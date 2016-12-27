/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.biz.form.appservice;

import java.util.List;

import com.comtop.cap.base.MDBaseAppservice;
import com.comtop.cap.base.MDBaseDAO;
import com.comtop.cap.bm.biz.form.dao.BizFormDAO;
import com.comtop.cap.bm.biz.form.dao.BizFormDataDAO;
import com.comtop.cap.bm.biz.form.model.BizFormVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 业务表单逻辑处理类
 * 
 * @author 姜子豪
 * @since 1.0
 * @version 2015-11-11 姜子豪
 */
@PetiteBean
public class BizFormAppService extends MDBaseAppservice<BizFormVO> {
    
    /** 注入DAO **/
    @PetiteInject
    protected BizFormDAO bizFormDAO;
    
    /** 注入DAO **/
    @PetiteInject
    protected BizFormDataDAO bizFormDataDAO;
    
    /**
     * 通过业务域ID查询业务表单
     * 
     * @param domainId 业务域ID
     * @param bizForm 业务表单
     * @return 业务表单对象
     */
    public List<BizFormVO> queryFormListByDomainId(String domainId, BizFormVO bizForm) {
        return bizFormDAO.queryFormListByDomainId(domainId, bizForm);
    }
    
    /**
     * 根据业务表单ID查询业务表单对象
     * 
     * @param formId 业务表单ID
     * @return 业务表单对象
     */
    public BizFormVO queryFormById(String formId) {
        return bizFormDAO.queryFormById(formId);
    }
    
    /**
     * 新增业务表单信息
     * 
     * @param bizForm 业务表单信息
     * @return 业务域业务表单ID
     */
    public String insertForm(BizFormVO bizForm) {
        return bizFormDAO.insertForm(bizForm);
    }
    
    /**
     * 修改业务表单信息
     * 
     * @param bizForm 业务表单信息
     */
    public void updateForm(BizFormVO bizForm) {
        bizFormDAO.updateForm(bizForm);
        
    }
    
    /**
     * 删除业务表单信息
     * 
     * @param formId 业务表单ID
     */
    public void deleteForm(String formId) {
        bizFormDataDAO.deleteDataByFormId(formId);
        bizFormDAO.deleteForm(formId);
    }
    
    /**
     * 查询业务表单数据条数
     * 
     * @param bizForm 业务表单ID
     * @return 业务表单对象
     */
    public int queryFormCount(BizFormVO bizForm) {
        return bizFormDAO.queryFormCount(bizForm);
    }
    
    /**
     * 查询业务表单数据条数
     * 
     * @param bizForm 业务表单ID
     * @return 业务表单对象
     */
    public int queryFormCountByDomainIdList(BizFormVO bizForm) {
        return bizFormDAO.queryFormCountByDomainIdList(bizForm);
    }
    
    /**
     * 查询业务表单
     * 
     * @param bizForm 业务表单信息
     * @return 业务表单对象
     */
    public List<BizFormVO> queryFormList(BizFormVO bizForm) {
        return bizFormDAO.queryFormList(bizForm);
    }
    
    /**
     * 查询业务表单
     * 
     * @param bizForm 业务表单信息
     * @return 业务表单对象
     */
    public List<BizFormVO> queryFormListByDomainIdList(BizFormVO bizForm) {
        return bizFormDAO.queryFormListByDomainIdList(bizForm);
    }
    
    /**
     * 通过业务域ID删除
     * 
     * @param domainId 业务域ID
     */
    public void deleteByDomainId(String domainId) {
        bizFormDAO.deleteByDomainId(domainId);
        bizFormDataDAO.deleteByDomainId(domainId);
    }
    
    /**
     * 查询业务表单是否被引用
     * 
     * @param bizFormId 业务表单ID
     * @return 结果
     */
    public int checkFormIsUse(String bizFormId) {
        return bizFormDataDAO.checkFormIsUse(bizFormId);
    }
    
    /**
     * 查询业务表单编码是否重复
     * 
     * @param bizForm 业务表单
     * @return 结果
     */
    public int checkFormCode(BizFormVO bizForm) {
        return bizFormDataDAO.checkFormCode(bizForm);
    }
    
    @Override
    protected MDBaseDAO<BizFormVO> getDAO() {
        return bizFormDAO;
    }
    
    /**
     * 加载不存在编码或排序号的数据
     * 
     * @return 数据集
     */
    public List<BizFormVO> loadBizFormNotExistCodeOrSortNo() {
        return bizFormDataDAO.queryList("com.comtop.cap.bm.biz.form.model.loadBizFormNotExistCodeOrSortNo", null);
    }
    
    /**
     * 加载不存在编码或排序号的数据
     * 
     * @param condition 条件
     * 
     * @return 数据集
     */
    public List<BizFormVO> loadBizFormVOListWithNoPackageId(BizFormVO condition) {
        return bizFormDataDAO.queryList("com.comtop.cap.bm.biz.form.model.loadBizFormVOListWithNoPackageId", condition);
    }
}
