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
 * 引入文件首选项
 *
 * @author 诸焕辉
 * @version jdk1.6
 * @version 2015-5-28 诸焕辉
 */
@DataTransferObject
public class IncludeFilePreferenceVO extends BaseModel {
    
    /** 标识 */
    private static final long serialVersionUID = 5966461224961964523L;
    
    /**
     * 构造函数
     */
    public IncludeFilePreferenceVO() {
        this.setModelId("preference.page.includeFile.includeFiles");
        this.setModelPackage("preference.page");
        this.setModelName("includeFiles");
        this.setModelType("includeFile");
    }
    
    /**
     * 获取自定义modelId
     * @return 字符
     */
    public static String getCustomModelId(){
    	return "preference.page.includeFile.CustomIncludeFiles";
    }
    
    /**
     * 创建自定义渲染行为配置文件
     * @return 配置对象
     */
    public static IncludeFilePreferenceVO createCustomIncludeFilePreference(){
    	IncludeFilePreferenceVO obj = new IncludeFilePreferenceVO();
    	String strExtend = obj.getModelId();
    	obj.setExtend(strExtend);
    	obj.setModelId(getCustomModelId());
    	obj.setModelName("CustomIncludeFiles");
    	return obj;
    }
    
    /** 页面引入的JSP清单 */
    private List<IncludeFileVO> jspList = new ArrayList<IncludeFileVO>();
    
    /** 页面引入的JS清单 */
    private List<IncludeFileVO> jsList = new ArrayList<IncludeFileVO>();
    
    /** 页面引入的CSS清单 */
    private List<IncludeFileVO> cssList = new ArrayList<IncludeFileVO>();
    
    /**
     * @return 获取 jspList属性值
     */
    public List<IncludeFileVO> getJspList() {
        return jspList;
    }
    
    /**
     * @param jspList 设置 jspList 属性值为参数值 jspList
     */
    public void setJspList(List<IncludeFileVO> jspList) {
        this.jspList = jspList;
    }
    
    /**
     * @return 获取 jsList属性值
     */
    public List<IncludeFileVO> getJsList() {
        return jsList;
    }
    
    /**
     * @param jsList 设置 jsList 属性值为参数值 jsList
     */
    public void setJsList(List<IncludeFileVO> jsList) {
        this.jsList = jsList;
    }
    
    /**
     * @return 获取 cssList属性值
     */
    public List<IncludeFileVO> getCssList() {
        return cssList;
    }
    
    /**
     * @param cssList 设置 cssList 属性值为参数值 cssList
     */
    public void setCssList(List<IncludeFileVO> cssList) {
        this.cssList = cssList;
    }
}
