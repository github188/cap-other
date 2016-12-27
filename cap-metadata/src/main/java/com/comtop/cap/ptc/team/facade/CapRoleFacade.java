/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.ptc.team.facade;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.comtop.cap.ptc.team.appservice.CapRoleAppService;
import com.comtop.cap.ptc.team.model.CapRoleVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.base.facade.BaseFacade;

/**
 * 角色管理基本信息扩展实现
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-9-9 CAP
 */
@PetiteBean
public class CapRoleFacade extends BaseFacade {
    
    /** 注入AppService **/
    @PetiteInject
    protected CapRoleAppService capRoleAppService;
    
    /**
     * 新增 角色管理基本信息
     * 
     * @param capRoleVO 角色管理基本信息对象
     * @return 角色管理基本信息
     */
    public Object insertCapRole(CapRoleVO capRoleVO) {
        return capRoleAppService.insertCapRole(capRoleVO);
    }
    
    /**
     * 更新 角色管理基本信息
     * 
     * @param capRoleVO 角色管理基本信息对象
     * @return 更新结果
     */
    public boolean updateCapRole(CapRoleVO capRoleVO) {
        return capRoleAppService.updateCapRole(capRoleVO);
    }
    
    /**
     * 保存或更新角色管理基本信息，根据ID是否为空
     * 
     * @param capRoleVO 角色管理基本信息ID
     * @return 角色管理基本信息保存后的主键ID
     */
    public String saveCapRole(CapRoleVO capRoleVO) {
        if (capRoleVO.getId() == null) {
            String strId = (String) this.insertCapRole(capRoleVO);
            capRoleVO.setId(strId);
        } else {
            this.updateCapRole(capRoleVO);
        }
        return capRoleVO.getId();
    }
    
    /**
     * 读取 角色管理基本信息 列表，分页查询--新版设计器使用
     * 
     * @param condition 查询条件
     * @return 角色管理基本信息列表
     */
    public Map<String, Object> queryCapRoleListByPage(CapRoleVO condition) {
        final Map<String, Object> ret = new HashMap<String, Object>(2);
        int count = capRoleAppService.queryCapRoleCount(condition);
        List<CapRoleVO> capRoleVOList = null;
        if (count > 0) {
            capRoleVOList = capRoleAppService.queryCapRoleList(condition);
        }
        ret.put("list", capRoleVOList);
        ret.put("count", count);
        return ret;
    }
    
    /**
     * 删除 角色管理基本信息
     * 
     * @param capRoleVO 角色管理基本信息对象
     * @return 删除结果
     */
    public boolean deleteCapRole(CapRoleVO capRoleVO) {
        return capRoleAppService.deleteCapRole(capRoleVO);
    }
    
    /**
     * 删除 角色管理基本信息集合
     * 
     * @param capRoleVOList 角色管理基本信息对象
     * @return 删除结果
     */
    public boolean deleteCapRoleList(List<CapRoleVO> capRoleVOList) {
        return capRoleAppService.deleteCapRoleList(capRoleVOList);
    }
    
    /**
     * 读取 角色管理基本信息
     * 
     * @param capRoleVO 角色管理基本信息对象
     * @return 角色管理基本信息
     */
    public CapRoleVO loadCapRole(CapRoleVO capRoleVO) {
        return capRoleAppService.loadCapRole(capRoleVO);
    }
    
    /**
     * 根据角色管理基本信息主键 读取 角色管理基本信息
     * 
     * @param id 角色管理基本信息主键
     * @return 角色管理基本信息
     */
    public CapRoleVO loadCapRoleById(String id) {
        return capRoleAppService.loadCapRoleById(id);
    }
    
    /**
     * 读取 角色管理基本信息 列表
     * 
     * @param condition 查询条件
     * @return 角色管理基本信息列表
     */
    public List<CapRoleVO> queryCapRoleList(CapRoleVO condition) {
        return capRoleAppService.queryCapRoleList(condition);
    }
    
    /**
     * 读取 角色管理基本信息 数据条数
     * 
     * @param condition 查询条件
     * @return 角色管理基本信息数据条数
     */
    public int queryCapRoleCount(CapRoleVO condition) {
        return capRoleAppService.queryCapRoleCount(condition);
    }
    
}
