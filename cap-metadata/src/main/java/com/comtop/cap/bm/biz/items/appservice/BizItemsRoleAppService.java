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
import com.comtop.cap.bm.biz.items.dao.BizItemsRoleDAO;
import com.comtop.cap.bm.biz.items.model.BizItemsRoleVO;
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
public class BizItemsRoleAppService extends MDBaseAppservice<BizItemsRoleVO> {
    
    /** 注入DAO **/
    @PetiteInject
    protected BizItemsRoleDAO bizItemsRoleDAO;
    
    /**
     * 新增角色关联
     * 
     * @param bizItemsRoleList 业务事项
     */
    public void insertBizItemsRoleList(List<BizItemsRoleVO> bizItemsRoleList) {
        bizItemsRoleDAO.insertBizItemsRoleList(bizItemsRoleList);
    }
    
    /**
     * 保存业务事项角色关联
     * 
     * @param bizItems 业务事项
     * @param itemsId 业务事项id
     */
    public void updateBizItemsRoleList(List<BizItemsRoleVO> bizItems, String itemsId) {
        bizItemsRoleDAO.deleteByItemsId(itemsId);
        bizItemsRoleDAO.insertBizItemsRoleList(bizItems);
    }
    
    /**
     * 根据业务事项主键读取 角色关联
     * 
     * @param id 业务事项主键
     * @return 业务事项角色关联
     */
    public List<BizItemsRoleVO> queryBizItemsRolesById(String id) {
        return bizItemsRoleDAO.queryBizItemsRolesByItemsId(id);
    }
    
    /**
     * 根据业务事项主键读取 角色关联
     * 
     * @param id 业务事项主键
     * @return 业务事项角色关联
     */
    public List<BizItemsRoleVO> getRoleListByItemId(String id) {
        return bizItemsRoleDAO.getRoleListByItemId(id);
    }
    
    /**
     * 通过业务事项ID删除角色关联
     * 
     * @param itemsId 业务域ID
     */
    public void deleteByItemsId(String itemsId) {
        bizItemsRoleDAO.deleteByItemsId(itemsId);
    }
    
    @Override
    protected MDBaseDAO<BizItemsRoleVO> getDAO() {
        return bizItemsRoleDAO;
    }
}
