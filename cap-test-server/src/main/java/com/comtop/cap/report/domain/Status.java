/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.report.domain;

import java.time.Instant;

import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlType;
import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;

import com.comtop.cap.report.xml.InstantAdapter;
import com.comtop.cap.report.xml.InstantSerializer;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

/**
 * 测试状态
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年9月6日 lizhongwen
 */
@XmlType(name = "status")
public class Status {
    
    /** 测试结果状态 */
    private ResultType status;
    
    /** 开始时间 */
    private Instant startTime;
    
    /** 结束时间 */
    private Instant endTime;
    
    /** 是否临界 */
    private Boolean critical;
    
    /**
     * @return 获取 status属性值
     */
    @XmlAttribute(name = "status")
    public ResultType getStatus() {
        return status;
    }
    
    /**
     * @param status 设置 status 属性值为参数值 status
     */
    public void setStatus(ResultType status) {
        this.status = status;
    }
    
    /**
     * @return 获取 startTime属性值
     */
    @XmlAttribute(name = "starttime")
    @XmlJavaTypeAdapter(type = Instant.class, value = InstantAdapter.class)
    @JsonSerialize(using = InstantSerializer.class)
    public Instant getStartTime() {
        return startTime;
    }
    
    /**
     * @param startTime 设置 startTime 属性值为参数值 startTime
     */
    public void setStartTime(Instant startTime) {
        this.startTime = startTime;
    }
    
    /**
     * @return 获取 endTime属性值
     */
    @XmlAttribute(name = "endtime")
    @XmlJavaTypeAdapter(type = Instant.class, value = InstantAdapter.class)
    @JsonSerialize(using = InstantSerializer.class)
    public Instant getEndTime() {
        return endTime;
    }
    
    /**
     * @param endTime 设置 endTime 属性值为参数值 endTime
     */
    public void setEndTime(Instant endTime) {
        this.endTime = endTime;
    }
    
    /**
     * @return 获取 critical属性值
     */
    @XmlAttribute(name = "critical")
    public Boolean getCritical() {
        return critical;
    }
    
    /**
     * @param critical 设置 critical 属性值为参数值 critical
     */
    public void setCritical(Boolean critical) {
        this.critical = critical;
    }
}
