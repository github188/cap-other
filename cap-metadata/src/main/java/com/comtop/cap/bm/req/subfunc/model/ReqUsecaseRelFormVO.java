/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.req.subfunc.model;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

import com.comtop.top.core.base.model.CoreVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 功能用例关联业务表单
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-12-22 CAP
 */
@DataTransferObject
@Table(name = "CAP_REQ_USECASE_REL_FORM")
public class ReqUsecaseRelFormVO extends CoreVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 主键 */
    @Id
    @Column(name = "ID", length = 40)
    private String id;
    
    /** 用例ID */
    @Column(name = "USECASE_ID", length = 40)
    private String usecaseId;
    
    /** 业务表单ID */
    @Column(name = "BIZ_FORM_ID", length = 40)
    private String bizFormId;
    
    /** 业务表单名称 */
    private String bizFormName;
    
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
     * @return 获取 用例ID属性值
     */
    
    public String getUsecaseId() {
        return usecaseId;
    }
    
    /**
     * @param usecaseId 设置 用例ID属性值为参数值 usecaseId
     */
    
    public void setUsecaseId(String usecaseId) {
        this.usecaseId = usecaseId;
    }
    
    /**
     * @return 获取 业务表单ID属性值
     */
    
    public String getBizFormId() {
        return bizFormId;
    }
    
    /**
     * @param bizFormId 设置 业务表单ID属性值为参数值 bizFormId
     */
    
    public void setBizFormId(String bizFormId) {
        this.bizFormId = bizFormId;
    }
    
    /**
     * @return 获取业务表单名称
     */
    public String getBizFormName() {
        return bizFormName;
    }
    
    /**
     * @param bizFormName 设置业务表单名称
     */
    
    public void setBizFormName(String bizFormName) {
        this.bizFormName = bizFormName;
    }

	@Override
	public String toString() {
		return "ReqUsecaseRelFormVO [id=" + id + ", usecaseId=" + usecaseId
				+ ", bizFormId=" + bizFormId + ", bizFormName=" + bizFormName
				+ "]";
	}
    
}
