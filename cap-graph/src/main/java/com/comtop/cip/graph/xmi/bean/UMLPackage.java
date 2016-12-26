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
 * 包元素
 *
 * @author duqi
 * @since jdk1.6
 * @version 2015年10月20日 duqi
 */
public class UMLPackage extends BaseXMIBean {
    
    /** UMLPackage */
    private List<UMLPackage> packages = new ArrayList<UMLPackage>();
    
    /** UMLCollaboration */
    private UMLCollaboration collaboration;
    
    /** UMLClass */
    private List<UMLClass> classes = new ArrayList<UMLClass>();
    
    /** taggedValuesMap */
    private Map<String, String> taggedValuesMap = new LinkedHashMap<String, String>();
    
    /** 关联关系 */
    private List<UMLAssociation> associations = new ArrayList<UMLAssociation>();
    
    /** 依赖关系 */
    private List<UMLDependency> dependencies = new ArrayList<UMLDependency>();
    
    /** 是否为根 */
    private boolean isRoot;
    
    /** 是否为叶子 */
    private boolean isLeaf;
    
    /** 是否是抽象的 */
    private boolean isAbstract;
    
    /** 可见性 */
    private String visibility = "public";
    
    /** 别名 */
    private String alias;
    
    /** XMI ID 前缀 */
    private static final String ID_PREFIX = "EAPK_";
    
    /** 本地ID */
    private int localId;
    
    /** 父包 */
    private UMLPackage parent;
    
    /** UMLModel */
    private UMLModel model;
    
    /** 类模型包 ： 所有包和类都从该包下开始添加 */
    private UMLPackage classModelPackage;
    
    /**
     * 构造函数
     * 
     * @param model UMLModel
     */
    public UMLPackage(UMLModel model) {
        this.model = model;
        this.isRoot = true;
        this.localId = XMIUtil.getLocalID();
        this.id = model.getId();
        this.name = "Model";
        initRootPackageTaggedValue();
    }
    
    /**
     * 构造函数
     * 
     * @param model UMLModel
     * @param parent 父包
     * @param name 名称
     * @param alias 别名
     * @param isClassModel 是否为类模型
     */
    public UMLPackage(UMLModel model, UMLPackage parent, String name, String alias, boolean isClassModel) {
        this.model = model;
        this.parent = parent;
        this.name = name;
        this.id = XMIUtil.getUUID();
        this.localId = XMIUtil.getLocalID();
        this.alias = alias;
        if (isClassModel) {
            initClassModelPackageTaggedValue();
        } else {
            initPackageTaggedValue();
        }
        
    }
    
    /**
     * 初始化taggedValuesMap
     *
     */
    private void initPackageTaggedValue() {
        String currentTime = DateUtil.getCurrentTime();
        taggedValuesMap.put("parent", parent.getXMIID());
        taggedValuesMap.put("created", currentTime);
        taggedValuesMap.put("modified", currentTime);
        taggedValuesMap.put("iscontrolled", "FALSE");
        taggedValuesMap.put("version", "1.0");
        taggedValuesMap.put("isprotected", "FALSE");
        taggedValuesMap.put("usedtd", "FALSE");
        taggedValuesMap.put("logxml", "FALSE");
        taggedValuesMap.put("phase", "1.0");
        taggedValuesMap.put("status", "Proposed");
        taggedValuesMap.put("author", "system");
        taggedValuesMap.put("complexity", "1");
        taggedValuesMap.put("ea_stype", "Public");
        if (alias != null) {
            taggedValuesMap.put("alias", alias);
        }
    }
    
    /**
     * 初始化根包的taggedValuesMap
     *
     */
    private void initRootPackageTaggedValue() {
        String currentTime = DateUtil.getCurrentTime();
        taggedValuesMap.put("modified", currentTime);
        taggedValuesMap.put("iscontrolled", "FALSE");
        taggedValuesMap.put("lastloaddate", currentTime);
        taggedValuesMap.put("isprotected", "FALSE");
        taggedValuesMap.put("usedtd", "FALSE");
        taggedValuesMap.put("logxml", "FALSE");
        taggedValuesMap.put("packageFlags", "CRC=0;isModel=1;");
    }
    
