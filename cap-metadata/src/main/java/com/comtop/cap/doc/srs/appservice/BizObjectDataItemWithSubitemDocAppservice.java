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
import java.util.Set;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.base.MDBaseAppservice;
import com.comtop.cap.bm.biz.info.appservice.BizObjDataItemAppService;
import com.comtop.cap.bm.biz.info.appservice.BizObjInfoAppService;
import com.comtop.cap.bm.biz.info.model.BizObjDataItemVO;
import com.comtop.cap.bm.biz.info.model.BizObjInfoVO;
import com.comtop.cap.bm.req.subfunc.appservice.ReqFunctionSubitemAppService;
import com.comtop.cap.bm.req.subfunc.model.ReqFunctionSubitemVO;
import com.comtop.cap.doc.service.AbstractWordDataAccessor;
import com.comtop.cap.doc.service.CommonDataManager;
import com.comtop.cap.doc.srs.model.BizObjectDataItemWithSubitemDTO;
import com.comtop.cap.doc.util.DocDataUtil;
import com.comtop.cap.document.util.CollectionUtils;
import com.comtop.cap.runtime.component.facade.AutoGenNumberFacade;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.core.AppBeanUtil;

/**
 * 业务对象数据项以及功能子项
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年12月28日 lizhongwen
 */
