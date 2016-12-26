/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression.support;

import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Map;

/**
 * 函数缓存
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月24日 lizhongwen
 */
public class FunctionCache {
    
    /** 默认函数前缀 */
    public static final String DEFAULT_SERVICE_PREFIX = "_defaultService";
    
    /** 函数集合 */
    private final Map<String, Method> functions = new HashMap<String, Method>();
    
    /**
     * 注册VO
     * 
     * @param name 名称
     * @param function 函数
     */
    public void registerFunction(String name, Method function) {
        this.functions.put(name, function);
    }
    
    /**
     * 设置函数集合
     * 
     * @param functions 函数集合
     */
    public void setFunctions(Map<String, Method> functions) {
        this.functions.putAll(functions);
    }
    
    /**
     * 获取函数
     * 
     * @param name 名称
     * @return 函数
     */
    public Method lookupFunction(String name) {
        Method method = this.functions.get(name);
        if (method == null) {
            String defaultName = DEFAULT_SERVICE_PREFIX + "#" + name.split("#")[1];
            method = this.functions.get(defaultName);
        }
        return method;
    }
}
