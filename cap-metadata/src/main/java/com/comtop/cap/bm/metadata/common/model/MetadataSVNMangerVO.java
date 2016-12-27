/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.common.model;

import com.comtop.cip.common.util.builder.EqualsBuilder;
import com.comtop.cip.common.util.builder.HashCodeBuilder;
import com.comtop.cip.common.util.builder.ReflectionToStringBuilder;
import com.comtop.cip.common.util.builder.ToStringStyle;

/**
 * 元数据SVN客户端管理VO
 * 
 * 
 * @author 沈康
 * @since 1.0
 * @version 2014-6-23 沈康
 */
public class MetadataSVNMangerVO {
    
    /** SVN服务器地址 */
    private String url;
    
    /** 用户名 */
    private String username;
    
    /** 密码 */
    private String password;
    
    /**
     * @return 获取 url属性值
     */
    public String getUrl() {
        return url;
    }
    
    /**
     * @param url 设置 url 属性值为参数值 url
     */
    public void setUrl(String url) {
        this.url = url;
    }
    
    /**
     * @return 获取 username属性值
     */
    public String getUsername() {
        return username;
    }
    
    /**
     * @param username 设置 username 属性值为参数值 username
     */
    public void setUsername(String username) {
        this.username = username;
    }
    
    /**
     * @return 获取 password属性值
     */
    public String getPassword() {
        return password;
    }
    
    /**
     * @param password 设置 password 属性值为参数值 password
     */
    public void setPassword(String password) {
        this.password = password;
    }
    
    /**
     * 比较对象是否相等
     * 
     * @param objValue 比较对象
     * @return 对象是否相等
     */
    @Override
    public boolean equals(Object objValue) {
        boolean bEqual = super.equals(objValue);
        if (super.equals(objValue)) {
            bEqual = true;
        } else {
            bEqual = EqualsBuilder.reflectionEquals(this, objValue);
        }
        return bEqual;
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
