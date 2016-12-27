/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.biz.model;

import java.util.List;

import com.comtop.cap.document.word.docmodel.data.BaseDTO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 业务表单DTO
 * 
 * @author 李志勇
 * @since 1.0
 * @version 2015-11-17 李志勇
 */
@DataTransferObject
public class BizFormDTO extends BaseDTO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 业务表单数据项 */
    private List<BizFormDataItemDTO> dataItemList;
    
    /** 业务节点清单 */
    private List<BizProcessNodeDTO> bizProcessNodes;
    
    /*** 子级业务表单 */
    private List<BizFormDTO> childs;
    
    /** 包名 */
    private String packageName;
    
    /** 表单类型 包还是具体的表单 */
    private int packageFlag = 0;
    
    /**
     * @return 获取 packageName属性值
     */
    public String getPackageName() {
        return packageName;
    }
    
    /**
     * @param packageName 设置 packageName 属性值为参数值 packageName
     */
    public void setPackageName(String packageName) {
        this.packageName = packageName;
    }
    
    /**
     * @return 获取 bizProcessNodes属性值
     */
    public List<BizProcessNodeDTO> getBizProcessNodes() {
        return bizProcessNodes;
    }
    
    /**
     * @param bizProcessNodes 设置 bizProcessNodes 属性值为参数值 bizProcessNodes
     */
    public void setBizProcessNodes(List<BizProcessNodeDTO> bizProcessNodes) {
        this.bizProcessNodes = bizProcessNodes;
    }
    
    /**
     * @return 获取 dataItemList属性值
     */
    public List<BizFormDataItemDTO> getDataItemList() {
        return dataItemList;
    }
    
    /**
     * @param dataItemList 设置 dataItemList 属性值为参数值 dataItemList
     */
    public void setDataItemList(List<BizFormDataItemDTO> dataItemList) {
        this.dataItemList = dataItemList;
    }
    
    /**
     * @return 获取 childs属性值
     */
    public List<BizFormDTO> getChilds() {
        return childs;
    }
    
    /**
     * @param childs 设置 childs 属性值为参数值 childs
     */
    public void setChilds(List<BizFormDTO> childs) {
        this.childs = childs;
    }
    
    /**
     * @return 获取 packageFlag属性值
     */
    public int getPackageFlag() {
        return packageFlag;
    }
    
    /**
     * @param packageFlag 设置 packageFlag 属性值为参数值 packageFlag
     */
    public void setPackageFlag(int packageFlag) {
        this.packageFlag = packageFlag;
    }
    
}
