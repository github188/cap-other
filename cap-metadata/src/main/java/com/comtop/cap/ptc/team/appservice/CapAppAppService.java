/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.ptc.team.appservice;

import java.util.List;

import com.comtop.cap.ptc.team.dao.CapAppDAO;
import com.comtop.cap.ptc.team.model.CapAppVO;
import com.comtop.cap.ptc.team.model.CapEmployeeVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.base.appservice.BaseAppService;

/**
 * 项目团队基本信息服务扩展类
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-9-9 CAP
 */
@PetiteBean
public class CapAppAppService extends BaseAppService {
    
    /** 注入DAO **/
    @PetiteInject
    protected CapAppDAO capAppDAO;
    
    /**
     * 新增
     * 
     * @param capAppVO 个人应用VO
     * @return 分配ID
     */
    public String insertCapApp(CapAppVO capAppVO) {
        return (String) capAppDAO.insert(capAppVO);
    }
    
    /**
     * 收藏应用
     *
     * @param capAppVO 应用VO
     * @return 成功标志
     */
    public String storeUpApp(CapAppVO capAppVO) {
        if (!isStore(capAppVO.getEmployeeId(), capAppVO.getAppId())) {
            return (String) capAppDAO.insert(capAppVO);
        }
        return "exsit";
    }
    
    /**
     * 批量分配应用
     *
     * @param lstCapAppVO 应用list
     * @param delCapAppVO 待删除的应用条件
     */
    public void assignApp(List<CapAppVO> lstCapAppVO, CapAppVO delCapAppVO) {
        // 删除团队之前分配的应用
        capAppDAO.delete("com.comtop.cap.ptc.team.model.deleteAppByTeamId", delCapAppVO);
        for (CapAppVO capAppVO : lstCapAppVO) {
            if (!isAssign(capAppVO.getEmployeeId(), capAppVO.getAppId())) {
                this.insertCapApp(capAppVO);
            }
        }
    }
    
    /**
     * 获取我的应用
     * 
     * @param userId 用户ID信息
     * @param cascadeCollect 是否级联查询收藏的应用
     * @return 返回值
     */
    public List<CapAppVO> queryMyApp(String userId, boolean cascadeCollect) {
        List<CapAppVO> lstCapAppVO;
        if (cascadeCollect) {
            lstCapAppVO = capAppDAO.queryMyAppIncludeStore(userId);
        } else {
            lstCapAppVO = capAppDAO.queryMyAppOnlyAssign(userId);
        }
        return lstCapAppVO;
    }
    
    /**
     * 是否已收藏
     *
     * @param employeeId 人员ID
     * @param appId 应用ID
     * @return true 已收藏 false未收藏
     */
    public boolean isStore(String employeeId, String appId) {
        CapAppVO objCapAppVO = new CapAppVO();
        objCapAppVO.setEmployeeId(employeeId);
        objCapAppVO.setAppId(appId);
        objCapAppVO.setAppType(2);
        List<CapAppVO> lstCapAppVO = capAppDAO.isExistRelation(objCapAppVO);
        if (lstCapAppVO != null && lstCapAppVO.size() > 0) {
            return true;
        }
        return false;
    }
    
    /**
     * 是否已分配
     *
     * @param employeeId 人员ID
     * @param appId 应用ID
     * @return true 已分配 false未分配
     */
    public boolean isAssign(String employeeId, String appId) {
        CapAppVO objCapAppVO = new CapAppVO();
        objCapAppVO.setEmployeeId(employeeId);
        objCapAppVO.setAppId(appId);
        objCapAppVO.setAppType(1);
        List<CapAppVO> lstCapAppVO = capAppDAO.isExistRelation(objCapAppVO);
        if (lstCapAppVO != null && lstCapAppVO.size() > 0) {
            return true;
        }
        return false;
    }
    
    /**
     * 取消收藏
     *
     * @param capAppVO 应用VO
     * @return 成功标志 true表示成功 false 表示失败
     */
    public boolean cancelAppStore(CapAppVO capAppVO) {
        return capAppDAO.delete(capAppVO);
    }
    
    /**
     * 根据登录人的应用收藏信息
     *
     * @param capAppVO 应用ID,人员ID
     * @return 应用收藏信息
     */
    public CapAppVO queryStoreApp(CapAppVO capAppVO) {
        List<CapAppVO> lstCapAppVO = capAppDAO.isExistRelation(capAppVO);
        if (lstCapAppVO != null && lstCapAppVO.size() > 0) {
            return lstCapAppVO.get(0);
        }
        return null;
    }
    
    /**
     * 根据ID查询VO
     *
     * @param id ID
     * @return VO
     */
    public CapAppVO queryById(String id) {
        CapAppVO objCapAppVO = new CapAppVO();
        objCapAppVO.setId(id);
        return capAppDAO.load(objCapAppVO);
    }
    
    /**
     * 根据应用查询分配的人员信息
     *
     * @param appId 应用ID
     * @param teamId 团队ID
     * @return 人员信息
     */
    public List<CapEmployeeVO> queryEmployeeListByAppId(String appId, String teamId) {
        return capAppDAO.queryEmployeeListByAppId(appId, teamId);
    }
    
}
