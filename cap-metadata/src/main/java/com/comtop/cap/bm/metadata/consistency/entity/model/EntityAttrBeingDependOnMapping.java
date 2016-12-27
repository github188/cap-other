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
 * 实体属性被依赖映射类
 * 
 * @author 许畅
 * @since JDK1.6
 * @version 2016年7月1日 许畅 新建
 */
public final class EntityAttrBeingDependOnMapping {
	
	/**
	 * 构造方法
	 */
	private EntityAttrBeingDependOnMapping(){
		
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
		
		messageMapping.put(EntityConsistencyCheckType.ENTITY_RELATIONSHIP_TARGET_FIELD, "当前实体属性{0}被实体{1}的关系目标实体属性所依赖");
		messageMapping.put(EntityConsistencyCheckType.ENTITY_RELATIONSHIP_ASSOCIATION_FIELD, "当前实体属性{0}被实体{1}的关系中间实体源属性所依赖");
		
		typeMapping.put(EntityConsistencyCheckType.ENTITY_RELATIONSHIP_TARGET_FIELD,ConsistencyCheckResultType.CONSISTENCY_TYPE_ENTITY_RELATION.getValue() );
		typeMapping.put(EntityConsistencyCheckType.ENTITY_RELATIONSHIP_ASSOCIATION_FIELD,ConsistencyCheckResultType.CONSISTENCY_TYPE_ENTITY_RELATION.getValue() );
		
		expressionMapping.put(EntityConsistencyCheckType.ENTITY_RELATIONSHIP_TARGET_FIELD, "entity[lstRelation[targetField='{0}'] and @modelId !='{1}' ]");
		expressionMapping.put(EntityConsistencyCheckType.ENTITY_RELATIONSHIP_ASSOCIATION_FIELD, "entity[lstRelation[associateSourceField='{0}'] and @modelId !='{1}' ]");
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
