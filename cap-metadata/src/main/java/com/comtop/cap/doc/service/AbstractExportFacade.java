/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.sysmodel.facade.SysmodelFacade;
import com.comtop.cap.bm.metadata.sysmodel.model.CapPackageVO;
import com.comtop.cap.bm.metadata.sysmodel.utils.CapModuleConstants;
import com.comtop.cap.doc.DocServiceException;
import com.comtop.cap.doc.hld.model.PackageDTO;
import com.comtop.cap.document.word.dao.IWordDataAccessor;
import com.comtop.cap.document.word.docmodel.data.BaseDTO;
import com.comtop.cap.runtime.base.facade.BaseFacade;
import com.comtop.cap.runtime.core.AppBeanUtil;

/**
 * 抽象导出门面类
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年12月30日 lizhiyong
 * @param <DTO> DTO
 */
abstract public class AbstractExportFacade<DTO extends BaseDTO> extends BaseFacade implements IWordDataAccessor<DTO> {
    
    /**
     * 包比较器，用于包数据的内存排序
     *
     * @author lizhiyong
     * @since jdk1.6
     * @version 2016年1月27日 lizhiyong
     */
    private static final class PackageComparator implements Comparator<PackageDTO> {
        
        @Override
        public int compare(PackageDTO o1, PackageDTO o2) {
            return o1.getSortNo() - o2.getSortNo();
        }
    }
    
    /** 日志对象 */
    protected final Logger LOGGER = LoggerFactory.getLogger(getClass());
    
    /** 系统模块操作门面 */
    protected final SysmodelFacade sysmodelFacade = AppBeanUtil.getBean(SysmodelFacade.class);
    
    /** 比较器 */
    private final PackageComparator comparator = new PackageComparator();
    
    @Override
    public void saveData(List<DTO> collection) {
        // 导出操作 无须实现
    }
    
    /**
     * 根据id和属性名更新属性
     *
     * @param id 对象id
     * @param propertyName 属性名
     * @param value 值
     */
    @Override
    public void updatePropertyByID(String id, String propertyName, Object value) {
        throw new DocServiceException("不支持的操作");
    }
    
    /**
     * 组装包结构树
     * 
     * @param packageId 包id
     *
     * @return 根节点
     */
    protected PackageDTO fixPackageTree(String packageId) {
        List<PackageDTO> packages = getPackages(packageId);
        if (packages != null && packages.size() > 0) {
            Map<String, PackageDTO> packageMap = listToMap(packages);
            fixParent(packageId, packageMap, packages);
            return packageMap.get(packageId);
        }
        return null;
    }
    
    /**
     * 获得填充了上级的PackageDTO集合
     *
     * @param packageId 包id
     * @return PackageDTO集合 ，除了根节点，每个对象均设置了parent属性
     */
    public List<PackageDTO> getPackagesWithParent(String packageId) {
        List<PackageDTO> packages = getPackages(packageId);
        if (packages != null && packages.size() > 0) {
            Map<String, PackageDTO> packageMap = listToMap(packages);
            fixParent(packageId, packageMap, packages);
        }
        return packages;
    }
    
    /**
     * 获得填充了上级的PackageDTO集合
     *
     * @param packageId 包id
     * @return PackageDTO集合 ，除了根节点，每个对象均设置了parent属性
     */
    public List<PackageDTO> getPackagesWithNoRoot(String packageId) {
        List<PackageDTO> packages = getPackages(packageId);
        if (packages != null && packages.size() > 0) {
            Map<String, PackageDTO> packageMap = listToMap(packages);
            fixParent(packageId, packageMap, packages);
            PackageDTO root = packageMap.get(packageId);
            packages.remove(root);
        }
        return packages;
    }
    
    /**
     * 填充对象的上级
     * 
     * @param rootId 根id
     *
     * @param packageMap 对象Map
     * @param packages 包集
     */
    private void fixParent(String rootId, Map<String, PackageDTO> packageMap, List<PackageDTO> packages) {
        PackageDTO parent = null;
        for (PackageDTO tempPackage : packages) {
            String parentId = tempPackage.getParentId();
            parent = packageMap.get(parentId);
            if (parent != null) {
                parent.addChild(tempPackage);
            }
        }
        PackageDTO root = packageMap.get(rootId);
        List<PackageDTO> packageChilds = root.getChilds();
        sortPackages(packageChilds);
    }
    
