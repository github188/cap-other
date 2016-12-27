/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.biz.role.facade;

import java.util.List;

import com.comtop.cap.bm.biz.role.appservice.BizRoleAppService;
import com.comtop.cap.bm.biz.role.model.BizRoleVO;
import com.comtop.cap.runtime.component.facade.AutoGenNumberFacade;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.base.facade.BaseFacade;
import com.comtop.cap.runtime.core.AppBeanUtil;

/**
 * 角色表,用于文档管理中角色信息管理 业务逻辑处理类 门面
 * 
 * @author 姜子豪
 * @since 1.0
 * @version 2015-11-11 姜子豪
 */
@PetiteBean
public class BizRoleFacade extends BaseFacade {
    
    /** 注入AppService **/
    @PetiteInject
    protected BizRoleAppService roleAppService;
    
    /**
     * 新增角色信息
     * 
     * @param roleVO 角色信息
     * @return 新增结果
     */
    public Object insertRole(BizRoleVO roleVO) {
    	AutoGenNumberFacade autoGenNumberService = AppBeanUtil.getBean(AutoGenNumberFacade.class);
        String code = autoGenNumberService.genNumber(BizRoleVO.getCodeExpr(), null);
        roleVO.setRoleCode(code);
        return roleAppService.insertRole(roleVO);
    }
    
    /**
     * 更新角色信息
     * 
     * @param roleVO 角色信息
     * @return 更新结果
     */
    public boolean updateRole(BizRoleVO roleVO) {
        return roleAppService.updateRole(roleVO);
    }
    
    /**
     * 删除角色信息
     * 
     * @param roleVOList 角色信息集合
     */
    public void deleteRoleList(List<BizRoleVO> roleVOList) {
        roleAppService.deleteRoleList(roleVOList);
    }
    
    /**
     * 通过角色信息ID查询角色表
     * 
     * @param id 角色表,用于文档管理中角色信息管理ID
     * @return 角色表,用于文档管理中角色信息管理对象
     */
    public BizRoleVO loadRoleById(String id) {
        return roleAppService.loadRoleById(id);
    }
    
    /**
     * 通过业务域ID查询角色列表
     * 
     * @param domainId 业务域ID
     * @return 角色列表
     */
    public List<BizRoleVO> queryRoleByDomainId(String domainId) {
        return roleAppService.queryRoleByDomainId(domainId);
    }
    
    /**
     * 查询角色列表
     * 
     * @param role 角色
     * @return 业务角色对象
     */
    public List<BizRoleVO> queryRoleListNopage(BizRoleVO role) {
        return roleAppService.queryRoleListNopage(role);
    }
    
    /**
     * 查询角色是否被引用
     * 
     * @param role 角色
     * @return 结果
     */
    public int checkRoleIsUse(BizRoleVO role) {
        return roleAppService.checkRoleIsUse(role);
    }
    
    /**
     * 查询角色列表
     * 
     * @param bizRoleVO 查询条件
     * @return 条数
     */
    public int queryRoleCount(BizRoleVO bizRoleVO) {
        return roleAppService.queryRoleCount(bizRoleVO);
    }
    
    /**
     * 查询角色列表
     * 
     * @param role 角色
     * @return 业务角色对象
     */
    public List<BizRoleVO> queryRoleList(BizRoleVO role) {
        return roleAppService.queryRoleList(role);
    }
}
