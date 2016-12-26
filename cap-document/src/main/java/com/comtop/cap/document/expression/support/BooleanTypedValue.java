/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression.support;

/**
 * Boolean数值
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月10日 lizhongwen
 */
public class BooleanTypedValue extends TypedValue {
    
    /** true */
    public static final BooleanTypedValue TRUE = new BooleanTypedValue(true);
    
    /** false */
    public static final BooleanTypedValue FALSE = new BooleanTypedValue(false);
    
    /**
     * 构造函数
     * 
     * @param b boolean值
     */
    private BooleanTypedValue(boolean b) {
        super(b, TypeDescriptor.valueOf(Boolean.class));
    }
    
    /**
     * 获取值
     *
     * @param b 布尔值
     * @return 值
     */
    public static BooleanTypedValue forValue(boolean b) {
        if (b) {
            return TRUE;
        }
        return FALSE;
    }
}
