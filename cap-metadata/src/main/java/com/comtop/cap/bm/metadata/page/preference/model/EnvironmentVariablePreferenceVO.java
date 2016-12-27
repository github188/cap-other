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
 * 环境变量首选项
 * 
 * @author 诸焕辉
 * @version jdk1.6
 * @version 2015-5-28 诸焕辉
 */
@DataTransferObject
public class EnvironmentVariablePreferenceVO extends BaseModel {
    
    /** 标识 */
    private static final long serialVersionUID = 5966461224961964523L;
    
    /**
     * 构造函数
     */
    public EnvironmentVariablePreferenceVO() {
        this.setModelId("preference.page.environmentVariable.environmentVariables");
        this.setModelPackage("preference.page");
        this.setModelName("environmentVariables");
        this.setModelType("environmentVariable");
    }
    
    /**
     * 获取自定义modelId
     * @return 字符
     */
    public static String getCustomModelId(){
    	return "preference.page.environmentVariable.CustomEnvironmentVariables";
    }
    
    /**
     * 创建自定义渲染行为配置文件
     * @return 配置对象
     */
    public static EnvironmentVariablePreferenceVO createCustomVariablePreference(){
    	EnvironmentVariablePreferenceVO obj = new EnvironmentVariablePreferenceVO();
    	String strExtend = obj.getModelId();
    	obj.setExtend(strExtend);
    	obj.setModelId(getCustomModelId());
    	obj.setModelName("CustomEnvironmentVariables");
    	return obj;
    }
    
    /** 系统环境变量清单 */
    private List<EnvironmentVariableVO> environmentVariableList = new ArrayList<EnvironmentVariableVO>();
    
    /**
     * @return 获取 environmentVariableList属性值
     */
    public List<EnvironmentVariableVO> getEnvironmentVariableList() {
        return environmentVariableList;
    }
    
    /**
     * @param environmentVariableList 设置 environmentVariableList 属性值为参数值 environmentVariableList
     */
    public void setEnvironmentVariableList(List<EnvironmentVariableVO> environmentVariableList) {
        this.environmentVariableList = environmentVariableList;
    }
}
