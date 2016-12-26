/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cip.graph.xmi.bean;

import org.dom4j.Element;

/**
 * 
 * 数据类型元素 ： 属性、方法参数、方法返回值的类型
 *
 * @author duqi
 * @since jdk1.6
 * @version 2015年10月20日 duqi
 */
public class UMLDatatype extends BaseXMIBean {
    
    /** 可见性 */
    private String visibility = "private";
    
    /** 是否为根 */
    private boolean isRoot;
    
    /** 是否为叶子 */
    private boolean isLeaf;
    
    /** 是否为抽象的 */
    private boolean isAbstract;
    
    /** 是否为抽象的 */
    private static final String ID_PREFIX = "eaxmiid";
    
    /**
     * 构造函数
     * 
     * @param num id序号
     * @param name 类型名称
     */
    public UMLDatatype(int num, String name) {
        this.id = ID_PREFIX + num;
        this.name = name;
    }
    
    /**
     * 
     * 转换为XML的DOM结构
     *
     * @param parent 父DOM元素
     */
    public void toDom(Element parent) {
        Element dataTypeElement = parent.addElement("UML:DataType");
        dataTypeElement.addAttribute("name", this.name);
        dataTypeElement.addAttribute("xmi.id", this.id);
        dataTypeElement.addAttribute("visibility", this.visibility + "");
        dataTypeElement.addAttribute("isRoot", this.isRoot + "");
        dataTypeElement.addAttribute("isLeaf", this.isLeaf + "");
        dataTypeElement.addAttribute("isAbstract", this.isAbstract + "");
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
    
}
