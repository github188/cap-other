/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docmodel.style;

import static com.comtop.cap.document.word.util.MeasurementUnits.cmToEMU;

import java.math.BigInteger;

/**
 * 裁剪
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年10月29日 lizhongwen
 */
public class Rectify {
    
    /** 左边裁剪宽度，单位：厘米 */
    public Float left;
    
    /** 左边裁剪宽度,单位（EMU） */
    private BigInteger leftAsEMU;
    
    /** 上方裁剪宽度，单位：厘米 */
    public Float top;
    
    /** 上方裁剪宽度,单位（EMU） */
    private BigInteger topAsEMU;
    
    /** 右方裁剪宽度，单位：厘米 */
    public Float right;
    
    /** 右方裁剪宽度,单位（EMU） */
    private BigInteger rightAsEMU;
    
    /** 底部裁剪宽度，单位：厘米 */
    public Float bottom;
    
    /** 底部,单位（EMU） */
    private BigInteger bottomAsEMU;
    
    /**
     * @return 获取 left属性值
     */
    public Float getLeft() {
        return left;
    }
    
    /**
     * @param left 设置 left 属性值为参数值 left
     */
    public void setLeft(Float left) {
        this.left = left;
        this.leftAsEMU = BigInteger.valueOf(cmToEMU(left));
    }
    
    /**
     * @return 获取 top属性值
     */
    public Float getTop() {
        return top;
    }
    
    /**
     * @param top 设置 top 属性值为参数值 top
     */
    public void setTop(Float top) {
        this.top = top;
        this.topAsEMU = BigInteger.valueOf(cmToEMU(top));
    }
    
    /**
     * @return 获取 right属性值
     */
    public Float getRight() {
        return right;
    }
    
    /**
     * @param right 设置 right 属性值为参数值 right
     */
    public void setRight(Float right) {
        this.right = right;
        this.rightAsEMU = BigInteger.valueOf(cmToEMU(right));
    }
    
    /**
     * @return 获取 bottom属性值
     */
    public Float getBottom() {
        return bottom;
    }
    
    /**
     * @param bottom 设置 bottom 属性值为参数值 bottom
     */
    public void setBottom(Float bottom) {
        this.bottom = bottom;
        this.bottomAsEMU = BigInteger.valueOf(cmToEMU(bottom));
    }
    
    /**
     * @return 获取 leftAsEMU属性值
     */
    public BigInteger getLeftAsEMU() {
        return leftAsEMU;
    }
    
    /**
     * @return 获取 topAsEMU属性值
     */
    public BigInteger getTopAsEMU() {
        return topAsEMU;
    }
    
    /**
     * @return 获取 rightAsEMU属性值
     */
    public BigInteger getRightAsEMU() {
        return rightAsEMU;
    }
    
    /**
     * @return 获取 bottomAsEMU属性值
     */
    public BigInteger getBottomAsEMU() {
        return bottomAsEMU;
    }
    
    /**
     * 字符串
     * 
     * @see java.lang.Object#toString()
     */
    @Override
    public String toString() {
        StringBuilder builder = new StringBuilder();
        if (this.leftAsEMU != null) {
            builder.append("l=\"").append(this.leftAsEMU.intValue()).append("\" ");
        }
        if (this.topAsEMU != null) {
            builder.append("t=\"").append(this.topAsEMU.intValue()).append("\" ");
        }
        if (this.rightAsEMU != null) {
            builder.append("r=\"").append(this.rightAsEMU.intValue()).append("\" ");
        }
        if (this.bottomAsEMU != null) {
            builder.append("b=\"").append(this.bottomAsEMU.intValue()).append("\" ");
        }
        return builder.toString();
    }
    
}
