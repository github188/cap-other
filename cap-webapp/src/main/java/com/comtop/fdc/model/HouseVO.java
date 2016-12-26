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
import javax.persistence.Table;
import javax.persistence.Column;
import javax.persistence.Id;
import java.sql.Timestamp;


/**
 * 房屋
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-12-1 CAP超级管理员
 */
@Table(name = "T_FDC_HOUSE")
@DataTransferObject
public class HouseVO extends CapBaseVO {

    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 主键 */
    @Id
    @Column(name = "ID",length=50,precision=0)
    private String id;
    
    /** 房名 */
    @Column(name = "NAME",length=50,precision=0)
    private String name;
    
    /** 编码 */
    @Column(name = "FNUMBER",length=50,precision=0)
    private String fnumber;
    
    /** 区域ID */
    @Column(name = "AREA_ID",length=50,precision=0)
    private String areaId;
    
    /** 业务日期 */
    @Column(name = "BIZDATE",precision=6)
    private Timestamp bizdate;
    
	
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
     * @return 获取 房名 属性值
     */
    public String getName() {
        return name;
    }
    	
    /**
     * @param name 设置 房名 属性值为参数值 name
     */
    public void setName(String name) {
        this.name = name;
    }
    
    /**
     * @return 获取 编码 属性值
     */
    public String getFnumber() {
        return fnumber;
    }
    	
    /**
     * @param fnumber 设置 编码 属性值为参数值 fnumber
     */
    public void setFnumber(String fnumber) {
        this.fnumber = fnumber;
    }
    
    /**
     * @return 获取 区域ID 属性值
     */
    public String getAreaId() {
        return areaId;
    }
    	
    /**
     * @param areaId 设置 区域ID 属性值为参数值 areaId
     */
    public void setAreaId(String areaId) {
        this.areaId = areaId;
    }
    
    /**
     * @return 获取 业务日期 属性值
     */
    public Timestamp getBizdate() {
        return bizdate;
    }
    	
    /**
     * @param bizdate 设置 业务日期 属性值为参数值 bizdate
     */
    public void setBizdate(Timestamp bizdate) {
        this.bizdate = bizdate;
    }
    
	 
    /**
     * 获取主键值
     * @return 主键值
     */
    @Override
    public String getPrimaryValue(){
    		return  this.id;
    }
}