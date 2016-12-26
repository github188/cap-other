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
import javax.xml.bind.annotation.XmlValue;
import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;

import com.comtop.cap.report.xml.InstantAdapter;
import com.comtop.cap.report.xml.InstantSerializer;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

/**
 * 错误消息
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年9月6日 lizhongwen
 */
@XmlType(name = "msg")
public class Message {
    
    /** 时间 */
    private Instant timestamp;
    
    /** 错误级别 */
    private Level level;
    
    /** 消息内容 */
    private String message;
    
    /**
     * @return 获取 timestamp属性值
     */
    @XmlAttribute(name = "timestamp")
    @XmlJavaTypeAdapter(type = Instant.class, value = InstantAdapter.class)
    @JsonSerialize(using = InstantSerializer.class)
    public Instant getTimestamp() {
        return timestamp;
    }
    
    /**
     * @param timestamp 设置 timestamp 属性值为参数值 timestamp
     */
    public void setTimestamp(Instant timestamp) {
        this.timestamp = timestamp;
    }
    
    /**
     * @return 获取 level属性值
     */
    @XmlAttribute(name = "level")
    public Level getLevel() {
        return level;
    }
    
    /**
     * @param level 设置 level 属性值为参数值 level
     */
    public void setLevel(Level level) {
        this.level = level;
    }
    
    /**
     * @return 获取 message属性值
     */
    @XmlValue
    public String getMessage() {
        return message;
    }
    
    /**
     * @param message 设置 message 属性值为参数值 message
     */
    public void setMessage(String message) {
        this.message = message;
    }
}
