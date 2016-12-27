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

import com.comtop.cap.bm.biz.flow.appservice.BizNodeConstraintAppService;
import com.comtop.cap.bm.biz.flow.model.BizNodeConstraintVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.base.facade.BaseFacade;

/**
 * 流程节点数据项约束 业务逻辑处理类 门面
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-11-20 CAP
 */
@PetiteBean
public class BizNodeConstraintFacade extends BaseFacade {
    
    /** 注入AppService **/
    @PetiteInject
    protected BizNodeConstraintAppService bizNodeConstraintAppService;
    
    /** 节点服务 */
    @PetiteInject
    protected BizProcessNodeFacade bizProcessNodeFacade;
    
    /**
     * 新增 流程节点数据项约束
     * 
     * @param bizNodeConstraintVO 流程节点数据项约束对象
     * @return 流程节点数据项约束
     */
    public Object insertBizNodeConstraint(BizNodeConstraintVO bizNodeConstraintVO) {
        return bizNodeConstraintAppService.insertBizNodeConstraint(bizNodeConstraintVO);
    }
    
    /**
     * 更新 流程节点数据项约束
     * 
     * @param bizNodeConstraintVO 流程节点数据项约束对象
     * @return 更新结果
     */
    public boolean updateBizNodeConstraint(BizNodeConstraintVO bizNodeConstraintVO) {
        return bizNodeConstraintAppService.updateBizNodeConstraint(bizNodeConstraintVO);
    }
    
    /**
     * 保存或更新流程节点数据项约束，根据ID是否为空
     * 
     * @param bizNodeConstraintVO 流程节点数据项约束ID
     * @return 流程节点数据项约束保存后的主键ID
     */
    public String saveBizNodeConstraint(BizNodeConstraintVO bizNodeConstraintVO) {
        if (bizNodeConstraintVO.getId() == null) {
            String strId = (String) this.insertBizNodeConstraint(bizNodeConstraintVO);
            bizNodeConstraintVO.setId(strId);
        } else {
            this.updateBizNodeConstraint(bizNodeConstraintVO);
        }
        return bizNodeConstraintVO.getId();
    }
    
    /**
     * 读取 流程节点数据项约束 列表，分页查询--新版设计器使用
     * 
     * @param condition 查询条件
     * @return 流程节点数据项约束列表
     */
    public Map<String, Object> queryBizNodeConstraintListByPage(BizNodeConstraintVO condition) {
        final Map<String, Object> ret = new HashMap<String, Object>(2);
        int count = bizNodeConstraintAppService.queryBizNodeConstraintCount(condition);
        List<BizNodeConstraintVO> bizNodeConstraintVOList = null;
        if (count > 0) {
            bizNodeConstraintVOList = bizNodeConstraintAppService.queryBizNodeConstraintList(condition);
        }
        ret.put("list", bizNodeConstraintVOList);
        ret.put("count", count);
        return ret;
    }
    
    /**
     * 删除 流程节点数据项约束
     * 
     * @param bizNodeConstraintVO 流程节点数据项约束对象
     * @return 删除结果
     */
    public boolean deleteBizNodeConstraint(BizNodeConstraintVO bizNodeConstraintVO) {
        return bizNodeConstraintAppService.deleteBizNodeConstraint(bizNodeConstraintVO);
    }
    
    /**
     * 删除 流程节点数据项约束集合
     * 
     * @param bizNodeConstraintVOList 流程节点数据项约束对象
     * @return 删除结果
     */
    public boolean deleteBizNodeConstraintList(List<BizNodeConstraintVO> bizNodeConstraintVOList) {
        return bizNodeConstraintAppService.deleteBizNodeConstraintList(bizNodeConstraintVOList);
    }
    
    /**
     * 读取 流程节点数据项约束
     * 
     * @param bizNodeConstraintVO 流程节点数据项约束对象
     * @return 流程节点数据项约束
     */
    public BizNodeConstraintVO loadBizNodeConstraint(BizNodeConstraintVO bizNodeConstraintVO) {
        return bizNodeConstraintAppService.loadBizNodeConstraint(bizNodeConstraintVO);
    }
    
    /**
     * 根据流程节点数据项约束主键 读取 流程节点数据项约束
     * 
     * @param id 流程节点数据项约束主键
     * @return 流程节点数据项约束
     */
    public BizNodeConstraintVO loadBizNodeConstraintById(String id) {
        return bizNodeConstraintAppService.loadBizNodeConstraintById(id);
    }
    
    /**
     * 读取 流程节点数据项约束 列表
     * 
     * @param condition 查询条件
     * @return 流程节点数据项约束列表
     */
    public List<BizNodeConstraintVO> queryBizNodeConstraintList(BizNodeConstraintVO condition) {
        return bizNodeConstraintAppService.queryBizNodeConstraintList(condition);
    }
    
    /**
     * 读取 流程节点数据项约束 数据条数
     * 
     * @param condition 查询条件
     * @return 流程节点数据项约束数据条数
     */
    public int queryBizNodeConstraintCount(BizNodeConstraintVO condition) {
        return bizNodeConstraintAppService.queryBizNodeConstraintCount(condition);
    }
    
    /**
     * 读取 流程节点数据项约束 列表
     * 
     * @param condition 查询条件
     * @return 流程节点数据项约束列表
     */
    public List<BizNodeConstraintVO> queryBizNodeConstraintGroupObjId(BizNodeConstraintVO condition) {
        return bizNodeConstraintAppService.queryBizNodeConstraintGroupObjId(condition);
    }
    
    /**
     * 删除流程节点数据项约束
     * 
     * @param bizNodeConstraintVO 流程节点数据项约束集合
     */
    public void deleteBizNodeConstraintByObjId(BizNodeConstraintVO bizNodeConstraintVO) {
        bizNodeConstraintAppService.deleteBizNodeConstraintByObjId(bizNodeConstraintVO);
    }
}