    /**
     * 初始ClassModel taggedValuesMap
     *
     */
    private void initClassModelPackageTaggedValue() {
        String currentTime = DateUtil.getCurrentTime();
        taggedValuesMap.put("parent", parent.getXMIID());
        taggedValuesMap.put("created", currentTime);
        taggedValuesMap.put("modified", currentTime);
        taggedValuesMap.put("iscontrolled", "FALSE");
        taggedValuesMap.put("isnamespace", "1");
        taggedValuesMap.put("lastloaddate", currentTime);
        taggedValuesMap.put("lastsavedate", currentTime);
        taggedValuesMap.put("isprotected", "FALSE");
        taggedValuesMap.put("usedtd", "FALSE");
        taggedValuesMap.put("logxml", "FALSE");
        taggedValuesMap.put("tpos", "6");
        taggedValuesMap.put("batchsave", "0");
        taggedValuesMap.put("batchload", "0");
        taggedValuesMap.put("packageFlags", "isModel=1;VICON=3;");
        taggedValuesMap.put("phase", "1.0");
        taggedValuesMap.put("status", "Proposed");
        taggedValuesMap.put("complexity", "1");
        taggedValuesMap.put("ea_stype", "Public");
    }
    
    /**
     * 添加一个类模型包
     *
     * @return UMLPackage
     */
    public UMLPackage addClassModelPackage() {
        classModelPackage = new UMLPackage(model, this, "Class Model", null, true);
        packages.add(classModelPackage);
        
        if (collaboration == null) {
            collaboration = new UMLCollaboration(this);
        }
        collaboration.addClassifierRole(classModelPackage);
        return classModelPackage;
    }
    
    /**
     * 添加一个包元素
     *
     * @param pName 包名称
     * @param aName 别名
     * @return 包元素
     */
    public UMLPackage addPackage(String pName, String aName) {
        UMLPackage pckage = new UMLPackage(model, this, pName, aName, false);
        packages.add(pckage);
        if (collaboration == null) {
            collaboration = new UMLCollaboration(this);
        }
        collaboration.addClassifierRole(pckage);
        return pckage;
    }
    
    /**
     * 添加TaggedValue
     *
     * @param key 键
     * @param value 值
     */
    public void addTaggedValue(String key, String value) {
        taggedValuesMap.put(key, value);
    }
    
    /**
     * 添加一个类元素
     *
     * @param clazz 类元素
     */
    public void addClass(UMLClass clazz) {
        classes.add(clazz);
    }
    
    /**
     * 添加一个关联关系
     *
     * @param association 关联关系元素
     */
    public void addAssociation(UMLAssociation association) {
        associations.add(association);
    }
    
    /**
     * 添加一个依赖
     *
     * @param dependency 依赖元素
     */
    public void addDependency(UMLDependency dependency) {
        dependencies.add(dependency);
    }
    
    /**
     * 
     * 转换为XML的DOM结构
     *
     * @param parentElem 父DOM元素
     */
    public void toDom(Element parentElem) {
        Element packageElement = parentElem.addElement("UML:Package");
        XMIUtil.addElementAttribute(packageElement, "name", this.name);
        XMIUtil.addElementAttribute(packageElement, "xmi.id", this.getXMIID());
        XMIUtil.addElementAttribute(packageElement, "isRoot", this.isRoot + "");
        XMIUtil.addElementAttribute(packageElement, "isLeaf", this.isLeaf + "");
        XMIUtil.addElementAttribute(packageElement, "isAbstract", this.isAbstract + "");
        XMIUtil.addElementAttribute(packageElement, "visibility", this.visibility);
        XMIUtil.addTaggedValueElement(packageElement, taggedValuesMap);
        Element ownedElement = packageElement.addElement("UML:Namespace.ownedElement");
        
        if (collaboration != null) {
            collaboration.toDom(ownedElement);
        }
        for (Iterator<UMLClass> iterator = classes.iterator(); iterator.hasNext();) {
            UMLClass next = iterator.next();
            next.toDom(ownedElement);
        }
        for (Iterator<UMLPackage> iterator = packages.iterator(); iterator.hasNext();) {
            UMLPackage next = iterator.next();
            next.toDom(ownedElement);
        }
        
        for (Iterator<UMLAssociation> iterator = associations.iterator(); iterator.hasNext();) {
            UMLAssociation next = iterator.next();
            next.toDom(ownedElement);
        }
        for (Iterator<UMLDependency> iterator = dependencies.iterator(); iterator.hasNext();) {
            UMLDependency next = iterator.next();
            next.toDom(ownedElement);
        }
    }
    
