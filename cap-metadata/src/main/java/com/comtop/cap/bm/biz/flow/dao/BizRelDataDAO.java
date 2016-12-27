/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.biz.flow.dao;

import java.util.List;

import com.comtop.cap.base.MDBaseDAO;
import com.comtop.cap.bm.biz.flow.model.BizRelDataVO;
import com.comtop.cip.jodd.jtx.JtxPropagationBehavior;
import com.comtop.cip.jodd.jtx.meta.Transaction;
import com.comtop.cip.jodd.petite.meta.PetiteBean;

/**
 * 业务关联数据项DAO
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-11-26 CAP
 */
@PetiteBean
public class BizRelDataDAO extends MDBaseDAO<BizRelDataVO> {
    
    /**
     * 新增 业务关联数据项
     * 
     * @param bizRelData 业务关联数据项对象
     * @return 业务关联数据项Id
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public Object insertBizRelData(BizRelDataVO bizRelData) {
        Object result = insert(bizRelData);
        return result;
    }
    
    /**
     * 更新 业务关联数据项
     * 
     * @param bizRelData 业务关联数据项对象
     * @return 更新成功与否
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean updateBizRelData(BizRelDataVO bizRelData) {
        return update(bizRelData);
    }
    
    /**
     * 删除 业务关联数据项
     * 
     * @param bizRelData 业务关联数据项对象
     * @return 删除成功与否
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean deleteBizRelData(BizRelDataVO bizRelData) {
        return delete(bizRelData);
    }
    
    /**
     * 读取 业务关联数据项
     * 
     * @param bizRelData 业务关联数据项对象
     * @return 业务关联数据项
     */
    public BizRelDataVO loadBizRelData(BizRelDataVO bizRelData) {
        BizRelDataVO objBizRelData = load(bizRelData);
        return objBizRelData;
    }
    
    /**
     * 根据业务关联数据项主键读取 业务关联数据项
     * 
     * @param id 业务关联数据项主键
     * @return 业务关联数据项
     */
    public BizRelDataVO loadBizRelDataById(String id) {
        BizRelDataVO objBizRelData = new BizRelDataVO();
        objBizRelData.setId(id);
        return loadBizRelData(objBizRelData);
    }
    
    /**
     * 读取 业务关联数据项 列表
     * 
     * @param condition 查询条件
     * @return 业务关联数据项列表
     */
    public List<BizRelDataVO> queryBizRelDataList(BizRelDataVO condition) {
        return queryList("com.comtop.cap.bm.biz.flow.model.queryBizRelDataList", condition, condition.getPageNo(),
            condition.getPageSize());
    }
    
    /**
     * 读取 业务关联数据项 数据条数
     * 
     * @param condition 查询条件
     * @return 业务关联数据项数据条数
     */
    public int queryBizRelDataCount(BizRelDataVO condition) {
        return ((Integer) selectOne("com.comtop.cap.bm.biz.flow.model.queryBizRelDataCount", condition)).intValue();
    }
    
}
