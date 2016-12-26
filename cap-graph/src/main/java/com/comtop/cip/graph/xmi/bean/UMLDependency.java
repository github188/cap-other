/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cip.graph.xmi.bean;

import java.util.LinkedHashMap;
import java.util.Map;

import org.dom4j.Element;

import com.comtop.cip.graph.xmi.utils.XMIUtil;

/**
 * 
 * 依赖关系元素
 *
 * @author duqi
 * @since jdk1.6
 * @version 2015年10月20日 duqi
 */
public class UMLDependency extends BaseXMIBean {
    
    /** 依赖的源端 */
    private String client;
    
    /** 依赖的目标端 */
    private String supplier;
    
    /** 依赖的可见性 */
    private String visibility = "public";
    
    /** taggedValuesMap */
    private Map<String, String> taggedValuesMap = new LinkedHashMap<String, String>();
    
    /** localId */
    private int localId;
    
    /** 源包 */
    private UMLPackage sourcePackage;
    
    /** 目标包 */
    private UMLPackage targetPackage;
    
    /** ID 前缀 */
    private static final String ID_PREFIX = "EAID_";
    
    /**
     * 构造函数
     * 
     * @param sourcePackage 源包
     * @param targetPackage 目标包
     */
    public UMLDependency(UMLPackage sourcePackage, UMLPackage targetPackage) {
        this.id = XMIUtil.getUUID();
        this.sourcePackage = sourcePackage;
        this.targetPackage = targetPackage;
        this.localId = XMIUtil.getLocalID();
        this.client = sourcePackage.getXMIID();
        this.supplier = targetPackage.getXMIID();
        initTaggedValue();
    }
    
    /**
     * 初始化taggedValuesMap
     *
     */
    private void initTaggedValue() {
        taggedValuesMap.put("style", "3");
        taggedValuesMap.put("ea_type", "Dependency");
        taggedValuesMap.put("direction", "Source -> Destination");
        taggedValuesMap.put("linemode", "3");
        taggedValuesMap.put("linecolor", "-1");
        taggedValuesMap.put("linewidth", "0");
        taggedValuesMap.put("seqno", "0");// TODO
        taggedValuesMap.put("headStyle", "0");
        taggedValuesMap.put("lineStyle", "0");
        taggedValuesMap.put("ea_localid", "" + localId);
        taggedValuesMap.put("ea_sourceName", sourcePackage.getName());
        taggedValuesMap.put("ea_targetName", targetPackage.getName());
        taggedValuesMap.put("ea_sourceType", "Package");
        taggedValuesMap.put("ea_targetType", "Package");
        taggedValuesMap.put("ea_sourceID", "" + sourcePackage.getLocalId());
        taggedValuesMap.put("ea_targetID", "" + targetPackage.getLocalId());
        taggedValuesMap.put("src_visibility", "Public");
        taggedValuesMap.put("src_aggregation", "0");
        taggedValuesMap.put("src_isOrdered", "false");
        taggedValuesMap.put("src_targetScope", "instance");
        taggedValuesMap.put("src_changeable", "none");
        taggedValuesMap.put("src_isNavigable", "false");
        taggedValuesMap.put("src_containment", "Unspecified");
        taggedValuesMap.put("src_style", "Union=0;Derived=0;AllowDuplicates=0;Owned=0;Navigable=Non-Navigable;");
        taggedValuesMap.put("dst_visibility", "Public");
        taggedValuesMap.put("dst_aggregation", "0");
        taggedValuesMap.put("dst_isOrdered", "false");
        taggedValuesMap.put("dst_targetScope", "instance");
        taggedValuesMap.put("dst_changeable", "none");
        taggedValuesMap.put("dst_isNavigable", "true");
        taggedValuesMap.put("dst_containment", "Unspecified");
        taggedValuesMap.put("dst_style", "Union=0;Derived=0;AllowDuplicates=0;Owned=0;Navigable=Navigable;");
        taggedValuesMap.put("virtualInheritance", "0");
    }
    
    /**
     * 
     * 转换为XML的DOM结构
     *
     * @param parent 父DOM元素
     */
    public void toDom(Element parent) {
        Element dependencyElement = parent.addElement("UML:Dependency");
        XMIUtil.addElementAttribute(dependencyElement, "xmi.id", this.getXMIID());
        XMIUtil.addElementAttribute(dependencyElement, "client", this.client);
        XMIUtil.addElementAttribute(dependencyElement, "supplier", this.supplier);
        XMIUtil.addElementAttribute(dependencyElement, "visibility", this.visibility);
        XMIUtil.addTaggedValueElement(dependencyElement, taggedValuesMap);
    }
    
    /**
     * 
     * 获取XMI ID
     * 
     * @return xmi id
     *
     */
    public String getXMIID() {
        if (this.id == null) {
            return null;
        }
        return ID_PREFIX + this.id;
    }
    
    /**
     * @return 获取 client属性值
     */
    public String getClient() {
        return client;
    }
    
    /**
     * @param client 设置 client 属性值为参数值 client
     */
    public void setClient(String client) {
        this.client = client;
    }
    
    /**
     * @return 获取 supplier属性值
     */
    public String getSupplier() {
        return supplier;
    }
    
    /**
     * @param supplier 设置 supplier 属性值为参数值 supplier
     */
    public void setSupplier(String supplier) {
        this.supplier = supplier;
    }
    
    /**
     * @return 获取 visibility属性值
     */
    public String getVisibility() {
        return visibility;
    }
    
    /**
     * @param visibility 设置 visibility 属性值为参数值 visibility
     */
    public void setVisibility(String visibility) {
        this.visibility = visibility;
    }
    
    /**
     * @return 获取 taggedValuesMap属性值
     */
    public Map<String, String> getTaggedValuesMap() {
        return taggedValuesMap;
    }
    
    /**
     * @param taggedValuesMap 设置 taggedValuesMap 属性值为参数值 taggedValuesMap
     */
    public void setTaggedValuesMap(Map<String, String> taggedValuesMap) {
        this.taggedValuesMap = taggedValuesMap;
    }
    
    /**
     * @return 获取 localId属性值
     */
    public int getLocalId() {
        return localId;
    }
    
    /**
     * @param localId 设置 localId 属性值为参数值 localId
     */
    public void setLocalId(int localId) {
        this.localId = localId;
    }
    
    /**
     * @return 获取 sourcePackage属性值
     */
    public UMLPackage getSourcePackage() {
        return sourcePackage;
    }
    
    /**
     * @param sourcePackage 设置 sourcePackage 属性值为参数值 sourcePackage
     */
    public void setSourcePackage(UMLPackage sourcePackage) {
        this.sourcePackage = sourcePackage;
    }
    
    /**
     * @return 获取 targetPackage属性值
     */
    public UMLPackage getTargetPackage() {
        return targetPackage;
    }
    
    /**
     * @param targetPackage 设置 targetPackage 属性值为参数值 targetPackage
     */
    public void setTargetPackage(UMLPackage targetPackage) {
        this.targetPackage = targetPackage;
    }
    
}
