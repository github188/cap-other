/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.srs.appservice;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.base.MDBaseAppservice;
import com.comtop.cap.bm.biz.form.model.BizFormVO;
import com.comtop.cap.bm.req.subfunc.appservice.ReqFunctionUsecaseAppService;
import com.comtop.cap.bm.req.subfunc.appservice.ReqUsecaseRelFormAppService;
import com.comtop.cap.bm.req.subfunc.facade.ReqUsecaseRelFormFacade;
import com.comtop.cap.bm.req.subfunc.model.ReqFunctionUsecaseVO;
import com.comtop.cap.bm.req.subfunc.model.ReqUsecaseRelFormVO;
import com.comtop.cap.doc.service.AbstractWordDataAccessor;
import com.comtop.cap.doc.service.CommonDataManager;
import com.comtop.cap.doc.srs.model.ReqFunctionUsecaseDTO;
import com.comtop.cap.doc.util.DocDataUtil;
import com.comtop.cap.document.util.CollectionUtils;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.core.AppBeanUtil;

/**
 * 功能用例 业务逻辑处理类 门面
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-12-22 CAP
 */
@PetiteBean
public class ReqFunctionUsecaseDocAppservice extends
    AbstractWordDataAccessor<ReqFunctionUsecaseVO, ReqFunctionUsecaseDTO> {
    
    /** 注入AppService **/
    @PetiteInject
    protected ReqFunctionUsecaseAppService reqFunctionUsecaseAppService;
    
    /** 注入AppService **/
    @PetiteInject
    protected ReqUsecaseRelFormAppService reqUsecaseRelFormAppService;
    
    /** 功能用例关联业务表单 Facade */
    protected final ReqUsecaseRelFormFacade reqUsecaseRelFormFacade = AppBeanUtil
        .getBean(ReqUsecaseRelFormFacade.class);
    
    /**
     * 
     * @see com.comtop.cap.document.word.dao.IWordDataAccessor#loadData(java.lang.Object)
     */
    @Override
    public List<ReqFunctionUsecaseDTO> loadData(ReqFunctionUsecaseDTO condition) {
        ReqFunctionUsecaseVO objCondition = new ReqFunctionUsecaseVO();
        objCondition.setSubitemId(condition.getSubitemId());
        objCondition.setPageSize(Integer.MAX_VALUE);
        List<ReqFunctionUsecaseVO> lstVos = reqFunctionUsecaseAppService.queryReqFunctionUsecaseList(objCondition);
        List<ReqFunctionUsecaseDTO> lstDtos = new ArrayList<ReqFunctionUsecaseDTO>();
        for (ReqFunctionUsecaseVO objVO : lstVos) {
            lstDtos.add(this.vo2DTO(objVO));
            CommonDataManager.addReqFunctionUsecase(objVO);
        }
        return lstDtos;
    }
    
    /**
     * 保存业务数据
     *
     * @param collection 业务数据集
     * @see com.comtop.cap.doc.service.AbstractWordDataAccessor#saveBizData(java.util.List)
     */
    @Override
    protected void saveBizData(List<ReqFunctionUsecaseDTO> collection) {
        if (CollectionUtils.isEmpty(collection)) {
            return;
        }
        for (ReqFunctionUsecaseDTO objDTO : collection) {
            this.saveOneData(objDTO);
        }
    }
    
    /**
     * 保存一条数据
     *
     * @param dto 业务数据
     */
    private void saveOneData(ReqFunctionUsecaseDTO dto) {
        ReqFunctionUsecaseVO objExisted = CommonDataManager.getReqFunctionUsecase(dto.getSubitemId(), dto.getName());
        ReqFunctionUsecaseVO objVO = this.dto2VO(dto);
        if (objExisted != null) {
            dto.setId(objExisted.getId());
            objVO.setId(objExisted.getId());
            reqFunctionUsecaseAppService.updateReqFunctionUsecase(objVO);
        } else {
            reqFunctionUsecaseAppService.insertReqFunctionUsecase(objVO);
        }
        if (StringUtils.isNotBlank(dto.getBizForms())) {
            saveBizForms(objVO.getId(), dto.getDomainId(), dto.getBizForms());
        }
    }
    
    /**
     * 保存业务表达数据
     *
     * @param id 保存业务表单数据
     * @param domainId 业务域ID
     * @param bizForms 业务表单名称
     */
    private void saveBizForms(String id, String domainId, String bizForms) {
        String strRegex = "[\\,\\.\\;；，、/\\\\]";
        String[] objFormNames = bizForms.split(strRegex);
        if (objFormNames == null) {
            return;
        }
        ReqUsecaseRelFormVO objFormCondition = new ReqUsecaseRelFormVO();
        objFormCondition.setUsecaseId(id);
        List<ReqUsecaseRelFormVO> lstForms = reqUsecaseRelFormAppService.queryReqUsecaseRelFormList(objFormCondition);
        Set<String> colNames = new HashSet<String>();
        if (lstForms != null && lstForms.size() > 0) {
            for (ReqUsecaseRelFormVO objForm : lstForms) {
                colNames.add(objForm.getBizFormName());
            }
        }
        int iStart = -1;
        int iEnd = 0;
        String strRegFormName;
        for (String strFormName : objFormNames) {
            iStart = strFormName.indexOf('「') + 1;
            if (iStart == -1) {
                iStart = strFormName.indexOf('[') + 1;
            }
            iEnd = strFormName.indexOf('」');
            if (iEnd == -1) {
                iEnd = strFormName.indexOf(']');
            }
            if (iStart != 0 && iEnd != -1 && iEnd > iStart) {
                strRegFormName = strFormName.substring(iStart, iEnd);
            } else {
                strRegFormName = strFormName;
            }
            if (colNames.contains(strRegFormName)) {
                continue;
            }
            BizFormVO objDizFormVO = CommonDataManager.getBizForm(domainId, strRegFormName);
            if (objDizFormVO == null) {
                continue;
            }
            ReqUsecaseRelFormVO objRel = new ReqUsecaseRelFormVO();
            objRel.setBizFormId(objDizFormVO.getId());
            objRel.setUsecaseId(id);
            reqUsecaseRelFormAppService.insertReqUsecaseRelForm(objRel);
        }
        
    }
    
    /**
     * 获得appservice
     *
     * @return appservice
     * @see com.comtop.cap.doc.service.AbstractWordDataAccessor#getBaseAppservice()
     */
    @Override
    protected MDBaseAppservice<ReqFunctionUsecaseVO> getBaseAppservice() {
        return null;
    }
    
    /**
     * 将DTO转换为VO
     *
     * @param data 数据集
     * @return VO
     * @see com.comtop.cap.doc.service.AbstractWordDataAccessor#dto2VO(com.comtop.cap.document.word.docmodel.data.BaseDTO)
     */
    @Override
    protected ReqFunctionUsecaseVO dto2VO(ReqFunctionUsecaseDTO data) {
        ReqFunctionUsecaseVO vo = new ReqFunctionUsecaseVO();
        DocDataUtil.copyProperties(vo, data);
        return vo;
    }
    
    /**
     * VO转换为DTO .一般情况下，子类应该重写本方法
     *
     * @param vo vo
     * @return DTO
     * @see com.comtop.cap.doc.service.AbstractWordDataAccessor#vo2DTO(com.comtop.top.core.base.model.CoreVO)
     */
    @Override
    protected ReqFunctionUsecaseDTO vo2DTO(ReqFunctionUsecaseVO vo) {
        ReqFunctionUsecaseDTO objDto = new ReqFunctionUsecaseDTO();
        DocDataUtil.copyProperties(objDto, vo);
        ReqUsecaseRelFormVO objFormCondition = new ReqUsecaseRelFormVO();
        objFormCondition.setUsecaseId(vo.getId());
        List<ReqUsecaseRelFormVO> lstForms = reqUsecaseRelFormAppService.queryReqUsecaseRelFormList(objFormCondition);
        if (lstForms != null && lstForms.size() > 0) {
            StringBuilder sbID = new StringBuilder();
            for (int i = 0; i < lstForms.size(); i++) {
                ReqUsecaseRelFormVO objForm = lstForms.get(i);
                if (i > 0) {
                    sbID.append(';');
                }
                sbID.append(objForm.getBizFormName());
            }
            objDto.setBizForms(sbID.toString());
        }
        objDto.setNewData(false);
        return objDto;
    }
}
