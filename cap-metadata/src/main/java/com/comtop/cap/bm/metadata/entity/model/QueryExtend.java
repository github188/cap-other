/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.entity.model;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 查询重写(重写CapWorkflow实体和CapBase实体方法)
 * 
 * @author 许畅
 * @since JDK1.6
 * @version 2016年6月2日 许畅 新建
 */
@DataTransferObject
public class QueryExtend extends BaseMetadata {

	/** 序列化版本号 */
	private static final long serialVersionUID = 1L;

	/** mybatis语法sql */
	private String mybatisSQL;

	/** 实际sql内容 */
	private String sql;

	/** 方法id */
	private String methodId;

	/** 方法名 */
	private String methodName;
	
	/** mybatis语法 select id */
	private String selectId;

	/**
	 * @return the mybatisSQL
	 */
	public String getMybatisSQL() {
		return mybatisSQL;
	}

	/**
	 * @param mybatisSQL
	 *            the mybatisSQL to set
	 */
	public void setMybatisSQL(String mybatisSQL) {
		this.mybatisSQL = mybatisSQL;
	}

	/**
	 * @return the sql
	 */
	public String getSql() {
		return sql;
	}

	/**
	 * @param sql
	 *            the sql to set
	 */
	public void setSql(String sql) {
		this.sql = sql;
	}

	/**
	 * @return the methodId
	 */
	public String getMethodId() {
		return methodId;
	}

	/**
	 * @param methodId
	 *            the methodId to set
	 */
	public void setMethodId(String methodId) {
		this.methodId = methodId;
	}

	/**
	 * @return the methodName
	 */
	public String getMethodName() {
		return methodName;
	}

	/**
	 * @param methodName
	 *            the methodName to set
	 */
	public void setMethodName(String methodName) {
		this.methodName = methodName;
	}

	/**
	 * @return the selectId
	 */
	public String getSelectId() {
		return selectId;
	}

	/**
	 * @param selectId the selectId to set
	 */
	public void setSelectId(String selectId) {
		this.selectId = selectId;
	}
}
