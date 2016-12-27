/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.ptc.team.facade;

import java.util.List;

import com.comtop.cap.bm.metadata.base.facade.CapBmBaseFacade;
import com.comtop.cap.ptc.team.appservice.TeamAndEmployeeRelAppService;
import com.comtop.cap.ptc.team.model.CapEmployeeVO;
import com.comtop.cap.ptc.team.model.TeamAndEmployeeRelVO;
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
public class TeamAndEmployeeRelFacade extends CapBmBaseFacade {
    
    /** 注入AppService **/
    @PetiteInject
    protected TeamAndEmployeeRelAppService teamAndEmployeeRelAppService;
    
    /**
     * 修改相应团队成员
     * 
     * @param employeeVO 项目团队成员基本信息
     */
    public void updateEmployeeToTeam(TeamAndEmployeeRelVO employeeVO) {
        teamAndEmployeeRelAppService.updateEmployeeToTeam(employeeVO);
    }
    
    /**
     * 新增相应团队成员
     * 
     * @param employeeVO 项目团队成员基本信息
     * @return 新增结果
     */
    public String insertEmployeeToTeam(TeamAndEmployeeRelVO employeeVO) {
        return teamAndEmployeeRelAppService.insertEmployeeToTeam(employeeVO);
    }
    
    /**
     * 根据团队ID查询团队成员
     * 
     * @param teamId 团队ID
     * @return 团队成员集合
     */
    public List<CapEmployeeVO> queryEmployeeByTeamId(String teamId) {
        return teamAndEmployeeRelAppService.queryEmployeeByTeamId(teamId);
    }
    
    /**
     * 删除项目团队成员
     * 
     * @param employeeVOList 项目团队成员
     */
    public void deleteTeamEmployee(List<TeamAndEmployeeRelVO> employeeVOList) {
        teamAndEmployeeRelAppService.deleteTeamEmployee(employeeVOList);
    }
    
    /**
     * 删除团队同时删除下属成员
     * 
     * @param teamId 项目团队Id
     */
    public void deleteFromTeam(String teamId) {
        teamAndEmployeeRelAppService.deleteFromTeam(teamId);
    }
    
    /**
     * 删除成员同时删除关系
     * 
     * @param employeeId 项目成员Id
     */
    public void deleteRelation(String employeeId) {
        teamAndEmployeeRelAppService.deleteRelation(employeeId);
    }
}
