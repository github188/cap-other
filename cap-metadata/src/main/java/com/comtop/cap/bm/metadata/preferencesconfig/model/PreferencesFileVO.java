/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.preferencesconfig.model;

import java.util.ArrayList;
import java.util.List;

import javax.xml.bind.annotation.XmlRootElement;

import com.comtop.cap.bm.metadata.base.model.BaseModel;

/**
 * 首选项配置VO
 *
 * @author 罗珍明
 * @version jdk1.6
 * @version 2015-12-31 
 */
@XmlRootElement(name = "Preferences")
public class PreferencesFileVO extends BaseModel {
	
	 /**
     * 构造函数
     */
    public PreferencesFileVO() {
        this.setModelId("preference.config.preferenceConfig.Preferences");
        this.setModelPackage("preference.config");
        this.setModelName("Preferences");
        this.setModelType("preferenceConfig");
    }
    
    /**
     * 返回可修改的首选配置Id
     * @return 字符串
     */
    public static String getCustomPreferModelId(){
    	return "preference.config.preferenceConfig.CustomPreferences";
    }
    
    /**
     * 获取首选项默认配置
     * 
     * @return 获取首选项默认配置
     */
    public static String getDefaultPreferModelId(){
    	return "preference.config.preferenceConfig.Preferences";
    }
    
    /**
     * 返回可修改的首选配置Id
     * @return 字符串
     */
    public static PreferencesFileVO createCustomPrefer(){
    	PreferencesFileVO obj = new PreferencesFileVO();
    	obj.setExtend(obj.getModelId());
    	obj.setModelId(getCustomPreferModelId());
    	obj.setModelName("CustomPreferences");
    	return obj;
    }
    
    /**
     * 首选项配置
     */
    private List<PreferenceConfigVO> subConfig = new ArrayList<PreferenceConfigVO>();

	/**
	 * @return the subConfig
	 */
	public List<PreferenceConfigVO> getSubConfig() {
		return subConfig;
	}

	/**
	 * @param subConfig the subConfig to set
	 */
	public void setSubConfig(List<PreferenceConfigVO> subConfig) {
		this.subConfig = subConfig;
	}

}
