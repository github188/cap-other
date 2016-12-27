/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.biz.flow.appservice;

import java.util.List;

import com.comtop.cap.base.MDBaseAppservice;
import com.comtop.cap.base.MDBaseDAO;
import com.comtop.cap.bm.biz.flow.dao.BizProcessNodeRoleDAO;
import com.comtop.cap.bm.biz.flow.model.BizProcessNodeRoleVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 业务事项 业务逻辑处理类
 * 
 * @author 姜子豪
 * @since 1.0
 * @version 2015-11-11 姜子豪
 */
@PetiteBean
public class BizProcessNodeRoleAppService extends MDBaseAppservice<BizProcessNodeRoleVO> {
    
    /** 注入DAO **/
    @PetiteInject
    protected BizProcessNodeRoleDAO bizProcessNodeRoleDAO;
    
    /**
     * 保存业务事项角色关联
     * 
     * @param nodeRoles 节点角色关联
     */
    public void insertBizProcessNodeRoleList(List<BizProcessNodeRoleVO> nodeRoles) {
        bizProcessNodeRoleDAO.insertBizProcessNodeRoleList(nodeRoles);
    }
    
    /**
     * 保存业务事项角色关联
     * 
     * @param nodeRoles 节点角色关联
     * @param nodeId 节点id
     */
    public void updateBizProcessNodeRoleList(List<BizProcessNodeRoleVO> nodeRoles, String nodeId) {
        bizProcessNodeRoleDAO.deleteByNodeId(nodeId);
        bizProcessNodeRoleDAO.insertBizProcessNodeRoleList(nodeRoles);
    }
    
    /**
     * 根据节点id读取节点角色关联
     * 
     * @param nodeId 节点id
     * @return 节点角色关联
     */
    public List<BizProcessNodeRoleVO> queryBizProcessNodeRolesByNodeId(String nodeId) {
        return bizProcessNodeRoleDAO.queryBizProcessNodeRolesByNodeId(nodeId);
    }
    
    /**
     * 通过节点ID角色关联
     * 
     * @param nodeId 节点id
     */
    public void deleteByNodeId(String nodeId) {
        bizProcessNodeRoleDAO.deleteByNodeId(nodeId);
    }
    
    @Override
    protected MDBaseDAO<BizProcessNodeRoleVO> getDAO() {
        return bizProcessNodeRoleDAO;
    }
    
    /**
     * FIXME 方法注释信息
     *
     * @param bizProcessNodeId xxx
     * @return xxx
     */
    public BizProcessNodeRoleVO queryBizProcessNodeRoleByNodeId(String bizProcessNodeId) {
        return bizProcessNodeRoleDAO.queryBizProcessNodeRoleByNodeId(bizProcessNodeId);
    }
    
    /**
     * 通过节点id删除数据
     * 
     * @param bizProcessNodeId 节点id
     */
    public void deleteProcessNodeRoleFacadeByNodeId(String bizProcessNodeId) {
        bizProcessNodeRoleDAO.deleteProcessNodeRoleFacadeByNodeId(bizProcessNodeId);
    }
}