    /**
     * 
     * 转换为XML的DOM结构
     *
     * @param parentElem 父DOM元素
     */
    public void currentElementToDom(Element parentElem) {
        Element packageElement = parentElem.addElement("UML:Package");
        XMIUtil.addElementAttribute(packageElement, "name", this.name);
        XMIUtil.addElementAttribute(packageElement, "xmi.id", this.getXMIID());
        XMIUtil.addElementAttribute(packageElement, "isRoot", this.isRoot + "");
        XMIUtil.addElementAttribute(packageElement, "isLeaf", this.isLeaf + "");
        XMIUtil.addElementAttribute(packageElement, "isAbstract", this.isAbstract + "");
        XMIUtil.addElementAttribute(packageElement, "visibility", this.visibility);
        XMIUtil.addTaggedValueElement(packageElement, taggedValuesMap);
        packageElement.addElement("UML:Namespace.ownedElement");
    }
    
    /**
     * 
     * 转换为XML的DOM结构
     *
     * @param parentElem 父DOM元素
     */
    public void subElementToDom(Element parentElem) {
        if (collaboration != null) {
            collaboration.toDom(parentElem);
        }
        for (Iterator<UMLClass> iterator = classes.iterator(); iterator.hasNext();) {
            UMLClass next = iterator.next();
            next.toDom(parentElem);
        }
        for (Iterator<UMLPackage> iterator = packages.iterator(); iterator.hasNext();) {
            UMLPackage next = iterator.next();
            next.toDom(parentElem);
        }
        
        for (Iterator<UMLAssociation> iterator = associations.iterator(); iterator.hasNext();) {
            UMLAssociation next = iterator.next();
            next.toDom(parentElem);
        }
        for (Iterator<UMLDependency> iterator = dependencies.iterator(); iterator.hasNext();) {
            UMLDependency next = iterator.next();
            next.toDom(parentElem);
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
    
    /**************************** getset方法区 ***********************************/
    
    /**
     * @return 获取 packages属性值
     */
    public List<UMLPackage> getPackages() {
        return packages;
    }
    
    /**
     * @param packages 设置 packages 属性值为参数值 packages
     */
    public void setPackages(List<UMLPackage> packages) {
        this.packages = packages;
    }
    
    /**
     * @return 获取 collaboration属性值
     */
    public UMLCollaboration getCollaboration() {
        return collaboration;
    }
    
    /**
     * @param collaboration 设置 collaboration 属性值为参数值 collaboration
     */
    public void setCollaboration(UMLCollaboration collaboration) {
        this.collaboration = collaboration;
    }
    
    /**
     * @return 获取 classes属性值
     */
    public List<UMLClass> getClasses() {
        return classes;
    }
    
    /**
     * @param classes 设置 classes 属性值为参数值 classes
     */
    public void setClasses(List<UMLClass> classes) {
        this.classes = classes;
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
     * @return 获取 associations属性值
     */
    public List<UMLAssociation> getAssociations() {
        return associations;
    }
    
    /**
     * @param associations 设置 associations 属性值为参数值 associations
     */
    public void setAssociations(List<UMLAssociation> associations) {
        this.associations = associations;
    }
    
    /**
     * @return 获取 dependencies属性值
     */
    public List<UMLDependency> getDependencies() {
        return dependencies;
    }
    
    /**
     * @param dependencies 设置 dependencies 属性值为参数值 dependencies
     */
    public void setDependencies(List<UMLDependency> dependencies) {
        this.dependencies = dependencies;
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
     * @return 获取 parent属性值
     */
    public UMLPackage getParent() {
        return parent;
    }
    
    /**
     * @param parent 设置 parent 属性值为参数值 parent
     */
    public void setParent(UMLPackage parent) {
        this.parent = parent;
    }
    
    /**
     * @return 获取 model属性值
     */
    public UMLModel getModel() {
        return model;
    }
    
    /**
     * @param model 设置 model 属性值为参数值 model
     */
    public void setModel(UMLModel model) {
        this.model = model;
    }
    
    /**
     * @return 获取 classModelPackage属性值
     */
    public UMLPackage getClassModelPackage() {
        return classModelPackage;
    }
    
    /**
     * @param classModelPackage 设置 classModelPackage 属性值为参数值 classModelPackage
     */
    public void setClassModelPackage(UMLPackage classModelPackage) {
        this.classModelPackage = classModelPackage;
    }
    
    /**
     * @return 获取 alias属性值
     */
    public String getAlias() {
        return alias;
    }
    
    /**
     * @param alias 设置 alias 属性值为参数值 alias
     */
    public void setAlias(String alias) {
        this.alias = alias;
    }
    
}
