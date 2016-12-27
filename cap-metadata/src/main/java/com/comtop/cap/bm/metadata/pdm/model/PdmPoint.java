/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.pdm.model;

/**
 * Created by duqi on 2016/2/24.
 */
public class PdmPoint {
    /** 横向坐标 */
    private int x;
    /** 垂直坐标 */
    private int y;

    /**
     * 构造
     * @param x 横向坐标
     * @param y 垂直坐标
     */
    public PdmPoint(int x, int y) {
        this.x = x;
        this.y = y;
    }

    /**
     * @return 获取 x属性值
     */
    public int getX() {
        return x;
    }

    /**
     * @param x 设置 x 属性值为参数值 x
     */
    public void setX(int x) {
        this.x = x;
    }

    /**
     * @return 获取 y属性值
     */
    public int getY() {
        return y;
    }

    /**
     * @param y 设置 y 属性值为参数值 y
     */
    public void setY(int y) {
        this.y = y;
    }
}
