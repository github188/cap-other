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
import com.comtop.cap.bm.metadata.pkg.appservice.ProjectJarAppService;
import com.comtop.cap.bm.metadata.pkg.model.ProjectJarVO;
import com.comtop.cap.runtime.base.facade.BaseFacade;

/**
 * 项目依赖包 业务逻辑处理类 门面
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2014-5-22 李忠文
 */
@PetiteBean
public class ProjectJarFacadeImpl extends BaseFacade implements IProjectJarFacade {

  /** 注入AppService **/
    @PetiteInject
    private ProjectJarAppService projectJarAppService;
    
    
    /**
     * 新增 项目依赖包
     * 
     * @param projectJar 项目依赖包对象
     * @return  项目依赖包
     * 
     */
    @Override
    public String insertProjectJar(final ProjectJarVO projectJar) {
        return projectJarAppService.insertProjectJar(projectJar);
    }
    
    /**
     * 更新 项目依赖包
     * 
     * @param projectJar 项目依赖包对象
     * @return  更新结果
     * 
     */
    @Override
    public boolean updateProjectJar(final ProjectJarVO projectJar) {
        return projectJarAppService.updateProjectJar(projectJar);
    }
    
    /**
     * 更新 项目依赖包集合
     * 
     * @param projectJars 项目依赖包对象集合
     * @return  更新结果
     * 
     */
    @Override
    public boolean updateProjectJarList(final List<ProjectJarVO> projectJars) {
        return projectJarAppService.updateProjectJarList(projectJars);
    }
    
    /**
     * 删除 项目依赖包
     * 
     * @param projectJar 项目依赖包对象
     */
    @Override
    public void deleteProjectJar(final ProjectJarVO projectJar) {
         projectJarAppService.deleteProjectJar(projectJar);
    }
    
    /**
     * 删除 项目依赖包集合
     * 
     * @param projectJars 项目依赖包对象集合
     */
    @Override
    public void deleteProjectJarList(final List<ProjectJarVO> projectJars) {
         projectJarAppService.deleteProjectJarList(projectJars);
    }
    
    
    /**
     * 通过项目依赖包ID查询项目依赖包对象
     * 
     * @param projectJarId 项目依赖包对象ID
     * @return  项目依赖包
     * 
     */
    @Override
    public ProjectJarVO queryProjectJarById(final String projectJarId) {
        return projectJarAppService.queryProjectJarById(projectJarId);
    }
    

}