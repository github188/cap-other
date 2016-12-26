/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.util;

import java.math.BigInteger;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.util.Locale;

/**
 * 单位
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年10月26日 lizhongwen
 */
public class MeasurementUnits {
    
    /** 浮点数格式化 */
    public final static DecimalFormat format;
    
    /** SCALE基准 */
    public final static float SCALE_BASE = 100f;
    
    /** DPI 默认基准 */
    public final static int DPI = 96;
    
    /** 缇转换为像素 分辨率基准 */
    public static final int TWIP_2_EMU = 635;
    
    /** 英寸转换为缇 基准 */
    public static final float INCH_2_TWIP = 1440f;
    
    /** 缇转换为毫米基准 */
    public static final float TWIP_2_MM = 56.6928f;
    
    /** 缇转换为磅（打印机的一个点）基准 */
    public static final float TWIP_2_POINT = 20f;
    
    /** 厘米转换为毫米 */
    public static final float CM_2_MM = 10f;
    
    /** 厘米转换为PX */
    public static final float CM_2_PX = 37.795276f;
    
    /** 厘米值转换为EMU基准 */
    public static final int CM_2_EMU = 360000;
    
    /** 英寸值转换为EMU基准 */
    public static final int INCH_2_EMU = 914400;
    
    /** 英寸值转换为毫米基准 */
    public static final float INCH_2_MM = 25.4f;
    
    /** 英寸值转换为PT(绝对长度单位。点（Point）。)基准 */
    public static final float INCH_2_PT = 72;
    
    // 初始化浮点数格式化
    static {
        format = new DecimalFormat("##.##", new DecimalFormatSymbols(Locale.ENGLISH));
    }
    
    /**
     * 构造函数
     */
    private MeasurementUnits() {
    }
    
    /**
     * 缇转换为EMU(English Metric Units,英制度量单位)
     *
     * @param twips 「Twip」中文译为"缇"，是一种和屏幕无关的长度单位,目的是为了让应用程序元素输出到不同设备时都能保持一致的计算方式。
     * @return EMU(English Metric Units,英制度量单位)
     */
    public static long twipToEMU(double twips) {
        return Math.round(TWIP_2_EMU * twips);
    }
    
    /**
     * 英寸转换为缇
     *
     * @param inch 英寸
     * @return 「Twip」缇
     */
    public static int inchToTwip(float inch) {
        // 1440 twip = 1 inch;
        return Math.round(inch * INCH_2_TWIP);
    }
    
    /**
     * 缇转换为英寸
     *
     * @param twip 「Twip」中文译为"缇"，是一种和屏幕无关的长度单位
     * @return 英寸
     */
    public static float twipToInch(int twip) {
        return twip / INCH_2_TWIP;
    }
    
    /**
     * 缇转换为毫米
     *
     * @param twip 「Twip」中文译为"缇"，是一种和屏幕无关的长度单位
     * @return 毫米
     */
    public static float twipToMm(int twip) {
        return twip / TWIP_2_MM;
    }
    
    /**
     * 毫米转换为缇
     *
     * @param mm 毫米
     * @return 「Twip」中文译为"缇"，是一种和屏幕无关的长度单位
     */
    public static int mmToTwip(float mm) {
        return inchToTwip(mmToInch(mm));
    }
    
    /**
     * 毫米转换为英寸
     *
     * @param mm 毫米
     * @return 「Twip」中文译为"缇"，是一种和屏幕无关的长度单位
     */
    public static float mmToInch(float mm) {
        return mm / INCH_2_MM;
    }
    
    /**
     * 英寸转毫米
     *
     * @param inch 英寸
     * @return 「mm」中文译为"mm"
     */
    public static float inch2mm(float inch) {
        return inch * INCH_2_MM;
    }
    
    /**
     * 缇转换为磅（打印机的一个点）
     *
     * @param twip 「Twip」中文译为"缇"，是一种和屏幕无关的长度单位
     * @return 磅（打印机的一个点）
     */
    public static float twipToPoint(int twip) {
        return twip / TWIP_2_POINT;
    }
    
    /**
     * 
     * 磅（打印机的一个点）转换为缇
     *
     * @param point 磅（打印机的一个点）
     * @return 「Twip」中文译为"缇"，是一种和屏幕无关的长度单位
     */
    public static int pointToTwip(float point) {
        return Math.round(TWIP_2_POINT * point);
    }
    
