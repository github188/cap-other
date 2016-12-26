/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docmodel.style;

import org.openxmlformats.schemas.wordprocessingml.x2006.main.STBorder;

/**
 * 线型
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年10月19日 lizhongwen
 */
public enum LineStyle {
    /** 无边框 */
    NIL(STBorder.NIL),
    /** 单线 */
    SINGLE(STBorder.SINGLE),
    /** 点化线 */
    DOTTED(STBorder.DOTTED),
    /** 小间隔的端线 */
    DASH_SMALL_GAP(STBorder.DASH_SMALL_GAP),
    /** 虚线 */
    DASHED(STBorder.DASHED),
    /** 点化虚线 */
    DOT_DASH(STBorder.DOT_DASH),
    /** 双点化虚线 */
    DOT_DOT_DASH(STBorder.DOT_DOT_DASH),
    /** 双线 */
    DOUBLE(STBorder.DOUBLE),
    /** 三线 */
    TRIPLE(STBorder.TRIPLE),
    /** 小间隔的细粗线 */
    THIN_THICK_SMALL_GAP(STBorder.THIN_THICK_SMALL_GAP),
    /** 小间隔的粗细线 */
    THICK_THIN_SMALL_GAP(STBorder.THICK_THIN_SMALL_GAP),
    /** 小间隔的细粗粗线 */
    THIN_THICK_THIN_SMALL_GAP(STBorder.THIN_THICK_THIN_SMALL_GAP),
    /** 中等间隔的细粗线 */
    THIN_THICK_MEDIUM_GAP(STBorder.THIN_THICK_MEDIUM_GAP),
    /** 中等间隔的粗细线 */
    THICK_THIN_MEDIUM_GAP(STBorder.THICK_THIN_MEDIUM_GAP),
    /** 中等间隔的细粗粗线 */
    THIN_THICK_THIN_MEDIUM_GAP(STBorder.THIN_THICK_THIN_MEDIUM_GAP),
    /** 大间隔的细粗线 */
    THIN_THICK_LARGE_GAP(STBorder.THIN_THICK_LARGE_GAP),
    /** 大间隔的粗细线 */
    THICK_THIN_LARGE_GAP(STBorder.THICK_THIN_LARGE_GAP),
    /** 大间隔的细粗粗线 */
    THIN_THICK_THIN_LARGE_GAP(STBorder.THIN_THICK_THIN_LARGE_GAP),
    /** 波浪线 */
    WAVE(STBorder.WAVE),
    /** 双波浪线 */
    DOUBLE_WAVE(STBorder.DOUBLE_WAVE),
    /** dashDotStroked */
    DASH_DOT_STROKED(STBorder.DASH_DOT_STROKED),
    /** threeDEmboss */
    THREE_D_EMBOSS(STBorder.THREE_D_EMBOSS),
    /** threeDEngrave */
    THREE_D_ENGRAVE(STBorder.THREE_D_ENGRAVE);
    
    /** 边框值 */
    public STBorder.Enum value;
    
    /**
     * 构造函数
     * 
     * @param value 边框值
     */
    private LineStyle(STBorder.Enum value) {
        this.value = value;
    }
    
    /**
     * @return 获取 value属性值
     */
    public STBorder.Enum getValue() {
        return value;
    }
}
