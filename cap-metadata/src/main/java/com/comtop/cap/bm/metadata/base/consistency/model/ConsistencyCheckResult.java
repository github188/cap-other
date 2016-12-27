/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.base.consistency.model;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 一致性校验结果
 * 
 * @author 罗珍明
 *
 */
@DataTransferObject
public class ConsistencyCheckResult implements Serializable {
	
	/**检验对象信息组成的唯一Id*/
	private String id = UUID.randomUUID().toString();
	
	/**校验信息*/
	private String message;
	
	/**校验对象跳转页面的类型*/
	private String type;
	
	/**校验对象扩展信息*/
	private Map<String,String> attrMap;

	/**
	 * @return the id
	 */
	public String getId() {
		return id;
	}

	/**
	 * @param id the id to set
	 */
	public void setId(String id) {
		this.id = id;
	}

	/**
	 * @return the message
	 */
	public String getMessage() {
		return message;
	}

	/**
	 * @param message the message to set
	 */
	public void setMessage(String message) {
		this.message = message;
	}

	/**
	 * @return the type
	 */
	public String getType() {
		return type;
	}

	/**
	 * @param type the type to set
	 */
	public void setType(String type) {
		this.type = type;
	}

	/**
	 * @return the attrMap
	 */
	public Map<String, String> getAttrMap() {
		return attrMap;
	}

	/**
	 * @param attrMap the attrMap to set
	 */
	public void setAttrMap(Map<String, String> attrMap) {
		this.attrMap = attrMap;
	}
	
	/**
	 * 添加参数
	 * @param attrName 参数名称
	 * @param attrValue 参数值
	 */
	public void addAttr(String attrName,String attrValue){
		if(this.attrMap == null){
			this.attrMap = new HashMap<String, String>();
		}
		this.attrMap.put(attrName, attrValue);
	}

}
