/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.ptc.report.model;

import java.util.Date;

import comtop.org.directwebremoting.annotations.DataTransferObject;


/**
 * 
 * CAP统计报表查询条件类
 * 
 * @author 杨赛
 * @since jdk1.6
 * @version 2015年9月21日
 */
@DataTransferObject
public class ReportCondition {
	/** 开始时间 */
	private Date startTime;
	
	/** 结束时间 */
	private Date endTime;
	
	/** 创建人id */
	private String createrId;
	
	/** 查看类型  0 按周  1按月 2 按季度 */
	private String queryType;
	
	/**
	 * get 开始时间
	 * @return 开始时间
	 */
	public Date getStartTime() {
		return startTime;
	}

	/**
	 * get 开始时间
	 * @param startTime 开始时间
	 */
	public void setStartTime(Date startTime) {
		this.startTime = startTime;
	}

	/**
	 * get 结束时间
	 * @return 结束时间
	 */
	public Date getEndTime() {
		return endTime;
	}

	/**
	 * set 结束时间
	 * @param endTime 结束时间
	 */
	public void setEndTime(Date endTime) {
		this.endTime = endTime;
	}

	/**
	 * get 创建人id
	 * @return 创建人id
	 */
	public String getCreaterId() {
		return createrId;
	}

	/**
	 * set 创建人id
	 * @param createrId 创建人id
	 */
	public void setCreaterId(String createrId) {
		this.createrId = createrId;
	}

	/**
	 * get 查看类型  0 按周  1按月 2 按季度
	 * @return 查看类型  0 按周  1按月 2 按季度
	 */
	public String getQueryType() {
		return queryType;
	}

	/**
	 * set 查看类型  0 按周  1按月 2 按季度
	 * @param queryType 查看类型  0 按周  1按月 2 按季度
	 */
	public void setQueryType(String queryType) {
		this.queryType = queryType;
	}
}
