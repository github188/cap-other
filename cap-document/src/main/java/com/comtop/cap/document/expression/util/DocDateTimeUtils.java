/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression.util;

import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.document.expression.annotation.Function;

/**
 * CAP文档管理，表达式函数，时间处理工具类
 * 
 * @author 李小强
 * @since 1.0
 * @version 2015-11-19 李小强
 */
public final class DocDateTimeUtils {
    
    /** LOG */
    private static final Logger LOG = LoggerFactory.getLogger(DocDateTimeUtils.class);
    
    /**
     * 日期格式如：2003-10-01 10:20:15.200
     */
    public final static String YEAR_TO_MSECOND_T = "yyyy-MM-dd HH:mm:ss.SSS";
    
    /**
     * 日期格式包含年、月、日、小时、分钟、秒、毫秒，如：2003-10-01 10:20:15:200
     * 
     */
    public final static String YEAR_TO_MSECOND = "yyyy-MM-dd HH:mm:ss:SSS";
    
    /**
     * 日期格式包含年、月、日、小时、分钟、秒,如：2003-10-01 10:20:15
     * 
     */
    public final static String YYYY_MM_DD_HH_MM_SS = "yyyy-MM-dd HH:mm:ss";
    
    /**
     * 日期格式包含年月日，如：2003-10-01
     * 
     */
    public final static String YEAR_MOUTH_DAY = "yyyy-MM-dd";
    
    /**
     * 日期格式包含年月，如：2003-10
     * 
     */
    public final static String YEAR_MOUTH = "yyyy-MM";
    
    /**
     * 紧凑型日期格式包含年、月、日、小时、分钟、秒、毫秒，如：20031001102015200
     * 
     */
    public final static String YEAR_TO_MSECOND_C = "yyyyMMddHHmmssSSS";
    
    /**
     * 紧凑型日期格式包含年、月、日、小时、分钟、秒,如：20031001102015
     * 
     */
    public final static String YEAR_TO_SECOND_C = "yyyyMMddHHmmss";
    
    /**
     * 日期格式包含年月日，如：20031001
     * 
     */
    public final static String YEARMOUTHDAY = "yyyyMMdd";
    
    /**
     * 紧凑型日期格式包含年月，如：200310
     * 
     */
    public final static String YEARMOUTH = "yyyyMM";
    
    /**
     * 日期格式包含年月，如：2003
     * 
     */
    public final static String YEAR = "yyyy";
    
    /**
     * 私有构造函数
     */
    private DocDateTimeUtils() {
        super();
    }
    
    /**
     * 计算一段时间之后的时间点
     * 
     * @param periodMillSecond 一段时间
     * @param startMillSecond 开始时间
     * @return Date类型的日期
     * @author 李欢
     */
    @Function(name = "DateTimeUtil_getPeriodDate", description = "计算一段时间之后的时间点")
    public static java.util.Date getPeriodDate(Long startMillSecond, Long periodMillSecond) {
        if (periodMillSecond == null) {
            return stringToDate(String.valueOf(startMillSecond));
        }
        Long lFutureSecond = startMillSecond + periodMillSecond;
        return new Date(lFutureSecond);
    }
    
    /**
     * 将字符型数字转为Date类型
     * 
     * @param value 要转换的字符
     * @return Date类型的日期
     * @author 李小强
     */
    @Function(name = "DateTimeUtil_stringToDefaultDate", description = "将字符型数字转为默认的Date类型")
    public static java.util.Date stringToDate(String value) {
        try {
            if (value == null || "".equals(value)) {
                return null;
            }
            
            SimpleDateFormat objFormatdate = new SimpleDateFormat(getDateFormat(value), Locale.getDefault());
            java.util.Date objDate = objFormatdate.parse(value);
            return objDate;
        } catch (ParseException ex) {
            LOG.error("时间格式解析异常", ex);
            return null;
        }
    }
    
    /**
     * 将字符型数字转为Date类型
     * 
     * @param value 要转换的字符
     * @param format 格式
     * @return Date类型的日期
     * @author 李小强
     */
    @Function(name = "DateTimeUtil_stringToFormatDate", description = "将字符型数字转为指定格式的Date类型")
    public static java.util.Date stringToDate(String value, String format) {
        try {
            if (value == null || "".equals(value)) {
                return null;
            }
            SimpleDateFormat objFormatdate = new SimpleDateFormat(format, Locale.getDefault());
            java.util.Date objDate = objFormatdate.parse(value);
            return objDate;
        } catch (ParseException ex) {
            LOG.error("时间格式解析异常", ex);
            return null;
        }
    }
    
    /**
     * 把包含日期值转换为字符串
     * 
     * @param date 日期（日期+时间）
     * @param type 输出类型
     * @return 字符串
     */
    @Function(name = "DateTimeUtil_dateTimeToFormatString", description = "把包含日期值转换为指定格式的字符串")
    public static String dateTimeToString(java.util.Date date, String type) {
        String dateString = "";
        if (date == null) {
            dateString = "";
        } else {
            SimpleDateFormat objFormatDate = new SimpleDateFormat(type, Locale.getDefault());
            dateString = objFormatDate.format(date);
        }
        return dateString;
    }
    
    /**
     * 把包含日期值转换为字符串
     * 
     * @param date 日期（日期+时间）
     * @return 字符串
     */
    @Function(name = "DateTimeUtil_dateTimeToDefaultString", description = "把包含日期值转换为默认格式的字符串")
    public static String dateTimeToString(java.util.Date date) {
        String dateString = "";
        if (date == null) {
            dateString = "";
        } else {
            SimpleDateFormat objFormatDate = new SimpleDateFormat(YYYY_MM_DD_HH_MM_SS, Locale.getDefault());
            dateString = objFormatDate.format(date);
        }
        return dateString;
    }
    
