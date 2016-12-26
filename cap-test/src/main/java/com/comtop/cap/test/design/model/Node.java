/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.design.model;

import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlTransient;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;

/**
 * 节点
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年6月23日 lizhongwen
 */
@XmlTransient
public abstract class Node extends BaseMetadata {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 节点标识 */
    private String id;
    
    /** x轴坐标 */
    private Float x;
    
    /** y轴坐标 */
    private Float y;
    
    /**
     * @return 获取 id属性值
     */
    @XmlAttribute(name = "id")
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
     * @return 获取 x属性值
     */
    @XmlAttribute(name = "x")
    public Float getX() {
        return x;
    }
    
    /**
     * @param x 设置 x 属性值为参数值 x
     */
    public void setX(Float x) {
        this.x = x;
    }
    
    /**
     * @return 获取 y属性值
     */
    @XmlAttribute(name = "y")
    public Float getY() {
        return y;
    }
    
    /**
     * @param y 设置 y 属性值为参数值 y
     */
    public void setY(Float y) {
        this.y = y;
    }
    
}
