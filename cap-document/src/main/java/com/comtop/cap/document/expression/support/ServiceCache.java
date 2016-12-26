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
 * 服务缓存
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月24日 lizhongwen
 */
public class ServiceCache {
    
    /** 默认服务 */
    public static final String DEFAULT_SERVICE = "_defaultService";
    
    /** 服务 */
    private final Map<String, Object> services = new HashMap<String, Object>();
    
    /**
     * 注册服务
     * 
     * @param name 名称
     * @param service 服务
     */
    public void registerService(String name, Object service) {
        this.services.put(name, service);
    }
    
    /**
     * 设置服务
     *
     * @param services 服务集合
     */
    public void setServices(Map<String, Object> services) {
        this.services.putAll(services);
    }
    
    /**
     * 获取服务
     * 
     * @param name 名称
     * @return 服务
     */
    public Object lookupService(String name) {
        Object service = this.services.get(name);
        if (service == null) {
            service = this.services.get(DEFAULT_SERVICE);
        }
        return service;
    }
}
