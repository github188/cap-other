/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.tech.model;

import com.comtop.cap.runtime.base.model.CapWorkflowVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;
import javax.persistence.Table;
import javax.persistence.Column;
import javax.persistence.Id;
import java.sql.Timestamp;


/**
 * 合同信息
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-11-29 CAP超级管理员
 */
@Table(name = "T_CT_CONTRACT")
@DataTransferObject
public class ContractVO extends CapWorkflowVO {

    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 主键 */
    @Id
    @Column(name = "ID",length=36,precision=0)
    private String id;
    
    /** 业务日期 */
    @Column(name = "BIZDATE",precision=6)
    private Timestamp bizdate;
    
    /** 合同编码 */
    @Column(name = "CONNUMBER",length=100,precision=0)
    private String connumber;
    
    /** 合同名称 */
    @Column(name = "NAME",length=50,precision=0)
    private String name;
    
    /** 合同类型 */
    @Column(name = "CONTRACT_TYPE",length=100,precision=0)
    private String contractType;
    
    /** 合同价格 */
    @Column(name = "PRICE",precision=2)
    private Double price;
    
    /** 甲方单位名称 */
    @Column(name = "PARTA_UNIT",length=100,precision=0)
    private String partaUnit;
    
    /** 甲方联系人 */
    @Column(name = "PARTA_CONTRACT",length=100,precision=0)
    private String partaContract;
    
    /** 乙方单位（建设单位） */
    @Column(name = "PARTB_UNIT",length=100,precision=0)
    private String partbUnit;
    
    /** 乙方联系人 */
    @Column(name = "PARTB_CONTRACT",length=100,precision=0)
    private String partbContract;
    
    /** 流程实例ID */
    @Column(name = "PROCESS_INS_ID",length=50,precision=0)
    private String processInsId;
    
    /** 流程状态 */
    @Column(name = "FLOW_STATE",precision=0)
    private Integer flowState;
    
	
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
     * @return 获取 合同编码 属性值
     */
    public String getConnumber() {
        return connumber;
    }
    	
    /**
     * @param connumber 设置 合同编码 属性值为参数值 connumber
     */
    public void setConnumber(String connumber) {
        this.connumber = connumber;
    }
    
    /**
     * @return 获取 合同名称 属性值
     */
    public String getName() {
        return name;
    }
    	
    /**
     * @param name 设置 合同名称 属性值为参数值 name
     */
    public void setName(String name) {
        this.name = name;
    }
    
    /**
     * @return 获取 合同类型 属性值
     */
    public String getContractType() {
        return contractType;
    }
    	
    /**
     * @param contractType 设置 合同类型 属性值为参数值 contractType
     */
    public void setContractType(String contractType) {
        this.contractType = contractType;
    }
    
    /**
     * @return 获取 合同价格 属性值
     */
    public Double getPrice() {
        return price;
    }
    	
    /**
     * @param price 设置 合同价格 属性值为参数值 price
     */
    public void setPrice(Double price) {
        this.price = price;
    }
    
    /**
     * @return 获取 甲方单位名称 属性值
     */
    public String getPartaUnit() {
        return partaUnit;
    }
    	
    /**
     * @param partaUnit 设置 甲方单位名称 属性值为参数值 partaUnit
     */
    public void setPartaUnit(String partaUnit) {
        this.partaUnit = partaUnit;
    }
    
    /**
     * @return 获取 甲方联系人 属性值
     */
    public String getPartaContract() {
        return partaContract;
    }
    	
    /**
     * @param partaContract 设置 甲方联系人 属性值为参数值 partaContract
     */
    public void setPartaContract(String partaContract) {
        this.partaContract = partaContract;
    }
    
    /**
     * @return 获取 乙方单位（建设单位） 属性值
     */
    public String getPartbUnit() {
        return partbUnit;
    }
    	
    /**
     * @param partbUnit 设置 乙方单位（建设单位） 属性值为参数值 partbUnit
     */
    public void setPartbUnit(String partbUnit) {
        this.partbUnit = partbUnit;
    }
    
    /**
     * @return 获取 乙方联系人 属性值
     */
    public String getPartbContract() {
        return partbContract;
    }
    	
    /**
     * @param partbContract 设置 乙方联系人 属性值为参数值 partbContract
     */
    public void setPartbContract(String partbContract) {
        this.partbContract = partbContract;
    }
    
    /**
     * @return 获取 流程实例ID 属性值
     */
    @Override
    public String getProcessInsId() {
        return processInsId;
    }
    	
    /**
     * @param processInsId 设置 流程实例ID 属性值为参数值 processInsId
     */
    @Override
    public void setProcessInsId(String processInsId) {
        this.processInsId = processInsId;
    }
    
    /**
     * @return 获取 流程状态 属性值
     */
    @Override
    public Integer getFlowState() {
        return flowState;
    }
    	
    /**
     * @param flowState 设置 流程状态 属性值为参数值 flowState
     */
    @Override
    public void setFlowState(Integer flowState) {
        this.flowState = flowState;
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