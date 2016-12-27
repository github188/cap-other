/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.pkg.appservice;

import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cip.jodd.jtx.JtxPropagationBehavior;
import com.comtop.cip.jodd.jtx.meta.Transaction;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cip.jodd.util.StringUtil;
import com.comtop.cap.bm.metadata.base.model.IMetaNode;
import com.comtop.cap.bm.metadata.common.appservice.DirectoryAppService;
import com.comtop.cap.bm.metadata.common.model.DirectoryVO;
import com.comtop.cap.bm.metadata.common.model.NodeType;
import com.comtop.cap.bm.metadata.pkg.dao.ProjectDAO;
import com.comtop.cap.bm.metadata.pkg.model.PackageVO;
import com.comtop.cap.bm.metadata.pkg.model.ProjectJarVO;
import com.comtop.cap.bm.metadata.pkg.model.ProjectVO;
import com.comtop.cap.runtime.base.appservice.BaseAppService;
import com.comtop.cip.runtime.base.dao.DatasourceHandler;
import com.comtop.corm.resource.util.CollectionUtils;

/**
 * 项目 业务逻辑处理类
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2014-5-22 李忠文
 */
@PetiteBean(value = "cipProjectAppService")
public class ProjectAppService extends BaseAppService {
    
    /** 日志 */
    private static final Logger LOGGER = LoggerFactory.getLogger(ProjectAppService.class);
    
    /** 注入DAO **/
    @PetiteInject
    protected ProjectDAO projectDAO;
    
    /** 注入JarService **/
    @PetiteInject
    protected ProjectJarAppService jarService;
    
    /** 注入PackageAppService **/
    @PetiteInject
    protected PackageAppService pkgService;
    
    /** 导航数AppService */
    @PetiteInject
    protected DirectoryAppService dirService;
    
    /**
     * 新增 项目
     * 
     * @param project 项目对象
     * @param isSysnCenterDB 是否同步到中心数据库
     * @return 项目
     * 
     */
    public String insertProject(final ProjectVO project, final boolean isSysnCenterDB) {
        // 新增项目信息到本地
        String strId = this.insertProjectToLocalDB(project, true);
        if (!isSysnCenterDB) {
            return strId;
        }
        
        // 根据项目ID查询目录树导航
        List<? extends IMetaNode> lstDirectoryVOs = dirService.queryNodeByProjectId(strId, NodeType.PKG_NODE);
        DirectoryVO objDirectoryVO = null;
        PackageVO objPackageVO = null;
        List<PackageVO> lstPackageVOs = new ArrayList<PackageVO>();
        if (!CollectionUtils.isEmpty(lstDirectoryVOs)) {
            for (int i = 0; i < lstDirectoryVOs.size(); i++) {
                objDirectoryVO = (DirectoryVO) lstDirectoryVOs.get(i);
                if (NodeType.PKG_NODE.equals(objDirectoryVO.getNodeType())) {
                    objPackageVO = pkgService.queryPackageById(objDirectoryVO.getId());
                    objPackageVO.setParentId(objDirectoryVO.getParentNodeId());
                    lstPackageVOs.add(objPackageVO);
                }
            }
        }
        
        if (isSysnCenterDB) {
            // 同步新增项目
            try {
                DatasourceHandler.useCenterDB();
                if (StringUtil.isNotBlank(strId)) {
                    project.setId(strId);
                }
                this.insertProjectToCenterDB(project);
                this.insertPackagesToCenterDB(lstPackageVOs);
            } catch (Throwable e) {
                LOGGER.error("新增项目同步到中心数据库出错！", e);
            } finally {
                DatasourceHandler.useLocalDB();
            }
        }
        return strId;
    }
    
    /**
     * 新增项目信息到本地
     * 
     * @param project 项目信息
     * @param isCreateChlDir 是否创建子包
     * @return 新增项目ID
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public String insertProjectToLocalDB(final ProjectVO project, final boolean isCreateChlDir) {
        String strId = (String) this.projectDAO.insert(project);
        
        // 保存到项目包结构中
        pkgService.insertProject(project, false, isCreateChlDir);
        
        // 级联保存项目依赖的Jar
        List<ProjectJarVO> lstJars = project.getJars();
        if (CollectionUtils.isEmpty(project.getJars())) {
            return strId;
        }
        
        for (ProjectJarVO objJar : lstJars) {
            objJar.setProjectId(strId);
            this.jarService.insertProjectJar(objJar);
        }
        return strId;
    }
    
    /**
     * 同步新增项目
     * 
     * @param project 项目对象
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    private void insertProjectToCenterDB(final ProjectVO project) {
        this.deleteProject(project, false);
        String strId = (String) this.projectDAO.insert(project);
        
        pkgService.insertProject(project, false, false);
        
        if (CollectionUtils.isEmpty(project.getJars())) {
            return;
        }
        // 级联保存项目依赖的Jar
        List<ProjectJarVO> lstJars = project.getJars();
        for (ProjectJarVO objJar : lstJars) {
            objJar.setProjectId(strId);
            this.jarService.insertProjectJar(objJar);
        }
    }
    
    /**
     * 同步新增子包
     * 
     * @param packages 包集合
     */
    private void insertPackagesToCenterDB(final List<PackageVO> packages) {
        for (PackageVO objPackageVO : packages) {
            pkgService.insertPackageToCenterDB(objPackageVO, objPackageVO.getParentId());
        }
    }
    
