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
 * 
 * UML模型：这里目前只实现了类模型
 *
 * @author duqi
 * @since jdk1.6
 * @version 2015年10月20日 duqi
 */
public class UMLModel extends BaseXMIBean {
    
    /** 根包 */
    private UMLPackage rootPackage;
    
    /** 数据类型 */
    private List<UMLDatatype> datatypes = new ArrayList<UMLDatatype>();
    
    /** taggedValuesMap */
    private Map<String, String> taggedValuesMap = new LinkedHashMap<String, String>();
    
    /** 根类 */
    private UMLClass rootClass = new UMLClass(true);
    
    /** XMI ID 前缀 */
    private static final String ID_PREFIX = "MX_EAID_";
    
    /** 用户数据类型的序列号 */
    private int increase = 0;
    
    /**
     * 构造函数
     */
    public UMLModel() {
        this.id = XMIUtil.getUUID();
        this.name = "EA Model";
        rootPackage = new UMLPackage(this);
    }
    
    /**
     * 获取序列号 并+1
     *
     * @return 序列号
     */
    public int getAndIncrease() {
        return increase++;
    }
    
    /**
     * 添加数据类型
     *
     * @param datatype 数据类型
     */
    public void addDatatype(UMLDatatype datatype) {
        datatypes.add(datatype);
    }
    
    /**
     * 
     * 转换为XML的DOM结构
     *
     * @param parent 父DOM元素
     */
    public void toDom(Element parent) {
        Element modelElement = parent.addElement("UML:Model");
        modelElement.addAttribute("name", this.name);
        modelElement.addAttribute("xmi.id", this.getXMIID());
        
        Element ownedElement = modelElement.addElement("UML:Namespace.ownedElement");
        rootClass.toDom(ownedElement);
        
        rootPackage.toDom(ownedElement);
        
        for (Iterator<UMLDatatype> iterator = datatypes.iterator(); iterator.hasNext();) {
            UMLDatatype next = iterator.next();
            next.toDom(ownedElement);
        }
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
     * @return 获取 rootPackage属性值
     */
    public UMLPackage getRootPackage() {
        return rootPackage;
    }
    
    /**
     * @param rootPackage 设置 rootPackage 属性值为参数值 rootPackage
     */
    public void setRootPackage(UMLPackage rootPackage) {
        this.rootPackage = rootPackage;
    }
    
    /**
     * @return 获取 datatypes属性值
     */
    public List<UMLDatatype> getDatatypes() {
        return datatypes;
    }
    
    /**
     * @param datatypes 设置 datatypes 属性值为参数值 datatypes
     */
    public void setDatatypes(List<UMLDatatype> datatypes) {
        this.datatypes = datatypes;
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
     * @return 获取 rootClass属性值
     */
    public UMLClass getRootClass() {
        return rootClass;
    }
    
    /**
     * @param rootClass 设置 rootClass 属性值为参数值 rootClass
     */
    public void setRootClass(UMLClass rootClass) {
        this.rootClass = rootClass;
    }
    
    /********************** getset方法区 ****************************/
    
}
