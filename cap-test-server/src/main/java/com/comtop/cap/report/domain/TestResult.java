/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.report.domain;

import java.sql.Timestamp;
import java.util.Calendar;
import java.util.Date;

/**
 * 测试结果
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年9月27日 lizhongwen
 */
public class TestResult {
    
    /** 坐标名称 */
    private String axisName;
    
    /** 开始时间 */
    private Date startTime;
    
    /** 结束时间 */
    private Date endTime;
    
    /** 通过数 */
    private Integer passCount;
    
    /** 失败数 */
    private Integer failCount;
    
    /** 统计数量 */
    private Integer top;
    
    /** 最好的还是最差的 */
    private Boolean excellent;
    
    /** 结果ID */
    private String id;
    
    /** 测试编号 */
    private String uuid;
    
    /** 用例名称 */
    private String testcaseName;
    
    /** 元数据名称 */
    private String metaName;
    
    /** 功能名称 */
    private String funcName;
    
    /** 应用名称 */
    private String appName;
    
    /** 测试结果 */
    private Boolean result;
    
    /** 测试时间 */
    private Timestamp testTime;
    
    /** 用例层级 */
    private Integer testcaseLevel;
    
    /** 应用ID */
    private String appId;
    
    /** 应用全路径 */
    private String appFullName;
    
    /** 测试日历 */
    private Calendar calendar;
    
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
     * @return 获取 uuid属性值
     */
    public String getUuid() {
        return uuid;
    }
    
    /**
     * @param uuid 设置 uuid 属性值为参数值 uuid
     */
    public void setUuid(String uuid) {
        this.uuid = uuid;
    }
    
    /**
     * @return 获取 testcaseName属性值
     */
    public String getTestcaseName() {
        return testcaseName;
    }
    
    /**
     * @param testcaseName 设置 testcaseName 属性值为参数值 testcaseName
     */
    public void setTestcaseName(String testcaseName) {
        this.testcaseName = testcaseName;
    }
    
    /**
     * @return 获取 metaName属性值
     */
    public String getMetaName() {
        return metaName;
    }
    
    /**
     * @param metaName 设置 metaName 属性值为参数值 metaName
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
     * @param funcName 设置 funcName 属性值为参数值 funcName
     */
    public void setFuncName(String funcName) {
        this.funcName = funcName;
    }
    
    /**
     * @return 获取 appName属性值
     */
    public String getAppName() {
        return appName;
    }
    
    /**
     * @param appName 设置 appName 属性值为参数值 appName
     */
    public void setAppName(String appName) {
        this.appName = appName;
    }
    
    /**
     * @return 获取 result属性值
     */
    public Boolean getResult() {
        return result;
    }
    
    /**
     * @param result 设置 result 属性值为参数值 result
     */
    public void setResult(Boolean result) {
        this.result = result;
    }
    
    /**
     * @return 获取 testTime属性值
     */
    public Timestamp getTestTime() {
        return testTime;
    }
    
    /**
     * @return 获取 axisName属性值
     */
    public String getAxisName() {
        return axisName;
    }
    
    /**
     * @param axisName 设置 axisName 属性值为参数值 axisName
     */
    public void setAxisName(String axisName) {
        this.axisName = axisName;
    }
    
    /**
     * @return 获取 startTime属性值
     */
    public Date getStartTime() {
        return startTime;
    }
    
    /**
     * @param startTime 设置 startTime 属性值为参数值 startTime
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
     * @param endTime 设置 endTime 属性值为参数值 endTime
     */
    public void setEndTime(Date endTime) {
        this.endTime = endTime;
    }
    
    /**
     * @return 获取 passCount属性值
     */
    public Integer getPassCount() {
        return passCount;
    }
    
    /**
     * @param passCount 设置 passCount 属性值为参数值 passCount
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
     * @param failCount 设置 failCount 属性值为参数值 failCount
     */
    public void setFailCount(Integer failCount) {
        this.failCount = failCount;
    }
    
    /**
     * @return 获取 top属性值
     */
    public Integer getTop() {
        return top;
    }
    
    /**
     * @param top 设置 top 属性值为参数值 top
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
     * @param excellent 设置 excellent 属性值为参数值 excellent
     */
    public void setExcellent(Boolean excellent) {
        this.excellent = excellent;
    }
    
    /**
     * @param testTime 设置 testTime 属性值为参数值 testTime
     */
    public void setTestTime(Timestamp testTime) {
        this.testTime = testTime;
        if (this.testTime != null) {
            this.calendar = Calendar.getInstance();
            this.calendar.setTimeInMillis(testTime.getTime());
        }
    }
    
    /**
     * @return 获取 testcaseLevel属性值
     */
    public Integer getTestcaseLevel() {
        return testcaseLevel;
    }
    
    /**
     * @param testcaseLevel 设置 testcaseLevel 属性值为参数值 testcaseLevel
     */
    public void setTestcaseLevel(Integer testcaseLevel) {
        this.testcaseLevel = testcaseLevel;
    }
    
    /**
     * @return 获取 appId属性值
     */
    public String getAppId() {
        return appId;
    }
    
    /**
     * @param appId 设置 appId 属性值为参数值 appId
     */
    public void setAppId(String appId) {
        this.appId = appId;
    }
    
    /**
     * @return 获取 appFullName属性值
     */
    public String getAppFullName() {
        return appFullName;
    }
    
    /**
     * @param appFullName 设置 appFullName 属性值为参数值 appFullName
     */
    public void setAppFullName(String appFullName) {
        this.appFullName = appFullName;
    }
    
    /**
     * @return 获取 year属性值
     */
    public Integer getYear() {
        if (this.calendar != null) {
            return this.calendar.get(Calendar.YEAR);
        }
        return null;
    }
    
    /**
     * @return 获取 month属性值
     */
    public Integer getMonth() {
        if (this.calendar != null) {
            return this.calendar.get(Calendar.MONTH) + 1;
        }
        return null;
    }
    
    /**
     * @return 获取 day属性值
     */
    public Integer getDay() {
        if (this.calendar != null) {
            return this.calendar.get(Calendar.DAY_OF_MONTH);
        }
        return null;
    }
    
    /**
     * @return 获取 week属性值
     */
    public Integer getWeek() {
        if (this.calendar != null) {
            int week = this.calendar.get(Calendar.WEEK_OF_YEAR);
            int year = this.calendar.get(Calendar.YEAR);
            Calendar firstDayOfYear = Calendar.getInstance();
            firstDayOfYear.set(year, 1, 1);
            if (firstDayOfYear.get(Calendar.DAY_OF_WEEK) != Calendar.SUNDAY) {
                week = week - 1;
            }
            return week == 0 ? 52 : week;
        }
        return null;
    }
    
    /**
     * @return 获取 week属性值
     */
    public Integer getWeekOfMonth() {
        if (this.calendar != null) {
            return this.calendar.get(Calendar.WEEK_OF_MONTH);
        }
        return null;
    }
}
