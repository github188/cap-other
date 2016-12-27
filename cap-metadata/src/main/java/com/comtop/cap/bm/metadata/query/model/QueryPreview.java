/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.query.model;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * SQL预览VO对象
 * 
 * @author 许畅
 * @since JDK1.6
 * @version 2016年6月13日 许畅 新建
 */
@DataTransferObject
public class QueryPreview extends BaseMetadata {

	/** SQL内容 */
	private String sql;

	/** MYBATIS 命名空间 */
	private String namespace;

	/** MYBATIS statementId */
	private String statementId;

	/** 用户自定义参数(以JSON格式传参) */
	private String params;

	/** 方法名称 */
	private String methodName;

	/** 实体名称 */
	private String entityName;

	/** 实体对象 */
	private String modelId;

	/**
	 * @return the sql 实际SQL内容
	 */
	public String getSql() {
		return sql;
	}

	/**
	 * @param sql
	 *            the sql to set 实际SQL内容
	 */
	public void setSql(String sql) {
		this.sql = sql;
	}

	/**
	 * @return the params 用户自定义参数(以JSON格式传参)
	 */
	public String getParams() {
		return params;
	}

	/**
	 * @param params
	 *            the params to set 用户自定义参数(以JSON格式传参)
	 */
	public void setParams(String params) {
		this.params = params;
	}

	/**
	 * @return the namespace MYBATIS 命名空间
	 */
	public String getNamespace() {
		return namespace;
	}

	/**
	 * @param namespace
	 *            the namespace to set MYBATIS 命名空间
	 */
	public void setNamespace(String namespace) {
		this.namespace = namespace;
	}

	/**
	 * @return the statementId MYBATIS statementId
	 */
	public String getStatementId() {
		return statementId;
	}

	/**
	 * @param statementId
	 *            the statementId to set MYBATIS statementId
	 */
	public void setStatementId(String statementId) {
		this.statementId = statementId;
	}

	/**
	 * @return the methodName 方法名称
	 */
	public String getMethodName() {
		return methodName;
	}

	/**
	 * @param methodName
	 *            the methodName to set 方法名称
	 */
	public void setMethodName(String methodName) {
		this.methodName = methodName;
	}

	/**
	 * @return the entityName
	 */
	public String getEntityName() {
		return entityName;
	}

	/**
	 * @param entityName
	 *            the entityName to set
	 */
	public void setEntityName(String entityName) {
		this.entityName = entityName;
	}

	/**
	 * @return the modelId
	 */
	public String getModelId() {
		return modelId;
	}

	/**
	 * @param modelId
	 *            the modelId to set
	 */
	public void setModelId(String modelId) {
		this.modelId = modelId;
	}

}
