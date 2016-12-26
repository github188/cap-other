/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cip.graph.xmi.bean;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.dom4j.Element;

import com.comtop.cip.graph.xmi.utils.XMIUtil;

/**
 * 
 * 包连接元素：记录了父包与当前包的关系
 *
 * @author duqi
 * @since jdk1.6
 * @version 2015年10月20日 duqi
 */
public class UMLCollaboration extends BaseXMIBean {
    
    /** List<UMLClassifierRole> */
    private List<UMLClassifierRole> classifierRoles = new ArrayList<UMLClassifierRole>();
    
    /** 父包 */
    private UMLPackage parentPackage;
    
    /** xmi id 前缀 */
    private static final String ID_PREFIX = "EAID_";
    
    /** xmi id 后缀 */
    private static final String ID_SUFFIX = "_Collaboration";
    
    /**
     * 
     * 构造函数
     * 
     * @param parentPackage 父包
     */
    public UMLCollaboration(UMLPackage parentPackage) {
        this.parentPackage = parentPackage;
        this.id = parentPackage.getId();
        this.name = "Collaborations";
    }
    
    /**
     * 
     * 添加UMLClassifierRole
     *
     * @param currentPackage 当前包
     */
    public void addClassifierRole(UMLPackage currentPackage) {
        UMLClassifierRole classifierRole = new UMLClassifierRole(parentPackage, currentPackage);
        classifierRoles.add(classifierRole);
    }
    
    /**
     * 
     * 转换为XML的DOM结构
     *
     * @param parent 父DOM元素
     */
    public void toDom(Element parent) {
        Element collaborationElement = parent.addElement("UML:Collaboration");
        XMIUtil.addElementAttribute(collaborationElement, "name", this.name);
        XMIUtil.addElementAttribute(collaborationElement, "xmi.id", this.getXMIID());
        Element ownedElement = collaborationElement.addElement("UML:Namespace.ownedElement");
        
        for (Iterator<UMLClassifierRole> iterator = classifierRoles.iterator(); iterator.hasNext();) {
            UMLClassifierRole next = iterator.next();
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
        return ID_PREFIX + this.id + ID_SUFFIX;
    }
    
    /**
     * @return 获取 classifierRoles属性值
     */
    public List<UMLClassifierRole> getClassifierRoles() {
        return classifierRoles;
    }
    
    /**
     * @param classifierRoles 设置 classifierRoles 属性值为参数值 classifierRoles
     */
    public void setClassifierRoles(List<UMLClassifierRole> classifierRoles) {
        this.classifierRoles = classifierRoles;
    }
    
}
