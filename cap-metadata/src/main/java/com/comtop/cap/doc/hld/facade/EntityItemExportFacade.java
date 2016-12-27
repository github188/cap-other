/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
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
import com.comtop.cap.doc.hld.model.EntityItemDTO;
import com.comtop.cap.doc.hld.model.PackageDTO;
import com.comtop.cap.document.expression.annotation.DocumentService;
import com.comtop.cip.common.util.CAPCollectionUtils;
import com.comtop.top.core.jodd.AppContext;

/**
 * FIXME 类注释信息
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2016年1月5日 lizhiyong
 */
@DocumentService(name = "EntityItem", dataType = EntityItemDTO.class)
public class EntityItemExportFacade extends ModelExportFacade<EntityItemDTO> {
    
    /** 表facade类 */
    EntityFacade entityFacade = AppContext.getBean(EntityFacade.class);
    
    @Override
    public List<EntityItemDTO> loadData(EntityItemDTO condition) {
        String nodeId = condition.getPackageId();
        List<EntityItemDTO> lstDto = new ArrayList<EntityItemDTO>();
        List<PackageDTO> lstPackage = this.getAllAppPackage(nodeId);
        if (lstPackage == null || lstPackage.size() == 0) {
            return null;
        }
        try {
            int i = 0;
            for (PackageDTO packageDTO : lstPackage) {
                List<EntityVO> lstEntitys = entityFacade.queryEntityList(packageDTO.getId());
                for (EntityVO entityVO : lstEntitys) {
                    List<EntityAttributeVO> lstEntityAttribute = entityVO.getAttributes();
                    if (CAPCollectionUtils.isEmpty(lstEntityAttribute)) {
                        continue;
                    }
                    for (EntityAttributeVO entityAttributeVO : lstEntityAttribute) {
                        EntityItemDTO dto = this.vo2DTO(entityVO, entityAttributeVO);
                        dto.setSortIndex(++i);
                        lstDto.add(dto);
                    }
                }
            }
        } catch (OperateException e) {
            LOGGER.error(MessageFormat.format("查询实体数据项时发生异常。当前模块id={0}", nodeId), e);
        }
        return lstDto;
    }
}
