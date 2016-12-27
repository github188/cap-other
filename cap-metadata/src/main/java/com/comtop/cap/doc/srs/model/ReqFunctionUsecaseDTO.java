/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.srs.model;

import com.comtop.cap.document.word.docmodel.data.BaseDTO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 功能用例
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年12月24日 lizhongwen
 */
@DataTransferObject
public class ReqFunctionUsecaseDTO extends BaseDTO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 业务说明 */
    private String bizComment;
    
    /** 业务规则 */
    private String bizRule;
    
    /** 使用级别 */
    private String useLevel;
    
    /** 先决条件 */
    private String premise;
    
    /** 基本功能 */
    private String baseFunction;
    
    /** 辅助功能 */
    private String auxiliaryFunction;
    
    /** 提示信息 */
    private String tipInfo;
    
    /** 处理约束 */
    private String dealConstraint;
    
    /** 输入信息 */
    private String inputInfo;
    
    /** 输出信息 */
    private String outputInfo;
    
    /** 非功能需求 */
    private String nonfunctionReq;
    
    /** 统计考核要素 */
    private String evalFactor;
    
    /** 差异说明 */
    private String differComment;
    
    /** 功能子项ID */
    private String subitemId;
    
    /** 业务表单 */
    private String bizForms;
    
    /**
     * @return 获取 bizComment属性值
     */
    public String getBizComment() {
        return bizComment;
    }
    
    /**
     * @param bizComment 设置 bizComment 属性值为参数值 bizComment
     */
    public void setBizComment(String bizComment) {
        this.bizComment = bizComment;
    }
    
    /**
     * @return 获取 bizRule属性值
     */
    public String getBizRule() {
        return bizRule;
    }
    
    /**
     * @param bizRule 设置 bizRule 属性值为参数值 bizRule
     */
    public void setBizRule(String bizRule) {
        this.bizRule = bizRule;
    }
    
    /**
     * @return 获取 useLevel属性值
     */
    public String getUseLevel() {
        return useLevel;
    }
    
    /**
     * @param useLevel 设置 useLevel 属性值为参数值 useLevel
     */
    public void setUseLevel(String useLevel) {
        this.useLevel = useLevel;
    }
    
    /**
     * @return 获取 premise属性值
     */
    public String getPremise() {
        return premise;
    }
    
    /**
     * @param premise 设置 premise 属性值为参数值 premise
     */
    public void setPremise(String premise) {
        this.premise = premise;
    }
    
    /**
     * @return 获取 baseFunction属性值
     */
    public String getBaseFunction() {
        return baseFunction;
    }
    
    /**
     * @param baseFunction 设置 baseFunction 属性值为参数值 baseFunction
     */
    public void setBaseFunction(String baseFunction) {
        this.baseFunction = baseFunction;
    }
    
    /**
     * @return 获取 auxiliaryFunction属性值
     */
    public String getAuxiliaryFunction() {
        return auxiliaryFunction;
    }
    
    /**
     * @param auxiliaryFunction 设置 auxiliaryFunction 属性值为参数值 auxiliaryFunction
     */
    public void setAuxiliaryFunction(String auxiliaryFunction) {
        this.auxiliaryFunction = auxiliaryFunction;
    }
    
    /**
     * @return 获取 tipInfo属性值
     */
    public String getTipInfo() {
        return tipInfo;
    }
    
    /**
     * @param tipInfo 设置 tipInfo 属性值为参数值 tipInfo
     */
    public void setTipInfo(String tipInfo) {
        this.tipInfo = tipInfo;
    }
    
    /**
     * @return 获取 dealConstraint属性值
     */
    public String getDealConstraint() {
        return dealConstraint;
    }
    
    /**
     * @param dealConstraint 设置 dealConstraint 属性值为参数值 dealConstraint
     */
    public void setDealConstraint(String dealConstraint) {
        this.dealConstraint = dealConstraint;
    }
    
    /**
     * @return 获取 inputInfo属性值
     */
    public String getInputInfo() {
        return inputInfo;
    }
    
    /**
     * @param inputInfo 设置 inputInfo 属性值为参数值 inputInfo
     */
    public void setInputInfo(String inputInfo) {
        this.inputInfo = inputInfo;
    }
    
    /**
     * @return 获取 outputInfo属性值
     */
    public String getOutputInfo() {
        return outputInfo;
    }
    
    /**
     * @param outputInfo 设置 outputInfo 属性值为参数值 outputInfo
     */
    public void setOutputInfo(String outputInfo) {
        this.outputInfo = outputInfo;
    }
    
    /**
     * @return 获取 nonfunctionReq属性值
     */
    public String getNonfunctionReq() {
        return nonfunctionReq;
    }
    
    /**
     * @param nonfunctionReq 设置 nonfunctionReq 属性值为参数值 nonfunctionReq
     */
    public void setNonfunctionReq(String nonfunctionReq) {
        this.nonfunctionReq = nonfunctionReq;
    }
    
    /**
     * @return 获取 evalFactor属性值
     */
    public String getEvalFactor() {
        return evalFactor;
    }
    
    /**
     * @param evalFactor 设置 evalFactor 属性值为参数值 evalFactor
     */
    public void setEvalFactor(String evalFactor) {
        this.evalFactor = evalFactor;
    }
    
    /**
     * @return 获取 differComment属性值
     */
    public String getDifferComment() {
        return differComment;
    }
    
    /**
     * @param differComment 设置 differComment 属性值为参数值 differComment
     */
    public void setDifferComment(String differComment) {
        this.differComment = differComment;
    }
    
    /**
     * @return 获取 subitemId属性值
     */
    public String getSubitemId() {
        return subitemId;
    }
    
    /**
     * @param subitemId 设置 subitemId 属性值为参数值 subitemId
     */
    public void setSubitemId(String subitemId) {
        this.subitemId = subitemId;
    }
    
    /**
     * @return 获取 bizForms属性值
     */
    public String getBizForms() {
        return bizForms;
    }
    
    /**
     * @param bizForms 设置 bizForms 属性值为参数值 bizForms
     */
    public void setBizForms(String bizForms) {
        this.bizForms = bizForms;
    }
}
