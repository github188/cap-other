/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.ptc.team.dao;

import java.util.List;

import com.comtop.cap.ptc.team.model.TeamVO;
import com.comtop.cip.jodd.jtx.JtxPropagationBehavior;
import com.comtop.cip.jodd.jtx.meta.Transaction;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.top.core.base.dao.CoreDAO;

/**
 * 项目团队基本信息扩展DAO
 * 
 * @author 姜子豪
 * @since 1.0
 * @version 2015-9-9 姜子豪
 */
@PetiteBean
public class TeamDAO extends CoreDAO<TeamVO> {
    
    /**
     * 查询项目团队基本信息列表
     * 
     * @return 项目团队基本信息列表
     */
    public List<TeamVO> queryTeamList() {
        
        return queryList("com.comtop.cap.ptc.team.model.queryTeamList", null);
    }
    
    /**
     * 根据团队ID查询团队对象列表
     * 
     * @param teamId 团队ID
     * @return 团队对象集合
     */
    public TeamVO queryTeamVOByTeamId(String teamId) {
        return (TeamVO) this.selectOne("com.comtop.cap.ptc.team.model.queryTeamVOByTeamId", teamId);
    }
    
    /**
     * 新增项目团队基本信息
     * 
     * @param team 项目团队基本信息
     * @return 项目团队基本信息map对象
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public String insertTeam(TeamVO team) {
        String result = (String) insert(team);
        return result;
    }
    
    /**
     * 修改项目团队基本信息
     * 
     * @param team 项目团队基本信息
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public void updateTeam(TeamVO team) {
        update(team);
    }
    
    /**
     * 删除项目团队
     * 
     * @param teamList 项目团队
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public void deleteTeamList(List<TeamVO> teamList) {
        delete(teamList);
    }
    
    /**
     * 查询项目团队基本信息列表
     * 
     * @return 项目团队基本信息列表
     */
    public List<TeamVO> queryTestTeamList() {
        return queryList("com.comtop.cap.ptc.team.model.queryTestTeamList", null);
    }
    
}
