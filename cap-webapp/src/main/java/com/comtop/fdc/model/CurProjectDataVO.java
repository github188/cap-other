/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.fdc.model;

import com.comtop.cap.runtime.base.model.CapBaseVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;


/**
 * 项目分期数据实体
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-10-17 CAP超级管理员
 */
@DataTransferObject
public class CurProjectDataVO extends CapBaseVO {

    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** id */
    private String id;
    
    /** 名称 */
    private String name;
    
    /** 编码 */
    private String number;
    
	
    /**
     * @return 获取 id 属性值
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
     * @return 获取 名称 属性值
     */
    public String getName() {
        return name;
    }
    	
    /**
     * @param name 设置 名称 属性值为参数值 name
     */
    public void setName(String name) {
        this.name = name;
    }
    
    /**
     * @return 获取 编码 属性值
     */
	public String getNumber() {
        return number;
    }
    	
    /**
     * @param number 设置 编码 属性值为参数值 number
     */
	public void setNumber(String number) {
        this.number = number;
    }
    
	 
}