/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.carstorage.model;

import com.comtop.cap.runtime.base.model.CapWorkflowVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;
import javax.persistence.Table;
import javax.persistence.Column;
import javax.persistence.Id;
import java.sql.Timestamp;


/**
 * 费用报销单
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-9-12 CAP超级管理员
 */
@Table(name = "T_BC_BIZACCOUNT")
@DataTransferObject
public class BizaccountVO extends CapWorkflowVO {

    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 主键 */
    @Id
    @Column(name = "ID",length=50,precision=0)
    private String id;
    
    /** 报销金额 */
    @Column(name = "PAYAMOUNT",precision=4)
    private Double payamount;
    
    /** 报销事由 */
    @Column(name = "REMARK",length=100,precision=0)
    private String remark;
    
    /** 报销开始日期 */
    @Column(name = "STARTDATE",precision=0)
    private Timestamp startdate;
    
    /** 报销结束日期 */
    @Column(name = "ENDDATE",precision=0)
    private Timestamp enddate;
    
    /** 流程状态 */
    @Column(name = "FLOW_STATE",precision=0)
    private Integer flowState;
    
    /** 流程实例id */
    @Column(name = "PROCESS_INS_ID",length=50,precision=0)
    private String processInsId;
    
    /** 车库id */
    @Column(name = "CARSTORAGE_ID",length=20,precision=0)
    private String carstorageId;
    
	
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
     * @return 获取 报销金额 属性值
     */
    public Double getPayamount() {
        return payamount;
    }
    	
    /**
     * @param payamount 设置 报销金额 属性值为参数值 payamount
     */
    public void setPayamount(Double payamount) {
        this.payamount = payamount;
    }
    
    /**
     * @return 获取 报销事由 属性值
     */
    public String getRemark() {
        return remark;
    }
    	
    /**
     * @param remark 设置 报销事由 属性值为参数值 remark
     */
    public void setRemark(String remark) {
        this.remark = remark;
    }
    
    /**
     * @return 获取 报销开始日期 属性值
     */
    public Timestamp getStartdate() {
        return startdate;
    }
    	
    /**
     * @param startdate 设置 报销开始日期 属性值为参数值 startdate
     */
    public void setStartdate(Timestamp startdate) {
        this.startdate = startdate;
    }
    
    /**
     * @return 获取 报销结束日期 属性值
     */
    public Timestamp getEnddate() {
        return enddate;
    }
    	
    /**
     * @param enddate 设置 报销结束日期 属性值为参数值 enddate
     */
    public void setEnddate(Timestamp enddate) {
        this.enddate = enddate;
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
     * @return 获取 流程实例id 属性值
     */
    @Override
    public String getProcessInsId() {
        return processInsId;
    }
    	
    /**
     * @param processInsId 设置 流程实例id 属性值为参数值 processInsId
     */
    @Override
    public void setProcessInsId(String processInsId) {
        this.processInsId = processInsId;
    }
    
    /**
     * @return 获取 车库id 属性值
     */
    public String getCarstorageId() {
        return carstorageId;
    }
    	
    /**
     * @param carstorageId 设置 车库id 属性值为参数值 carstorageId
     */
    public void setCarstorageId(String carstorageId) {
        this.carstorageId = carstorageId;
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