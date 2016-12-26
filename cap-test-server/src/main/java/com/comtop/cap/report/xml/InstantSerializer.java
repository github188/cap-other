/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.report.xml;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.time.Instant;
import java.util.Date;

import org.springframework.stereotype.Component;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

/**
 * JSON序列化Instant
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年9月7日 lizhongwen
 */
@Component
public final class InstantSerializer extends JsonSerializer<Instant> {
    
    /** 日期处理 */
    private static final SimpleDateFormat FORMATTER = new SimpleDateFormat("yyyyMMdd HH:mm:ss.SSS");
    
    /**
     * 
     * @see com.fasterxml.jackson.databind.ser.std.StdSerializer#serialize(java.lang.Object,
     *      com.fasterxml.jackson.core.JsonGenerator, com.fasterxml.jackson.databind.SerializerProvider)
     */
    @Override
    public void serialize(Instant value, JsonGenerator gen, SerializerProvider provider) throws IOException {
        String text = (value == null ? null : FORMATTER.format(Date.from(value)));
        gen.writeString(text);
    }
    
}
