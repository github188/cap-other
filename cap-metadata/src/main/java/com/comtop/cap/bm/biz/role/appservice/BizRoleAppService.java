/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.biz.role.appservice;

import java.util.List;

import com.comtop.cap.base.MDBaseAppservice;
import com.comtop.cap.base.MDBaseDAO;
import com.comtop.cap.bm.biz.items.appservice.BizItemsAppService;
import com.comtop.cap.bm.biz.role.dao.BizRoleDAO;
import com.comtop.cap.bm.biz.role.model.BizRoleVO;
import com.comtop.cap.bm.req.subfunc.appservice.ReqSubitemDutyAppService;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 角色业务逻辑处理类
 * 
 * @author 姜子豪
 * @since 1.0
 * @version 2015-11-11 姜子豪
 */
@PetiteBean
public class BizRoleAppService extends MDBaseAppservice<BizRoleVO> {
    
    /** 注入DAO **/
    @PetiteInject
    protected BizRoleDAO roleDAO;
    
    /** 注入 功能子项职责 AppService **/
    @PetiteInject
    protected ReqSubitemDutyAppService reqSubitemDutyAppService;
    
    /** 注入 业务事项 AppService **/
    @PetiteInject
    protected BizItemsAppService bizItemsAppService;
    
    /**
     * 新增角色信息
     * 
     * @param role 角色信息
     * @return 新增结果
     */
    public Object insertRole(BizRoleVO role) {
        return roleDAO.insertRole(role);
    }
    
    /**
     * 更新角色信息
     * 
     * @param role 角色信息
     * @return 更新结果
     */
    public boolean updateRole(BizRoleVO role) {
        return roleDAO.updateRole(role);
    }
    
    /**
     * 删除角色信息
     * 
     * @param roleList 角色信息集合
     */
    public void deleteRoleList(List<BizRoleVO> roleList) {
        roleDAO.deleteRoleList(roleList);
        for (BizRoleVO roleVO : roleList) {
            reqSubitemDutyAppService.deleteDutyByRoleId(roleVO.getId());
            bizItemsAppService.deleteItemRoleByRoleId(roleVO.getId());
        }
    }
    
    /**
     * 通过角色信息ID查询角色表
     * 
     * @param id 角色表,用于文档管理中角色信息管理ID
     * @return 角色表,用于文档管理中角色信息管理对象
     */
    public BizRoleVO loadRoleById(String id) {
        return roleDAO.loadRoleById(id);
    }
    
    /**
     * 通过业务域ID查询角色列表
     * 
     * @param domainId 业务域ID
     * @return 角色列表
     */
    public List<BizRoleVO> queryRoleByDomainId(String domainId) {
        return roleDAO.queryRoleByDomainId(domainId);
    }
    
    /**
     * 查询角色列表
     * 
     * @param role 角色
     * @return 业务角色对象
     */
    public List<BizRoleVO> queryRoleListNopage(BizRoleVO role) {
        return roleDAO.queryRoleListNopage(role);
    }
    
    /**
     * 查询角色是否被引用
     * 
     * @param role 角色
     * @return 结果
     */
    public int checkRoleIsUse(BizRoleVO role) {
        return roleDAO.checkRoleIsUse(role);
    }
    
    @Override
    protected MDBaseDAO<BizRoleVO> getDAO() {
        return roleDAO;
    }
    
    /**
     * @return 查询所有的业务级别
     *
     */
    public List<String> loadBizLevelList() {
        return roleDAO.queryList("com.comtop.cap.bm.biz.role.model.loadBizLevelList", null);
    }
    
    /**
     * 查询角色列表
     * 
     * @param bizRoleVO 查询条件
     * @return 条数
     */
    public int queryRoleCount(BizRoleVO bizRoleVO) {
        return roleDAO.queryRoleCount(bizRoleVO);
    }
    
    /**
     * 查询角色列表
     * 
     * @param role 角色
     * @return 业务角色对象
     */
    public List<BizRoleVO> queryRoleList(BizRoleVO role) {
        return roleDAO.queryRoleList(role);
    }
}
