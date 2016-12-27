/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.hld.facade;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.bm.biz.info.facade.BizObjDataItemFacade;
import com.comtop.cap.bm.biz.info.facade.BizObjInfoFacade;
import com.comtop.cap.bm.biz.info.model.BizObjDataItemVO;
import com.comtop.cap.bm.biz.info.model.BizObjInfoVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.BaseTableVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.ColumnVO;
import com.comtop.cap.bm.metadata.entity.model.EntityAttributeVO;
import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cap.doc.hld.model.EntityDTO;
import com.comtop.cap.doc.hld.model.EntityItemDTO;
import com.comtop.cap.doc.service.AbstractExportFacade;
import com.comtop.cap.document.word.docmodel.data.BaseDTO;
import com.comtop.cap.runtime.core.AppBeanUtil;

/**
 * 实体、属性相关的导出抽象类
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年12月30日 lizhiyong
 * @param <DTO> DTO
 */
abstract public class ModelExportFacade<DTO extends BaseDTO> extends AbstractExportFacade<DTO> {
    
    /** 没有属性的P元素字符串 */
    private static final String NULL_P_ELEMENT = "<p/>";
    
    /** 业务对象信息 */
    protected final BizObjInfoFacade bizObjInfoFacade = AppBeanUtil.getBean(BizObjInfoFacade.class);
    
    /** 业务对象数据项 */
    protected final BizObjDataItemFacade bizObjDataFacade = AppBeanUtil.getBean(BizObjDataItemFacade.class);
    
    /** 业务对象缓存 */
    protected final Map<String, BizObjInfoVO> bizObjectMap = new HashMap<String, BizObjInfoVO>();
    
    /** 业务对象数据项缓存 */
    protected final Map<String, BizObjDataItemVO> bizObjDataItemMap = new HashMap<String, BizObjDataItemVO>();
    
    /**
     * 获得业务对象
     *
     * @param bizObjId 业务对象id
     * @return 业务对象
     */
    protected BizObjInfoVO getBizObjectInfoVO(String bizObjId) {
        BizObjInfoVO bizObjInfoVO = bizObjectMap.get(bizObjId);
        if (bizObjInfoVO != null) {
            return bizObjInfoVO;
        }
        if (bizObjectMap.containsKey(bizObjId)) {
            return null;
        }
        bizObjInfoVO = bizObjInfoFacade.loadBizObjInfoById(bizObjId);
        bizObjectMap.put(bizObjId, bizObjInfoVO);
        return bizObjInfoVO;
    }
    
    /**
     * 获得业务对象
     *
     * @param bizObjDataId 业务对象id
     * @return 业务对象
     */
    protected BizObjDataItemVO getBizObjectDataItemVO(String bizObjDataId) {
        BizObjDataItemVO bizObjDataItemVO = bizObjDataItemMap.get(bizObjDataId);
        if (bizObjDataItemVO != null) {
            return bizObjDataItemVO;
        }
        if (bizObjDataItemMap.containsKey(bizObjDataId)) {
            return null;
        }
        bizObjDataItemVO = bizObjDataFacade.loadBizObjDataItemById(bizObjDataId);
        bizObjDataItemMap.put(bizObjDataId, bizObjDataItemVO);
        return bizObjDataItemVO;
    }
    
    /**
     * 实体VO转DTO
     *
     * @param entityVO 实体VO
     * @return 实体DTO
     */
    protected EntityDTO vo2DTO(EntityVO entityVO) {
        EntityDTO dto = new EntityDTO();
        dto.setCnName(entityVO.getChName());
        dto.setName(entityVO.getEngName());
        dto.setCode(entityVO.getEngName());
        dto.setDescription(entityVO.getDescription());
        dto.setId(entityVO.getModelId());
        dto.setNewData(false);
        List<String> bizObjectIds = entityVO.getBizObjectIds();
        if (bizObjectIds != null && bizObjectIds.size() > 0) {
            StringBuffer sb = new StringBuffer();
            BizObjInfoVO bizObjInfoVO = null;
            for (String bizObjId : bizObjectIds) {
                bizObjInfoVO = getBizObjectInfoVO(bizObjId);
                if (bizObjInfoVO != null) {
                    sb.append(bizObjInfoVO.getName()).append(NULL_P_ELEMENT);
                }
            }
            dto.setBizObjectNames(sb.toString());
        }
        dto.setRemark(entityVO.getDescription());
        BaseTableVO baseTableVO = entityVO.getObjBaseTableVO();
        if (baseTableVO != null) {
            dto.setTableComments(baseTableVO.getDescription());
            dto.setTableName(baseTableVO.getModelName());
            dto.setCnTableName(baseTableVO.getChName());
        }
        List<EntityAttributeVO> attributeVOs = entityVO.getAttributes();
        if (attributeVOs != null && attributeVOs.size() >= 0) {
            EntityItemDTO item = null;
            int sortIndex = 1;
            for (EntityAttributeVO entityAttributeVO : attributeVOs) {
                item = vo2DTO(entityVO, entityAttributeVO);
                item.setSortIndex(sortIndex++);
                dto.addEntityItem(item);
            }
        }
        
        return dto;
    }
    
