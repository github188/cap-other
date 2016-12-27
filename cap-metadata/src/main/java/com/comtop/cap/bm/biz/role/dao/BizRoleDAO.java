/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.biz.role.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.comtop.cap.base.MDBaseDAO;
import com.comtop.cap.bm.biz.role.model.BizRoleVO;
import com.comtop.cap.common.executor.PropertyReadExecutor;
import com.comtop.cap.common.executor.PropertyUpdateExecutor;
import com.comtop.cip.jodd.jtx.JtxPropagationBehavior;
import com.comtop.cip.jodd.jtx.meta.Transaction;
import com.comtop.cip.jodd.petite.meta.PetiteBean;

/**
 * 角色DAO
 * 
 * @author 姜子豪
 * @since 1.0
 * @version 2015-11-11 姜子豪
 */
@PetiteBean
public class BizRoleDAO extends MDBaseDAO<BizRoleVO> {
    
    /**
     * 新增角色信息
     * 
     * @param role 角色信息
     * @return 新增结果
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public Object insertRole(BizRoleVO role) {
        Object result = insert(role);
        return result;
    }
    
    /**
     * 更新角色信息
     * 
     * @param role 角色信息
     * @return 更新结果
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean updateRole(BizRoleVO role) {
        return update(role);
    }
    
    /**
     * 删除角色信息
     * 
     * @param roleList 角色信息集合
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public void deleteRoleList(List<BizRoleVO> roleList) {
        super.delete(roleList);
    }
    
    /**
     * 通过角色信息ID查询角色表
     * 
     * @param role 角色表,用于文档管理中角色信息管理ID
     * @return 角色表,用于文档管理中角色信息管理对象
     */
    public BizRoleVO loadRole(BizRoleVO role) {
        BizRoleVO objRole = load(role);
        return objRole;
    }
    
    /**
     * 通过角色信息ID查询角色表
     * 
     * @param id 角色表,用于文档管理中角色信息管理ID
     * @return 角色表,用于文档管理中角色信息管理对象
     */
    public BizRoleVO loadRoleById(String id) {
        BizRoleVO objRole = new BizRoleVO();
        objRole.setId(id);
        return loadRole(objRole);
    }
    
    /**
     * 通过业务域ID查询角色列表
     * 
     * @param domainId 业务域ID
     * @return 角色列表
     */
    public List<BizRoleVO> queryRoleByDomainId(String domainId) {
        return queryList("com.comtop.cap.bm.biz.role.model.queryRoleByDomainId", domainId);
    }
    
    /**
     * 通过业务域ID删除所属角色
     * 
     * @param domainId 业务域ID
     */
    public void deleteByDomainId(String domainId) {
        super.delete("com.comtop.cap.bm.biz.role.model.deleteByDomainId", domainId);
        
    }
    
    /**
     * 查询角色列表
     * 
     * @param role 角色
     * @return 业务角色对象
     */
    public List<BizRoleVO> queryRoleListNopage(BizRoleVO role) {
        return queryList("com.comtop.cap.bm.biz.role.model.queryRoleList", role);
    }
    
    /**
     * 查询角色是否被引用
     * 
     * @param role 角色
     * @return 结果
     */
    public int checkRoleIsUse(BizRoleVO role) {
        return (Integer) selectOne("com.comtop.cap.bm.biz.role.model.checkRoleIsUse", role);
    }
    
    /**
     * 根据查询条件查询文档list
     * 
     * @param id 对象id
     * @param properties 属性集
     *
     * @return Map<String,Object> 属性集
     */
    @Override
    public Map<String, Object> readPropertyById(final String id, List<String> properties) {
        final Map<String, Object> retMap = new HashMap<String, Object>(properties.size() + 1);
        retMap.put("id", id);
        this.execute(new PropertyReadExecutor(id, properties, BizRoleVO.class, retMap));
        return retMap;
    }
    
    /**
     * 根据查询条件查询文档list
     * 
     * @param id 对象id
     * @param properties 属性集
     */
    @Override
    public void updatePropertyById(final String id, Map<String, Object> properties) {
        this.execute(new PropertyUpdateExecutor(id, properties, BizRoleVO.class));
    }

    /**
     * 查询角色列表
     * @param bizRoleVO 查询条件
     * @return 条数
     */
	public int queryRoleCount(BizRoleVO bizRoleVO) {
		   return (Integer) selectOne("com.comtop.cap.bm.biz.role.model.queryRoleCount", bizRoleVO);
	}
	
    /**
     * 查询角色列表
     * 
     * @param role 角色
     * @return 业务角色对象
     */
    public List<BizRoleVO> queryRoleList(BizRoleVO role) {
        return super.queryList("com.comtop.cap.bm.biz.role.model.queryRoleList", role, role.getPageNo(), role.getPageSize());
    }
    
}
