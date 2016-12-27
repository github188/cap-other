/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.hld.facade;

import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.entity.facade.EntityFacade;
import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cap.bm.metadata.entity.model.MethodVO;
import com.comtop.cap.doc.hld.model.EntityDTO;
import com.comtop.cap.doc.hld.model.PackageDTO;
import com.comtop.cap.doc.hld.model.ServiceDTO;
import com.comtop.cap.document.expression.annotation.DocumentService;
import com.comtop.cip.common.util.CAPCollectionUtils;
import com.comtop.cap.runtime.core.AppBeanUtil;

/**
 * 服务门面
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年12月30日 lizhiyong
 */
@DocumentService(name = "Service", dataType = ServiceDTO.class)
public class ServiceFacade extends ModelExportFacade<ServiceDTO> {
    
    /** 实体门面 */
    protected EntityFacade entityFacade = AppBeanUtil.getBean(EntityFacade.class);
    
    @Override
    public List<ServiceDTO> loadData(ServiceDTO condition) {
        bizObjectMap.clear();
        bizObjDataItemMap.clear();
        String packageId = condition.getPackageId();
        List<PackageDTO> apps = getAllAppPackage(packageId);
        if (apps == null || apps.size() == 0) {
            return null;
        }
        List<ServiceDTO> alRet = new ArrayList<ServiceDTO>();
        ServiceDTO serviceDTO = null;
        int sortIndex = 0;
        for (PackageDTO packageDTO : apps) {
            List<EntityVO> entities;
            try {
                entities = entityFacade.queryEntityList(packageDTO.getId());
                if (entities != null && entities.size() >= 0) {
                    for (EntityVO entity : entities) {
                        List<MethodVO> methods = entity.getMethods();
                        if (CAPCollectionUtils.isEmpty(methods)) {
                            continue;
                        }
                        for (MethodVO methodVO : methods) {
                            serviceDTO = vo2DTO(entity, methodVO, packageDTO.getId());
                            serviceDTO.setSortIndex(++sortIndex);
                            alRet.add(serviceDTO);
                        }
                    }
                }
            } catch (OperateException e) {
                LOGGER.error(MessageFormat.format("查询服务时发生异常。当前模块id={0}", packageId), e);
            }
        }
        return alRet;
    }
    
    /**
     * VO转DTO
     * 
     * @param entity 实体
     *
     * @param methodVO 方法
     * @param packageId 包id
     * @return 服务DTO
     */
    private ServiceDTO vo2DTO(EntityVO entity, MethodVO methodVO, String packageId) {
        ServiceDTO serviceDTO = new ServiceDTO();
        serviceDTO.setCnName(methodVO.getChName());
        serviceDTO.setName(methodVO.getEngName());
        serviceDTO.setDescription(methodVO.getDescription());
        serviceDTO.setCode(entity.getEngName() + "." + methodVO.getEngName());
        serviceDTO.setConstraint(methodVO.getConstraint());
        serviceDTO.setExpPerformance(methodVO.getExpPerformance());
        serviceDTO.setFeatures(methodVO.getFeatures());
        serviceDTO.setPrivateService(methodVO.isPrivateService());
        serviceDTO.setId(methodVO.getMethodId());
        serviceDTO.setNewData(false);
        serviceDTO.setRemark(methodVO.getDescription());
        
        List<String> entityIds = methodVO.queryParamEntityIds();
        
        Map<String, String> entityInputMap = new HashMap<String, String>();
        if (entityIds != null && entityIds.size() > 0) {
            for (String entityId : entityIds) {
                if (entityInputMap.get(entityId) != null) {
                    continue;
                }
                entityInputMap.put(entityId, entityId);
                EntityVO entityVO = entityFacade.loadEntity(entityId, packageId);
                if (entityVO != null) {
                    EntityDTO entityDTO = vo2DTO(entityVO);
                    serviceDTO.addEntityInputParam(entityDTO);
                }
            }
        }
        Map<String, String> entityOutputMap = new HashMap<String, String>();
        entityIds = methodVO.queryReturnEntityIds();
        if (entityIds != null && entityIds.size() > 0) {
            for (String entityId : entityIds) {
                if (entityOutputMap.get(entityId) != null) {
                    continue;
                }
                entityOutputMap.put(entityId, entityId);
                EntityVO entityVO = entityFacade.loadEntity(entityId, packageId);
                if (entityVO != null) {
                    EntityDTO entityDTO = vo2DTO(entityVO);
                    serviceDTO.addEntityOutputParam(entityDTO);
                }
            }
        }
        return serviceDTO;
    }
}
