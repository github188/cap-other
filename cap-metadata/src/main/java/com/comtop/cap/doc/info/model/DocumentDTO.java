/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.info.model;

import com.comtop.cap.document.word.docmodel.data.BaseDTO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 文档DTO
 * 
 * @author 李志勇
 * @since 1.0
 * @version 2015-11-9 CAP
 */
@DataTransferObject
public class DocumentDTO extends BaseDTO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 文档模板 */
    private String docTmplId;
    
    /** 总分册标志，SUM：总册；SUB：分册 */
    private String summaryFlag;
    
    /** 业务域.关联的业务域id； */
    private String bizDomain;
    
    /** 文档类型 */
    private String docType;
    
    /** 文档模板名称 */
    private String docTemplateName;
    
    /** 导入文件路径 */
    private String filePath;
    
    /** 文档版本 */
    private String version;
    
    /** 密级 */
    private String scretLevel;
    
    /** 内部版本 */
    private String innerVersion;
    
    /** 类型 */
    private String type;
    
    /** 编制人 */
    private String maker;
    
    /** 编制时间 */
    private String maketime;
    
    /** 审核人 */
    private String auditor;
    
    /** 审核时间 */
    private String auditTime;
    
    /** 项目名称 */
    private String projectname;
    
    /** 项目编码 */
    private String projectCode;
    
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
     * @return 获取 version属性值
     */
    public String getVersion() {
        return version;
    }
    
    /**
     * @param version 设置 version 属性值为参数值 version
     */
    public void setVersion(String version) {
        this.version = version;
    }
    
    /**
     * @return 获取 scretLevel属性值
     */
    public String getScretLevel() {
        return scretLevel;
    }
    
    /**
     * @param scretLevel 设置 scretLevel 属性值为参数值 scretLevel
     */
    public void setScretLevel(String scretLevel) {
        this.scretLevel = scretLevel;
    }
    
    /**
     * @return 获取 innerVersion属性值
     */
    public String getInnerVersion() {
        return innerVersion;
    }
    
    /**
     * @param innerVersion 设置 innerVersion 属性值为参数值 innerVersion
     */
    public void setInnerVersion(String innerVersion) {
        this.innerVersion = innerVersion;
    }
    
    /**
     * @return 获取 type属性值
     */
    public String getType() {
        return type;
    }
    
    /**
     * @param type 设置 type 属性值为参数值 type
     */
    public void setType(String type) {
        this.type = type;
    }
    
    /**
     * @return 获取 maker属性值
     */
    public String getMaker() {
        return maker;
    }
    
    /**
     * @param maker 设置 maker 属性值为参数值 maker
     */
    public void setMaker(String maker) {
        this.maker = maker;
    }
    
    /**
     * @return 获取 maketime属性值
     */
    public String getMaketime() {
        return maketime;
    }
    
    /**
     * @param maketime 设置 maketime 属性值为参数值 maketime
     */
    public void setMaketime(String maketime) {
        this.maketime = maketime;
    }
    
    /**
     * @return 获取 auditor属性值
     */
    public String getAuditor() {
        return auditor;
    }
    
    /**
     * @param auditor 设置 auditor 属性值为参数值 auditor
     */
    public void setAuditor(String auditor) {
        this.auditor = auditor;
    }
    
    /**
     * @return 获取 auditTime属性值
     */
    public String getAuditTime() {
        return auditTime;
    }
    
    /**
     * @param auditTime 设置 auditTime 属性值为参数值 auditTime
     */
    public void setAuditTime(String auditTime) {
        this.auditTime = auditTime;
    }
    
    /**
     * @return 获取 projectname属性值
     */
    public String getProjectname() {
        return projectname;
    }
    
    /**
     * @param projectname 设置 projectname 属性值为参数值 projectname
     */
    public void setProjectname(String projectname) {
        this.projectname = projectname;
    }
    
    /**
     * @return 获取 projectCode属性值
     */
    public String getProjectCode() {
        return projectCode;
    }
    
    /**
     * @param projectCode 设置 projectCode 属性值为参数值 projectCode
     */
    public void setProjectCode(String projectCode) {
        this.projectCode = projectCode;
    }
}
