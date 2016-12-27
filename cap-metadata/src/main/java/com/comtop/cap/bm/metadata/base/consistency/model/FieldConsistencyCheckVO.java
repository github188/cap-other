/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.base.consistency.model;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 控件模型
 * 
 * @author 罗珍明
 * @version jdk1.5
 * @version 2015-4-28 罗珍明
 */
@DataTransferObject
public class FieldConsistencyCheckVO extends BaseMetadata {
	
	/**
	 * @return the consistencyConfigVO
	 */
	public FieldConsistencyConfigVO getConsistencyConfigVO() {
		return consistencyConfigVO;
	}

	/**
	 * @param consistencyConfigVO the consistencyConfigVO to set
	 */
	public void setConsistencyConfigVO(FieldConsistencyConfigVO consistencyConfigVO) {
		this.consistencyConfigVO = consistencyConfigVO;
	}

	/**
	 * @return the value
	 */
	public Object getValue() {
		return value;
	}

	/**
	 * @param value the value to set
	 */
	public void setValue(Object value) {
		this.value = value;
	}

	/***/
	private FieldConsistencyConfigVO consistencyConfigVO;
	
	/***/
	private Object value;
	
}
