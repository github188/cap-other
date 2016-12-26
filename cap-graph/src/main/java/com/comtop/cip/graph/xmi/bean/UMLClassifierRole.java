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

import com.comtop.cip.graph.xmi.utils.DateUtil;
import com.comtop.cip.graph.xmi.utils.XMIUtil;

/**
 * UMLClassifierRole
 *
 * @author duqi
 * @since jdk1.6
 * @version 2015年10月8日 duqi
 */
public class UMLClassifierRole extends BaseXMIBean {
    
    /** 可见性 */
    private String visibility = "public";
    
    /** 根包xmiid */
    private String base;
    
    /** taggedValuesMap */
    private Map<String, String> taggedValuesMap = new LinkedHashMap<String, String>();
    
    /** xmi id 前缀 */
    private static final String ID_PREFIX = "EAID_";
    
    /** 父包 */
    private UMLPackage parentPackage;
    
    /** 当前包 */
    private UMLPackage currentPackage;
    
    /**
     * 构造函数
     * 
     * @param parentPackage 父包
     * @param currentPackage 当前包
     */
    public UMLClassifierRole(UMLPackage parentPackage, UMLPackage currentPackage) {
        this.parentPackage = parentPackage;
        this.currentPackage = currentPackage;
        this.id = currentPackage.getId();
        this.name = currentPackage.getName();
        this.base = ID_PREFIX + parentPackage.getModel().getRootClass().getId();
        initTaggedValues();
        
    }
    
    /**
     * 
     * 初始化taggedValuesMap
     *
     */
    public void initTaggedValues() {
        String currentTime = DateUtil.getCurrentTime();
        taggedValuesMap.put("isAbstract", "false");
        taggedValuesMap.put("isSpecification", "false");
        taggedValuesMap.put("ea_stype", "Package");
        taggedValuesMap.put("ea_ntype", "0");
        taggedValuesMap.put("version", "1.0");
        taggedValuesMap.put("package", "EAPK_" + parentPackage.getId());
        taggedValuesMap.put("date_created", currentTime);
        taggedValuesMap.put("date_modified", currentTime);
        taggedValuesMap.put("gentype", "Java");
        taggedValuesMap.put("tagged", "0");
        taggedValuesMap.put("package2", "EAID_" + currentPackage.getId());
        taggedValuesMap.put("package_name", parentPackage.getName());
        taggedValuesMap.put("phase", "1.0");
        taggedValuesMap.put("author", "system");
        taggedValuesMap.put("complexity", "1");
        taggedValuesMap.put("status", "Proposed");
        taggedValuesMap.put("tpos", "0");// TODO
        taggedValuesMap.put("ea_localid", "" + XMIUtil.getLocalID());
        taggedValuesMap.put("ea_eleType", "package");
        taggedValuesMap.put("style",
            "BackColor=-1;BorderColor=-1;BorderWidth=-1;FontColor=-1;VSwimLanes=1;HSwimLanes=1;BorderStyle=0;");
        if (currentPackage.getAlias() != null) {
            taggedValuesMap.put("alias", currentPackage.getAlias());
        }
    }
    
    /**
     * 
     * 转换为XML的DOM结构
     *
     * @param parent 父DOM元素
     */
    public void toDom(Element parent) {
        Element classifierRoleElement = parent.addElement("UML:ClassifierRole");
        XMIUtil.addElementAttribute(classifierRoleElement, "name", this.name);
        XMIUtil.addElementAttribute(classifierRoleElement, "xmi.id", this.getXMIID());
        XMIUtil.addElementAttribute(classifierRoleElement, "visibility", this.visibility);
        XMIUtil.addElementAttribute(classifierRoleElement, "base", this.base);
        XMIUtil.addTaggedValueElement(classifierRoleElement, taggedValuesMap);
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
     * @return 获取 base属性值
     */
    public String getBase() {
        return base;
    }
    
    /**
     * @param base 设置 base 属性值为参数值 base
     */
    public void setBase(String base) {
        this.base = base;
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
     * @return 获取 currentPackage属性值
     */
    public UMLPackage getCurrentPackage() {
        return currentPackage;
    }
    
    /**
     * @param currentPackage 设置 currentPackage 属性值为参数值 currentPackage
     */
    public void setCurrentPackage(UMLPackage currentPackage) {
        this.currentPackage = currentPackage;
    }
    
}
