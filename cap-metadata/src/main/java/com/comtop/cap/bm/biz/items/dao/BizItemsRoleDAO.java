/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.biz.items.dao;

import java.util.List;

import com.comtop.cap.base.MDBaseDAO;
import com.comtop.cap.bm.biz.items.model.BizItemsRoleVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;

/**
 * 业务事项DAO
 * 
 * @author 李志勇
 * @since 1.0
 * @version 2015-11-11 李志勇
 */
@PetiteBean
public class BizItemsRoleDAO extends MDBaseDAO<BizItemsRoleVO> {
    
    /**
     * 根据业务事项主键读取 业务事项
     * 
     * @param itemsId 业务事项主键
     * @return 业务事项
     */
    public List<BizItemsRoleVO> queryBizItemsRolesByItemsId(String itemsId) {
        return queryList("com.comtop.cap.bm.biz.items.model.queryBizItemsRolesByItemsId", itemsId);
    }
    
    /**
     * 保存业务事项列表
     * 
     * @param bizItemsRoleList 业务事项列表
     */
    public void insertBizItemsRoleList(List<BizItemsRoleVO> bizItemsRoleList) {
        insert(bizItemsRoleList);
    }
    
    /**
     * 通过业务域ID删除业务事项
     * 
     * @param itemsId 业务域ID
     */
    public void deleteByItemsId(String itemsId) {
        delete("com.comtop.cap.bm.biz.items.model.deleteByItemsId", itemsId);
    }
    
    /**
     * 根据业务事项主键读取 角色关联
     * 
     * @param itemsId 业务事项主键
     * @return 业务事项角色关联
     */
    public List<BizItemsRoleVO> getRoleListByItemId(String itemsId) {
        return queryList("com.comtop.cap.bm.biz.items.model.getRoleListByItemId", itemsId);
    }
}
