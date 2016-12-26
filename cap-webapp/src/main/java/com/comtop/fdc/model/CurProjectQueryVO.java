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
import javax.persistence.Column;
import java.sql.Timestamp;


/**
 * 项目分期查询实体
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-11-9 CAP超级管理员
 */
@DataTransferObject
public class CurProjectQueryVO extends CapBaseVO {

    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** id */
    private String id;
    
    /** 名称 */
    private String name;
    
    /** 编码 */
    private String number;
    
    /** 开发商id */
    @Column(name = "DEVELOPER_ID",length=50,precision=0)
    private String developerId;
    
    /** 创建时间 */
    @Column(name = "CREATE_TIME",precision=6)
    private Timestamp createTime;
    
	
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
    
    /**
     * @return 获取 开发商id 属性值
     */
    public String getDeveloperId() {
        return developerId;
    }
    	
    /**
     * @param developerId 设置 开发商id 属性值为参数值 developerId
     */
    public void setDeveloperId(String developerId) {
        this.developerId = developerId;
    }
    
    /**
     * @return 获取 创建时间 属性值
     */
    public Timestamp getCreateTime() {
        return createTime;
    }
    	
    /**
     * @param createTime 设置 创建时间 属性值为参数值 createTime
     */
    public void setCreateTime(Timestamp createTime) {
        this.createTime = createTime;
    }
    
	 
}