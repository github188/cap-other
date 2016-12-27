/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.biz.info.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.comtop.cap.base.MDBaseDAO;
import com.comtop.cap.bm.biz.info.model.BizObjDataItemVO;
import com.comtop.cip.jodd.jtx.JtxPropagationBehavior;
import com.comtop.cip.jodd.jtx.meta.Transaction;
import com.comtop.cip.jodd.petite.meta.PetiteBean;

/**
 * 业务对象数据项扩展DAO
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-11-10 CAP
 */
@PetiteBean
public class BizObjDataItemDAO extends MDBaseDAO<BizObjDataItemVO> {
    
    /**
     * 新增 业务对象数据项
     * 
     * @param bizObjDataItem 业务对象数据项对象
     * @return 业务对象数据项Id
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public Object insertBizObjDataItem(BizObjDataItemVO bizObjDataItem) {
        Object result = insert(bizObjDataItem);
        return result;
    }
    
    /**
     * 更新 业务对象数据项
     * 
     * @param bizObjDataItem 业务对象数据项对象
     * @return 更新成功与否
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean updateBizObjDataItem(BizObjDataItemVO bizObjDataItem) {
        return update(bizObjDataItem);
    }
    
    /**
     * 删除 业务对象数据项
     * 
     * @param bizObjDataItem 业务对象数据项对象
     * @return 删除成功与否
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean deleteBizObjDataItem(BizObjDataItemVO bizObjDataItem) {
        return delete(bizObjDataItem);
    }
    
    /**
     * 读取 业务对象数据项
     * 
     * @param bizObjDataItem 业务对象数据项对象
     * @return 业务对象数据项
     */
    public BizObjDataItemVO loadBizObjDataItem(BizObjDataItemVO bizObjDataItem) {
        BizObjDataItemVO objBizObjDataItem = load(bizObjDataItem);
        return objBizObjDataItem;
    }
    
    /**
     * 根据业务对象数据项主键读取 业务对象数据项
     * 
     * @param id 业务对象数据项主键
     * @return 业务对象数据项
     */
    public BizObjDataItemVO loadBizObjDataItemById(String id) {
        BizObjDataItemVO objBizObjDataItem = new BizObjDataItemVO();
        objBizObjDataItem.setId(id);
        return loadBizObjDataItem(objBizObjDataItem);
    }
    
    /**
     * 读取 业务对象数据项 列表
     * 
     * @param condition 查询条件
     * @return 业务对象数据项列表
     */
    public List<BizObjDataItemVO> queryBizObjDataItemList(BizObjDataItemVO condition) {
        return queryList("com.comtop.cap.bm.biz.info.model.queryBizObjDataItemList", condition, condition.getPageNo(),
            condition.getPageSize());
    }
    
    /**
     * 根据业务对象数据项的ID集合查询对应的业务对象数据项VO集合
     * @param ids 业务对象数据项的ID集合，为空是返回空集合
     * @return 符合条件的业务对象数据项VO集合
     */
    public List<BizObjDataItemVO> queryBizObjDataItemListByIds(List<String> ids) {
        return queryList("com.comtop.cap.bm.biz.info.model.queryBizObjDataItemListByIds", ids);
    }
    
    
    /**
     * 读取 业务对象数据项 数据条数
     * 
     * @param condition 查询条件
     * @return 业务对象数据项数据条数
     */
    public int queryBizObjDataItemCount(BizObjDataItemVO condition) {
        return ((Integer) selectOne("com.comtop.cap.bm.biz.info.model.queryBizObjDataItemCount", condition)).intValue();
    }
    
    /**
     * 根据业务对象ID集合查询业务对象数据项集合
     *
     * @param objIds 业务对象ID集合
     * @return 业务对象数据项集合
     */
    public List<BizObjDataItemVO> loadBizObjDataItemsByIds(String[] objIds) {
        Map<String, String[]> condition = new HashMap<String, String[]>();
        condition.put("objIds", objIds);
        return queryList("com.comtop.cap.bm.biz.info.model.loadBizObjDataItemsByIds", condition);
    }
    
}
