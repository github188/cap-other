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
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 内置行为函数首选项
 * 
 * @author 诸焕辉
 * @version jdk1.6
 * @version 2015-7-22 诸焕辉
 */
@DataTransferObject
public class BuiltInActionPreferenceVO extends BaseModel {
    
    /** 标识 */
    private static final long serialVersionUID = 5966461224961964523L;
    
    /** 内置行为函数 */
    private List<BuiltInActionVO> builtInActionList = new ArrayList<BuiltInActionVO>();
    
    /**
     * 构造函数
     */
    public BuiltInActionPreferenceVO() {
        this.setModelId("preference.page.builtInAction.builtInActions");
        this.setModelPackage("preference.page");
        this.setModelName("builtInActions");
        this.setModelType("builtInAction");
    }
    
    /**
     * @return 获取 builtInActionList属性值
     */
    public List<BuiltInActionVO> getBuiltInActionList() {
        return builtInActionList;
    }
    
    /**
     * @param builtInActionList 设置 builtInActionList 属性值为参数值 builtInActionList
     */
    public void setBuiltInActionList(List<BuiltInActionVO> builtInActionList) {
        this.builtInActionList = builtInActionList;
    }
}