    /**
     * java.util.date转
     * 
     * @param date 日期（日期+时间）
     * @return 字符串
     */
    @Function(name = "DateTimeUtil_dateToTimestamp", description = "date转Timestamp")
    public static Timestamp dateToTimestamp(java.util.Date date) {
        return new Timestamp(date.getTime());
    }
    
    /**
     * java.util.date转,Timestamp转Date
     * 
     * @param date 日期（日期+时间）
     * @return 字符串
     */
    @Function(name = "DateTimeUtil_timestampToDate", description = "Timestamp转Date")
    public static Date timestampToDate(Timestamp date) {
        return new Date(date.getTime());
    }
    
    /**
     * 获取当前时间字符串值
     * 紧凑型日期格式包含年、月、日、小时、分钟、秒,如：20031001102015
     * 
     * @author 李小强
     * @return 当前时间字符串值,格式：20031001102015
     */
    @Function(name = "DateTimeUtil_getCurrDateTimeStr", description = "获取当前时间字符串值")
    public static String getCurrDateTimeStr() {
        return dateTimeToString(new Date(), YEAR_TO_SECOND_C);
    }
    
    /**
     * 按指定格式获取当前时间字符串值
     * 
     * @param formt 格式
     * @return 当前时间字符串值
     */
    @Function(name = "DateTimeUtil_getCurrTimeFormatStr", description = "按指定格式获取当前时间字符串值")
    public static String getCurrTimeFormatStr(String formt) {
        return dateTimeToString(new Date(), formt);
    }
    
    /**
     * 时间戳转换为字符串
     * 
     * @param time 时间戳
     * @return 时间戳字符串
     */
    @Function(name = "DateTimeUtil_timestampToStr", description = "时间戳转换为字符串")
    public static String timestampToStr(Timestamp time) {
        if (null == time) {
            return null;
        }
        Date date = new Date(time.getTime());
        return dateTimeToString(date, YYYY_MM_DD_HH_MM_SS);
    }
    
    /**
     * 字符串转换为时间戳
     * 
     * @param str 事件字符串
     * @return 时间戳
     */
    @Function(name = "DateTimeUtil_strToTimestamp", description = "字符串转换为时间戳")
    public static Timestamp strToTimestamp(String str) {
        if (DocStringUtils.isBlank(str)) {
            return null;
        }
        Date date = stringToDate(str, getDateFormat(str));
        return new Timestamp(date.getTime());
    }
    
    /**
     * 
     * 根据时间获取时间格式,
     * 优化支持3种格式及3种格式以内的格式：yyyy-MM-dd HH:mm:ss:SSS、yyyy-MM-dd HH:mm:ss.SSS、yyyyMMddHHmmssSSS
     * 
     * @param date 时间数据
     * @return 时间格式
     */
    @Function(name = "DateTimeUtil_getDateFormat", description = "根据时间获取时间格式，支持3种格式及3种格式以内的格式：yyyy-MM-dd HH:mm:ss:SSS、yyyy-MM-dd HH:mm:ss.SSS、yyyyMMddHHmmssSSS")
    public static String getDateFormat(String date) {
        try {
            int iLen = date.length();
            int iRegLen = YEAR_TO_MSECOND.length();
            if (matchesFormat(date, YEAR_TO_MSECOND_REG)) {// 先绝对匹配：yyyy-MM-dd HH:mm:ss:SSS
                return YEAR_TO_MSECOND.substring(0, (iLen > iRegLen) ? iRegLen : iLen);
            }
            if (matchesFormat(date, YEAR_TO_MSECOND_C_REG)) {// 包含匹配：yyyyMMddHHmmssSSS
                return YEAR_TO_MSECOND_C.substring(0, (iLen > iRegLen) ? iRegLen : iLen);
            }
            if (matchesFormat(date, YEAR_TO_MSECOND_T_REG)) {// 包含匹配：yyyy-MM-dd HH:mm:ss.SSS
                return YEAR_TO_MSECOND_T.substring(0, (iLen > iRegLen) ? iRegLen : iLen);
            }
        } catch (Throwable ex) {
            LOG.warn("获取格式异常，采用默认格式：" + YEAR_MOUTH_DAY, ex);
        }
        return YEAR_MOUTH_DAY;
    }
    
    /**
     * 匹配日期是否符合指定格式
     * 
     * @param date 日期
     * @param reg 正则表达式格式
     * @return 是否符合指定格式
     */
    
    private static boolean matchesFormat(String date, String reg) {
        Pattern pattern = Pattern.compile(reg);
        Matcher matcher = pattern.matcher(date);
        return matcher.matches();
    }
    
    /*** yyyy-MM-dd HH:mm:ss:SSS */
    public static final String YEAR_TO_MSECOND_REG = "^\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}:\\d{0,}";
    
    /*** yyyyMMddHHmmssSSS */
    public static final String YEAR_TO_MSECOND_C_REG = "^\\d{4}\\d{2}\\d{0,2}\\d{0,2}\\d{0,2}\\d{0,2}\\d{0,}";
    
    /*** yyyy-MM-dd HH:mm:ss.SSS */
    public static final String YEAR_TO_MSECOND_T_REG = "^\\d{4}-{0,1}\\d{0,2}-{0,1}\\d{0,2} {0,1}\\d{0,2}:{0,1}\\d{0,2}:{0,1}\\d{0,2}[.]{0,1}\\d{0,}";
}
