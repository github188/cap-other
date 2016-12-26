/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression.support;

import java.util.HashMap;
import java.util.Map;

/**
 * 值对象缓存
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月24日 lizhongwen
 */
public class ValueObjectCache {
    
    /** VO */
    private final Map<String, Class<?>> valueObjects = new HashMap<String, Class<?>>();
    
    /**
     * 注册VO
     * 
     * @param name 名称
     * @param voType VO类型
     */
    public void registerValueObject(String name, Class<?> voType) {
        this.valueObjects.put(name, voType);
    }
    
    /**
     * 设置VO类型集合
     * 
     * @param valueObjects VO类型集合
     */
    public void setValueObjects(Map<String, Class<?>> valueObjects) {
        this.valueObjects.putAll(valueObjects);
    }
    
    /**
     * 获取VO类型
     * 
     * @param name 名称
     * @return VO类型
     */
    public Class<?> lookupValueObject(String name) {
        return this.valueObjects.get(name);
    }
}
