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
import com.comtop.cap.bm.metadata.page.desinger.model.PageAttributeVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 页面参数首选项
 *
 * @author 凌晨
 * @version jdk1.6
 * @version 2015-8-5 凌晨
 */
@DataTransferObject
public class PageAttributePreferenceVO extends BaseModel {
    
    /** 序列化版本ID */
    private static final long serialVersionUID = 9154087864229538660L;
    
    /**
     * 构造函数
     */
    public PageAttributePreferenceVO() {
        this.setModelId("preference.page.pageParameter.pageParameters");
        this.setModelPackage("preference.page");
        this.setModelName("pageParameters");
        this.setModelType("pageParameter");
    }
    
    /** 页面的页面参数清单 */
    private List<PageAttributeVO> parameterList = new ArrayList<PageAttributeVO>();
    
    /**
     * @return 获取 parameterList属性值
     */
    public List<PageAttributeVO> getParameterList() {
        return parameterList;
    }
    
    /**
     * @param parameterList 设置 parameterList 属性值为参数值 parameterList
     */
    public void setParameterList(List<PageAttributeVO> parameterList) {
        this.parameterList = parameterList;
    }
    
}
