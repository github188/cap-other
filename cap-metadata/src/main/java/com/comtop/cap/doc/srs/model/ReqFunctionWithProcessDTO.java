/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.srs.model;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.document.word.docmodel.data.BaseDTO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 需求功能项-流程DTO
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年12月24日 lizhongwen
 */
@DataTransferObject
public class ReqFunctionWithProcessDTO extends BaseDTO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 功能项ID */
    private String itemId;
    
    /** 功能项编码 */
    private String itemCode;
    
    /** 功能项名称 */
    private String itemName;
    
    /** 流程Id */
    private String flowId;
    
    /** 是否IT实现 */
    private Integer itImp;
    
    /** 是否IT实现 */
    private String itImpStr;
    
    /** 需求分析 */
    private String reqAnalysis;
    
    /** 说明 */
    private String description;
    
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
     * @return 获取 flowId属性值
     */
    public String getFlowId() {
        return flowId;
    }
    
    /**
     * @param flowId 设置 flowId 属性值为参数值 flowId
     */
    public void setFlowId(String flowId) {
        this.flowId = flowId;
    }
    
    /**
     * @return 获取 itImp属性值
     */
    public Integer getItImp() {
        if (itImp == null && ("√".equals(itImpStr) || "是".equals(itImpStr))) {
            this.itImp = 0;
        } else {
            this.itImp = 1;
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
        if (StringUtils.isBlank(itImpStr) && itImp != null && itImp == 0) {
            this.itImpStr = "√";
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
     * @return 获取 reqAnalysis属性值
     */
    public String getReqAnalysis() {
        return reqAnalysis;
    }
    
    /**
     * @param reqAnalysis 设置 reqAnalysis 属性值为参数值 reqAnalysis
     */
    public void setReqAnalysis(String reqAnalysis) {
        this.reqAnalysis = reqAnalysis;
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
}