@PetiteBean
public class BizObjectDataItemWithSubitemDocAppservice extends
    AbstractWordDataAccessor<BizObjDataItemVO, BizObjectDataItemWithSubitemDTO> {
    
    /** 注入AppService **/
    @PetiteInject
    protected BizObjDataItemAppService bizObjDataItemAppService;
    
    /** 注入AppService **/
    @PetiteInject
    protected BizObjInfoAppService bizObjInfoAppService;
    
    /** 注入AppService **/
    @PetiteInject
    protected ReqFunctionSubitemAppService reqFunctionSubitemAppService;
    
    /**
     * 
     * @see com.comtop.cap.document.word.dao.IWordDataAccessor#loadData(java.lang.Object)
     */
    @Override
    public List<BizObjectDataItemWithSubitemDTO> loadData(BizObjectDataItemWithSubitemDTO condition) {
        String strSubitemId = condition.getSubitemId();
        ReqFunctionSubitemVO objSubitem = CommonDataManager.getReqFunctionSubitem(condition.getItemId(),
            condition.getSubitemName());
        List<BizObjectDataItemWithSubitemDTO> lstResult = new ArrayList<BizObjectDataItemWithSubitemDTO>();
        if (objSubitem == null) {
            objSubitem = reqFunctionSubitemAppService.loadReqFunctionSubitemById(strSubitemId);
            CommonDataManager.addReqFunctionSubitem(objSubitem);
        }
        if (objSubitem == null) {
            return lstResult;
        }
        String strBizObjIds = objSubitem.getBizObjectIds();
        if (StringUtils.isBlank(strBizObjIds)) {
            return lstResult;
        }
        String[] objIds = strBizObjIds.split(",");
        if (objIds == null || objIds.length < 1) {
            return lstResult;
        }
        List<BizObjDataItemVO> lstItems = bizObjDataItemAppService.loadBizObjDataItemsByIds(objIds);
        for (BizObjDataItemVO objItem : lstItems) {
            CommonDataManager.addBizObjDataItem(objItem);
            lstResult.add(this.vo2DTO(objItem));
        }
        return lstResult;
    }
    
    /**
     * 
     * @see com.comtop.cap.doc.service.AbstractWordDataAccessor#saveBizData(java.util.List)
     */
    @Override
    protected void saveBizData(List<BizObjectDataItemWithSubitemDTO> collection) {
        if (CollectionUtils.isEmpty(collection)) {
            return;
        }
        for (BizObjectDataItemWithSubitemDTO objDTO : collection) {
            this.saveOneData(objDTO);
        }
        
    }
    
    /**
     * 保存一条数据
     *
     * @param data 数据项
     */
    private void saveOneData(BizObjectDataItemWithSubitemDTO data) {
        if (data == null) {
            return;
        }
        String strSubitemId = data.getSubitemId();
        String strDomainId = data.getDomainId();
        String strDocumentId = data.getDocumentId();
        Map<String, String> colParams = new HashMap<String, String>();
        colParams.put("domainId", strDomainId);
        ReqFunctionSubitemVO objTemp = CommonDataManager.getReqFunctionSubitem(data.getItemId(), data.getSubitemName());
        if (objTemp == null) {
            objTemp = CommonDataManager.getTempReqFunctionSubitem(strSubitemId);
        }
        if (objTemp == null) {
            objTemp = new ReqFunctionSubitemVO();
            objTemp.setId(strSubitemId);
            CommonDataManager.addTempReqFunctionSubitem(objTemp);
        }
        String objName = data.getObjectName();
        BizObjInfoVO objInfo = updateBizObjInfo(data, strDomainId, strDocumentId, colParams, objName);
        updateBizObjectDataItem(data, objInfo);
        Set<String> lstIds = objTemp.getBizObjIds();
        if (lstIds == null || !lstIds.contains(objInfo.getId())) {
            String objIds = objTemp.getBizObjectIds();
            if (StringUtils.isBlank(objIds)) {
                objIds = objInfo.getId();
            } else {
                objIds = objIds + "," + objInfo.getId();
            }
            objTemp.setBizObjectIds(objIds);
        }
    }
    
    /**
     * 更新业务对象数据项
     *
     * @param data 数据
     * @param objInfo 业务对象
     */
    private void updateBizObjectDataItem(BizObjectDataItemWithSubitemDTO data, BizObjInfoVO objInfo) {
        BizObjDataItemVO objVO = CommonDataManager.getBizObjDataItem(data);
        if (objVO == null) {
            objVO = new BizObjDataItemVO();
            DocDataUtil.copyProperties(objVO, data);
            objVO.setBizObjId(objInfo.getId());
            if (objVO.getId() != null) {
                BizObjDataItemAppService objService = AppBeanUtil.getBean(BizObjDataItemAppService.class);
                objService.insert(objVO);
            }
            CommonDataManager.addBizObjDataItem(objVO);
        } else {
            boolean bUpdated = false;
            if (StringUtils.isBlank(objVO.getCodeNote()) && StringUtils.isNotBlank(data.getCodeNote())) {
                objVO.setCodeNote(data.getCodeNote());
                bUpdated = true;
            }
            if (StringUtils.isNotBlank(data.getRemark())) {
                if (StringUtils.isBlank(objVO.getRemark())) {
                    objVO.setRemark(data.getRemark());
                    bUpdated = true;
                } else if (!objVO.getRemark().contains(data.getRemark())) {
                    objVO.setRemark(objVO.getRemark() + "," + data.getRemark());
                    bUpdated = true;
                }
            }
            if (bUpdated) {
                CommonDataManager.addBizObjDataItem(objVO);
                bizObjDataItemAppService.updateBizObjDataItem(objVO);
            }
        }
    }
    
    /**
     * 更新业务对象
     *
     * @param data 数据
     * @param strDomainId 业务域ID
     * @param strDocumentId 文档ID
     * @param colParams 参数
     * @param objName 名称
     * @return 业务对象
     */
    private BizObjInfoVO updateBizObjInfo(BizObjectDataItemWithSubitemDTO data, String strDomainId,
        String strDocumentId, Map<String, String> colParams, String objName) {
        BizObjInfoVO objInfo = CommonDataManager.getBizObjInfo(strDomainId, objName);
        if (objInfo == null) { // 找不到业务对象
        	AutoGenNumberFacade autoGenNumberService = AppBeanUtil.getBean(AutoGenNumberFacade.class);
            objInfo = new BizObjInfoVO();
            objInfo.setDomainId(strDomainId);
            objInfo.setDocumentId(strDocumentId);
            String strCode = autoGenNumberService.genNumber(BizObjInfoVO.CODE_EXPR, colParams);
            objInfo.setCode(strCode);
            String strNumber = autoGenNumberService.genNumber(BizObjInfoVO.SORT_NO_EXPR, colParams);
            int iNumber = Integer.parseInt(strNumber);
            objInfo.setSortNo(iNumber);
            objInfo.setName(objName);
            objInfo.setDataFrom(1);
            objInfo.setDocumentId(strDocumentId);
            objInfo.setDescription(data.getObjectDesc());
            if (objInfo.getId() != null) {
                BizObjInfoAppService objService = AppBeanUtil.getBean(BizObjInfoAppService.class);
                objService.insert(objInfo);
            }
            CommonDataManager.addBizObjInfo(objInfo);
            data.setObjectId(objInfo.getId());
        } else {
            boolean bUpdated = false;
            if (StringUtils.isBlank(objInfo.getDescription()) && StringUtils.isNotBlank(data.getObjectDesc())) {
                objInfo.setDescription(data.getObjectDesc());
                bUpdated = true;
            }
            if (StringUtils.isBlank(objInfo.getCode()) && StringUtils.isNotBlank(data.getCode())) {
                objInfo.setCode(data.getCode());
                bUpdated = true;
            }
            if (bUpdated) {
                CommonDataManager.addBizObjInfo(objInfo);
                bizObjInfoAppService.update(objInfo);
            }
            data.setObjectId(objInfo.getId());
        }
        return objInfo;
    }
    
    /**
     * 获得appservice
     *
     * @return appservice
     * @see com.comtop.cap.doc.service.AbstractWordDataAccessor#getBaseAppservice()
     */
    @Override
    protected MDBaseAppservice<BizObjDataItemVO> getBaseAppservice() {
        return null;
    }
    
    /**
     * 将DTO转换为VO
     * 
     * @param dto dto
     * @return VO
     * @see com.comtop.cap.doc.service.AbstractWordDataAccessor#dto2VO(com.comtop.cap.document.word.docmodel.data.BaseDTO)
     */
    @Override
    protected BizObjDataItemVO dto2VO(BizObjectDataItemWithSubitemDTO dto) {
        BizObjDataItemVO objVO = new BizObjDataItemVO();
        DocDataUtil.copyProperties(objVO, dto);
        objVO.setBizObjId(dto.getObjectId());
        return objVO;
    }
    
    /**
     * 
     * @see com.comtop.cap.doc.service.AbstractWordDataAccessor#vo2DTO(com.comtop.top.core.base.model.CoreVO)
     */
    @Override
    protected BizObjectDataItemWithSubitemDTO vo2DTO(BizObjDataItemVO vo) {
        BizObjectDataItemWithSubitemDTO objDTO = new BizObjectDataItemWithSubitemDTO();
        DocDataUtil.copyProperties(objDTO, vo);
        objDTO.setObjectId(vo.getBizObjId());
        objDTO.setNewData(false);
        return objDTO;
    }
    
}
