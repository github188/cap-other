/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docmodel.style;

/**
 * CSS属性类
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年11月3日 lizhiyong
 */
public class CSSProperty {
    
    /** 属性名 */
    private final String name;
    
    /** 属性值 */
    private final String value;
    
    /**
     * 构造函数
     * 
     * @param name x
     * @param value x
     */
    public CSSProperty(String name, String value) {
        this.name = name;
        this.value = value;
    }
    
    /**
     * @return 获取 name属性值
     */
    public String getName() {
        return name;
    }
    
    /**
     * @return 获取 value属性值
     */
    public String getValue() {
        return value;
    }
    
}
