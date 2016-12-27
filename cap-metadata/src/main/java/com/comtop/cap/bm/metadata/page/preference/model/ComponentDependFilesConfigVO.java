/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.preference.model;

import java.util.ArrayList;
import java.util.List;

import com.comtop.cap.bm.metadata.base.model.BaseModel;
import com.comtop.cap.bm.metadata.common.dwr.CapMap;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 控件依赖文件配置
 *
 * @author 诸焕辉
 * @version jdk1.6
 * @version 2016-3-30 诸焕辉
 */
@DataTransferObject
public class ComponentDependFilesConfigVO extends BaseModel {
    
    /** 标识 */
    private static final long serialVersionUID = 5966461224961964523L;
    
    /**
     * 构造函数
     */
    public ComponentDependFilesConfigVO() {
        this.setModelId("preference.page.componentDependFilesConfig.dependFilesChangeInfo");
        this.setModelPackage("preference.page");
        this.setModelName("dependFilesChangeInfo");
        this.setModelType("componentDependFilesConfig");
    }
    
    /** 替换文件和被替换文件映射关系 */
    private List<CapMap> dependFilesChangeInfoList = new ArrayList<CapMap>();
    
    /**
     * @return 获取 dependFilesChangeInfoList属性值
     */
    public List<CapMap> getDependFilesChangeInfoList() {
        return dependFilesChangeInfoList;
    }
    
    /**
     * @param dependFilesChangeInfoList 设置 dependFilesChangeInfoList 属性值为参数值 dependFilesChangeInfoList
     */
    public void setDependFilesChangeInfoList(List<CapMap> dependFilesChangeInfoList) {
        this.dependFilesChangeInfoList = dependFilesChangeInfoList;
    }
}
