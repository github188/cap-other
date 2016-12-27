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
import com.comtop.cap.bm.biz.flow.dao.BizNodeConstraintDAO;
import com.comtop.cap.bm.biz.flow.model.BizNodeConstraintVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 流程节点数据项约束 业务逻辑处理类
 * 
 * @author CIP
 * @since 1.0
 * @version 2015-11-20 CIP
 */
@PetiteBean
public class BizNodeConstraintAppService extends MDBaseAppservice<BizNodeConstraintVO> {
    
    /** 注入DAO **/
    @PetiteInject
    protected BizNodeConstraintDAO bizNodeConstraintDAO;
    
    /**
     * 新增 流程节点数据项约束
     * 
     * @param bizNodeConstraint 流程节点数据项约束对象
     * @return 流程节点数据项约束Id
     */
    public Object insertBizNodeConstraint(BizNodeConstraintVO bizNodeConstraint) {
        return bizNodeConstraintDAO.insertBizNodeConstraint(bizNodeConstraint);
    }
    
    /**
     * 更新 流程节点数据项约束
     * 
     * @param bizNodeConstraint 流程节点数据项约束对象
     * @return 更新成功与否
     */
    public boolean updateBizNodeConstraint(BizNodeConstraintVO bizNodeConstraint) {
        return bizNodeConstraintDAO.updateBizNodeConstraint(bizNodeConstraint);
    }
    
    /**
     * 删除 流程节点数据项约束
     * 
     * @param bizNodeConstraint 流程节点数据项约束对象
     * @return 删除成功与否
     */
    public boolean deleteBizNodeConstraint(BizNodeConstraintVO bizNodeConstraint) {
        return bizNodeConstraintDAO.deleteBizNodeConstraint(bizNodeConstraint);
    }
    
    /**
     * 删除 流程节点数据项约束集合
     * 
     * @param bizNodeConstraintList 流程节点数据项约束对象
     * @return 删除成功与否
     */
    public boolean deleteBizNodeConstraintList(List<BizNodeConstraintVO> bizNodeConstraintList) {
        if (bizNodeConstraintList == null) {
            return true;
        }
        for (BizNodeConstraintVO bizNodeConstraint : bizNodeConstraintList) {
            this.deleteBizNodeConstraint(bizNodeConstraint);
        }
        return true;
    }
    
    /**
     * 读取 流程节点数据项约束
     * 
     * @param bizNodeConstraint 流程节点数据项约束对象
     * @return 流程节点数据项约束
     */
    public BizNodeConstraintVO loadBizNodeConstraint(BizNodeConstraintVO bizNodeConstraint) {
        return bizNodeConstraintDAO.loadBizNodeConstraint(bizNodeConstraint);
    }
    
    /**
     * 根据流程节点数据项约束主键读取 流程节点数据项约束
     * 
     * @param id 流程节点数据项约束主键
     * @return 流程节点数据项约束
     */
    public BizNodeConstraintVO loadBizNodeConstraintById(String id) {
        return bizNodeConstraintDAO.loadBizNodeConstraintById(id);
    }
    
    /**
     * 读取 流程节点数据项约束 列表
     * 
     * @param condition 查询条件
     * @return 流程节点数据项约束列表
     */
    public List<BizNodeConstraintVO> queryBizNodeConstraintList(BizNodeConstraintVO condition) {
        return bizNodeConstraintDAO.queryBizNodeConstraintList(condition);
    }
    
    /**
     * 读取 流程节点数据项约束 数据条数
     * 
     * @param condition 查询条件
     * @return 流程节点数据项约束数据条数
     */
    public int queryBizNodeConstraintCount(BizNodeConstraintVO condition) {
        return bizNodeConstraintDAO.queryBizNodeConstraintCount(condition);
    }
    
    /**
     * 读取 流程节点数据项约束 列表
     * 
     * @param condition 查询条件
     * @return 流程节点数据项约束列表
     */
    public List<BizNodeConstraintVO> queryBizNodeConstraintGroupObjId(BizNodeConstraintVO condition) {
        return bizNodeConstraintDAO.queryBizNodeConstraintGroupObjId(condition);
    }
    
    /**
     * 删除流程节点数据项约束
     * 
     * @param bizNodeConstraintVO 流程节点数据项约束集合
     */
    public void deleteBizNodeConstraintByObjId(BizNodeConstraintVO bizNodeConstraintVO) {
        bizNodeConstraintDAO.deleteBizNodeConstraintByObjId(bizNodeConstraintVO);
    }
    
    @Override
    protected MDBaseDAO<BizNodeConstraintVO> getDAO() {
        return bizNodeConstraintDAO;
    }
    
}
