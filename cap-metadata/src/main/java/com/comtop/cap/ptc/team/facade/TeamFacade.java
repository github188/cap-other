/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.ptc.team.facade;

import java.util.List;

import com.comtop.cap.bm.metadata.base.facade.CapBmBaseFacade;
import com.comtop.cap.ptc.team.appservice.TeamAppService;
import com.comtop.cap.ptc.team.model.TeamVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 项目团队基本信息扩展实现
 * 
 * @author 姜子豪
 * @since 1.0
 * @version 2015-9-9 姜子豪
 */
@PetiteBean
public class TeamFacade extends CapBmBaseFacade {
    
    /** 注入AppService **/
    @PetiteInject
    protected TeamAppService teamAppService;
    
    /**
     * 查询项目团队基本信息列表
     * 
     * @return 项目团队基本信息列表
     */
    public List<TeamVO> queryTeamList() {
        return teamAppService.queryTeamList();
    }
    
    /**
     * 根据团队ID查询团队对象列表
     * 
     * @param teamId 团队ID
     * @return 团队对象集合
     */
    public TeamVO queryTeamVOByTeamId(String teamId) {
        return teamAppService.queryTeamVOByTeamId(teamId);
    }
    
    /**
     * 新增项目团队基本信息
     * 
     * @param team 项目团队基本信息
     * @return 项目团队基本信息map对象
     */
    public String insertTeam(TeamVO team) {
        return teamAppService.insertTeam(team);
    }
    
    /**
     * 修改项目团队基本信息
     * 
     * @param team 项目团队基本信息
     */
    public void updateTeam(TeamVO team) {
        teamAppService.updateTeam(team);
    }
    
    /**
     * 删除项目团队
     * 
     * @param teamList 项目团队
     */
    public void deleteTeamList(List<TeamVO> teamList) {
        teamAppService.deleteTeamList(teamList);
    }
    
    /**
     * 查询测试团队基本信息列表
     * 
     * @return 测试团队基本信息列表
     */
    public List<TeamVO> queryTestTeamList() {
        return teamAppService.queryTestTeamList();
    }
}
