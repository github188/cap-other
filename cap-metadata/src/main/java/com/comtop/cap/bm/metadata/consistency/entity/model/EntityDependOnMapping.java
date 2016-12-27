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
 * 实体所依赖的属性映射类
 * 
 * @author 许畅
 * @since JDK1.6
 * @version 2016年7月1日 许畅 新建
 */
public final class EntityDependOnMapping {

	/**
	 * 构造方法
	 */
	private EntityDependOnMapping() {

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
	public static void initMapping() {

		messageMapping.put(EntityConsistencyCheckType.ENTITY_PARENT_ENTITY_TYPE, "当前实体{0}对应的父实体{1}不存在.");
		messageMapping.put(EntityConsistencyCheckType.ENTITY_PROCESS_TYPE, "当前实体{0}对应的工作流流程{1}不存在.");
		messageMapping.put(EntityConsistencyCheckType.ENTITY_TABLE_TYPE, "当前实体{0}对应的数据库表{1}不存在.");
		messageMapping.put(EntityConsistencyCheckType.ENTITY_ATTRIBUTE_RELATION_TYPE, "当前实体属性{0}所关联的目标实体{1}不存在.");
		messageMapping.put(EntityConsistencyCheckType.ENTITY_ATTRIBUTE_ENUM_TYPE,"当前实体属性{0}所关联的枚举类{1}不存在." );
		messageMapping.put(EntityConsistencyCheckType.ENTITY_METHOD_RETURN_TYPE, "当前实体方法名{0}的返回值所关联的实体{1}不存在.");
		messageMapping.put(EntityConsistencyCheckType.ENTITY_METHOD_PARAMETER_TYPE, "当前实体方法名{0}的参数所关联的实体{1}不存在.");
		messageMapping.put(EntityConsistencyCheckType.ENTITY_METHOD_CASCADE_TYPE,"当前实体方法名{0}的级联属性所关联的实体{1}不存在." );
		messageMapping.put(EntityConsistencyCheckType.ENTITY_RELATIONSHIP_TYPE, "当前实体关系{0}的所关联的目标实体{1}不存在.");
		
		typeMapping.put(EntityConsistencyCheckType.ENTITY_PARENT_ENTITY_TYPE, ConsistencyCheckResultType.CONSISTENCY_TYPE_ENTITY_BASEINFO.getValue());
		typeMapping.put(EntityConsistencyCheckType.ENTITY_PROCESS_TYPE, ConsistencyCheckResultType.CONSISTENCY_TYPE_ENTITY_BASEINFO.getValue());
		typeMapping.put(EntityConsistencyCheckType.ENTITY_TABLE_TYPE, ConsistencyCheckResultType.CONSISTENCY_TYPE_ENTITY_BASEINFO.getValue());
		typeMapping.put(EntityConsistencyCheckType.ENTITY_ATTRIBUTE_RELATION_TYPE, ConsistencyCheckResultType.CONSISTENCY_TYPE_ENTITY_ATTRIBUTE.getValue());
		typeMapping.put(EntityConsistencyCheckType.ENTITY_ATTRIBUTE_ENUM_TYPE,ConsistencyCheckResultType.CONSISTENCY_TYPE_ENTITY_ATTRIBUTE.getValue() );
		typeMapping.put(EntityConsistencyCheckType.ENTITY_METHOD_RETURN_TYPE, ConsistencyCheckResultType.CONSISTENCY_TYPE_ENTITY_METHOD.getValue());
		typeMapping.put(EntityConsistencyCheckType.ENTITY_METHOD_PARAMETER_TYPE,ConsistencyCheckResultType.CONSISTENCY_TYPE_ENTITY_METHOD.getValue() );
		typeMapping.put(EntityConsistencyCheckType.ENTITY_METHOD_CASCADE_TYPE,ConsistencyCheckResultType.CONSISTENCY_TYPE_ENTITY_METHOD.getValue() );
		typeMapping.put(EntityConsistencyCheckType.ENTITY_RELATIONSHIP_TYPE,ConsistencyCheckResultType.CONSISTENCY_TYPE_ENTITY_RELATION.getValue() );
	
	}
	
	/**
	 * @return the messagemapping 消息映射关系
	 */
	public static Map<Integer,String> getMessagemapping() {
		return messageMapping;
	}

	/**
	 * @return the typemapping 类型映射
	 */
	public static Map<Integer,String> getTypemapping() {
		return typeMapping;
	}

	/**
	 * @return the expressionmapping 表达式映射
	 */
	public static Map<Integer,String> getExpressionmapping() {
		return expressionMapping;
	}

}
