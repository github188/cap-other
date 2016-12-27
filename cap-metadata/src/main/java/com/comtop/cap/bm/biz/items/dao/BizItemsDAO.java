/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.biz.items.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.comtop.cap.base.MDBaseDAO;
import com.comtop.cap.bm.biz.items.model.BizItemsVO;
import com.comtop.cap.common.executor.PropertyReadExecutor;
import com.comtop.cap.common.executor.PropertyUpdateExecutor;
import com.comtop.cip.jodd.jtx.JtxPropagationBehavior;
import com.comtop.cip.jodd.jtx.meta.Transaction;
import com.comtop.cip.jodd.petite.meta.PetiteBean;

/**
 * 业务事项DAO
 * 
 * @author 姜子豪
 * @since 1.0
 * @version 2015-11-11 姜子豪
 */
@PetiteBean
public class BizItemsDAO extends MDBaseDAO<BizItemsVO> {
    
    /**
     * 新增 业务事项
     * 
     * @param bizItems 业务事项对象
     * @return 业务事项Id
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public Object insertBizItems(BizItemsVO bizItems) {
        int sortNo = getItemMaxSort(bizItems) + 1;
        bizItems.setSortNo(sortNo);
        Object result = insert(bizItems);
        return result;
    }
    
    /**
     * 更新 业务事项
     * 
     * @param bizItems 业务事项对象
     * @return 更新成功与否
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean updateBizItems(BizItemsVO bizItems) {
        return update(bizItems);
    }
    
    /**
     * 删除 业务事项
     * 
     * @param bizItems 业务事项对象
     * @return 删除成功与否
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean deleteBizItems(BizItemsVO bizItems) {
        return delete(bizItems);
    }
    
    /**
     * 根据业务事项主键读取 业务事项
     * 
     * @param id 业务事项主键
     * @return 业务事项
     */
    public BizItemsVO queryBizItemsById(String id) {
        return (BizItemsVO) selectOne("com.comtop.cap.bm.biz.items.model.queryBizItemsById", id);
    }
    
    /**
     * 读取 业务事项 列表
     * 
     * @param condition 查询条件
     * @return 业务事项列表
     */
    public List<BizItemsVO> queryBizItemsList(BizItemsVO condition) {
        return queryList("com.comtop.cap.bm.biz.items.model.queryBizItemsList", condition);
    }
    
    /**
     * 读取 业务事项 数据条数
     * 
     * @param condition 查询条件
     * @return 业务事项数据条数
     */
    public int queryBizItemsCount(BizItemsVO condition) {
        return ((Integer) selectOne("com.comtop.cap.bm.biz.items.model.queryBizItemsCount", condition)).intValue();
    }
    
    /**
     * 通过业务域ID查询 数据条数
     * 
     * @param bizItems 业务事项
     * @return 业务事项数据条数
     */
    public int queryItemsCountByDomainId(BizItemsVO bizItems) {
        return ((Integer) selectOne("com.comtop.cap.bm.biz.items.model.queryItemsCountByDomainId", bizItems))
            .intValue();
    }
    
    /**
     * 通过业务域ID查询业务事项
     * 
     * @param bizItems 业务事项
     * @return 业务事项列表
     */
    public List<BizItemsVO> queryItemsListByDomainId(BizItemsVO bizItems) {
        return queryList("com.comtop.cap.bm.biz.items.model.queryItemsListByDomainId", bizItems, bizItems.getPageNo(),
            bizItems.getPageSize());
    }
    
    /**
     * 保存业务事项列表
     * 
     * @param itemList 业务事项列表
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public void saveItemList(List<BizItemsVO> itemList) {
        super.update(itemList);
    }
    
    /**
     * 通过业务域ID删除业务事项
     * 
     * @param domainId 业务域ID
     */
    public void deleteByDomainId(String domainId) {
        super.delete("com.comtop.cap.bm.biz.items.model.deleteByDomainId", domainId);
        
    }
    
    /**
     * 查询事项是否被引用
     * 
     * @param bizItems 事项
     * @return 结果
     */
    public int checkItemIsUse(BizItemsVO bizItems) {
        return ((Integer) selectOne("com.comtop.cap.bm.biz.items.model.checkItemIsUse", bizItems)).intValue();
    }
    
    /**
     * 获取事项排序号最大值
     * 
     * @param bizItems 业务事项
     * @return 结果
     */
    public int getItemMaxSort(BizItemsVO bizItems) {
        Object maxt = selectOne("com.comtop.cap.bm.biz.items.model.getItemMaxSort", bizItems);
        return maxt == null ? 0 : ((Integer) maxt).intValue();
    }
    
    /**
     * 根据查询条件查询文档list
     * 
     * @param id 对象id
     * @param properties 属性集
     *
     * @return Map<String,Object> 属性集
     */
    @Override
    public Map<String, Object> readPropertyById(final String id, List<String> properties) {
        final Map<String, Object> retMap = new HashMap<String, Object>(properties.size() + 1);
        retMap.put("id", id);
        this.execute(new PropertyReadExecutor(id, properties, BizItemsVO.class, retMap));
        return retMap;
    }
    
    /**
     * 根据查询条件查询文档list
     * 
     * @param id 对象id
     * @param properties 属性集
     */
    @Override
    public void updatePropertyById(final String id, Map<String, Object> properties) {
        this.execute(new PropertyUpdateExecutor(id, properties, BizItemsVO.class));
    }
    
    /**
     * 
     * 业务事项
     *
     * @param idList idlist
     * @return 业务事项
     */
    public List<BizItemsVO> queryItemByidlist(List<String> idList) {
        return queryList("com.comtop.cap.bm.biz.items.model.queryItemByidlist", idList);
    }
    
    /**
     * 批量修改业务事项
     * 
     * @param bizItemList 业务事项
     */
    public void updateItemList(List<BizItemsVO> bizItemList) {
        super.update(bizItemList);
    }
    
    /**
     * 业务事项名称查重
     * 
     * @param bizItems 业务事项
     * @return 结果
     */
    public boolean checkItemName(BizItemsVO bizItems) {
        int result = ((Integer) selectOne("com.comtop.cap.bm.biz.items.model.checkItemName", bizItems)).intValue();
        return result == 0 ? true : false;
    }
    
    /**
     * 删除业务域下的角色的同时删除关联的事项下的角色
     * 
     * @param roleId 角色ID
     */
    public void deleteItemRoleByRoleId(String roleId) {
        selectOne("com.comtop.cap.bm.biz.items.model.deleteItemRoleByRoleId", roleId);
    }
}