    /**
     * 更新 项目
     * 
     * @param project 项目对象
     * @param isSysnCenterDB 是否同步更新到数据库
     * @return 更新成功与否
     * 
     */
    public boolean updateProject(final ProjectVO project, final boolean isSysnCenterDB) {
        // 更新本地项目信息
        boolean objUpdateSuc = this.updateProjectLocalDB(project);
        
        if (!isSysnCenterDB) {
            return objUpdateSuc;
        }
        
        // 同步更新到中心数据库
        try {
            DatasourceHandler.useCenterDB();
            this.updateProjectCenterDB(project);
        } catch (Throwable e) {
            LOGGER.error("更新项目同步到中心数据库出错！", e);
        } finally {
            DatasourceHandler.useLocalDB();
        }
        return objUpdateSuc;
    }
    
    /**
     * 更新本地项目信息
     * 
     * @param project 项目信息
     * @return 是否更新成功
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    private boolean updateProjectLocalDB(final ProjectVO project) {
        // 级联更新项目依赖的Jar
        this.jarService.deleteProjectJarByProjectId(project.getId());
        List<ProjectJarVO> lstJars = project.getJars();
        if (!CollectionUtils.isEmpty(project.getJars())) {
            for (ProjectJarVO objJar : lstJars) {
                objJar.setProjectId(project.getId());
                this.jarService.insertProjectJar(objJar);
            }
        }
        boolean objUpdateSuc = this.projectDAO.update(project);
        return objUpdateSuc;
    }
    
    /**
     * 更新项目同步中心数据库
     * 
     * @param project 项目对象
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    private void updateProjectCenterDB(final ProjectVO project) {
        // 级联更新项目依赖的Jar
        this.jarService.deleteProjectJarByProjectId(project.getId());
        List<ProjectJarVO> lstJars = project.getJars();
        for (ProjectJarVO objJar : lstJars) {
            objJar.setProjectId(project.getId());
            this.jarService.insertProjectJar(objJar);
        }
        this.projectDAO.update(project);
    }
    
    /**
     * 更新 项目集合
     * 
     * @param projects 项目对象集合
     * @return 更新成功与否
     * 
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean updateProjectList(final List<ProjectVO> projects) {
        if (CollectionUtils.isEmpty(projects)) {
            return true;
        }
        int iCount = 0;
        for (ProjectVO objProject : projects) {
            if (updateProject(objProject, true)) {
                iCount++;
            }
        }
        return iCount == projects.size();
    }
    
    /**
     * 删除 项目
     * 
     * @param project 项目对象
     * @param isSysnCenterDB 是否同步到中心数据库
     * 
     */
    public void deleteProject(final ProjectVO project, final boolean isSysnCenterDB) {
        // 删除本地项目
        this.deleteProjectWithLocalDB(project);
        
        if (!isSysnCenterDB) {
            return;
        }
        
        // 同步中心数据库删除项目
        try {
            DatasourceHandler.useCenterDB();
            this.deleteProjectWithCenterDB(project);
        } catch (Throwable e) {
            LOGGER.error("删除项目同步到中心数据库出错！", e);
        } finally {
            DatasourceHandler.useLocalDB();
        }
    }
    
    /**
     * 删除本地项目
     * 
     * @param project 项目对象
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    private void deleteProjectWithLocalDB(final ProjectVO project) {
        // 级联删除项目依赖的Jar
        this.jarService.deleteProjectJarByProjectId(project.getId());
        
        this.projectDAO.delete(project);
        
        // 删除项目包结构
        pkgService.deleteProject(project, false);
        
        // TODO 如果删除项目的时候，需要将项目中所有元数据都删除掉
    }
    
    /**
     * 删除项目同步中心数据库
     * 
     * @param project 项目对象
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    private void deleteProjectWithCenterDB(final ProjectVO project) {
        // 级联删除项目依赖的Jar
        this.jarService.deleteProjectJarByProjectId(project.getId());
        
        this.projectDAO.delete(project);
        
        // 删除项目包结构
        pkgService.deleteProject(project, false);
        
        // TODO 如果删除项目的时候，需要将项目中所有元数据都删除掉
    }
    
    /**
     * 删除 项目集合
     * 
     * @param projects 项目对象集合
     * @param isSysnCenterDB 是否同步到中心数据库
     * 
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public void deleteProjectList(final List<ProjectVO> projects, final boolean isSysnCenterDB) {
        if (CollectionUtils.isEmpty(projects)) {
            return;
        }
        for (ProjectVO objProject : projects) {
            this.deleteProject(objProject, isSysnCenterDB);
        }
    }
    
    /**
     * 通过项目ID查询项目对象
     * 
     * @param projectId 项目ID
     * @return 项目
     */
    public ProjectVO queryProjectById(final String projectId) {
        ProjectVO objParam = new ProjectVO();
        objParam.setId(projectId);
        ProjectVO objProject = this.projectDAO.load(objParam);
        // 级联查询所有Jar包
        if (null != objProject) {
            List<ProjectJarVO> lstJars = this.jarService.queryProjectJarByProjectId(projectId);
            objProject.setJars(lstJars);
        }
        return objProject;
    }
    
    /**
     * 通过用户ID查询该用户所在项目
     *
     * @param userId 用户ID
     * @return 项目集合
     */
    public List<ProjectVO> queryProjectsByUserId(String userId) {
        return projectDAO.queryProjectsByUserId(userId);
    }
}
