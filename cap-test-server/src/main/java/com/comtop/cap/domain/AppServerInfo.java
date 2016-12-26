/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.domain;

/**
 * 应用服务器信息
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年8月22日 lizhongwen
 */
public class AppServerInfo {
    
    /** 应用服务器URL */
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
}
