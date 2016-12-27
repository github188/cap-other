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
import com.comtop.cap.bm.metadata.common.model.NodeType;
import com.comtop.cap.bm.metadata.pkg.dao.PackageDAO;
import com.comtop.cap.bm.metadata.pkg.model.PackageType;
import com.comtop.cap.bm.metadata.pkg.model.PackageVO;
import com.comtop.cap.bm.metadata.pkg.model.ProjectVO;
import com.comtop.cap.runtime.base.appservice.BaseAppService;
import com.comtop.cip.runtime.base.dao.DatasourceHandler;

/**
 * 包 业务逻辑处理类
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2014-3-17 李忠文
 */
@PetiteBean
public class PackageAppService extends BaseAppService {
    
    /** 日志 */
    private static final Logger LOGGER = LoggerFactory.getLogger(ProjectAppService.class);
    
    /** 包DAO **/
    @PetiteInject
    protected PackageDAO packageDAO;
    
    /** 目录导航树AppService */
    @PetiteInject
    protected DirectoryAppService directoryAppService;
    
    /**
     * 新增 包
     * 
     * @param pkg 包对象
     * @param parentNodeId 父节点ID
     * @param isSysnCenterDB 是否同步到中心数据库
     * @return 包Id
     * 
     */
    public String insertPackage(final PackageVO pkg, final String parentNodeId, final boolean isSysnCenterDB) {
        // 本地新增包信息
        String strPkgId = this.insertPackageToLocalDB(pkg, parentNodeId);
        if (!isSysnCenterDB) {
            return strPkgId;
        }
        
        // 同步新增包到中心数据库
        try {
            DatasourceHandler.useCenterDB();
            if (StringUtil.isNotBlank(strPkgId)) {
                pkg.setId(strPkgId);
            }
            this.insertPackageToCenterDB(pkg, parentNodeId);
        } catch (Throwable e) {
            LOGGER.error("新增包同步到中心数据库出错！", e);
        } finally {
            DatasourceHandler.useLocalDB();
        }
        return strPkgId;
    }
    
    /**
     * 本地新增包
     * 
     * @param pkg 包信息
     * @param parentNodeId 父节点ID
     * @return 新增包ID
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    private String insertPackageToLocalDB(final PackageVO pkg, final String parentNodeId) {
        String strPkgId = (String) packageDAO.insert(pkg);
        directoryAppService.insertNode(pkg, parentNodeId);
        return strPkgId;
    }
    
    /**
     * 同步新增包
     * 
     * @param pkg 包对象
     * @param parentNodeId 父节点ID
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public void insertPackageToCenterDB(final PackageVO pkg, final String parentNodeId) {
        List<PackageVO> lstPackageVOs = new ArrayList<PackageVO>();
        lstPackageVOs.add(pkg);
        // 如果是同步中心库的操作先执行删除操作，再新增同步数据
        packageDAO.delete(pkg);
        packageDAO.insert(pkg);
        directoryAppService.insertNode(pkg, parentNodeId);
    }
    
    /**
     * 根据包的类型及相关数据生成节点类型
     * 
     * @param pkg 包VO
     * @param parentNodeId 上级节点Id
     * @return 节点类型
     */
    @Deprecated
    public String convert(final PackageVO pkg, final String parentNodeId) {
        int iPkgType = pkg.getPackageType();
        String strNodeType;
        switch (iPkgType) {
            case PackageType.PROJECT_PKG:
                strNodeType = NodeType.PROJECT_NODE;
                break;
            // case PackageType.MODULE_PKG:
            // strNodeType = NodeType.MODULE_NODE;
            // break;
            case PackageType.COMM_PKG:
                strNodeType = getNodeTypeByParentNode(pkg, parentNodeId);
                break;
            default:
                strNodeType = NodeType.PKG_NODE;
                break;
        }
        return strNodeType;
    }
    
    /**
     * 通过上级节点获取
     * 
     * @param pkg 包VO
     * @param parentNodeId 上级节点Id
     * @return 节点类型
     */
    @Deprecated
    public String getNodeTypeByParentNode(final PackageVO pkg, final String parentNodeId) {
        if (StringUtil.isBlank(parentNodeId)) {
            return NodeType.PKG_NODE;
        }
        IMetaNode objNode = directoryAppService.queryNodeById(parentNodeId);
        if (NodeType.MODULE_NODE.equals(objNode.getNodeType())) {
            return pkg.getShortName() + "Package";
        }
        return NodeType.PKG_NODE;
    }
    
