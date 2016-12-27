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
import com.comtop.cap.bm.biz.flow.dao.BizProcessInfoDAO;
import com.comtop.cap.bm.biz.flow.model.BizProcessInfoVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 业务流程 业务逻辑处理类
 * 
 * @author CIP
 * @since 1.0
 * @version 2015-11-12 CIP
 */
@PetiteBean
public class BizProcessInfoAppService extends MDBaseAppservice<BizProcessInfoVO> {
    
    /** 注入DAO **/
    @PetiteInject
    protected BizProcessInfoDAO bizProcessInfoDAO;
    
    /**
     * 新增 业务流程
     * 
     * @param bizProcessInfo 业务流程对象
     * @return 业务流程Id
     */
    public Object insertBizProcessInfo(BizProcessInfoVO bizProcessInfo) {
        return bizProcessInfoDAO.insertBizProcessInfo(bizProcessInfo);
    }
    
    /**
     * 更新 业务流程
     * 
     * @param bizProcessInfo 业务流程对象
     * @return 更新成功与否
     */
    public boolean updateBizProcessInfo(BizProcessInfoVO bizProcessInfo) {
        return bizProcessInfoDAO.updateBizProcessInfo(bizProcessInfo);
    }
    
    /**
     * 删除 业务流程
     * 
     * @param bizProcessInfo 业务流程对象
     * @return 删除成功与否
     */
    public boolean deleteBizProcessInfo(BizProcessInfoVO bizProcessInfo) {
        return bizProcessInfoDAO.deleteBizProcessInfo(bizProcessInfo);
    }
    
    /**
     * 删除 业务流程集合
     * 
     * @param bizProcessInfoList 业务流程对象
     * @return 删除成功与否
     */
    public boolean deleteBizProcessInfoList(List<BizProcessInfoVO> bizProcessInfoList) {
        if (bizProcessInfoList == null) {
            return true;
        }
        for (BizProcessInfoVO bizProcessInfo : bizProcessInfoList) {
            this.deleteBizProcessInfo(bizProcessInfo);
        }
        return true;
    }
    
    /**
     * 读取 业务流程
     * 
     * @param bizProcessInfo 业务流程对象
     * @return 业务流程
     */
    public BizProcessInfoVO loadBizProcessInfo(BizProcessInfoVO bizProcessInfo) {
        return bizProcessInfoDAO.loadBizProcessInfo(bizProcessInfo);
    }
    
    /**
     * 根据业务流程主键读取 业务流程
     * 
     * @param id 业务流程主键
     * @return 业务流程
     */
    public BizProcessInfoVO loadBizProcessInfoById(String id) {
        return bizProcessInfoDAO.loadBizProcessInfoById(id);
    }
    
    /**
     * 读取 业务流程 列表
     * 
     * @param condition 查询条件
     * @return 业务流程列表
     */
    public List<BizProcessInfoVO> queryBizProcessInfoList(BizProcessInfoVO condition) {
        return bizProcessInfoDAO.queryBizProcessInfoList(condition);
    }
    
    /**
     * 读取 业务流程 数据条数
     * 
     * @param condition 查询条件
     * @return 业务流程数据条数
     */
    public int queryBizProcessInfoCount(BizProcessInfoVO condition) {
        return bizProcessInfoDAO.queryBizProcessInfoCount(condition);
    }
    
    /**
     * 查询存在流程节点数量
     * 
     * @param bizProcessInfo 业务流程
     * @return 流程节点数量
     */
    public int queryProcessNodeCount(BizProcessInfoVO bizProcessInfo) {
        return bizProcessInfoDAO.queryProcessNodeCount(bizProcessInfo);
    }
    
    @Override
    protected MDBaseDAO<BizProcessInfoVO> getDAO() {
        return bizProcessInfoDAO;
    }
    
    /**
     * 通过idList获取名称集合
     * 
     * @param condition 查询条件
     * @return 节点名称
     */
    public String queryProcessNodeNames(BizProcessInfoVO condition) {
        return bizProcessInfoDAO.queryProcessNodeNames(condition);
    }
}
