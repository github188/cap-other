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
import com.comtop.cap.bm.biz.flow.dao.BizFormNodeRelDAO;
import com.comtop.cap.bm.biz.flow.model.BizFormNodeRelVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 业务表单和业务流程节点关系表 业务逻辑处理类
 * 
 * @author CIP
 * @since 1.0
 * @version 2015-11-24 CIP
 */
@PetiteBean
public class BizFormNodeRelAppService extends MDBaseAppservice<BizFormNodeRelVO> {
    
    /** 注入DAO **/
    @PetiteInject
    protected BizFormNodeRelDAO bizFormNodeRelDAO;
    
    /**
     * 新增 业务表单和业务流程节点关系表
     * 
     * @param bizFormNodeRel 业务表单和业务流程节点关系表对象
     * @return 业务表单和业务流程节点关系表Id
     */
    public Object insertBizFormNodeRel(BizFormNodeRelVO bizFormNodeRel) {
        return bizFormNodeRelDAO.insertBizFormNodeRel(bizFormNodeRel);
    }
    
    /**
     * 更新 业务表单和业务流程节点关系表
     * 
     * @param bizFormNodeRel 业务表单和业务流程节点关系表对象
     * @return 更新成功与否
     */
    public boolean updateBizFormNodeRel(BizFormNodeRelVO bizFormNodeRel) {
        return bizFormNodeRelDAO.updateBizFormNodeRel(bizFormNodeRel);
    }
    
    /**
     * 删除 业务表单和业务流程节点关系表
     * 
     * @param bizFormNodeRel 业务表单和业务流程节点关系表对象
     * @return 删除成功与否
     */
    public boolean deleteBizFormNodeRel(BizFormNodeRelVO bizFormNodeRel) {
        return bizFormNodeRelDAO.deleteBizFormNodeRel(bizFormNodeRel);
    }
    
    /**
     * 删除 业务表单和业务流程节点关系表集合
     * 
     * @param bizFormNodeRelList 业务表单和业务流程节点关系表对象
     * @return 删除成功与否
     */
    public boolean deleteBizFormNodeRelList(List<BizFormNodeRelVO> bizFormNodeRelList) {
        if (bizFormNodeRelList == null) {
            return true;
        }
        for (BizFormNodeRelVO bizFormNodeRel : bizFormNodeRelList) {
            this.deleteBizFormNodeRel(bizFormNodeRel);
        }
        return true;
    }
    
    /**
     * 读取 业务表单和业务流程节点关系表
     * 
     * @param bizFormNodeRel 业务表单和业务流程节点关系表对象
     * @return 业务表单和业务流程节点关系表
     */
    public BizFormNodeRelVO loadBizFormNodeRel(BizFormNodeRelVO bizFormNodeRel) {
        return bizFormNodeRelDAO.loadBizFormNodeRel(bizFormNodeRel);
    }
    
    /**
     * 根据业务表单和业务流程节点关系表主键读取 业务表单和业务流程节点关系表
     * 
     * @param id 业务表单和业务流程节点关系表主键
     * @return 业务表单和业务流程节点关系表
     */
    public BizFormNodeRelVO loadBizFormNodeRelById(String id) {
        return bizFormNodeRelDAO.loadBizFormNodeRelById(id);
    }
    
    /**
     * 读取 业务表单和业务流程节点关系表 列表
     * 
     * @param condition 查询条件
     * @return 业务表单和业务流程节点关系表列表
     */
    public List<BizFormNodeRelVO> queryBizFormNodeRelList(BizFormNodeRelVO condition) {
        return bizFormNodeRelDAO.queryBizFormNodeRelList(condition);
    }
    
    /**
     * 读取 业务表单和业务流程节点关系表 数据条数
     * 
     * @param condition 查询条件
     * @return 业务表单和业务流程节点关系表数据条数
     */
    public int queryBizFormNodeRelCount(BizFormNodeRelVO condition) {
        return bizFormNodeRelDAO.queryBizFormNodeRelCount(condition);
    }
    
    @Override
    protected MDBaseDAO<BizFormNodeRelVO> getDAO() {
        return bizFormNodeRelDAO;
    }
}
