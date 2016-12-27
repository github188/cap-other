/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.ptc.team.appservice;

import java.util.List;

import com.comtop.cap.ptc.team.dao.CapRoleDAO;
import com.comtop.cap.ptc.team.model.CapRoleVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.base.appservice.BaseAppService;

/**
 * 角色管理基本信息服务扩展类
 * 
 * @author 姜子豪
 * @since 1.0
 * @version 2015-9-9 姜子豪
 */
@PetiteBean
public class CapRoleAppService extends BaseAppService {
    
    /** 注入DAO **/
    @PetiteInject
    protected CapRoleDAO capRoleDAO;
    
    /**
     * 新增 角色管理基本信息
     * 
     * @param capRole 角色管理基本信息对象
     * @return 角色管理基本信息Id
     */
    public Object insertCapRole(CapRoleVO capRole) {
        return capRoleDAO.insertCapRole(capRole);
    }
    
    /**
     * 更新 角色管理基本信息
     * 
     * @param capRole 角色管理基本信息对象
     * @return 更新成功与否
     */
    public boolean updateCapRole(CapRoleVO capRole) {
        return capRoleDAO.updateCapRole(capRole);
    }
    
    /**
     * 删除 角色管理基本信息
     * 
     * @param capRole 角色管理基本信息对象
     * @return 删除成功与否
     */
    public boolean deleteCapRole(CapRoleVO capRole) {
        return capRoleDAO.deleteCapRole(capRole);
    }
    
    /**
     * 删除 角色管理基本信息集合
     * 
     * @param capRoleList 角色管理基本信息对象
     * @return 删除成功与否
     */
    public boolean deleteCapRoleList(List<CapRoleVO> capRoleList) {
        if (capRoleList == null) {
            return true;
        }
        for (CapRoleVO capRole : capRoleList) {
            this.deleteCapRole(capRole);
        }
        return true;
    }
    
    /**
     * 读取 角色管理基本信息
     * 
     * @param capRole 角色管理基本信息对象
     * @return 角色管理基本信息
     */
    public CapRoleVO loadCapRole(CapRoleVO capRole) {
        return capRoleDAO.loadCapRole(capRole);
    }
    
    /**
     * 根据角色管理基本信息主键读取 角色管理基本信息
     * 
     * @param id 角色管理基本信息主键
     * @return 角色管理基本信息
     */
    public CapRoleVO loadCapRoleById(String id) {
        return capRoleDAO.loadCapRoleById(id);
    }
    
    /**
     * 读取 角色管理基本信息 列表
     * 
     * @param condition 查询条件
     * @return 角色管理基本信息列表
     */
    public List<CapRoleVO> queryCapRoleList(CapRoleVO condition) {
        return capRoleDAO.queryCapRoleList(condition);
    }
    
    /**
     * 读取 角色管理基本信息 数据条数
     * 
     * @param condition 查询条件
     * @return 角色管理基本信息数据条数
     */
    public int queryCapRoleCount(CapRoleVO condition) {
        return capRoleDAO.queryCapRoleCount(condition);
    }
    
}
