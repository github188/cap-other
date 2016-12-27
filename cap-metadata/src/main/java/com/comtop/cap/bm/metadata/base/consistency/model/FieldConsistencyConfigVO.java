/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.base.consistency.model;

import java.util.HashMap;
import java.util.Map;

import javax.xml.bind.annotation.XmlType;

import com.comtop.cap.bm.metadata.base.consistency.annotation.ConsistencyDependOnField;
import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import com.comtop.cap.bm.metadata.common.storage.annotation.IgnoreField;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 控件模型
 * 
 * @author 罗珍明
 * @version jdk1.5
 * @version 2015-4-28 罗珍明
 */
@DataTransferObject
@XmlType(name = "consistencyConfig")
public class FieldConsistencyConfigVO extends BaseMetadata {
	
	/**是否进一致性校验**/
	private Boolean checkConsistency;
	
	/**
	 * @return the checkConsistency
	 */
	public Boolean getCheckConsistency() {
		return checkConsistency;
	}

	/**
	 * @param checkConsistency the checkConsistency to set
	 */
	public void setCheckConsistency(Boolean checkConsistency) {
		this.checkConsistency = checkConsistency;
	}
	
	/**需要校验的属性*/
	@IgnoreField
	private String fieldName;
	
	/**属性所属对象名称*/
	private String objectClassName;

	/**
	 * @return the objectClassName
	 */
	public String getObjectClassName() {
		return objectClassName;
	}

	/**
	 * @param objectClassName the objectClassName to set
	 */
	public void setObjectClassName(String objectClassName) {
		this.objectClassName = objectClassName;
	}

	/**
	 * @return the fieldName
	 */
	public String getFieldName() {
		return fieldName;
	}

	/**
	 * @param fieldName the fieldName to set
	 */
	public void setFieldName(String fieldName) {
		this.fieldName = fieldName;
	}

	/**
	 * 
	 * 校验范围
	 */
	private String checkScope = ConsistencyDependOnField.CHECK_SCOPE_CURRENT_OBJECT;
	
	/**
	 * 
	 *  检验的类名 ,该类需要实现接口 IConsistencyCheck 和  IConsistencyReferencedCheck
	 */
	private String checkClass;
	
	/**
	 * 
	 * 校验表达式
	 */
	private String expression;
	
	/**
     * 
     * 用于处理属性值的正则表达
     */
	private Map<String, String> regular = new HashMap<String, String>();

	/**
	 * @return the checkScope
	 */
	public String getCheckScope() {
		return checkScope;
	}

	/**
	 * @param checkScope the checkScope to set
	 */
	public void setCheckScope(String checkScope) {
		this.checkScope = checkScope;
	}

	/**
	 * @return the checkClass
	 */
	public String getCheckClass() {
		return checkClass;
	}

	/**
	 * @param checkClass the checkClass to set
	 */
	public void setCheckClass(String checkClass) {
		this.checkClass = checkClass;
	}

	/**
	 * @return the expression
	 */
	public String getExpression() {
		return expression;
	}

	/**
	 * @param expression the expression to set
	 */
	public void setExpression(String expression) {
		this.expression = expression;
	}

	/**
     * @return the regular
     */
    public Map<String, String> getRegular() {
        return regular;
    }

    /**
     * @param regular the regular to set
     */
    public void setRegular(Map<String, String> regular) {
        this.regular = regular;
    }
}
