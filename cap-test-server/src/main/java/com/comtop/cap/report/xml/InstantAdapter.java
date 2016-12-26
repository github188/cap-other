/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.report.xml;

import java.text.SimpleDateFormat;
import java.time.Instant;
import java.util.Date;

import javax.xml.bind.annotation.adapters.XmlAdapter;

/**
 * Instant
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年9月7日 lizhongwen
 */
public class InstantAdapter extends XmlAdapter<String, Instant> {
    
    /** 日期处理 */
    private static final SimpleDateFormat FORMATTER = new SimpleDateFormat("yyyyMMdd HH:mm:ss.SSS");
    
    /**
     * 
     * @see javax.xml.bind.annotation.adapters.XmlAdapter#unmarshal(java.lang.Object)
     */
    @Override
    public Instant unmarshal(String v) throws Exception {
        Date date = FORMATTER.parse(v);
        return date == null ? null : date.toInstant();
    }
    
    /**
     * 
     * @see javax.xml.bind.annotation.adapters.XmlAdapter#marshal(java.lang.Object)
     */
    @Override
    public String marshal(Instant v) throws Exception {
        return v == null ? null : FORMATTER.format(Date.from(v));
    }
    
}
