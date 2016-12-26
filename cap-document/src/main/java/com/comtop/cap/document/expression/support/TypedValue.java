/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression.support;

import com.comtop.cap.document.expression.support.TypeDescriptor.EndSymbol;
import com.comtop.cap.document.expression.support.TypeDescriptor.InitSymbol;

/**
 * 包装数据以及数据类型
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月9日 lizhongwen
 */
public class TypedValue {
    
    /** 空值 */
    public static final TypedValue NULL = new TypedValue(null, TypeDescriptor.NULL);
    
    /** 结束符 */
    public static final TypedValue EOF = new TypedValue(EndSymbol.instance(), TypeDescriptor.EOF);
    
    /** 初始化符 */
    public static final TypedValue INIT = new TypedValue(InitSymbol.instance(), TypeDescriptor.INIT);
    
    /** 值 */
    protected Object value;
    
    /** 类型描述 */
    protected TypeDescriptor descriptor;
    
    /**
     * 构造函数
     */
    protected TypedValue() {
        
    }
    
    /**
     * 构造函数
     * 
     * @param value 值
     */
    public TypedValue(Object value) {
        this.value = value;
        this.descriptor = null; // initialized when/if requested
    }
    
    /**
     * 构造函数
     * 
     * @param value 值
     * @param descriptor 类型描述
     */
    public TypedValue(Object value, TypeDescriptor descriptor) {
        this.value = value;
        this.descriptor = descriptor;
    }
    
    /**
     * @param value 设置值
     */
    public void setValue(Object value) {
        this.value = value;
        this.descriptor = TypeDescriptor.forObject(value);
    }
    
    /**
     * @return 获取 value属性值
     */
    public Object getValue() {
        return value;
    }
    
    /**
     * @return 获取 descriptor属性值
     */
    public TypeDescriptor getDescriptor() {
        return descriptor;
    }
    
}
