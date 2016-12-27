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
 * 查询建模where条件数据模型
 * 
 * @author 许畅
 * @since JDK1.6
 * @version 2016年7月26日 许畅 新建
 */
@DataTransferObject
public class WhereCondition extends BaseMetadata {

	/** 序列化版本号 */
	private static final long serialVersionUID = 1L;

	/**
	 * 操作符,and or {@link com.comtop.cap.bm.metadata.entity.model.OperatorType} 如
	 * 'and' 'or'
	 */
	private String operatorType;

	/** 是否左括号 */
	private boolean hasLeftBracket;

	/** 条件属性 */
	private QueryAttribute conditionAttribute;

	/**
	 * 通配符 {@link com.comtop.cap.bm.metadata.entity.model.Wildcard} 如 '=,>,<,%'
	 * 等
	 */
	private String wildcard;

	/** 值 */
	private String value;

	/** 自定义条件 */
	private String customCondition;

	/** 右括号 */
	private boolean hasRightBracket;

	/** 传值方式 {@link com.comtop.cap.bm.metadata.entity.model.TransferValPattern} */
	private String transferValPattern;

	/** 查询条件是否需要空判断 */
	private boolean emptyCheck;

	/** 序号 */
	private int sortNo;

	/**
	 * @return the operatorType 操作符
	 */
	public String getOperatorType() {
		return operatorType;
	}

	/**
	 * @param operatorType
	 *            the operatorType to set 操作符
	 */
	public void setOperatorType(String operatorType) {
		this.operatorType = operatorType;
	}

	/**
	 * @return the hasLeftBracket 左括号
	 */
	public boolean isHasLeftBracket() {
		return hasLeftBracket;
	}

	/**
	 * @param hasLeftBracket
	 *            the hasLeftBracket to set 左括号
	 */
	public void setHasLeftBracket(boolean hasLeftBracket) {
		this.hasLeftBracket = hasLeftBracket;
	}

	/**
	 * @return the hasRightBracket 右括号
	 */
	public boolean isHasRightBracket() {
		return hasRightBracket;
	}

	/**
	 * @param hasRightBracket
	 *            the hasRightBracket to set 右括号
	 */
	public void setHasRightBracket(boolean hasRightBracket) {
		this.hasRightBracket = hasRightBracket;
	}

	/**
	 * @return the wildcard 通配符
	 */
	public String getWildcard() {
		return wildcard;
	}

	/**
	 * @param wildcard
	 *            the wildcard to set 通配符
	 */
	public void setWildcard(String wildcard) {
		this.wildcard = wildcard;
	}

	/**
	 * @return the value 值
	 */
	public String getValue() {
		return value;
	}

	/**
	 * @param value
	 *            the value to set 值
	 */
	public void setValue(String value) {
		this.value = value;
	}

	/**
	 * @return the transferValPattern 传值方式
	 */
	public String getTransferValPattern() {
		return transferValPattern;
	}

	/**
	 * @param transferValPattern
	 *            the transferValPattern to set 传值方式
	 */
	public void setTransferValPattern(String transferValPattern) {
		this.transferValPattern = transferValPattern;
	}

	/**
	 * @return the sortNo 序号
	 */
	public int getSortNo() {
		return sortNo;
	}

	/**
	 * @param sortNo
	 *            the sortNo to set 序号
	 */
	public void setSortNo(int sortNo) {
		this.sortNo = sortNo;
	}

	/**
	 * @return the conditionAttribute 条件属性
	 */
	public QueryAttribute getConditionAttribute() {
		return conditionAttribute;
	}

	/**
	 * @param conditionAttribute
	 *            the conditionAttribute to set 条件属性
	 */
	public void setConditionAttribute(QueryAttribute conditionAttribute) {
		this.conditionAttribute = conditionAttribute;
	}

	/**
	 * @return the emptyCheck 查询条件是否需要空判断
	 */
	public boolean isEmptyCheck() {
		return emptyCheck;
	}

	/**
	 * @param emptyCheck
	 *            the emptyCheck to set 查询条件是否需要空判断
	 */
	public void setEmptyCheck(boolean emptyCheck) {
		this.emptyCheck = emptyCheck;
	}

	/**
	 * @return the customCondition 自定义条件
	 */
	public String getCustomCondition() {
		return customCondition;
	}

	/**
	 * @param customCondition
	 *            the customCondition to set 自定义条件
	 */
	public void setCustomCondition(String customCondition) {
		this.customCondition = customCondition;
	}

}
