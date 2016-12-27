/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.consistency.entity.util;

import java.io.InputStream;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.base.consistency.model.ConsistencyCheckResult;
import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.consistency.ConsistencyResultAttrName;
import com.comtop.cap.bm.metadata.consistency.entity.model.EntityBeingDependOnMapping;
import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cip.jodd.util.StringUtil;
import com.comtop.cip.json.util.IOUtils;

/**
 * 实体一致性校验工具类
 * 
 * @author 许畅
 * @since JDK1.6
 * @version 2016年6月28日 许畅 新建
 */
public final class EntityConsistencyUtil {

	/** 日志 */
	private final static Logger LOGGER = LoggerFactory.getLogger(EntityConsistencyUtil.class);
	
	/** 实体一致性校验xml映射 */
	private final static String ENTITY_CONSISTENCY_XML ="com/comtop/cap/bm/metadata/consistency/entity/EntityConsistencyMapping.xml";

	/**
	 * 构造方法
	 */
	private EntityConsistencyUtil() {

	}

	/**
	 * 校验当前实体被哪些实体依赖
	 * 
	 * @param entity
	 *            实体对象
	 * @return 被依赖的实体对象集合
	 */
	public static List<ConsistencyCheckResult> checkEntityBeingDependOn(EntityVO entity) {
		List<ConsistencyCheckResult> results = new ArrayList<ConsistencyCheckResult>();
		Map<Integer, String> expressionMapping = EntityBeingDependOnMapping.getExpressionmapping();

		try {
			Set<Integer> entityConsistencyCheckTypes = expressionMapping.keySet();

			for (Integer entityConsistencyCheckType : entityConsistencyCheckTypes) {
				// 解析XPATH表达式
				String expression = parsingExpression(expressionMapping.get(entityConsistencyCheckType),entity.getModelId());

				// 查询被依赖的实体集合
				List<EntityVO> beingDependOnEntitys = CacheOperator.queryList(expression, EntityVO.class);

				// 添加进一致性校验结果集
				addEntityConsistencyCheckResult(beingDependOnEntitys,results, entityConsistencyCheckType,entity.getModelId());
			}
		} catch (OperateException e) {
			LOGGER.error("查询实体被依赖校验出错:" + e.getMessage(), e);
		}

		return results;
	}
	
	/**
	 * 获取实体关系所关联的实体
	 * 
	 * @param entity
	 *            实体对象
	 * @return 关联实体集合
	 */
	public static List<EntityVO> getRelationEntity(EntityVO entity) {
		List<EntityVO> relationEntitys = new ArrayList<EntityVO>();
		Map<Integer, String> expressionMapping = EntityBeingDependOnMapping.getExpressionmapping();

		Integer[] entityConsistencyCheckTypes = {
				EntityConsistencyCheckType.ENTITY_RELATIONSHIP_ASSOSIATE_TYPE,
				EntityConsistencyCheckType.ENTITY_RELATIONSHIP_TARGET_TYPE };

		try {
			for (Integer entityConsistencyCheckType : entityConsistencyCheckTypes) {
				// 解析XPATH表达式
				String expression = parsingExpression(expressionMapping.get(entityConsistencyCheckType),entity.getModelId());

				// 查询被依赖的实体集合
				List<EntityVO> beingDependOnEntitys = CacheOperator.queryList(expression, EntityVO.class);
				relationEntitys.addAll(beingDependOnEntitys);
			}

		} catch (OperateException e) {
			LOGGER.error("查询实体被依赖校验出错:" + e.getMessage(), e);
		}

		return relationEntitys;
	}

	/**
	 * @param beingDependOnEntitys
	 *            被依赖的实体集合
	 * @param results
	 *            校验结果集
	 * @param entityConsistencyCheckType
	 *            实体校验类型
	 * @param modelId
	 *            来源实体id
	 */
	private static void addEntityConsistencyCheckResult(List<EntityVO> beingDependOnEntitys,List<ConsistencyCheckResult> results,
			int entityConsistencyCheckType, String modelId) {
		Map<Integer, String> messageMapping = EntityBeingDependOnMapping.getMessagemapping();
		Map<Integer, String> typeMapping = EntityBeingDependOnMapping.getTypemapping();
		
		for (EntityVO beingDependOnEntity : beingDependOnEntitys) {
			ConsistencyCheckResult consistencyCheckResult = new ConsistencyCheckResult();
			String message = parsingExpression(messageMapping.get(entityConsistencyCheckType), beingDependOnEntity.getModelId(), modelId);
			String type = typeMapping.get(entityConsistencyCheckType);
			
			consistencyCheckResult.setMessage(message);
			consistencyCheckResult.setType(type);
			Map<String,String> attrMap = new HashMap<String,String>();
			attrMap.put(ConsistencyResultAttrName.ENTITY_MODEL_ID.getValue(), beingDependOnEntity.getModelId());
			consistencyCheckResult.setAttrMap(attrMap);
			results.add(consistencyCheckResult);
		}

	}
	
