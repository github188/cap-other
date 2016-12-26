/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.definition.model;

import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;

import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlTransient;
import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;

import com.comtop.cap.bm.metadata.base.model.BaseModel;
import com.comtop.cap.common.xml.CDataAdaptor;


/**
 * 测试步骤定义
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年6月22日 lizhongwen
 */
@XmlTransient
public abstract class StepDefinition extends BaseModel {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 包前缀 */
    private static final String PKG_PREFIX = "testStepDefinitions";
    
    /** 名称 */
    private String name;
    
    /** 定义 */
    private String definition;
    
    /** 图标 */
    private String icon;
    
    /** 描述 */
    private String description;
    
    /** 帮助 */
    private String help;
    
    /** 步骤分组 */
    private String group;
    
    /** 脚本 */
    private String macro;
    
    /** 引用库 */
    private Set<String> libraries;
    
    /** 引用资源 */
    private Set<String> resources;
    
    /** 参数集 */
    private List<Argument> arguments;
    
    /**
     * @return 获取 name属性值
     */
    @XmlAttribute(name = "name", required = true)
    public String getName() {
        return name;
    }
    
    /**
     * @param name 设置 name 属性值为参数值 name
     */
    public void setName(String name) {
        this.name = name;
    }
    
    /**
     * @return 获取 definition属性值
     */
    @XmlAttribute(name = "definition", required = true)
    public String getDefinition() {
        return definition;
    }
    
    /**
     * @param definition 设置 definition 属性值为参数值 definition
     */
    public void setDefinition(String definition) {
        this.definition = definition;
    }
    
    /**
     * @return 获取 icon属性值
     */
    @XmlAttribute(name = "icon")
    public String getIcon() {
        return icon;
    }
    
    /**
     * @param icon 设置 icon 属性值为参数值 icon
     */
    public void setIcon(String icon) {
        this.icon = icon;
    }
    
    /**
     * @return 获取 description属性值
     */
    @XmlAttribute(name = "desc")
    public String getDescription() {
        return description;
    }
    
    /**
     * @param description 设置 description 属性值为参数值 description
     */
    public void setDescription(String description) {
        this.description = description;
    }
    
    /**
     * @return 获取 help属性值
     */
    @XmlElement(name = "help")
    @XmlJavaTypeAdapter(value = CDataAdaptor.class)
    public String getHelp() {
        return help;
    }
    
    /**
     * @param help 设置 help 属性值为参数值 help
     */
    public void setHelp(String help) {
        this.help = help;
    }
    
    /**
     * @return 获取 group属性值
     */
    @XmlAttribute(name = "group")
    public String getGroup() {
        return group;
    }
    
    /**
     * @param group 设置 group 属性值为参数值 group
     */
    public void setGroup(String group) {
        this.group = group;
    }
    
    /**
     * @return 获取 macro属性值
     */
    @XmlElement(name = "macro")
    @XmlJavaTypeAdapter(value = CDataAdaptor.class)
    public String getMacro() {
        return macro;
    }
    
    /**
     * @param macro 设置 macro 属性值为参数值 macro
     */
    public void setMacro(String macro) {
        this.macro = macro;
    }
    
    /**
     * @return 获取 libraries属性值
     */
    @XmlElement(name = "lib")
    public Set<String> getLibraries() {
        return libraries;
    }
    
    /**
     * 添加资源库
     * 
     * @param library 引用库
     */
    public void addLibrary(String library) {
        if (this.libraries == null) {
            this.libraries = new HashSet<String>();
        }
        this.libraries.add(library);
    }
    
    /**
     * @param libraries 设置 libraries 属性值为参数值 libraries
     */
    public void setLibraries(Set<String> libraries) {
        this.libraries = libraries;
    }
    
    /**
     * @return 获取 resources属性值
     */
    @XmlElement(name = "res")
    public Set<String> getResources() {
        return resources;
    }
    
    /**
     * 添加资源库
     * 
     * @param resource 引用资源
     */
    public void addResource(String resource) {
        if (this.resources == null) {
            this.resources = new HashSet<String>();
        }
        this.resources.add(resource);
    }
    
    /**
     * @param resources 设置 resources 属性值为参数值 resources
     */
    public void setResources(Set<String> resources) {
        this.resources = resources;
    }
    
    /**
     * @return 获取 arguments属性值
     */
    @XmlElement(name = "arg")
    public List<Argument> getArguments() {
        return arguments;
    }
    
    /**
     * @param arguments 设置 arguments 属性值为参数值 arguments
     */
    public void setArguments(List<Argument> arguments) {
        this.arguments = arguments;
    }
    
    /**
     * 添加参数
     *
     * @param argument 参数
     */
    public void addArgument(Argument argument) {
        if (this.arguments == null) {
            this.arguments = new LinkedList<Argument>();
        }
        this.arguments.add(argument);
    }
    
    /**
     * @return 获取包前缀
     */
    @XmlTransient
    protected String getPackagePrefix() {
        return PKG_PREFIX;
    }
    
    /**
     * @return 获取节点类型
     */
    @XmlTransient
    public abstract StepType getStepType();
    
    /**
     * @see com.comtop.cap.bm.metadata.base.model.BaseModel#getModelId()
     */
    @Override
    @XmlAttribute(name = "type")
    public String getModelId() {
        return this.getModelPackage() + "." + this.getModelType() + "." + this.getDefinition();
    }
    
    /**
     * @see com.comtop.cap.bm.metadata.base.model.BaseModel#getModelPackage()
     */
    @Override
    @XmlTransient
    public String getModelPackage() {
        return this.getPackagePrefix() + "." + this.getStepType().getPath();
    }
    
    /**
     * @see com.comtop.cap.bm.metadata.base.model.BaseModel#getModelName()
     */
    @Override
    @XmlTransient
    public String getModelName() {
        return this.getDefinition();
    }
    
    /**
     * @see com.comtop.cap.bm.metadata.base.model.BaseModel#getModelType()
     */
    @Override
    @XmlTransient
    public String getModelType() {
        return this.getStepType().getType();
    }
    
    /**
     * @see com.comtop.cap.bm.metadata.base.model.BaseModel#getCreateTime()
     */
    @Override
    public long getCreateTime() {
        return super.getCreateTime() == 0 ? System.currentTimeMillis() : super.getCreateTime();
    }
    
}
