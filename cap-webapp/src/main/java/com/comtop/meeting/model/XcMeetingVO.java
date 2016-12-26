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
import javax.persistence.Table;
import javax.persistence.Column;
import com.comtop.cap.runtime.base.annotation.AssociateAttribute;
import com.comtop.meeting.model.XcMeetingroomVO;
import com.comtop.meeting.model.XcPresententryVO;
import java.util.List;
import javax.persistence.Id;
import java.sql.Timestamp;


/**
 * 会议管理
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-5-30 CAP超级管理员
 */
@Table(name = "OMS_DEMO_XC_MEETING")
@DataTransferObject
public class XcMeetingVO extends CapBaseVO {

    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 主键 */
    @Id
    @Column(name = "MEETINGID",length=44,precision=0)
    private String meetingid;
    
    /** 会议室ID */
    @Column(name = "ROOMID",length=40,precision=0)
    private String roomid;
    
    /** 会议名称 */
    @Column(name = "MEETINGNAME",length=100,precision=0)
    private String meetingname;
    
    /** 申请人 */
    @Column(name = "APPLIERID",length=100,precision=0)
    private String applierid;
    
    /** 计划开始时间 */
    @Column(name = "STARTDATE",precision=0)
    private Timestamp startdate;
    
    /** 计划结束时间 */
    @Column(name = "ENDDATE",precision=0)
    private Timestamp enddate;
    
    /** 会议类型 */
    @Column(name = "MEETINGTYPE",length=40,precision=0)
    private String meetingtype;
    
    /** 备注 */
    @Column(name = "FDESC",length=1000,precision=0)
    private String fdesc;
    
    /** 最后修改日期 */
    @Column(name = "LASTUPDATEDATE",precision=0)
    private Timestamp lastupdatedate;
    
    /** appliername */
    @Column(name = "APPLIERNAME",length=100,precision=0)
    private String appliername;
    
    /** roomname */
    @Column(name = "ROOMNAME",length=100,precision=0)
    private String roomname;
    
    /** 出席者 */
    @AssociateAttribute(multiple = "One-Many", associateFieldName = "meetingid")
    private List<XcPresententryVO> relationPerson_presents_relation;
    
    /** 会议关系 */
    @AssociateAttribute(multiple = "One-One", associateFieldName = "roomid")
    private XcMeetingroomVO relationroom_relation;
    
	
    /**
     * @return 获取 主键 属性值
     */
    public String getMeetingid() {
        return meetingid;
    }
    	
    /**
     * @param meetingid 设置 主键 属性值为参数值 meetingid
     */
    public void setMeetingid(String meetingid) {
        this.meetingid = meetingid;
    }
    
    /**
     * @return 获取 会议室ID 属性值
     */
    public String getRoomid() {
        return roomid;
    }
    	
    /**
     * @param roomid 设置 会议室ID 属性值为参数值 roomid
     */
    public void setRoomid(String roomid) {
        this.roomid = roomid;
    }
    
    /**
     * @return 获取 会议名称 属性值
     */
    public String getMeetingname() {
        return meetingname;
    }
    	
    /**
     * @param meetingname 设置 会议名称 属性值为参数值 meetingname
     */
    public void setMeetingname(String meetingname) {
        this.meetingname = meetingname;
    }
    
    /**
     * @return 获取 申请人 属性值
     */
    public String getApplierid() {
        return applierid;
    }
    	
    /**
     * @param applierid 设置 申请人 属性值为参数值 applierid
     */
    public void setApplierid(String applierid) {
        this.applierid = applierid;
    }
    
    /**
     * @return 获取 计划开始时间 属性值
     */
    public Timestamp getStartdate() {
        return startdate;
    }
    	
    /**
     * @param startdate 设置 计划开始时间 属性值为参数值 startdate
     */
    public void setStartdate(Timestamp startdate) {
        this.startdate = startdate;
    }
    
    /**
     * @return 获取 计划结束时间 属性值
     */
    public Timestamp getEnddate() {
        return enddate;
    }
    	
    /**
     * @param enddate 设置 计划结束时间 属性值为参数值 enddate
     */
    public void setEnddate(Timestamp enddate) {
        this.enddate = enddate;
    }
    
    /**
     * @return 获取 会议类型 属性值
     */
    public String getMeetingtype() {
        return meetingtype;
    }
    	
    /**
     * @param meetingtype 设置 会议类型 属性值为参数值 meetingtype
     */
    public void setMeetingtype(String meetingtype) {
        this.meetingtype = meetingtype;
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
     * @return 获取 最后修改日期 属性值
     */
    public Timestamp getLastupdatedate() {
        return lastupdatedate;
    }
    	
    /**
     * @param lastupdatedate 设置 最后修改日期 属性值为参数值 lastupdatedate
     */
    public void setLastupdatedate(Timestamp lastupdatedate) {
        this.lastupdatedate = lastupdatedate;
    }
    
    /**
     * @return 获取 appliername 属性值
     */
    public String getAppliername() {
        return appliername;
    }
    	
    /**
     * @param appliername 设置 appliername 属性值为参数值 appliername
     */
    public void setAppliername(String appliername) {
        this.appliername = appliername;
    }
    
    /**
     * @return 获取 roomname 属性值
     */
    public String getRoomname() {
        return roomname;
    }
    	
    /**
     * @param roomname 设置 roomname 属性值为参数值 roomname
     */
    public void setRoomname(String roomname) {
        this.roomname = roomname;
    }
    
    /**
     * @return 获取 出席者 属性值
     */
    public List<XcPresententryVO> getRelationPerson_presents_relation() {
        return relationPerson_presents_relation;
    }
    	
    /**
     * @param relationPerson_presents_relation 设置 出席者 属性值为参数值 relationPerson_presents_relation
     */
    public void setRelationPerson_presents_relation(List<XcPresententryVO> relationPerson_presents_relation) {
        this.relationPerson_presents_relation = relationPerson_presents_relation;
    }
    
    /**
     * @return 获取 会议关系 属性值
     */
    public XcMeetingroomVO getRelationroom_relation() {
        return relationroom_relation;
    }
    	
    /**
     * @param relationroom_relation 设置 会议关系 属性值为参数值 relationroom_relation
     */
    public void setRelationroom_relation(XcMeetingroomVO relationroom_relation) {
        this.relationroom_relation = relationroom_relation;
    }
    
	 
    /**
     * 获取主键值
     * @return 主键值
     */
    @Override
    public String getPrimaryValue(){
    		return  this.meetingid;
    }
}