    // /**
    // * 新增模块
    // *
    // *
    // * @param module 模块对象
    // * @param parentNodeId 父节点ID
    // * @return 模块Id
    // */
    // @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    // public String insertModule(final PackageVO module, final String parentNodeId) {
    // module.setPackageType(PackageType.MODULE_PKG);
    // String strModulePath = module.getFullPath();
    // String strModuleId = this.insertPackage(module, parentNodeId);
    // // 创建模块下默认的子包
    // String[] strSubTypes = new String[] { NodeType.UML_NODE, NodeType.ENTITY_NODE,
    // NodeType.REL_NODE, NodeType.VO_NODE, NodeType.TABLE_NODE, NodeType.QUERY_NODE };
    // String[] strSubNames = new String[] { "模型包", "实体包", "关系包", "值对象包", "数据表包", "查询包" };
    // String strSubType;
    // String strSubName;
    // for (int iIndex = 0; iIndex < strSubTypes.length; iIndex++) {
    // strSubType = strSubTypes[iIndex];
    // strSubName = strSubNames[iIndex];
    // insertSubPackage(strModuleId, strModulePath, strSubType, strSubName);
    // }
    // return strModuleId;
    // }
    
    /**
     * 新增项目
     * 
     * @param project 项目VO
     * @param isSysnCenterDB 是否同步到中心数据库
     * @param isCreateChlDir 是否创建子包
     * @return 项目ID
     */
    public String insertProject(ProjectVO project, final boolean isSysnCenterDB, final boolean isCreateChlDir) {
        // 创建项目包
        PackageVO objProjectPkg = new PackageVO();
        if (StringUtil.isNotBlank(project.getId())) {
            objProjectPkg.setId(project.getId());
        }
        objProjectPkg.setShortName(project.getShortName());
        objProjectPkg.setEnglishName(project.getName());
        objProjectPkg.setChineseName(project.getChineseName());
        objProjectPkg.setFullPath(project.getShortName());
        objProjectPkg.setPackageType(PackageType.PROJECT_PKG);
        objProjectPkg.setDescription(project.getChineseName());
        
        String strProjectId = this.insertPackage(objProjectPkg, null, isSysnCenterDB);
        
        if (!isCreateChlDir) {
            return strProjectId;
        }
        
        // 创建项目下面的子包
        String strPkgPath = project.getPackagePath();
        String[] strPathParts = strPkgPath.split("\\.");
        String strFullPathPart = "";
        PackageVO objPkg;
        String strParentNodeId = strProjectId;
        for (String strPathPart : strPathParts) {
            objPkg = new PackageVO();
            if (StringUtil.isNotBlank(strFullPathPart)) {
                strFullPathPart += ".";
            }
            strFullPathPart += strPathPart;
            // objPkg.setShortName(strPathPart);
            objPkg.setEnglishName(strPathPart);
            objPkg.setChineseName(strPathPart);
            objPkg.setFullPath(strFullPathPart);
            objPkg.setPackageType(PackageType.COMM_PKG);
            objPkg.setDescription(strPathPart);
            strParentNodeId = insertPackage(objPkg, strParentNodeId, isSysnCenterDB);
        }
        return strProjectId;
    }
    
    /**
     * 删除项目
     * 
     * @param project 项目VO
     * @param isSysnCenterDB 是否同步到中心数据库
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public void deleteProject(ProjectVO project, final boolean isSysnCenterDB) {
        List<PackageVO> lstPackages = new ArrayList<PackageVO>();
        PackageVO objPackageVO = this.queryPackageById(project.getId());
        if (objPackageVO != null) {
            lstPackages.add(objPackageVO);
            this.deletePackageList(lstPackages, isSysnCenterDB);
        }
    }
    
    // /**
    // * 新增模块下子包
    // *
    // * @param moduleId 模块Id
    // * @param modulePath 模块路径
    // * @param subType 子包类型
    // * @param subName 子包名称
    // */
    // private void insertSubPackage(String moduleId, String modulePath, String subType, String subName) {
    // PackageVO objPkg = new PackageVO();
    // objPkg.setChineseName(subName);
    // objPkg.setEnglishName(subType);
    // objPkg.setFullPath(modulePath + "." + subType);
    // objPkg.setShortName(subType);
    // objPkg.setDescription(subName + "，由CIP自动生成此包。");
    // objPkg.setPackageType(PackageType.COMM_PKG);
    // this.insertPackage(objPkg, moduleId);
    // }
    
