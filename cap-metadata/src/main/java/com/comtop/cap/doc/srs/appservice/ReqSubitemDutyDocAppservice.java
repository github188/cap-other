/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.srs.appservice;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.base.MDBaseAppservice;
import com.comtop.cap.bm.biz.role.appservice.BizRoleAppService;
import com.comtop.cap.bm.biz.role.model.BizRoleVO;
import com.comtop.cap.bm.common.BizLevel;
import com.comtop.cap.bm.req.subfunc.appservice.ReqSubitemDutyAppService;
import com.comtop.cap.bm.req.subfunc.model.ReqSubitemDutyVO;
import com.comtop.cap.doc.service.AbstractWordDataAccessor;
import com.comtop.cap.doc.service.CommonDataManager;
import com.comtop.cap.doc.srs.model.ReqSubitemDutyDTO;
import com.comtop.cap.doc.util.DocDataUtil;
import com.comtop.cap.document.util.CollectionUtils;
import com.comtop.cap.runtime.component.facade.AutoGenNumberFacade;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.core.AppBeanUtil;

/**
 * 功能子项职责表 业务逻辑处理类 门面
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-12-16 CAP
 */
@PetiteBean
public class ReqSubitemDutyDocAppservice extends AbstractWordDataAccessor<ReqSubitemDutyVO, ReqSubitemDutyDTO> {
    
    /** 注入AppService **/
    @PetiteInject
    protected ReqSubitemDutyAppService reqSubitemDutyAppService;
    
    /** 注入AppService **/
    @PetiteInject
    protected BizRoleAppService roleAppService;
    
    /**
     * 
     * @see com.comtop.cap.document.word.dao.IWordDataAccessor#loadData(java.lang.Object)
     */
    @Override
    public List<ReqSubitemDutyDTO> loadData(ReqSubitemDutyDTO condition) {
        ReqSubitemDutyVO objCondtion = new ReqSubitemDutyVO();
        objCondtion.setSubitemId(condition.getSubitemId());
        objCondtion.setPageSize(Integer.MAX_VALUE);
        List<ReqSubitemDutyVO> lstDatas = reqSubitemDutyAppService.queryReqSubitemDutyList(objCondtion);
        List<ReqSubitemDutyDTO> lstResult = new ArrayList<ReqSubitemDutyDTO>();
        for (ReqSubitemDutyVO objVO : lstDatas) {
            lstResult.add(this.vo2DTO(objVO));
            CommonDataManager.addReqSubitemDuty(objVO);
        }
        return lstResult;
    }
    
    /**
     * 保存业务数据
     *
     * @param collection 业务数据集
     * @see com.comtop.cap.doc.service.AbstractWordDataAccessor#saveBizData(java.util.List)
     */
    @Override
    protected void saveBizData(List<ReqSubitemDutyDTO> collection) {
        if (CollectionUtils.isEmpty(collection)) {
            return;
        }
        for (ReqSubitemDutyDTO objDTO : collection) {
            this.saveSplitData(objDTO);
        }
    }
    
    /**
     * 将数据进行切分
     *
     * @param data 原始数据
     */
    private void saveSplitData(ReqSubitemDutyDTO data) {
        String strName = data.getName();
        if (StringUtils.isBlank(strName)) {
            return;
        }
        List<ReqSubitemDutyDTO> lstSplitDTOs = new ArrayList<ReqSubitemDutyDTO>();
        String strRegex = "[\\,\\.\\;；，、/\\\\]";
        String[] objNames = strName.split(strRegex);
        ReqSubitemDutyDTO objSplit;
        for (String n : objNames) {
            if (StringUtils.isNotBlank(n)) {
                objSplit = new ReqSubitemDutyDTO();
                DocDataUtil.copyProperties(objSplit, data);
                objSplit.setName(n);
                lstSplitDTOs.add(objSplit);
            }
        }
        for (ReqSubitemDutyDTO objDTO : lstSplitDTOs) {
            this.saveOneData(objDTO);
        }
        
    }
    
