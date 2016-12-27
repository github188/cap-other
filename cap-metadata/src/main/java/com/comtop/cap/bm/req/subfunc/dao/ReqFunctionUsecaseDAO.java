/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.req.subfunc.dao;
import java.util.List;

import com.comtop.cap.bm.req.subfunc.model.ReqFunctionUsecaseVO;
import com.comtop.cip.jodd.jtx.JtxPropagationBehavior;
import com.comtop.cip.jodd.jtx.meta.Transaction;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.top.core.base.dao.CoreDAO;
/**
 * 功能用例DAO
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-12-22 CAP
 */
@PetiteBean
public class ReqFunctionUsecaseDAO extends CoreDAO<ReqFunctionUsecaseVO> {
	 
     /**
     * 新增 功能用例
     * 
     * @param reqFunctionUsecase 功能用例对象
     * @return  功能用例Id
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED , readOnly = false)
    public Object insertReqFunctionUsecase(ReqFunctionUsecaseVO reqFunctionUsecase) {
        Object result = insert(reqFunctionUsecase);
        return result;
    }
    
    /**
     * 更新 功能用例
     * 
     * @param reqFunctionUsecase 功能用例对象
     * @return  更新成功与否
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED , readOnly = false)
    public boolean updateReqFunctionUsecase(ReqFunctionUsecaseVO reqFunctionUsecase) {
        return update(reqFunctionUsecase);
    }
    
    /**
     * 删除 功能用例
     * 
     * @param reqFunctionUsecase 功能用例对象
     * @return  删除成功与否
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED , readOnly = false)
    public boolean deleteReqFunctionUsecase(ReqFunctionUsecaseVO reqFunctionUsecase) {
        return delete(reqFunctionUsecase);
    }
    
    
    /**
     * 读取 功能用例
     * 
     * @param reqFunctionUsecase 功能用例对象
     * @return  功能用例
     */
    public ReqFunctionUsecaseVO loadReqFunctionUsecase(ReqFunctionUsecaseVO reqFunctionUsecase) {
    	ReqFunctionUsecaseVO objReqFunctionUsecase = load(reqFunctionUsecase);
        return objReqFunctionUsecase;
    }
    
    /**
     * 根据功能用例主键读取 功能用例
     * 
     * @param id 功能用例主键
     * @return  功能用例
     */
    public ReqFunctionUsecaseVO loadReqFunctionUsecaseById(String id) {
    	ReqFunctionUsecaseVO objReqFunctionUsecase = new ReqFunctionUsecaseVO();
    	objReqFunctionUsecase.setId(id);
        return loadReqFunctionUsecase(objReqFunctionUsecase);
    }
    
    /**
     * 读取 功能用例 列表
     * 
     * @param condition 查询条件
     * @return  功能用例列表
     */
    public List<ReqFunctionUsecaseVO> queryReqFunctionUsecaseList(ReqFunctionUsecaseVO condition) {
        return queryList("com.comtop.cap.bm.req.subfunc.model.queryReqFunctionUsecaseList", condition,condition.getPageNo(), condition.getPageSize());
    }
    
    /**
     * 读取 功能用例 数据条数
     * 
     * @param condition 查询条件
     * @return  功能用例数据条数
     */
    public int queryReqFunctionUsecaseCount(ReqFunctionUsecaseVO condition) {
        return ((Integer)selectOne("com.comtop.cap.bm.req.subfunc.model.queryReqFunctionUsecaseCount", condition)).intValue();
    }
}