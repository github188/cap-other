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

import com.comtop.cip.graph.xmi.utils.XMIUtil;

/**
 * UML 关联关系
 *
 *
 * @author duqi
 * @since jdk1.6
 * @version 2015年10月8日 duqi
 */
public class UMLAssociation extends BaseXMIBean {
    
    /** 可见性 */
    private String visibility = "public";
    
    /** 是否为根 */
    private boolean isRoot = false;
    
    /** 是否为叶子 */
    private boolean isLeaf = false;
    
    /** 是否为抽象的 */
    private boolean isAbstract = false;
    
    /** taggedValuesMap集合 */
    private Map<String, String> taggedValuesMap = new LinkedHashMap<String, String>();
    
    /** UMLAssociationEnd集合 */
    private List<UMLAssociationEnd> associationEnds = new ArrayList<UMLAssociationEnd>();
    
    /** XMI ID 前缀 */
    private static final String ID_PREFIX = "EAID_";
    
    /** local ID */
    private int localId;
    
    /** 关联的源类 */
    private UMLClass sourceClass;
    
    /** 关联的目标类 */
    private UMLClass targetClass;
    
    /** 源多重性 */
    private String sourceMultiplicity;
    
    /** 目标多重性 */
    private String targetMultiplicity;
    
    /**
     * 构造函数
     * 
     * @param sourceClass 源类
     * @param targetClass 目标类
     * @param sourceMultiplicity 源多重性
     * @param targetMultiplicity 目标多重性
     */
    public UMLAssociation(UMLClass sourceClass, UMLClass targetClass, String sourceMultiplicity,
        String targetMultiplicity) {
        this.id = XMIUtil.getUUID();
        this.localId = XMIUtil.getLocalID();
        this.sourceClass = sourceClass;
        this.targetClass = targetClass;
        this.sourceMultiplicity = sourceMultiplicity;
        this.targetMultiplicity = targetMultiplicity;
        initTaggedValue();
        addAssociationEnd();
    }
    
    /**
     * 初始化taggedValuesMap
     *
     */
    private void initTaggedValue() {
        taggedValuesMap.put("style", "3");
        taggedValuesMap.put("ea_type", "Association");
        taggedValuesMap.put("direction", "Unspecified");
        taggedValuesMap.put("linemode", "3");
        taggedValuesMap.put("linewidth", "-1");
        taggedValuesMap.put("seqno", "0");// TODO
        taggedValuesMap.put("headStyle", "0");
        taggedValuesMap.put("lineStyle", "0");
        taggedValuesMap.put("ea_localid", "" + localId);
        taggedValuesMap.put("ea_sourceName", sourceClass.getName());
        taggedValuesMap.put("ea_targetName", targetClass.getName());
        taggedValuesMap.put("ea_sourceType", sourceClass.getType());
        taggedValuesMap.put("ea_targetType", targetClass.getType());
        taggedValuesMap.put("ea_sourceID", "" + sourceClass.getLocalId());
        taggedValuesMap.put("ea_targetID", "" + targetClass.getLocalId());
        taggedValuesMap.put("lb", sourceMultiplicity);
        taggedValuesMap.put("rb", targetMultiplicity);
    }
    
    /**
     * 添加UMLAssociationEnd
     *
     */
    private void addAssociationEnd() {
        UMLAssociationEnd sourceAssociationEnd = new UMLAssociationEnd(sourceClass, sourceMultiplicity, true);
        UMLAssociationEnd targetAssociationEnd = new UMLAssociationEnd(targetClass, targetMultiplicity, false);
        associationEnds.add(sourceAssociationEnd);
        associationEnds.add(targetAssociationEnd);
    }
    
    /**
     * 
     * 转换为XML的DOM结构
     *
     * @param parent 父DOM元素
     */
    public void toDom(Element parent) {
        Element packageElement = parent.addElement("UML:Association");
        XMIUtil.addElementAttribute(packageElement, "name", this.name);
        XMIUtil.addElementAttribute(packageElement, "xmi.id", this.getXMIID());
        XMIUtil.addElementAttribute(packageElement, "isRoot", this.isRoot + "");
        XMIUtil.addElementAttribute(packageElement, "isLeaf", this.isLeaf + "");
        XMIUtil.addElementAttribute(packageElement, "isAbstract", this.isAbstract + "");
        XMIUtil.addElementAttribute(packageElement, "visibility", this.visibility);
        XMIUtil.addTaggedValueElement(packageElement, taggedValuesMap);
        Element associationConnectionElement = packageElement.addElement("UML:Association.connection");
        for (Iterator<UMLAssociationEnd> iterator = associationEnds.iterator(); iterator.hasNext();) {
            UMLAssociationEnd next = iterator.next();
            next.toDom(associationConnectionElement);
        }
    }
    
    /**
     * 获取XMIID
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
     * @return 获取 associationEnds属性值
     */
    public List<UMLAssociationEnd> getAssociationEnds() {
        return associationEnds;
    }
    
    /**
     * @param associationEnds 设置 associationEnds 属性值为参数值 associationEnds
     */
    public void setAssociationEnds(List<UMLAssociationEnd> associationEnds) {
        this.associationEnds = associationEnds;
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
     * @return 获取 sourceClass属性值
     */
    public UMLClass getSourceClass() {
        return sourceClass;
    }
    
    /**
     * @param sourceClass 设置 sourceClass 属性值为参数值 sourceClass
     */
    public void setSourceClass(UMLClass sourceClass) {
        this.sourceClass = sourceClass;
    }
    
    /**
     * @return 获取 targetClass属性值
     */
    public UMLClass getTargetClass() {
        return targetClass;
    }
    
    /**
     * @param targetClass 设置 targetClass 属性值为参数值 targetClass
     */
    public void setTargetClass(UMLClass targetClass) {
        this.targetClass = targetClass;
    }
    
    /**
     * @return 获取 sourceMultiplicity属性值
     */
    public String getSourceMultiplicity() {
        return sourceMultiplicity;
    }
    
    /**
     * @param sourceMultiplicity 设置 sourceMultiplicity 属性值为参数值 sourceMultiplicity
     */
    public void setSourceMultiplicity(String sourceMultiplicity) {
        this.sourceMultiplicity = sourceMultiplicity;
    }
    
    /**
     * @return 获取 targetMultiplicity属性值
     */
    public String getTargetMultiplicity() {
        return targetMultiplicity;
    }
    
    /**
     * @param targetMultiplicity 设置 targetMultiplicity 属性值为参数值 targetMultiplicity
     */
    public void setTargetMultiplicity(String targetMultiplicity) {
        this.targetMultiplicity = targetMultiplicity;
    }
    
}
