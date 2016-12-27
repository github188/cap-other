/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.biz.appservice;

import java.util.List;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.base.MDBaseAppservice;
import com.comtop.cap.bm.biz.info.appservice.BizObjDataItemAppService;
import com.comtop.cap.bm.biz.info.dao.BizObjDataItemDAO;
import com.comtop.cap.bm.biz.info.model.BizObjDataItemVO;
import com.comtop.cap.doc.biz.convert.BizObjectDataItemConverter;
import com.comtop.cap.doc.biz.model.BizObjectDTO;
import com.comtop.cap.doc.biz.model.BizObjectDataItemDTO;
import com.comtop.cap.doc.service.BizAbstractWordDataAccessor;
import com.comtop.cap.doc.service.IndexBuilder;
import com.comtop.cap.doc.util.DocDataUtil;
import com.comtop.cap.runtime.component.facade.AutoGenNumberFacade;
import com.comtop.cip.common.constant.CapNumberConstant;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.core.AppBeanUtil;

/**
 * 业务对象数据项文档操作门面
 * 
 * @author 李志勇
 * @since 1.0
 * @version 2015-11-10 李志勇
 */
@PetiteBean
@IndexBuilder(dto = BizObjectDataItemDTO.class)
public class BizObjDataItemDocAppservice extends BizAbstractWordDataAccessor<BizObjDataItemVO, BizObjectDataItemDTO> {
    
    /** 注入AppService **/
    @PetiteInject
    protected BizObjDataItemAppService bizObjDataItemAppService;
    
    /** 注入AppService **/
    @PetiteInject
    protected BizObjInfoDocAppservice bizObjInfoDocAppservice;
    
    /** 注入业务对象数据项DAO **/
    @PetiteInject
    protected BizObjDataItemDAO bizObjDataItemDAO;
    
    @Override
    protected MDBaseAppservice<BizObjDataItemVO> getBaseAppservice() {
        return bizObjDataItemAppService;
    }
    
    @Override
    protected void saveBizData(List<BizObjectDataItemDTO> dataItems) {
        if (dataItems != null && dataItems.size() > 0) {
            for (BizObjectDataItemDTO dataItem : dataItems) {
                saveData(dataItem);
            }
        }
    }
    
    @Override
    protected void fillRelationObjectIds(BizObjectDataItemDTO dataItem) {
        if (dataItem.isNewData()) {
            if (StringUtils.isNotBlank(dataItem.getObjectName())) {
                BizObjectDTO bizObjectDTO = BizObjectDataItemConverter.convert2BizObject(dataItem, null);
                String objectId = bizObjInfoDocAppservice.findIdFromRelation(bizObjectDTO);
                dataItem.setObjectId(objectId);
            } else {
                //
            }
        }
    }
    
    @Override
    public List<BizObjectDataItemDTO> loadData(BizObjectDataItemDTO condition) {
        List<BizObjectDataItemDTO> dataItems = queryDTOList(condition);
        int iSortIndex = CapNumberConstant.NUMBER_INT_ZERO;
        for (BizObjectDataItemDTO dataItemDTO : dataItems) {
            dataItemDTO.setNewData(false);
            dataItemDTO.setSortIndex(++iSortIndex);
        }
        return dataItems;
    }
    
    @Override
    protected BizObjDataItemVO dto2VO(BizObjectDataItemDTO data) {
        BizObjDataItemVO bizObjDataItemVO = DocDataUtil.dto2VO(data, BizObjDataItemVO.class);
        bizObjDataItemVO.setBizObjId(data.getObjectId());
        return bizObjDataItemVO;
    }
    
    @Override
    protected BizObjectDataItemDTO vo2DTO(BizObjDataItemVO vo) {
        BizObjectDataItemDTO bizObjectDataItemDTO = DocDataUtil.vo2DTO(vo, BizObjectDataItemDTO.class);
        bizObjectDataItemDTO.setObjectId(vo.getBizObjId());
        return bizObjectDataItemDTO;
    }
    
    @Override
    public String saveNewData(BizObjectDataItemDTO newData) {
        if (StringUtils.isBlank(newData.getCode())) {
            newData.setCode(generateCode(BizObjDataItemVO.getCodeExpr(), null));
        }
        newData.setSortNo(generateSortNo("BizObjectDataItem-SortNo"));
        BizObjDataItemVO vo = dto2VO(newData);
        String id = this.bizObjDataItemAppService.save(vo);
        newData.setId(id);
        return id;
    }
    
    /**
     * 获得 DTO uri
     *
     * @param data dto
     * @return uri
     */
    @Override
    protected String getUri(BizObjectDataItemDTO data) {
        return data.getObjectId() + "-" + StringUtils.trim(data.getName());
    }
    
    /**
     * 更新编码和序号
     *
     */
    public void updateCodeAndSortNo() {
        List<BizObjDataItemVO> alData = bizObjDataItemAppService.loadBizObjDataItemNotExistCodeOrSortNo();
        AutoGenNumberFacade autoGenNumberService = AppBeanUtil.getBean(AutoGenNumberFacade.class);
        for (BizObjDataItemVO data : alData) {
            if (StringUtils.isBlank(data.getCode())) {
                String code = autoGenNumberService.genNumber(BizObjDataItemVO.getCodeExpr(), null);
                bizObjDataItemAppService.updatePropertyById(data.getId(), "code", code);
            }
            
            if (data.getSortNo() == null) {
                String sortNoExpr = DocDataUtil.getSortNoExpr("BizObjectDataItem-SortNo", data.getBizObjId());
                String code = autoGenNumberService.genNumber(sortNoExpr, null);
                bizObjDataItemAppService.updatePropertyById(data.getId(), "sortNo", code);
            }
        }
    }
    
    /**
     * 查询DTO数据集
     *
     * @param condition 条件
     * @return DTO数据集
     */
    @Override
    public List<BizObjectDataItemDTO> queryDTOList(BizObjectDataItemDTO condition) {
        return bizObjDataItemDAO.queryList("com.comtop.cap.bm.biz.info.model.queryBizObjectDataItemDTOList", condition);
    }
}
