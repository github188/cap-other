/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.req.subfunc.dao;

import java.util.List;

import com.comtop.cap.bm.req.subfunc.model.ReqPageVO;
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
public class ReqFunctionPageDAO extends CoreDAO<ReqPageVO> {
    
    /**
     * 新增界面原型基本信息
     * 
     * @param reqFunctionPage 界面原型基本信息
     * @return id
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public String insertReqFunctionPage(ReqPageVO reqFunctionPage) {
        int sortNo = getMaxSortNum() + 1;
        reqFunctionPage.setSortNo(sortNo);
        return (String) insert(reqFunctionPage);
    }
    
    /**
     * 修改界面原型基本信息
     * 
     * @param reqFunctionPage 界面原型基本信息
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public void updateReqFunctionPage(ReqPageVO reqFunctionPage) {
        update(reqFunctionPage);
    }
    
    /**
     * 根据界面原型的ID集合查询对应的界面原型VO集合
     * 
     * @param pageIds 界面原型的ID集合，为空是返回空集合
     * @return 符合条件的界面原型VO集合
     */
    public List<ReqPageVO> queryReqPageListByIds(List<String> pageIds) {
        return queryList("com.comtop.cap.bm.req.subfunc.model.queryReqPageListByIds", pageIds);
    }
    
    /**
     * 
     * 获取界面原型数据条数（分页）
     * 
     * @param reqFunctionPage 查询条件
     * @return 数据条数
     */
    public int queryReqPageCount(ReqPageVO reqFunctionPage) {
        return ((Integer) selectOne("com.comtop.cap.bm.req.subfunc.model.queryReqPageCount", reqFunctionPage))
            .intValue();
    }
    
    /**
     * 
     * 获取界面原型列表（分页）
     *
     * @param reqFunctionPage 查询条件
     * @return 界面原型列表
     */
    public List<ReqPageVO> queryReqPageList(ReqPageVO reqFunctionPage) {
        return queryList("com.comtop.cap.bm.req.subfunc.model.queryReqPageList", reqFunctionPage,
            reqFunctionPage.getPageNo(), reqFunctionPage.getPageSize());
    }
    
    /**
     * 
     * 删除界面原型
     * 
     * @param reqFunctionPageList 界面原型
     */
    public void deleteReqPageList(List<ReqPageVO> reqFunctionPageList) {
        super.delete(reqFunctionPageList);
    }
    
    /**
     * 通过功能子项删除界面原型
     * 
     * @param subitemId 功能子项id
     */
    public void deleteReqPageBySubitemId(String subitemId) {
        super.execute("DELETE FROM CAP_REQ_PAGE WHERE SUBITEM_ID='" + subitemId + "'");
    }
    
    /**
     * 
     * 获取排序号
     *
     * @return 排序号
     */
    public int getMaxSortNum() {
        Object sortNo = super.selectOne("com.comtop.cap.bm.req.subfunc.model.getMaxSortNum", null);
        return sortNo == null ? 0 : ((Integer) sortNo).intValue();
    }
    
    /**
     * 
     * 批量保存界面原型
     * 
     * @param pageList 界面原型list
     */
    public void updatePageList(List<ReqPageVO> pageList) {
        super.update(pageList);
    }
}
