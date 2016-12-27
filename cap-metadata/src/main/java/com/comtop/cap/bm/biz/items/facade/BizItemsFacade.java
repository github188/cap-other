/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.biz.items.facade;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.comtop.cap.bm.biz.flow.facade.BizProcessInfoFacade;
import com.comtop.cap.bm.biz.items.appservice.BizItemsAppService;
import com.comtop.cap.bm.biz.items.appservice.BizItemsRoleAppService;
import com.comtop.cap.bm.biz.items.model.BizItemsVO;
import com.comtop.cap.bm.biz.role.facade.BizRoleFacade;
import com.comtop.cap.runtime.component.facade.AutoGenNumberFacade;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.base.facade.BaseFacade;
import com.comtop.cap.runtime.core.AppBeanUtil;

/**
 * 业务事项 业务逻辑处理类 门面
 * 
 * @author 姜子豪
 * @since 1.0
 * @version 2015-11-11 姜子豪
 */
@PetiteBean
public class BizItemsFacade extends BaseFacade {
    
    /** 注入AppService **/
    @PetiteInject
    protected BizItemsAppService bizItemsAppService;
    
    /** 注入AppService **/
    @PetiteInject
    protected BizProcessInfoFacade bizProcessInfoFacade;
    
    /** 注入AppService **/
    @PetiteInject
    protected BizRoleFacade bizRoleFacade;
    
    /** 注入AppService **/
    @PetiteInject
    protected BizItemsRoleAppService bizItemsRoleAppService;
    
    /**
     * 新增 业务事项
     * 
     * @param bizItemsVO 业务事项对象
     * @return 业务事项
     */
    public String insertBizItems(BizItemsVO bizItemsVO) {
    	AutoGenNumberFacade autoGenNumberService = AppBeanUtil.getBean(AutoGenNumberFacade.class);
        String code = autoGenNumberService.genNumber(BizItemsVO.getCodeExpr(), null);
        bizItemsVO.setCode(code);
        return bizItemsAppService.insertBizItems(bizItemsVO);
    }
    
    /**
     * 更新 业务事项
     * 
     * @param bizItemsVO 业务事项对象
     * @return 更新结果
     */
    public boolean updateBizItems(BizItemsVO bizItemsVO) {
        return bizItemsAppService.updateBizItems(bizItemsVO);
    }
    
    /**
     * 保存或更新业务事项，根据ID是否为空
     * 
     * @param bizItemsVO 业务事项ID
     * @return 业务事项保存后的主键ID
     */
    public String saveBizItems(BizItemsVO bizItemsVO) {
        if (bizItemsVO.getId() == null) {
            String strId = this.insertBizItems(bizItemsVO);
            bizItemsVO.setId(strId);
        } else {
            this.updateBizItems(bizItemsVO);
        }
        return bizItemsVO.getId();
    }
    
    /**
     * 读取 业务事项 列表，分页查询--新版设计器使用
     * 
     * @param condition 查询条件
     * @return 业务事项列表
     */
    public Map<String, Object> queryBizItemsListByPage(BizItemsVO condition) {
        final Map<String, Object> ret = new HashMap<String, Object>(2);
        int count = bizItemsAppService.queryBizItemsCount(condition);
        List<BizItemsVO> bizItemsVOList = null;
        if (count > 0) {
            bizItemsVOList = bizItemsAppService.queryBizItemsList(condition);
        }
        ret.put("list", bizItemsVOList);
        ret.put("count", count);
        return ret;
    }
    
    /**
     * 删除 业务事项
     * 
     * @param bizItemsVO 业务事项对象
     * @return 删除结果
     */
    public boolean deleteBizItems(BizItemsVO bizItemsVO) {
        return bizItemsAppService.deleteBizItems(bizItemsVO);
    }
    
    /**
     * 删除 业务事项集合
     * 
     * @param bizItemsVOList 业务事项对象
     * @return 删除结果
     */
    public boolean deleteBizItemsList(List<BizItemsVO> bizItemsVOList) {
        return bizItemsAppService.deleteBizItemsList(bizItemsVOList);
    }
    
    /**
     * 根据业务事项主键 读取 业务事项
     * 
     * @param id 业务事项主键
     * @return 业务事项
     */
    public BizItemsVO queryBizItemsById(String id) {
        return bizItemsAppService.queryBizItemsById(id);
    }
    
    /**
     * 读取 业务事项 列表
     * 
     * @param condition 查询条件
     * @return 业务事项列表
     */
    public List<BizItemsVO> queryBizItemsList(BizItemsVO condition) {
        return bizItemsAppService.queryBizItemsList(condition);
    }
    
    /**
     * 读取 业务事项 数据条数
     * 
     * @param condition 查询条件
     * @return 业务事项数据条数
     */
    public int queryBizItemsCount(BizItemsVO condition) {
        return bizItemsAppService.queryBizItemsCount(condition);
    }
    
    /**
     * 通过业务域ID查询 数据条数
     * 
     * @param bizItems 业务事项
     * @return 业务事项数据条数
     */
    public int queryItemsCountByDomainId(BizItemsVO bizItems) {
        return bizItemsAppService.queryItemsCountByDomainId(bizItems);
    }
    
    /**
     * 通过业务域ID查询业务事项
     * 
     * @param bizItems 业务事项
     * @return 业务事项列表
     */
    public List<BizItemsVO> queryItemsListByDomainId(BizItemsVO bizItems) {
        return bizItemsAppService.queryItemsListByDomainId(bizItems);
    }
    
    /**
     * 保存业务事项列表
     * 
     * @param itemList 业务事项列表
     */
    public void saveItemList(List<BizItemsVO> itemList) {
        bizItemsAppService.saveItemList(itemList);
    }
    
    /**
     * 查询事项是否被引用
     * 
     * @param bizItems 事项
     * @return 结果
     */
    public int checkItemIsUse(BizItemsVO bizItems) {
        return bizItemsAppService.checkItemIsUse(bizItems);
    }
    
    /**
     * 查询业务事项
     * 
     * @param bizItems 业务事项
     * @return 业务事项
     */
    public List<BizItemsVO> queryItemsList(BizItemsVO bizItems) {
        return bizItemsAppService.queryItemsList(bizItems);
    }
    
    /**
     * 批量修改业务事项
     * 
     * @param bizItemList 业务事项
     */
    public void updateItemList(List<BizItemsVO> bizItemList) {
        bizItemsAppService.updateItemList(bizItemList);
    }
    
    /**
     * 更新编码和序号
     *
     */
    // public void updateCodeAndSortNo() {
    // List<BizItemsVO> alData = bizItemsAppService.loadBizItemsNotExistCodeOrSortNo();
    // AutoGenNumberService autoGenNumberService = new AutoGenNumberService();
    // for (BizItemsVO data : alData) {
    // if (StringUtils.isBlank(data.getCode())) {
    // String code = autoGenNumberService.genNumber(BizItemsVO.getCodeExpr(), null);
    // bizItemsAppService.updatePropertyById(data.getId(), "code", code);
    // }
    //
    // if (data.getSortNo() == null) {
    // String sortNoExpr = DocDataUtil.getSortNoExpr("BizItems-SortNo", data.getDomainId());
    // String code = autoGenNumberService.genNumber(sortNoExpr, null);
    // bizItemsAppService.updatePropertyById(data.getId(), "sortNo", code);
    // }
    // }
    // }
    
    /**
     * 业务事项名称查重
     * 
     * @param bizItems 业务事项
     * @return 结果
     */
    public boolean checkItemName(BizItemsVO bizItems) {
        return bizItemsAppService.checkItemName(bizItems);
    }
}
