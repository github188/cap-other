/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.biz.items.appservice;

import java.util.List;

import com.comtop.cap.base.MDBaseAppservice;
import com.comtop.cap.base.MDBaseDAO;
import com.comtop.cap.bm.biz.items.dao.BizItemsDAO;
import com.comtop.cap.bm.biz.items.model.BizItemsRoleVO;
import com.comtop.cap.bm.biz.items.model.BizItemsVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 业务事项 业务逻辑处理类
 * 
 * @author 姜子豪
 * @since 1.0
 * @version 2015-11-11 姜子豪
 */
@PetiteBean
public class BizItemsAppService extends MDBaseAppservice<BizItemsVO> {
    
    /** 注入DAO **/
    @PetiteInject
    protected BizItemsDAO bizItemsDAO;
    
    /** 角色关联AppService **/
    @PetiteInject
    protected BizItemsRoleAppService bizItemsRoleAppService;
    
    /**
     * 新增 业务事项
     * 
     * @param bizItems 业务事项对象
     * @return 业务事项Id
     */
    public String insertBizItems(BizItemsVO bizItems) {
        String ItemId = (String) bizItemsDAO.insertBizItems(bizItems);
        if (!bizItems.getBizItemsRoleList().isEmpty()) {
            List<BizItemsRoleVO> RoleList = bizItems.getBizItemsRoleList();
            for (int i = 0; i < RoleList.size(); i++) {
                RoleList.get(i).setItemsId(ItemId);
            }
            bizItemsRoleAppService.insertBizItemsRoleList(RoleList);
        }
        return ItemId;
    }
    
    /**
     * 更新 业务事项
     * 
     * @param bizItems 业务事项对象
     * @return 更新成功与否
     */
    public boolean updateBizItems(BizItemsVO bizItems) {
        bizItemsRoleAppService.deleteByItemsId(bizItems.getId());
        if (bizItems.getBizItemsRoleList() != null) {
            List<BizItemsRoleVO> RoleList = bizItems.getBizItemsRoleList();
            for (int i = 0; i < RoleList.size(); i++) {
                RoleList.get(i).setItemsId(bizItems.getId());
            }
            bizItemsRoleAppService.insertBizItemsRoleList(RoleList);
        }
        return bizItemsDAO.updateBizItems(bizItems);
    }
    
    /**
     * 删除 业务事项
     * 
     * @param bizItems 业务事项对象
     * @return 删除成功与否
     */
    public boolean deleteBizItems(BizItemsVO bizItems) {
        return bizItemsDAO.deleteBizItems(bizItems);
    }
    
    /**
     * 删除 业务事项集合
     * 
     * @param bizItemsList 业务事项对象
     * @return 删除成功与否
     */
    public boolean deleteBizItemsList(List<BizItemsVO> bizItemsList) {
        if (bizItemsList == null) {
            return true;
        }
        for (BizItemsVO bizItems : bizItemsList) {
            this.deleteBizItems(bizItems);
        }
        return true;
    }
    
    /**
     * 根据业务事项主键读取 业务事项
     * 
     * @param id 业务事项主键
     * @return 业务事项
     */
    public BizItemsVO queryBizItemsById(String id) {
        BizItemsVO bizItem = bizItemsDAO.queryBizItemsById(id);
        List<BizItemsRoleVO> bizItemsRoleList = bizItemsRoleAppService.getRoleListByItemId(id);
        if (!bizItemsRoleList.isEmpty()) {
            String roleNames = "";
            for (BizItemsRoleVO roleVO : bizItemsRoleList) {
                roleNames += roleVO.getRoleName() + ";";
            }
            bizItem.setRoleNames(roleNames);
            bizItem.setBizItemsRoleList(bizItemsRoleList);
        }
        return bizItem;
    }
    
    /**
     * 读取 业务事项 列表
     * 
     * @param condition 查询条件
     * @return 业务事项列表
     */
    public List<BizItemsVO> queryBizItemsList(BizItemsVO condition) {
        return bizItemsDAO.queryBizItemsList(condition);
    }
    
    /**
     * 读取 业务事项 数据条数
     * 
     * @param condition 查询条件
     * @return 业务事项数据条数
     */
    public int queryBizItemsCount(BizItemsVO condition) {
        return bizItemsDAO.queryBizItemsCount(condition);
    }
    
    /**
     * 通过业务域ID查询 数据条数
     * 
     * @param bizItems 业务事项数
     * @return 业务事项数据条数
     */
    public int queryItemsCountByDomainId(BizItemsVO bizItems) {
        return bizItemsDAO.queryItemsCountByDomainId(bizItems);
    }
    
    /**
     * 通过业务域ID查询业务事项
     * 
     * @param bizItems 业务事项数
     * @return 业务事项列表
     */
    public List<BizItemsVO> queryItemsListByDomainId(BizItemsVO bizItems) {
        return bizItemsDAO.queryItemsListByDomainId(bizItems);
    }
    
    /**
     * 保存业务事项列表
     * 
     * @param itemList 业务事项列表
     */
    public void saveItemList(List<BizItemsVO> itemList) {
        bizItemsDAO.saveItemList(itemList);
    }
    
    /**
     * 查询事项是否被引用
     * 
     * @param bizItems 事项
     * @return 结果
     */
    public int checkItemIsUse(BizItemsVO bizItems) {
        return bizItemsDAO.checkItemIsUse(bizItems);
    }
    
    @Override
    protected MDBaseDAO<BizItemsVO> getDAO() {
        return bizItemsDAO;
    }
    
    /**
     * 加载不存在编码或排序号的数据
     *
     * @return 数据集
     */
    public List<BizItemsVO> loadBizItemsNotExistCodeOrSortNo() {
        return bizItemsDAO.queryList("com.comtop.cap.bm.biz.items.model.loadBizItemsNotExistCodeOrSortNo", null);
    }
    
    /**
     * 查询业务事项
     * 
     * @param bizItems 业务事项
     * @return 业务事项
     */
    public List<BizItemsVO> queryItemsList(BizItemsVO bizItems) {
        return bizItemsDAO.queryBizItemsList(bizItems);
    }
    
    /**
     * 批量修改业务事项
     * 
     * @param bizItemList 业务事项
     */
    public void updateItemList(List<BizItemsVO> bizItemList) {
        bizItemsDAO.updateItemList(bizItemList);
    }
    
    /**
     * 业务事项名称查重
     * 
     * @param bizItems 业务事项
     * @return 结果
     */
    public boolean checkItemName(BizItemsVO bizItems) {
        return bizItemsDAO.checkItemName(bizItems);
    }
    
    /**
     * 删除业务域下的角色的同时删除关联的事项下的角色
     * 
     * @param roleId 角色ID
     */
    public void deleteItemRoleByRoleId(String roleId) {
        bizItemsDAO.deleteItemRoleByRoleId(roleId);
    }
}
