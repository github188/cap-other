/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.req.subfunc.dao;

import java.util.List;

import com.comtop.cap.base.MDBaseDAO;
import com.comtop.cap.bm.req.subfunc.model.ReqFunctionSubitemVO;
import com.comtop.cip.jodd.jtx.JtxPropagationBehavior;
import com.comtop.cip.jodd.jtx.meta.Transaction;
import com.comtop.cip.jodd.petite.meta.PetiteBean;

/**
 * 功能子项,建在功能项下面扩展DAO
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-11-25 CAP
 */
@PetiteBean
public class ReqFunctionSubitemDAO extends MDBaseDAO<ReqFunctionSubitemVO> {
    
    /**
     * 新增 功能子项,建在功能项下面
     * 
     * @param reqFunctionSubitem 功能子项,建在功能项下面对象
     * @return 功能子项,建在功能项下面Id
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public Object insertReqFunctionSubitem(ReqFunctionSubitemVO reqFunctionSubitem) {
        Object result = insert(reqFunctionSubitem);
        return result;
    }
    
    /**
     * 更新 功能子项,建在功能项下面
     * 
     * @param reqFunctionSubitem 功能子项,建在功能项下面对象
     * @return 更新成功与否
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean updateReqFunctionSubitem(ReqFunctionSubitemVO reqFunctionSubitem) {
        return update(reqFunctionSubitem);
    }
    
    /**
     * 删除 功能子项,建在功能项下面
     * 
     * @param reqFunctionSubitem 功能子项,建在功能项下面对象
     * @return 删除成功与否
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean deleteReqFunctionSubitem(ReqFunctionSubitemVO reqFunctionSubitem) {
        return delete(reqFunctionSubitem);
    }
    
    /**
     * 读取 功能子项,建在功能项下面
     * 
     * @param reqFunctionSubitem 功能子项,建在功能项下面对象
     * @return 功能子项,建在功能项下面
     */
    public ReqFunctionSubitemVO loadReqFunctionSubitem(ReqFunctionSubitemVO reqFunctionSubitem) {
        ReqFunctionSubitemVO objReqFunctionSubitem = load(reqFunctionSubitem);
        return objReqFunctionSubitem;
    }
    
    /**
     * 根据功能子项,建在功能项下面主键读取 功能子项,建在功能项下面
     * 
     * @param id 功能子项,建在功能项下面主键
     * @return 功能子项,建在功能项下面
     */
    public ReqFunctionSubitemVO loadReqFunctionSubitemById(String id) {
        ReqFunctionSubitemVO objReqFunctionSubitem = new ReqFunctionSubitemVO();
        objReqFunctionSubitem.setId(id);
        return loadReqFunctionSubitem(objReqFunctionSubitem);
    }
    
    /**
     * 读取 功能子项,建在功能项下面 列表
     * 
     * @param condition 查询条件
     * @return 功能子项,建在功能项下面列表
     */
    public List<ReqFunctionSubitemVO> queryReqFunctionSubitemList(ReqFunctionSubitemVO condition) {
        return queryList("com.comtop.cap.bm.req.subfunc.model.queryReqFunctionSubitemList", condition,
            condition.getPageNo(), condition.getPageSize());
    }
    
    /**
     * 读取 功能子项,建在功能项下面 数据条数
     * 
     * @param condition 查询条件
     * @return 功能子项,建在功能项下面数据条数
     */
    public int queryReqFunctionSubitemCount(ReqFunctionSubitemVO condition) {
        return ((Integer) selectOne("com.comtop.cap.bm.req.subfunc.model.queryReqFunctionSubitemCount", condition))
            .intValue();
    }
    
    /**
     * 查询功能项及功能子项
     *
     * @param condition 查询条件
     * @return 功能项以及功能子项
     */
    public List<ReqFunctionSubitemVO> querySubitemsWithItem(ReqFunctionSubitemVO condition) {
        return queryList("com.comtop.cap.bm.req.subfunc.model.querySubitemsWithItem", condition, condition.getPageNo(),
            condition.getPageSize());
    }
    
    /**
     * 更新 排序号
     * 
     * @param reqFunctionSubitemVO 功能子项
     *
     */
    public void updateSortNoById(ReqFunctionSubitemVO reqFunctionSubitemVO) {
        selectOne("com.comtop.cap.bm.req.subfunc.model.updateSortNoById", reqFunctionSubitemVO);
    }
    
}
