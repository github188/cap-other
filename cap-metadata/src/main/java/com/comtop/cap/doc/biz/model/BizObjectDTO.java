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
 * 业务对象基本信息DTO
 * 
 * @author 李志勇
 * @since 1.0
 * @version 2015-11-10 李志勇
 */
@DataTransferObject
public class BizObjectDTO extends BaseDTO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 子对象集 */
    private List<BizObjectDTO> childs;
    
    /** 根据关系RelData生成业务对象数据项集合,由CIP自动创建。 */
    private List<BizObjectDataItemDTO> dataItemList;
    
    /** 流程节点 */
    private BizProcessNodeDTO bizProcessNode;
    
    /** 包名 */
    private String packageName;
    
    /** 对象类型 包还是具体的对象 */
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
     * @return 获取 dataItemList属性值
     */
    public List<BizObjectDataItemDTO> getDataItemList() {
        return dataItemList;
    }
    
    /**
     * @param dataItemList 设置 dataItemList 属性值为参数值 dataItemList
     */
    public void setDataItemList(List<BizObjectDataItemDTO> dataItemList) {
        this.dataItemList = dataItemList;
    }
    
    /**
     * @return 获取 childs属性值
     */
    public List<BizObjectDTO> getChilds() {
        return childs;
    }
    
    /**
     * @param childs 设置 childs 属性值为参数值 childs
     */
    public void setChilds(List<BizObjectDTO> childs) {
        this.childs = childs;
    }
    
    /**
     * @return 获取 bizProcessNode属性值
     */
    public BizProcessNodeDTO getBizProcessNode() {
        return bizProcessNode;
    }
    
    /**
     * @param bizProcessNode 设置 bizProcessNode 属性值为参数值 bizProcessNode
     */
    public void setBizProcessNode(BizProcessNodeDTO bizProcessNode) {
        this.bizProcessNode = bizProcessNode;
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
