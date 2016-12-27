/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.biz.form.facade;

import java.util.List;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.bm.biz.form.appservice.BizFormAppService;
import com.comtop.cap.bm.biz.form.model.BizFormVO;
import com.comtop.cap.doc.util.DocDataUtil;
import com.comtop.cap.runtime.component.facade.AutoGenNumberFacade;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.base.facade.BaseFacade;
import com.comtop.cap.runtime.core.AppBeanUtil;

/**
 * 业务表单逻辑处理类
 * 
 * @author 姜子豪
 * @since 1.0
 * @version 2015-11-11 姜子豪
 */
@PetiteBean
public class BizFormFacade extends BaseFacade {
    
    /** 注入AppService **/
    @PetiteInject
    protected BizFormAppService bizFormAppService;
    
    /** 注入AppService **/
    @PetiteInject
    protected BizFormDataFacade bizFormDataFacade;
    
    /**
     * 通过业务域ID查询业务表单
     * 
     * @param domainId 业务域ID
     * @param bizForm 业务表单
     * @return 业务表单对象
     */
    public List<BizFormVO> queryFormListByDomainId(String domainId, BizFormVO bizForm) {
        return bizFormAppService.queryFormListByDomainId(domainId, bizForm);
    }
    
    /**
     * 根据业务表单ID查询业务表单对象
     * 
     * @param formId 业务表单ID
     * @return 业务表单对象
     */
    public BizFormVO queryFormById(String formId) {
        return bizFormAppService.queryFormById(formId);
    }
    
    /**
     * 新增业务表单信息
     * 
     * @param bizForm 业务表单信息
     * @return 业务域业务表单ID
     */
    public String insertForm(BizFormVO bizForm) {
        AutoGenNumberFacade autoGenNumberService = AppBeanUtil.getBean(AutoGenNumberFacade.class);
        String code = autoGenNumberService.genNumber(BizFormVO.getCodeExpr(), null);
        bizForm.setCode(code);
        return bizFormAppService.insertForm(bizForm);
    }
    
    /**
     * 修改业务表单信息
     * 
     * @param bizForm 业务表单信息
     */
    public void updateForm(BizFormVO bizForm) {
        bizFormAppService.updateForm(bizForm);
        
    }
    
    /**
     * 删除业务表单信息
     * 
     * @param formId 业务表单ID
     */
    public void deleteForm(String formId) {
        bizFormAppService.deleteForm(formId);
    }
    
    /**
     * 查询业务表单数据条数
     * 
     * @param bizForm 业务表单ID
     * @return 业务表单对象
     */
    public int queryFormCount(BizFormVO bizForm) {
        return bizFormAppService.queryFormCount(bizForm);
    }
    
    /**
     * 查询业务表单数据条数
     * 
     * @param bizForm 业务表单ID
     * @return 业务表单对象
     */
    public int queryFormCountByDomainIdList(BizFormVO bizForm) {
        return bizFormAppService.queryFormCountByDomainIdList(bizForm);
    }
    
    /**
     * 查询业务表单
     * 
     * @param bizForm 业务表单信息
     * @return 业务表单对象
     */
    public List<BizFormVO> queryFormList(BizFormVO bizForm) {
        return bizFormAppService.queryFormList(bizForm);
    }
    
    /**
     * 查询业务表单
     * 
     * @param bizForm 业务表单信息
     * @return 业务表单对象
     */
    public List<BizFormVO> queryFormListByDomainIdList(BizFormVO bizForm) {
        return bizFormAppService.queryFormListByDomainIdList(bizForm);
    }
    
    /**
     * 查询业务表单是否被引用
     * 
     * @param bizFormId 业务表单ID
     * @return 结果
     */
    public int checkFormIsUse(String bizFormId) {
        return bizFormAppService.checkFormIsUse(bizFormId);
    }
    
    /**
     * 查询业务表单编码是否重复
     * 
     * @param bizForm 业务表单
     * @return 结果
     */
    public int checkFormCode(BizFormVO bizForm) {
        return bizFormAppService.checkFormCode(bizForm);
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
}
