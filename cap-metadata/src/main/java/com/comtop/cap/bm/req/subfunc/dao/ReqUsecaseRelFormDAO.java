/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.req.subfunc.dao;
import java.util.List;

import com.comtop.cap.bm.req.subfunc.model.ReqUsecaseRelFormVO;
import com.comtop.cip.jodd.jtx.JtxPropagationBehavior;
import com.comtop.cip.jodd.jtx.meta.Transaction;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.top.core.base.dao.CoreDAO;
/**
 * 功能用例关联业务表单DAO
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-12-22 CAP
 */
@PetiteBean
public class ReqUsecaseRelFormDAO extends CoreDAO<ReqUsecaseRelFormVO> {
	 
     /**
     * 新增 功能用例关联业务表单
     * 
     * @param reqUsecaseRelForm 功能用例关联业务表单对象
     * @return  功能用例关联业务表单Id
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED , readOnly = false)
    public Object insertReqUsecaseRelForm(ReqUsecaseRelFormVO reqUsecaseRelForm) {
        Object result = insert(reqUsecaseRelForm);
        return result;
    }
    
    /**
     * 更新 功能用例关联业务表单
     * 
     * @param reqUsecaseRelForm 功能用例关联业务表单对象
     * @return  更新成功与否
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED , readOnly = false)
    public boolean updateReqUsecaseRelForm(ReqUsecaseRelFormVO reqUsecaseRelForm) {
        return update(reqUsecaseRelForm);
    }
    
    /**
     * 删除 功能用例关联业务表单
     * 
     * @param reqUsecaseRelForm 功能用例关联业务表单对象
     * @return  删除成功与否
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED , readOnly = false)
    public boolean deleteReqUsecaseRelForm(ReqUsecaseRelFormVO reqUsecaseRelForm) {
        return delete(reqUsecaseRelForm);
    }
    
    
    /**
     * 读取 功能用例关联业务表单
     * 
     * @param reqUsecaseRelForm 功能用例关联业务表单对象
     * @return  功能用例关联业务表单
     */
    public ReqUsecaseRelFormVO loadReqUsecaseRelForm(ReqUsecaseRelFormVO reqUsecaseRelForm) {
    	ReqUsecaseRelFormVO objReqUsecaseRelForm = load(reqUsecaseRelForm);
        return objReqUsecaseRelForm;
    }
    
    /**
     * 根据功能用例关联业务表单主键读取 功能用例关联业务表单
     * 
     * @param id 功能用例关联业务表单主键
     * @return  功能用例关联业务表单
     */
    public ReqUsecaseRelFormVO loadReqUsecaseRelFormById(String id) {
    	ReqUsecaseRelFormVO objReqUsecaseRelForm = new ReqUsecaseRelFormVO();
    	objReqUsecaseRelForm.setId(id);
        return loadReqUsecaseRelForm(objReqUsecaseRelForm);
    }
    
    /**
     * 读取 功能用例关联业务表单 列表
     * 
     * @param condition 查询条件
     * @return  功能用例关联业务表单列表
     */
    public List<ReqUsecaseRelFormVO> queryReqUsecaseRelFormList(ReqUsecaseRelFormVO condition) {
        return queryList("com.comtop.cap.bm.req.subfunc.model.queryReqUsecaseRelFormList", condition,condition.getPageNo(), condition.getPageSize());
    }
    
    /**
     * 读取 功能用例关联业务表单 数据条数
     * 
     * @param condition 查询条件
     * @return  功能用例关联业务表单数据条数
     */
    public int queryReqUsecaseRelFormCount(ReqUsecaseRelFormVO condition) {
        return ((Integer)selectOne("com.comtop.cap.bm.req.subfunc.model.queryReqUsecaseRelFormCount", condition)).intValue();
    }

    /**
     * 读取功能用例关联业务表单
     * 
     * @param subitemId 功能用例ID
     * @return 功能用例关联业务表单
     */
	public ReqUsecaseRelFormVO queryReqUsecaseRelFormBysubitemId(
			String subitemId) {
		 return (ReqUsecaseRelFormVO)selectOne("com.comtop.cap.bm.req.subfunc.model.queryReqUsecaseRelFormBysubitemId", subitemId);
	}

	/**
     * 删除原有的功能用例关联业务表单
     * 
     * @param subitemId 功能用例ID
     */
	public void deleteReqUsecaseRelFormByUsecaseId(String subitemId) {
		super.execute("delete from CAP_REQ_USECASE_REL_FORM where USECASE_ID='"+subitemId+"'");
	}
    
    
    
    
    
}