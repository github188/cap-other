/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.req.func.dao;

import java.util.List;

import com.comtop.cap.bm.req.func.model.ReqFunctionRelItemsVO;
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
public class ReqFunctionRelItemsDAO extends CoreDAO<ReqFunctionRelItemsVO> {
    
    /**
     * 
     * 新增关联关系
     *
     * @param itemsVO 关联
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public void insertRelationToFunItem(ReqFunctionRelItemsVO itemsVO) {
        super.insert(itemsVO);
    }
    
    /**
     * 
     * 删除功能项相关关联关系
     * 
     * @param funItemId 功能项id
     */
    public void deleteFunctionRelItemByFunItemId(String funItemId) {
        super.delete("com.comtop.cap.bm.req.func.model.deleteFunctionRelItemByFunItemId", funItemId);
    }
    
    /**
     * 
     * FIXME 方法注释信息(此标记由Eclipse自动生成,请填写注释信息删除此标记)
     *
     * @param reqFunctionItemId 功能项Id
     * @return 流程
     */
    public List<ReqFunctionRelItemsVO> getRelItemListByFunItemId(String reqFunctionItemId) {
        return queryList("com.comtop.cap.bm.req.func.model.getRelItemListByFunItemId", reqFunctionItemId);
    }
}
