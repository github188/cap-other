/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.srs.model;

import java.util.HashSet;
import java.util.Set;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.document.word.docmodel.data.BaseDTO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 功能子项
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年12月24日 lizhongwen
 */
@DataTransferObject
public class ReqFunctionSubitemDTO extends BaseDTO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 功能项ID */
    private String itemId;
    
    /** 功能项编码 */
    private String itemCode;
    
    /** 功能项 */
    private String itemName;
    
    /** 业务环节 */
    private String bizLink;
    
    /** 是否IT实现 */
    private Integer itImp;
    
    /** IT实现,0为是，1为否 */
    private String itImpStr;
    
    /** 需求分析 */
    private String analysis;
    
    /** 说明 */
    private String description;
    
    /** 流程节点 */
    private String nodeNames;
    
    /** 业务对象ID集合 */
    private String bizObjectIds;
    
    /**
     * @return 获取 itemId属性值
     */
    public String getItemId() {
        return itemId;
    }
    
    /**
     * @param itemId 设置 itemId 属性值为参数值 itemId
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
     * @return 获取 bizLink属性值
     */
    public String getBizLink() {
        return bizLink;
    }
    
    /**
     * @param bizLink 设置 bizLink 属性值为参数值 bizLink
     */
    public void setBizLink(String bizLink) {
        this.bizLink = bizLink;
    }
    
    /**
     * @return 获取 itImp属性值
     */
    public Integer getItImp() {
        if ("√".equals(itImpStr) || "是".equals(itImpStr)) {
            this.itImp = 0;
        } else {
            this.itImp = null;
        }
        return itImp;
    }
    
    /**
     * @param itImp 设置 itImp 属性值为参数值 itImp
     */
    public void setItImp(Integer itImp) {
        this.itImp = itImp;
    }
    
    /**
     * @return 获取 itImpStr属性值
     */
    public String getItImpStr() {
        if (itImp != null && itImp == 0) {
            this.itImpStr = "√";
        } else {
            this.itImpStr = "";
        }
        return itImpStr;
    }
    
    /**
     * @param itImpStr 设置 itImpStr 属性值为参数值 itImpStr
     */
    public void setItImpStr(String itImpStr) {
        this.itImpStr = itImpStr;
    }
    
    /**
     * @return 获取 analysis属性值
     */
    public String getAnalysis() {
        return analysis;
    }
    
    /**
     * @param analysis 设置 analysis 属性值为参数值 analysis
     */
    public void setAnalysis(String analysis) {
        this.analysis = analysis;
    }
    
    /**
     * @return 获取 description属性值
     */
    @Override
    public String getDescription() {
        return description;
    }
    
    /**
     * @param description 设置 description 属性值为参数值 description
     */
    @Override
    public void setDescription(String description) {
        this.description = description;
    }
    
    /**
     * @return 获取 nodeNames属性值
     */
    public String getNodeNames() {
        return nodeNames;
    }
    
    /**
     * @param nodeNames 设置 nodeNames 属性值为参数值 nodeNames
     */
    public void setNodeNames(String nodeNames) {
        this.nodeNames = nodeNames;
    }
    
    /**
     * @return 获取 bizObjectIds属性值
     */
    public String getBizObjectIds() {
        return bizObjectIds;
    }
    
    /**
     * @param bizObjectIds 设置 bizObjectIds 属性值为参数值 bizObjectIds
     */
    public void setBizObjectIds(String bizObjectIds) {
        this.bizObjectIds = bizObjectIds;
    }
    
    /**
     * @return 获取 bizObjIds属性值
     */
    public Set<String> getBizObjIds() {
        Set<String> colIdSet = new HashSet<String>();
        if (StringUtils.isBlank(bizObjectIds)) {
            return colIdSet;
        }
        String[] objIds = bizObjectIds.split(",");
        if (objIds == null) {
            return colIdSet;
        }
        for (String strID : objIds) {
            colIdSet.add(strID);
        }
        return colIdSet;
    }
}
