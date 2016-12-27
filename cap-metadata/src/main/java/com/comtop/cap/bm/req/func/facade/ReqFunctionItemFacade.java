/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.req.func.facade;

import java.util.HashMap;
import java.util.Map;

import com.comtop.cap.bm.biz.domain.model.BizDomainVO;
import com.comtop.cap.bm.req.func.appservice.ReqFunctionItemAppService;
import com.comtop.cap.bm.req.func.model.ReqFunctionItemVO;
import com.comtop.cap.doc.service.CommonDataManager;
import com.comtop.cap.runtime.component.facade.AutoGenNumberFacade;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.base.facade.BaseFacade;
import com.comtop.cap.runtime.core.AppBeanUtil;

/**
 * 功能项，建立在系统、子系统、目录下面。扩展实现
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-11-25 CAP
 */
@PetiteBean
public class ReqFunctionItemFacade extends BaseFacade {
    
    /** 注入AppService **/
    @PetiteInject
    protected ReqFunctionItemAppService reqFunctionItemAppService;
    
    /**
     * 新增 功能项
     * 
     * @param reqFunctionItemVO 功能项
     * @return ID
     */
    public String insertReqFunctionItem(ReqFunctionItemVO reqFunctionItemVO) {
        String domainId = reqFunctionItemVO.getBizDomainId();
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("domainId", domainId);
        AutoGenNumberFacade autoGenNumberService = AppBeanUtil.getBean(AutoGenNumberFacade.class);
        String no = autoGenNumberService.genNumber(ReqFunctionItemVO.SORT_EXPR, params);
        int number = Integer.parseInt(no);
        reqFunctionItemVO.setSortNo(number);
        BizDomainVO domainVo = CommonDataManager.getBizDomainVO(domainId);
        if (domainVo != null) {
            params.put("domainCode", domainVo.getCode());
        }
        String code = autoGenNumberService.genNumber(ReqFunctionItemVO.CODE_EXPR, params);
        reqFunctionItemVO.setCode(code);
        return reqFunctionItemAppService.insertReqFunctionItem(reqFunctionItemVO);
    }
    
    /**
     * 更新 功能项
     * 
     * @param reqFunctionItemVO 功能项
     * @return 更新结果
     */
    public boolean updateReqFunctionItem(ReqFunctionItemVO reqFunctionItemVO) {
        return reqFunctionItemAppService.updateReqFunctionItem(reqFunctionItemVO);
    }
    
    /**
     * 保存或更新功能项，建立在系统、子系统、目录下面。，根据ID是否为空
     * 
     * @param reqFunctionItemVO 功能项，建立在系统、子系统、目录下面。ID
     * @return 功能项，建立在系统、子系统、目录下面。保存后的主键ID
     */
    public String saveReqFunctionItem(ReqFunctionItemVO reqFunctionItemVO) {
        if (reqFunctionItemVO.getId() == null) {
            String strId = this.insertReqFunctionItem(reqFunctionItemVO);
            reqFunctionItemVO.setId(strId);
        } else {
            this.updateReqFunctionItem(reqFunctionItemVO);
        }
        return reqFunctionItemVO.getId();
    }
    
    /**
     * 删除 功能项
     * 
     * @param reqFunctionItemVO 功能项
     * @return 删除结果
     */
    public boolean deleteReqFunctionItem(ReqFunctionItemVO reqFunctionItemVO) {
        return reqFunctionItemAppService.deleteReqFunctionItem(reqFunctionItemVO);
    }
    
    /**
     * 通过功能项ID查询功能项
     * 
     * @param reqFunctionItemId 功能项ID
     * @return 功能项对象
     */
    public ReqFunctionItemVO queryReqFunctionItemById(String reqFunctionItemId) {
        return reqFunctionItemAppService.queryReqFunctionItemById(reqFunctionItemId);
    }
    
    /**
     * 检查功能项编码是否重复
     * 
     * @param reqFunctionItem 功能项
     * @return 结果
     */
    public int checkReqFunItemCode(ReqFunctionItemVO reqFunctionItem) {
        return reqFunctionItemAppService.checkReqFunItemCode(reqFunctionItem);
    }
    
    /**
     * 更新 排序号
     * 
     * @param reqFunctionItemVO 功能项
     *
     */
    public void updateSortNoById(ReqFunctionItemVO reqFunctionItemVO) {
        reqFunctionItemAppService.updateSortNoById(reqFunctionItemVO);
    }
    
    /**
     * 查询功能项是否有关联子项
     * 
     * @param reqFunctionItem 功能项
     * @return 结果
     */
    public boolean checkSubFunByFunItem(ReqFunctionItemVO reqFunctionItem) {
        return reqFunctionItemAppService.checkSubFunByFunItem(reqFunctionItem);
    }
    
    /**
     * 
     * 检查功能项是否重名
     * 
     * @param reqFunctionItem 功能项
     * @return 结果
     */
    public boolean checkFuncItemName(ReqFunctionItemVO reqFunctionItem) {
        return reqFunctionItemAppService.checkFuncItemName(reqFunctionItem);
    }
    
}
