/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.report.domain;

/**
 * 系统模块对象
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年9月27日 lizhongwen
 */
public class Module {
    
    /** Id */
    private String id;
    
    /** 名称 */
    private String name;
    
    /** 全路径 */
    private String fullPath;
    
    /**
     * 构造函数
     */
    public Module() {
        super();
    }
    
    /**
     * 构造函数
     * 
     * @param id Id
     * @param name 名称
     * @param fullPath 全路径
     */
    public Module(String id, String name, String fullPath) {
        super();
        this.id = id;
        this.name = name;
        this.fullPath = fullPath;
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
     * @return 获取 name属性值
     */
    public String getName() {
        return name;
    }
    
    /**
     * @param name 设置 name 属性值为参数值 name
     */
    public void setName(String name) {
        this.name = name;
    }
    
    /**
     * @return 获取 fullPath属性值
     */
    public String getFullPath() {
        return fullPath;
    }
    
    /**
     * @param fullPath 设置 fullPath 属性值为参数值 fullPath
     */
    public void setFullPath(String fullPath) {
        this.fullPath = fullPath;
    }
}
