/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.pkg.facade;

import java.util.List;

import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.bm.metadata.pkg.appservice.ProjectAppService;
import com.comtop.cap.bm.metadata.pkg.model.ProjectVO;
import com.comtop.cap.runtime.base.facade.BaseFacade;

/**
 * 项目 业务逻辑处理类 门面
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2014-5-22 李忠文
 */
@PetiteBean
public class ProjectFacadeImpl extends BaseFacade implements IProjectFacade {
    
    /** 注入AppService **/
    @PetiteInject(value = "cipProjectAppService")
    private ProjectAppService projectAppService;
    
    /**
     * 新增 项目
     * 
     * @param project 项目对象
     * @return 项目
     * 
     */
    @Override
    public String insertProject(final ProjectVO project) {
        return projectAppService.insertProject(project, true);
    }
    
    /**
     * 更新 项目
     * 
     * @param project 项目对象
     * @return 更新结果
     * 
     */
    @Override
    public boolean updateProject(final ProjectVO project) {
        return projectAppService.updateProject(project, true);
    }
    
    /**
     * 更新 项目集合
     * 
     * @param projects 项目对象集合
     * @return 更新结果
     * 
     */
    @Override
    public boolean updateProjectList(final List<ProjectVO> projects) {
        return projectAppService.updateProjectList(projects);
    }
    
    /**
     * 删除 项目
     * 
     * @param project 项目对象
     */
    @Override
    public void deleteProject(final ProjectVO project) {
        projectAppService.deleteProject(project, true);
    }
    
    /**
     * 删除 项目集合
     * 
     * @param projects 项目对象集合
     */
    @Override
    public void deleteProjectList(final List<ProjectVO> projects) {
        projectAppService.deleteProjectList(projects, true);
    }
    
    /**
     * 通过项目ID查询项目对象
     * 
     * @param projectId 项目对象ID
     * @return 项目
     * 
     */
    @Override
    public ProjectVO queryProjectById(final String projectId) {
        return projectAppService.queryProjectById(projectId);
    }
    
    /**
     * 通过用户ID查询该用户所在项目
     *
     * @param userId 用户ID
     * @return 项目集合
     */
    @Override
    public List<ProjectVO> queryProjectsByUserId(String userId) {
        return projectAppService.queryProjectsByUserId(userId);
    }
    
}
