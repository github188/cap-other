/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docmodel.style;

import java.math.BigInteger;

/**
 * 边框
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年10月19日 lizhongwen
 */
public class Border {
    
    /** 线型 */
    private LineStyle type = LineStyle.SINGLE;
    
    /** 粗细 (单位：磅) */
    private Float thickness = 0.5f;
    
    /** 粗细基准 */
    private static final int THICKNESS_BASE = 8;
    
    /** 线条位置 */
    private BorderLocation loaction;
    
    /**
     * 构造函数
     */
    public Border() {
    }
    
    /**
     * 构造函数
     * 
     * @param type 线型
     */
    public Border(LineStyle type) {
        this.type = type;
    }
    
    /**
     * 构造函数
     * 
     * @param type 线型
     * @param loaction 线条位置
     */
    public Border(LineStyle type, BorderLocation loaction) {
        super();
        this.type = type;
        this.loaction = loaction;
    }
    
    /**
     * @return 获取 type属性值
     */
    public LineStyle getType() {
        return type;
    }
    
    /**
     * @param type 设置 type 属性值为参数值 type
     */
    public void setType(LineStyle type) {
        this.type = type;
    }
    
    /**
     * @return 获取 thickness属性值
     */
    public Float getThickness() {
        return thickness;
    }
    
    /**
     * @return 获取 thicknessWord属性值
     */
    public BigInteger getThicknessValue() {
        return BigInteger.valueOf((int) (thickness * THICKNESS_BASE));
    }
    
    /**
     * @param thickness 设置 thickness 属性值为参数值 thickness
     */
    public void setThickness(Float thickness) {
        this.thickness = thickness;
    }
    
    /**
     * @return 获取 loaction属性值
     */
    public BorderLocation getLoaction() {
        return loaction;
    }
    
    /**
     * @param loaction 设置 loaction 属性值为参数值 loaction
     */
    public void setLoaction(BorderLocation loaction) {
        this.loaction = loaction;
    }
}
