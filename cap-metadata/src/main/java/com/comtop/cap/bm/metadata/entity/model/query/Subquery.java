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
 * 子查询信息
 * 
 * @author 许畅
 * @since JDK1.6
 * @version 2016年7月25日 许畅 新建
 */
@DataTransferObject
public class Subquery extends BaseMetadata {

	/** 序列化版本号 */
	private static final long serialVersionUID = 1L;

	/** 子表名 */
	private String subTableName;

	/** 子表别名 */
	private String subTableAlias;

	/** 子表对应的实体id */
	private String entityId;

	/** 子查询连接方式 {@link com.comtop.cap.bm.metadata.entity.model.query.JoinType} */
	private String joinType = JoinType.LEFT_JOIN.getValue();

	/** on条件的左边 */
	private QueryAttribute onLeft;

	/** on条件的右边 */
	private QueryAttribute onRight;

	/** 关联QueryModel作为子查询数据集 */
	private QueryModel refQueryModel;

	/** 子查询id */
	private String subQueryId;

	/** 备注 */
	private String remark;

	/** 序号 */
	private int sortNo;

	/**
	 * @return the onLeft on条件的左边
	 */
	public QueryAttribute getOnLeft() {
		return onLeft;
	}

	/**
	 * @param onLeft
	 *            the onLeft to set on条件的左边
	 */
	public void setOnLeft(QueryAttribute onLeft) {
		this.onLeft = onLeft;
	}

	/**
	 * @return the onRight on条件的右边
	 */
	public QueryAttribute getOnRight() {
		return onRight;
	}

	/**
	 * @param onRight
	 *            the onRight to set on条件的右边
	 */
	public void setOnRight(QueryAttribute onRight) {
		this.onRight = onRight;
	}

	/**
	 * @return the joinType 子查询连接方式
	 */
	public String getJoinType() {
		return joinType;
	}

	/**
	 * @param joinType
	 *            the joinType to set 子查询连接方式
	 */
	public void setJoinType(String joinType) {
		this.joinType = joinType;
	}

	/**
	 * @return the subTableName 子表名称
	 */
	public String getSubTableName() {
		return subTableName;
	}

	/**
	 * @param subTableName
	 *            the subTableName to set 子表名称
	 */
	public void setSubTableName(String subTableName) {
		this.subTableName = subTableName;
	}

	/**
	 * @return the subTableAlias 子表别名
	 */
	public String getSubTableAlias() {
		return subTableAlias;
	}

	/**
	 * @param subTableAlias
	 *            the subTableAlias to set 子表别名
	 */
	public void setSubTableAlias(String subTableAlias) {
		this.subTableAlias = subTableAlias;
	}

	/**
	 * @return the entityId 子表对应的实体id
	 */
	public String getEntityId() {
		return entityId;
	}

	/**
	 * @param entityId
	 *            the entityId to set 子表对应的实体id
	 */
	public void setEntityId(String entityId) {
		this.entityId = entityId;
	}

	/**
	 * @return the sortNo 序号可供上移下移
	 */
	public int getSortNo() {
		return sortNo;
	}

	/**
	 * @param sortNo
	 *            the sortNo to set 序号可供上移下移
	 */
	public void setSortNo(int sortNo) {
		this.sortNo = sortNo;
	}

	/**
	 * @return the refQueryModel 关联QueryModel作为子查询数据集
	 */
	public QueryModel getRefQueryModel() {
		return refQueryModel;
	}

	/**
	 * @param refQueryModel
	 *            the refQueryModel to set 关联QueryModel作为子查询数据集
	 */
	public void setRefQueryModel(QueryModel refQueryModel) {
		this.refQueryModel = refQueryModel;
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
	 * @return the remark 备注
	 */
	public String getRemark() {
		return remark;
	}

	/**
	 * @param remark
	 *            the remark to set 备注
	 */
	public void setRemark(String remark) {
		this.remark = remark;
	}

}
