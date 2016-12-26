/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.meeting.model;

import com.comtop.cap.runtime.base.model.CapWorkflowVO;

import comtop.org.directwebremoting.annotations.DataTransferObject;

import javax.persistence.Table;
import javax.persistence.Column;
import javax.persistence.Id;

import java.sql.Timestamp;


/**
 * 会议室
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-5-30 CAP超级管理员
 */
@Table(name = "OMS_DEMO_XC_MEETINGROOM")
@DataTransferObject
public class XcMeetingroomVO extends CapWorkflowVO {

    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 主键 */
    @Id
    @Column(name = "ROOMID",length=40,precision=0)
    private String roomid;
    
    /** 会议室地址 */
    @Column(name = "ADDRESS",length=40,precision=0)
    private String address;
    
    /** 会议室规模 */
    @Column(name = "FSIZE",length=40,precision=0)
    private String fsize;
    
    /** 备注 */
    @Column(name = "FDESC",length=1000,precision=0)
    private String fdesc;
    
    /** 会议室编码 */
    @Column(name = "FNUMBER",length=40,precision=0)
    private String fnumber;
    
    /** 会议室名称 */
    @Column(name = "NAME",length=40,precision=0)
    private String name;
    
    /** lastupdatedate */
    @Column(name = "LASTUPDATEDATE",precision=0)
    private Timestamp lastupdatedate;
    
	
    /**
     * @return 获取 主键 属性值
     */
    public String getRoomid() {
        return roomid;
    }
    	
    /**
     * @param roomid 设置 主键 属性值为参数值 roomid
     */
    public void setRoomid(String roomid) {
        this.roomid = roomid;
    }
    
    /**
     * @return 获取 会议室地址 属性值
     */
    public String getAddress() {
        return address;
    }
    	
    /**
     * @param address 设置 会议室地址 属性值为参数值 address
     */
    public void setAddress(String address) {
        this.address = address;
    }
    
    /**
     * @return 获取 会议室规模 属性值
     */
    public String getFsize() {
        return fsize;
    }
    	
    /**
     * @param fsize 设置 会议室规模 属性值为参数值 fsize
     */
    public void setFsize(String fsize) {
        this.fsize = fsize;
    }
    
    /**
     * @return 获取 备注 属性值
     */
    public String getFdesc() {
        return fdesc;
    }
    	
    /**
     * @param fdesc 设置 备注 属性值为参数值 fdesc
     */
    public void setFdesc(String fdesc) {
        this.fdesc = fdesc;
    }
    
    /**
     * @return 获取 会议室编码 属性值
     */
    public String getFnumber() {
        return fnumber;
    }
    	
    /**
     * @param fnumber 设置 会议室编码 属性值为参数值 fnumber
     */
    public void setFnumber(String fnumber) {
        this.fnumber = fnumber;
    }
    
    /**
     * @return 获取 会议室名称 属性值
     */
    public String getName() {
        return name;
    }
    	
    /**
     * @param name 设置 会议室名称 属性值为参数值 name
     */
    public void setName(String name) {
        this.name = name;
    }
    
    /**
     * @return 获取 lastupdatedate 属性值
     */
    public Timestamp getLastupdatedate() {
        return lastupdatedate;
    }
    	
    /**
     * @param lastupdatedate 设置 lastupdatedate 属性值为参数值 lastupdatedate
     */
    public void setLastupdatedate(Timestamp lastupdatedate) {
        this.lastupdatedate = lastupdatedate;
    }
    
	 
    /**
     * 获取主键值
     * @return 主键值
     */
    @Override
    public String getPrimaryValue(){
    		return  this.roomid;
    }

	/** 
	 *
	 * @return xxx
	 *		
	 * @see com.comtop.cap.runtime.base.model.CapWorkflowVO#getProcessInsId()
	 */
	@Override
	public String getProcessInsId() {
		// TODO 自动生成方法存根注释，方法实现时请删除此注释
		return null;
	}

	/** 
	 *
	 * @param processInsId xx
	 *		
	 * @see com.comtop.cap.runtime.base.model.CapWorkflowVO#setProcessInsId(java.lang.String)
	 */
	@Override
	public void setProcessInsId(String processInsId) {
		// TODO 自动生成方法存根注释，方法实现时请删除此注释
		
	}

	/** 
	 *
	 * @return xx
	 *		
	 * @see com.comtop.cap.runtime.base.model.CapWorkflowVO#getFlowState()
	 */
	@Override
	public Integer getFlowState() {
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
		//
	}
}