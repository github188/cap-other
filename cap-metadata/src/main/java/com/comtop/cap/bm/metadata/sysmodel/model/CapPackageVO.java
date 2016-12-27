/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.sysmodel.model;

import java.util.List;

import com.comtop.cap.bm.metadata.base.model.BaseModel;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * CAP模块（包括子系统、目录、应用）与包对象集成视图VO
 * 
 * @author 罗珍明
 * @since 1.0
 * @version 2015-12-30 罗珍明
 */
@DataTransferObject
public class CapPackageVO extends BaseModel {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 模块ID */
    private String moduleId;
    
    /** 模块单编码 */
    private String moduleCode;
    
    /** 模块名称 */
    private String moduleName;
    
    /** 节点类型：SYSTEM_MODULE_TYPE为系统，CATALOG_MODULE_TYPE为模块 ，APPLICATION_MODULE_TYPE为应用 */
    private int moduleType;
    
    /** 描述 */
    private String moduleDescription;
    
    /** 父模块ID */
    private String parentModuleId;
    
    /** 父模块ID */
    private List<FunctionItemVO> lstFunctionItem;
    
    /** 包ID */
    private String id;
    
    /** 包简称 */
    private String shortName;
    
    /** 包全路径 */
    private String fullPath;
    
    /** Java代码路径 */
    private String javaCodePath;
    
    /** 页面工程路径 */
    private String pagePath;
    
    /** 包类型 ,0表示普通包，1表示模块 */
    private int packageType;
    
    /** 父ID */
    private String parentId;
    
    /** 排序号 */
    private int sortId;
    
    /**
     * @return 获取 javaCodePath属性值
     */
    public String getJavaCodePath() {
        return javaCodePath;
    }
    
    /**
     * @param javaCodePath 设置 javaCodePath 属性值为参数值 javaCodePath
     */
    public void setJavaCodePath(String javaCodePath) {
        this.javaCodePath = javaCodePath;
    }
    
    /**
     * @return 获取 pagePath属性值
     */
    public String getPagePath() {
        return pagePath;
    }
    
    /**
     * @param pagePath 设置 pagePath 属性值为参数值 pagePath
     */
    public void setPagePath(String pagePath) {
        this.pagePath = pagePath;
    }
    
    /**
     * @return 获取 sortId属性值
     */
    public int getSortId() {
        return sortId;
    }
    
    /**
     * @param sortId 设置 sortId 属性值为参数值 sortId
     */
    public void setSortId(int sortId) {
        this.sortId = sortId;
    }
    
    /**
     * @return 获取 moduleId属性值
     */
    public String getModuleId() {
        return moduleId;
    }
    
    /**
     * @param moduleId 设置 moduleId 属性值为参数值 moduleId
     */
    public void setModuleId(String moduleId) {
        this.moduleId = moduleId;
    }
    
    /**
     * @return 获取 moduleName属性值
     */
    public String getModuleName() {
        return moduleName;
    }
    
    /**
     * @param moduleName 设置 moduleName 属性值为参数值 moduleName
     */
    public void setModuleName(String moduleName) {
        this.moduleName = moduleName;
    }
    
    /**
     * @return 获取 moduleType属性值
     */
    public int getModuleType() {
        return moduleType;
    }
    
    /**
     * @param moduleType 设置 moduleType 属性值为参数值 moduleType
     */
    public void setModuleType(int moduleType) {
        this.moduleType = moduleType;
    }
    
    /**
     * @return 获取 parentModuleId属性值
     */
    public String getParentModuleId() {
        return parentModuleId;
    }
    
    /**
     * @param parentModuleId 设置 parentModuleId 属性值为参数值 parentModuleId
     */
    public void setParentModuleId(String parentModuleId) {
        this.parentModuleId = parentModuleId;
    }
    
    /**
     * @return 获取 lstFunctionItem属性值
     */
    public List<FunctionItemVO> getLstFunctionItem() {
        return lstFunctionItem;
    }
    
    /**
     * @param lstFunctionItem 设置 lstFunctionItem 属性值为参数值 lstFunctionItem
     */
    public void setLstFunctionItem(List<FunctionItemVO> lstFunctionItem) {
        this.lstFunctionItem = lstFunctionItem;
    }
    
    /**
     * @return 获取 moduleDescription属性值
     */
    public String getModuleDescription() {
        return moduleDescription;
    }
    
    /**
     * @param moduleDescription 设置 moduleDescription 属性值为参数值 moduleDescription
     */
    public void setModuleDescription(String moduleDescription) {
        this.moduleDescription = moduleDescription;
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
     * @return 获取 id属性值
     * @see com.comtop.cap.runtime.base.model.BaseVO#getId()
     */
    public String getId() {
        return this.id;
    }
    
    /**
     * @param id 设置 id 属性值为参数值 id
     * 
     * @see com.comtop.cap.runtime.base.model.BaseVO#setId(java.lang.String)
     */
    public void setId(String id) {
        this.id = id;
    }
    
    /**
     * @return 获取 shortName属性值
     */
    public String getShortName() {
        return shortName;
    }
    
    /**
     * @param shortName 设置 shortName 属性值为参数值 shortName
     */
    public void setShortName(String shortName) {
        this.shortName = shortName;
    }
    
    /**
     * @return 获取 fullPath属性值
     */
    public String getFullPath() {
        return fullPath;
    }
    
    /**
     * @param fullPath 设置 fullPath 属性值为参数值 fullPath
     */
    public void setFullPath(String fullPath) {
        this.fullPath = fullPath;
    }
    
    /**
     * @return 获取 packageType属性值
     */
    public int getPackageType() {
        return packageType;
    }
    
    /**
     * @param packageType 设置 packageType 属性值为参数值 packageType
     */
    public void setPackageType(int packageType) {
        this.packageType = packageType;
    }
    
    /**
     * @return 获取 moduleCode属性值
     */
    public String getModuleCode() {
        return moduleCode;
    }
    
    /**
     * @param moduleCode 设置 moduleCode 属性值为参数值 moduleCode
     */
    public void setModuleCode(String moduleCode) {
        this.moduleCode = moduleCode;
    }
    
}