    /**
     * 像素转换为缇
     *
     * @param px 像素
     * @return 「Twip」中文译为"缇"，是一种和屏幕无关的长度单位
     */
    public static int pxToTwip(float px) {
        float inch = px / DPI;
        return inchToTwip(inch);
    }
    
    /**
     * 像素转换为缇
     *
     * @param px 像素
     * @return 「Twip」中文译为"缇"，是一种和屏幕无关的长度单位
     */
    public static float px2cm(float px) {
        return px / CM_2_PX;
    }
    
    /**
     * 毫米转换为厘米
     *
     * @param mm 毫米
     * @return 厘米
     */
    public static float mm2cm(float mm) {
        return mm / CM_2_MM;
    }
    
    /**
     * 厘米转换为毫米
     *
     * @param cm 厘米
     * @return 毫米
     */
    public static float cmToMM(float cm) {
        return cm * CM_2_MM;
    }
    
    /**
     * 厘米转换为Twip(缇)
     *
     * @param cm 厘米
     * @return 「Twip」中文译为"缇"，是一种和屏幕无关的长度单位
     */
    public static int cmToTwip(float cm) {
        return inchToTwip(mmToInch(cmToMM(cm)));
    }
    
    /**
     * 厘米值转换为EMU(English Metric Units,英制度量单位)
     *
     * @param cm 厘米
     * @return EMU(English Metric Units,英制度量单位)
     */
    public static int cmToEMU(float cm) {
        return Math.round(cm * CM_2_EMU);
    }
    
    /**
     * 厘米值转换为EMU(English Metric Units,英制度量单位)
     *
     * @param emu emu
     * @return EMU(English Metric Units,英制度量单位)
     */
    public static float emuToCm(long emu) {
        return Math.round(emu / (CM_2_EMU * 1f));
    }
    
    /**
     * 英寸值转换为EMU(English Metric Units,英制度量单位)
     *
     * @param inch 英寸
     * @return EMU(English Metric Units,英制度量单位)
     */
    public static int inchToEMU(float inch) {
        return Math.round(inch * INCH_2_EMU);
    }
    
    /**
     * 英寸值转换为PT(绝对长度单位。点（Point）)
     *
     * @param cm 厘米
     * @return pt绝对长度单位。点（Point）
     */
    public static float cmToPT(float cm) {
        float pt = mmToInch(cmToMM(cm)) * INCH_2_PT;
        return Math.round(pt * SCALE_BASE) / SCALE_BASE;
    }
    
    /**
     * 英寸值转换为PT(绝对长度单位。点（Point）)
     *
     * @param pt pt
     * @return pt绝对长度单位。点（Point）
     */
    public static float pt2cm(float pt) {
        float inch = Math.round(pt * SCALE_BASE) / SCALE_BASE / INCH_2_PT;
        return mm2cm(inch2mm(inch));
        
    }
    
    /**
     * DAX转换为毫米
     *
     * @param dxa dxa
     * @return float
     */
    public static float dxa2mm(float dxa) {
        return (float) (dxa2inch(dxa) * 25.4);
    }
    
    /**
     * DAX转换为毫米
     *
     * @param dxa dxa
     * @return float
     */
    public static float dxa2mm(BigInteger dxa) {
        return (float) (dxa2inch(dxa) * 25.4);
    }
    
    /**
     * EMU转换为点
     *
     * @param emu dxa
     * @return float
     */
    public static float emu2points(long emu) {
        return dxa2points(emu) / 635;
    }
    
    /**
     * DAX转换为点
     *
     * @param dxa dxa
     * @return float
     */
    public static float dxa2points(float dxa) {
        return dxa / 20;
    }
    
    /**
     * DAX转换为点
     *
     * @param dxa dxa
     * @return float
     */
    public static int dxa2points(int dxa) {
        return dxa / 20;
    }
    
    /**
     * DAX转换为点
     *
     * @param dxa dxa
     * @return float
     */
    public static float dxa2points(BigInteger dxa) {
        return dxa.intValue() / 20;
    }
    
    /**
     * DAX转换为英寸
     *
     * @param dxa dxa
     * @return float
     */
    public static float dxa2inch(float dxa) {
        return dxa2points(dxa) / 72;
    }
    
    /**
     * DAX转换为英寸
     *
     * @param dxa dxa
     * @return float
     */
    public static float dxa2inch(BigInteger dxa) {
        return dxa2points(dxa) / 72;
    }
}
