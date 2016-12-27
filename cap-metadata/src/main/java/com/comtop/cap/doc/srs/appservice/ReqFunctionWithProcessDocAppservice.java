/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.srs.appservice;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.base.MDBaseAppservice;
import com.comtop.cap.bm.biz.flow.appservice.BizProcessInfoAppService;
import com.comtop.cap.bm.biz.flow.model.BizProcessInfoVO;
import com.comtop.cap.bm.req.func.appservice.ReqFunctionItemAppService;
import com.comtop.cap.bm.req.func.model.ReqFunctionItemVO;
import com.comtop.cap.bm.req.func.model.ReqFunctionRelFlowVO;
import com.comtop.cap.doc.service.AbstractWordDataAccessor;
import com.comtop.cap.doc.service.CommonDataManager;
import com.comtop.cap.doc.srs.model.ReqFunctionWithProcessDTO;
import com.comtop.cap.document.util.CollectionUtils;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 业务功能项关联业务流程
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年12月28日 lizhongwen
 */
@PetiteBean
public class ReqFunctionWithProcessDocAppservice extends
    AbstractWordDataAccessor<ReqFunctionItemVO, ReqFunctionWithProcessDTO> {
    
    /** 注入AppService **/
    @PetiteInject
    protected ReqFunctionItemDocAppservice reqFunctionItemDocAppservice;
    
    /** 注入AppService **/
    @PetiteInject
    protected ReqFunctionItemAppService reqFunctionItemAppService;
    
    /** 注入AppService **/
    @PetiteInject
    protected BizProcessInfoAppService bizProcessInfoAppService;
    
    /**
     * 据据条件加载数据
     *
     * @param condition 条件集
     * @return 加载的数据结构 List 表示对象集合
     * @see com.comtop.cap.document.word.dao.IWordDataAccessor#loadData(java.lang.Object)
     */
    @Override
    public List<ReqFunctionWithProcessDTO> loadData(ReqFunctionWithProcessDTO condition) {
        List<ReqFunctionWithProcessDTO> lstResult = reqFunctionItemDocAppservice
            .queryReqFunctionItemWithProcess(condition);
        for (ReqFunctionWithProcessDTO objProcess : lstResult) {
            objProcess.getItImpStr();
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
    protected void saveBizData(List<ReqFunctionWithProcessDTO> collection) {
        if (CollectionUtils.isEmpty(collection)) {
            return;
        }
        for (ReqFunctionWithProcessDTO objDTO : collection) {
            saveOneData(objDTO);
        }
    }
    
    /**
     * 保存一条数据
     *
     * @param data dto
     */
    private void saveOneData(ReqFunctionWithProcessDTO data) {
        ReqFunctionItemVO objItem = CommonDataManager.getReqFunctionItem(data.getDomainId(), data.getItemName());
        if (objItem == null) {
            return;
        }
        objItem.setReqAnalysis(data.getReqAnalysis());
        objItem.setItImp(data.getItImp());
        if (StringUtils.isNotBlank(data.getItemCode())) {// 更新编码
            objItem.setCode(data.getItemCode());
        }
        BizProcessInfoVO objCondition = new BizProcessInfoVO();
        if (StringUtils.isNotBlank(data.getName()) && !"无".equals(data.getName())) {
            objCondition.setProcessName(data.getName());
            objCondition.setDomainId(data.getDomainId());
            List<BizProcessInfoVO> lstInfos = bizProcessInfoAppService.loadList(objCondition);
            if (!CollectionUtils.isEmpty(lstInfos)) {
                BizProcessInfoVO objInfo = lstInfos.get(0);
                ReqFunctionRelFlowVO objFlow = new ReqFunctionRelFlowVO();
                objFlow.setBizFlowId(objInfo.getId());
                objFlow.setBizFlowName(objInfo.getProcessName());
                objFlow.setFunctionItemId(objItem.getId());
                List<ReqFunctionRelFlowVO> lstFlows = new ArrayList<ReqFunctionRelFlowVO>();
                lstFlows.add(objFlow);
                objItem.setReqFunctionRelFlow(lstFlows);
                
            }
        }
        reqFunctionItemAppService.updateReqFunctionItem(objItem);
    }
    
    /**
     * 获得appservice
     *
     * @return appservice
     * @see com.comtop.cap.doc.service.AbstractWordDataAccessor#getBaseAppservice()
     */
    @Override
    protected MDBaseAppservice<ReqFunctionItemVO> getBaseAppservice() {
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
    protected ReqFunctionItemVO dto2VO(ReqFunctionWithProcessDTO data) {
        return null;
    }
    
    /**
     * VO转换为DTO .一般情况下，子类应该重写本方法
     *
     * @param vo vo
     * @return DTO
     * @see com.comtop.cap.doc.service.AbstractWordDataAccessor#vo2DTO(com.comtop.top.core.base.model.CoreVO)
     */
    @Override
    protected ReqFunctionWithProcessDTO vo2DTO(ReqFunctionItemVO vo) {
        return null;
    }
    
}
