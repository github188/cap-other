/*
 * Copyright 2005 Joe Walker
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.comtop.cap.bm.metadata.common.dwr;

import java.lang.reflect.Modifier;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;
import java.util.StringTokenizer;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import comtop.org.directwebremoting.ConversionException;
import comtop.org.directwebremoting.extend.ConvertUtil;
import comtop.org.directwebremoting.extend.Converter;
import comtop.org.directwebremoting.extend.ConverterManager;
import comtop.org.directwebremoting.extend.InboundContext;
import comtop.org.directwebremoting.extend.InboundVariable;
import comtop.org.directwebremoting.extend.ObjectOutboundVariable;
import comtop.org.directwebremoting.extend.OutboundContext;
import comtop.org.directwebremoting.extend.OutboundVariable;
import comtop.org.directwebremoting.extend.Property;
import comtop.org.directwebremoting.extend.ProtocolConstants;
import comtop.org.directwebremoting.util.JavascriptUtil;
import comtop.org.directwebremoting.util.LocalUtil;

/**
 * An implementation of Converter for Maps.
 * @author Joe Walker [joe at getahead dot ltd dot uk]
 */
public class CapMapConverter implements Converter {
	/* (non-Javadoc)
	 * @see org.directwebremoting.Converter#setConverterManager(org.directwebremoting.ConverterManager)
	 */
	@Override
	public void setConverterManager(ConverterManager converterManager) {
		this.converterManager = converterManager;
	}

	/* (non-Javadoc)
	 * @see org.directwebremoting.Converter#convertInbound(java.lang.Class, org.directwebremoting.InboundVariable, org.directwebremoting.InboundContext)
	 */
	@Override
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public Object convertInbound(Class<?> paramType, InboundVariable data) throws ConversionException {
		if (data.isNull()) {
			return null;
		}

		String value = data.getValue();

		// If the text is null then the whole bean is null
		if (value.trim().equals(ProtocolConstants.INBOUND_NULL)) {
			return null;
		}

		if (!value.startsWith(ProtocolConstants.INBOUND_MAP_START)
						|| !value.endsWith(ProtocolConstants.INBOUND_MAP_END)) {
			log.warn("Expected object while converting data for " + paramType.getName() + " in "
							+ data.getContext().getCurrentProperty() + ". Passed: " + value);
			throw new ConversionException(paramType, "Data conversion error. See logs for more details.");
		}

		value = value.substring(1, value.length() - 1);

		try {
			// Maybe we ought to check that the paramType isn't expecting a more
			// distinct type of Map and attempt to create that?
			Map<Object, Object> map;

			// If paramType is concrete then just use whatever we've got.
			if (!paramType.isInterface() && !Modifier.isAbstract(paramType.getModifiers())) {
				// If there is a problem creating the type then we have no way
				// of completing this - they asked for a specific type and we
				// can't create that type. I don't know of a way of finding
				// subclasses that might be instaniable so we accept failure.
				map = (Map<Object, Object>) paramType.newInstance();
			} else {
				map = new HashMap<Object, Object>();
			}

			// Get the extra type info
			Property parent = data.getContext().getCurrentProperty();

			Property keyProp = parent.createChild(0);
			keyProp = converterManager.checkOverride(keyProp);

			Property valProp = parent.createChild(1);
			valProp = converterManager.checkOverride(valProp);

			// We should put the new object into the working map in case it
			// is referenced later nested down in the conversion process.
			data.getContext().addConverted(data, paramType, map);
			InboundContext incx = data.getContext();

			// Loop through the property declarations
			StringTokenizer st = new StringTokenizer(value, ",");
			int size = st.countTokens();
			for (int i = 0; i < size; i++) {
				String token = st.nextToken();
				if (token.trim().length() == 0) {
					continue;
				}

				int colonpos = token.indexOf(ProtocolConstants.INBOUND_MAP_ENTRY);
				if (colonpos == -1) {
					throw new ConversionException(paramType, "Missing " + ProtocolConstants.INBOUND_MAP_ENTRY
									+ " in object description: {1}" + token);
				}

				String valStr = token.substring(colonpos + 1).trim();
				String[] splitIv = ConvertUtil.splitInbound(valStr);
				String splitIvValue = splitIv[ConvertUtil.INBOUND_INDEX_VALUE];
				String splitIvType = splitIv[ConvertUtil.INBOUND_INDEX_TYPE];
				InboundVariable valIv = new InboundVariable(incx, null, splitIvType, splitIvValue);
				valIv.dereference();

				Class valTyClass = String.class;

				if ("boolean".equals(valIv.getType())) {
					valTyClass = Boolean.class;
				} else if ("array".equals(valIv.getType())) {
					valTyClass = ArrayList.class;
				} else if ("number".equals(valIv.getType())) {
					String strValue = valIv.getValue();
					if (strValue.indexOf(".") != -1) {
						valTyClass = Double.class;
					} else {
						valTyClass = Integer.class;
					}
				} else if ("date".equals(valIv.getType())) {
					valTyClass = Date.class;
				}

				Object val = converterManager.convertInbound(valTyClass, valIv, valProp);
				String keyStr = token.substring(0, colonpos).trim();
				map.put(keyStr, val);
			}

			return map;
		} catch (ConversionException ex) {
			throw ex;
		} catch (Exception ex) {
			throw new ConversionException(paramType, ex);
		}
	}

