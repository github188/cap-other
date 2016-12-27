/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.ptc.team.dao;

import java.util.List;

import com.comtop.cap.ptc.team.model.CapRoleVO;
import com.comtop.cip.jodd.jtx.JtxPropagationBehavior;
import com.comtop.cip.jodd.jtx.meta.Transaction;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.top.core.base.dao.CoreDAO;

/**
 * 角色管理基本信息扩展DAO
 * 
 * @author 姜子豪
 * @since 1.0
 * @version 2015-9-9 姜子豪
 */
@PetiteBean
public class CapRoleDAO extends CoreDAO<CapRoleVO> {
    
    /**
     * 新增 角色管理基本信息
     * 
     * @param capRole 角色管理基本信息对象
     * @return 角色管理基本信息Id
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public Object insertCapRole(CapRoleVO capRole) {
        Object result = insert(capRole);
        return result;
    }
    
    /**
     * 更新 角色管理基本信息
     * 
     * @param capRole 角色管理基本信息对象
     * @return 更新成功与否
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean updateCapRole(CapRoleVO capRole) {
        return update(capRole);
    }
    
    /**
     * 删除 角色管理基本信息
     * 
     * @param capRole 角色管理基本信息对象
     * @return 删除成功与否
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean deleteCapRole(CapRoleVO capRole) {
        return delete(capRole);
    }
    
    /**
     * 读取 角色管理基本信息
     * 
     * @param capRole 角色管理基本信息对象
     * @return 角色管理基本信息
     */
    public CapRoleVO loadCapRole(CapRoleVO capRole) {
        CapRoleVO objCapRole = load(capRole);
        return objCapRole;
    }
    
    /**
     * 根据角色管理基本信息主键读取 角色管理基本信息
     * 
     * @param id 角色管理基本信息主键
     * @return 角色管理基本信息
     */
    public CapRoleVO loadCapRoleById(String id) {
        CapRoleVO objCapRole = new CapRoleVO();
        objCapRole.setId(id);
        return loadCapRole(objCapRole);
    }
    
    /**
     * 读取 角色管理基本信息 列表
     * 
     * @param condition 查询条件
     * @return 角色管理基本信息列表
     */
    public List<CapRoleVO> queryCapRoleList(CapRoleVO condition) {
        return queryList("com.comtop.cap.ptc.team.model.queryCapRoleList", condition, condition.getPageNo(),
            condition.getPageSize());
    }
    
    /**
     * 读取 角色管理基本信息 数据条数
     * 
     * @param condition 查询条件
     * @return 角色管理基本信息数据条数
     */
    public int queryCapRoleCount(CapRoleVO condition) {
        return ((Integer) selectOne("com.comtop.cap.ptc.team.model.queryCapRoleCount", condition)).intValue();
    }
    
}
