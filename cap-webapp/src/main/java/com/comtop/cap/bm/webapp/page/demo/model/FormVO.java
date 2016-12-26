/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.webapp.page.demo.model;

import java.util.Date;
import java.util.List;

import com.comtop.cap.runtime.base.model.CapWorkflowVO;

import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * FIXME 类注释信息(此标记由Eclipse自动生成,请填写注释信息删除此标记)
 *
 *
 * @author 作者
 * @since 1.0
 * @version 2015-6-5 作者
 */
@DataTransferObject
public class FormVO extends CapWorkflowVO {

	/** FIXME */
    private static final long serialVersionUID = 1641133614408662818L;

    /**
	 *
	 */
	private String code;

	/**
	 *
	 */
	private List<FormGrid1VO> outageDeviceTableList;

	/**
	 *
	 */
	private List<FormGrid2VO> requeryTableList;

	/**
	 * @return 获取 outageDeviceTableList属性值
	 */
	public List<FormGrid1VO> getOutageDeviceTableList() {
		return outageDeviceTableList;
	}

	/**
	 * @param outageDeviceTableList 设置 outageDeviceTableList 属性值为参数值 outageDeviceTableList
	 */
	public void setOutageDeviceTableList(List<FormGrid1VO> outageDeviceTableList) {
		this.outageDeviceTableList = outageDeviceTableList;
	}

	/**
	 * @return 获取 requeryTableList属性值
	 */
	public List<FormGrid2VO> getRequeryTableList() {
		return requeryTableList;
	}

	/**
	 * @param requeryTableList 设置 requeryTableList 属性值为参数值 requeryTableList
	 */
	public void setRequeryTableList(List<FormGrid2VO> requeryTableList) {
		this.requeryTableList = requeryTableList;
	}

	/**
	 * @return 获取 code属性值
	 */
	public String getCode() {
		return code;
	}

	/**
	 * @param code 设置 code 属性值为参数值 code
	 */
	public void setCode(String code) {
		this.code = code;
	}

	/**
	 * @return 获取 workPlanId属性值
	 */
	public String getWorkPlanId() {
		return workPlanId;
	}

	/**
	 * @param workPlanId 设置 workPlanId 属性值为参数值 workPlanId
	 */
	public void setWorkPlanId(String workPlanId) {
		this.workPlanId = workPlanId;
	}

	/**
	 * @return 获取 applyDate属性值
	 */
	public Date getApplyDate() {
		return applyDate;
	}

	/**
	 * @param applyDate 设置 applyDate 属性值为参数值 applyDate
	 */
	public void setApplyDate(Date applyDate) {
		this.applyDate = applyDate;
	}

	/**
	 * @return 获取 outageReasonType属性值
	 */
	public int getOutageReasonType() {
		return outageReasonType;
	}

	/**
	 * @param outageReasonType 设置 outageReasonType 属性值为参数值 outageReasonType
	 */
	public void setOutageReasonType(int outageReasonType) {
		this.outageReasonType = outageReasonType;
	}

	/**
	 * @return 获取 overhaulType属性值
	 */
	public int getOverhaulType() {
		return overhaulType;
	}

	/**
	 * @param overhaulType 设置 overhaulType 属性值为参数值 overhaulType
	 */
	public void setOverhaulType(int overhaulType) {
		this.overhaulType = overhaulType;
	}

	/**
	 * @return 获取 isNeedInside属性值
	 */
	public int getIsNeedInside() {
		return isNeedInside;
	}

	/**
	 * @param isNeedInside 设置 isNeedInside 属性值为参数值 isNeedInside
	 */
	public void setIsNeedInside(int isNeedInside) {
		this.isNeedInside = isNeedInside;
	}

	/**
	 * @return 获取 longTimeOutageReason属性值
	 */
	public int getLongTimeOutageReason() {
		return longTimeOutageReason;
	}

	/**
	 * @param longTimeOutageReason 设置 longTimeOutageReason 属性值为参数值 longTimeOutageReason
	 */
	public void setLongTimeOutageReason(int longTimeOutageReason) {
		this.longTimeOutageReason = longTimeOutageReason;
	}

	/**
	 * @return 获取 notTurnpowerReason属性值
	 */
	public Integer[] getNotTurnpowerReason() {
		return notTurnpowerReason;
	}

