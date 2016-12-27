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
 * 实体被页面所依赖映射
 * 
 * @author 许畅
 * @since JDK1.6
 * @version 2016年7月7日 许畅 新建
 */
public final class EntityBeingPageDependOnMapping {

	/**
	 * 构造方法
	 */
	private EntityBeingPageDependOnMapping() {

	}

	/** 一致性校验消息提示映射关系 */
	private final static Map<Integer, String> messageMapping = new HashMap<Integer, String>();

	/** 一致性校验类型映射关系 */
	private final static Map<Integer, String> typeMapping = new HashMap<Integer, String>();

	/** 一致性校验XPATH表达式映射关系 */
	private final static Map<Integer, String> expressionMapping = new HashMap<Integer, String>();
	
	static {
		// 读取实体一致性xml文件
		if (messageMapping.isEmpty())
			EntityConsistencyUtil.parsingConsistencyXML();
	}

	/** 初始化映射关系(此初始化方法暂时没用,目前的数据初始化都在xml中初始化) */
	public static void initMapping() {
		messageMapping.put(EntityConsistencyCheckType.PAGE_DATA_STORE_TYPE, "当前实体被页面【%s-%s】所依赖");
		
		typeMapping.put(EntityConsistencyCheckType.PAGE_DATA_STORE_TYPE, ConsistencyCheckResultType.CONSISTENCY_TYPE_PAGE_DATASTORE.getValue());
		
		expressionMapping.put(EntityConsistencyCheckType.PAGE_DATA_STORE_TYPE, "page[dataStoreVOList[entityId='%s']]");
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
