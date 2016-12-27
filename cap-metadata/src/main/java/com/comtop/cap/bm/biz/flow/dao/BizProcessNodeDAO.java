/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.biz.flow.dao;

import java.util.List;

import com.comtop.cap.base.MDBaseDAO;
import com.comtop.cap.bm.biz.flow.model.BizProcessNodeVO;
import com.comtop.cip.jodd.jtx.JtxPropagationBehavior;
import com.comtop.cip.jodd.jtx.meta.Transaction;
import com.comtop.cip.jodd.petite.meta.PetiteBean;

/**
 * 业务流程节点DAO
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-11-16 CAP
 */
@PetiteBean
public class BizProcessNodeDAO extends MDBaseDAO<BizProcessNodeVO> {
    
    /**
     * 新增 业务流程节点
     * 
     * @param bizProcessNode 业务流程节点对象
     * @return 业务流程节点Id
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public Object insertBizProcessNode(BizProcessNodeVO bizProcessNode) {
        BizProcessNodeVO bizProcessNodeVO = new BizProcessNodeVO();
        bizProcessNodeVO.setProcessId(bizProcessNode.getProcessId());
        int sortNo = 1;
        sortNo += this.queryBizProcessNodeCount(bizProcessNodeVO);
        bizProcessNode.setSortNo(sortNo);
        Object result = insert(bizProcessNode);
        return result;
    }
    
    /**
     * 更新 业务流程节点
     * 
     * @param bizProcessNode 业务流程节点对象
     * @return 更新成功与否
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean updateBizProcessNode(BizProcessNodeVO bizProcessNode) {
        return update(bizProcessNode);
    }
    
    /**
     * 删除 业务流程节点
     * 
     * @param bizProcessNode 业务流程节点对象
     * @return 删除成功与否
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean deleteBizProcessNode(BizProcessNodeVO bizProcessNode) {
        return delete(bizProcessNode);
    }
    
    /**
     * 读取 业务流程节点
     * 
     * @param bizProcessNode 业务流程节点对象
     * @return 业务流程节点
     */
    public BizProcessNodeVO loadBizProcessNode(BizProcessNodeVO bizProcessNode) {
        BizProcessNodeVO objBizProcessNode = load(bizProcessNode);
        return objBizProcessNode;
    }
    
    /**
     * 根据业务流程节点主键读取 业务流程节点
     * 
     * @param id 业务流程节点主键
     * @return 业务流程节点
     */
    public BizProcessNodeVO loadBizProcessNodeById(String id) {
        BizProcessNodeVO objBizProcessNode = new BizProcessNodeVO();
        objBizProcessNode.setId(id);
        return loadBizProcessNode(objBizProcessNode);
    }
    
    /**
     * 读取 业务流程节点 列表
     * 
     * @param condition 查询条件
     * @return 业务流程节点列表
     */
    public List<BizProcessNodeVO> queryBizProcessNodeList(BizProcessNodeVO condition) {
        return queryList("com.comtop.cap.bm.biz.flow.model.queryBizProcessNodeList", condition, condition.getPageNo(),
            condition.getPageSize());
    }
    
    /**
     * 读取 业务流程节点 列表(不分页)
     * 
     * @param condition 查询条件
     * @return 业务流程节点列表
     */
    public List<BizProcessNodeVO> queryBizProcessNodeListNoPaging(BizProcessNodeVO condition) {
        return queryList("com.comtop.cap.bm.biz.flow.model.queryBizProcessNodeList", condition);
    }
    
    /**
     * 读取 业务流程节点 数据条数
     * 
     * @param condition 查询条件
     * @return 业务流程节点数据条数
     */
    public int queryBizProcessNodeCount(BizProcessNodeVO condition) {
        return ((Integer) selectOne("com.comtop.cap.bm.biz.flow.model.queryBizProcessNodeCount", condition)).intValue();
    }
    
    /**
     * 查询流程节点(提供选择界面)
     * 
     * @param bizProcessNode 业务流程节点
     * @return 业务流程节点对象
     */
    public List<BizProcessNodeVO> queryNodeListForChoose(BizProcessNodeVO bizProcessNode) {
        return queryList("com.comtop.cap.bm.biz.flow.model.queryNodeListForChoose", bizProcessNode);
    }
    
    /**
     * 查询流程节点(提供选择界面)ById
     * 
     * @param bizProcessNode 业务流程节点
     * @return 业务流程节点对象
     */
    public List<BizProcessNodeVO> queryNodeInfoById(BizProcessNodeVO bizProcessNode) {
        return queryList("com.comtop.cap.bm.biz.flow.model.queryNodeInfoById", bizProcessNode);
    }
    
    /**
     * 
     * 查询流程节点使用条数
     * 
     * @param bizProcessNode 业务流程节点对象
     * @return 业务流程节点对象
     */
    public int queryUseBizProcessNodeCount(BizProcessNodeVO bizProcessNode) {
        return ((Integer) selectOne("com.comtop.cap.bm.biz.flow.model.queryUseBizProcessNodeCount", bizProcessNode))
            .intValue();
    }
    
}
