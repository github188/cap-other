/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.hld.facade;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.doc.hld.model.PackageDTO;
import com.comtop.cap.doc.service.AbstractExportFacade;
import com.comtop.cap.document.expression.annotation.DocumentService;
import com.comtop.cip.jodd.petite.meta.PetiteBean;

/**
 * 应用模块导出门面
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年12月30日 lizhiyong
 */
@PetiteBean
@DocumentService(name = "Package", dataType = PackageDTO.class)
public class PackageFacade extends AbstractExportFacade<PackageDTO> {
    
    @Override
    public List<PackageDTO> loadData(PackageDTO condition) {
        try {
            int type = condition.getType();
            String id = condition.getId();
            // 如果有id，则按id查询
            if (StringUtils.isNotBlank(id)) {
                return queryById(type, id);
            }
            
            String parentId = condition.getParentId();
            // 如果没有上级id，返回空
            if (StringUtils.isBlank(parentId)) {
                return null;
            }
            int cascadeQuery = condition.getCascadeQuery();
            // 如果不级联
            if (cascadeQuery == 0) {
                // 没有级联条件，则非级联查询
                return queryUnCascade(type, parentId);
            }
            
            // 以下都是需要级联查询的情况
            List<PackageDTO> packages = getPackagesWithNoRoot(parentId);
            if (packages == null || packages.size() == 0) {
                return null;
            }
            // 类型和类型层次都为空，返回所有数据
            int typeLevel = condition.getTypeLevel();
            if (type == 0 && typeLevel == 0) {
                setSortIndex(packages);
                return packages;
            }
            // 类型不为空，类型层次为空，返回所有子节点中类型匹配的数据
            if (type != 0 && typeLevel == 0) {
                return fixData(packages, type);
            }
            
            if (type == 0 && typeLevel != 0) {
                // 类型不为空但类型层次为空，无意义，直接返回。
                return null;
            }
            // 类型和类型层次都不为空
            return fixData(packages, type, typeLevel);
        } catch (Throwable e) {
            LOGGER.error("加载包时发生错误。当前条件=" + condition, e);
            return null;
        }
    }
    
    /**
     * 组装数据，按类型匹配
     *
     * @param packages 包集
     * @param type 类型
     * @return 数据集
     */
    private List<PackageDTO> fixData(List<PackageDTO> packages, int type) {
        int sortIndex = 1;
        List<PackageDTO> alRet = new ArrayList<PackageDTO>();
        for (PackageDTO packageDTO : packages) {
            if (packageDTO.getType() == type) {
                packageDTO.setSortIndex(sortIndex++);
                alRet.add(packageDTO);
            }
        }
        return alRet;
    }
    
    /**
     * 组装数据，按类型和类型层次匹配
     *
     * @param packages 包集
     * @param type 类型
     * @param typeLevel 类型层次
     * @return 数据集
     */
    private List<PackageDTO> fixData(List<PackageDTO> packages, int type, int typeLevel) {
        int sortIndex = 1;
        List<PackageDTO> alRet = new ArrayList<PackageDTO>();
        for (PackageDTO packageDTO : packages) {
            // 类型要匹配，类型层次要小于等于给定的值
            if (packageDTO.getType() == type && packageDTO.getTypeLevel() <= typeLevel) {
                packageDTO.setSortIndex(sortIndex++);
                alRet.add(packageDTO);
            }
        }
        return alRet;
    }
    
    /**
     * 按id查询
     *
     * @param type 类型
     * @param id id
     * @return 数据集
     */
    private List<PackageDTO> queryById(int type, String id) {
        PackageDTO packageDTO = readPackage(id);
        if (packageDTO == null) {
            return null;
        }
        
        if (type == 0 || packageDTO.getType() == type) {
            List<PackageDTO> alRet = new ArrayList<PackageDTO>();
            alRet.add(packageDTO);
            return alRet;
        }
        return null;
    }
    
    /**
     * 非级联查询
     *
     * @param type 类型
     * @param parentId 上级id
     * @return 数据集
     */
    private List<PackageDTO> queryUnCascade(int type, String parentId) {
        PackageDTO root = fixPackageTree(parentId);
        if (root == null) {
            // 如果没有根节点，直接返回
            return null;
        }
        List<PackageDTO> packages = root.getChilds();
        if (packages == null || packages.size() == 0) {
            return null;
        }
        // 如果没有类型约束,返回直接子级
        if (type == 0) {
            setSortIndex(packages);
            return packages;
        }
        return fixData(packages, type);
    }
}
