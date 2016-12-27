/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.common;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.comtop.cip.jodd.util.StringUtil;

/**
 * 元数据版本化日期工具类
 * 
 * @author 沈康
 * @since 1.0
 * @version 2014-6-26 沈康
 */
public final class MetadataDateUtils {
    
    /** 无需构建此类的对象 */
    private MetadataDateUtils() {
    }
    
    /**
     * 将一个{@link Date}类型转化为字符串格式
     * 
     * @param date 需要转化的对象
     * @param outputType 输出格式
     * @return 一个字符串格式的日期，如果被转化对象为空则返回空字符串
     */
    public static String convertDateToString(Date date, String outputType) {
        if (date == null) {
            return "";
        }
        
        DateFormat objSimpleDateFormat = null;
        if (StringUtil.isBlank(outputType)) {
            objSimpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        } else {
            objSimpleDateFormat = new SimpleDateFormat(outputType);
        }
        return objSimpleDateFormat.format(date);
    }
    
    /**
     * 将一个字符串类型的日期转化为{@link Date}类型
     * 
     * @param resource 字符串格式的日期
     * @param dateType 日期的格式
     * @return 返回一个{@link Date}对象, 当传入的字符串为空时返回null
     * @throws ParseException ParseException
     */
    public static Date convertStringToDate(String resource, String dateType) throws ParseException {
        if (StringUtil.isBlank(resource)) {
            return null;
        }
        
        SimpleDateFormat objSimpleDateFormat = null;
        if (StringUtil.isBlank(dateType)) {
            objSimpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        } else {
            objSimpleDateFormat = new SimpleDateFormat(dateType);
        }
        return objSimpleDateFormat.parse(resource);
    }
}
