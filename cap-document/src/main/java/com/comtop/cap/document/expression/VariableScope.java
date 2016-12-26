/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression;

import java.util.LinkedHashMap;
import java.util.Map;

/**
 * 参数域
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月9日 lizhongwen
 */
public class VariableScope {
    
    /** 参数名-值 */
    private final Map<String, Object> vars = new LinkedHashMap<String, Object>();
    
    /**
     * 构造函数
     */
    public VariableScope() {
    }
    
    /**
     * 构造函数
     * 
     * @param arguments 参数
     */
    public VariableScope(Map<String, Object> arguments) {
        if (arguments != null) {
            this.vars.putAll(arguments);
        }
    }
    
    /**
     * 
     * 构造函数
     * 
     * @param name 参数名
     * @param value 参数值
     */
    public VariableScope(String name, Object value) {
        this.vars.put(name, value);
    }
    
    /**
     * 查找参数
     *
     * @param name 参数名
     * @return 参数值
     */
    public Object lookupVariable(String name) {
        return this.vars.get(name);
    }
    
    /**
     * 设置参数
     *
     * @param name 参数名
     * @param value 参数值
     */
    public void setVariable(String name, Object value) {
        this.vars.put(name, value);
    }
    
    /**
     * 设置参数
     *
     * @param arguments 参数
     */
    public void setVariable(Map<String, Object> arguments) {
        this.vars.putAll(arguments);
    }
    
    /**
     * 定义参数
     *
     * @param name 参数吗
     * @return 参数定义
     */
    public boolean definesVariable(String name) {
        return this.vars.containsKey(name);
    }
}
