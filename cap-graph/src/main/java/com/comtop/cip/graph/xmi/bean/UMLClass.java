/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cip.graph.xmi.bean;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.dom4j.Element;

import com.comtop.cip.graph.xmi.utils.DateUtil;
import com.comtop.cip.graph.xmi.utils.XMIUtil;

/**
 * 
 * 类元素
 *
 * @author duqi
 * @since jdk1.6
 * @version 2015年10月20日 duqi
 */
public class UMLClass extends BaseXMIBean {
    
    /** XMI ID 前缀 */
    private static final String ID_PREFIX = "EAID_";
    
    /** 命名空间 */
    private String namespace;
    
    /** 可见性 */
    private String visibility;
    
    /** 是否为根 */
    private boolean isRoot;
    
    /** 是否为叶子 */
    private boolean isLeaf;
    
    /** 是否是抽象的 */
    private boolean isAbstract;
    
    /** 是否是激活的 */
    private boolean isActive;
    
    /** taggedValuesMap */
    private Map<String, String> taggedValuesMap = new LinkedHashMap<String, String>();
    
    /** 类属性集合 */
    private List<UMLAttribute> attributes = new ArrayList<UMLAttribute>();
    
    /** 类方法集合 */
    private List<UMLOperation> operations = new ArrayList<UMLOperation>();
    
    /** 父包 */
    private UMLPackage parentPackage;
    
    /** localId */
    private int localId;
    
    /** 类型 */
    private String type = "Class";
    
    /** 属性位置 */
    private int attrPosition = 0;
    
    /** 方法位置 */
    private int operPosition = 0;
    
    /**
     * 构造函数
     * 
     * @param isRoot 是否为根
     */
    public UMLClass(boolean isRoot) {
        this.isRoot = isRoot;
        if (isRoot) {
            this.id = XMIUtil.getUUID();
            this.name = "EARootClass";
            this.visibility = "public";
        }
    }
    
    /**
     * 构造函数
     * 
     * @param pckage 包
     * @param className 类名
     * 
     */
    public UMLClass(UMLPackage pckage, String className) {
        this.id = XMIUtil.getUUID();
        this.parentPackage = pckage;
        this.name = className;
        this.namespace = "EAPK_" + pckage.getId();
        this.visibility = "public";
        this.localId = XMIUtil.getLocalID();
        initTaggedValues();
    }
    
    /**
     * 初始化taggedValuesMap
     *
     */
    public void initTaggedValues() {
        String currentTime = DateUtil.getCurrentTime();
        taggedValuesMap.put("isSpecification", "false");
        taggedValuesMap.put("ea_stype", "Class");
        taggedValuesMap.put("ea_ntype", "0");
        taggedValuesMap.put("version", "1.0");
        taggedValuesMap.put("package", "EAPK_" + parentPackage.getId());
        taggedValuesMap.put("date_created", currentTime);
        taggedValuesMap.put("date_modified", currentTime);
        taggedValuesMap.put("gentype", "java");
        taggedValuesMap.put("tagged", "0");
        taggedValuesMap.put("package_name", parentPackage.getName());
        taggedValuesMap.put("phase", "1.0");
        taggedValuesMap.put("author", "system");
        taggedValuesMap.put("complexity", "1");
        taggedValuesMap.put("status", "Proposed");
        taggedValuesMap.put("tpos", "0");
        taggedValuesMap.put("ea_localid", "" + localId);
        taggedValuesMap.put("ea_eleType", "element");
        taggedValuesMap.put("style",
            "BackColor=-1;BorderColor=-1;BorderWidth=-1;FontColor=-1;VSwimLanes=1;HSwimLanes=1;BorderStyle=0;");
    }
    
    /**
     * 获取属性位置并+1
     *
     * @return attrPosition
     */
    public int getAndIncrAttrPosition() {
        return attrPosition++;
    }
    
    /**
     * 获取方法位置并+1
     *
     * @return operPosition
     */
    public int getAndIncrOperPosition() {
        return operPosition++;
    }
    
    /**
     * 添加属性
     * 
     * @param attribute 属性
     *
     */
    public void addAttribute(UMLAttribute attribute) {
        attributes.add(attribute);
    }
    
    /**
     * 添加操作
     * 
     * @param operation 操作
     *
     */
    public void addOperation(UMLOperation operation) {
        operations.add(operation);
    }
    
