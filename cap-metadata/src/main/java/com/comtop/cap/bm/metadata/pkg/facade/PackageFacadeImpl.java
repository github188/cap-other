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
import com.comtop.cap.bm.metadata.pkg.appservice.PackageAppService;
import com.comtop.cap.bm.metadata.pkg.model.PackageVO;
import com.comtop.cap.runtime.base.facade.BaseFacade;

/**
 * 包 业务逻辑处理类 门面
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2014-3-17 李忠文
 */
@PetiteBean
public class PackageFacadeImpl extends BaseFacade implements IPackageFacade {
    
    /** 注入AppService **/
    @PetiteInject
    protected PackageAppService packageAppService;
    
    /**
     * 新增 包
     * 
     * @param pkg 包对象
     * @param parentNodeId 上级节点ID，如果为根节点，那么上级节点为null
     * @return 包
     * @see com.comtop.cap.bm.metadata.pkg.facade.IPackageFacade#
     *      insertPackage(com.comtop.cap.bm.metadata.pkg.model.PackageVO,java.lang.String)
     */
    @Override
    public String insertPackage(final PackageVO pkg, final String parentNodeId) {
        return packageAppService.insertPackage(pkg, parentNodeId, true);
    }
    
    // /**
    // * 新增模块
    // *
    // * @param module 模块
    // * @param parentNodeId 父节点ID
    // * @return 模块Id
    // *
    // * @see com.comtop.cap.bm.metadata.pkg.facade.IPackageFacade#
    // * insertModule(com.comtop.cap.bm.metadata.pkg.model.PackageVO,java.lang.String)
    // */
    // public String insertModule(final PackageVO module, final String parentNodeId) {
    // return packageAppService.insertModule(module, parentNodeId);
    // }
    
    /**
     * 更新 包
     * 
     * @param packages 包对象集合
     * @return 更新结果
     * 
     */
    @Override
    public boolean updatePackageList(final List<PackageVO> packages) {
        return packageAppService.updatePackageList(packages);
    }
    
    /**
     * 删除 包
     * 
     * @param packages 包对象集合
     */
    @Override
    public void deletePackageList(final List<PackageVO> packages) {
        packageAppService.deletePackageList(packages, true);
    }
    
    /**
     * 通过包ID查询包对象
     * 
     * @param packageId 包对象ID
     * @return 包
     * 
     */
    @Override
    public PackageVO queryPackageById(final String packageId) {
        return packageAppService.queryPackageById(packageId);
    }
    
    /**
     * 查询指定父包内名称重复的包
     * 
     * @param parentPkgId 父包ID
     * @param packageId 当前包Id
     * @param name 名称（中英文名称均可）
     * @return 指定父包内名称重复的包集合
     * @see com.comtop.cap.bm.metadata.pkg.facade.IPackageFacade#queryPackageInPackageByName(java.lang.String,
     *      java.lang.String, java.lang.String)
     */
    @Override
    public List<PackageVO> queryPackageInPackageByName(final String parentPkgId, final String packageId,
        final String name) {
        return packageAppService.queryPackageInPackageByName(parentPkgId, packageId, name);
    }
    
    /**
     * 根据包ID和包简称查询同级包下包名称是否存在并返回结果集
     * 
     * @param shortName 包简称
     * @param packageId 包ID
     * @param parentId 包父ID
     * @return PackageVO集合
     */
    @Override
    public List<PackageVO> queryPackageByShortName(final String shortName, final String packageId, final String parentId) {
        return packageAppService.queryPackageByShortName(shortName, packageId, parentId);
    }
    
    /**
     * 判断包全路径是否已存在
     *
     * @param packageVO 包全路径
     * @return 是否存在
     */
    @Override
    public boolean isExistPackageFullPath(PackageVO packageVO) {
        return packageAppService.isExistPackageFullPath(packageVO);
    }

	/**
	 * 根据包路径查包对象
	 * 
	 * @param packagePath
	 *            包路径
	 * @return 包对象
	 */
	@Override
	public PackageVO queryPackageByFullPath(String packagePath) {
		return packageAppService.queryPackageByFullPath(packagePath);
	}

	/**
	 * 根据包id删除包
	 * 
	 * @param packageVO
	 *            PackageVO
	 */
	@Override
	public void deletePackageByPackageId(PackageVO packageVO) {
		packageAppService.deletePackageByPackageId(packageVO);
	}
}
