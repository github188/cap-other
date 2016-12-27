/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.hld.convert;

import java.util.List;

import com.comtop.cap.bm.metadata.entity.model.EntityAttributeVO;
import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cap.doc.hld.model.EntityItemDTO;

/**
 * dto vo转换器
 * 
 * @author 李小芬
 * @since 1.0
 * @version 2016-1-8 李小芬
 */
public class EntityItemConverter {
    
    /**
     * 构造函数
     */
    private EntityItemConverter() {
        //
    }
    
    /**
     * 转化为EntityItemDTO
     *
     * 
     * @param lstEntitys 实体对象
     * @param lstDto EntityItemDTO
     */
    public static void tableVOs2EntityItemDTOs(List<EntityVO> lstEntitys, List<EntityItemDTO> lstDto) {
        for (EntityVO vo : lstEntitys) {
            List<EntityAttributeVO> lstEntityAttribute = vo.getAttributes();
            for (EntityAttributeVO attributeVO : lstEntityAttribute) {
                EntityItemDTO dto = new EntityItemDTO();
                columnVO2EntityItemDTO(vo, attributeVO, dto);
                lstDto.add(dto);
            }
        }
    }
    
    /**
     * 转化为EntityItemDTO
     *
     * @param vo 实体信息
     * @param attributeVO 属性信息
     * @param dto dto
     */
    private static void columnVO2EntityItemDTO(EntityVO vo, EntityAttributeVO attributeVO, EntityItemDTO dto) {
        dto.setDbObjectCode(vo.getEngName());
        dto.setDbObjectName(vo.getChName());
        dto.setDbObjectDescription(vo.getDescription());
        dto.setFieldName(attributeVO.getChName());
        dto.setFieldCode(attributeVO.getEngName());
        dto.setFieldDescription(attributeVO.getDescription());
        // dto.setDataType(attributeVO.getAttributeType());
        dto.setAllowNull(attributeVO.isAllowNull() ? "Y" : "N");
        dto.setPrimaryKey(attributeVO.isPrimaryKey() ? "Y" : "N");
        // todo
        dto.setBizObjects("");
    }
}
