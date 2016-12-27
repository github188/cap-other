/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.biz.flow.dao;

import java.util.List;

import com.comtop.cap.base.MDBaseDAO;
import com.comtop.cap.bm.biz.flow.model.BizProcessInfoVO;
import com.comtop.cip.jodd.jtx.JtxPropagationBehavior;
import com.comtop.cip.jodd.jtx.meta.Transaction;
import com.comtop.cip.jodd.petite.meta.PetiteBean;

/**
 * 业务流程DAO
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-11-12 CAP
 */
@PetiteBean
public class BizProcessInfoDAO extends MDBaseDAO<BizProcessInfoVO> {
    
    /**
     * 新增 业务流程
     * 
     * @param bizProcessInfo 业务流程对象
     * @return 业务流程Id
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public Object insertBizProcessInfo(BizProcessInfoVO bizProcessInfo) {
        Object result = insert(bizProcessInfo);
        return result;
    }
    
    /**
     * 更新 业务流程
     * 
     * @param bizProcessInfo 业务流程对象
     * @return 更新成功与否
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean updateBizProcessInfo(BizProcessInfoVO bizProcessInfo) {
        return update(bizProcessInfo);
    }
    
    /**
     * 删除 业务流程
     * 
     * @param bizProcessInfo 业务流程对象
     * @return 删除成功与否
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean deleteBizProcessInfo(BizProcessInfoVO bizProcessInfo) {
        return delete(bizProcessInfo);
    }
    
    /**
     * 读取 业务流程
     * 
     * @param bizProcessInfo 业务流程对象
     * @return 业务流程
     */
    public BizProcessInfoVO loadBizProcessInfo(BizProcessInfoVO bizProcessInfo) {
        BizProcessInfoVO objBizProcessInfo = load(bizProcessInfo);
        return objBizProcessInfo;
    }
    
    /**
     * 根据业务流程主键读取 业务流程
     * 
     * @param id 业务流程主键
     * @return 业务流程
     */
    public BizProcessInfoVO loadBizProcessInfoById(String id) {
        BizProcessInfoVO objBizProcessInfo = new BizProcessInfoVO();
        objBizProcessInfo.setId(id);
        return loadBizProcessInfo(objBizProcessInfo);
    }
    
    /**
     * 读取 业务流程 列表
     * 
     * @param condition 查询条件
     * @return 业务流程列表
     */
    public List<BizProcessInfoVO> queryBizProcessInfoList(BizProcessInfoVO condition) {
        return queryList("com.comtop.cap.bm.biz.flow.model.queryBizProcessInfoList", condition, condition.getPageNo(),
            condition.getPageSize());
    }
    
    /**
     * 读取 业务流程 数据条数
     * 
     * @param condition 查询条件
     * @return 业务流程数据条数
     */
    public int queryBizProcessInfoCount(BizProcessInfoVO condition) {
        return ((Integer) selectOne("com.comtop.cap.bm.biz.flow.model.queryBizProcessInfoCount", condition)).intValue();
    }
    
    /**
     * 查询存在流程节点数量
     * 
     * @param bizProcessInfo 业务流程
     * @return 流程节点数量
     */
    public int queryProcessNodeCount(BizProcessInfoVO bizProcessInfo) {
        return ((Integer) selectOne("com.comtop.cap.bm.biz.flow.model.queryProcessNodeCount", bizProcessInfo))
            .intValue();
    }
    
    /**
     * 通过idlist获取名称集合
     * 
     * @param condition 业务流程
     * @return 名称集合
     */
    public String queryProcessNodeNames(BizProcessInfoVO condition) {
        return (String) selectOne("com.comtop.cap.bm.biz.flow.model.queryBizProcessNodeNames", condition);
    }
    
}
