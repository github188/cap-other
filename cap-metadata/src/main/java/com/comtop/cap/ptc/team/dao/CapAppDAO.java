/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.ptc.team.dao;

import java.util.List;

import com.comtop.cap.ptc.team.model.CapAppVO;
import com.comtop.cap.ptc.team.model.CapEmployeeVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.top.core.base.dao.CoreDAO;

/**
 * 个人应用DAO
 * 
 * @author 李小芬
 * @since 1.0
 * @version 2015-10-9 李小芬
 */
@PetiteBean
public class CapAppDAO extends CoreDAO<CapAppVO> {
    
    /**
     * 查询收藏和分配的应用
     *
     * @param userId 用户ID
     * @return 应用
     */
    public List<CapAppVO> queryMyAppIncludeStore(String userId) {
        return this.queryList("queryMyAppIncludeStore", userId);
    }
    
    /**
     * 查询分配的应用
     *
     * @param userId 用户ID
     * @return 应用
     */
    public List<CapAppVO> queryMyAppOnlyAssign(String userId) {
        return this.queryList("queryMyAppOnlyAssign", userId);
    }
    
    /**
     * 判断人员和应用是否已存在关联关系
     *
     * @param objCapAppVO 个人应用VO
     * @return 结果集
     */
    public List<CapAppVO> isExistRelation(CapAppVO objCapAppVO) {
        return this.queryList("isExistRelation", objCapAppVO);
    }
    
    /**
     * 根据应用查询分配的人员信息
     *
     * @param appId 应用ID
     * @param teamId 团队ID
     * @return 人员信息
     */
    public List<CapEmployeeVO> queryEmployeeListByAppId(String appId, String teamId) {
        CapAppVO objCapAppVO = new CapAppVO();
        objCapAppVO.setAppId(appId);
        objCapAppVO.setTeamId(teamId);
        return this.queryList("com.comtop.cap.ptc.team.model.queryEmployeeListByAppId", objCapAppVO);
    }
    
    /**
     * 需要删除的应用信息
     *
     * @param delCapAppVO 条件VO
     * @return 记录
     */
    public List<CapAppVO> queryAppByTeam(CapAppVO delCapAppVO) {
        return this.queryList("queryAppByTeam", delCapAppVO);
    }
    
}
