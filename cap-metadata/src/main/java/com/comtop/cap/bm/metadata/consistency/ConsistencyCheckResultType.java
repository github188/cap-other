/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.consistency;

/**
 * 一致性校验结果类
 * 
 * @author 罗珍明
 *
 */
public enum ConsistencyCheckResultType {
	
	/***/
	CONSISTENCY_TYPE_PAGE_BASEINFO("pageBaseInfo"),
	
	/***/
	CONSISTENCY_TYPE_PAGE_LAYOUT("pageLayout"),
	
	/***/
	CONSISTENCY_TYPE_PAGE_DATASTORE("pageDataStore"),
	
	/***/
	CONSISTENCY_TYPE_PAGE_RIGHT("pageRight"),
	
	/***/
	CONSISTENCY_TYPE_PAGE_ACTION("pageAction"),
	
	/** 实体对象校验类型 */
	CONSISTENCY_TYPE_ENTITY_BASEINFO("entityBaseInfo"),
	
	/** 实体方法校验类型 */
	CONSISTENCY_TYPE_ENTITY_METHOD("entityMethod"),
	
	/** 实体属性校验类型 */
	CONSISTENCY_TYPE_ENTITY_ATTRIBUTE("entityAttribute"),
	
	/** 实体关系校验类型 */
	CONSISTENCY_TYPE_ENTITY_RELATION("entityRelation");
	
	/**枚举值*/
	private String value;
	
	/**
	 * @return the value
	 */
	public String getValue() {
		return value;
	}

	/**
	 * @param value 枚举值
	 * 
	 */
	private ConsistencyCheckResultType(String value){
		this.value = value;
	}

}
