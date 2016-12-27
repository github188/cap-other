/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.info.model;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

import com.comtop.top.core.base.model.CoreVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 文档
 * 
 * @author 李小芬
 * @since 1.0
 * @version 2015-11-9 李小芬
 */
@DataTransferObject
@Table(name = "CAP_DOC_DOCUMENT")
public class DocumentVO extends CoreVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 流水号 */
    @Id
    @Column(name = "ID", length = 40)
    private String id;
    
    /** 名称 */
    @Column(name = "NAME", length = 250)
    private String name;
    
    /** 文档模板 */
    @Column(name = "DOC_TMPL_ID", length = 40)
    private String docTmplId;
    
    /** 总分册标志，SUM：总册；SUB：分册 */
    @Column(name = "SUMMARY_FLAG", length = 10)
    private String summaryFlag;
    
    /** 业务域.关联的业务域id； */
    @Column(name = "BIZ_DOMAIN", length = 40)
    private String bizDomain;
    
    /** 说明 */
    @Column(name = "REMARK", length = 500)
    private String remark;
    
    /** 文档状态 */
    @Column(name = "STATUS", length = 10)
    private String status;
    
    /** 文档类型 */
    private String docType;
    
    /** 文档模板名称 */
    private String docTemplateName;
    
    /** 模块应用场景类型 public private */
    private String docConfigType;
    
    /** 导入文件路径 */
    private String filePath;
    
    /** 上传文件类别 */
    private String uploadKey;
    
    /** 上传文件类别 */
    private String uploadId;
    
    /** 新模板id */
    private String newTmplId;
    
    /**
     * @return 获取 newTmplId属性值
     */
    public String getNewTmplId() {
        return newTmplId;
    }
    
    /**
     * @param newTmplId 设置 newTmplId 属性值为参数值 newTmplId
     */
    public void setNewTmplId(String newTmplId) {
        this.newTmplId = newTmplId;
    }
    
    /**
     * @return 获取 uploadId属性值
     */
    public String getUploadId() {
        return uploadId;
    }
    
    /**
     * @param uploadId 设置 uploadId 属性值为参数值 uploadId
     */
    public void setUploadId(String uploadId) {
        this.uploadId = uploadId;
    }
    
    /** 操作日志id */
    private String operateLogId;
    
    /**
     * @return 获取 operateLogId属性值
     */
    public String getOperateLogId() {
        return operateLogId;
    }
    
    /**
     * @param operateLogId 设置 operateLogId 属性值为参数值 operateLogId
     */
    public void setOperateLogId(String operateLogId) {
        this.operateLogId = operateLogId;
    }
    
    /**
     * @return 获取 流水号属性值
     */
    public String getId() {
        return id;
    }
    
    /**
     * @param id 设置 流水号属性值为参数值 id
     */
    public void setId(String id) {
        this.id = id;
    }
    
    /**
     * @return 获取 名称属性值
     */
    public String getName() {
        return name;
    }
    
    /**
     * @param name 设置 名称属性值为参数值 name
     */
    public void setName(String name) {
        this.name = name;
    }
    
    /**
     * @return 获取 文档模板属性值
     */
    public String getDocTmplId() {
        return docTmplId;
    }
    
    /**
     * @param docTmplId 设置 文档模板属性值为参数值 docTmplId
     */
    public void setDocTmplId(String docTmplId) {
        this.docTmplId = docTmplId;
    }
    
    /**
     * @return 获取 总分册标志，SUM：总册；SUB：分册属性值
     */
    public String getSummaryFlag() {
        return summaryFlag;
    }
    
    /**
     * @param summaryFlag 设置 总分册标志，SUM：总册；SUB：分册属性值为参数值 summaryFlag
     */
    public void setSummaryFlag(String summaryFlag) {
        this.summaryFlag = summaryFlag;
    }
    
    /**
     * @return 获取 业务域.关联的业务域id；属性值
     */
    public String getBizDomain() {
        return bizDomain;
    }
    
    /**
     * @param bizDomain 设置 业务域.关联的业务域id；属性值为参数值 bizDomain
     */
    public void setBizDomain(String bizDomain) {
        this.bizDomain = bizDomain;
    }
    
    /**
     * @return 获取 说明属性值
     */
    public String getRemark() {
        return remark;
    }
    
    /**
     * @param remark 设置 说明属性值为参数值 remark
     */
    public void setRemark(String remark) {
        this.remark = remark;
    }
    
    /**
     * @return 获取 说明属性值
     */
    public String getDocType() {
        return docType;
    }
    
    /**
     * @param docType 设置 说明属性值为参数值 docType
     */
    public void setDocType(String docType) {
        this.docType = docType;
    }
    
    /**
     * @return 获取 说明属性值
     */
    public String getDocTemplateName() {
        return docTemplateName;
    }
    
    /**
     * @param docTemplateName 设置 说明属性值为参数值 docTemplateName
     */
    public void setDocTemplateName(String docTemplateName) {
        this.docTemplateName = docTemplateName;
    }
    
    /**
     * @return 获取 docConfigType
     */
    public String getDocConfigType() {
        return docConfigType;
    }
    
    /**
     * @param docConfigType 设置 说明属性值为参数值 docConfigType
     */
    public void setDocConfigType(String docConfigType) {
        this.docConfigType = docConfigType;
    }
    
    /**
     * 获取文件路径
     * 
     * @return filePath
     */
    public String getFilePath() {
        return filePath;
    }
    
    /**
     * 
     * 设置文件路径
     * 
     * @param filePath 文件路径
     */
    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }
    
    /**
     * @return 获取 uploadKey属性值
     */
    public String getUploadKey() {
        return uploadKey;
    }
    
    /**
     * @param uploadKey 设置 uploadKey 属性值为参数值 uploadKey
     */
    public void setUploadKey(String uploadKey) {
        this.uploadKey = uploadKey;
    }
    
    /**
     * @return 获取 status属性值
     */
    public String getStatus() {
        return status;
    }
    
    /**
     * @param status 设置 status 属性值为参数值 status
     */
    public void setStatus(String status) {
        this.status = status;
    }
    
}
