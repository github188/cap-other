/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.srs.appservice;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.base.MDBaseAppservice;
import com.comtop.cap.bm.biz.domain.model.BizDomainVO;
import com.comtop.cap.bm.req.func.appservice.ReqFunctionItemAppService;
import com.comtop.cap.bm.req.func.dao.ReqFunctionItemDAO;
import com.comtop.cap.bm.req.func.model.ReqFunctionDistributedVO;
import com.comtop.cap.bm.req.func.model.ReqFunctionItemVO;
import com.comtop.cap.doc.service.AbstractWordDataAccessor;
import com.comtop.cap.doc.service.CommonDataManager;
import com.comtop.cap.doc.srs.model.ReqFunctionItemDTO;
import com.comtop.cap.doc.srs.model.ReqFunctionRoleDTO;
import com.comtop.cap.doc.srs.model.ReqFunctionWithProcessDTO;
import com.comtop.cap.doc.util.DocDataUtil;
import com.comtop.cap.document.util.CollectionUtils;
import com.comtop.cap.runtime.component.facade.AutoGenNumberFacade;
import com.comtop.cip.common.constant.CapNumberConstant;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.core.AppBeanUtil;

/**
 * 功能项，建立在系统、子系统、目录下面。扩展实现
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-11-25 CAP
 */
@PetiteBean
public class ReqFunctionItemDocAppservice extends AbstractWordDataAccessor<ReqFunctionItemVO, ReqFunctionItemDTO> {
    
    /** 注入AppService **/
    @PetiteInject
    protected ReqFunctionItemAppService reqFunctionItemAppService;
    
    /** 注入AppService **/
    @PetiteInject
    protected ReqFunctionItemDAO reqFunctionItemDAO;
    
    /**
     * 
     * @see com.comtop.cap.document.word.dao.IWordDataAccessor#loadData(java.lang.Object)
     */
    @Override
    public List<ReqFunctionItemDTO> loadData(ReqFunctionItemDTO condition) {
        ReqFunctionItemVO objCodition = new ReqFunctionItemVO();
        objCodition.setId(condition.getId());
        objCodition.setBizDomainId(condition.getDomainId());
        List<ReqFunctionItemVO> lstItems = reqFunctionItemAppService.loadList(objCodition);
        List<ReqFunctionItemDTO> lstDataItems = new ArrayList<ReqFunctionItemDTO>(lstItems.size());
        int iSortNo = CapNumberConstant.NUMBER_INT_ZERO;
        for (ReqFunctionItemVO objItem : lstItems) {
            ReqFunctionItemVO objVO = reqFunctionItemAppService.queryReqFunctionItemWithDistributed(objItem);
            CommonDataManager.addReqFunctionItem(objVO);
            ReqFunctionItemDTO objDto = this.vo2DTO(objVO);
            iSortNo++;
            objDto.setSortIndex(iSortNo);
            lstDataItems.add(objDto);
        }
        return lstDataItems;
    }
    
    /**
     * 
     * @see com.comtop.cap.doc.service.AbstractWordDataAccessor#saveBizData(java.util.List)
     */
    @Override
    protected void saveBizData(List<ReqFunctionItemDTO> collection) {
        if (CollectionUtils.isEmpty(collection)) {
            return;
        }
        for (ReqFunctionItemDTO objDTO : collection) {
            saveOneData(objDTO);
        }
    }
    
    /**
     * 保存一条数据
     *
     * @param data 数据
     */
    public void saveOneData(ReqFunctionItemDTO data) {
        ReqFunctionItemVO objItem = CommonDataManager.getReqFunctionItem(data.getDomainId(), data.getName());
        String strDomainId = data.getDomainId();
        Map<String, Object> colParams = new HashMap<String, Object>();
        colParams.put("domainId", strDomainId);
        AutoGenNumberFacade autoGenNumberService = AppBeanUtil.getBean(AutoGenNumberFacade.class);
        boolean bUpdate = false;
        if (objItem == null || objItem.getSortNo() == null || objItem.getSortNo() == 0) {
            String strNO = autoGenNumberService.genNumber(ReqFunctionItemVO.SORT_EXPR, colParams);
            int iNumber = Integer.parseInt(strNO);
            data.setSortNo(iNumber);
        } else {
            data.setSortNo(objItem.getSortNo());
        }
        if (StringUtils.isBlank(data.getCode())) {
            BizDomainVO objDomainVo = CommonDataManager.getBizDomainVO(strDomainId);
            if (objDomainVo != null) {
                colParams.put("domainCode", objDomainVo.getCode());
            }
            String strCode = autoGenNumberService.genNumber(ReqFunctionItemVO.CODE_EXPR, colParams);
            data.setCode(strCode);
        }
        if (objItem != null) {
            bUpdate = true;
            this.updateVO(data, objItem);
        } else {
            objItem = this.dto2VO(data);
        }
        if (bUpdate) {
            data.setId(objItem.getId());
            reqFunctionItemAppService.updateReqFunctionItem(objItem);
        } else {
            reqFunctionItemAppService.insertReqFunctionItem(objItem);
        }
        CommonDataManager.addReqFunctionItem(objItem);
    }
    
