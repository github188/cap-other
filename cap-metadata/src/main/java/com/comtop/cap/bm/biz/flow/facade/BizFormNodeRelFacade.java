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

import com.comtop.cap.bm.biz.flow.appservice.BizFormNodeRelAppService;
import com.comtop.cap.bm.biz.flow.model.BizFormNodeRelVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.base.facade.BaseFacade;

/**
 * 业务表单和业务流程节点关系表 业务逻辑处理类 门面
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-11-24 CAP
 */
@PetiteBean
public class BizFormNodeRelFacade extends BaseFacade {
    
    /** 注入AppService **/
    @PetiteInject
    protected BizFormNodeRelAppService bizFormNodeRelAppService;
    
    /**
     * 新增 业务表单和业务流程节点关系表
     * 
     * @param bizFormNodeRelVO 业务表单和业务流程节点关系表对象
     * @return 业务表单和业务流程节点关系表
     */
    public Object insertBizFormNodeRel(BizFormNodeRelVO bizFormNodeRelVO) {
        return bizFormNodeRelAppService.insertBizFormNodeRel(bizFormNodeRelVO);
    }
    
    /**
     * 更新 业务表单和业务流程节点关系表
     * 
     * @param bizFormNodeRelVO 业务表单和业务流程节点关系表对象
     * @return 更新结果
     */
    public boolean updateBizFormNodeRel(BizFormNodeRelVO bizFormNodeRelVO) {
        return bizFormNodeRelAppService.updateBizFormNodeRel(bizFormNodeRelVO);
    }
    
    /**
     * 保存或更新业务表单和业务流程节点关系表，根据ID是否为空
     * 
     * @param bizFormNodeRelVO 业务表单和业务流程节点关系表ID
     * @return 业务表单和业务流程节点关系表保存后的主键ID
     */
    public String saveBizFormNodeRel(BizFormNodeRelVO bizFormNodeRelVO) {
        if (bizFormNodeRelVO.getId() == null) {
            String strId = (String) this.insertBizFormNodeRel(bizFormNodeRelVO);
            bizFormNodeRelVO.setId(strId);
        } else {
            this.updateBizFormNodeRel(bizFormNodeRelVO);
        }
        return bizFormNodeRelVO.getId();
    }
    
    /**
     * 读取 业务表单和业务流程节点关系表 列表，分页查询--新版设计器使用
     * 
     * @param condition 查询条件
     * @return 业务表单和业务流程节点关系表列表
     */
    public Map<String, Object> queryBizFormNodeRelListByPage(BizFormNodeRelVO condition) {
        final Map<String, Object> ret = new HashMap<String, Object>(2);
        int count = bizFormNodeRelAppService.queryBizFormNodeRelCount(condition);
        List<BizFormNodeRelVO> bizFormNodeRelVOList = null;
        if (count > 0) {
            bizFormNodeRelVOList = bizFormNodeRelAppService.queryBizFormNodeRelList(condition);
        }
        ret.put("list", bizFormNodeRelVOList);
        ret.put("count", count);
        return ret;
    }
    
    /**
     * 删除 业务表单和业务流程节点关系表
     * 
     * @param bizFormNodeRelVO 业务表单和业务流程节点关系表对象
     * @return 删除结果
     */
    public boolean deleteBizFormNodeRel(BizFormNodeRelVO bizFormNodeRelVO) {
        return bizFormNodeRelAppService.deleteBizFormNodeRel(bizFormNodeRelVO);
    }
    
    /**
     * 删除 业务表单和业务流程节点关系表集合
     * 
     * @param bizFormNodeRelVOList 业务表单和业务流程节点关系表对象
     * @return 删除结果
     */
    public boolean deleteBizFormNodeRelList(List<BizFormNodeRelVO> bizFormNodeRelVOList) {
        return bizFormNodeRelAppService.deleteBizFormNodeRelList(bizFormNodeRelVOList);
    }
    
    /**
     * 读取 业务表单和业务流程节点关系表
     * 
     * @param bizFormNodeRelVO 业务表单和业务流程节点关系表对象
     * @return 业务表单和业务流程节点关系表
     */
    public BizFormNodeRelVO loadBizFormNodeRel(BizFormNodeRelVO bizFormNodeRelVO) {
        return bizFormNodeRelAppService.loadBizFormNodeRel(bizFormNodeRelVO);
    }
    
    /**
     * 根据业务表单和业务流程节点关系表主键 读取 业务表单和业务流程节点关系表
     * 
     * @param id 业务表单和业务流程节点关系表主键
     * @return 业务表单和业务流程节点关系表
     */
    public BizFormNodeRelVO loadBizFormNodeRelById(String id) {
        return bizFormNodeRelAppService.loadBizFormNodeRelById(id);
    }
    
    /**
     * 读取 业务表单和业务流程节点关系表 列表
     * 
     * @param condition 查询条件
     * @return 业务表单和业务流程节点关系表列表
     */
    public List<BizFormNodeRelVO> queryBizFormNodeRelList(BizFormNodeRelVO condition) {
        return bizFormNodeRelAppService.queryBizFormNodeRelList(condition);
    }
    
    /**
     * 读取 业务表单和业务流程节点关系表 数据条数
     * 
     * @param condition 查询条件
     * @return 业务表单和业务流程节点关系表数据条数
     */
    public int queryBizFormNodeRelCount(BizFormNodeRelVO condition) {
        return bizFormNodeRelAppService.queryBizFormNodeRelCount(condition);
    }
    
}
