/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cip.graph.image.facade;

import com.comtop.cip.graph.image.model.ImageVO;

/**
 * 图形转换为图片的接口
 *
 * @author duqi
 *
 */
public interface IGraphToImageFacade {
    
    /**
     * 获取应用结构图 的生成图片
     * 
     * @param moduleId 模块ID
     * @param rootUrl 根路径
     * @param cookieString cookie字符串
     * @return 生成图片路径
     */
    public ImageVO getModuleStructImage(final String moduleId, final String rootUrl, final String cookieString);
    
    /**
     * 获取模块关系图 的生成图片路径
     * 
     * @param moduleId 模块ID
     * @param rootUrl 根路径
     * @param cookieString cookie字符串
     * @return 生成图片路径
     */
    public ImageVO getModuleRelationImage(final String moduleId, final String rootUrl, final String cookieString);
    
    /**
     * 获取资源关系图 的生成图片路径
     * 
     * @param moduleId 模块ID
     * @param rootUrl 根路径
     * @param cookieString cookie字符串
     * @return 生成图片路径
     */
    public ImageVO getResourceRelationImage(final String moduleId, final String rootUrl, final String cookieString);
    
    /**
     * 获取逻辑部署图 的生成图片路径
     * 
     * @param moduleId 模块ID
     * @param rootUrl 根路径
     * @param cookieString cookie字符串
     * @return 生成图片路径
     */
    public ImageVO getLogicDeploymentImage(final String moduleId, final String rootUrl, final String cookieString);
    
    /**
     * 获取物理部署图 的生成图片路径
     * 
     * @param moduleId 模块ID
     * @param rootUrl 根路径
     * @param cookieString cookie字符串
     * @return 生成图片路径
     */
    public ImageVO getPhysicDeploymentImage(final String moduleId, final String rootUrl, final String cookieString);
    
    /**
     * 获取数据库关系图 的生成图片路径
     * 
     * @param moduleId 模块ID
     * @param rootUrl 根路径
     * @param cookieString cookie字符串
     * @return 生成图片路径
     */
    public ImageVO getERImage(final String moduleId, final String rootUrl, final String cookieString);
    
}