    /**
     * 更新 包
     * 
     * @param packages 包对象集合
     * @return 更新成功与否
     * 
     */
    public boolean updatePackageList(final List<PackageVO> packages) {
        if (packages == null) {
            return true;
        }
        
        // 本地更新包集合
        boolean objIsUpdateSuc = this.updatePackageListToLocalDB(packages);
        
        // 同步更新到中心数据库
        try {
            DatasourceHandler.useCenterDB();
            this.updatePackageListToCenterDB(packages);
        } catch (Throwable e) {
            LOGGER.error("更新包同步到中心数据库出错！", e);
        } finally {
            DatasourceHandler.useLocalDB();
        }
        return objIsUpdateSuc;
    }
    
    /**
     * 本地更新包集合
     * 
     * @param packages 包对象集合
     * @return 是否更新成功
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    private boolean updatePackageListToLocalDB(final List<PackageVO> packages) {
        directoryAppService.updateNodeList(packages);
        return packageDAO.update(packages) == packages.size();
    }
    
    /**
     * 同步更新包到中心数据库
     * 
     * @param packages 包对象集合
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    private void updatePackageListToCenterDB(final List<PackageVO> packages) {
        directoryAppService.updateNodeList(packages);
        packageDAO.update(packages);
    }
    
    /**
     * 删除 包
     * 
     * @param packages 包对象集合
     * @param isSysnCenterDB 是否同步到中心数据库
     * 
     */
    public void deletePackageList(final List<PackageVO> packages, final boolean isSysnCenterDB) {
        if (packages == null) {
            return;
        }
        
        // 本地删除包集合
        this.deletePackageListWithLocalDB(packages);
        
        if (!isSysnCenterDB) {
            return;
        }
        
        // 同步删除中心数据库包
        try {
            DatasourceHandler.useCenterDB();
            this.deletePackageListWithCenterDB(packages);
        } catch (Throwable e) {
            LOGGER.error("删除包同步到中心数据库出错！", e);
        } finally {
            DatasourceHandler.useLocalDB();
        }
    }
    
    /**
     * 本地删除包集合
     * 
     * @param packages 包对象集合
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    private void deletePackageListWithLocalDB(final List<PackageVO> packages) {
        directoryAppService.deleteNodeList(packages);
        packageDAO.delete(packages);
    }
    
    /**
     * 同步删除包
     * 
     * @param packages 包对象集合
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    private void deletePackageListWithCenterDB(final List<PackageVO> packages) {
        directoryAppService.deleteNodeList(packages);
        packageDAO.delete(packages);
    }
    
    /**
     * 通过包ID查询包对象
     * 
     * @param packageId 包ID
     * @return 包
     */
    public PackageVO queryPackageById(final String packageId) {
        PackageVO objParam = new PackageVO();
        objParam.setId(packageId);
        return packageDAO.load(objParam);
    }
    
    /**
     * 查询指定父包内名称重复的包
     * 
     * @param parentPkgId 父包ID
     * @param packageId 当前包Id
     * @param name 名称（中英文名称均可）
     * @return 指定父包内名称重复的包集合
     */
    public List<PackageVO> queryPackageInPackageByName(final String parentPkgId, final String packageId,
        final String name) {
        return packageDAO.queryPackageInPackageByName(parentPkgId, packageId, name);
    }
    
    /**
     * 根据包ID和包简称查询同级包下包名称是否存在并返回结果集
     * 
     * @param shortName 包简称
     * @param packageId 包ID
     * @param parentId 包父ID
     * @return PackageVO集合
     */
    public List<PackageVO> queryPackageByShortName(final String shortName, final String packageId, final String parentId) {
        return packageDAO.queryPackageByShortName(shortName, packageId, parentId);
    }
    
    /**
     * 判断包全路径是否已存在
     *
     * @param packageVO 包全路径
     * @return 是否存在
     */
    public boolean isExistPackageFullPath(PackageVO packageVO) {
        return packageDAO.isExistPackageFullPath(packageVO);
    }
    
	/**
	 * @param packagePath
	 *            包路径
	 * @return 包对象
	 */
	public PackageVO queryPackageByFullPath(String packagePath) {
		return packageDAO.queryPackageByFullPath(packagePath);
	}
	
	/**
	 * 根据包id删除包
	 * 
	 * @param pk
	 *            PackageVO
	 */
	public void deletePackageByPackageId(PackageVO pk) {
		packageDAO.deletePackageByPackageId(pk);
	}
}
