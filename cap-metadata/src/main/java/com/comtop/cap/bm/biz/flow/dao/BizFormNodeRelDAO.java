/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.biz.flow.dao;

import java.util.List;

import com.comtop.cap.base.MDBaseDAO;
import com.comtop.cap.bm.biz.flow.model.BizFormNodeRelVO;
import com.comtop.cip.jodd.jtx.JtxPropagationBehavior;
import com.comtop.cip.jodd.jtx.meta.Transaction;
import com.comtop.cip.jodd.petite.meta.PetiteBean;

/**
 * 业务表单和业务流程节点关系表DAO
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-11-24 CAP
 */
@PetiteBean
public class BizFormNodeRelDAO extends MDBaseDAO<BizFormNodeRelVO> {
    
    /**
     * 新增 业务表单和业务流程节点关系表
     * 
     * @param bizFormNodeRel 业务表单和业务流程节点关系表对象
     * @return 业务表单和业务流程节点关系表Id
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public Object insertBizFormNodeRel(BizFormNodeRelVO bizFormNodeRel) {
        Object result = insert(bizFormNodeRel);
        return result;
    }
    
    /**
     * 更新 业务表单和业务流程节点关系表
     * 
     * @param bizFormNodeRel 业务表单和业务流程节点关系表对象
     * @return 更新成功与否
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean updateBizFormNodeRel(BizFormNodeRelVO bizFormNodeRel) {
        return update(bizFormNodeRel);
    }
    
    /**
     * 删除 业务表单和业务流程节点关系表
     * 
     * @param bizFormNodeRel 业务表单和业务流程节点关系表对象
     * @return 删除成功与否
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean deleteBizFormNodeRel(BizFormNodeRelVO bizFormNodeRel) {
        return delete(bizFormNodeRel);
    }
    
    /**
     * 读取 业务表单和业务流程节点关系表
     * 
     * @param bizFormNodeRel 业务表单和业务流程节点关系表对象
     * @return 业务表单和业务流程节点关系表
     */
    public BizFormNodeRelVO loadBizFormNodeRel(BizFormNodeRelVO bizFormNodeRel) {
        BizFormNodeRelVO objBizFormNodeRel = load(bizFormNodeRel);
        return objBizFormNodeRel;
    }
    
    /**
     * 根据业务表单和业务流程节点关系表主键读取 业务表单和业务流程节点关系表
     * 
     * @param id 业务表单和业务流程节点关系表主键
     * @return 业务表单和业务流程节点关系表
     */
    public BizFormNodeRelVO loadBizFormNodeRelById(String id) {
        BizFormNodeRelVO objBizFormNodeRel = new BizFormNodeRelVO();
        objBizFormNodeRel.setId(id);
        return loadBizFormNodeRel(objBizFormNodeRel);
    }
    
    /**
     * 读取 业务表单和业务流程节点关系表 列表
     * 
     * @param condition 查询条件
     * @return 业务表单和业务流程节点关系表列表
     */
    public List<BizFormNodeRelVO> queryBizFormNodeRelList(BizFormNodeRelVO condition) {
        return queryList("com.comtop.cap.bm.biz.flow.model.queryBizFormNodeRelList", condition, condition.getPageNo(),
            condition.getPageSize());
    }
    
    /**
     * 读取 业务表单和业务流程节点关系表 数据条数
     * 
     * @param condition 查询条件
     * @return 业务表单和业务流程节点关系表数据条数
     */
    public int queryBizFormNodeRelCount(BizFormNodeRelVO condition) {
        return ((Integer) selectOne("com.comtop.cap.bm.biz.flow.model.queryBizFormNodeRelCount", condition)).intValue();
    }
    
}
