/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cip.graph.editor.model;

import javax.xml.bind.annotation.XmlRootElement;

import com.comtop.cap.bm.metadata.base.model.BaseModel;

import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 部署图
 * 
 * 
 * @author 缪柏年
 * @since 1.0
 * @version 2015-9-15 缪柏年
 */
@XmlRootElement(name = "editor")
@DataTransferObject
public class DeployDiagramVO extends BaseModel{
    
    /** 标识 */
    private static final long serialVersionUID = 1L;
    
    /** 模块id  */
    private String moduleId;
    
    /** 部署图类型(physic物理部署,logic逻辑部署)  */
    private String diagramType;
    
	/**
	 * @return 获取 diagramType属性值
	 */
	public String getDiagramType() {
		return diagramType;
	}

	/**
	 * @param diagramType 设置 diagramType 属性值为参数值 diagramType
	 */
	public void setDiagramType(String diagramType) {
		this.diagramType = diagramType;
	}

	/**
     * 构造函数
     */
    public DeployDiagramVO() {
        this.setModelType("graph");
    }
    
	/** 部署图xml内容  */
    private String content;

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
	 * @return 获取 content属性值
	 */
	public String getContent() {
		return content;
	}

	/**
	 * @param content 设置 content 属性值为参数值 content
	 */
	public void setContent(String content) {
		this.content = content;
	}
}