	/**
	 * 将被依赖校验结果集转换为客户端所需要的结果集
	 * 
	 * @param results
	 *            校验结果集
	 * 
	 * @return 转换后的结果集
	 */
	public static Map<String, Object> convertToBeingDependOnClientResult(List<ConsistencyCheckResult> results) {
		Map<String, Object> objReult = new HashMap<String, Object>();

		if (results != null && !results.isEmpty()) {
			objReult.put("dependOnCurrent", results);
		}

		if (objReult.isEmpty()) {
			objReult.put("validateResult", true);
		} else {
			objReult.put("validateResult", false);
		}

		return objReult;
	}

	/**
	 * 解析表达式
	 * 
	 * @param expression
	 *            表达式
	 * @param params
	 *            参数数组
	 * @return 解析后的表达式
	 */
	public static String parsingExpression(String expression, String... params) {
		String parsingExpression = expression;
		for (int i = 0; i < params.length; i++) {
			parsingExpression = parsingExpression.replace("{" + i + "}",params[i]);
		}
		return parsingExpression;
	}

	/**
	 * dom4j解析实体一致性映射 xml: <br>
	 * com/comtop/cap/bm/metadata/consistency/entity/EntityConsistencyMapping.
	 * xml
	 */
	@SuppressWarnings("unchecked")
	public static void parsingConsistencyXML() {
		SAXReader reader = new SAXReader();
		InputStream in = null;
		try {
			in = Thread.currentThread().getContextClassLoader().getResourceAsStream(ENTITY_CONSISTENCY_XML);
			
			Document document = reader.read(in);
			Element root = document.getRootElement();
			Class<?> mappingKeyClass = Class.forName(root.elementText("mappingKeyClass"));
			
			List<Element> mappings= root.elements("mapping");
			for (Element mapping : mappings) {
				Class<?> mappingClass = Class.forName(mapping.attributeValue("class"));
				Map<Integer, String> messageMapping = 
						(Map<Integer, String>) mappingClass.getMethod("getMessagemapping").invoke(mappingClass);
				Map<Integer,String> typeMapping = 
						(Map<Integer, String>) mappingClass.getMethod("getTypemapping").invoke(mappingClass);
				Map<Integer, String> expressionMapping  = 
						(Map<Integer, String>) mappingClass.getMethod("getExpressionmapping").invoke(mappingClass);
				
				String[] elementNames = mapping.attributeValue("elementTypes").split(",");
				for (String name : elementNames) {
					List<Element> elements = mapping.elements(name);
					
					for (Element element : elements) {
						String elementKey = element.elementText("key");
						if (StringUtil.isEmpty(elementKey)) {
							continue;
						}
						Field field = mappingKeyClass.getField(elementKey);
						Integer key = (Integer) field.get(mappingKeyClass);
						String value = element.elementText("value");
						LOGGER.info("EntityConsistencyMapping.xml's key:" + key);
						LOGGER.info("EntityConsistencyMapping.xml's value:" + value);
						if ("message".equals(name)) {
							messageMapping.put(key, value);
						} else if ("type".equals(name)) {
							typeMapping.put(key, value);
						} else if ("expression".equals(name)) {
							expressionMapping.put(key, value);
						}
					}
				}
			}
		} catch (DocumentException e) {
			LOGGER.error("解析实体一致性EntityConsistencyMapping.xml出错:" + e.getMessage(),e);
		} catch (ClassNotFoundException e) {
			LOGGER.error("can not find class:" + e.getMessage(), e);
		} catch (SecurityException e) {
			LOGGER.error("can not find security:" + e.getMessage(), e);
		} catch (NoSuchFieldException e) {
			LOGGER.error("can not find Field:" + e.getMessage(), e);
		} catch (IllegalArgumentException e) {
			LOGGER.error("获取EntityConsistencyCheckType类属性失败:" + e.getMessage(),e);
		} catch (IllegalAccessException e) {
			LOGGER.error("获取EntityConsistencyCheckType类属性失败:" + e.getMessage(),e);
		} catch (NoSuchMethodException e) {
			LOGGER.error("找不到获取映射关系方法:" + e.getMessage(), e);
		} catch (InvocationTargetException e) {
			LOGGER.error("反射执行异常:" + e.getMessage(), e);
		} finally {
			IOUtils.close(in);
		}
	}
	
	/**
	 * @param args
	 *            测试验证
	 */
	public static void main(String[] args) {
		System.gc();
		long start = Runtime.getRuntime().freeMemory();
		parsingConsistencyXML();
		
        System.gc();		
		long end = Runtime.getRuntime().freeMemory();
		System.out.println("消耗内存:" + (start - end));

		String expression = "entity[attributes[attributeType/generic[value=\"{0}\"] ] and @modelId !=\"{0}\" ]";
		System.out.println("parsing...:" + MessageFormat.format(expression,"com.comtop.meeting.entity.Car"));
	}
	
}
