/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.biz.form.dao;

import java.util.List;

import com.comtop.cap.base.MDBaseDAO;
import com.comtop.cap.bm.biz.form.model.BizFormDataVO;
import com.comtop.cap.bm.biz.form.model.BizFormVO;
import com.comtop.cip.jodd.jtx.JtxPropagationBehavior;
import com.comtop.cip.jodd.jtx.meta.Transaction;
import com.comtop.cip.jodd.petite.meta.PetiteBean;

/**
 * 业务表单数据项DAO
 * 
 * @author 姜子豪
 * @since 1.0
 * @version 2015-11-11 姜子豪
 */
@PetiteBean
public class BizFormDataDAO extends MDBaseDAO<BizFormDataVO> {
    
    /**
     * 通过业务表单ID查询业务表单数据
     * 
     * @param bizFormData 业务表单数据
     * @return 业务表单对象
     */
    public List<BizFormDataVO> queryFormDataListByFormId(BizFormDataVO bizFormData) {
        return queryList("com.comtop.cap.bm.biz.form.model.queryFormDataListByFormId", bizFormData);
    }
    
    /**
     * 通过业务表单ID查询业务表单数据项条数
     * 
     * @param bizFormData 业务表单数据
     * @return 业务表单数据项条数
     */
    public int queryFormDataCountByFormId(BizFormDataVO bizFormData) {
        return (Integer) selectOne("com.comtop.cap.bm.biz.form.model.queryFormDataCountByFormId", bizFormData);
    }
    
    /**
     * 更新业务表单数据项
     * 
     * @param bizFormData 业务表单数据项
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public void updateFormData(BizFormDataVO bizFormData) {
        super.update(bizFormData);
    }
    
    /**
     * 新增业务表单数据项
     * 
     * @param bizFormData 业务表单数据项
     * @return 保存结果
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public String insertFormData(BizFormDataVO bizFormData) {
        return (String) super.insert(bizFormData);
    }
    
    /**
     * 删除业务表单数据项
     * 
     * @param bizFormDataList 业务表单数据项
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public void deleteFormData(List<BizFormDataVO> bizFormDataList) {
        delete(bizFormDataList);
    }
    
    /**
     * 删除业务表单时删除相关数据项
     * 
     * @param formId 业务表单ID
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public void deleteDataByFormId(String formId) {
        super.delete("com.comtop.cap.bm.biz.form.model.deleteDataByFormId", formId);
    }
    
    /**
     * 通过业务域ID删除
     * 
     * @param domainId 业务域ID
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public void deleteByDomainId(String domainId) {
        super.delete("com.comtop.cap.bm.biz.form.model.deleteByDomainId", domainId);
    }
    
    /**
     * 查询业务表单是否被引用
     * 
     * @param bizFormId 业务表单ID
     * @return 结果
     */
    public int checkFormIsUse(String bizFormId) {
        return (Integer) selectOne("com.comtop.cap.bm.biz.form.model.checkFormIsUse", bizFormId);
    }
    
    /**
     * 查询业务表单编码是否重复
     * 
     * @param bizForm 业务表单
     * @return 结果
     */
    public int checkFormCode(BizFormVO bizForm) {
        return (Integer) selectOne("com.comtop.cap.bm.biz.form.model.checkFormCode", bizForm);
    }
}
