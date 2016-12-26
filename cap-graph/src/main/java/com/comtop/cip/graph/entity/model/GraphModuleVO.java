/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cip.graph.entity.model;

import java.util.List;

import javax.persistence.Column;

import com.comtop.cip.graph.uml.model.GraphEntityExtendVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 模块VO
 * 
 * @author 陈志伟
 * @since 1.0
 * @version 2015-7-22 陈志伟
 */
@DataTransferObject
public class GraphModuleVO {
    
    /** 模块id */
    @Column(name = "MODULE_ID")
    private String moduleId;
    
    /** 模块编码 */
    @Column(name = "MODULE_CODE")
    private String moduleCode;
    
    /** 模块名称 */
    @Column(name = "MODULE_NAME")
    private String moduleName;
    
    /** 模块类型 */
    @Column(name = "MODULE_TYPE")
    private int moduleType;// 模块关系图功能需要
    
    /** 模块ID全路径 */
    @Column(name = "MODULE_ID_FULL_PATH")
    private String moduleIdFullPath;// 模块关系图功能需要
    
    /** 模块名称全路径 */
    @Column(name = "MODULE_NAME_FULL_PATH")
    private String moduleNameFullPath;// 模块关系图功能需要
    
    /** 包全路径 */
    @Column(name = "FULL_PATH")
    private String packageFullPath;
    
    /** 模块id全路径的长度 */
    @Column(name = "FULL_ID_PATH_LENGTH")
    private int fullPathIdLength;// 功能结构图需要
    
    /** 模块id父节点ID */
    @Column(name = "PARENT_MODULE_ID")
    private String parentModuleId;// 功能结构图需要
    
    /** 实体集合 */
    private List<GraphEntityVO> graphEntityVOs;
    
    /** 实体关联关系 */
    private List<GraphEntityRelaVO> graphEntityRelaVOs;
    
    /** 实体继承关系 */
    private List<GraphEntityExtendVO> graphEntityExtendVOs;
    
    /** 记录原始实体VO集合 */
    private List<com.comtop.cap.bm.metadata.entity.model.EntityVO> entityVOList;
    
    /** 记录原始实体关系VO集合 */
    private List<com.comtop.cap.bm.metadata.entity.model.EntityRelationshipVO> entityRelationshipVOList;
    
    /** 当前模块的子模块之间的依赖关系 */
    private List<GraphModuleRelaVO> innerModuleRelaVOList; // 模块关系图功能、 导出到EA功能需要
    
    /** 被指定的内部模块依赖的外部模块的依赖关系 */
    private List<GraphModuleRelaVO> dependOutModuleRelaVOList;// 模块关系图功能需要
    
    /** 外部模块依赖指定的内部模块的依赖关系 */
    private List<GraphModuleRelaVO> dependedOutModuleRelaVOList;// 模块关系图功能需要
    
    /** 内部模块列表 */
    private List<GraphModuleVO> innerModuleVOList;// 模块关系图功能、 导出到EA功能需要
    
    /** 依赖外部模块列表 */
    private List<GraphModuleVO> dependOutModuleVOList;// 模块关系图功能需要
    
    /** 被依赖外部模块列表 */
    private List<GraphModuleVO> dependedOutModuleVOList;// 模块关系图功能需要
    
    /**
     * @return the moduleId
     */
    public String getModuleId() {
        return moduleId;
    }
    
    /**
     * @param moduleId
     *            the moduleId to set
     */
    public void setModuleId(String moduleId) {
        this.moduleId = moduleId;
    }
    
    /**
     * @return the moduleCode
     */
    public String getModuleCode() {
        return moduleCode;
    }
    
    /**
     * @param moduleCode
     *            the moduleCode to set
     */
    public void setModuleCode(String moduleCode) {
        this.moduleCode = moduleCode;
    }
    
    /**
     * @return the moduleName
     */
    public String getModuleName() {
        return moduleName;
    }
    
