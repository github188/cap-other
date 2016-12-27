/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.biz.form.dao;

import java.util.List;

import com.comtop.cap.base.MDBaseDAO;
import com.comtop.cap.bm.biz.form.model.BizFormVO;
import com.comtop.cip.jodd.jtx.JtxPropagationBehavior;
import com.comtop.cip.jodd.jtx.meta.Transaction;
import com.comtop.cip.jodd.petite.meta.PetiteBean;

/**
 * 业务表单DAO
 * 
 * @author 姜子豪
 * @since 1.0
 * @version 2015-11-11 姜子豪
 */
@PetiteBean
public class BizFormDAO extends MDBaseDAO<BizFormVO> {
    
    /**
     * 通过业务域ID查询业务表单
     * 
     * @param domainId 业务域ID
     * @param bizForm 业务表单
     * @return 业务表单对象
     */
    public List<BizFormVO> queryFormListByDomainId(String domainId, BizFormVO bizForm) {
        bizForm.setDomainId(domainId);
        return queryList("com.comtop.cap.bm.biz.form.model.queryFormListByDomainId", bizForm);
    }
    
    /**
     * 根据业务表单ID查询业务表单对象
     * 
     * @param formId 业务表单ID
     * @return 业务表单对象
     */
    public BizFormVO queryFormById(String formId) {
        return (BizFormVO) selectOne("com.comtop.cap.bm.biz.form.model.queryFormById", formId);
    }
    
    /**
     * 查询业务表单数据条数
     * 
     * @param bizForm 业务表单ID
     * @return 业务表单对象
     */
    public int queryFormCount(BizFormVO bizForm) {
        return (Integer) selectOne("com.comtop.cap.bm.biz.form.model.queryFormCount", bizForm);
    }
    
    /**
     * 查询业务表单数据条数
     * 
     * @param bizForm 业务表单ID
     * @return 业务表单对象
     */
    public int queryFormCountByDomainIdList(BizFormVO bizForm) {
        return (Integer) selectOne("com.comtop.cap.bm.biz.form.model.queryFormCountByDomainIdList", bizForm);
    }
    
    /**
     * 新增业务表单信息
     * 
     * @param bizForm 业务表单信息
     * @return 业务域业务表单ID
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public String insertForm(BizFormVO bizForm) {
        int sortNo = getFormMaxSort(bizForm) + 1;
        bizForm.setSortNo(sortNo);
        return (String) super.insert(bizForm);
    }
    
    /**
     * 修改业务表单信息
     * 
     * @param bizForm 业务表单信息
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public void updateForm(BizFormVO bizForm) {
        super.update(bizForm);
    }
    
    /**
     * 删除业务表单信息
     * 
     * @param formId 业务表单ID
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public void deleteForm(String formId) {
        super.delete("com.comtop.cap.bm.biz.form.model.deleteForm", formId);
    }
    
    /**
     * 查询业务表单
     * 
     * @param bizForm 业务表单信息
     * @return 业务表单对象
     */
    public List<BizFormVO> queryFormList(BizFormVO bizForm) {
        return queryList("com.comtop.cap.bm.biz.form.model.queryFormList", bizForm, bizForm.getPageNo(), bizForm.getPageSize());
    }
    
    /**
     * 查询业务表单
     * 
     * @param bizForm 业务表单信息
     * @return 业务表单对象
     */
    public List<BizFormVO> queryFormListByDomainIdList(BizFormVO bizForm) {
        return queryList("com.comtop.cap.bm.biz.form.model.queryFormListByDomainIdList", bizForm, bizForm.getPageNo(), bizForm.getPageSize());
    }
    
    /**
     * 通过业务域ID删除
     * 
     * @param domainId 业务域ID
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public void deleteByDomainId(String domainId) {
        super.delete("com.comtop.cap.bm.biz.form.model.deleteFormByDomainId", domainId);
    }
    
    /**
     * 获取业务表单排序号最大值
     * 
     * @param bizForm 业务表单
     * @return 结果
     */
    public int getFormMaxSort(BizFormVO bizForm) {
        Object maxt = selectOne("com.comtop.cap.bm.biz.form.model.getFormMaxSort", bizForm);
        return maxt == null ? 0 : ((Integer) maxt).intValue();
    }
}
