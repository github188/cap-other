/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.operatelog.model;

import java.sql.Timestamp;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

import com.comtop.top.core.base.model.CoreVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 文档操作记录表
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-12-22 CAP
 */
@DataTransferObject
@Table(name = "CAP_DOC_OPER_LOG")
public class DocOperLogVO extends CoreVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 主键ID */
    @Id
    @Column(name = "ID", length = 40)
    private String id;
    
    /** 业务域ID */
    @Column(name = "BIZ_DOMAIN_ID", length = 40)
    private String bizDomainId;
    
    /** 操作者ID */
    @Column(name = "USER_ID", length = 40)
    private String userId;
    
    /** 操作者名称 */
    @Column(name = "USER_NAME", length = 40)
    private String userName;
    
    /** 操作时间 */
    @Column(name = "OPER_TIME", precision = 11)
    private Timestamp operTime;
    
    /** 操作类型,IMP：导入；EXP：导出 */
    @Column(name = "OPER_TYPE", length = 20)
    private String operType;
    
    /** 操作结果：SUCCEED：成功；FAIL：失败；Doing：执行中。默认值为：Doing，在异步操作完成后根据实际情况更新此内容 */
    @Column(name = "OPER_RESULT", length = 20)
    private String operResult = "Doing";
    
    /** 附件地址，在异步操作完成后根据实际情况更新此内容 */
    @Column(name = "FILE_ADDR", length = 500)
    private String fileAddr;
    
    /** 日志文件地址 */
    @Column(name = "LOG_FILE_PATH", length = 500)
    private String logFilePath;
    
    /** 备注 */
    @Column(name = "REMARK", length = 500)
    private String remark;
    
    /** 对应的文档ID */
    @Column(name = "DOCUMENT_ID", length = 500)
    private String documentId;
    
    
    /**
     * @return 获取 logFilePath属性值
     */
    public String getLogFilePath() {
        return logFilePath;
    }
    
    /**
     * @param logFilePath 设置 logFilePath 属性值为参数值 logFilePath
     */
    public void setLogFilePath(String logFilePath) {
        this.logFilePath = logFilePath;
    }
    
    /**
     * @return 获取 主键ID
     */
    
    public String getId() {
        return id;
    }
    
    /**
     * @param id 设置 主键ID
     */
    
    public void setId(String id) {
        this.id = id;
    }
    
    /**
     * @return 获取 业务域ID属性值
     */
    
    public String getBizDomainId() {
        return bizDomainId;
    }
    
    /**
     * @param bizDomainId 设置 业务域ID属性值为参数值 bizDomainId
     */
    
    public void setBizDomainId(String bizDomainId) {
        this.bizDomainId = bizDomainId;
    }
    
    /**
     * @return 获取 操作者ID属性值
     */
    
    public String getUserId() {
        return userId;
    }
    
    /**
     * @param userId 设置 操作者ID属性值为参数值 userId
     */
    
    public void setUserId(String userId) {
        this.userId = userId;
    }
    
    /**
     * @return 获取 操作者名称属性值
     */
    
    public String getUserName() {
        return userName;
    }
    
    /**
     * @param userName 设置 操作者名称属性值为参数值 userName
     */
    
    public void setUserName(String userName) {
        this.userName = userName;
    }
    
    /**
     * @return 获取 操作时间属性值
     */
    
    public Timestamp getOperTime() {
        return operTime;
    }
    
    /**
     * @param operTime 设置 操作时间属性值为参数值 operTime
     */
    
    public void setOperTime(Timestamp operTime) {
        this.operTime = operTime;
    }
    
    /**
     * @return 获取 操作类型,IMP：导入；EXP：导出属性值
     */
    
    public String getOperType() {
        return operType;
    }
    
    /**
     * @param operType 设置 操作类型,IMP：导入；EXP：导出属性值为参数值 operType
     */
    
    public void setOperType(String operType) {
        this.operType = operType;
    }
    
    /**
     * @return 获取 操作结果：SUCCEED：成功；FAIL：失败；Doing：执行中。默认值为：Doing，在异步操作完成后根据实际情况更新此内容属性值
     */
    
    public String getOperResult() {
        return operResult;
    }
    
    /**
     * @param operResult 设置 操作结果：SUCCEED：成功；FAIL：失败；Doing：执行中。默认值为：Doing，在异步操作完成后根据实际情况更新此内容属性值为参数值 operResult
     */
    
    public void setOperResult(String operResult) {
        this.operResult = operResult;
    }
    
    /**
     * @return 获取 附件地址，在异步操作完成后根据实际情况更新此内容属性值
     */
    
    public String getFileAddr() {
        return fileAddr;
    }
    
    /**
     * @param fileAddr 设置 附件地址，在异步操作完成后根据实际情况更新此内容属性值为参数值 fileAddr
     */
    
    public void setFileAddr(String fileAddr) {
        this.fileAddr = fileAddr;
    }
    
    /**
     * @return 获取 备注属性值
     */
    
    public String getRemark() {
        return remark;
    }
    
    /**
     * @param remark 设置 备注属性值为参数值 remark
     */
    
    public void setRemark(String remark) {
        this.remark = remark;
    }

	/**
	 * @return 对应的文档ID
	 */
	public String getDocumentId() {
		return documentId;
	}

	/**
	 * @param documentId 对应的文档ID
	 */
	public void setDocumentId(String documentId) {
		this.documentId = documentId;
	}
    
    
    
}