    /**
     * @param moduleName
     *            the moduleName to set
     */
    public void setModuleName(String moduleName) {
        this.moduleName = moduleName;
    }
    
    /**
     * @return the graphEntityVOs
     */
    public List<GraphEntityVO> getGraphEntityVOs() {
        return graphEntityVOs;
    }
    
    /**
     * @param graphEntityVOs
     *            the graphEntityVOs to set
     */
    public void setGraphEntityVOs(List<GraphEntityVO> graphEntityVOs) {
        this.graphEntityVOs = graphEntityVOs;
    }
    
    /**
     * @return the graphEntityRelaVOs
     */
    public List<GraphEntityRelaVO> getGraphEntityRelaVOs() {
        return graphEntityRelaVOs;
    }
    
    /**
     * @param graphEntityRelaVOs
     *            the graphEntityRelaVOs to set
     */
    public void setGraphEntityRelaVOs(List<GraphEntityRelaVO> graphEntityRelaVOs) {
        this.graphEntityRelaVOs = graphEntityRelaVOs;
    }
    
    /**
     * @return 获取 graphEntityExtendVOs属性值
     */
    public List<GraphEntityExtendVO> getGraphEntityExtendVOs() {
        return graphEntityExtendVOs;
    }
    
    /**
     * @param graphEntityExtendVOs 设置 graphEntityExtendVOs 属性值为参数值 graphEntityExtendVOs
     */
    public void setGraphEntityExtendVOs(List<GraphEntityExtendVO> graphEntityExtendVOs) {
        this.graphEntityExtendVOs = graphEntityExtendVOs;
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
     * @return 获取 innerModuleRelaVOList属性值
     */
    public List<GraphModuleRelaVO> getInnerModuleRelaVOList() {
        return innerModuleRelaVOList;
    }
    
    /**
     * @param innerModuleRelaVOList 设置 innerModuleRelaVOList 属性值为参数值 innerModuleRelaVOList
     */
    public void setInnerModuleRelaVOList(List<GraphModuleRelaVO> innerModuleRelaVOList) {
        this.innerModuleRelaVOList = innerModuleRelaVOList;
    }
    
    /**
     * @return 获取 dependOutModuleRelaVOList属性值
     */
    public List<GraphModuleRelaVO> getDependOutModuleRelaVOList() {
        return dependOutModuleRelaVOList;
    }
    
    /**
     * @param dependOutModuleRelaVOList 设置 dependOutModuleRelaVOList 属性值为参数值 dependOutModuleRelaVOList
     */
    public void setDependOutModuleRelaVOList(List<GraphModuleRelaVO> dependOutModuleRelaVOList) {
        this.dependOutModuleRelaVOList = dependOutModuleRelaVOList;
    }
    
    /**
     * @return 获取 dependedOutModuleRelaVOList属性值
     */
    public List<GraphModuleRelaVO> getDependedOutModuleRelaVOList() {
        return dependedOutModuleRelaVOList;
    }
    
    /**
     * @param dependedOutModuleRelaVOList 设置 dependedOutModuleRelaVOList 属性值为参数值 dependedOutModuleRelaVOList
     */
    public void setDependedOutModuleRelaVOList(List<GraphModuleRelaVO> dependedOutModuleRelaVOList) {
        this.dependedOutModuleRelaVOList = dependedOutModuleRelaVOList;
    }
    
    /**
     * @return 获取 innerModuleVOList属性值
     */
    public List<GraphModuleVO> getInnerModuleVOList() {
        return innerModuleVOList;
    }
    
    /**
     * @param innerModuleVOList 设置 innerModuleVOList 属性值为参数值 innerModuleVOList
     */
    public void setInnerModuleVOList(List<GraphModuleVO> innerModuleVOList) {
        this.innerModuleVOList = innerModuleVOList;
    }
    
    /**
     * @return 获取 dependOutModuleVOList属性值
     */
    public List<GraphModuleVO> getDependOutModuleVOList() {
        return dependOutModuleVOList;
    }
    
    /**
     * @param dependOutModuleVOList 设置 dependOutModuleVOList 属性值为参数值 dependOutModuleVOList
     */
    public void setDependOutModuleVOList(List<GraphModuleVO> dependOutModuleVOList) {
        this.dependOutModuleVOList = dependOutModuleVOList;
    }
    
    /**
     * @return 获取 dependedOutModuleVOList属性值
     */
    public List<GraphModuleVO> getDependedOutModuleVOList() {
        return dependedOutModuleVOList;
    }
    
    /**
     * @param dependedOutModuleVOList 设置 dependedOutModuleVOList 属性值为参数值 dependedOutModuleVOList
     */
    public void setDependedOutModuleVOList(List<GraphModuleVO> dependedOutModuleVOList) {
        this.dependedOutModuleVOList = dependedOutModuleVOList;
    }
    
    /**
     * @return 获取 moduleNameFullPath属性值
     */
    public String getModuleNameFullPath() {
        return moduleNameFullPath;
    }
    
    /**
     * @param moduleNameFullPath 设置 moduleNameFullPath 属性值为参数值 moduleNameFullPath
     */
    public void setModuleNameFullPath(String moduleNameFullPath) {
        this.moduleNameFullPath = moduleNameFullPath;
    }
    
    /**
     * @return 获取 moduleIdFullPath属性值
     */
    public String getModuleIdFullPath() {
        return moduleIdFullPath;
    }
    
    /**
     * @param moduleIdFullPath 设置 moduleIdFullPath 属性值为参数值 moduleIdFullPath
     */
    public void setModuleIdFullPath(String moduleIdFullPath) {
        this.moduleIdFullPath = moduleIdFullPath;
    }
    
    /**
     * @return 获取 packageFullPath属性值
     */
    public String getPackageFullPath() {
        return packageFullPath;
    }
    
    /**
     * @param packageFullPath 设置 packageFullPath 属性值为参数值 packageFullPath
     */
    public void setPackageFullPath(String packageFullPath) {
        this.packageFullPath = packageFullPath;
    }
    
    /**
     * @return 获取 entityVOList属性值
     */
    public List<com.comtop.cap.bm.metadata.entity.model.EntityVO> getEntityVOList() {
        return entityVOList;
    }
    
    /**
     * @param entityVOList 设置 entityVOList 属性值为参数值 entityVOList
     */
    public void setEntityVOList(List<com.comtop.cap.bm.metadata.entity.model.EntityVO> entityVOList) {
        this.entityVOList = entityVOList;
    }
    
    /**
     * @return 获取 entityRelationshipVOList属性值
     */
    public List<com.comtop.cap.bm.metadata.entity.model.EntityRelationshipVO> getEntityRelationshipVOList() {
        return entityRelationshipVOList;
    }
    
    /**
     * @param entityRelationshipVOList 设置 entityRelationshipVOList 属性值为参数值 entityRelationshipVOList
     */
    public void setEntityRelationshipVOList(
        List<com.comtop.cap.bm.metadata.entity.model.EntityRelationshipVO> entityRelationshipVOList) {
        this.entityRelationshipVOList = entityRelationshipVOList;
    }

	/**
	 * @return the fullPathIdLength
	 */
	public int getFullPathIdLength() {
		return fullPathIdLength;
	}

	/**
	 * @param fullPathIdLength the fullPathIdLength to set
	 */
	public void setFullPathIdLength(int fullPathIdLength) {
		this.fullPathIdLength = fullPathIdLength;
	}

	/**
	 * @return the parentModuleId
	 */
	public String getParentModuleId() {
		return parentModuleId;
	}

	/**
	 * @param parentModuleId the parentModuleId to set
	 */
	public void setParentModuleId(String parentModuleId) {
		this.parentModuleId = parentModuleId;
	}
    
}
