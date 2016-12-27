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
import com.comtop.cap.bm.biz.info.appservice.BizObjInfoAppService;
import com.comtop.cap.bm.biz.info.dao.BizObjInfoDAO;
import com.comtop.cap.bm.biz.info.model.BizObjInfoVO;
import com.comtop.cap.doc.biz.convert.BizObjectConverter;
import com.comtop.cap.doc.biz.model.BizObjectDTO;
import com.comtop.cap.doc.biz.model.BizObjectDataItemDTO;
import com.comtop.cap.doc.biz.model.DataItemDTO;
import com.comtop.cap.doc.service.BizAbstractWordDataAccessor;
import com.comtop.cap.doc.service.IndexBuilder;
import com.comtop.cap.doc.util.DocDataUtil;
import com.comtop.cap.runtime.component.facade.AutoGenNumberFacade;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.core.AppBeanUtil;

/**
 * 业务对象文档操作门面
 * 
 * @author 李志勇
 * @since 1.0
 * @version 2015-11-10 李志勇
 */
@PetiteBean
@IndexBuilder(dto = BizObjectDTO.class)
public class BizObjInfoDocAppservice extends BizAbstractWordDataAccessor<BizObjInfoVO, BizObjectDTO> {
    
    /** 注入业务对象AppService **/
    @PetiteInject
    protected BizObjInfoAppService bizObjInfoAppService;
    
    /** 注入业务对象DAO **/
    @PetiteInject
    protected BizObjInfoDAO bizObjInfoDAO;
    
    /** 注入业务对象数据项文档操作服务 **/
    @PetiteInject
    protected BizObjDataItemDocAppservice bizObjDataItemDocAppservice;
    
    @Override
    protected void saveBizData(List<BizObjectDTO> collection) {
        for (BizObjectDTO bizObjectDTO : collection) {
            saveData(bizObjectDTO);
            List<BizObjectDataItemDTO> dataItems = bizObjectDTO.getDataItemList();
            if (dataItems != null && dataItems.size() > 0) {
                for (DataItemDTO dataItemDTO : dataItems) {
                    dataItemDTO.setObjectId(bizObjectDTO.getId());
                }
                bizObjDataItemDocAppservice.saveData(dataItems);
            }
        }
    }
    
    @Override
    protected void fillRelationObjectIds(BizObjectDTO bizObjectDTO) {
        if (bizObjectDTO.isNewData()) {
            if (StringUtils.isNotBlank(bizObjectDTO.getPackageName())) {
                BizObjectDTO packageDTO = BizObjectConverter.convert2Package(bizObjectDTO, null);
                String packageId = findIdFromRelation(packageDTO);
                bizObjectDTO.setPackageId(packageId);
            } else {
                //
            }
        }
    }
    
    /**
     * 初始化一条数据
     *
     * @param bizObjectDTO DTO对象
     */
    @Override
    protected void initOneData(BizObjectDTO bizObjectDTO) {
        BizObjectDataItemDTO queryCondtion = new BizObjectDataItemDTO();
        queryCondtion.setObjectId(bizObjectDTO.getId());
        List<BizObjectDataItemDTO> dataItems = bizObjDataItemDocAppservice.loadData(queryCondtion);
        bizObjectDTO.setDataItemList(dataItems);
    }
    
    @Override
    protected BizObjInfoVO dto2VO(BizObjectDTO data) {
        return DocDataUtil.dto2VO(data, BizObjInfoVO.class);
    }
    
    @Override
    protected BizObjectDTO vo2DTO(BizObjInfoVO vo) {
        return DocDataUtil.vo2DTO(vo, BizObjectDTO.class);
    }
    
    @Override
    protected String getUri(BizObjectDTO data) {
        return data.getPackageId() + "-" + data.getName();
    }
    
    @Override
    public String saveNewData(BizObjectDTO newData) {
        if (StringUtils.isBlank(newData.getCode())) {
            newData.setCode(generateCode(BizObjInfoVO.getCodeExpr(), null));
        }
        newData.setSortNo(generateSortNo("BizObject-SortNo"));
        BizObjInfoVO vo = dto2VO(newData);
        String id = this.bizObjInfoAppService.save(vo);
        newData.setId(id);
        return id;
    }
    
    @Override
    protected MDBaseAppservice<BizObjInfoVO> getBaseAppservice() {
        return bizObjInfoAppService;
    }
    
    /**
     * 更新编码和序号
     *
     */
    public void updateCodeAndSortNo() {
        List<BizObjInfoVO> alData = bizObjInfoAppService.loadBizObjInfoNotExistCodeOrSortNo();
        AutoGenNumberFacade autoGenNumberService = AppBeanUtil.getBean(AutoGenNumberFacade.class);
        for (BizObjInfoVO data : alData) {
            if (StringUtils.isBlank(data.getCode())) {
                String code = autoGenNumberService.genNumber(BizObjInfoVO.getCodeExpr(), null);
                bizObjInfoAppService.updatePropertyById(data.getId(), "code", code);
            }
            if (data.getSortNo() == null) {
                String sortNoExpr = DocDataUtil.getSortNoExpr("BizObject-SortNo", data.getDomainId());
                String code = autoGenNumberService.genNumber(sortNoExpr, null);
                bizObjInfoAppService.updatePropertyById(data.getId(), "sortNo", code);
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
    public List<BizObjectDTO> queryDTOList(BizObjectDTO condition) {
        if (StringUtils.isBlank(condition.getPackageId())) {
            return bizObjInfoDAO.queryList("com.comtop.cap.bm.biz.info.model.queryBizObjectDTOListWithNoPackageId",
                condition);
        }
        return bizObjInfoDAO.queryList("com.comtop.cap.bm.biz.info.model.queryBizObjectDTOList", condition);
    }
    
}
