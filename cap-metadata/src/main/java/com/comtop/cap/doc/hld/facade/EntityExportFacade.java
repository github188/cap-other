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
import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cap.doc.hld.model.EntityDTO;
import com.comtop.cap.doc.hld.model.PackageDTO;
import com.comtop.cap.document.expression.annotation.DocumentService;
import com.comtop.top.core.jodd.AppContext;

/**
 * 实体导出服务
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2016年1月5日 lizhiyong
 */
@DocumentService(name = "Entity", dataType = EntityDTO.class)
public class EntityExportFacade extends ModelExportFacade<EntityDTO> {
    
    /** 实体facade类 */
    protected EntityFacade entityFacade = AppContext.getBean(EntityFacade.class);
    
    @Override
    public List<EntityDTO> loadData(EntityDTO condition) {
        String packageId = condition.getPackageId();
        List<PackageDTO> alApps = getAllAppPackage(packageId);
        if (alApps == null || alApps.size() == 0) {
            return null;
        }
        // 查询节点下的所有实体及实体对应的业务对象
        List<EntityDTO> lstDto = new ArrayList<EntityDTO>();
        try {
            int sortIndex = 0;
            for (PackageDTO app : alApps) {
                List<EntityVO> lstEntitys = entityFacade.queryEntityList(app.getId());
                for (EntityVO vo : lstEntitys) {
                    EntityDTO dto = vo2DTO(vo);
                    dto.setSortIndex(++sortIndex);
                    lstDto.add(dto);
                }
            }
        } catch (OperateException e) {
            LOGGER.error(MessageFormat.format("查询实体时发生异常。当前模块id={0}", packageId), e);
        }
        return lstDto;
    }
    
}
