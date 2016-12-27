/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.biz.info.facade;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.comtop.cap.bm.biz.info.appservice.BizObjDataItemAppService;
import com.comtop.cap.bm.biz.info.model.BizObjDataItemVO;
import com.comtop.cip.common.util.CAPCollectionUtils;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.base.facade.BaseFacade;

/**
 * 业务对象数据项扩展实现
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-11-10 CAP
 */
@PetiteBean
public class BizObjDataItemFacade extends BaseFacade {
    
    /** 注入AppService **/
    @PetiteInject
    protected BizObjDataItemAppService bizObjDataItemAppService;
    
    /**
     * 新增 业务对象数据项
     * 
     * @param bizObjDataItemVO 业务对象数据项对象
     * @return 业务对象数据项
     */
    public Object insertBizObjDataItem(BizObjDataItemVO bizObjDataItemVO) {
        return bizObjDataItemAppService.insertBizObjDataItem(bizObjDataItemVO);
    }
    
    /**
     * 更新 业务对象数据项
     * 
     * @param bizObjDataItemVO 业务对象数据项对象
     * @return 更新结果
     */
    public boolean updateBizObjDataItem(BizObjDataItemVO bizObjDataItemVO) {
        return bizObjDataItemAppService.updateBizObjDataItem(bizObjDataItemVO);
    }
    
    /**
     * 保存或更新业务对象数据项，根据ID是否为空
     * 
     * @param bizObjDataItemVO 业务对象数据项ID
     * @return 业务对象数据项保存后的主键ID
     */
    public String saveBizObjDataItem(BizObjDataItemVO bizObjDataItemVO) {
        if (bizObjDataItemVO.getId() == null) {
            String strId = (String) this.insertBizObjDataItem(bizObjDataItemVO);
            bizObjDataItemVO.setId(strId);
        } else {
            this.updateBizObjDataItem(bizObjDataItemVO);
        }
        return bizObjDataItemVO.getId();
    }
    
    /**
     * 读取 业务对象数据项 列表，分页查询--新版设计器使用
     * 
     * @param condition 查询条件
     * @return 业务对象数据项列表
     */
    public Map<String, Object> queryBizObjDataItemListByPage(BizObjDataItemVO condition) {
        final Map<String, Object> ret = new HashMap<String, Object>(2);
        int count = bizObjDataItemAppService.queryBizObjDataItemCount(condition);
        List<BizObjDataItemVO> bizObjDataItemVOList = null;
        if (count > 0) {
            bizObjDataItemVOList = bizObjDataItemAppService.queryBizObjDataItemList(condition);
        }
        ret.put("list", bizObjDataItemVOList);
        ret.put("count", count);
        return ret;
    }
    
    /**
     * 根据业务对象数据项的ID集合查询对应的业务对象数据项VO集合
     * 
     * @param ids 业务对象数据项的ID集合，为空是返回空集合
     * @return 符合条件的业务对象数据项VO集合
     */
    public List<BizObjDataItemVO> queryBizObjDataItemListByIds(List<String> ids) {
        if (CAPCollectionUtils.isEmpty(ids)) {
            return new ArrayList<BizObjDataItemVO>();
        }
        return bizObjDataItemAppService.queryBizObjDataItemListByIds(ids);
    }
    
    /**
     * 删除 业务对象数据项
     * 
     * @param bizObjDataItemVO 业务对象数据项对象
     * @return 删除结果
     */
    public boolean deleteBizObjDataItem(BizObjDataItemVO bizObjDataItemVO) {
        return bizObjDataItemAppService.deleteBizObjDataItem(bizObjDataItemVO);
    }
    
    // /**
    // * 删除 业务对象数据项集合
    // *
    // * @param bizObjDataItemVOList 业务对象数据项对象
    // * @return 删除结果
    // */
    // public boolean deleteBizObjDataItemList(List<BizObjDataItemVO> bizObjDataItemVOList) {
    // return bizObjDataItemAppService.deleteBizObjDataItemList(bizObjDataItemVOList);
    // }
    
    /**
     * 读取 业务对象数据项
     * 
     * @param bizObjDataItemVO 业务对象数据项对象
     * @return 业务对象数据项
     */
    public BizObjDataItemVO loadBizObjDataItem(BizObjDataItemVO bizObjDataItemVO) {
        return bizObjDataItemAppService.loadBizObjDataItem(bizObjDataItemVO);
    }
    
    /**
     * 根据业务对象数据项主键 读取 业务对象数据项
     * 
     * @param id 业务对象数据项主键
     * @return 业务对象数据项
     */
    public BizObjDataItemVO loadBizObjDataItemById(String id) {
        return bizObjDataItemAppService.loadBizObjDataItemById(id);
    }
    
    /**
     * 读取 业务对象数据项 列表
     * 
     * @param condition 查询条件
     * @return 业务对象数据项列表
     */
    public List<BizObjDataItemVO> queryBizObjDataItemList(BizObjDataItemVO condition) {
        return bizObjDataItemAppService.queryBizObjDataItemList(condition);
    }
    
    /**
     * 读取 业务对象数据项 数据条数
     * 
     * @param condition 查询条件
     * @return 业务对象数据项数据条数
     */
    public int queryBizObjDataItemCount(BizObjDataItemVO condition) {
        return bizObjDataItemAppService.queryBizObjDataItemCount(condition);
    }
}
