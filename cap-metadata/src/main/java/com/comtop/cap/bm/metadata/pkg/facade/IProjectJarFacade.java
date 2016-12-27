/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.pkg.facade;

import java.util.List;

import com.comtop.cap.bm.metadata.pkg.model.ProjectJarVO;

/**
 * 项目依赖包 业务逻辑处理类接口
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2014-5-22 李忠文
 */
public interface IProjectJarFacade extends IProjectJarQueryFacade {

    
    /**
     * 新增 项目依赖包
     * 
     * @param projectJar 项目依赖包对象
     * @return  项目依赖包
     */
     String insertProjectJar(final ProjectJarVO projectJar);
 
     /**
     * 更新 项目依赖包
     * 
     * @param projectJar 项目依赖包对象
     * @return  更新结果
     */
     boolean updateProjectJar(final ProjectJarVO projectJar);
        
    /**
     * 更新 项目依赖包集合
     * 
     * @param projectJars 项目依赖包对象集合
     * @return  更新结果
     */
     boolean updateProjectJarList(final List<ProjectJarVO> projectJars);
    
    /**
     * 删除 项目依赖包
     * 
     * @param projectJar 项目依赖包对象
     */
     void deleteProjectJar(final ProjectJarVO projectJar);    
    
    /**
     * 删除 项目依赖包集合
     * 
     * @param projectJars 项目依赖包对象集合
     */
     void deleteProjectJarList(final List<ProjectJarVO> projectJars);
    
}