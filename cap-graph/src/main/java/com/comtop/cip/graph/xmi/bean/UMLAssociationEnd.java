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
 * UML关联关系每端的描述
 *
 *
 * @author duqi
 * @since jdk1.6
 * @version 2015年10月8日 duqi
 */
public class UMLAssociationEnd {
    
    /** 可见性 */
    private String visibility = "public";
    
    /** 多重性 */
    private String multiplicity;
    
    /** 是否聚合 组合 */
    private String aggregation = "none";
    
    /** 是否排序 */
    private boolean isOrdered = false;
    
    /** 目标域 */
    private String targetScope = "instance";
    
    /** 能否改变 */
    private String changeable = "none";
    
    /** 未知 */
    private boolean isNavigable = true;
    
    /** 类型 */
    private String type;
    
    /** taggedValuesMap */
    private Map<String, String> taggedValuesMap = new LinkedHashMap<String, String>();
    
    /** 是否为源端 */
    private boolean isSource;
    
    /**
     * 构造函数
     * 
     * @param clazz 类
     * @param multiplicity 多重性
     * @param isSource 是否为源端
     */
    public UMLAssociationEnd(UMLClass clazz, String multiplicity, boolean isSource) {
        this.type = "EAID_" + clazz.getId();
        this.multiplicity = multiplicity;
        this.isSource = isSource;
        initTaggedValue();
    }
    
    /**
     * 初始化taggedValuesMap
     *
     */
    private void initTaggedValue() {
        taggedValuesMap.put("containment", "Unspecified");
        if (isSource) {
            taggedValuesMap.put("sourcestyle", "Union=0;Derived=0;AllowDuplicates=0;Owned=0;Navigable=Unspecified;");
            taggedValuesMap.put("ea_end", "source");
        } else {
            taggedValuesMap.put("deststyle", "Union=0;Derived=0;AllowDuplicates=0;Owned=0;Navigable=Unspecified;");
            taggedValuesMap.put("ea_end", "target");
        }
    }
    
    /**
     * 
     * 转换为XML的DOM结构
     *
     * @param parent 父DOM元素
     */
    public void toDom(Element parent) {
        Element associationEndElement = parent.addElement("UML:AssociationEnd");
        XMIUtil.addElementAttribute(associationEndElement, "multiplicity", this.multiplicity);
        XMIUtil.addElementAttribute(associationEndElement, "aggregation", this.aggregation);
        XMIUtil.addElementAttribute(associationEndElement, "isOrdered", this.isOrdered + "");
        XMIUtil.addElementAttribute(associationEndElement, "targetScope", this.targetScope);
        XMIUtil.addElementAttribute(associationEndElement, "changeable", this.changeable);
        XMIUtil.addElementAttribute(associationEndElement, "isNavigable", this.isNavigable + "");
        XMIUtil.addElementAttribute(associationEndElement, "visibility", this.visibility);
        XMIUtil.addElementAttribute(associationEndElement, "type", this.type);
        XMIUtil.addTaggedValueElement(associationEndElement, taggedValuesMap);
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
     * @return 获取 aggregation属性值
     */
    public String getAggregation() {
        return aggregation;
    }
    
    /**
     * @param aggregation 设置 aggregation 属性值为参数值 aggregation
     */
    public void setAggregation(String aggregation) {
        this.aggregation = aggregation;
    }
    
    /**
     * @return 获取 isOrdered属性值
     */
    public boolean isOrdered() {
        return isOrdered;
    }
    
    /**
     * @param isOrdered 设置 isOrdered 属性值为参数值 isOrdered
     */
    public void setOrdered(boolean isOrdered) {
        this.isOrdered = isOrdered;
    }
    
    /**
     * @return 获取 targetScope属性值
     */
    public String getTargetScope() {
        return targetScope;
    }
    
    /**
     * @param targetScope 设置 targetScope 属性值为参数值 targetScope
     */
    public void setTargetScope(String targetScope) {
        this.targetScope = targetScope;
    }
    
    /**
     * @return 获取 changeable属性值
     */
    public String getChangeable() {
        return changeable;
    }
    
    /**
     * @param changeable 设置 changeable 属性值为参数值 changeable
     */
    public void setChangeable(String changeable) {
        this.changeable = changeable;
    }
    
    /**
     * @return 获取 isNavigable属性值
     */
    public boolean isNavigable() {
        return isNavigable;
    }
    
    /**
     * @param isNavigable 设置 isNavigable 属性值为参数值 isNavigable
     */
    public void setNavigable(boolean isNavigable) {
        this.isNavigable = isNavigable;
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
    
}
