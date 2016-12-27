/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.biz.flow.facade;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.biz.flow.appservice.BizProcessInfoAppService;
import com.comtop.cap.bm.biz.flow.appservice.BizProcessNodeAppService;
import com.comtop.cap.bm.biz.flow.appservice.BizProcessNodeRoleAppService;
import com.comtop.cap.bm.biz.flow.appservice.BizRelInfoAppService;
import com.comtop.cap.bm.biz.flow.model.BizProcessNodeVO;
import com.comtop.cap.bm.biz.flow.model.BizRelInfoVO;
import com.comtop.cap.bm.biz.role.facade.BizRoleFacade;
import com.comtop.cap.doc.content.facade.ContentSegFacade;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.base.facade.BaseFacade;

/**
 * 业务流程节点 业务逻辑处理类 门面
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-11-16 CAP
 */
@PetiteBean
public class BizProcessNodeFacade extends BaseFacade {
    
    /** 日志对象 */
    protected final Logger logger = LoggerFactory.getLogger(BizProcessNodeFacade.class);
    
    /** 注入AppService **/
    @PetiteInject
    protected BizProcessNodeAppService bizProcessNodeAppService;
    
    /** 注入AppService **/
    @PetiteInject
    protected BizProcessInfoAppService bizProcessInfoAppService;
    
    /** 注入AppService **/
    @PetiteInject
    protected BizFormNodeRelFacade bizFormNodeRelFacade;
    
    /** 注入AppService **/
    @PetiteInject
    protected BizRoleFacade bizRoleFacade;
    
    /** 注入AppService **/
    @PetiteInject
    protected BizNodeConstraintFacade bizNodeConstraintFacade;
    
    /** 业务流程 */
    @PetiteInject
    protected BizProcessInfoFacade bizProcessInfoFacade;
    
    /** 注入DAO **/
    @PetiteInject
    protected BizRelInfoAppService bizRelInfoAppService;
    
    /** 非结构化内容数据服务 */
    @PetiteInject
    protected ContentSegFacade contentSegFacade;
    
    /** 节点角色关联 */
    @PetiteInject
    protected BizProcessNodeRoleAppService bizProcessNodeRoleAppService;
    
    /**
     * 构造函数
     */
    public BizProcessNodeFacade() {
        
    }
    
    /**
     * 新增 业务流程节点
     * 
     * @param bizProcessNodeVO 业务流程节点对象
     * @return 业务流程节点
     */
    public Object insertBizProcessNode(BizProcessNodeVO bizProcessNodeVO) {
        return bizProcessNodeAppService.insertBizProcessNode(bizProcessNodeVO);
    }
    
    /**
     * 更新 业务流程节点
     * 
     * @param bizProcessNodeVO 业务流程节点对象
     * @return 更新结果
     */
    public boolean updateBizProcessNode(BizProcessNodeVO bizProcessNodeVO) {
        BizRelInfoVO condition = new BizRelInfoVO();
        condition.setRoleaNodeId(bizProcessNodeVO.getId());
        condition.setRoleaNodeName(bizProcessNodeVO.getName());
        condition.setRolebNodeId(bizProcessNodeVO.getId());
        condition.setRolebNodeName(bizProcessNodeVO.getName());
        bizRelInfoAppService.synBizNodeConstraint(condition);
        return bizProcessNodeAppService.updateBizProcessNode(bizProcessNodeVO);
    }
    
    /**
     * 保存或更新业务流程节点，根据ID是否为空
     * 
     * @param bizProcessNodeVO 业务流程节点ID
     * @return 业务流程节点保存后的主键ID
     */
    public String saveBizProcessNode(BizProcessNodeVO bizProcessNodeVO) {
        if (bizProcessNodeVO.getId() == null) {
            String strId = (String) this.insertBizProcessNode(bizProcessNodeVO);
            bizProcessNodeVO.setId(strId);
        } else {
            this.updateBizProcessNode(bizProcessNodeVO);
        }
        return bizProcessNodeVO.getId();
    }
    
