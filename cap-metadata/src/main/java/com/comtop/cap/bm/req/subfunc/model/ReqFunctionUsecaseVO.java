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
 * 功能用例
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-12-22 CAP
 */
@DataTransferObject
@Table(name = "CAP_REQ_FUNCTION_USECASE")
public class ReqFunctionUsecaseVO extends CoreVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 用例ID */
    @Id
    @Column(name = "ID", length = 40)
    private String id;
    
    /** 子项ID */
    @Column(name = "SUBITEM_ID", length = 40)
    private String subitemId;
    
    /** 名称 */
    @Column(name = "NAME", length = 40)
    private String name;
    
    /** 编号 */
    @Column(name = "CODE", length = 256)
    private String code;
    
    /** 业务说明 */
    @Column(name = "BIZ_COMMENT", length = 4000)
    private String bizComment;
    
    /** 业务规则 */
    @Column(name = "BIZ_RULE", length = 4000)
    private String bizRule;
    
    /** 使用级别(公司;分子公司;基层单位) */
    @Column(name = "USE_LEVEL", length = 256)
    private String useLevel;
    
    /** 先决条件 */
    @Column(name = "PREMISE", length = 4000)
    private String premise;
    
    /** 基本功能 */
    @Column(name = "BASE_FUNCTION", length = 4000)
    private String baseFunction;
    
    /** 辅助功能 */
    @Column(name = "AUXILIARY_FUNCTION", length = 4000)
    private String auxiliaryFunction;
    
    /** 提示信息 */
    @Column(name = "TIP_INFO", length = 4000)
    private String tipInfo;
    
    /** 处理约束 */
    @Column(name = "DEAL_CONSTRAINT", length = 4000)
    private String dealConstraint;
    
    /** 输入信息 */
    @Column(name = "INPUT_INFO", length = 4000)
    private String inputInfo;
    
    /** 输出信息 */
    @Column(name = "OUTPUT_INFO", length = 4000)
    private String outputInfo;
    
    /** 统计考核要素 */
    @Column(name = "EVAL_FACTOR", length = 4000)
    private String evalFactor;
    
    /** 非功能需求 */
    @Column(name = "NONFUNCTION_REQ", length = 4000)
    private String nonfunctionReq;
    
    /** 差异说明 */
    @Column(name = "DIFFER_COMMENT", length = 4000)
    private String differComment;
    
    /** 备注 */
    @Column(name = "REMARK", length = 500)
    private String remark;
    
    /** 数据来源，1：导入；0：系统创建； */
    @Column(name = "DATA_FROM", precision = 1)
    private Integer dataFrom;
    
    /** 文档ID */
    @Column(name = "DOCUMENT_ID", length = 40)
    private String documentId;
    
    /** 业务域ID */
    private String domainId;
    
    /** 表单id */
    private String bizFormIds;
    
    /**
     * @return 获取 用例ID属性值
     */
    public String getId() {
        return id;
    }
    
    /**
     * @param id 设置 用例ID属性值为参数值 id
     */
    
    public void setId(String id) {
        this.id = id;
    }
    
    /**
     * @return 获取 子项ID属性值
     */
    
    public String getSubitemId() {
        return subitemId;
    }
    
    /**
     * @param subitemId 设置 子项ID属性值为参数值 subitemId
     */
    
    public void setSubitemId(String subitemId) {
        this.subitemId = subitemId;
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
     * @return 获取 编号属性值
     */
    
    public String getCode() {
        return code;
    }
    
    /**
     * @param code 设置 编号属性值为参数值 code
     */
    
    public void setCode(String code) {
        this.code = code;
    }
    
    /**
     * @return 获取 业务说明属性值
     */
    
    public String getBizComment() {
        return bizComment;
    }
    
    /**
     * @param bizComment 设置 业务说明属性值为参数值 bizComment
     */
    
    public void setBizComment(String bizComment) {
        this.bizComment = bizComment;
    }
    
    /**
     * @return 获取 业务规则属性值
     */
    
    public String getBizRule() {
        return bizRule;
    }
    
    /**
     * @param bizRule 设置 业务规则属性值为参数值 bizRule
     */
    
    public void setBizRule(String bizRule) {
        this.bizRule = bizRule;
    }
    
    /**
     * @return 获取 使用级别(公司;分子公司;基层单位)属性值
     */
    
    public String getUseLevel() {
        return useLevel;
    }
    
    /**
     * @param useLevel 设置 使用级别(公司;分子公司;基层单位)属性值为参数值 useLevel
     */
    
    public void setUseLevel(String useLevel) {
        this.useLevel = useLevel;
    }
    
    /**
     * @return 获取 先决条件属性值
     */
    
    public String getPremise() {
        return premise;
    }
    
    /**
     * @param premise 设置 先决条件属性值为参数值 premise
     */
    
    public void setPremise(String premise) {
        this.premise = premise;
    }
    
    /**
     * @return 获取 基本功能属性值
     */
    
    public String getBaseFunction() {
        return baseFunction;
    }
    
    /**
     * @param baseFunction 设置 基本功能属性值为参数值 baseFunction
     */
    
    public void setBaseFunction(String baseFunction) {
        this.baseFunction = baseFunction;
    }
    
    /**
     * @return 获取 辅助功能属性值
     */
    
    public String getAuxiliaryFunction() {
        return auxiliaryFunction;
    }
    
    /**
     * @param auxiliaryFunction 设置 辅助功能属性值为参数值 auxiliaryFunction
     */
    
    public void setAuxiliaryFunction(String auxiliaryFunction) {
        this.auxiliaryFunction = auxiliaryFunction;
    }
    
    /**
     * @return 获取 提示信息属性值
     */
    
    public String getTipInfo() {
        return tipInfo;
    }
    
    /**
     * @param tipInfo 设置 提示信息属性值为参数值 tipInfo
     */
    
    public void setTipInfo(String tipInfo) {
        this.tipInfo = tipInfo;
    }
    
    /**
     * @return 获取 处理约束属性值
     */
    
    public String getDealConstraint() {
        return dealConstraint;
    }
    
    /**
     * @param dealConstraint 设置 处理约束属性值为参数值 dealConstraint
     */
    
    public void setDealConstraint(String dealConstraint) {
        this.dealConstraint = dealConstraint;
    }
    
    /**
     * @return 获取 输入信息属性值
     */
    
    public String getInputInfo() {
        return inputInfo;
    }
    
    /**
     * @param inputInfo 设置 输入信息属性值为参数值 inputInfo
     */
    
    public void setInputInfo(String inputInfo) {
        this.inputInfo = inputInfo;
    }
    
    /**
     * @return 获取 输出信息属性值
     */
    
    public String getOutputInfo() {
        return outputInfo;
    }
    
    /**
     * @param outputInfo 设置 输出信息属性值为参数值 outputInfo
     */
    
    public void setOutputInfo(String outputInfo) {
        this.outputInfo = outputInfo;
    }
    
    /**
     * @return 获取 统计考核要素属性值
     */
    
    public String getEvalFactor() {
        return evalFactor;
    }
    
    /**
     * @param evalFactor 设置 统计考核要素属性值为参数值 evalFactor
     */
    
    public void setEvalFactor(String evalFactor) {
        this.evalFactor = evalFactor;
    }
    
    /**
     * @return 获取 非功能需求属性值
     */
    
    public String getNonfunctionReq() {
        return nonfunctionReq;
    }
    
    /**
     * @param nonfunctionReq 设置 非功能需求属性值为参数值 nonfunctionReq
     */
    
    public void setNonfunctionReq(String nonfunctionReq) {
        this.nonfunctionReq = nonfunctionReq;
    }
    
    /**
     * @return 获取 差异说明属性值
     */
    
    public String getDifferComment() {
        return differComment;
    }
    
    /**
     * @param differComment 设置 差异说明属性值为参数值 differComment
     */
    
    public void setDifferComment(String differComment) {
        this.differComment = differComment;
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
     * @return 获取 数据来源，1：导入；0：系统创建；属性值
     */
    
    public Integer getDataFrom() {
        return dataFrom;
    }
    
    /**
     * @param dataFrom 设置 数据来源，1：导入；0：系统创建；属性值为参数值 dataFrom
     */
    
    public void setDataFrom(Integer dataFrom) {
        this.dataFrom = dataFrom;
    }
    
    /**
     * @return 获取 文档ID属性值
     */
    
    public String getDocumentId() {
        return documentId;
    }
    
    /**
     * @param documentId 设置 文档ID属性值为参数值 documentId
     */
    
    public void setDocumentId(String documentId) {
        this.documentId = documentId;
    }
    
    /**
     * @return 获取 domainId属性值
     */
    public String getDomainId() {
        return domainId;
    }
    
    /**
     * @param domainId 设置 domainId 属性值为参数值 domainId
     */
    public void setDomainId(String domainId) {
        this.domainId = domainId;
    }
    
    /**
     * 获取表单id
     * 
     * @return 表单id
     */
    public String getBizFormIds() {
        return bizFormIds;
    }
    
    /**
     * 设置表单id
     * 
     * @param bizFormIds 表单id
     */
    public void setBizFormIds(String bizFormIds) {
        this.bizFormIds = bizFormIds;
    }
    
    @Override
    public String toString() {
        return "ReqFunctionUsecaseVO [id=" + id + ", subitemId=" + subitemId + ", name=" + name + ", code=" + code
            + ", bizComment=" + bizComment + ", bizRule=" + bizRule + ", useLevel=" + useLevel + ", premise=" + premise
            + ", baseFunction=" + baseFunction + ", auxiliaryFunction=" + auxiliaryFunction + ", tipInfo=" + tipInfo
            + ", dealConstraint=" + dealConstraint + ", inputInfo=" + inputInfo + ", outputInfo=" + outputInfo
            + ", evalFactor=" + evalFactor + ", nonfunctionReq=" + nonfunctionReq + ", differComment=" + differComment
            + ", remark=" + remark + ", dataFrom=" + dataFrom + ", documentId=" + documentId + ", bizFormIds="
            + bizFormIds + "]";
    }
    
}
