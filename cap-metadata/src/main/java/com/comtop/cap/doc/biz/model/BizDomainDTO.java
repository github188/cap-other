/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.biz.model;

import java.util.ArrayList;
import java.util.List;

import com.comtop.cap.document.word.docmodel.data.BaseDTO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 业务域DTO
 * 
 * @author 李志勇
 * @since 1.0
 * @version 2015-11-3 李志勇
 */
@DataTransferObject
public class BizDomainDTO extends BaseDTO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 父ID */
    private String parentId;
    
    /** 简称 */
    private String shortName;
    
    /** 上级业务域id */
    private String parentName;
    
    /** 上级业务域id */
    private List<BizItemDTO> bizItems;
    
    /**
     * @return 获取 parentId属性值
     */
    public String getParentId() {
        return parentId;
    }
    
    /**
     * @param parentId 设置 parentId 属性值为参数值 parentId
     */
    public void setParentId(String parentId) {
        this.parentId = parentId;
    }
    
    /**
     * @return 获取 shortName属性值
     */
    public String getShortName() {
        return shortName;
    }
    
    /**
     * @param shortName 设置 shortName 属性值为参数值 shortName
     */
    public void setShortName(String shortName) {
        this.shortName = shortName;
    }
    
    /**
     * @return 获取 parentName属性值
     */
    public String getParentName() {
        return parentName;
    }
    
    /**
     * @param parentName 设置 parentName 属性值为参数值 parentName
     */
    public void setParentName(String parentName) {
        this.parentName = parentName;
    }
    
    /**
     * @param bizItemsList 设置 bizProcessNodes 属性值为参数值 bizProcessNodes
     */
    public void addBizItems(List<BizItemDTO> bizItemsList) {
        if (bizItemsList != null && bizItemsList.size() > 0) {
            for (BizItemDTO bizItemDTO : bizItemsList) {
                addBizItem(bizItemDTO);
            }
        }
    }
    
    /**
     * @param bizItemDTO 添加的业务事项
     */
    public void addBizItem(BizItemDTO bizItemDTO) {
        if (this.bizItems == null) {
            bizItems = new ArrayList<BizItemDTO>(10);
        }
        bizItems.add(bizItemDTO);
        bizItemDTO.setBizDomainDTO(this);
    }
    
    /**
     * @return 获取 bizItems属性值
     */
    public List<BizItemDTO> getBizItems() {
        return bizItems;
    }
    
    /**
     * @param bizItems 设置 bizItems 属性值为参数值 bizItems
     */
    public void setBizItems(List<BizItemDTO> bizItems) {
        this.bizItems = bizItems;
    }
    
}
