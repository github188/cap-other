/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.design.generate;

import java.util.Collection;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;

/**
 * 脚本
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年7月8日 lizhongwen
 */
public class Script {
    
    /** 脚本名称 */
    private String name;
    
    /** 引入库 */
    private Set<String> libs;
    
    /** 引入资源 */
    private Set<String> resources;
    
    /** 引入变量 */
    private Set<String> variables;
    
    /** 脚本片段 */
    private List<String> segments;
    
    /**
     * 构造函数
     */
    public Script() {
        super();
    }
    
    /**
     * 构造函数
     * 
     * @param name 脚本名称
     */
    public Script(String name) {
        this();
        this.name = name;
    }
    
    /**
     * @return 获取 name属性值
     */
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
     * @return 获取 libs属性值
     */
    public Set<String> getLibs() {
        return libs;
    }
    
    /**
     * @param libs 设置 libs 属性值为参数值 libs
     */
    public void setLibs(Set<String> libs) {
        this.libs = libs;
    }
    
    /**
     * @param lib 添加引入库
     */
    public void addLib(String lib) {
        if (this.libs == null) {
            this.libs = new HashSet<String>();
        }
        this.libs.add(lib);
    }
    
    /**
     * @param liberaris 批量添加引入库
     */
    public void addLibs(Collection<String> liberaris) {
        if (this.libs == null) {
            this.libs = new HashSet<String>();
        }
        this.libs.addAll(liberaris);
    }
    
    /**
     * @return 获取 resources属性值
     */
    public Set<String> getResources() {
        return resources;
    }
    
    /**
     * @param resources 设置 resources 属性值为参数值 resources
     */
    public void setResources(Set<String> resources) {
        this.resources = resources;
    }
    
    /**
     * @param resource 添加资源
     */
    public void addResource(String resource) {
        if (this.resources == null) {
            this.resources = new HashSet<String>();
        }
        this.resources.add(resource);
    }
    
    /**
     * @param reses 批量添加资源
     */
    public void addResources(Collection<String> reses) {
        if (this.resources == null) {
            this.resources = new HashSet<String>();
        }
        this.resources.addAll(reses);
    }
    
    /**
     * @return 获取 variables属性值
     */
    public Set<String> getVariables() {
        return variables;
    }
    
    /**
     * @param variables 设置 variables 属性值为参数值 variables
     */
    public void setVariables(Set<String> variables) {
        this.variables = variables;
    }
    
    /**
     * @param variable 添加变量
     */
    public void addVariable(String variable) {
        if (this.variables == null) {
            this.variables = new HashSet<String>();
        }
        this.variables.add(variable);
    }
    
    /**
     * @param vars 批量添加变量
     */
    public void addVariables(Collection<String> vars) {
        if (this.variables == null) {
            this.variables = new HashSet<String>();
        }
        this.variables.addAll(variables);
    }
    
    /**
     * @return 获取 segments属性值
     */
    public List<String> getSegments() {
        return segments;
    }
    
    /**
     * @param segments 设置 segments 属性值为参数值 segments
     */
    public void setSegments(List<String> segments) {
        this.segments = segments;
    }
    
    /**
     * @param segment 添加脚本片段
     */
    public void addSegment(String segment) {
        if (this.segments == null) {
            this.segments = new LinkedList<String>();
        }
        this.segments.add(segment);
    }
    
    /**
     * @param segs 批量脚本片段
     */
    public void addSegments(Collection<String> segs) {
        if (this.segments == null) {
            this.segments = new LinkedList<String>();
        }
        this.segments.addAll(segs);
    }
    
    /**
     * @param script 合并脚本
     */
    public void merge(Script script) {
        if (script == null) {
            return;
        }
        if (this.libs == null && script.libs != null) {
            this.libs = script.libs;
        } else if (this.libs != null && script.libs != null) {
            this.libs.addAll(script.libs);
        }
        if (this.resources == null && script.resources != null) {
            this.resources = script.resources;
        } else if (this.resources != null && script.resources != null) {
            this.resources.addAll(script.resources);
        }
        if (this.variables == null && script.variables != null) {
            this.variables = script.variables;
        } else if (this.variables != null && script.variables != null) {
            this.variables.addAll(script.variables);
        }
        if (this.segments == null && script.segments != null) {
            this.segments = script.segments;
        } else if (this.segments != null && script.segments != null) {
            this.segments.addAll(script.segments);
        }
    }
}
