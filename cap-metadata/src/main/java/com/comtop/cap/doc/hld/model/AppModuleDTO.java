/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.hld.model;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.document.word.docmodel.data.BaseDTO;

/**
 * 应用 模块 数据主题
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年12月30日 lizhiyong
 */
public class AppModuleDTO extends BaseDTO {
    
    /** 序列号 */
    private static final long serialVersionUID = 1L;
    
    /** 上级id */
    private String parentId;
    
    /** 上级名称 */
    private String parentName;
    
    /** 类型 */
    private String type;
    
    /** 系统id */
    private String rootId;
    
    /** 系统id */
    private String rootName;
    
    /** 系统id */
    private String rootCode;
    
    /** 一级模块id */
    private String firstLevelModuleId;
    
    /** 一级模块名称 */
    private String firstLevelModuleName;
    
    /** 一级模块编码 */
    private String firstLevelModuleCode;
    
    /** 二级模块id */
    private String secondLevelModuleId;
    
    /** 二级模块名称 */
    private String secondLevelModuleName;
    
    /** 二级模块编码 */
    private String secondLevelModuleCode;
    
    /** 一级应用id */
    private String firstLevelAppId;
    
    /** 一级应用名称 */
    private String firstLevelAppName;
    
    /** 一级应用编码 */
    private String firstLevelAppCode;
    
    /** 二级应用id */
    private String secondLevelAppId;
    
    /** 二级应用名称 */
    private String secondLevelAppName;
    
    /** 二级应用编码 */
    private String secondLevelAppCode;
    
    /** 功能项id */
    private String funcItemIds;
    
    /** 功能项名称 */
    private String funcItemNames;
    
    /** 功能项编码 */
    private String funcItemCodes;
    
    /** 功能子项id */
    private String funcSubItemIds;
    
    /** 功能子项名称 */
    private String funcSubItemNames;
    
    /** 功能子项编码 */
    private String funcSubItemCodes;
    
    @Override
    public boolean equals(Object obj) {
        boolean equals = super.equals(obj);
        if (!equals) {
            if (!AppModuleDTO.class.equals(obj.getClass())) {
                return false;
            }
            AppModuleDTO compareTo = (AppModuleDTO) obj;
            return StringUtils.equals(firstLevelModuleId, compareTo.getFirstLevelModuleId())
                && StringUtils.equals(secondLevelModuleId, compareTo.getSecondLevelModuleId())
                && StringUtils.equals(firstLevelAppId, compareTo.getFirstLevelAppId())
                && StringUtils.equals(secondLevelAppId, compareTo.getSecondLevelAppId());
        }
        return equals;
    }
    
    @Override
    public int hashCode() {
        return super.hashCode();
    }
    
    /**
     * @return 获取 parentId属性值
     */
    public String getParentId() {
        return parentId;
    }
    
    /**
     * @param parentId 设置 parentId 属性值为参数值 parentId
     */
    public void setParentId(String parentId) {
        this.parentId = parentId;
    }
    
    /**
     * @return 获取 parentName属性值
     */
    public String getParentName() {
        return parentName;
    }
    
    /**
     * @param parentName 设置 parentName 属性值为参数值 parentName
     */
    public void setParentName(String parentName) {
        this.parentName = parentName;
    }
    
    /**
     * @return 获取 type属性值
     */
    public String getType() {
        return type;
    }
    
