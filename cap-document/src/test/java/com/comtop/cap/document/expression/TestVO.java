/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression;

import java.io.Serializable;

/**
 * 测试VO
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月16日 lizhongwen
 */
public class TestVO implements Serializable {
    
    /** FIXME */
    private static final long serialVersionUID = 1L;
    
    /** name */
    private String name;
    
    /**
     * 构造函数
     */
    public TestVO() {
        super();
    }
    
    /**
     * 构造函数
     * 
     * @param name name
     */
    public TestVO(String name) {
        super();
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
     * 
     * @see java.lang.Object#toString()
     */
    @Override
    public String toString() {
        return "TestVO [name=" + name + "]";
    }
    
}
