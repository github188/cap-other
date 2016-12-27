/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.ptc.report.model;

import com.comtop.top.core.base.model.CoreVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 
 * CAP统计报表VO
 * 
 * @author 杨赛
 * @since jdk1.6
 * @version 2015年9月21日
 */
@DataTransferObject
public class CAPReportVO extends CoreVO {
	/** FIXME */
    private static final long serialVersionUID = 7583188696977712551L;

    /** 界面（页面）数量 */
	private int pageCount;
	
	/** 实体数量 */
	private int entityCount;
	
	/** 流程数量 */
	private int flowCount;
	
	/** 服务数量 */
	private int serviceCount;
	
	/** 模块数量 */
	private int moduleCount;
	
	/** 报表轴名称，例如：项目模块复杂度分析 该值就是模块名*/
	private String axisName;
	
	/**
	 * get 界面（页面）数量 
	 * @return 界面（页面）数量 
	 */
	public int getPageCount() {
		return pageCount;
	}

	/**
	 * set 界面（页面）数量 
	 * @param pageCount 界面（页面）数量 
	 */
	public void setPageCount(int pageCount) {
		this.pageCount = pageCount;
	}

	/**
	 * get 实体数量 
	 * @return 实体数量 
	 */
	public int getEntityCount() {
		return entityCount;
	}

	/**
	 * set 实体数量
	 * @param entityCount 实体数量
	 */
	public void setEntityCount(int entityCount) {
		this.entityCount = entityCount;
	}

	/**
	 * get 流程数量
	 * @return 流程数量
	 */
	public int getFlowCount() {
		return flowCount;
	}

	/**
	 * set 流程数量
	 * @param flowCount 流程数量
	 */
	public void setFlowCount(int flowCount) {
		this.flowCount = flowCount;
	}

	/**
	 * get 服务数量
	 * @return 服务数量
	 */
	public int getServiceCount() {
		return serviceCount;
	}

	/**
	 * get 服务数量
	 * @param serviceCount 服务数量
	 */
	public void setServiceCount(int serviceCount) {
		this.serviceCount = serviceCount;
	}
	
	
	/**
	 * get 模块数量
	 * @return 模块数量
	 */
	public int getModuleCount() {
		return moduleCount;
	}

	/**
	 * set 模块数量
	 * @param moduleCount 模块数量
	 */
	public void setModuleCount(int moduleCount) {
		this.moduleCount = moduleCount;
	}

	/**
	 * get 报表轴名称，例如：项目模块复杂度分析 该值就是模块名
	 * @return 报表轴名称
	 */
	public String getAxisName() {
		return axisName;
	}

	/**
	 * set 报表轴名称，例如：项目模块复杂度分析 该值就是模块名
	 * @param axisName 报表轴名称，例如：项目模块复杂度分析 该值就是模块名
	 */
	public void setAxisName(String axisName) {
		this.axisName = axisName;
	}
}
