/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.ptc.team.facade;

import java.util.List;

import com.comtop.cap.ptc.team.appservice.CapAppAppService;
import com.comtop.cap.ptc.team.model.CapAppVO;
import com.comtop.cap.ptc.team.model.CapEmployeeVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.base.facade.BaseFacade;

/**
 * 项目团队基本信息扩展实现
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-9-9 CAP
 */
@PetiteBean
public class CapAppFacade extends BaseFacade {
    
    /** 注入AppService **/
    @PetiteInject
    protected CapAppAppService capAppAppService;
    
    /**
     * 新增
     * 
     * @param capAppVO 个人应用VO
     * @return 分配ID
     */
    public String insertCapApp(CapAppVO capAppVO) {
        return capAppAppService.insertCapApp(capAppVO);
    }
    
    /**
     * 收藏应用
     *
     * @param capAppVO 应用VO
     * @return 成功标志
     */
    public String storeUpApp(CapAppVO capAppVO) {
        return capAppAppService.storeUpApp(capAppVO);
    }
    
    /**
     * 获取我的应用
     * 
     * @param userId 用户ID信息
     * @param cascadeCollect 是否级联查询收藏的应用
     * @return 返回值
     */
    public List<CapAppVO> queryMyApp(String userId, boolean cascadeCollect) {
        return capAppAppService.queryMyApp(userId, cascadeCollect);
    }
    
    /**
     * 批量分配应用
     *
     * @param lstCapAppVO 应用list
     * @param delCapAppVO 待删除的应用条件
     */
    public void assignApp(List<CapAppVO> lstCapAppVO, CapAppVO delCapAppVO) {
        capAppAppService.assignApp(lstCapAppVO, delCapAppVO);
    }
    
    /**
     * 取消收藏
     *
     * @param capAppVO 应用VO
     * @return 成功标志
     */
    public boolean cancelAppStore(CapAppVO capAppVO) {
        return capAppAppService.cancelAppStore(capAppVO);
    }
    
    /**
     * 根据登录人的应用收藏信息
     *
     * @param capAppVO 应用ID,人员ID
     * @return 应用收藏信息
     */
    public CapAppVO queryStoreApp(CapAppVO capAppVO) {
        return capAppAppService.queryStoreApp(capAppVO);
    }
    
    /**
     * 根据ID查询VO
     *
     * @param id ID
     * @return VO
     */
    public CapAppVO queryById(String id) {
        return capAppAppService.queryById(id);
    }
    
    /**
     * 根据应用查询分配的人员信息
     *
     * @param appId 应用ID
     * @param teamId 团队ID
     * @return 人员信息
     */
    public List<CapEmployeeVO> queryEmployeeListByAppId(String appId, String teamId) {
        return capAppAppService.queryEmployeeListByAppId(appId, teamId);
    }
    
}
