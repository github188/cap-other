/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.base.model;

import java.io.Serializable;

import com.comtop.cip.common.util.builder.EqualsBuilder;
import com.comtop.cip.common.util.builder.HashCodeBuilder;
import com.comtop.cip.common.util.builder.ReflectionToStringBuilder;
import com.comtop.cip.common.util.builder.ToStringStyle;

/**
 * 模型公共父类
 *
 * @author 郑重
 * @version jdk1.5
 * @version 2015-4-22 郑重
 */
abstract public class BaseMetadata implements Serializable {
    
    /** serialVersionUID */
    private static final long serialVersionUID = -4066066704536947588L;
    
    /**
     * 比较对象是否相等
     *
     * @param objValue 比较对象
     * @return 对象是否相等
     * @see java.lang.Object#equals(java.lang.Object)
     */
    @Override
    public boolean equals(Object objValue) {
        return super.equals(objValue) ? true : EqualsBuilder.reflectionEquals(this, objValue);
    }
    
    /**
     * 生成hashCode
     *
     * @return hashCode值
     * @see java.lang.Object#hashCode()
     */
    @Override
    public int hashCode() {
        return HashCodeBuilder.reflectionHashCode(this);
    }
    
    /**
     * 通用toString
     *
     * @return 类信息
     */
    @Override
    public String toString() {
        return ReflectionToStringBuilder.toString(this, ToStringStyle.MULTI_LINE_STYLE);
    }
}
