/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.consistency.entity.model;

import java.util.HashMap;
import java.util.Map;

import com.comtop.cap.bm.metadata.consistency.ConsistencyCheckResultType;
import com.comtop.cap.bm.metadata.consistency.entity.util.EntityConsistencyCheckType;
import com.comtop.cap.bm.metadata.consistency.entity.util.EntityConsistencyUtil;

/**
 * 实体被实体属性,方法,关系,自身依赖映射
 * 
 * @author 许畅
 * @since JDK1.6
 * @version 2016年7月8日 许畅 新建
 */
public final class EntityBeingDependOnMapping {

	/**
	 * 构造方法
	 */
	private EntityBeingDependOnMapping() {

	}
	
	/** 一致性校验消息提示映射关系 */
	private final static Map<Integer,String> messageMapping = new HashMap<Integer,String>();
	
	/** 一致性校验类型映射关系 */
	private final static Map<Integer,String> typeMapping = new HashMap<Integer,String>();
	
	/** 一致性校验XPATH表达式映射关系 */
	private final static Map<Integer,String> expressionMapping = new HashMap<Integer,String>();
	
	static {
		// 读取实体一致性xml文件
		if (messageMapping.isEmpty())
			EntityConsistencyUtil.parsingConsistencyXML();
	}

	/** 初始化映射关系 (此初始化方法暂时没用,目前的数据初始化都在xml中初始化) */
	public static void initMapping(){
		messageMapping.put(EntityConsistencyCheckType.ENTITY_METHOD_PARAMETER_ENTITY_TYPE, "实体{0}中方法所对应的实体类型参数依赖当前实体{1}");
		messageMapping.put(EntityConsistencyCheckType.ENTITY_METHOD_PARAMETER_GENERIC_TYPE, "实体{0}中方法所对应的泛型实体类型参数依赖当前实体{1}");
		messageMapping.put(EntityConsistencyCheckType.ENTITY_METHOD_RETURN_ENTITY_TYPE, "实体{0}中方法所对应的实体类型返回值依赖当前实体{1}");
		messageMapping.put(EntityConsistencyCheckType.ENTITY_METHOD_RETURN_GENERIC_TYPE, "实体{0}中方法所对应的泛型实体类型返回值依赖当前实体{1}");
		messageMapping.put(EntityConsistencyCheckType.ENTITY_RELATIONSHIP_ASSOSIATE_TYPE, "实体{0}中关系所对应的多对多中间实体依赖当前实体{1}");
		messageMapping.put(EntityConsistencyCheckType.ENTITY_RELATIONSHIP_TARGET_TYPE, "实体{0}中关系所对应的目标实体依赖当前实体{1}");
		messageMapping.put(EntityConsistencyCheckType.ENTITY_ATTRIBUTE_ENTITY_TYPE, "实体{0}中属性所关联的实体依赖当前实体{1}");
		messageMapping.put(EntityConsistencyCheckType.ENTITY_ATTRIBUTE_GENERIC_TYPE, "实体{0}中属性所关联的泛型实体依赖当前实体{1}");
		messageMapping.put(EntityConsistencyCheckType.ENTITY_PARENT_ENTITY_TYPE, "实体{0}中父实体依赖当前实体{1}");
		
		typeMapping.put(EntityConsistencyCheckType.ENTITY_METHOD_PARAMETER_ENTITY_TYPE, ConsistencyCheckResultType.CONSISTENCY_TYPE_ENTITY_METHOD.getValue());
		typeMapping.put(EntityConsistencyCheckType.ENTITY_METHOD_PARAMETER_GENERIC_TYPE, ConsistencyCheckResultType.CONSISTENCY_TYPE_ENTITY_METHOD.getValue());
		typeMapping.put(EntityConsistencyCheckType.ENTITY_METHOD_RETURN_ENTITY_TYPE, ConsistencyCheckResultType.CONSISTENCY_TYPE_ENTITY_METHOD.getValue());
		typeMapping.put(EntityConsistencyCheckType.ENTITY_METHOD_RETURN_GENERIC_TYPE, ConsistencyCheckResultType.CONSISTENCY_TYPE_ENTITY_METHOD.getValue());
		typeMapping.put(EntityConsistencyCheckType.ENTITY_RELATIONSHIP_ASSOSIATE_TYPE, ConsistencyCheckResultType.CONSISTENCY_TYPE_ENTITY_RELATION.getValue());
		typeMapping.put(EntityConsistencyCheckType.ENTITY_RELATIONSHIP_TARGET_TYPE, ConsistencyCheckResultType.CONSISTENCY_TYPE_ENTITY_RELATION.getValue());
		typeMapping.put(EntityConsistencyCheckType.ENTITY_ATTRIBUTE_ENTITY_TYPE, ConsistencyCheckResultType.CONSISTENCY_TYPE_ENTITY_ATTRIBUTE.getValue());
		typeMapping.put(EntityConsistencyCheckType.ENTITY_ATTRIBUTE_GENERIC_TYPE, ConsistencyCheckResultType.CONSISTENCY_TYPE_ENTITY_ATTRIBUTE.getValue());
		typeMapping.put(EntityConsistencyCheckType.ENTITY_PARENT_ENTITY_TYPE, ConsistencyCheckResultType.CONSISTENCY_TYPE_ENTITY_BASEINFO.getValue());
		
		expressionMapping.put(EntityConsistencyCheckType.ENTITY_METHOD_PARAMETER_ENTITY_TYPE, "entity[methods[parameters[dataType/value='{0}']] and @modelId !='{0}']");
		expressionMapping.put(EntityConsistencyCheckType.ENTITY_METHOD_PARAMETER_GENERIC_TYPE, "entity[methods[parameters[dataType//generic[value='{0}'] ]] and @modelId !='{0}']");
		expressionMapping.put(EntityConsistencyCheckType.ENTITY_METHOD_RETURN_ENTITY_TYPE, "entity[methods[returnType/value='{0}'] and @modelId !='{0}']");
		expressionMapping.put(EntityConsistencyCheckType.ENTITY_METHOD_RETURN_GENERIC_TYPE, "entity[methods[returnType//generic[value='{0}']] and @modelId !='{0}' ]");
		expressionMapping.put(EntityConsistencyCheckType.ENTITY_RELATIONSHIP_ASSOSIATE_TYPE, "entity[lstRelation[associateEntityId='{0}'] and @modelId !='{0}' ]");
		expressionMapping.put(EntityConsistencyCheckType.ENTITY_RELATIONSHIP_TARGET_TYPE, "entity[lstRelation[targetEntityId='{0}'] and @modelId !='{0}' ]");
		expressionMapping.put(EntityConsistencyCheckType.ENTITY_ATTRIBUTE_ENTITY_TYPE, "entity[attributes[attributeType[contains(value,'{0}')]] and @modelId !='{0}' ]");
		expressionMapping.put(EntityConsistencyCheckType.ENTITY_ATTRIBUTE_GENERIC_TYPE, "entity[attributes[attributeType/generic[value='{0}'] ] and @modelId !='{0}' ]");
		expressionMapping.put(EntityConsistencyCheckType.ENTITY_PARENT_ENTITY_TYPE, "entity[parentEntityId='{0}' and @modelId !='{0}']");
	}

	/**
	 * @return the messagemapping
	 */
	public static Map<Integer, String> getMessagemapping() {
		return messageMapping;
	}

	/**
	 * @return the typemapping
	 */
	public static Map<Integer, String> getTypemapping() {
		return typeMapping;
	}

	/**
	 * @return the expressionmapping
	 */
	public static Map<Integer, String> getExpressionmapping() {
		return expressionMapping;
	}
}
