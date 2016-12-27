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
import com.comtop.cap.bm.biz.flow.dao.BizProcessNodeDAO;
import com.comtop.cap.bm.biz.flow.model.BizProcessNodeVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 业务流程节点 业务逻辑处理类
 * 
 * @author CIP
 * @since 1.0
 * @version 2015-11-16 CIP
 */
@PetiteBean
public class BizProcessNodeAppService extends MDBaseAppservice<BizProcessNodeVO> {
    
    /** 注入DAO **/
    @PetiteInject
    protected BizProcessNodeDAO bizProcessNodeDAO;
    
    /**
     * 新增 业务流程节点
     * 
     * @param bizProcessNode 业务流程节点对象
     * @return 业务流程节点Id
     */
    public Object insertBizProcessNode(BizProcessNodeVO bizProcessNode) {
        return bizProcessNodeDAO.insertBizProcessNode(bizProcessNode);
    }
    
    /**
     * 更新 业务流程节点
     * 
     * @param bizProcessNode 业务流程节点对象
     * @return 更新成功与否
     */
    public boolean updateBizProcessNode(BizProcessNodeVO bizProcessNode) {
        return bizProcessNodeDAO.updateBizProcessNode(bizProcessNode);
    }
    
    /**
     * 删除 业务流程节点
     * 
     * @param bizProcessNode 业务流程节点对象
     * @return 删除成功与否
     */
    public boolean deleteBizProcessNode(BizProcessNodeVO bizProcessNode) {
        return bizProcessNodeDAO.deleteBizProcessNode(bizProcessNode);
    }
    
    /**
     * 删除 业务流程节点集合
     * 
     * @param bizProcessNodeList 业务流程节点对象
     * @return 删除成功与否
     */
    public boolean deleteBizProcessNodeList(List<BizProcessNodeVO> bizProcessNodeList) {
        if (bizProcessNodeList == null) {
            return true;
        }
        for (BizProcessNodeVO bizProcessNode : bizProcessNodeList) {
            this.deleteBizProcessNode(bizProcessNode);
        }
        return true;
    }
    
    /**
     * 读取 业务流程节点
     * 
     * @param bizProcessNode 业务流程节点对象
     * @return 业务流程节点
     */
    public BizProcessNodeVO loadBizProcessNode(BizProcessNodeVO bizProcessNode) {
        return bizProcessNodeDAO.loadBizProcessNode(bizProcessNode);
    }
    
    /**
     * 根据业务流程节点主键读取 业务流程节点
     * 
     * @param id 业务流程节点主键
     * @return 业务流程节点
     */
    public BizProcessNodeVO loadBizProcessNodeById(String id) {
        return bizProcessNodeDAO.loadBizProcessNodeById(id);
    }
    
    /**
     * 读取 业务流程节点 列表
     * 
     * @param condition 查询条件
     * @return 业务流程节点列表
     */
    public List<BizProcessNodeVO> queryBizProcessNodeList(BizProcessNodeVO condition) {
        return bizProcessNodeDAO.queryBizProcessNodeList(condition);
    }
    
    /**
     * 读取 业务流程节点 列表（不分页）
     * 
     * @param condition 查询条件
     * @return 业务流程节点列表
     */
    public List<BizProcessNodeVO> queryBizProcessNodeListNoPaging(BizProcessNodeVO condition) {
        return bizProcessNodeDAO.queryBizProcessNodeList(condition);
    }
    
    /**
     * 读取 业务流程节点 数据条数
     * 
     * @param condition 查询条件
     * @return 业务流程节点数据条数
     */
    public int queryBizProcessNodeCount(BizProcessNodeVO condition) {
        return bizProcessNodeDAO.queryBizProcessNodeCount(condition);
    }
    
    /**
     * 查询流程节点(提供选择界面)
     * 
     * @param bizProcessNode 业务流程节点
     * @return 业务流程节点对象
     */
    public List<BizProcessNodeVO> queryNodeListForChoose(BizProcessNodeVO bizProcessNode) {
        return bizProcessNodeDAO.queryNodeListForChoose(bizProcessNode);
    }
    
    /**
     * 查询流程节点(提供选择界面)
     * 
     * @param bizProcessNode 业务流程节点
     * @return 业务流程节点对象
     */
    public List<BizProcessNodeVO> queryNodeInfoById(BizProcessNodeVO bizProcessNode) {
        return bizProcessNodeDAO.queryNodeInfoById(bizProcessNode);
    }
    
    /**
     * 
     * 查询流程节点使用条数
     * 
     * @param bizProcessNode 业务流程节点对象
     * @return 业务流程节点对象
     */
    public int queryUseBizProcessNodeCount(BizProcessNodeVO bizProcessNode) {
        return bizProcessNodeDAO.queryUseBizProcessNodeCount(bizProcessNode);
    }
    
    @Override
    protected MDBaseDAO<BizProcessNodeVO> getDAO() {
        return bizProcessNodeDAO;
    }
}