    /**
     * 属性VO转DTO
     * 
     * @param entityVO 实体VO
     *
     * @param attributeVO 属性VO
     * @return 属性DTO
     */
    protected EntityItemDTO vo2DTO(EntityVO entityVO, EntityAttributeVO attributeVO) {
        EntityItemDTO dto = new EntityItemDTO();
        // 基本属性
        dto.setName(attributeVO.getEngName());
        dto.setCode(attributeVO.getEngName());
        dto.setCnName(attributeVO.getChName());
        dto.setDescription(attributeVO.getDescription());
        dto.setNewData(false);
        dto.setRemark(attributeVO.getDescription());
        // 实体属性
        dto.setEntityCnName(entityVO.getChName());
        dto.setEntityCode(entityVO.getEngName());
        dto.setEntityName(entityVO.getEngName());
        dto.setEntityId(entityVO.getModelId());
        
        // 业务对象
        List<String> bizObjectIds = entityVO.getBizObjectIds();
        if (bizObjectIds != null && bizObjectIds.size() > 0) {
            fillBizObjectAttributes(dto, bizObjectIds);
        }
        
        // 业务对象数据项
        List<String> bizDataItems = attributeVO.getDataItemIds();
        if (bizDataItems != null && bizDataItems.size() >= 0) {
            fillBizObjectItemsAttributes(dto, bizDataItems);
        }
        // 数据库表和列
        if (entityVO.getObjBaseTableVO() != null) {
            // 填充数据库相关的属性
            fillDBAttributes(entityVO, attributeVO, dto);
        }
        return dto;
    }
    
    /**
     * 填充业务对象相关属性
     *
     * @param dto 当前DTO
     * @param bizObjectIds 业务对象ID集
     */
    private void fillBizObjectAttributes(EntityItemDTO dto, List<String> bizObjectIds) {
        StringBuffer sb = new StringBuffer();
        BizObjInfoVO bizObjInfoVO = null;
        for (String bizObjId : bizObjectIds) {
            bizObjInfoVO = getBizObjectInfoVO(bizObjId);
            if (bizObjInfoVO != null) {
                sb.append(bizObjInfoVO.getName()).append(NULL_P_ELEMENT);
            }
        }
        dto.setBizObjects(sb.toString());
    }
    
    /**
     * 填充业务对象数据项相关属性
     *
     * @param dto 当前DTI
     * @param bizDataItems 业务对象数据项
     */
    private void fillBizObjectItemsAttributes(EntityItemDTO dto, List<String> bizDataItems) {
        BizObjDataItemVO dataItemVO = null;
        StringBuffer buffer = new StringBuffer();
        StringBuffer buffer2 = new StringBuffer();
        StringBuffer buffer3 = new StringBuffer();
        for (String itemId : bizDataItems) {
            dataItemVO = getBizObjectDataItemVO(itemId);
            if (dataItemVO == null) {
                continue;
            }
            buffer.append(dataItemVO.getName()).append(NULL_P_ELEMENT);
            if (StringUtils.isNotBlank(dataItemVO.getRemark())) {
                buffer2.append(dataItemVO.getRemark()).append(NULL_P_ELEMENT);
            }
            if (StringUtils.isNotBlank(dataItemVO.getCodeNote())) {
                buffer3.append(dataItemVO.getCodeNote()).append(NULL_P_ELEMENT);
            }
        }
        dto.setBizObjectDataItem(buffer.toString());
        dto.setQualityReq(buffer2.toString());
        dto.setCodeStandard(buffer3.toString());
    }
    
    /**
     * 填充数据库相关的属性
     *
     * @param entityVO 实体VO
     * @param attributeVO 属性VO
     * @param dto 当前DTO
     */
    private void fillDBAttributes(EntityVO entityVO, EntityAttributeVO attributeVO, EntityItemDTO dto) {
        ColumnVO columnVO = null;
        BaseTableVO tableVO = entityVO.getObjBaseTableVO();
        columnVO = tableVO.getColumnVOByColumnEngName(attributeVO.getDbFieldId());
        dto.setDbObjectCode(tableVO.getCode());
        dto.setDbObjectName(tableVO.getChName());
        dto.setDbObjectDescription(tableVO.getDescription());
        if (columnVO != null) {
            dto.setFieldName(columnVO.getChName());
            dto.setFieldDescription(columnVO.getDescription());
            dto.setFieldCode(columnVO.getCode());
            dto.setAllowNull(columnVO.getCanBeNull() ? "是" : "否");
            dto.setForeignKey(columnVO.getIsForeignKey() ? "是" : "否");
            dto.setMainDataItem(null);
            dto.setPrimaryKey(columnVO.getIsPrimaryKEY() ? "是" : "否");
            dto.setDataType(columnVO.getDataType());
        }
    }
    
}
