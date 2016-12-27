/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.req.subfunc.facade;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.comtop.cap.bm.biz.role.appservice.BizRoleAppService;
import com.comtop.cap.bm.req.subfunc.appservice.ReqSubitemDutyAppService;
import com.comtop.cap.bm.req.subfunc.model.ReqSubitemDutyVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.base.facade.BaseFacade;

/**
 * 功能子项职责表 业务逻辑处理类 门面
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-12-16 CAP
 */
@PetiteBean
public class ReqSubitemDutyFacade extends BaseFacade {
    
    /** 注入AppService **/
    @PetiteInject
    protected ReqSubitemDutyAppService reqSubitemDutyAppService;
    
    /** 注入AppService **/
    @PetiteInject
    protected BizRoleAppService roleAppService;
    
    /**
     * 新增 功能子项职责表
     * 
     * @param reqSubitemDutyVO 功能子项职责表对象
     * @return 功能子项职责表
     */
    public Object insertReqSubitemDuty(ReqSubitemDutyVO reqSubitemDutyVO) {
        return reqSubitemDutyAppService.insertReqSubitemDuty(reqSubitemDutyVO);
    }
    
    /**
     * 更新 功能子项职责表
     * 
     * @param reqSubitemDutyVO 功能子项职责表对象
     * @return 更新结果
     */
    public boolean updateReqSubitemDuty(ReqSubitemDutyVO reqSubitemDutyVO) {
        return reqSubitemDutyAppService.updateReqSubitemDuty(reqSubitemDutyVO);
    }
    
    /**
     * 保存或更新功能子项职责表，根据ID是否为空
     * 
     * @param reqSubitemDutyVO 功能子项职责表ID
     * @return 功能子项职责表保存后的主键ID
     */
    public String saveReqSubitemDuty(ReqSubitemDutyVO reqSubitemDutyVO) {
        if (reqSubitemDutyVO.getId() == null) {
            String strId = (String) this.insertReqSubitemDuty(reqSubitemDutyVO);
            reqSubitemDutyVO.setId(strId);
        } else {
            this.updateReqSubitemDuty(reqSubitemDutyVO);
        }
        return reqSubitemDutyVO.getId();
    }
    
    /**
     * 读取 功能子项职责表 列表，分页查询--新版设计器使用
     * 
     * @param condition 查询条件
     * @return 功能子项职责表列表
     */
    public Map<String, Object> queryReqSubitemDutyListByPage(ReqSubitemDutyVO condition) {
        final Map<String, Object> ret = new HashMap<String, Object>(2);
        int count = reqSubitemDutyAppService.queryReqSubitemDutyCount(condition);
        List<ReqSubitemDutyVO> reqSubitemDutyVOList = null;
        if (count > 0) {
            reqSubitemDutyVOList = reqSubitemDutyAppService.queryReqSubitemDutyList(condition);
        }
        ret.put("list", reqSubitemDutyVOList);
        ret.put("count", count);
        return ret;
    }
    
    /**
     * 删除 功能子项职责表
     * 
     * @param subitemId 功能子项职责表对象ID
     * @return 删除结果
     */
    public boolean deleteReqSubitemDuty(String subitemId) {
        return reqSubitemDutyAppService.deleteReqSubitemDuty(subitemId);
    }
    
    /**
     * 删除 功能子项职责表集合
     * 
     * @param reqSubitemDutyVOList 功能子项职责表对象
     * @return 删除结果
     */
    public boolean deleteReqSubitemDutyList(List<ReqSubitemDutyVO> reqSubitemDutyVOList) {
        return reqSubitemDutyAppService.deleteReqSubitemDutyList(reqSubitemDutyVOList);
    }
    
    /**
     * 读取 功能子项职责表
     * 
     * @param reqSubitemDutyVO 功能子项职责表对象
     * @return 功能子项职责表
     */
    public ReqSubitemDutyVO loadReqSubitemDuty(ReqSubitemDutyVO reqSubitemDutyVO) {
        return reqSubitemDutyAppService.loadReqSubitemDuty(reqSubitemDutyVO);
    }
    
    /**
     * 根据功能子项职责表主键 读取 功能子项职责表
     * 
     * @param id 功能子项职责表主键
     * @return 功能子项职责表
     */
    public ReqSubitemDutyVO loadReqSubitemDutyById(String id) {
        return reqSubitemDutyAppService.loadReqSubitemDutyById(id);
    }
    
    /**
     * 读取 功能子项职责表 列表
     * 
     * @param condition 查询条件
     * @return 功能子项职责表列表
     */
    public List<ReqSubitemDutyVO> queryReqSubitemDutyList(ReqSubitemDutyVO condition) {
        return reqSubitemDutyAppService.queryReqSubitemDutyList(condition);
    }
    
    /**
     * 读取 功能子项职责表 数据条数
     * 
     * @param condition 查询条件
     * @return 功能子项职责表数据条数
     */
    public int queryReqSubitemDutyCount(ReqSubitemDutyVO condition) {
        return reqSubitemDutyAppService.queryReqSubitemDutyCount(condition);
    }
    
    /**
     * 获取角色id集合
     * 
     * @param subitemId 功能子项id
     * @return 获取角色id集合
     */
    public String queryBizRolesBySubitemId(String subitemId) {
        return reqSubitemDutyAppService.queryBizRolesBySubitemId(subitemId);
    }
    
}
