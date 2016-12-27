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
import com.comtop.cap.bm.biz.form.appservice.BizFormDataAppService;
import com.comtop.cap.bm.biz.form.dao.BizFormDataDAO;
import com.comtop.cap.bm.biz.form.model.BizFormDataVO;
import com.comtop.cap.doc.biz.convert.BizFormDataConverter;
import com.comtop.cap.doc.biz.model.BizFormDTO;
import com.comtop.cap.doc.biz.model.BizFormDataItemDTO;
import com.comtop.cap.doc.service.BizAbstractWordDataAccessor;
import com.comtop.cap.doc.service.IndexBuilder;
import com.comtop.cap.doc.util.DocDataUtil;
import com.comtop.cap.runtime.component.facade.AutoGenNumberFacade;
import com.comtop.cip.common.constant.CapNumberConstant;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.core.AppBeanUtil;

/**
 * 业务表单数据项 文档操作门面
 * 
 * @author 李志勇
 * @since 1.0
 * @version 2015-11-11 李志勇
 */
@PetiteBean
@IndexBuilder(dto = BizFormDataItemDTO.class)
public class BizFormDataDocAppservice extends BizAbstractWordDataAccessor<BizFormDataVO, BizFormDataItemDTO> {
    
    /** 注入DAO **/
    @PetiteInject
    protected BizFormDataDAO bizFormDataDAO;
    
    /** 注入AppService **/
    @PetiteInject
    protected BizFormDataAppService bizFormDataAppService;
    
    /** 业务表单文档操作服务 */
    @PetiteInject
    protected BizFormDocAppservice bizFormDocAppservice;
    
    @Override
    protected MDBaseAppservice<BizFormDataVO> getBaseAppservice() {
        return bizFormDataAppService;
    }
    
    @Override
    protected void saveBizData(List<BizFormDataItemDTO> dataItems) {
        if (dataItems != null && dataItems.size() > 0) {
            for (BizFormDataItemDTO dataItem : dataItems) {
                saveData(dataItem);
            }
        }
    }
    
    @Override
    protected void fillRelationObjectIds(BizFormDataItemDTO dto) {
        if (dto.isNewData()) {
            if (StringUtils.isNotBlank(dto.getObjectName())) {
                BizFormDTO bizFormDTO = BizFormDataConverter.convert2BizForm(dto, null);
                String formId = bizFormDocAppservice.findIdFromRelation(bizFormDTO);
                dto.setObjectId(formId);
            } else {
                //
            }
        }
    }
    
    @Override
    public List<BizFormDataItemDTO> loadData(BizFormDataItemDTO condition) {
        List<BizFormDataItemDTO> dataItems = queryDTOList(condition);
        int iSortIndex = CapNumberConstant.NUMBER_INT_ZERO;
        for (BizFormDataItemDTO dataItemDTO : dataItems) {
            dataItemDTO.setNewData(false);
            dataItemDTO.setSortIndex(++iSortIndex);
        }
        return dataItems;
    }
    
    @Override
    protected BizFormDataVO dto2VO(BizFormDataItemDTO data) {
        BizFormDataVO bizFormDataVO = DocDataUtil.dto2VO(data, BizFormDataVO.class);
        bizFormDataVO.setRequried(data.getIntRequired());
        bizFormDataVO.setFormId(data.getObjectId());
        return bizFormDataVO;
    }
    
    @Override
    protected BizFormDataItemDTO vo2DTO(BizFormDataVO vo) {
        BizFormDataItemDTO bizFormDataItemDTO = DocDataUtil.vo2DTO(vo, BizFormDataItemDTO.class);
        bizFormDataItemDTO.setObjectId(vo.getFormId());
        bizFormDataItemDTO.setIntRequired(vo.getRequried());
        return bizFormDataItemDTO;
    }
    
    @Override
    public String saveNewData(BizFormDataItemDTO newData) {
        newData.setSortNo(generateSortNo("BizFormData-SortNo"));
        BizFormDataVO vo = dto2VO(newData);
        String id = this.bizFormDataAppService.save(vo);
        newData.setId(id);
        return id;
    }
    
    @Override
    protected String getUri(BizFormDataItemDTO data) {
        return data.getObjectId() + "-" + StringUtils.trim(data.getName());
    }
    
    /**
     * 更新编码和序号
     *
     */
    public void updateCodeAndSortNo() {
        List<BizFormDataVO> alData = bizFormDataAppService.loadBizFormDataNotExistCodeOrSortNo();
        AutoGenNumberFacade autoGenNumberService = AppBeanUtil.getBean(AutoGenNumberFacade.class);
        for (BizFormDataVO data : alData) {
            if (data.getSortNo() == null) {
                String sortNoExpr = DocDataUtil.getSortNoExpr("BizFormData-SortNo", data.getFormId());
                String code = autoGenNumberService.genNumber(sortNoExpr, null);
                bizFormDataAppService.updatePropertyById(data.getId(), "sortNo", code);
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
    public List<BizFormDataItemDTO> queryDTOList(BizFormDataItemDTO condition) {
        return bizFormDataDAO.queryList("com.comtop.cap.bm.biz.form.model.queryBizFormDataItemDTOList", condition);
    }
}
