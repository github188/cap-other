/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.meeting.model;

import com.comtop.cap.runtime.base.model.CapBaseVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;
import javax.persistence.Column;


/**
 * TestQuery
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-5-30 CAP超级管理员
 */
@DataTransferObject
public class TestQueryVO extends CapBaseVO {

    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 主键ID */
    @Column(name = "ID",length=50,precision=0)
    private String id;
    
    /** 名称 */
    @Column(name = "NAME",length=50,precision=0)
    private String name;
    
    /** 车牌号 */
    @Column(name = "CARNUMBER",length=50,precision=0)
    private String carnumber;
    
    /** 型号 */
    @Column(name = "MODEL",length=50,precision=0)
    private String model;
    
    /** 流程实例id */
    @Column(name = "PROCESS_INS_ID",length=50,precision=0)
    private String processInsId;
    
    /** 流程状态 */
    @Column(name = "FLOW_STATE",precision=0)
    private Integer flowState;
    
    /** 车库id */
    @Column(name = "CARSTORAGEID",length=40,precision=0)
    private String carstorageid;
    
    /** 价格 */
    @Column(name = "PRICE",precision=10)
    private Double price;
    
	
    /**
     * @return 获取 主键ID 属性值
     */
    public String getId() {
        return id;
    }
    	
    /**
     * @param id 设置 主键ID 属性值为参数值 id
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
     * @return 获取 车牌号 属性值
     */
    public String getCarnumber() {
        return carnumber;
    }
    	
    /**
     * @param carnumber 设置 车牌号 属性值为参数值 carnumber
     */
    public void setCarnumber(String carnumber) {
        this.carnumber = carnumber;
    }
    
    /**
     * @return 获取 型号 属性值
     */
    public String getModel() {
        return model;
    }
    	
    /**
     * @param model 设置 型号 属性值为参数值 model
     */
    public void setModel(String model) {
        this.model = model;
    }
    
    /**
     * @return 获取 流程实例id 属性值
     */
    public String getProcessInsId() {
        return processInsId;
    }
    	
    /**
     * @param processInsId 设置 流程实例id 属性值为参数值 processInsId
     */
    public void setProcessInsId(String processInsId) {
        this.processInsId = processInsId;
    }
    
    /**
     * @return 获取 流程状态 属性值
     */
    public Integer getFlowState() {
        return flowState;
    }
    	
    /**
     * @param flowState 设置 流程状态 属性值为参数值 flowState
     */
    public void setFlowState(Integer flowState) {
        this.flowState = flowState;
    }
    
    /**
     * @return 获取 车库id 属性值
     */
    public String getCarstorageid() {
        return carstorageid;
    }
    	
    /**
     * @param carstorageid 设置 车库id 属性值为参数值 carstorageid
     */
    public void setCarstorageid(String carstorageid) {
        this.carstorageid = carstorageid;
    }
    
    /**
     * @return 获取 价格 属性值
     */
    public Double getPrice() {
        return price;
    }
    	
    /**
     * @param price 设置 价格 属性值为参数值 price
     */
    public void setPrice(Double price) {
        this.price = price;
    }
    
	 
}