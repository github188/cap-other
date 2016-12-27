/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.pkg.facade;

import java.util.List;

import com.comtop.cap.bm.metadata.pkg.model.PackageVO;

/**
 * 包 业务逻辑处理类接口
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2014-3-17 李忠文
 */
public interface IPackageFacade extends IPackageQueryFacade {

	/**
	 * 新增 包
	 * 
	 * @param pkg
	 *            包对象
	 * @param parentNodeId
	 *            上级节点ID，如果为根节点，那么上级节点为null
	 * @return 包Id
	 */
	String insertPackage(final PackageVO pkg, final String parentNodeId);

	// /**
	// * 新增模块
	// *
	// * @param module 模块
	// * @param parentNodeId 父节点ID
	// * @return 模块Id
	// */
	// String insertModule(final PackageVO module, final String parentNodeId);
	//

	/**
	 * 更新 包
	 * 
	 * @param packages
	 *            包对象集合
	 * @return 更新结果
	 * 
	 */
	boolean updatePackageList(final List<PackageVO> packages);

	/**
	 * 删除 包
	 * 
	 * @param packages
	 *            包对象集合
	 * 
	 */
	void deletePackageList(final List<PackageVO> packages);

	/**
	 * 查询指定父包内名称重复的包
	 * 
	 * @param parentPkgId
	 *            父包ID
	 * @param packageId
	 *            当前包Id
	 * @param name
	 *            名称（中英文名称均可）
	 * @return 指定父包内名称重复的包集合
	 */
	List<PackageVO> queryPackageInPackageByName(final String parentPkgId,
			final String packageId, final String name);

	/**
	 * 根据包ID和包简称查询同级包下包名称是否存在并返回结果集
	 * 
	 * @param shortName
	 *            包简称
	 * @param packageId
	 *            包ID
	 * @param parentId
	 *            包父ID
	 * @return PackageVO集合
	 */
	List<PackageVO> queryPackageByShortName(final String shortName,
			final String packageId, final String parentId);

	/**
	 * 判断包全路径是否已存在
	 *
	 * @param packageVO
	 *            包全路径
	 * @return 是否存在
	 */
	boolean isExistPackageFullPath(PackageVO packageVO);

	/**
	 * 根据包id删除packageVO
	 * 
	 * @param packageVO
	 *            包VO
	 */
	void deletePackageByPackageId(PackageVO packageVO);
}
