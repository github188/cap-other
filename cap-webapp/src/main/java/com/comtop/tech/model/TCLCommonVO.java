/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.tech.model;

import com.comtop.cap.runtime.base.model.CapBaseVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;


/**
 * 科技通用实体
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-12-2 CAP超级管理员
 */
@DataTransferObject
public class TCLCommonVO extends CapBaseVO {

    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 主键 */
    private String id;
    
    /** 名称 */
    private String name;
    
    /** 编码 */
    private String number;
    
    /** 测试 */
    private String test;
    
    /** 测试2 */
    private String test2;
    
    /** 测试3 */
    private String test3;
    
	
    /**
     * @return 获取 主键 属性值
     */
    public String getId() {
        return id;
    }
    	
    /**
     * @param id 设置 主键 属性值为参数值 id
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
    
    /**
     * @return 获取 测试 属性值
     */
    public String getTest() {
        return test;
    }
    	
    /**
     * @param test 设置 测试 属性值为参数值 test
     */
    public void setTest(String test) {
        this.test = test;
    }
    
    /**
     * @return 获取 测试2 属性值
     */
    public String getTest2() {
        return test2;
    }
    	
    /**
     * @param test2 设置 测试2 属性值为参数值 test2
     */
    public void setTest2(String test2) {
        this.test2 = test2;
    }
    
    /**
     * @return 获取 测试3 属性值
     */
    public String getTest3() {
        return test3;
    }
    	
    /**
     * @param test3 设置 测试3 属性值为参数值 test3
     */
    public void setTest3(String test3) {
        this.test3 = test3;
    }
    
	 
}