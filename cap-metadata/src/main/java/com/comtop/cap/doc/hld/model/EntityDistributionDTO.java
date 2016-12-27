/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.hld.model;

import java.util.Map;

import com.comtop.cap.document.word.docmodel.data.BaseDTO;

/**
 * 概念模型分布、逻辑模型分布
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年12月30日 lizhiyong
 */
public class EntityDistributionDTO extends BaseDTO {
    
    /** FIXME */
    private static final long serialVersionUID = 1L;
    
    /** 概念实体分布 */
    private Map<String, String> distributionMap;
    
    /** 一级模块 */
    private String firstLevelModuleName;
    
    /** 一级模块 */
    private String firstLevelModuleCode;
    
    /** 一级模块 */
    private String firstLevelModuleId;
    
    /** 一级应用 */
    private String firstLevelAppName;
    
    /** 一级应用 */
    private String firstLevelAppCode;
    
    /** 一级应用 */
    private String firstLevelAppId;
    
    /**
     * @return 获取 distributionMap属性值
     */
    public Map<String, String> getDistributionMap() {
        return distributionMap;
    }
    
    /**
     * @param distributionMap 设置 distributionMap 属性值为参数值 distributionMap
     */
    public void setDistributionMap(Map<String, String> distributionMap) {
        this.distributionMap = distributionMap;
    }
    
    /**
     * @return 获取 firstLevelModuleCode属性值
     */
    public String getFirstLevelModuleCode() {
        return firstLevelModuleCode;
    }
    
    /**
     * @param firstLevelModuleCode 设置 firstLevelModuleCode 属性值为参数值 firstLevelModuleCode
     */
    public void setFirstLevelModuleCode(String firstLevelModuleCode) {
        this.firstLevelModuleCode = firstLevelModuleCode;
    }
    
    /**
     * @return 获取 firstLevelModuleId属性值
     */
    public String getFirstLevelModuleId() {
        return firstLevelModuleId;
    }
    
    /**
     * @param firstLevelModuleId 设置 firstLevelModuleId 属性值为参数值 firstLevelModuleId
     */
    public void setFirstLevelModuleId(String firstLevelModuleId) {
        this.firstLevelModuleId = firstLevelModuleId;
    }
    
    /**
     * @return 获取 firstLevelModuleName属性值
     */
    public String getFirstLevelModuleName() {
        return firstLevelModuleName;
    }
    
    /**
     * @param firstLevelModuleName 设置 firstLevelModuleName 属性值为参数值 firstLevelModuleName
     */
    public void setFirstLevelModuleName(String firstLevelModuleName) {
        this.firstLevelModuleName = firstLevelModuleName;
    }
    
    /**
     * @return 获取 firstLevelAppName属性值
     */
    public String getFirstLevelAppName() {
        return firstLevelAppName;
    }
    
    /**
     * @param firstLevelAppName 设置 firstLevelAppName 属性值为参数值 firstLevelAppName
     */
    public void setFirstLevelAppName(String firstLevelAppName) {
        this.firstLevelAppName = firstLevelAppName;
    }
    
    /**
     * @return 获取 firstLevelAppCode属性值
     */
    public String getFirstLevelAppCode() {
        return firstLevelAppCode;
    }
    
    /**
     * @param firstLevelAppCode 设置 firstLevelAppCode 属性值为参数值 firstLevelAppCode
     */
    public void setFirstLevelAppCode(String firstLevelAppCode) {
        this.firstLevelAppCode = firstLevelAppCode;
    }
    
    /**
     * @return 获取 firstLevelAppId属性值
     */
    public String getFirstLevelAppId() {
        return firstLevelAppId;
    }
    
    /**
     * @param firstLevelAppId 设置 firstLevelAppId 属性值为参数值 firstLevelAppId
     */
    public void setFirstLevelAppId(String firstLevelAppId) {
        this.firstLevelAppId = firstLevelAppId;
    }
    
}
