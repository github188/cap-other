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
 * UML 类属性
 *
 *
 * @author duqi
 * @since jdk1.6
 * @version 2015年10月8日 duqi
 */
public class UMLAttribute extends BaseXMIBean {
    
    /** 能否改变 */
    private String changeable = "none";
    
    /** 可见性 */
    private String visibility = "private";
    
    /** 拥有者域 */
    private String ownerScope = "instance";
    
    /** 目标域 */
    private String targetScope = "instance";
    
    /** 数据类型 */
    private UMLDatatype datatype;
    
    /** taggedValuesMap */
    private Map<String, String> taggedValuesMap = new LinkedHashMap<String, String>();
    
    /** 属性的position */
    private int position;
    
    /**
     * 构造函数
     * 
     * @param datatype 数据类型
     * @param name 名称
     * @param visibility 可视性
     * @param position 位置
     */
    public UMLAttribute(UMLDatatype datatype, String name, String visibility, int position) {
        this.datatype = datatype;
        this.name = name;
        this.position = position;
        this.visibility = visibility;
        initTaggedValue();
    }
    
    /**
     * 初始化taggedValuesMap
     *
     */
    private void initTaggedValue() {
        taggedValuesMap.put("type", datatype.getName());
        taggedValuesMap.put("derived", "0");
        taggedValuesMap.put("containment", "Not Specified");
        taggedValuesMap.put("ordered", "0");
        taggedValuesMap.put("position", "" + position);
        taggedValuesMap.put("returnarray", "0");
        taggedValuesMap.put("pure", "0");
        taggedValuesMap.put("ea_guid", XMIUtil.getGUID());
        taggedValuesMap.put("ea_localid", "" + XMIUtil.getLocalID());
        taggedValuesMap.put("styleex", "IsLiteral=0;volatile=0;");
    }
    
    /**
     * 
     * 转换为XML的DOM结构
     *
     * @param parent 父DOM元素
     */
    public void toDom(Element parent) {
        Element attributeElement = parent.addElement("UML:Attribute");
        XMIUtil.addElementAttribute(attributeElement, "name", this.name);
        XMIUtil.addElementAttribute(attributeElement, "changeable", this.changeable);
        XMIUtil.addElementAttribute(attributeElement, "visibility", this.visibility);
        XMIUtil.addElementAttribute(attributeElement, "ownerScope", this.ownerScope);
        XMIUtil.addElementAttribute(attributeElement, "targetScope", this.targetScope);
        XMIUtil.addTaggedValueElement(attributeElement, taggedValuesMap);
        
        attributeElement.addElement("UML:Attribute.initialValue").addElement("UML:Expression");
        Element classifierElement = attributeElement.addElement("UML:StructuralFeature.type").addElement(
            "UML:Classifier");
        classifierElement.addAttribute("xmi.idref", datatype.getId());
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
     * @return 获取 ownerScope属性值
     */
    public String getOwnerScope() {
        return ownerScope;
    }
    
    /**
     * @param ownerScope 设置 ownerScope 属性值为参数值 ownerScope
     */
    public void setOwnerScope(String ownerScope) {
        this.ownerScope = ownerScope;
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
     * @return 获取 datatype属性值
     */
    public UMLDatatype getDatatype() {
        return datatype;
    }
    
    /**
     * @param datatype 设置 datatype 属性值为参数值 datatype
     */
    public void setDatatype(UMLDatatype datatype) {
        this.datatype = datatype;
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
     * @return 获取 position属性值
     */
    public int getPosition() {
        return position;
    }
    
    /**
     * @param position 设置 position 属性值为参数值 position
     */
    public void setPosition(int position) {
        this.position = position;
    }
    
}
