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
import com.comtop.cap.runtime.base.annotation.AssociateAttribute;
import java.util.List;
import java.sql.Clob;
import javax.persistence.Id;
import java.sql.Timestamp;
import com.comtop.fdc.model.HouseVO;
import java.sql.Blob;


/**
 * 小区
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-12-1 CAP超级管理员
 */
@Table(name = "T_FDC_AREA")
@DataTransferObject
public class AreaVO extends CapBaseVO {

    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 主键 */
    @Id
    @Column(name = "ID",length=50,precision=0)
    private String id;
    
    /** 名称 */
    @Column(name = "NAME",length=50,precision=0)
    private String name;
    
    /** 编码 */
    @Column(name = "FNUMBER",length=50,precision=0)
    private String fnumber;
    
    /** 开发商id */
    @Column(name = "DEVELOPER_ID",length=50,precision=0)
    private String developerId;
    
    /** 创建时间 */
    @Column(name = "CREATE_TIME",precision=6)
    private Timestamp createTime;
    
    /** 面积 */
    @Column(name = "FSIZE",precision=2)
    private Double fsize;
    
    /** 业务日期 */
    @Column(name = "BIZDATE",precision=0)
    private Timestamp bizdate;
    
    /** 状态 */
    @Column(name = "STATE",precision=0)
    private Integer state;
    
    /** 人口 */
    @Column(name = "PEPOLES",precision=0)
    private Integer pepoles;
    
    /** 大字段 */
    @Column(name = "COL_BLOB",precision=0)
    private Blob colBlob;
    
    /** 大字段 */
    @Column(name = "COL_CLOB",precision=0)
    private Clob colClob;
    
    /** 级别 */
    @Column(name = "AREA_LEVEL",precision=0)
    private Integer areaLevel;
    
    /** 金额 */
    @Column(name = "AMOUNT",precision=0)
    private Integer amount;
    
    /** jine */
    @Column(name = "BILL",precision=0)
    private Integer bill;
    
    /** areaId */
    @AssociateAttribute(multiple = "One-Many", associateFieldName = "areaId")
    private List<HouseVO> relationAreaId;
    
	
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
    
    /**
     * @return 获取 面积 属性值
     */
    public Double getFsize() {
        return fsize;
    }
    	
    /**
     * @param fsize 设置 面积 属性值为参数值 fsize
     */
    public void setFsize(Double fsize) {
        this.fsize = fsize;
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
     * @return 获取 状态 属性值
     */
    public Integer getState() {
        return state;
    }
    	
    /**
     * @param state 设置 状态 属性值为参数值 state
     */
    public void setState(Integer state) {
        this.state = state;
    }
    
    /**
     * @return 获取 人口 属性值
     */
    public Integer getPepoles() {
        return pepoles;
    }
    	
    /**
     * @param pepoles 设置 人口 属性值为参数值 pepoles
     */
    public void setPepoles(Integer pepoles) {
        this.pepoles = pepoles;
    }
    
    /**
     * @return 获取 大字段 属性值
     */
    public Blob getColBlob() {
        return colBlob;
    }
    	
    /**
     * @param colBlob 设置 大字段 属性值为参数值 colBlob
     */
    public void setColBlob(Blob colBlob) {
        this.colBlob = colBlob;
    }
    
    /**
     * @return 获取 大字段 属性值
     */
    public Clob getColClob() {
        return colClob;
    }
    	
    /**
     * @param colClob 设置 大字段 属性值为参数值 colClob
     */
    public void setColClob(Clob colClob) {
        this.colClob = colClob;
    }
    
    /**
     * @return 获取 级别 属性值
     */
    public Integer getAreaLevel() {
        return areaLevel;
    }
    	
    /**
     * @param areaLevel 设置 级别 属性值为参数值 areaLevel
     */
    public void setAreaLevel(Integer areaLevel) {
        this.areaLevel = areaLevel;
    }
    
    /**
     * @return 获取 金额 属性值
     */
    public Integer getAmount() {
        return amount;
    }
    	
    /**
     * @param amount 设置 金额 属性值为参数值 amount
     */
    public void setAmount(Integer amount) {
        this.amount = amount;
    }
    
    /**
     * @return 获取 jine 属性值
     */
    public Integer getBill() {
        return bill;
    }
    	
    /**
     * @param bill 设置 jine 属性值为参数值 bill
     */
    public void setBill(Integer bill) {
        this.bill = bill;
    }
    
    /**
     * @return 获取 areaId 属性值
     */
    public List<HouseVO> getRelationAreaId() {
        return relationAreaId;
    }
    	
    /**
     * @param relationAreaId 设置 areaId 属性值为参数值 relationAreaId
     */
    public void setRelationAreaId(List<HouseVO> relationAreaId) {
        this.relationAreaId = relationAreaId;
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