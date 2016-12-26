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
 * 类方法参数元素： 包括方法返回值、参数
 *
 * @author duqi
 * @since jdk1.6
 * @version 2015年10月20日 duqi
 */
public class UMLOperationParameter extends BaseXMIBean {
    
    /** 方法参数种类 有返回值 和参数选项 */
    private String kind;
    
    /** 可见性 */
    private String visibility;
    
    /** 方法参数的数据类型 */
    private UMLDatatype datatype;
    
    /** taggedValuesMap */
    private Map<String, String> taggedValuesMap = new LinkedHashMap<String, String>();
    
    /**
     * 构造函数
     * 
     * @param kind 方法参数种类 有返回值 和参数选项
     * @param datatype 数据类型
     * @param name 参数名称
     */
    public UMLOperationParameter(String kind, UMLDatatype datatype, String name) {
        this.kind = kind;
        this.name = name;
        this.datatype = datatype;
        initTaggedValue();
    }
    
    /**
     * 构造函数
     * 
     * @param kind 方法参数种类 有返回值 和参数选项
     * @param datatype 数据类型
     */
    public UMLOperationParameter(String kind, UMLDatatype datatype) {
        this.kind = kind;
        this.datatype = datatype;
        initTaggedValue();
    }
    
    /**
     * 初始化taggedValuesMap
     *
     */
    private void initTaggedValue() {
        taggedValuesMap.put("pos", "0");
        taggedValuesMap.put("type", datatype.getName());
        taggedValuesMap.put("const", "0");
        taggedValuesMap.put("ea_guid", XMIUtil.getGUID());
    }
    
    /**
     * 
     * 转换为XML的DOM结构
     *
     * @param parent 父DOM元素
     */
    public void toDom(Element parent) {
        Element operationParameterElement = parent.addElement("UML:Parameter");
        XMIUtil.addElementAttribute(operationParameterElement, "name", this.name);
        XMIUtil.addElementAttribute(operationParameterElement, "kind", this.kind);
        XMIUtil.addElementAttribute(operationParameterElement, "visibility", this.visibility);
        XMIUtil.addTaggedValueElement(operationParameterElement, taggedValuesMap);
        
        Element classifierElement = operationParameterElement.addElement("UML:Parameter.type").addElement(
            "UML:Classifier");
        classifierElement.addAttribute("xmi.idref", datatype.getId());
        
        operationParameterElement.addElement("UML:Parameter.defaultValue").addElement("UML:Expression");
    }
    
    /**
     * @return 获取 kind属性值
     */
    public String getKind() {
        return kind;
    }
    
    /**
     * @param kind 设置 kind 属性值为参数值 kind
     */
    public void setKind(String kind) {
        this.kind = kind;
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
    
}
