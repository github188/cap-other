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
 * 页面参数首选项
 *
 * @author 肖威
 * @version jdk1.6
 * @version 2015-12-29 
 */
@DataTransferObject
public class PageTemplateActionPreferenceVO extends BaseModel {
    
    /** 序列化版本ID */
    private static final long serialVersionUID = 9154087864229538431L;
    
    /**
     * 构造函数
     */
    public PageTemplateActionPreferenceVO() {
        this.setModelId("preference.config.pageTemplateAction.pageTemplateAction");
        this.setModelPackage("preference.config");
        this.setModelName("pageTemplateAction");
        this.setModelType("pageTemplateAction");
    }
    
    /**
     * 获取自定义modelId
     * @return 字符
     */
    public static String getCustomModelId(){
    	return "preference.config.pageTemplateAction.CustomPageTemplateAction";
    }
    
    /**
     * 创建自定义渲染行为配置文件
     * @return 配置对象
     */
    public static PageTemplateActionPreferenceVO createCustomActionPreference(){
    	PageTemplateActionPreferenceVO obj = new PageTemplateActionPreferenceVO();
    	String strExtend = obj.getModelId();
    	obj.setExtend(strExtend);
    	obj.setModelId(getCustomModelId());
    	obj.setModelName("CustomPageTemplateAction");
    	return obj;
    }
    
    /**  */
    private List<PageTemplateActionVO> lstActions = new ArrayList<PageTemplateActionVO>();

	/**
	 * @return the lstActions
	 */
	public List<PageTemplateActionVO> getLstActions() {
		return lstActions;
	}

	/**
	 * @param lstActions the lstActions to set
	 */
	public void setLstActions(List<PageTemplateActionVO> lstActions) {
		this.lstActions = lstActions;
	}

}
