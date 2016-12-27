/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.req.subfunc.model;

import java.util.HashSet;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.apache.commons.lang.StringUtils;

import com.comtop.top.core.base.model.CoreVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 功能子项,建在功能项下面
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-11-25 CAP
 */
@DataTransferObject
@Table(name = "CAP_REQ_FUNCTION_SUBITEM")
public class ReqFunctionSubitemVO extends CoreVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 子项ID */
    @Id
    @Column(name = "ID", length = 40)
    private String id;
    
    /** 功能项ID */
    @Column(name = "ITEM_ID", length = 40)
    private String itemId;
    
    /** 功能项名称 */
    @Transient
    private String itemName;
    
    /** 功能项编码 */
    @Transient
    private String itemCode;
    
    /** 业务域id */
    @Transient
    private String domainId;
    
    /** 名称 */
    @Column(name = "NAME", length = 40)
    private String name;
    
    /** 中文名称 */
    @Column(name = "CN_NAME", length = 80)
    private String cnName;
    
    /** 编码 */
    @Column(name = "CODE", length = 256)
    private String code;
    
    /** 节点ID集合 */
    @Column(name = "NODE_IDS", length = 1200)
    private String nodeIds;
    
    /** 节点名称集合 */
    private String nodeNames;
    
    /** 业务对象ID集合 */
    @Column(name = "BIZ_OBJECT_IDS", length = 1200)
    private String bizObjectIds;
    
    /** 业务对象名称集合 */
    private String bizObjectNames;
    
    /** 排序号 */
    @Column(name = "SORT_NO", precision = 10)
    private Integer sortNo;
    
    /** IT实现 */
    @Column(name = "IT_IMP", precision = 1)
    private Integer itImp;
    
    /** 需求分析 */
    @Column(name = "REQ_ANALYSIS", length = 500)
    private String reqAnalysis;
    
    /** 备注 */
    @Column(name = "REMARK", length = 500)
    private String remark;
    
    /** 说明 */
    @Column(name = "FUNCTION_DESCRIPTION", length = 4000)
    private String functionDescription;
    
    /** 数据来源，1：导入；0：系统创建； */
    @Column(name = "DATA_FROM", precision = 1)
    private Integer dataFrom;
    
    /** 文档ID */
    @Column(name = "DOCUMENT_ID", length = 40)
    private String documentId;
    
    /**查询ID*/
    private String queryId;

    /** 编码表达式 */
    public static final String CODE_EXPR = "${itemCode}-${seq('ReqFunctionSubitem',3,1,1)}";
    
    /** 编码表达式 */
    public static final String SORT_EXPR = "${seq('${itemCode}-ReqFunctionSubitem',6,1,1)}";
    
    /**
     * @return 获取 子项ID属性值
     */
    
    public String getId() {
        return id;
    }
    
    /**
     * @param id 设置 子项ID属性值为参数值 id
     */
    
    public void setId(String id) {
        this.id = id;
    }
    
    /**
     * @return 获取 功能项ID属性值
     */
    
    public String getItemId() {
        return itemId;
    }
    
    /**
     * @param itemId 设置 功能项ID属性值为参数值 itemId
     */
    
    public void setItemId(String itemId) {
        this.itemId = itemId;
    }
    
    /**
     * @return 获取 itemCode属性值
     */
    public String getItemCode() {
        return itemCode;
    }
    
    /**
     * @param itemCode 设置 itemCode 属性值为参数值 itemCode
     */
    public void setItemCode(String itemCode) {
        this.itemCode = itemCode;
    }
    
    /**
     * @return 获取 itemName属性值
     */
    public String getItemName() {
        return itemName;
    }
    
    /**
     * @param itemName 设置 itemName 属性值为参数值 itemName
     */
    public void setItemName(String itemName) {
        this.itemName = itemName;
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
     * 
     * 获取节点ID集合
     * 
     * @return 节点ID集合
     */
    public String getNodeIds() {
        return nodeIds;
    }
    
    /**
     * 设置节点ID集合
     * 
     * @param nodeIds 节点ID集合
     */
    public void setNodeIds(String nodeIds) {
        this.nodeIds = nodeIds;
    }
    
    /**
     * 获取节点name集合
     * 
     * @return 节点name集合
     */
    public String getNodeNames() {
        return nodeNames;
    }
    
    /**
     * 设置节点name集合
     * 
     * @param nodeNames 节点name集合
     */
    public void setNodeNames(String nodeNames) {
        this.nodeNames = nodeNames;
    }
    
    /**
     * 获取业务对象id集合
     * 
     * @return 业务对象id集合
     */
    public String getBizObjectIds() {
        return bizObjectIds;
    }
    
    /**
     * @return 获取 bizObjIds属性值
     */
    public Set<String> getBizObjIds() {
        Set<String> idSet = new HashSet<String>();
        if (StringUtils.isBlank(bizObjectIds)) {
            return idSet;
        }
        String[] ids = bizObjectIds.split(",");
        if (ids == null) {
            return idSet;
        }
        for (String str : ids) {
            idSet.add(str);
        }
        return idSet;
    }
    
    /**
     * 设置业务对象id集合
     * 
     * @param bizObjectIds 业务对象id集合
     */
    public void setBizObjectIds(String bizObjectIds) {
        this.bizObjectIds = bizObjectIds;
    }
    
    /**
     * 获取业务对象名称集合
     * 
     * @return 业务对象名称集合
     */
    public String getBizObjectNames() {
        return bizObjectNames;
    }
    
    /**
     * 设置业务对象名称集合
     * 
     * @param bizObjectNames 业务对象名称集合
     */
    public void setBizObjectNames(String bizObjectNames) {
        this.bizObjectNames = bizObjectNames;
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
     * @return 获取 IT实现属性值
     */
    
    public Integer getItImp() {
        return itImp;
    }
    
    /**
     * @param itImp 设置 IT实现属性值为参数值 itImp
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
     * @return 获取 说明属性值
     */
    
    public String getFunctionDescription() {
        return functionDescription;
    }
    
    /**
     * @param functionDescription 设置 说明属性值为参数值 functionDescription
     */
    
    public void setFunctionDescription(String functionDescription) {
        this.functionDescription = functionDescription;
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
     * 获取查询ID
     * @return 查询ID
     */
	public String getQueryId() {
		return queryId;
	}

	/**
	 * 设置查询ID
	 * @param queryId 查询ID
	 */
	public void setQueryId(String queryId) {
		this.queryId = queryId;
	}

	@Override
	public String toString() {
		return "ReqFunctionSubitemVO [id=" + id + ", itemId=" + itemId
				+ ", itemName=" + itemName + ", itemCode=" + itemCode
				+ ", domainId=" + domainId + ", name=" + name + ", cnName="
				+ cnName + ", code=" + code + ", nodeIds=" + nodeIds
				+ ", nodeNames=" + nodeNames + ", bizObjectIds=" + bizObjectIds
				+ ", bizObjectNames=" + bizObjectNames + ", sortNo=" + sortNo
				+ ", itImp=" + itImp + ", reqAnalysis=" + reqAnalysis
				+ ", remark=" + remark + ", functionDescription="
				+ functionDescription + ", dataFrom=" + dataFrom
				+ ", documentId=" + documentId + "]";
	}
    

    
}
