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

import com.comtop.cap.bm.biz.flow.appservice.BizProcessInfoAppService;
import com.comtop.cap.bm.biz.flow.appservice.BizProcessNodeAppService;
import com.comtop.cap.bm.biz.flow.appservice.BizRelInfoAppService;
import com.comtop.cap.bm.biz.flow.model.BizProcessInfoVO;
import com.comtop.cap.bm.biz.flow.model.BizRelInfoVO;
import com.comtop.cap.bm.biz.items.facade.BizItemsFacade;
import com.comtop.cap.runtime.component.facade.AutoGenNumberFacade;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.base.facade.BaseFacade;
import com.comtop.cap.runtime.core.AppBeanUtil;

/**
 * 业务流程 业务逻辑处理类 门面
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-11-12 CAP
 */
@PetiteBean
public class BizProcessInfoFacade extends BaseFacade {
    
    /** 注入AppService **/
    @PetiteInject
    protected BizProcessInfoAppService bizProcessInfoAppService;
    
    /** 节点facede */
    @PetiteInject
    protected BizProcessNodeFacade bizProcessNodeFacade;
    
    /** 节点facede */
    @PetiteInject
    protected BizProcessNodeAppService bizProcessNodeAppService;
    
    /** 注入DAO **/
    @PetiteInject
    protected BizRelInfoAppService bizRelInfoAppService;
    
    /** FIXME */
    @PetiteInject
    protected BizItemsFacade bizItemsFacade;
    
    /**
     * 新增 业务流程
     * 
     * @param bizProcessInfoVO 业务流程对象
     * @return 业务流程
     */
    public Object insertBizProcessInfo(BizProcessInfoVO bizProcessInfoVO) {
    	AutoGenNumberFacade autoGenNumberService = AppBeanUtil.getBean(AutoGenNumberFacade.class);
        String code = autoGenNumberService.genNumber(BizProcessInfoVO.getCodeExpr(), null);
        bizProcessInfoVO.setCode(code);
        String id = (String) bizProcessInfoAppService.insertBizProcessInfo(bizProcessInfoVO);
        bizProcessInfoAppService.updatePropertyById(id, "code", code);
        return id;
    }
    
    /**
     * 更新 业务流程
     * 
     * @param bizProcessInfoVO 业务流程对象
     * @return 更新结果
     */
    public boolean updateBizProcessInfo(BizProcessInfoVO bizProcessInfoVO) {
        BizRelInfoVO condition = new BizRelInfoVO();
        condition.setRoleaProcessId(bizProcessInfoVO.getId());
        condition.setRoleaProcessName(bizProcessInfoVO.getProcessName());
        condition.setRolebProcessId(bizProcessInfoVO.getId());
        condition.setRolebProcessName(bizProcessInfoVO.getProcessName());
        bizRelInfoAppService.synBizNodeConstraint(condition);
        return bizProcessInfoAppService.updateBizProcessInfo(bizProcessInfoVO);
    }
    
    /**
     * 保存或更新业务流程，根据ID是否为空
     * 
     * @param bizProcessInfoVO 业务流程ID
     * @return 业务流程保存后的主键ID
     */
    public String saveBizProcessInfo(BizProcessInfoVO bizProcessInfoVO) {
        if (bizProcessInfoVO.getId() == null) {
            String strId = (String) this.insertBizProcessInfo(bizProcessInfoVO);
            bizProcessInfoVO.setId(strId);
        } else {
            this.updateBizProcessInfo(bizProcessInfoVO);
        }
        return bizProcessInfoVO.getId();
    }
    
    /**
     * 读取 业务流程 列表，分页查询--新版设计器使用
     * 
     * @param condition 查询条件
     * @return 业务流程列表
     */
    public Map<String, Object> queryBizProcessInfoListByPage(BizProcessInfoVO condition) {
        final Map<String, Object> ret = new HashMap<String, Object>(2);
        int count = bizProcessInfoAppService.queryBizProcessInfoCount(condition);
        List<BizProcessInfoVO> bizProcessInfoVOList = null;
        if (count > 0) {
            bizProcessInfoVOList = bizProcessInfoAppService.queryBizProcessInfoList(condition);
        }
        ret.put("list", bizProcessInfoVOList);
        ret.put("count", count);
        return ret;
    }
    
    /**
     * 删除 业务流程
     * 
     * @param bizProcessInfoVO 业务流程对象
     * @return 删除结果
     */
    public boolean deleteBizProcessInfo(BizProcessInfoVO bizProcessInfoVO) {
        return bizProcessInfoAppService.deleteBizProcessInfo(bizProcessInfoVO);
    }
    
    /**
     * 删除 业务流程集合
     * 
     * @param bizProcessInfoVOList 业务流程对象
     * @return 删除结果
     */
    public boolean deleteBizProcessInfoList(List<BizProcessInfoVO> bizProcessInfoVOList) {
        return bizProcessInfoAppService.deleteBizProcessInfoList(bizProcessInfoVOList);
    }
    
    /**
     * 读取 业务流程
     * 
     * @param bizProcessInfoVO 业务流程对象
     * @return 业务流程
     */
    public BizProcessInfoVO loadBizProcessInfo(BizProcessInfoVO bizProcessInfoVO) {
        return bizProcessInfoAppService.loadBizProcessInfo(bizProcessInfoVO);
    }
    
    /**
     * 根据业务流程主键 读取 业务流程
     * 
     * @param id 业务流程主键
     * @return 业务流程
     */
    public BizProcessInfoVO loadBizProcessInfoById(String id) {
        return bizProcessInfoAppService.loadBizProcessInfoById(id);
    }
    
    /**
     * 读取 业务流程 列表
     * 
     * @param condition 查询条件
     * @return 业务流程列表
     */
    public List<BizProcessInfoVO> queryBizProcessInfoList(BizProcessInfoVO condition) {
        return bizProcessInfoAppService.queryBizProcessInfoList(condition);
    }
    
    /**
     * 读取 业务流程 数据条数
     * 
     * @param condition 查询条件
     * @return 业务流程数据条数
     */
    public int queryBizProcessInfoCount(BizProcessInfoVO condition) {
        return bizProcessInfoAppService.queryBizProcessInfoCount(condition);
    }
    
    /**
     * 查询存在流程节点数量
     * 
     * @param bizProcessInfo 业务流程
     * @return 流程节点数量
     */
    public int queryProcessNodeCount(BizProcessInfoVO bizProcessInfo) {
        return bizProcessInfoAppService.queryProcessNodeCount(bizProcessInfo);
    }
}