    /**
     * 获得appservice
     *
     * @return appservice
     * @see com.comtop.cap.doc.service.AbstractWordDataAccessor#getBaseAppservice()
     */
    @Override
    protected MDBaseAppservice<ReqFunctionItemVO> getBaseAppservice() {
        return reqFunctionItemAppService;
    }
    
    /**
     * 将DTO转换为VO
     *
     * @param dto 数据
     * @return VO
     * @see com.comtop.cap.doc.service.AbstractWordDataAccessor#dto2VO(com.comtop.cap.document.word.docmodel.data.BaseDTO)
     */
    @Override
    protected ReqFunctionItemVO dto2VO(ReqFunctionItemDTO dto) {
        ReqFunctionItemVO objVO = new ReqFunctionItemVO();
        DocDataUtil.copyProperties(objVO, dto);
        objVO.setItImp(1);
        updateVO(dto, objVO);
        return objVO;
    }
    
    /**
     * 根据DTO中的数据更新
     *
     * @param dto dto
     * @param vo vo
     */
    private void updateVO(ReqFunctionItemDTO dto, ReqFunctionItemVO vo) {
        vo.setBizDomainId(dto.getDomainId());
        vo.setDocumentId(dto.getDocumentId());
        vo.setCnName(dto.getName());
        if ((vo.getItImp() == null || vo.getItImp() == 1) && dto.getItImp() != null) {
            vo.setItImp(dto.getItImp());
        }
        if (StringUtils.isBlank(vo.getFunctionDescription())) {
            vo.setFunctionDescription(dto.getDescription());
        }
        if (StringUtils.isNotBlank(dto.getCode())) {// 更新编码
            vo.setCode(dto.getCode());
        }
        if (dto.getDistributed() != null && !dto.getDistributed().isEmpty()) {
            ReqFunctionItemVO objIem = reqFunctionItemAppService.queryReqFunctionItemWithDistributed(vo);
            Map<String, String> colExisted = new HashMap<String, String>();
            if (objIem != null && objIem.getReqFunctionDistributed() != null) {
                for (ReqFunctionDistributedVO objDistributed : objIem.getReqFunctionDistributed()) {
                    colExisted.put(objDistributed.getLevelCode(), objDistributed.getId());
                }
            }
            List<ReqFunctionDistributedVO> lstDistributes = new ArrayList<ReqFunctionDistributedVO>();
            for (Entry<String, String> objEntry : dto.getDistributed().entrySet()) {
                String strValue = objEntry.getValue();
                if ("√".equals(strValue) || "是".equals(strValue)) {
                    String strCode = objEntry.getKey();
                    String strId = colExisted.get(strCode);
                    ReqFunctionDistributedVO objDistributed = new ReqFunctionDistributedVO();
                    objDistributed.setId(strId);
                    objDistributed.setDataFrom(1);
                    objDistributed.setDocumentId(dto.getDocumentId());
                    objDistributed.setLevelCode(strCode);
                    objDistributed.setItemId(dto.getId());
                    objDistributed.setRelation(1);
                    lstDistributes.add(objDistributed);
                }
            }
            vo.setReqFunctionDistributed(lstDistributes);
        }
    }
    
    /**
     * VO转换为DTO .一般情况下，子类应该重写本方法
     *
     * @param vo vo
     * @return DTO
     * @see com.comtop.cap.doc.service.AbstractWordDataAccessor#vo2DTO(com.comtop.top.core.base.model.CoreVO)
     */
    @Override
    protected ReqFunctionItemDTO vo2DTO(ReqFunctionItemVO vo) {
        ReqFunctionItemDTO objDto = new ReqFunctionItemDTO();
        DocDataUtil.copyProperties(objDto, vo);
        objDto.setDomainId(vo.getBizDomainId());
        objDto.setName(vo.getCnName());
        objDto.setItImp(vo.getItImp());
        objDto.setDescription(vo.getFunctionDescription());
        objDto.getItImpStr();
        if (vo.getReqFunctionDistributed() != null) {
            Map<String, String> colDistributed = new HashMap<String, String>();
            for (ReqFunctionDistributedVO objDistributed : vo.getReqFunctionDistributed()) {
                colDistributed.put(objDistributed.getLevelCode(), "√");
            }
            objDto.setDistributed(colDistributed);
        }
        objDto.setNewData(false);
        return objDto;
    }
    
    /**
     * 查询需求功能项以及业务流程
     *
     * @param condition 查询条件
     * @return 需求功能项以及业务流程
     */
    public List<ReqFunctionWithProcessDTO> queryReqFunctionItemWithProcess(ReqFunctionWithProcessDTO condition) {
        return reqFunctionItemDAO.queryList("com.comtop.cap.bm.req.func.model.queryReqFunctionItemWithProcess",
            condition);
    }
    
    /**
     * 查询需求功能项以及业务角色
     *
     * @param condition 查询条件
     * @return 需求功能项以及业务角色
     */
    public List<ReqFunctionRoleDTO> queryReqFunctionItemWithRole(ReqFunctionRoleDTO condition) {
        return reqFunctionItemDAO.queryList("com.comtop.cap.bm.req.func.model.queryReqFunctionItemWithRole", condition);
    }
    
}
