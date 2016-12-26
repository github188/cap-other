/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.expression;

/**
 * 文档容器注册接口
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年12月17日 lizhongwen
 */
public interface IDocumentRegister {
    
    /**
     * 设置默认服务
     *
     * @param defautService 默认服务对象
     */
    void setDefaultService(final Object defautService);
    
    /**
     * 注册文档服务
     *
     * @param type 文档服务类型
     */
    void registerService(final Class<?> type);
    
    /**
     * 注册文档服务
     *
     * @param service 服务对象
     */
    void registerService(final Object service);
    
    /**
     * 注册文档对象
     *
     * @param type 文档对象类型
     * @param service VO服务对象
     */
    void registerService(final Class<?> type, final Object service);
    
    /**
     * 注册函数
     *
     * @param type 函数所在的类
     */
    void registerFunction(final Class<?> type);
    
    /**
     * 注册结束
     */
    void registed();
    
}