    /**
     * 
     * 转换为XML的DOM结构
     *
     * @param parent 父DOM元素
     */
    public void toDom(Element parent) {
        Element classElement = parent.addElement("UML:Class");
        XMIUtil.addElementAttribute(classElement, "name", this.name);
        XMIUtil.addElementAttribute(classElement, "xmi.id", this.getXMIID());
        XMIUtil.addElementAttribute(classElement, "namespace", this.namespace);
        XMIUtil.addElementAttribute(classElement, "visibility", this.visibility);
        XMIUtil.addElementAttribute(classElement, "isAbstract", isAbstract + "");
        XMIUtil.addElementAttribute(classElement, "isRoot", isRoot + "");
        XMIUtil.addElementAttribute(classElement, "isLeaf", isLeaf + "");
        XMIUtil.addElementAttribute(classElement, "isActive", isActive + "");
        XMIUtil.addTaggedValueElement(classElement, taggedValuesMap);
        
        if (isRoot) {
            return;
        }
        Element classifierFeatureElement = classElement.addElement("UML:Classifier.feature");
        // 添加属性
        for (Iterator<UMLAttribute> attributeIterator = attributes.iterator(); attributeIterator.hasNext();) {
            UMLAttribute attribute = attributeIterator.next();
            attribute.toDom(classifierFeatureElement);
        }
        // 添加操作
        for (Iterator<UMLOperation> operationIterator = operations.iterator(); operationIterator.hasNext();) {
            UMLOperation operation = operationIterator.next();
            operation.toDom(classifierFeatureElement);
        }
    }
    
    /**
     * 获得XMIID
     *
     * @return XMIID
     */
    public String getXMIID() {
        if (this.id == null) {
            return null;
        }
        return ID_PREFIX + this.id;
    }
    
    /**
     * @return 获取 namespace属性值
     */
    public String getNamespace() {
        return namespace;
    }
    
    /**
     * @param namespace 设置 namespace 属性值为参数值 namespace
     */
    public void setNamespace(String namespace) {
        this.namespace = namespace;
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
     * @return 获取 isRoot属性值
     */
    public boolean isRoot() {
        return isRoot;
    }
    
    /**
     * @param isRoot 设置 isRoot 属性值为参数值 isRoot
     */
    public void setRoot(boolean isRoot) {
        this.isRoot = isRoot;
    }
    
    /**
     * @return 获取 isLeaf属性值
     */
    public boolean isLeaf() {
        return isLeaf;
    }
    
    /**
     * @param isLeaf 设置 isLeaf 属性值为参数值 isLeaf
     */
    public void setLeaf(boolean isLeaf) {
        this.isLeaf = isLeaf;
    }
    
    /**
     * @return 获取 isAbstract属性值
     */
    public boolean isAbstract() {
        return isAbstract;
    }
    
    /**
     * @param isAbstract 设置 isAbstract 属性值为参数值 isAbstract
     */
    public void setAbstract(boolean isAbstract) {
        this.isAbstract = isAbstract;
    }
    
    /**
     * @return 获取 isActive属性值
     */
    public boolean isActive() {
        return isActive;
    }
    
    /**
     * @param isActive 设置 isActive 属性值为参数值 isActive
     */
    public void setActive(boolean isActive) {
        this.isActive = isActive;
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
     * @return 获取 attributes属性值
     */
    public List<UMLAttribute> getAttributes() {
        return attributes;
    }
    
    /**
     * @param attributes 设置 attributes 属性值为参数值 attributes
     */
    public void setAttributes(List<UMLAttribute> attributes) {
        this.attributes = attributes;
    }
    
    /**
     * @return 获取 operations属性值
     */
    public List<UMLOperation> getOperations() {
        return operations;
    }
    
    /**
     * @param operations 设置 operations 属性值为参数值 operations
     */
    public void setOperations(List<UMLOperation> operations) {
        this.operations = operations;
    }
    
    /**
     * @return 获取 parentPackage属性值
     */
    public UMLPackage getParentPackage() {
        return parentPackage;
    }
    
    /**
     * @param parentPackage 设置 parentPackage 属性值为参数值 parentPackage
     */
    public void setParentPackage(UMLPackage parentPackage) {
        this.parentPackage = parentPackage;
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
     * @return 获取 attrPosition属性值
     */
    public int getAttrPosition() {
        return attrPosition;
    }
    
    /**
     * @param attrPosition 设置 attrPosition 属性值为参数值 attrPosition
     */
    public void setAttrPosition(int attrPosition) {
        this.attrPosition = attrPosition;
    }
    
    /**
     * @return 获取 operPosition属性值
     */
    public int getOperPosition() {
        return operPosition;
    }
    
    /**
     * @param operPosition 设置 operPosition 属性值为参数值 operPosition
     */
    public void setOperPosition(int operPosition) {
        this.operPosition = operPosition;
    }
    
}
