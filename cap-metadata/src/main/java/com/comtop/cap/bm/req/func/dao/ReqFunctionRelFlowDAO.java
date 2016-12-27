/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.req.func.dao;

import java.util.List;

import com.comtop.cap.bm.req.func.model.ReqFunctionRelFlowVO;
import com.comtop.cip.jodd.jtx.JtxPropagationBehavior;
import com.comtop.cip.jodd.jtx.meta.Transaction;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.top.core.base.dao.CoreDAO;

/**
 * 功能项与流程关联DAO
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-11-25 CAP
 */
@PetiteBean
public class ReqFunctionRelFlowDAO extends CoreDAO<ReqFunctionRelFlowVO> {
    
    /**
     * 
     * 删除关联关系
     *
     * @param flowVO 关联
     */
    
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public void deleteRelByFlowVO(ReqFunctionRelFlowVO flowVO) {
        super.delete(flowVO);
    }
    
    /**
     * 
     * 新增关联关系
     *
     * @param flowVO 关联
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public void insertRelation(ReqFunctionRelFlowVO flowVO) {
        super.insert(flowVO);
    }
    
    /**
     * 
     * 删除功能项相关关联关系
     * 
     * @param funItemId 功能项id
     */
    public void deleteFunctionRelFlowByFunItemId(String funItemId) {
        super.delete("com.comtop.cap.bm.req.func.model.deleteFunctionRelFlowByFunItemId", funItemId);
    }
    
    /**
     * 
     * FIXME 方法注释信息(此标记由Eclipse自动生成,请填写注释信息删除此标记)
     *
     * @param reqFunctionItemId 功能项Id
     * @return 流程
     */
    public List<ReqFunctionRelFlowVO> getRelFlowListByFunItemId(String reqFunctionItemId) {
        return queryList("com.comtop.cap.bm.req.func.model.getRelFlowListByFunItemId", reqFunctionItemId);
    }
}
