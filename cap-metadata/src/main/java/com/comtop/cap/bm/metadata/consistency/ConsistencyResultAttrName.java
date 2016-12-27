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
public enum ConsistencyResultAttrName {
	
	/***/
	PAGE_LAYOUT_ATTRNAME_COMPONENT_PRO_DATABIND("databind"),
	/***/
	PAGE_LAYOUT_ATTRNAME_COMPONENT_PRO("componentProperty"),
	/***/
	PAGE_LAYOUT_ATTRNAME_PK("layoutId"),
	/***/
	PAGE_ACTION_ATTRNAME_ACTION_PRO("actionProperty"),
	/***/
	PAGE_ACTION_ATTRNAME_PK("pageActionId"),
	/***/
	PAGE_ATTRNAME_PK("modelId"),
	
	/** 实体modelId */
	ENTITY_MODEL_ID("modelId"),
	
	/** 实体属性key */
	ENTITY_ATTRIBUTE_KEY("attribute"),
	
	/***/
	PAGE_DATASTORE_ATTRNAME_ENAME("ename"),
	
	/***/
	PAGE_DATASTORE_ATTRNAME_ENAME_VALUE_CONSTANTS("pageConstantList"),
	
	/***/
	PAGE_DATASTORE_ATTRNAME_ENTITY("entityId"),
	
	/***/
	PAGE_DATASTORE_ATTRNAME_PAGECONSTANT_CONSTANTNAME("constantName");
	
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
	private ConsistencyResultAttrName(String value){
		this.value = value;
	}

}
