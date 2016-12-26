/******************************************************************************
 * Copyright (C) 2012 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression.util;

import java.math.BigDecimal;

import com.comtop.cap.document.expression.annotation.Function;

/**
 * CAP文档管理，表达式函数，数值处理工具类
 *
 * @author 李小强
 * @since 1.0
 * @version 2015年11月19日 李小强
 */
public final class DocMathUtils {
    /**
     * 精确到小数点以后10位，以后的数字四舍五入。
     */
    private static final int DEF_DIV_SCALE = 10;   //
    /**
     * 私有化构造函数
     */
    private DocMathUtils() {
    }

    /**
     *将BigDecimal类型转换成int类型 如果value为null，直接返回0
     *
     * @param value 待转换的源数据
     * @return 转换后的数据信息
     */
    @Function(name = "MathUtils_bigDecimal2int", description = "将BigDecimal类型转换成int类型 如果value为null，直接返回0")
    public static int bigDecimal2int(BigDecimal value) {
        if (value == null) {
            return 0;
        }
        return value.intValue();
    }

    /**
     *将int转换成BigDecimal类型
     * @param value 待转换的源数据
     * @return 转换后的数据信息
     */
    @Function(name = "MathUtils_int2BigDecimal", description = "将int转换成BigDecimal类型")
    public static BigDecimal int2BigDecimal(int value) {
        return BigDecimal.valueOf(value);
    }
    
    /**
     *将BigDecimal类型转换成Integer类型 如果value为null，直接返回null
     *
     * @param value 待转换的源数据
     * @return 转换后的数据信息
     */
    @Function(name = "MathUtils_bigDecimal2Integer", description = "将BigDecimal类型转换成Integer类型 如果value为null，直接返回null")
    public static Integer bigDecimal2Integer(BigDecimal value) {
        if (value == null) {
            return null;
        }
        return Integer.valueOf(value.intValue());
    }

    /**
     *将Integer类型转换成BigDecimal类型 如果value为null，直接返回null
     *
     * @param value 待转换的源数据
     * @return 转换后的数据信息
     */
    @Function(name = "MathUtils_integer2BigDecimal", description = "将Integer类型转换成BigDecimal类型 如果value为null，直接返回null")
    public static BigDecimal integer2BigDecimal(Integer value) {
        if (value == null) {
            return null;
        }
        return BigDecimal.valueOf(value.intValue());
    }


    /**
     * 提供精确的加法运算。
     * @param v1 被加数
     * @param v2 加数
     * @return 两个参数的和
     * @author 李小强2013-01-09
     */
    @Function(name = "MathUtils_doubleAdd", description = "提供精确的double加法运算")
    public static double add(double v1, double v2) {
        BigDecimal objBe1 = new BigDecimal(Double.toString(v1));
        BigDecimal objBe2 = new BigDecimal(Double.toString(v2));
        return objBe1.add(objBe2).doubleValue();
    }

    /**
     * 提供精确的减法运算。
     * @param v1 被减数
     * @param v2 减数
     * @return 两个参数的差
     * @author 李小强 2013-01-09
     */
    @Function(name = "MathUtils_doubleSub", description = "提供精确的double减法运算")
    public static double sub(double v1, double v2) {
        BigDecimal objBe1 = new BigDecimal(Double.toString(v1));
        BigDecimal objBe2 = new BigDecimal(Double.toString(v2));
        return objBe1.subtract(objBe2).doubleValue();
    }

    /**
     * 提供精确的乘法运算。
     * @param v1 被乘数
     * @param v2 乘数
     * @return 两个参数的积
     * @author 李小强 2013-01-09
     */
    @Function(name = "MathUtils_doubleMul", description = "提供精确的double减法运算")
    public static double mul(double v1, double v2) {
        BigDecimal objBe1 = new BigDecimal(Double.toString(v1));
        BigDecimal objBe2 = new BigDecimal(Double.toString(v2));
        return objBe1.multiply(objBe2).doubleValue();
    }

    /**
     * 提供（相对）精确的除法运算，当发生除不尽的情况时，精确到小数点以后10位，以后的数字四舍五入。
     * @param v1 被除数
     * @param v2 除数
     * @return 两个参数的商
     * @author 李小强2013-01-09
     */
    @Function(name = "MathUtils_doubleDiv", description = "提供（相对）精确的除法运算，当发生除不尽的情况时，精确到小数点以后10位，以后的数字四舍五入。")
    public static double div(double v1, double v2) {
        return div(v1, v2, DEF_DIV_SCALE);
    }

    /**
     * 提供（相对）精确的除法运算。<br/>
     * 当发生除不尽的情况时，由scale参数指 定精度，以后的数字四舍五入。
     * @param v1 被除数
     * @param v2 除数
     * @param scale 表示表示需要精确到小数点以后几位。
     * @return 两个参数的商  ,如果scale小于0，则抛出The scale must be a positive integer or zero错误
     * @author 李小强2013-01-09
     */
    @Function(name = "MathUtils_doubleDivScale", description = "提供（相对）精确的除法运算，当发生除不尽的情况时，由scale参数指 定精度，以后的数字四舍五入")
    public static double div(double v1, double v2, int scale) {
        BigDecimal objBe1 = new BigDecimal(Double.toString(v1));
        BigDecimal objBe2 = new BigDecimal(Double.toString(v2));
        return objBe1.divide(objBe2, scale, BigDecimal.ROUND_HALF_UP).doubleValue();
    }

    /**
     * 四舍五入<br/>
     * 提供精确的小数位四舍五入处理。
     * @param v 需要四舍五入的数字
     * @param scale 小数点后保留几位
     * @return 四舍五入后的结果  ,如果scale小于0，则抛出The scale must be a positive integer or zero错误
     * @author 李小强 2013-01-09
     */
    @Function(name = "MathUtils_doubleRound", description = "四舍五入,提供精确的小数位四舍五入处理")
    public static double round(double v, int scale) {
      
        BigDecimal objBe = new BigDecimal(Double.toString(v));
        BigDecimal objBeone =  BigDecimal.ONE;
        return objBe.divide(objBeone, scale, BigDecimal.ROUND_HALF_UP).doubleValue();
    }
}