	/**
	 * @param notTurnpowerReason 设置 notTurnpowerReason 属性值为参数值 notTurnpowerReason
	 */
	public void setNotTurnpowerReason(Integer[] notTurnpowerReason) {
		this.notTurnpowerReason = notTurnpowerReason;
	}

	/**
	 * @return 获取 notInMonplanReason属性值
	 */
	public String getNotInMonplanReason() {
		return notInMonplanReason;
	}

	/**
	 * @param notInMonplanReason 设置 notInMonplanReason 属性值为参数值 notInMonplanReason
	 */
	public void setNotInMonplanReason(String notInMonplanReason) {
		this.notInMonplanReason = notInMonplanReason;
	}

	/**
	 * @return 获取 planPeopleId属性值
	 */
	public String getPlanPeopleId() {
		return planPeopleId;
	}

	/**
	 * @param planPeopleId 设置 planPeopleId 属性值为参数值 planPeopleId
	 */
	public void setPlanPeopleId(String planPeopleId) {
		this.planPeopleId = planPeopleId;
	}

	/**
	 * @return 获取 planPeopleName属性值
	 */
	public String getPlanPeopleName() {
		return planPeopleName;
	}

	/**
	 * @param planPeopleName 设置 planPeopleName 属性值为参数值 planPeopleName
	 */
	public void setPlanPeopleName(String planPeopleName) {
		this.planPeopleName = planPeopleName;
	}

	/**
	 * @return 获取 planDepartmentId属性值
	 */
	public String getPlanDepartmentId() {
		return planDepartmentId;
	}

	/**
	 * @param planDepartmentId 设置 planDepartmentId 属性值为参数值 planDepartmentId
	 */
	public void setPlanDepartmentId(String planDepartmentId) {
		this.planDepartmentId = planDepartmentId;
	}

	/**
	 * @return 获取 planDepartmentName属性值
	 */
	public String getPlanDepartmentName() {
		return planDepartmentName;
	}

	/**
	 * @param planDepartmentName 设置 planDepartmentName 属性值为参数值 planDepartmentName
	 */
	public void setPlanDepartmentName(String planDepartmentName) {
		this.planDepartmentName = planDepartmentName;
	}

	/**
	 * 
	 */
	private String workPlanId;

	/**
	 * 
	 */
	private Date applyDate;

	/**
	 * 
	 */
	private int outageReasonType;

	/**
	 * 
	 */
	private int overhaulType;

	/**
	 * 
	 */
	private int isNeedInside;

	/**
	 * 
	 */
	private int longTimeOutageReason;

	/**
	 * 
	 */
	private Integer[] notTurnpowerReason;

	/**
	 * 
	 */
	private String notInMonplanReason;

	/**
	 * 
	 */
	private String planPeopleId;

	/**
	 * 
	 */
	private String planPeopleName;

	/**
	 * 
	 */
	private String planDepartmentId;

	/**
	 * 
	 */
	private String planDepartmentName;


	/** 
	 *
	 * @return xx
	 *		
	 * @see com.comtop.cap.runtime.base.model.CapWorkflowVO#getProcessInsId()
	 */
	@Override
	public String getProcessInsId() {
		// TODO 自动生成方法存根注释，方法实现时请删除此注释
		return null;
	}

	/** 
	 * @param processInsId xx
	 *		 
	 * @see com.comtop.cap.runtime.base.model.CapWorkflowVO#setProcessInsId(java.lang.String)
	 */
	@Override
	public void setProcessInsId(String processInsId) {
		// TODO 自动生成方法存根注释，方法实现时请删除此注释
		
	}

	/** 
	 * @return xx
	 *		
	 * @see com.comtop.cap.runtime.base.model.CapWorkflowVO#getFlowState()
	 */
	@Override
	public Integer getFlowState() {
		// TODO 自动生成方法存根注释，方法实现时请删除此注释
		return null;
	}

	/** 
	 *
	 * @param flowState xx
	 *		
	 * @see com.comtop.cap.runtime.base.model.CapWorkflowVO#setFlowState(java.lang.Integer)
	 */
	@Override
	public void setFlowState(Integer flowState) {
		// TODO 自动生成方法存根注释，方法实现时请删除此注释
		
	}


}
