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

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import comtop.org.directwebremoting.extend.AbstractCreator;

/**
 * A creator that simply uses the default constructor each time it is called.
 * @author Joe Walker [joe at getahead dot ltd dot uk]
 */
public class CapMapCreator extends AbstractCreator {
	
	/** 日志 */
    private final static Logger LOG = LoggerFactory.getLogger(CapMapCreator.class);

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.directwebremoting.Creator#getType()
	 */
	@Override
	public Class<?> getType() {
		return CapMap.class;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.directwebremoting.Creator#getInstance()
	 */
	@Override
	public Object getInstance() throws InstantiationException {
		try {
			return CapMap.class.newInstance();
		} catch (IllegalAccessException ex) {
			LOG.debug("error", ex);
			throw new InstantiationException("Illegal Access to default constructor on " + CapMap.class.getName());
		}
	}
}
