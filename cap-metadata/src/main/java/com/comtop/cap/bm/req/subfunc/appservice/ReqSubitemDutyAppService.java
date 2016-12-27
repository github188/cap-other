/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.req.subfunc.appservice;

import java.util.List;

import com.comtop.cap.bm.req.subfunc.dao.ReqSubitemDutyDAO;
import com.comtop.cap.bm.req.subfunc.model.ReqSubitemDutyVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.base.appservice.BaseAppService;

/**
 * 功能子项职责表 业务逻辑处理类
 * 
 * @author CIP
 * @since 1.0
 * @version 2015-12-16 CIP
 */
@PetiteBean
public class ReqSubitemDutyAppService extends BaseAppService {
    
    /** 注入DAO **/
    @PetiteInject
    protected ReqSubitemDutyDAO reqSubitemDutyDAO;
    
    /**
     * 新增 功能子项职责表
     * 
     * @param reqSubitemDuty 功能子项职责表对象
     * @return 功能子项职责表Id
     */
    public Object insertReqSubitemDuty(ReqSubitemDutyVO reqSubitemDuty) {
        return reqSubitemDutyDAO.insertReqSubitemDuty(reqSubitemDuty);
    }
    
    /**
     * 更新 功能子项职责表
     * 
     * @param reqSubitemDuty 功能子项职责表对象
     * @return 更新成功与否
     */
    public boolean updateReqSubitemDuty(ReqSubitemDutyVO reqSubitemDuty) {
        return reqSubitemDutyDAO.updateReqSubitemDuty(reqSubitemDuty);
    }
    
    /**
     * 删除 功能子项职责表
     * 
     * @param subitemId 功能子项id
     * @return 删除成功与否
     */
    public boolean deleteReqSubitemDuty(String subitemId) {
        return reqSubitemDutyDAO.deleteReqSubitemDutyBySubitemId(subitemId);
    }
    
    /**
     * 删除 功能子项职责表集合
     * 
     * @param reqSubitemDutyList 功能子项职责表对象
     * @return 删除成功与否
     */
    public boolean deleteReqSubitemDutyList(List<ReqSubitemDutyVO> reqSubitemDutyList) {
        if (reqSubitemDutyList == null) {
            return true;
        }
        for (ReqSubitemDutyVO reqSubitemDuty : reqSubitemDutyList) {
            reqSubitemDutyDAO.deleteReqSubitemDuty(reqSubitemDuty);
        }
        return true;
    }
    
    /**
     * 读取 功能子项职责表
     * 
     * @param reqSubitemDuty 功能子项职责表对象
     * @return 功能子项职责表
     */
    public ReqSubitemDutyVO loadReqSubitemDuty(ReqSubitemDutyVO reqSubitemDuty) {
        return reqSubitemDutyDAO.loadReqSubitemDuty(reqSubitemDuty);
    }
    
    /**
     * 根据功能子项职责表主键读取 功能子项职责表
     * 
     * @param id 功能子项职责表主键
     * @return 功能子项职责表
     */
    public ReqSubitemDutyVO loadReqSubitemDutyById(String id) {
        return reqSubitemDutyDAO.loadReqSubitemDutyById(id);
    }
    
    /**
     * 读取 功能子项职责表 列表
     * 
     * @param condition 查询条件
     * @return 功能子项职责表列表
     */
    public List<ReqSubitemDutyVO> queryReqSubitemDutyList(ReqSubitemDutyVO condition) {
        return reqSubitemDutyDAO.queryReqSubitemDutyList(condition);
    }
    
    /**
     * 读取 功能子项职责表 数据条数
     * 
     * @param condition 查询条件
     * @return 功能子项职责表数据条数
     */
    public int queryReqSubitemDutyCount(ReqSubitemDutyVO condition) {
        return reqSubitemDutyDAO.queryReqSubitemDutyCount(condition);
    }
    
    /**
     * 获取角色id集合
     * 
     * @param subitemId 功能子项id
     * @return 获取角色id集合
     */
    public String queryBizRolesBySubitemId(String subitemId) {
        return reqSubitemDutyDAO.queryBizRolesBySubitemId(subitemId);
    }
    
    /**
     * 根据角色ID删除对应职责
     * 
     * @param roleId 角色
     */
    public void deleteDutyByRoleId(String roleId) {
        reqSubitemDutyDAO.deleteDutyByRoleId(roleId);
    }
    
}
