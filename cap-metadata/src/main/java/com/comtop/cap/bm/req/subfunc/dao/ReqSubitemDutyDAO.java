/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.req.subfunc.dao;

import java.util.List;

import com.comtop.cap.bm.req.subfunc.model.ReqSubitemDutyVO;
import com.comtop.cip.jodd.jtx.JtxPropagationBehavior;
import com.comtop.cip.jodd.jtx.meta.Transaction;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.top.core.base.dao.CoreDAO;

/**
 * 功能子项职责表DAO
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-12-16 CAP
 */
@PetiteBean
public class ReqSubitemDutyDAO extends CoreDAO<ReqSubitemDutyVO> {
    
    /**
     * 新增 功能子项职责表
     * 
     * @param reqSubitemDuty 功能子项职责表对象
     * @return 功能子项职责表Id
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public Object insertReqSubitemDuty(ReqSubitemDutyVO reqSubitemDuty) {
        Object result = insert(reqSubitemDuty);
        return result;
    }
    
    /**
     * 更新 功能子项职责表
     * 
     * @param reqSubitemDuty 功能子项职责表对象
     * @return 更新成功与否
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean updateReqSubitemDuty(ReqSubitemDutyVO reqSubitemDuty) {
        return update(reqSubitemDuty);
    }
    
    /**
     * 删除 功能子项职责表
     * 
     * @param reqSubitemDuty 功能子项职责表对象
     * @return 删除成功与否
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean deleteReqSubitemDuty(ReqSubitemDutyVO reqSubitemDuty) {
        return delete(reqSubitemDuty);
    }
    
    /**
     * 删除 功能子项职责表
     * 
     * @param subitemId 功能子项职ID
     * @return 删除成功与否
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean deleteReqSubitemDutyBySubitemId(String subitemId) {
        return super.execute("DELETE FROM CAP_REQ_SUBITEM_DUTY WHERE SUBITEM_ID='" + subitemId + "'");
    }
    
    /**
     * 读取 功能子项职责表
     * 
     * @param reqSubitemDuty 功能子项职责表对象
     * @return 功能子项职责表
     */
    public ReqSubitemDutyVO loadReqSubitemDuty(ReqSubitemDutyVO reqSubitemDuty) {
        ReqSubitemDutyVO objReqSubitemDuty = load(reqSubitemDuty);
        return objReqSubitemDuty;
    }
    
    /**
     * 根据功能子项职责表主键读取 功能子项职责表
     * 
     * @param id 功能子项职责表主键
     * @return 功能子项职责表
     */
    public ReqSubitemDutyVO loadReqSubitemDutyById(String id) {
        ReqSubitemDutyVO objReqSubitemDuty = new ReqSubitemDutyVO();
        objReqSubitemDuty.setId(id);
        return loadReqSubitemDuty(objReqSubitemDuty);
    }
    
    /**
     * 读取 功能子项职责表 列表
     * 
     * @param condition 查询条件
     * @return 功能子项职责表列表
     */
    public List<ReqSubitemDutyVO> queryReqSubitemDutyList(ReqSubitemDutyVO condition) {
        return queryList("com.comtop.cap.bm.req.subfunc.model.queryReqSubitemDutyList", condition,
            condition.getPageNo(), condition.getPageSize());
    }
    
    /**
     * 读取 功能子项职责表 数据条数
     * 
     * @param condition 查询条件
     * @return 功能子项职责表数据条数
     */
    public int queryReqSubitemDutyCount(ReqSubitemDutyVO condition) {
        return ((Integer) selectOne("com.comtop.cap.bm.req.subfunc.model.queryReqSubitemDutyCount", condition))
            .intValue();
    }
    
    /**
     * 获取角色id集合
     * 
     * @param subitemId 功能子项id
     * @return 获取角色id集合
     */
    public String queryBizRolesBySubitemId(String subitemId) {
        return (String) selectOne("com.comtop.cap.bm.req.subfunc.model.queryBizRolesBySubitemId", subitemId);
    }
    
    /**
     * 根据角色ID删除对应职责
     * 
     * @param roleId 角色
     */
    public void deleteDutyByRoleId(String roleId) {
        selectOne("com.comtop.cap.bm.req.subfunc.model.deleteDutyByRoleId", roleId);
    }
    
}
