/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.biz.flow.dao;

import java.util.List;

import com.comtop.cap.base.MDBaseDAO;
import com.comtop.cap.bm.biz.flow.model.BizNodeConstraintVO;
import com.comtop.cip.jodd.jtx.JtxPropagationBehavior;
import com.comtop.cip.jodd.jtx.meta.Transaction;
import com.comtop.cip.jodd.petite.meta.PetiteBean;

/**
 * 流程节点数据项约束DAO
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-11-20 CAP
 */
@PetiteBean
public class BizNodeConstraintDAO extends MDBaseDAO<BizNodeConstraintVO> {
    
    /**
     * 新增 流程节点数据项约束
     * 
     * @param bizNodeConstraint 流程节点数据项约束对象
     * @return 流程节点数据项约束Id
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public Object insertBizNodeConstraint(BizNodeConstraintVO bizNodeConstraint) {
        Object result = insert(bizNodeConstraint);
        return result;
    }
    
    /**
     * 更新 流程节点数据项约束
     * 
     * @param bizNodeConstraint 流程节点数据项约束对象
     * @return 更新成功与否
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean updateBizNodeConstraint(BizNodeConstraintVO bizNodeConstraint) {
        return update(bizNodeConstraint);
    }
    
    /**
     * 删除 流程节点数据项约束
     * 
     * @param bizNodeConstraint 流程节点数据项约束对象
     * @return 删除成功与否
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean deleteBizNodeConstraint(BizNodeConstraintVO bizNodeConstraint) {
        return delete(bizNodeConstraint);
    }
    
    /**
     * 读取 流程节点数据项约束
     * 
     * @param bizNodeConstraint 流程节点数据项约束对象
     * @return 流程节点数据项约束
     */
    public BizNodeConstraintVO loadBizNodeConstraint(BizNodeConstraintVO bizNodeConstraint) {
        BizNodeConstraintVO objBizNodeConstraint = load(bizNodeConstraint);
        return objBizNodeConstraint;
    }
    
    /**
     * 根据流程节点数据项约束主键读取 流程节点数据项约束
     * 
     * @param id 流程节点数据项约束主键
     * @return 流程节点数据项约束
     */
    public BizNodeConstraintVO loadBizNodeConstraintById(String id) {
        BizNodeConstraintVO objBizNodeConstraint = new BizNodeConstraintVO();
        objBizNodeConstraint.setId(id);
        return loadBizNodeConstraint(objBizNodeConstraint);
    }
    
    /**
     * 读取 流程节点数据项约束 列表
     * 
     * @param condition 查询条件
     * @return 流程节点数据项约束列表
     */
    public List<BizNodeConstraintVO> queryBizNodeConstraintList(BizNodeConstraintVO condition) {
        return queryList("com.comtop.cap.bm.biz.flow.model.queryBizNodeConstraintList", condition,
            condition.getPageNo(), condition.getPageSize());
    }
    
    /**
     * 读取 流程节点数据项约束 数据条数
     * 
     * @param condition 查询条件
     * @return 流程节点数据项约束数据条数
     */
    public int queryBizNodeConstraintCount(BizNodeConstraintVO condition) {
        return ((Integer) selectOne("com.comtop.cap.bm.biz.flow.model.queryBizNodeConstraintCount", condition))
            .intValue();
    }
    
    /**
     * 读取 流程节点数据项约束 列表
     * 
     * @param condition 查询条件
     * @return 流程节点数据项约束列表
     */
    public List<BizNodeConstraintVO> queryBizNodeConstraintGroupObjId(BizNodeConstraintVO condition) {
        return queryList("com.comtop.cap.bm.biz.flow.model.queryBizNodeConstraintGroupObjId", condition);
    }
    
    /**
     * 删除流程节点数据项约束
     * 
     * @param bizNodeConstraintVO 流程节点数据项约束集合
     */
    public void deleteBizNodeConstraintByObjId(BizNodeConstraintVO bizNodeConstraintVO) {
        super.execute("delete from CAP_BIZ_NODE_CONSTRAINT where BIZ_OBJ_ID='" + bizNodeConstraintVO.getBizObjId()
            + "' AND NODE_ID ='" + bizNodeConstraintVO.getNodeId() + "'");
    }
}
