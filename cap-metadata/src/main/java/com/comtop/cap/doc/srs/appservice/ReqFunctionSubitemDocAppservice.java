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

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.base.MDBaseAppservice;
import com.comtop.cap.bm.biz.domain.model.BizDomainVO;
import com.comtop.cap.bm.biz.flow.appservice.BizProcessInfoAppService;
import com.comtop.cap.bm.biz.info.appservice.BizObjInfoAppService;
import com.comtop.cap.bm.req.func.appservice.ReqFunctionItemAppService;
import com.comtop.cap.bm.req.func.model.ReqFunctionItemVO;
import com.comtop.cap.bm.req.subfunc.appservice.ReqFunctionSubitemAppService;
import com.comtop.cap.bm.req.subfunc.model.ReqFunctionSubitemVO;
import com.comtop.cap.doc.service.AbstractWordDataAccessor;
import com.comtop.cap.doc.service.CommonDataManager;
import com.comtop.cap.doc.srs.model.ReqFunctionSubitemDTO;
import com.comtop.cap.doc.util.DocDataUtil;
import com.comtop.cap.document.util.CollectionUtils;
import com.comtop.cap.runtime.component.facade.AutoGenNumberFacade;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.core.AppBeanUtil;

/**
 * 功能子项,建在功能项下面扩展实现
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-11-25 CAP
 */
