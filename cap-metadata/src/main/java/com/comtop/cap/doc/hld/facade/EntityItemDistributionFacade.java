/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.hld.facade;

import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.List;

import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.entity.facade.EntityFacade;
import com.comtop.cap.bm.metadata.entity.model.EntityAttributeVO;
import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cap.doc.hld.model.EntityItemDistributionDTO;
import com.comtop.cap.doc.hld.model.PackageDTO;
import com.comtop.cap.doc.service.AbstractExportFacade;
import com.comtop.cap.document.expression.annotation.DocumentService;
import com.comtop.cip.common.util.CAPCollectionUtils;
import com.comtop.cap.runtime.core.AppBeanUtil;

/**
 * FIXME 类注释信息
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年12月30日 lizhiyong
 */
@DocumentService(name = "EntityItemDistribution", dataType = EntityItemDistributionDTO.class)
public class EntityItemDistributionFacade extends AbstractExportFacade<EntityItemDistributionDTO> {
    
    /** 包导出服务 */
    protected PackageFacade packageFacade = AppBeanUtil.getBean(PackageFacade.class);
    
    /** 包导出服务 */
    protected EntityFacade entityFacade = AppBeanUtil.getBean(EntityFacade.class);
    
    @Override
    public List<EntityItemDistributionDTO> loadData(EntityItemDistributionDTO condition) {
        
        String packageId = condition.getPackageId();
        List<PackageDTO> apps = getAllAppPackage(packageId);
        if (apps == null || apps.size() == 0) {
            return null;
        }
        List<EntityItemDistributionDTO> alRet = new ArrayList<EntityItemDistributionDTO>();
        PackageDTO root = readPackage(packageId);
        int sortIndex = 1;
        for (PackageDTO packageDTO : apps) {
            try {
                List<EntityVO> lstEntitys = entityFacade.queryEntityList(packageDTO.getId());
                for (EntityVO vo : lstEntitys) {
                    List<EntityAttributeVO> attributes = vo.getAttributes();
                    if (CAPCollectionUtils.isEmpty(attributes)) {
                        continue;
                    }
                    for (EntityAttributeVO entityAttributeVO : attributes) {
                        EntityItemDistributionDTO distributionDTO = new EntityItemDistributionDTO();
                        distributionDTO.setEntityCode(vo.getEngName());
                        distributionDTO.setEntityName(vo.getEngName());
                        distributionDTO.setEntityId(vo.getModelId());
                        distributionDTO.setEntityCnName(vo.getChName());
                        distributionDTO.setName(entityAttributeVO.getEngName());
                        distributionDTO.setCode(entityAttributeVO.getEngName());
                        distributionDTO.setId(entityAttributeVO.getEngName());
                        distributionDTO.setCnName(entityAttributeVO.getChName());
                        distributionDTO.setModuleId(packageDTO.getId());
                        distributionDTO.setModuleName(packageDTO.getName());
                        distributionDTO.setModuleCode(packageDTO.getName());
                        distributionDTO.setSystemCode(root.getCode());
                        distributionDTO.setSystemId(root.getId());
                        distributionDTO.setSystemName(root.getName());
                        distributionDTO.setSortIndex(sortIndex++);
                        alRet.add(distributionDTO);
                    }
                }
            } catch (OperateException e) {
                LOGGER.error(MessageFormat.format("查询实体时发生异常。当前模块id={0}", packageId), e);
            }
            
            // PackageDTO rootPack = getRootPackage(packageDTO);
            // distributionDTO.setFirstLevelModuleName(rootPack.getName());
            // distributionDTO.setFirstLevelModuleId(rootPack.getId());
            // distributionDTO.setFirstLevelModuleCode(rootPack.getCode());
        }
        
        // PackageDTO pCondition = new PackageDTO();
        // pCondition.setCascadeQuery(1);
        // condition.setPackageId(packageId);
        // pCondition.setType(CapModuleConstants.CATALOG_MODULE_TYPE);
        // pCondition.setTypeLevel(2);
        // List<PackageDTO> modules = packageFacade.loadData(pCondition);
        // for (EntityDistributionDTO distribute : alRet) {
        // Map<String, String> distributionMap = new HashMap<String, String>();
        // for (PackageDTO packageDTO : modules) {
        // distributionMap.put(packageDTO.getId(), "*");
        // }
        // distribute.setDistributionMap(distributionMap);
        // }
        return alRet;
        
    }
}
