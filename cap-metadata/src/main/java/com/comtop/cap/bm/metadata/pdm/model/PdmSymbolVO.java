/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.pdm.model;

import com.comtop.cap.bm.metadata.pdm.util.AtomicIntegerUtils;

/**
 * Created by duqi on 2016/2/23.
 */
public class PdmSymbolVO {

    /** id */
    private String id;
    /** 起始x坐标 */
    private int startX;
    /** 起始y坐标 */
    private int startY;
    /** 结束x坐标 */
    private int endX;
    /** 结束y坐标 */
    private int endY;

    /**
     * 默认构造
     */
    public PdmSymbolVO(){
        id = AtomicIntegerUtils.getLocalID();
    }

    /**
     * 重载函数
     * @return rect字符串
     */
    @Override
    public String toString() {
        return "((" + startX + "," + startY + "), (" + endX + "," + endY + "))";
    }

    /**
     * @return 获取 id属性值
     */
    public String getId() {
        return id;
    }

    /**
     * @param id 设置 id 属性值为参数值 id
     */
    public void setId(String id) {
        this.id = id;
    }

    /**
     * @return 获取 startX属性值
     */
    public int getStartX() {
        return startX;
    }

    /**
     * @param startX 设置 startX 属性值为参数值 startX
     */
    public void setStartX(int startX) {
        this.startX = startX;
    }

    /**
     * @return 获取 startY属性值
     */
    public int getStartY() {
        return startY;
    }

    /**
     * @param startY 设置 startY 属性值为参数值 startY
     */
    public void setStartY(int startY) {
        this.startY = startY;
    }

    /**
     * @return 获取 endX属性值
     */
    public int getEndX() {
        return endX;
    }

    /**
     * @param endX 设置 endX 属性值为参数值 endX
     */
    public void setEndX(int endX) {
        this.endX = endX;
    }

    /**
     * @return 获取 endY属性值
     */
    public int getEndY() {
        return endY;
    }

    /**
     * @param endY 设置 endY 属性值为参数值 endY
     */
    public void setEndY(int endY) {
        this.endY = endY;
    }

}