    /**
     * 读取 业务流程节点 列表，分页查询--新版设计器使用
     * 
     * @param condition 查询条件
     * @return 业务流程节点列表
     */
    public Map<String, Object> queryBizProcessNodeListByPage(BizProcessNodeVO condition) {
        final Map<String, Object> ret = new HashMap<String, Object>(2);
        int count = bizProcessNodeAppService.queryBizProcessNodeCount(condition);
        List<BizProcessNodeVO> bizProcessNodeVOList = null;
        if (count > 0) {
            bizProcessNodeVOList = bizProcessNodeAppService.queryBizProcessNodeList(condition);
        }
        ret.put("list", bizProcessNodeVOList);
        ret.put("count", count);
        return ret;
    }
    
    /**
     * 删除 业务流程节点
     * 
     * @param bizProcessNodeVO 业务流程节点对象
     * @return 删除结果
     */
    public boolean deleteBizProcessNode(BizProcessNodeVO bizProcessNodeVO) {
        return bizProcessNodeAppService.deleteBizProcessNode(bizProcessNodeVO);
    }
    
    /**
     * 删除 业务流程节点集合
     * 
     * @param bizProcessNodeVOList 业务流程节点对象
     * @return 删除结果
     */
    public boolean deleteBizProcessNodeList(List<BizProcessNodeVO> bizProcessNodeVOList) {
        return bizProcessNodeAppService.deleteBizProcessNodeList(bizProcessNodeVOList);
    }
    
    /**
     * 读取 业务流程节点
     * 
     * @param bizProcessNodeVO 业务流程节点对象
     * @return 业务流程节点
     */
    public BizProcessNodeVO loadBizProcessNode(BizProcessNodeVO bizProcessNodeVO) {
        return bizProcessNodeAppService.loadBizProcessNode(bizProcessNodeVO);
    }
    
    /**
     * 根据业务流程节点主键 读取 业务流程节点
     * 
     * @param id 业务流程节点主键
     * @return 业务流程节点
     */
    public BizProcessNodeVO loadBizProcessNodeById(String id) {
        return bizProcessNodeAppService.loadBizProcessNodeById(id);
    }
    
    /**
     * 读取 业务流程节点 列表
     * 
     * @param condition 查询条件
     * @return 业务流程节点列表
     */
    public List<BizProcessNodeVO> queryBizProcessNodeList(BizProcessNodeVO condition) {
        return bizProcessNodeAppService.queryBizProcessNodeList(condition);
    }
    
    /**
     * 读取 业务流程节点 列表（不分页）
     * 
     * @param condition 查询条件
     * @return 业务流程节点列表
     */
    public List<BizProcessNodeVO> queryBizProcessNodeListNoPaging(BizProcessNodeVO condition) {
        return bizProcessNodeAppService.queryBizProcessNodeList(condition);
    }
    
    /**
     * 读取 业务流程节点 数据条数
     * 
     * @param condition 查询条件
     * @return 业务流程节点数据条数
     */
    public int queryBizProcessNodeCount(BizProcessNodeVO condition) {
        return bizProcessNodeAppService.queryBizProcessNodeCount(condition);
    }
    
    /**
     * 查询流程节点(提供选择界面)
     * 
     * @param bizProcessNode 业务流程节点
     * @return 业务流程节点对象
     */
    public List<BizProcessNodeVO> queryNodeListForChoose(BizProcessNodeVO bizProcessNode) {
        return bizProcessNodeAppService.queryNodeListForChoose(bizProcessNode);
    }
    
    /**
     * 查询流程节点(提供选择界面)
     * 
     * @param bizProcessNode 业务流程节点
     * @return 业务流程节点对象
     */
    public List<BizProcessNodeVO> queryNodeInfoById(BizProcessNodeVO bizProcessNode) {
        return bizProcessNodeAppService.queryNodeInfoById(bizProcessNode);
    }
    
    /**
     * 
     * 查询流程节点使用条数
     * 
     * @param bizProcessNode 业务流程节点对象
     * @return 业务流程节点对象
     */
    public int queryUseBizProcessNodeCount(BizProcessNodeVO bizProcessNode) {
        return bizProcessNodeAppService.queryUseBizProcessNodeCount(bizProcessNode);
    }
}
