/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.srs.model;

import java.util.Map;

import com.comtop.cap.document.word.docmodel.data.BaseDTO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 业务功能项DTO
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年12月24日 lizhongwen
 */
@DataTransferObject
public class ReqFunctionItemDTO extends BaseDTO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 业务描述 */
    private String description;
    
    /** IT实现,0为是，1为否 */
    private Integer itImp;
    
    /** IT实现,0为是，1为否 */
    private String itImpStr;
    
    /** 功能分布 */
    private Map<String, String> distributed;
    
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
     * @return 获取 distributed属性值
     */
    public Map<String, String> getDistributed() {
        return distributed;
    }
    
    /**
     * @param distributed 设置 distributed 属性值为参数值 distributed
     */
    public void setDistributed(Map<String, String> distributed) {
        this.distributed = distributed;
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
     * @param itImp 设置 itImp 属性值为参数值 itImp
     */
    public void setItImp(Integer itImp) {
        this.itImp = itImp;
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
}
