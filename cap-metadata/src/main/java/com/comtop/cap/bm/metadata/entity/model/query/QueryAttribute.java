/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.entity.model.query;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 查询建模属性(包括列名称,列别名,表名称,表别名)
 * 
 * @author 许畅
 * @since JDK1.6
 * @version 2016年7月25日 许畅 新建
 */
@DataTransferObject
public class QueryAttribute extends BaseMetadata {

	/** 序列化版本号 */
	private static final long serialVersionUID = 1L;

	/** 列名称 */
	private String columnName;

	/** 列别名 */
	private String columnAlias;

	/** 表别名 */
	private String tableAlias;

	/** 表名称 */
	private String tableName;

	/** 表对应的实体id */
	private String entityId;

	/** sql脚本(可以自定义一些函数和特殊脚本语法) */
	private String sqlScript;

	/** 子查询id(用来区分是否子查询) */
	private String subQueryId;

	/** 实体属性英文名(冗余供select展现) */
	private String engName;

	/** 实体属性中文名(冗余供select展现) */
	private String chName;

	/**
	 * @return the columnName 列名称
	 */
	public String getColumnName() {
		return columnName;
	}

	/**
	 * @param columnName
	 *            the columnName to set 列名称
	 */
	public void setColumnName(String columnName) {
		this.columnName = columnName;
	}

	/**
	 * @return the columnAlias 列别名
	 */
	public String getColumnAlias() {
		return columnAlias;
	}

	/**
	 * @param columnAlias
	 *            the columnAlias to set 列别名
	 */
	public void setColumnAlias(String columnAlias) {
		this.columnAlias = columnAlias;
	}

	/**
	 * @return the tableAlias 表别名
	 */
	public String getTableAlias() {
		return tableAlias;
	}

	/**
	 * @param tableAlias
	 *            the tableAlias to set 表别名
	 */
	public void setTableAlias(String tableAlias) {
		this.tableAlias = tableAlias;
	}

	/**
	 * @return the tableName
	 */
	public String getTableName() {
		return tableName;
	}

	/**
	 * @param tableName
	 *            the tableName to set
	 */
	public void setTableName(String tableName) {
		this.tableName = tableName;
	}

	/**
	 * @return the sqlScript 特殊sql函数脚本
	 */
	public String getSqlScript() {
		return sqlScript;
	}

	/**
	 * @param sqlScript
	 *            the sqlScript to set 特殊sql函数脚本
	 */
	public void setSqlScript(String sqlScript) {
		this.sqlScript = sqlScript;
	}

	/**
	 * @return the entityId 表对应的实体id
	 */
	public String getEntityId() {
		return entityId;
	}

	/**
	 * @param entityId
	 *            the entityId to set 表对应的实体id
	 */
	public void setEntityId(String entityId) {
		this.entityId = entityId;
	}

	/**
	 * @return the subQueryId 子查询id
	 */
	public String getSubQueryId() {
		return subQueryId;
	}

	/**
	 * @param subQueryId
	 *            the subQueryId to set 子查询id
	 */
	public void setSubQueryId(String subQueryId) {
		this.subQueryId = subQueryId;
	}

	/**
	 * @return the engName 实体属性英文名
	 */
	public String getEngName() {
		return engName;
	}

	/**
	 * @param engName
	 *            the engName to set 实体属性英文名
	 */
	public void setEngName(String engName) {
		this.engName = engName;
	}

	/**
	 * @return the chName 实体属性中文名
	 */
	public String getChName() {
		return chName;
	}

	/**
	 * @param chName
	 *            the chName to set 实体属性中文名
	 */
	public void setChName(String chName) {
		this.chName = chName;
	}

}
