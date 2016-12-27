/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.desinger.model;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.xml.bind.annotation.XmlRootElement;

import com.comtop.cap.bm.metadata.base.consistency.annotation.ConsistencyDependOnField;
import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import com.comtop.cap.bm.metadata.common.dwr.CapMap;
import com.comtop.cap.bm.metadata.common.storage.annotation.IgnoreField;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 布局模型
 * 
 * @author 诸焕辉
 * @version jdk1.6
 * @version 2015-4-28 诸焕辉
 */
@XmlRootElement(name = "layout")
@DataTransferObject
public class LayoutVO extends BaseMetadata {
    
    /** serialVersionUID */
    private static final long serialVersionUID = 860496463818349858L;
    
    /** 控件ID */
    private String id;
    
    /** 节点类型 */
    private String type;
    
    /** 控件类型 */
    private String uiType;
    
    /**
     * 父控件Id
     */
    private String parentId;
    
    /** 子节点集合 */
    @ConsistencyDependOnField
    private List<LayoutVO> children = new ArrayList<LayoutVO>();
    
    /** 控件属性Map */
    @ConsistencyDependOnField
    private CapMap options = new CapMap();
    
    /** 对象类型的属性 */
    @IgnoreField
    private CapMap objectOptions = new CapMap();
    
    /** 控件属性是JSON属性名称 */
    @IgnoreField
    private Map<String, Map<String, Boolean>> jsonKeys;
    
    /** 控件属性类型 */
    @IgnoreField
    private Map<String, String> attrTypes;
    
    /** 控件定义模型的唯一ID */
    private String componentModelId;
    
    /** 控件需求来源说明  */
    private String requireExplain;
    
    /**
     * @return 获取 id属性值
     */
    public String getId() {
        return id;
    }
    
    /**
     * @param id 设置 id 属性值为参数值 id
     */
    public void setId(String id) {
        this.id = id;
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
     * @return 获取 uiType属性值
     */
    public String getUiType() {
        return uiType;
    }
    
    /**
     * @param uiType 设置 uiType 属性值为参数值 uiType
     */
    public void setUiType(String uiType) {
        this.uiType = uiType;
    }
    
    /**
     * @return 获取 children属性值
     */
    public List<LayoutVO> getChildren() {
        return children;
    }
    
    /**
     * @param children 设置 children 属性值为参数值 children
     */
    public void setChildren(List<LayoutVO> children) {
        this.children = children;
    }
    
    /**
     * @return 获取 options属性值
     */
    public CapMap getOptions() {
        return options;
    }
    
    /**
     * @param options 设置 options 属性值为参数值 options
     */
    public void setOptions(CapMap options) {
        this.options = options;
    }
    
    /**
     * @return the objectOptions
     */
    public CapMap getObjectOptions() {
        return objectOptions;
    }
    
    /**
     * @param objectOptions the objectOptions to set
     */
    public void setObjectOptions(CapMap objectOptions) {
        this.objectOptions = objectOptions;
    }
    
    /**
     * @return 获取 jsonKeys属性值
     */
    public Map<String, Map<String, Boolean>> getJsonKeys() {
        return jsonKeys;
    }
    
    /**
     * @param jsonKeys 设置 jsonKeys 属性值为参数值 jsonKeys
     */
    public void setJsonKeys(Map<String, Map<String, Boolean>> jsonKeys) {
        this.jsonKeys = jsonKeys;
    }
    
    /**
     * @return the parentId
     */
    public String getParentId() {
        return parentId;
    }
    
    /**
     * @param parentId the parentId to set
     */
    public void setParentId(String parentId) {
        this.parentId = parentId;
    }
    
    /**
     * @return 获取 componentModelId属性值
     */
    public String getComponentModelId() {
        return componentModelId;
    }
    
    /**
     * @param componentModelId 设置 componentModelId 属性值为参数值 componentModelId
     */
    public void setComponentModelId(String componentModelId) {
        this.componentModelId = componentModelId;
    }

    /**
     * @return 获取 attrTypes属性值
     */
    public Map<String, String> getAttrTypes() {
        return attrTypes;
    }

    /**
     * @param attrTypes 设置 attrTypes 属性值为参数值 attrTypes
     */
    public void setAttrTypes(Map<String, String> attrTypes) {
        this.attrTypes = attrTypes;
    }

    /**
     * @return 获取 requireExplain属性值
     */
	public String getRequireExplain() {
		return requireExplain;
	}

	/**
     * @param requireExplain 设置 requireExplain 属性值为参数值 requireExplain
     */
	public void setRequireExplain(String requireExplain) {
		this.requireExplain = requireExplain;
	}
}
