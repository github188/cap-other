/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.req.func.model;

import java.util.List;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

import com.comtop.top.core.base.model.CoreVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 功能项，建立在系统、子系统、目录下面。
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-11-25 CAP
 */
@DataTransferObject
@Table(name = "CAP_REQ_FUNCTION_ITEM")
public class ReqFunctionItemVO extends CoreVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 关联业务流程 */
    private List<ReqFunctionRelFlowVO> reqFunctionRelFlow;
    
    /** 关联业务事项 */
    private List<ReqFunctionRelItemsVO> reqFunctionRelItems;
    
    /** 关联功能分布 */
    private List<ReqFunctionDistributedVO> reqFunctionDistributed;
    
    /** 功能项ID */
    @Id
    @Column(name = "ID", length = 40)
    private String id;
    
    /** 中文名称 */
    @Column(name = "CN_NAME", length = 80)
    private String cnName;
    
    /** 业务域ID */
    @Column(name = "BIZ_DOMAIN_ID", length = 40)
    private String bizDomainId;
    
    /** 编码 */
    @Column(name = "CODE", length = 256)
    private String code;
    
    /** IT实现,0为是，1为否 */
    @Column(name = "IT_IMP", precision = 1)
    private Integer itImp;
    
    /** 需求分析 */
    @Column(name = "REQ_ANALYSIS", length = 500)
    private String reqAnalysis;
    
    /** 功能综述 */
    @Column(name = "FUNCTION_DESCRIPTION", length = 4000)
    private String functionDescription;
    
    /** 排序号 */
    @Column(name = "SORT_NO", precision = 10)
    private Integer sortNo;
    
    /** 备注 */
    @Column(name = "REMARK", length = 500)
    private String remark;
    
    /** 数据来源，1：导入；0：系统创建； */
    @Column(name = "DATA_FROM", precision = 1)
    private Integer dataFrom;
    
    /** 文档ID */
    @Column(name = "DOCUMENT_ID", length = 40)
    private String documentId;

    /** 上级业务域名称 */
    private String domainName;
    
    /** 编码表达式 */
    public static final String CODE_EXPR = "E-${domainCode}-${seq('ReqFunctionItem',3,1,1)}";
    
    /** 编码表达式 */
    public static final String SORT_EXPR = "${seq('${domainId}-ReqFunctionItem',6,1,1)}";
    
    /**
     * @return 获取 功能项ID属性值
     */
    
    public String getId() {
        return id;
    }
    
    /**
     * @param id 设置 功能项ID属性值为参数值 id
     */
    
    public void setId(String id) {
        this.id = id;
    }
    
    /**
     * @return 获取 中文名称属性值
     */
    
    public String getCnName() {
        return cnName;
    }
    
    /**
     * @param cnName 设置 中文名称属性值为参数值 cnName
     */
    
    public void setCnName(String cnName) {
        this.cnName = cnName;
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
     * @return 获取 编码属性值
     */
    
    public String getCode() {
        return code;
    }
    
    /**
     * @param code 设置 编码属性值为参数值 code
     */
    
    public void setCode(String code) {
        this.code = code;
    }
    
    /**
     * @return 获取 IT实现,0为是，1为否属性值
     */
    
    public Integer getItImp() {
        return itImp;
    }
    
    /**
     * @param itImp 设置 IT实现,0为是，1为否属性值为参数值 itImp
     */
    
    public void setItImp(Integer itImp) {
        this.itImp = itImp;
    }
    
    /**
     * @return 获取 需求分析属性值
     */
    
    public String getReqAnalysis() {
        return reqAnalysis;
    }
    
    /**
     * @param reqAnalysis 设置 需求分析属性值为参数值 reqAnalysis
     */
    
    public void setReqAnalysis(String reqAnalysis) {
        this.reqAnalysis = reqAnalysis;
    }
    
    /**
     * @return 获取 功能综述属性值
     */
    
    public String getFunctionDescription() {
        return functionDescription;
    }
    
    /**
     * @param functionDescription 设置 功能综述属性值为参数值 functionDescription
     */
    
    public void setFunctionDescription(String functionDescription) {
        this.functionDescription = functionDescription;
    }
    
    /**
     * @return 获取 排序号属性值
     */
    
    public Integer getSortNo() {
        return sortNo;
    }
    
    /**
     * @param sortNo 设置 排序号属性值为参数值 sortNo
     */
    
    public void setSortNo(Integer sortNo) {
        this.sortNo = sortNo;
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
     * @return 获取 domainName属性值
     */
    public String getDomainName() {
        return domainName;
    }
    
    /**
     * @param domainName 设置 domainName 属性值为参数值 domainName
     */
    public void setDomainName(String domainName) {
        this.domainName = domainName;
    }
    
    /**
     * @return 获取 reqFunctionRelFlow属性值
     */
    public List<ReqFunctionRelFlowVO> getReqFunctionRelFlow() {
        return reqFunctionRelFlow;
    }
    
    /**
     * @param reqFunctionRelFlow 设置 reqFunctionRelFlow 属性值为参数值 reqFunctionRelFlow
     */
    public void setReqFunctionRelFlow(List<ReqFunctionRelFlowVO> reqFunctionRelFlow) {
        this.reqFunctionRelFlow = reqFunctionRelFlow;
    }
    
    /**
     * @return 获取 reqFunctionRelItems属性值
     */
    public List<ReqFunctionRelItemsVO> getReqFunctionRelItems() {
        return reqFunctionRelItems;
    }
    
    /**
     * @param reqFunctionRelItems 设置 reqFunctionRelItems 属性值为参数值 reqFunctionRelItems
     */
    public void setReqFunctionRelItems(List<ReqFunctionRelItemsVO> reqFunctionRelItems) {
        this.reqFunctionRelItems = reqFunctionRelItems;
    }
    
    /**
     * @return 获取 reqFunctionDistributed属性值
     */
    public List<ReqFunctionDistributedVO> getReqFunctionDistributed() {
        return reqFunctionDistributed;
    }
    
    /**
     * @param reqFunctionDistributed 设置 reqFunctionDistributed 属性值为参数值 reqFunctionDistributed
     */
    public void setReqFunctionDistributed(List<ReqFunctionDistributedVO> reqFunctionDistributed) {
        this.reqFunctionDistributed = reqFunctionDistributed;
    }
    
}