    /**
     * @param type 设置 type 属性值为参数值 type
     */
    public void setType(String type) {
        this.type = type;
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
     * @return 获取 secondLevelModuleId属性值
     */
    public String getSecondLevelModuleId() {
        return secondLevelModuleId;
    }
    
    /**
     * @param secondLevelModuleId 设置 secondLevelModuleId 属性值为参数值 secondLevelModuleId
     */
    public void setSecondLevelModuleId(String secondLevelModuleId) {
        this.secondLevelModuleId = secondLevelModuleId;
    }
    
    /**
     * @return 获取 secondLevelModuleName属性值
     */
    public String getSecondLevelModuleName() {
        return secondLevelModuleName;
    }
    
    /**
     * @param secondLevelModuleName 设置 secondLevelModuleName 属性值为参数值 secondLevelModuleName
     */
    public void setSecondLevelModuleName(String secondLevelModuleName) {
        this.secondLevelModuleName = secondLevelModuleName;
    }
    
    /**
     * @return 获取 secondLevelModuleCode属性值
     */
    public String getSecondLevelModuleCode() {
        return secondLevelModuleCode;
    }
    
    /**
     * @param secondLevelModuleCode 设置 secondLevelModuleCode 属性值为参数值 secondLevelModuleCode
     */
    public void setSecondLevelModuleCode(String secondLevelModuleCode) {
        this.secondLevelModuleCode = secondLevelModuleCode;
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
     * @return 获取 secondLevelAppId属性值
     */
    public String getSecondLevelAppId() {
        return secondLevelAppId;
    }
    
    /**
     * @param secondLevelAppId 设置 secondLevelAppId 属性值为参数值 secondLevelAppId
     */
    public void setSecondLevelAppId(String secondLevelAppId) {
        this.secondLevelAppId = secondLevelAppId;
    }
    
    /**
     * @return 获取 secondLevelAppName属性值
     */
    public String getSecondLevelAppName() {
        return secondLevelAppName;
    }
    
    /**
     * @param secondLevelAppName 设置 secondLevelAppName 属性值为参数值 secondLevelAppName
     */
    public void setSecondLevelAppName(String secondLevelAppName) {
        this.secondLevelAppName = secondLevelAppName;
    }
    
    /**
     * @return 获取 secondLevelAppCode属性值
     */
    public String getSecondLevelAppCode() {
        return secondLevelAppCode;
    }
    
    /**
     * @param secondLevelAppCode 设置 secondLevelAppCode 属性值为参数值 secondLevelAppCode
     */
    public void setSecondLevelAppCode(String secondLevelAppCode) {
        this.secondLevelAppCode = secondLevelAppCode;
    }
    
    /**
     * @return 获取 funcItemIds属性值
     */
    public String getFuncItemIds() {
        return funcItemIds;
    }
    
    /**
     * @param funcItemIds 设置 funcItemIds 属性值为参数值 funcItemIds
     */
    public void setFuncItemIds(String funcItemIds) {
        this.funcItemIds = funcItemIds;
    }
    
    /**
     * @return 获取 funcItemNames属性值
     */
    public String getFuncItemNames() {
        return funcItemNames;
    }
    
    /**
     * @param funcItemNames 设置 funcItemNames 属性值为参数值 funcItemNames
     */
    public void setFuncItemNames(String funcItemNames) {
        this.funcItemNames = funcItemNames;
    }
    
    /**
     * @return 获取 funcItemCodes属性值
     */
    public String getFuncItemCodes() {
        return funcItemCodes;
    }
    
    /**
     * @param funcItemCodes 设置 funcItemCodes 属性值为参数值 funcItemCodes
     */
    public void setFuncItemCodes(String funcItemCodes) {
        this.funcItemCodes = funcItemCodes;
    }
    
    /**
     * @return 获取 funcSubItemIds属性值
     */
    public String getFuncSubItemIds() {
        return funcSubItemIds;
    }
    
    /**
     * @param funcSubItemIds 设置 funcSubItemIds 属性值为参数值 funcSubItemIds
     */
    public void setFuncSubItemIds(String funcSubItemIds) {
        this.funcSubItemIds = funcSubItemIds;
    }
    
    /**
     * @return 获取 funcSubItemNames属性值
     */
    public String getFuncSubItemNames() {
        return funcSubItemNames;
    }
    
    /**
     * @param funcSubItemNames 设置 funcSubItemNames 属性值为参数值 funcSubItemNames
     */
    public void setFuncSubItemNames(String funcSubItemNames) {
        this.funcSubItemNames = funcSubItemNames;
    }
    
    /**
     * @return 获取 funcSubItemCodes属性值
     */
    public String getFuncSubItemCodes() {
        return funcSubItemCodes;
    }
    
    /**
     * @param funcSubItemCodes 设置 funcSubItemCodes 属性值为参数值 funcSubItemCodes
     */
    public void setFuncSubItemCodes(String funcSubItemCodes) {
        this.funcSubItemCodes = funcSubItemCodes;
    }
    
    /**
     * @return 获取 rootId属性值
     */
    public String getRootId() {
        return rootId;
    }
    
    /**
     * @param rootId 设置 rootId 属性值为参数值 rootId
     */
    public void setRootId(String rootId) {
        this.rootId = rootId;
    }
    
    /**
     * @return 获取 rootName属性值
     */
    public String getRootName() {
        return rootName;
    }
    
    /**
     * @param rootName 设置 rootName 属性值为参数值 rootName
     */
    public void setRootName(String rootName) {
        this.rootName = rootName;
    }
    
    /**
     * @return 获取 rootCode属性值
     */
    public String getRootCode() {
        return rootCode;
    }
    
    /**
     * @param rootCode 设置 rootCode 属性值为参数值 rootCode
     */
    public void setRootCode(String rootCode) {
        this.rootCode = rootCode;
    }
}
