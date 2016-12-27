/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.biz.flow.dao;

import java.util.List;

import com.comtop.cap.base.MDBaseDAO;
import com.comtop.cap.bm.biz.flow.model.BizRelInfoVO;
import com.comtop.cip.jodd.jtx.JtxPropagationBehavior;
import com.comtop.cip.jodd.jtx.meta.Transaction;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.util.StringUtil;

/**
 * 业务关联DAO
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-11-25 CAP
 */
@PetiteBean
public class BizRelInfoDAO extends MDBaseDAO<BizRelInfoVO> {
    
    /**
     * 新增 业务关联
     * 
     * @param bizRelInfo 业务关联对象
     * @return 业务关联Id
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public Object insertBizRelInfo(BizRelInfoVO bizRelInfo) {
        Object result = insert(bizRelInfo);
        return result;
    }
    
    /**
     * 更新 业务关联
     * 
     * @param bizRelInfo 业务关联对象
     * @return 更新成功与否
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean updateBizRelInfo(BizRelInfoVO bizRelInfo) {
        return update(bizRelInfo);
    }
    
    /**
     * 删除 业务关联
     * 
     * @param bizRelInfo 业务关联对象
     * @return 删除成功与否
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean deleteBizRelInfo(BizRelInfoVO bizRelInfo) {
        return delete(bizRelInfo);
    }
    
    /**
     * 读取 业务关联
     * 
     * @param bizRelInfo 业务关联对象
     * @return 业务关联
     */
    public BizRelInfoVO loadBizRelInfo(BizRelInfoVO bizRelInfo) {
        BizRelInfoVO objBizRelInfo = load(bizRelInfo);
        return objBizRelInfo;
    }
    
    /**
     * 根据业务关联主键读取 业务关联
     * 
     * @param id 业务关联主键
     * @return 业务关联
     */
    public BizRelInfoVO loadBizRelInfoById(String id) {
        BizRelInfoVO objBizRelInfo = new BizRelInfoVO();
        objBizRelInfo.setId(id);
        return loadBizRelInfo(objBizRelInfo);
    }
    
    /**
     * 读取 业务关联 列表
     * 
     * @param condition 查询条件
     * @return 业务关联列表
     */
    public List<BizRelInfoVO> queryBizRelInfoList(BizRelInfoVO condition) {
        return queryList("com.comtop.cap.bm.biz.flow.model.queryBizRelInfoList", condition);
    }
    
    /**
     * 读取 业务关联 数据条数
     * 
     * @param condition 查询条件
     * @return 业务关联数据条数
     */
    public int queryBizRelInfoCount(BizRelInfoVO condition) {
        return ((Integer) selectOne("com.comtop.cap.bm.biz.flow.model.queryBizRelInfoCount", condition)).intValue();
    }
    
    /**
     * 同步数据
     * 
     * @param condition 业务关联
     */
    public void synBizNodeConstraint(BizRelInfoVO condition) {
        if (StringUtil.isNotBlank(condition.getRoleaDomainId())) {
            super.execute("update CAP_BIZ_REL_INFO set ROLEA_DOMAIN_NAME='" + condition.getRoleaDomainName()
                + "' where ROLEA_DOMAIN_ID='" + condition.getRoleaDomainId() + "'");
            super.execute("update CAP_BIZ_REL_INFO set ROLEB_DOMAIN_NAME='" + condition.getRolebDomainName()
                + "' where ROLEB_DOMAIN_ID='" + condition.getRolebDomainId() + "'");
            
        }
        if (StringUtil.isNotBlank(condition.getRoleaProcessId())) {
            super.execute("update CAP_BIZ_REL_INFO set ROLEA_PROCESS_NAME='" + condition.getRoleaProcessName()
                + "' where ROLEA_PROCESS_ID='" + condition.getRoleaProcessId() + "'");
            super.execute("update CAP_BIZ_REL_INFO set ROLEB_PROCESS_NAME='" + condition.getRolebProcessName()
                + "' where ROLEB_PROCESS_ID='" + condition.getRolebProcessId() + "'");
        }
        if (StringUtil.isNotBlank(condition.getRoleaNodeId())) {
            super.execute("update CAP_BIZ_REL_INFO set ROLEA_NODE_NAME='" + condition.getRoleaNodeName()
                + "' where ROLEA_NODE_ID='" + condition.getRoleaNodeId() + "'");
            super.execute("update CAP_BIZ_REL_INFO set ROLEB_NODE_NAME='" + condition.getRolebNodeName()
                + "' where ROLEB_NODE_ID='" + condition.getRolebNodeId() + "'");
        }
    }
}
