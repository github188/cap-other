/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.biz.flow.dao;

import java.util.List;

import com.comtop.cap.base.MDBaseDAO;
import com.comtop.cap.bm.biz.flow.model.BizProcessNodeRoleVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;

/**
 * 业务事项DAO
 * 
 * @author 李志勇
 * @since 1.0
 * @version 2015-11-11 李志勇
 */
@PetiteBean
public class BizProcessNodeRoleDAO extends MDBaseDAO<BizProcessNodeRoleVO> {
    
    /**
     * 根据节点id读取节点角色关联
     * 
     * @param nodeId 节点id
     * @return 节点角色关联
     */
    public List<BizProcessNodeRoleVO> queryBizProcessNodeRolesByNodeId(String nodeId) {
        return queryList("com.comtop.cap.bm.biz.flow.model.queryBizProcessNodeRolesByNodeId", nodeId);
    }
    
    /**
     * 保存节点角色关联列表
     * 
     * @param nodeRoles 节点角色关联
     */
    public void insertBizProcessNodeRoleList(List<BizProcessNodeRoleVO> nodeRoles) {
        insert(nodeRoles);
    }
    
    /**
     * 通过节点ID角色关联
     * 
     * @param nodeId 节点id
     */
    public void deleteByNodeId(String nodeId) {
        delete("com.comtop.cap.bm.biz.flow.model.deleteByNodeId", nodeId);
    }
    
    /**
     * 
     * FIXME 方法注释信息
     *
     * @param bizProcessNodeId xxx
     * @return xxx
     */
    public BizProcessNodeRoleVO queryBizProcessNodeRoleByNodeId(String bizProcessNodeId) {
        return (BizProcessNodeRoleVO) selectOne("com.comtop.cap.bm.biz.flow.model.queryBizProcessNodeRoleByNodeId",
            bizProcessNodeId);
    }
    
    /**
     * 通过节点id删除数据
     * 
     * @param bizProcessNodeId 节点id
     */
    public void deleteProcessNodeRoleFacadeByNodeId(String bizProcessNodeId) {
        super.execute("delete from CAP_BIZ_PROCESS_NODE_ROLE where node_id='" + bizProcessNodeId + "'");
    }
}
