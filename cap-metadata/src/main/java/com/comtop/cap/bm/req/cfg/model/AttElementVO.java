/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.req.cfg.model;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

import com.comtop.top.core.base.model.CoreVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 需求附件元素
 * 
 * @author 姜子豪
 * @since 1.0
 * @version 2015-9-16 姜子豪
 */
@DataTransferObject
@Table(name = "CAP_REQ_ATT_ELEMENT")
public class AttElementVO extends CoreVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 主键 */
    @Id
    @Column(name = "ID", length = 32)
    private String id;
    
    /** 类型编号（SYS.项目;SUBSYS.子项目,DIR.目录,MODEL.模块,PAGE.界面,SERVICE.服务,PROCESS 流程,ENTITY.实体,） */
    @Column(name = "REQ_TYPE", length = 32)
    private String reqType;
    
    /** 附件名称标签 */
    @Column(name = "ATT_LABEL", length = 100)
    private String attLabel;
    
    /** 附件标签标识(对应附件中的jobTypeCode) */
    @Column(name = "JOB_TYPE_CODE", length = 100)
    private String jobTypeCode;
    
    /** 业务单据的ID(对应附件中的objId) */
    @Column(name = "OBJ_ID", length = 100)
    private String objId;
    
    /** 排列序号 */
    @Column(name = "SORT", length = 10)
    private int sort;
    
    /**
     * @return 获取 主键属性值
     */
    
    public String getId() {
        return id;
    }
    
    /**
     * @param id 设置 主键属性值为参数值 id
     */
    
    public void setId(String id) {
        this.id = id;
    }
    
    /**
     * @return 获取 类型编号（SYS.项目;SUBSYS.子项目,DIR.目录,MODEL.模块,PAGE.界面,SERVICE.服务,PROCESS 流程,ENTITY.实体,）属性值
     */
    
    public String getReqType() {
        return reqType;
    }
    
    /**
     * @param reqType 设置 类型编号（SYS.项目;SUBSYS.子项目,DIR.目录,MODEL.模块,PAGE.界面,SERVICE.服务,PROCESS 流程,ENTITY.实体,）属性值为参数值 reqType
     */
    
    public void setReqType(String reqType) {
        this.reqType = reqType;
    }
    
    /**
     * @return 获取 附件名称标签属性值
     */
    
    public String getAttLabel() {
        return attLabel;
    }
    
    /**
     * @param attLabel 设置 附件名称标签属性值为参数值 attLabel
     */
    
    public void setAttLabel(String attLabel) {
        this.attLabel = attLabel;
    }
    
    /**
     * @return 获取 附件标签标识(对应附件中的jobTypeCode)属性值
     */
    
    public String getJobTypeCode() {
        return jobTypeCode;
    }
    
    /**
     * @param jobTypeCode 设置 附件标签标识(对应附件中的jobTypeCode)属性值为参数值 jobTypeCode
     */
    
    public void setJobTypeCode(String jobTypeCode) {
        this.jobTypeCode = jobTypeCode;
    }
    
    /**
     * @return 获取 业务单据的ID(对应附件中的objId)属性值
     */
    
    public String getObjId() {
        return objId;
    }
    
    /**
     * @param objId 设置 业务单据的ID(对应附件中的objId)属性值为参数值 objId
     */
    
    public void setObjId(String objId) {
        this.objId = objId;
    }
    
    /**
     * @return 获取 排列序号
     */
    public int getSort() {
        return sort;
    }
    
    /**
     * @param sort 设置 排列序号
     */
    public void setSort(int sort) {
        this.sort = sort;
    }
}
