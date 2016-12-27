/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.pkg.facade;

import java.util.List;

import com.comtop.cap.bm.metadata.pkg.model.ProjectVO;

/**
 * 项目 业务逻辑处理类接口
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2014-5-22 李忠文
 */
public interface IProjectFacade extends IProjectQueryFacade {
    
    /**
     * 新增 项目
     * 
     * @param project 项目对象
     * @return 项目
     */
    String insertProject(final ProjectVO project);
    
    /**
     * 更新 项目
     * 
     * @param project 项目对象
     * @return 更新结果
     */
    boolean updateProject(final ProjectVO project);
    
    /**
     * 更新 项目集合
     * 
     * @param projects 项目对象集合
     * @return 更新结果
     */
    boolean updateProjectList(final List<ProjectVO> projects);
    
    /**
     * 删除 项目
     * 
     * @param project 项目对象
     */
    void deleteProject(final ProjectVO project);
    
    /**
     * 删除 项目集合
     * 
     * @param projects 项目对象集合
     */
    void deleteProjectList(final List<ProjectVO> projects);
    
}