    /**
     * 保存一条数据
     *
     * @param data dto
     */
    private void saveOneData(ReqSubitemDutyDTO data) {
        String strName = data.getName();
        String strSubitemId = data.getSubitemId();
        String strRoleName;
        String strBizLevel = CommonDataManager.findRoleBizLevel(strName);
        if (StringUtils.isNotBlank(strBizLevel) && !BizLevel.BIZ_LEVEL_UNKNOWN.getCode().equals(strBizLevel)) {
            int iLen = BizLevel.getBizLevelByCode(strBizLevel).getCnName().length();
            strRoleName = strName.substring(iLen);
        } else {
            strRoleName = strName;
        }
        if (StringUtils.isBlank(strRoleName) && StringUtils.isNotBlank(strBizLevel)) {
            strRoleName = BizLevel.getBizLevelByCode(strBizLevel).getCnName();
        }
        data.setBizLevel(strBizLevel);
        data.setRoleName(strRoleName);
        
        boolean bUpdate = true;
        ReqSubitemDutyVO objExisted = CommonDataManager.getReqSubitemDuty(strSubitemId, strBizLevel, strRoleName);
        ReqSubitemDutyVO objVO;
        if (objExisted == null) {
            String strID = UUID.randomUUID().toString().replace("-", "").toUpperCase();
            data.setId(strID);
            objVO = this.dto2VO(data);
            bUpdate = false;
        } else {
            objVO = objExisted;
            if (StringUtils.isBlank(objVO.getDescription())) {
                objVO.setDescription(data.getDescription());
            } else if (StringUtils.isNotBlank(data.getDescription())
                && !objVO.getDescription().contains(data.getDescription())) {
                String strDescription = objVO.getDescription() + "," + data.getDescription();
                objVO.setDescription(strDescription);
            }
        }
        if (bUpdate) {
            reqSubitemDutyAppService.updateReqSubitemDuty(objVO);
        } else {
            reqSubitemDutyAppService.insertReqSubitemDuty(objVO);
            CommonDataManager.addReqSubitemDuty(objVO);
        }
    }
    
    /**
     * 获得appservice
     *
     * @return appservice
     * @see com.comtop.cap.doc.service.AbstractWordDataAccessor#getBaseAppservice()
     */
    @Override
    protected MDBaseAppservice<ReqSubitemDutyVO> getBaseAppservice() {
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
    protected ReqSubitemDutyVO dto2VO(ReqSubitemDutyDTO data) {
        String strDomainId = data.getDomainId();
        String strBizLevel = data.getBizLevel();
        String strRoleName = data.getRoleName();
        BizRoleVO objRoleVO = CommonDataManager.getBizRole(strDomainId, strBizLevel, strRoleName);
        if (objRoleVO == null) { // 找不到角色
            objRoleVO = new BizRoleVO();
            objRoleVO.setRoleName(strRoleName);
            AutoGenNumberFacade autoGenNumberService = AppBeanUtil.getBean(AutoGenNumberFacade.class);
            objRoleVO.setRoleCode(autoGenNumberService.genNumber(BizRoleVO.getCodeExpr(), null));
            objRoleVO.setDomainId(strDomainId);
            objRoleVO.setDocumentId(data.getDocumentId());
            objRoleVO.setDataFrom(1);
            objRoleVO.setBizLevel(strBizLevel);
            this.roleAppService.insertRole(objRoleVO);
            CommonDataManager.addBizRole(objRoleVO);
        }
        data.setRoleId(objRoleVO.getId());
        ReqSubitemDutyVO objVO = new ReqSubitemDutyVO();
        DocDataUtil.copyProperties(objVO, data);
        return objVO;
    }
    
    /**
     * VO转换为DTO .一般情况下，子类应该重写本方法
     *
     * @param vo vo
     * @return DTO
     * @see com.comtop.cap.doc.service.AbstractWordDataAccessor#vo2DTO(com.comtop.top.core.base.model.CoreVO)
     */
    @Override
    protected ReqSubitemDutyDTO vo2DTO(ReqSubitemDutyVO vo) {
        ReqSubitemDutyDTO objDTO = new ReqSubitemDutyDTO();
        DocDataUtil.copyProperties(objDTO, vo);
        objDTO.setNewData(false);
        String strName;
        if (StringUtils.isNotBlank(vo.getBizLevel())) {
            BizLevel objLevel = BizLevel.getBizLevelByCode(vo.getBizLevel());
            if (objLevel != null && objLevel != BizLevel.BIZ_LEVEL_UNKNOWN) {
                strName = objLevel.getCnName();
            } else {
                strName = "";
            }
            if (StringUtils.isNotBlank(vo.getRoleName())) {
                strName = strName + vo.getRoleName();
            }
        } else {
            strName = vo.getRoleName();
        }
        objDTO.setName(strName);
        return objDTO;
    }
    
    /**
     * 获取角色id集合
     * 
     * @param subitemId 功能子项id
     * @return 获取角色id集合
     */
    public String queryBizRolesBySubitemId(String subitemId) {
        return reqSubitemDutyAppService.queryBizRolesBySubitemId(subitemId);
    }
    
}
