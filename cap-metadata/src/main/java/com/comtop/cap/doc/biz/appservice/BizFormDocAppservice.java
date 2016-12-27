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
import com.comtop.cap.bm.biz.form.appservice.BizFormAppService;
import com.comtop.cap.bm.biz.form.dao.BizFormDAO;
import com.comtop.cap.bm.biz.form.model.BizFormVO;
import com.comtop.cap.doc.biz.convert.BizFormConverter;
import com.comtop.cap.doc.biz.model.BizFormDTO;
import com.comtop.cap.doc.biz.model.BizFormDataItemDTO;
import com.comtop.cap.doc.biz.model.DataItemDTO;
import com.comtop.cap.doc.service.BizAbstractWordDataAccessor;
import com.comtop.cap.doc.service.IndexBuilder;
import com.comtop.cap.doc.util.DocDataUtil;
import com.comtop.cap.runtime.component.facade.AutoGenNumberFacade;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.core.AppBeanUtil;

/**
 * 业务表单文档操作门面
 * 
 * @author 李志勇
 * @since 1.0
 * @version 2015-11-11 李志勇
 */
@PetiteBean
@IndexBuilder(dto = BizFormDTO.class)
public class BizFormDocAppservice extends BizAbstractWordDataAccessor<BizFormVO, BizFormDTO> {
    
    /** 注入AppService **/
    @PetiteInject
    protected BizFormAppService bizFormAppService;
    
    /** 注入AppService **/
    @PetiteInject
    protected BizFormDataDocAppservice bizFormDataDocAppservice;
    
    /** 注入DAO **/
    @PetiteInject
    protected BizFormDAO bizFormDAO;
    
    @Override
    protected MDBaseAppservice<BizFormVO> getBaseAppservice() {
        return bizFormAppService;
    }
    
    @Override
    protected void saveBizData(List<BizFormDTO> collection) {
        for (BizFormDTO bizFormDTO : collection) {
            saveData(bizFormDTO);
            List<BizFormDataItemDTO> dataItems = bizFormDTO.getDataItemList();
            if (dataItems != null && dataItems.size() > 0) {
                for (DataItemDTO dataItemDTO : dataItems) {
                    dataItemDTO.setObjectId(bizFormDTO.getId());
                }
                bizFormDataDocAppservice.saveData(dataItems);
            }
        }
    }
    
    @Override
    protected void fillRelationObjectIds(BizFormDTO dto) {
        if (dto.isNewData()) {
            if (StringUtils.isNotBlank(dto.getPackageName())) {
                BizFormDTO packageDTO = BizFormConverter.convert2Package(dto, null);
                String packageId = findIdFromRelation(packageDTO);
                dto.setPackageId(packageId);
            } else {
                //
            }
        }
    }
    
    /**
     * 初始化一条数据
     *
     * @param bizFormDTO DTO对象
     */
    @Override
    protected void initOneData(BizFormDTO bizFormDTO) {
        BizFormDataItemDTO queryCondtion = new BizFormDataItemDTO();
        queryCondtion.setObjectId(bizFormDTO.getId());
        List<BizFormDataItemDTO> dataItems = bizFormDataDocAppservice.loadData(queryCondtion);
        bizFormDTO.setDataItemList(dataItems);
    }
    
    @Override
    protected String getUri(BizFormDTO data) {
        return data.getPackageId() + "-" + data.getName();
    }
    
    @Override
    protected BizFormVO dto2VO(BizFormDTO data) {
        return DocDataUtil.dto2VO(data, BizFormVO.class);
    }
    
    @Override
    protected BizFormDTO vo2DTO(BizFormVO vo) {
        return DocDataUtil.vo2DTO(vo, BizFormDTO.class);
    }
    
    @Override
    public String saveNewData(BizFormDTO newData) {
        if (StringUtils.isBlank(newData.getCode())) {
            newData.setCode(generateCode(BizFormVO.getCodeExpr(), null));
        }
        newData.setSortNo(generateSortNo("BizForm-SortNo"));
        BizFormVO vo = dto2VO(newData);
        String id = this.bizFormAppService.save(vo);
        newData.setId(id);
        return id;
    }
    
    /**
     * 更新编码和序号
     *
     */
    public void updateCodeAndSortNo() {
        List<BizFormVO> alData = bizFormAppService.loadBizFormNotExistCodeOrSortNo();
        AutoGenNumberFacade autoGenNumberService = AppBeanUtil.getBean(AutoGenNumberFacade.class);
        for (BizFormVO data : alData) {
            if (StringUtils.isBlank(data.getCode())) {
                String code = autoGenNumberService.genNumber(BizFormVO.getCodeExpr(), null);
                bizFormAppService.updatePropertyById(data.getId(), "code", code);
            }
            
            if (data.getSortNo() == null) {
                String sortNoExpr = DocDataUtil.getSortNoExpr("BizForm-SortNo", data.getDomainId());
                String code = autoGenNumberService.genNumber(sortNoExpr, null);
                bizFormAppService.updatePropertyById(data.getId(), "sortNo", code);
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
    public List<BizFormDTO> queryDTOList(BizFormDTO condition) {
        // 如果有包id，则以包id为基本条件 否则就直接查询
        if (StringUtils.isBlank(condition.getPackageId())) {
            return bizFormDAO.queryList("com.comtop.cap.bm.biz.form.model.queryBizFormDTOListWithNoPackageId",
                condition);
        }
        return bizFormDAO.queryList("com.comtop.cap.bm.biz.form.model.queryBizFormDTOList", condition);
    }
}
