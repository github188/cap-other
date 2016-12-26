/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.webapp.page.demo.model;

import com.comtop.top.core.base.model.CoreVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * FIXME 类注释信息(此标记由Eclipse自动生成,请填写注释信息删除此标记)
 *
 *
 * @author 作者
 * @since 1.0
 * @version 2015-6-5 作者
 */
@DataTransferObject
public class FormGrid1VO extends CoreVO {
	/** FIXME */
    private static final long serialVersionUID = 5238394072500512860L;

    /**
	 * 
	 */
	private String id;

	/**
	 * 
	 */
	private String depertment;

	/**
	 * 
	 */
	private String substation;

	/**
	 * 
	 */
	private String line;

	/**
	 * 
	 */
	private String device;

	/**
	 * @return 获取 id属性值
	 */
	public String getId() {
		return id;
	}

	/**
	 * @param id 设置 id 属性值为参数值 id
	 */
	public void setId(String id) {
		this.id = id;
	}

	/**
	 * @return 获取 depertment属性值
	 */
	public String getDepertment() {
		return depertment;
	}

	/**
	 * @param depertment 设置 depertment 属性值为参数值 depertment
	 */
	public void setDepertment(String depertment) {
		this.depertment = depertment;
	}

	/**
	 * @return 获取 substation属性值
	 */
	public String getSubstation() {
		return substation;
	}

	/**
	 * @param substation 设置 substation 属性值为参数值 substation
	 */
	public void setSubstation(String substation) {
		this.substation = substation;
	}

	/**
	 * @return 获取 line属性值
	 */
	public String getLine() {
		return line;
	}

	/**
	 * @param line 设置 line 属性值为参数值 line
	 */
	public void setLine(String line) {
		this.line = line;
	}

	/**
	 * @return 获取 device属性值
	 */
	public String getDevice() {
		return device;
	}

	/**
	 * @param device 设置 device 属性值为参数值 device
	 */
	public void setDevice(String device) {
		this.device = device;
	}

}
