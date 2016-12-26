/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.robot.model;

import java.util.Date;

import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 测试结果统计
 * 
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年9月28日 lizhongwen
 */
@DataTransferObject
public class Statistics {

	/** 坐标名称 */
	private String axisName;
	/** 应用Id */
	private String appId;
	/** 应用名称 */
	private String appName;

	/** 应用全名称 */
	private String appFullName;

	/** 元数据名称 */
	private String metaName;

	/** 功能名称 */
	private String funcName;

	/** 用例名称 */
	private String testcaseName;

	/** 开始时间 */
	private Date startTime;

	/** 结束时间 */
	private Date endTime;

	/** 测试时间 */
	private Date testTime;

	/** 通过数 */
	private Integer passCount;

	/** 失败数 */
	private Integer failCount;
	/** 测试编号--TEST_UUID */
	private String testUuid;//

	/** 是否通过测试 */
	private Boolean pass;

	/** 统计数量 */
	private Integer top;

	/** 最好的还是最差的 */
	private Boolean excellent;

	/**
	 * @return 获取 axisName属性值
	 */
	public String getAxisName() {
		return axisName;
	}

	/**
	 * @param axisName
	 *            设置 axisName 属性值为参数值 axisName
	 */
	public void setAxisName(String axisName) {
		this.axisName = axisName;
	}

	/**
	 * @return 获取 appName属性值
	 */
	public String getAppName() {
		return appName;
	}

	/**
	 * @return TEST_UUID
	 */
	public String getTestUuid() {
		return testUuid;
	}

	/**
	 * @param testUuid TEST_UUID
	 */
	public void setTestUuid(String testUuid) {
		this.testUuid = testUuid;
	}

	/**
	 * @param appName
	 *            设置 appName 属性值为参数值 appName
	 */
	public void setAppName(String appName) {
		this.appName = appName;
	}

	/**
	 * @return 获取 appFullName属性值
	 */
	public String getAppFullName() {
		return appFullName;
	}

	/**
	 * @param appFullName
	 *            设置 appFullName 属性值为参数值 appFullName
	 */
	public void setAppFullName(String appFullName) {
		this.appFullName = appFullName;
	}

	/**
	 * @return 获取 metaName属性值
	 */
	public String getMetaName() {
		return metaName;
	}

	/**
	 * @param metaName
	 *            设置 metaName 属性值为参数值 metaName
	 */
	public void setMetaName(String metaName) {
		this.metaName = metaName;
	}

	/**
	 * @return 获取 funcName属性值
	 */
	public String getFuncName() {
		return funcName;
	}

	/**
	 * @param funcName
	 *            设置 funcName 属性值为参数值 funcName
	 */
	public void setFuncName(String funcName) {
		this.funcName = funcName;
	}

	/**
	 * @return 获取 testcaseName属性值
	 */
	public String getTestcaseName() {
		return testcaseName;
	}

	/**
	 * @param testcaseName
	 *            设置 testcaseName 属性值为参数值 testcaseName
	 */
	public void setTestcaseName(String testcaseName) {
		this.testcaseName = testcaseName;
	}

	/**
	 * @return 获取 startTime属性值
	 */
	public Date getStartTime() {
		return startTime;
	}

	/**
	 * @param startTime
	 *            设置 startTime 属性值为参数值 startTime
	 */
	public void setStartTime(Date startTime) {
		this.startTime = startTime;
	}

	/**
	 * @return 获取 endTime属性值
	 */
	public Date getEndTime() {
		return endTime;
	}

	/**
	 * @param endTime
	 *            设置 endTime 属性值为参数值 endTime
	 */
	public void setEndTime(Date endTime) {
		this.endTime = endTime;
	}

	/**
	 * @return 获取 testTime属性值
	 */
	public Date getTestTime() {
		return testTime;
	}

	/**
	 * @param testTime
	 *            设置 testTime 属性值为参数值 testTime
	 */
	public void setTestTime(Date testTime) {
		this.testTime = testTime;
	}

	/**
	 * @return 获取 passCount属性值
	 */
	public Integer getPassCount() {
		return passCount;
	}

	/**
	 * @param passCount
	 *            设置 passCount 属性值为参数值 passCount
	 */
	public void setPassCount(Integer passCount) {
		this.passCount = passCount;
	}

	/**
	 * @return 获取 failCount属性值
	 */
	public Integer getFailCount() {
		return failCount;
	}

	/**
	 * @param failCount
	 *            设置 failCount 属性值为参数值 failCount
	 */
	public void setFailCount(Integer failCount) {
		this.failCount = failCount;
	}

	/**
	 * @return 获取 appId属性值
	 */
	public String getAppId() {
		return appId;
	}

	/**
	 * @param appId
	 *            设置 appId 属性值为参数值 appId
	 */
	public void setAppId(String appId) {
		this.appId = appId;
	}

	/**
	 * @return 获取 pass属性值
	 */
	public Boolean getPass() {
		return pass;
	}

	/**
	 * @param pass
	 *            设置 pass 属性值为参数值 pass
	 */
	public void setPass(Boolean pass) {
		this.pass = pass;
	}

	/**
	 * @return 获取 top属性值
	 */
	public Integer getTop() {
		return top;
	}

	/**
	 * @param top
	 *            设置 top 属性值为参数值 top
	 */
	public void setTop(Integer top) {
		this.top = top;
	}

	/**
	 * @return 获取 excellent属性值
	 */
	public Boolean getExcellent() {
		return excellent;
	}

	/**
	 * @param excellent
	 *            设置 excellent 属性值为参数值 excellent
	 */
	public void setExcellent(Boolean excellent) {
		this.excellent = excellent;
	}

	@Override
	public String toString() {
		return "Statistics [axisName=" + axisName + ", appId=" + appId
				+ ", appName=" + appName + ", appFullName=" + appFullName
				+ ", metaName=" + metaName + ", funcName=" + funcName
				+ ", testcaseName=" + testcaseName + ", startTime=" + startTime
				+ ", endTime=" + endTime + ", testTime=" + testTime
				+ ", passCount=" + passCount + ", failCount=" + failCount
				+ ", testUuid=" + testUuid + ", pass=" + pass + ", top=" + top
				+ ", excellent=" + excellent + "]";
	}
	
	
}