@PetiteBean
public class ReqFunctionSubitemDocAppservice extends
    AbstractWordDataAccessor<ReqFunctionSubitemVO, ReqFunctionSubitemDTO> {
    
    /** 注入AppService **/
    @PetiteInject
    protected ReqFunctionSubitemAppService reqFunctionSubitemAppService;
    
    /** 注入AppService **/
    @PetiteInject
    protected BizProcessInfoAppService bizProcessInfoAppService;
    
    /** 注入AppService **/
    @PetiteInject
    protected BizObjInfoAppService bizObjInfoAppService;
    
    /** 注入AppService **/
    @PetiteInject
    protected ReqFunctionItemAppService reqFunctionItemAppService;
    
    /**自动生成编码**/
    private AutoGenNumberFacade autoGenNumberService = AppBeanUtil.getBean(AutoGenNumberFacade.class);
    
    /**
     * 据据条件加载数据
     *
     * @param condition 条件集
     * @return 加载的数据结构 List 表示对象集合
     * @see com.comtop.cap.document.word.dao.IWordDataAccessor#loadData(java.lang.Object)
     */
    @Override
    public List<ReqFunctionSubitemDTO> loadData(ReqFunctionSubitemDTO condition) {
        ReqFunctionSubitemVO objCondition = new ReqFunctionSubitemVO();
        objCondition.setId(condition.getId());
        objCondition.setDomainId(condition.getDomainId());
        objCondition.setItemId(condition.getItemId());
        objCondition.setPageSize(Integer.MAX_VALUE);
        List<ReqFunctionSubitemVO> lstSubitems = reqFunctionSubitemAppService.querySubitemsWithItem(objCondition);
        List<ReqFunctionSubitemDTO> lstDtos = new ArrayList<ReqFunctionSubitemDTO>();
        for (ReqFunctionSubitemVO objSubitem : lstSubitems) {
            lstDtos.add(this.vo2DTO(objSubitem));
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
    protected void saveBizData(List<ReqFunctionSubitemDTO> collection) {
        if (CollectionUtils.isEmpty(collection)) {
            return;
        }
        for (ReqFunctionSubitemDTO objDTO : collection) {
            this.saveOneData(objDTO);
        }
    }
    
    /**
     * 保存一条数据
     *
     * @param data dto
     */
    public void saveOneData(ReqFunctionSubitemDTO data) {
        String strItemId = data.getItemId();
        String strDomainId = data.getDomainId();
        String strItemName = data.getItemName();
        Map<String, Object> colParams = new HashMap<String, Object>();
        colParams.put("domainId", strDomainId);
        ReqFunctionItemVO objItem = CommonDataManager.getReqFunctionItem(strDomainId, strItemName);
        if (objItem == null) { // 找不到业务数据项
            objItem = new ReqFunctionItemVO();
            objItem.setCnName(strItemName);
            objItem.setDocumentId(data.getDocumentId());
            objItem.setId(strItemId);
            objItem.setBizDomainId(strDomainId);
            objItem.setItImp(data.getItImp() == null ? 1 : data.getItImp());
            String strNO = autoGenNumberService.genNumber(ReqFunctionItemVO.SORT_EXPR, colParams);
            int iNumber = Integer.parseInt(strNO);
            BizDomainVO objDomainVo = CommonDataManager.getBizDomainVO(strDomainId);
            if (objDomainVo != null) {
                colParams.put("domainCode", objDomainVo.getCode());
            }
            
            String strCode = data.getItemCode();
            if (StringUtils.isBlank(data.getItemCode())) {
                strCode = autoGenNumberService.genNumber(ReqFunctionItemVO.CODE_EXPR, colParams);
            }
            objItem.setCode(strCode);
            objItem.setSortNo(iNumber);
            objItem.setDataFrom(1);
            this.reqFunctionItemAppService.save(objItem);
            data.setItemId(objItem.getId());
            CommonDataManager.addReqFunctionItem(objItem);
        } else {
            strItemId = objItem.getId();
            if (StringUtils.isNotBlank(data.getItemCode())) {
                objItem.setCode(data.getItemCode());
                this.reqFunctionItemAppService.update(objItem);
            }
            data.setItemId(strItemId);
        }
        colParams.put("itemCode", objItem.getCode());
        ReqFunctionSubitemVO objTemp = CommonDataManager.getTempReqFunctionSubitem(data.getId());
        if (objTemp != null) {
            data.setBizObjectIds(objTemp.getBizObjectIds());
            CommonDataManager.removeTempReqFunctionSubitem(objTemp.getId());
        }
        ReqFunctionSubitemVO objSubitem = CommonDataManager.getReqFunctionSubitem(strItemId, data.getName());
        boolean bUpdate = false;
        if (objSubitem == null || objSubitem.getSortNo() == null || objSubitem.getSortNo() == 0) {
            String strNO = autoGenNumberService.genNumber(ReqFunctionSubitemVO.SORT_EXPR, colParams);
            int iNumber = Integer.parseInt(strNO);
            data.setSortNo(iNumber);
        } else {
            data.setSortNo(objSubitem.getSortNo());
        }
        if (objSubitem != null) {
            bUpdate = true;
            this.updateVO(data, objSubitem);
        } else {
            objSubitem = this.dto2VO(data);
        }
        if (StringUtils.isBlank(data.getCode()) && StringUtils.isBlank(objSubitem.getCode())) {
            String strCode = autoGenNumberService.genNumber(ReqFunctionSubitemVO.CODE_EXPR, colParams);
            objSubitem.setCode(strCode);
        }
        if (bUpdate) {
            data.setId(objSubitem.getId());
            reqFunctionSubitemAppService.update(objSubitem);
        } else {
            reqFunctionSubitemAppService.save(objSubitem);
        }
        CommonDataManager.addReqFunctionSubitem(objSubitem);
    }
    
    /**
     * 获得appservice
     *
     * @return appservice
     * @see com.comtop.cap.doc.service.AbstractWordDataAccessor#getBaseAppservice()
     */
    @Override
    protected MDBaseAppservice<ReqFunctionSubitemVO> getBaseAppservice() {
        return reqFunctionSubitemAppService;
    }
    
    /**
     * VO转换为DTO .一般情况下，子类应该重写本方法
     *
     * @param vo vo
     * @return DTO
     * @see com.comtop.cap.doc.service.AbstractWordDataAccessor#vo2DTO(com.comtop.top.core.base.model.CoreVO)
     */
    @Override
    protected ReqFunctionSubitemDTO vo2DTO(ReqFunctionSubitemVO vo) {
        ReqFunctionSubitemDTO objDTO = new ReqFunctionSubitemDTO();
        DocDataUtil.copyProperties(objDTO, vo);
        objDTO.setAnalysis(vo.getReqAnalysis());
        objDTO.setDescription(vo.getFunctionDescription());
        objDTO.setName(vo.getCnName());
        objDTO.getItImpStr();
        objDTO.setNewData(false);
        return objDTO;
    }
    
    /**
     * 更新VO
     *
     * @param data 数据
     * @param vo VO
     */
    private void updateVO(ReqFunctionSubitemDTO data, ReqFunctionSubitemVO vo) {
        if (StringUtils.isBlank(vo.getReqAnalysis()) && StringUtils.isNotBlank(data.getAnalysis())) {
            vo.setReqAnalysis(data.getAnalysis());
        }
        if (StringUtils.isBlank(vo.getFunctionDescription()) && StringUtils.isNotBlank(data.getDescription())) {
            vo.setFunctionDescription(data.getDescription());
        }
        if ((vo.getItImp() == null || vo.getItImp() == 1) && data.getItImp() != null) {
            vo.setItImp(data.getItImp());
        }
        if (StringUtils.isNotBlank(data.getCode())) { // 更新编码
            vo.setCode(data.getCode());
        }
    }
    
    /**
     * VO转换为DTO .一般情况下，子类应该重写本方法
     *
     * @param data vo
     * @return DTO
     * @see com.comtop.cap.doc.service.AbstractWordDataAccessor#vo2DTO(com.comtop.top.core.base.model.CoreVO)
     */
    @Override
    protected ReqFunctionSubitemVO dto2VO(ReqFunctionSubitemDTO data) {
        ReqFunctionSubitemVO objVO = new ReqFunctionSubitemVO();
        DocDataUtil.copyProperties(objVO, data);
        objVO.setCnName(data.getName());
        objVO.setItImp(1);
        updateVO(data, objVO);
        return objVO;
    }
    
}