	/* (non-Javadoc)
	 * @see org.directwebremoting.Converter#convertOutbound(java.lang.Object, org.directwebremoting.OutboundContext)
	 */
	@Override
	@SuppressWarnings("unchecked")
	public OutboundVariable convertOutbound(Object data, OutboundContext outctx) throws ConversionException {
		// First we just collect our converted children
		//noinspection unchecked
		Map<String, OutboundVariable> ovs = LocalUtil.classNewInstance("OrderedConvertOutbound",
						"java.util.LinkedHashMap", Map.class);
		if (ovs == null) {
			ovs = new HashMap<String, OutboundVariable>();
		}

		ObjectOutboundVariable ov = new ObjectOutboundVariable(outctx);
		outctx.put(data, ov);

		// Loop through the map outputting any init code and collecting
		// converted outbound variables into the ovs map
		Map<Object, Object> map = (Map<Object, Object>) data;
		for (Entry<Object, Object> entry : map.entrySet()) {
			Object key = entry.getKey();
			Object value = entry.getValue();

			// If the key is null, retrieve the configured null key value from the configuration of this converter.
			if (null == key && null != nullKey) {
				log.debug("MapConverter: A null key was encountered DWR is using the configured nullKey string: "
								+ nullKey);
				key = nullKey;
			}

			// It would be nice to check for Enums here
			if (!(key instanceof String) && !sentNonStringWarning && key != null) {
				log.warn("--Javascript does not support non string keys. Converting '" + key.getClass().getName()
								+ "' using toString()");
				sentNonStringWarning = true;
			}

			String outkey = JavascriptUtil.escapeJavaScript(key != null ? key.toString() : null);

			/*
			OutboundVariable ovkey = converterManager.convertOutbound(key, outctx);
			buffer.append(ovkey.getInitCode());
			outkey = ovkey.getAssignCode();
			 */

			OutboundVariable nested = converterManager.convertOutbound(value, outctx);

			ovs.put(outkey, nested);
		}

		ov.setChildren(ovs);

		return ov;
	}

	/**
	 * @return the nullKey
	 */
	public String getNullKey() {
		return nullKey;
	}

	/**
	 * @param nullKey the nullKey to set
	 */
	public void setNullKey(String nullKey) {
		this.nullKey = nullKey;
	}

	/**
	 * We don't want to give the non-string warning too many times.
	 */
	private static boolean sentNonStringWarning = false;

	/**
	 * To forward marshalling requests
	 */
	private ConverterManager converterManager = null;

	/**
	 * Used by DWR if a null key is encountered.  Configure in the init section when the map converter is declared.
	 * <converter id="map" class="org.directwebremoting.convert.MapConverter">
	 *     <param name="nullKey" value="null" />
	 * </converter>
	 */
	private String nullKey = null;

	/**
	 * The log stream
	 */
	private static final Log log = LogFactory.getLog(CapMapConverter.class);
}
