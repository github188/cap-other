/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.pkg.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cap.bm.metadata.pkg.model.PackageVO;
import com.comtop.cip.runtime.base.dao.BaseDAO;

/**
 * 包 数据访问接口类
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2014-3-17 李忠文
 */
@PetiteBean
public class PackageDAO extends BaseDAO<PackageVO> {
    
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
        Map<String, String> objParam = new HashMap<String, String>();
        objParam.put("parentPkgId", parentPkgId);
        objParam.put("packageId", packageId);
        objParam.put("name", name);
        return this.queryList("queryPackageInPackageByName", objParam);
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
        Map<String, String> objParam = new HashMap<String, String>();
        objParam.put("shortName", shortName);
        objParam.put("packageId", packageId);
        objParam.put("parentId", parentId);
        return this.queryList("queryPackageByShortName", objParam);
    }
    
    /**
     * 判断包全路径是否已存在
     *
     * @param packageVO 包全路径
     * @return 是否存在
     */
    public boolean isExistPackageFullPath(PackageVO packageVO) {
        int iNameCount = ((Integer) this.selectOne("com.comtop.cap.bm.metadata.pkg.model.isExistPackageFullPath",
            packageVO)).intValue();
        return (iNameCount > 0);
    }
    
    /**
     * 判断包全路径是否已存在
     *
     * @param packagePath 包全路径
     * @return 是否存在
     */
    public PackageVO queryPackageByFullPath(String packagePath) {
    	PackageVO objPackageVO = new PackageVO();
    	objPackageVO.setFullPath(packagePath);
        return (PackageVO)this.selectOne("com.comtop.cap.bm.metadata.pkg.model.queryPackageByFullPath",objPackageVO);
    }
    
	/**
	 * 根据包id删除包
	 * 
	 * @param pk
	 *            PackageVO
	 */
	public void deletePackageByPackageId(PackageVO pk) {
		this.delete("com.comtop.cap.bm.metadata.pkg.model.deletePackageByPackageId", pk);
	}
}
