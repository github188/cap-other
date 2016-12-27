/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.pkg.appservice;

import java.util.List;

import com.comtop.cip.jodd.jtx.JtxPropagationBehavior;
import com.comtop.cip.jodd.jtx.meta.Transaction;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.bm.metadata.pkg.dao.ProjectJarDAO;
import com.comtop.cap.bm.metadata.pkg.model.ProjectJarVO;
import com.comtop.cap.runtime.base.appservice.BaseAppService;
import com.comtop.corm.resource.util.CollectionUtils;

/**
 * 项目依赖包 业务逻辑处理类
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2014-5-22 李忠文
 */
@PetiteBean
public class ProjectJarAppService extends BaseAppService {
    
    /** 注入DAO **/
    @PetiteInject
    protected ProjectJarDAO projectJarDAO;
    
    /**
     * 新增 项目依赖包
     * 
     * @param projectJar 项目依赖包对象
     * @return 项目依赖包
     * 
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public String insertProjectJar(final ProjectJarVO projectJar) {
        return (String) projectJarDAO.insert(projectJar);
    }
    
    /**
     * 更新 项目依赖包
     * 
     * @param projectJar 项目依赖包对象
     * @return 更新成功与否
     * 
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean updateProjectJar(final ProjectJarVO projectJar) {
        return projectJarDAO.update(projectJar);
    }
    
    /**
     * 更新 项目依赖包集合
     * 
     * @param projectJars 项目依赖包对象集合
     * @return 更新成功与否
     * 
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean updateProjectJarList(final List<ProjectJarVO> projectJars) {
        if (CollectionUtils.isEmpty(projectJars)) {
            return true;
        }
        int iCount = 0;
        for (ProjectJarVO objProjectJar : projectJars) {
            if (updateProjectJar(objProjectJar)) {
                iCount++;
            }
        }
        return iCount == projectJars.size();
    }
    
    /**
     * 删除 项目依赖包
     * 
     * @param projectJar 项目依赖包对象
     * 
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public void deleteProjectJar(final ProjectJarVO projectJar) {
        projectJarDAO.delete(projectJar);
    }
    
    /**
     * 删除 项目依赖包集合
     * 
     * @param projectJars 项目依赖包对象集合
     * 
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public void deleteProjectJarList(final List<ProjectJarVO> projectJars) {
        if (CollectionUtils.isEmpty(projectJars)) {
            return;
        }
        for (ProjectJarVO objProjectJar : projectJars) {
            this.deleteProjectJar(objProjectJar);
        }
    }
    
    /**
     * 删除 项目依赖包集合
     * 
     * @param projectId 项目Id
     * 
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public void deleteProjectJarByProjectId(final String projectId) {
        this.projectJarDAO.deleteProjectJarByProjectId(projectId);
    }
    
    /**
     * 通过项目依赖包ID查询项目依赖包对象
     * 
     * @param projectJarId 项目依赖包ID
     * @return 项目依赖包
     * 
     */
    public ProjectJarVO queryProjectJarById(final String projectJarId) {
        ProjectJarVO objParam = new ProjectJarVO();
        objParam.setId(projectJarId);
        return this.projectJarDAO.load(objParam);
    }
    
    /**
     * 通过项目ID查询项目依赖包对象
     * 
     * 
     * @param projectId 项目ID
     * @return 项目依赖包集合
     */
    public List<ProjectJarVO> queryProjectJarByProjectId(final String projectId) {
        return this.projectJarDAO.queryProjectJarByProjectId(projectId);
    }
}