    /**
     * 排序包
     *
     * @param packages 包
     */
    private void sortPackages(List<PackageDTO> packages) {
        if (packages != null && packages.size() > 0) {
            Collections.sort(packages, comparator);
            for (PackageDTO packageDTO : packages) {
                sortPackages(packageDTO.getChilds());
            }
        }
    }
    
    /**
     * list转Map
     *
     * @param packages 对象集
     * @return 对象Map
     */
    private Map<String, PackageDTO> listToMap(List<PackageDTO> packages) {
        Map<String, PackageDTO> packageMap = new HashMap<String, PackageDTO>();
        for (PackageDTO packageDTO : packages) {
            packageMap.put(packageDTO.getId(), packageDTO);
        }
        return packageMap;
    }
    
    /**
     * 获得包及其下级包
     * 
     * @param packageId 包id
     *
     * @return 根节点
     */
    protected List<PackageDTO> getPackages(String packageId) {
        List<CapPackageVO> packages = sysmodelFacade.querySubChildModuleByModuleId(packageId);
        // List<CapPackageVO> packages = testQuerySubChildModuleByModuleId(packageId);
        if (packages != null && packages.size() > 0) {
            PackageDTO packageDTO = null;
            List<PackageDTO> packageList = new ArrayList<PackageDTO>();
            for (CapPackageVO capPackageVO : packages) {
                packageDTO = vo2DTO(capPackageVO);
                packageList.add(packageDTO);
            }
            return packageList;
        }
        return null;
    }
    
    /**
     * 获得所有的应用对应的 Package
     * 
     * @param packageId 包id
     *
     * @return 根节点
     */
    protected List<PackageDTO> getAllAppPackage(String packageId) {
        List<CapPackageVO> packages = sysmodelFacade.querySubChildModuleByModuleId(packageId);
        // List<CapPackageVO> packages = testQuerySubChildModuleByModuleId(packageId);
        if (packages != null && packages.size() > 0) {
            PackageDTO packageDTO = null;
            List<PackageDTO> appPackageList = new ArrayList<PackageDTO>();
            for (CapPackageVO capPackageVO : packages) {
                if (capPackageVO.getModuleType() == CapModuleConstants.APPLICATION_MODULE_TYPE) {
                    packageDTO = vo2DTO(capPackageVO);
                    appPackageList.add(packageDTO);
                }
            }
            return appPackageList;
        }
        return null;
    }
    
    /**
     * VO 转DTO
     *
     * @param capPackageVO VO
     * @return DTO
     */
    private PackageDTO vo2DTO(CapPackageVO capPackageVO) {
        PackageDTO packageDTO = new PackageDTO();
        packageDTO.setId(capPackageVO.getModuleId());
        packageDTO.setParentId(capPackageVO.getParentModuleId());
        packageDTO.setName(capPackageVO.getModuleName());
        packageDTO.setNewData(false);
        packageDTO.setCode(capPackageVO.getModuleCode());
        packageDTO.setLstFunctionItem(capPackageVO.getLstFunctionItem());
        packageDTO.setDescription(capPackageVO.getModuleDescription());
        packageDTO.setRemark(capPackageVO.getFullPath());
        packageDTO.setType(capPackageVO.getModuleType());
        packageDTO.setSortNo(capPackageVO.getSortId());
        return packageDTO;
    }
    
    /**
     * 设置排序号
     * @param <T> BaseDTO
     *
     * @param datas 数据集
     */
    protected <T extends BaseDTO> void setSortIndex(List<T> datas) {
        if (datas != null && datas.size() > 0) {
            int sortIndex = 1;
            for (T t : datas) {
                t.setSortIndex(sortIndex++);
            }
        }
    }
    
    /**
     * 读取指定的包
     *
     * @param packageId 包id
     * @return 包id
     */
    protected PackageDTO readPackage(String packageId) {
        return vo2DTO(sysmodelFacade.readModuleVOById(packageId));
    }
    
    /**
     * 读取指定的包
     *
     * @return 包id
     */
    protected PackageDTO getRootPackage() {
        return vo2DTO(sysmodelFacade.readModuleRoot());
    }
    
    /**
     * 获得当前包的顶级包
     *
     * @param packageDTO 包
     * @return 顶级包
     */
    protected PackageDTO getRootPackage(PackageDTO packageDTO) {
        PackageDTO parent = packageDTO.getParent();
        while (parent != null) {
            if (parent.getParent() == null) {
                return parent;
            }
            parent = parent.getParent();
        }
        return null;
        
    }
}
