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

import com.comtop.cap.bm.biz.info.appservice.BizObjInfoAppService;
import com.comtop.cap.bm.biz.info.model.BizObjInfoVO;
import com.comtop.cap.runtime.component.facade.AutoGenNumberFacade;
import com.comtop.cip.common.util.CAPCollectionUtils;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.base.facade.BaseFacade;
import com.comtop.cap.runtime.core.AppBeanUtil;

/**
 * 业务对象基本信息扩展实现
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-11-10 CAP
 */
@PetiteBean
public class BizObjInfoFacade extends BaseFacade {
    
    /** 注入AppService **/
    @PetiteInject
    protected BizObjInfoAppService bizObjInfoAppService;
    
    /** 注入AppService **/
    @PetiteInject
    protected BizObjDataItemFacade bizObjDataItemFacade;
    
    /**
     * 新增 业务对象基本信息
     * 
     * @param bizObjInfoVO 业务对象基本信息对象
     * @return 业务对象基本信息
     */
    public Object insertBizObjInfo(BizObjInfoVO bizObjInfoVO) {
        AutoGenNumberFacade autoGenNumberService = AppBeanUtil.getBean(AutoGenNumberFacade.class);
        String code = autoGenNumberService.genNumber(BizObjInfoVO.getCodeExpr(), null);
        bizObjInfoVO.setCode(code);
        return bizObjInfoAppService.insertBizObjInfo(bizObjInfoVO);
    }
    
    /**
     * 更新 业务对象基本信息
     * 
     * @param bizObjInfoVO 业务对象基本信息对象
     * @return 更新结果
     */
    public boolean updateBizObjInfo(BizObjInfoVO bizObjInfoVO) {
        return bizObjInfoAppService.updateBizObjInfo(bizObjInfoVO);
    }
    
    /**
     * 根据业务对象ID集合查询对应的业务对象VO集合
     * 
     * @param bizInfoIds 业务对象的ID集合，为空是返回空集合
     * @return 符合条件的业务对象VO集合
     */
    public List<BizObjInfoVO> queryBizInfoListByIds(List<String> bizInfoIds) {
        if (CAPCollectionUtils.isEmpty(bizInfoIds)) {
            return new ArrayList<BizObjInfoVO>(0);
        }
        return bizObjInfoAppService.queryBizInfoListByIds(bizInfoIds);
    }
    
    /**
     * 保存或更新业务对象基本信息，根据ID是否为空
     * 
     * @param bizObjInfoVO 业务对象基本信息ID
     * @return 业务对象基本信息保存后的主键ID
     */
    public String saveBizObjInfo(BizObjInfoVO bizObjInfoVO) {
        if (bizObjInfoVO.getId() == null) {
            String strId = (String) this.insertBizObjInfo(bizObjInfoVO);
            bizObjInfoVO.setId(strId);
        } else {
            this.updateBizObjInfo(bizObjInfoVO);
        }
        return bizObjInfoVO.getId();
    }
    
    /**
     * 读取 业务对象基本信息 列表，分页查询--新版设计器使用
     * 
     * @param condition 查询条件
     * @return 业务对象基本信息列表
     */
    public Map<String, Object> queryBizObjInfoListByPage(BizObjInfoVO condition) {
        final Map<String, Object> ret = new HashMap<String, Object>(2);
        int count = bizObjInfoAppService.queryBizObjInfoCount(condition);
        List<BizObjInfoVO> bizObjInfoVOList = null;
        if (count > 0) {
            bizObjInfoVOList = bizObjInfoAppService.queryBizObjInfoList(condition);
        }
        ret.put("list", bizObjInfoVOList);
        ret.put("count", count);
        return ret;
    }
    
    /**
     * 删除 业务对象基本信息
     * 
     * @param bizObjInfoVO 业务对象基本信息对象
     * @return 删除结果
     */
    public boolean deleteBizObjInfo(BizObjInfoVO bizObjInfoVO) {
        return bizObjInfoAppService.deleteBizObjInfo(bizObjInfoVO);
    }
    
    /**
     * 删除 业务对象基本信息集合
     * 
     * @param bizObjInfoVOList 业务对象基本信息对象
     * @return 删除结果
     */
    public boolean deleteBizObjInfoList(List<BizObjInfoVO> bizObjInfoVOList) {
        return bizObjInfoAppService.deleteBizObjInfoList(bizObjInfoVOList);
    }
    
    /**
     * 读取 业务对象基本信息
     * 
     * @param bizObjInfoVO 业务对象基本信息对象
     * @return 业务对象基本信息
     */
    public BizObjInfoVO loadBizObjInfo(BizObjInfoVO bizObjInfoVO) {
        return bizObjInfoAppService.loadBizObjInfo(bizObjInfoVO);
    }
    
    /**
     * 根据业务对象基本信息主键 读取 业务对象基本信息
     * 
     * @param id 业务对象基本信息主键
     * @return 业务对象基本信息
     */
    public BizObjInfoVO loadBizObjInfoById(String id) {
        return bizObjInfoAppService.loadBizObjInfoById(id);
    }
    
    /**
     * 读取 业务对象基本信息 列表
     * 
     * @param condition 查询条件
     * @return 业务对象基本信息列表
     */
    public List<BizObjInfoVO> queryBizObjInfoList(BizObjInfoVO condition) {
        return bizObjInfoAppService.queryBizObjInfoList(condition);
    }
    
    /**
     * 读取 业务对象基本信息 列表
     * 
     * @param condition 查询条件
     * @return 业务对象基本信息列表
     */
    public List<BizObjInfoVO> queryBizObjInfoListByDomainIdList(BizObjInfoVO condition) {
        return bizObjInfoAppService.queryBizObjInfoListByDomainIdList(condition);
    }
    
    /****
     * 判断指定的业务域下是否已存在同名业务对象
     * 
     * @param bizObjInfo 业务对象, 业务域ID、业务名称必须(如果是修改还需要传ID)
     * @return 如果存在则返回true;否则返回false
     */
    public boolean isExistSameNameBizInfo(final BizObjInfoVO bizObjInfo) {
        return bizObjInfoAppService.isExistSameNameBizInfo(bizObjInfo);
    }
    
    /****
     * 判断指定的业务域下是否已存在相同编号的业务对象
     * 
     * @param bizObjInfo 业务对象, 业务域ID、业务编号必须(如果是修改还需要传ID)
     * @return 如果存在则返回true;否则返回false
     */
    public boolean isExistSameCodeBizInfo(final BizObjInfoVO bizObjInfo) {
        return bizObjInfoAppService.isExistSameCodeBizInfo(bizObjInfo);
    }
    
    /***
     * 修改业务对象排序
     * 
     * @param bizObjInfo
     *            业务对象,ID必须
     * @param type
     *            1:升级、-1：降级
     * @return 操作结果 正常返回true,否则返回false
     */
    public boolean updateSortNo(final BizObjInfoVO bizObjInfo, int type) {
        return bizObjInfoAppService.updateSortNo(bizObjInfo, type);
    }
    
    /**
     * 读取 业务对象基本信息 数据条数
     * 
     * @param condition 查询条件
     * @return 业务对象基本信息数据条数
     */
    public int queryBizObjInfoCount(BizObjInfoVO condition) {
        return bizObjInfoAppService.queryBizObjInfoCount(condition);
    }
    
    /**
     * 读取 业务对象基本信息 数据条数
     * 
     * @param condition 查询条件
     * @return 业务对象基本信息数据条数
     */
    public int queryBizObjInfoCountByDomainIdList(BizObjInfoVO condition) {
        return bizObjInfoAppService.queryBizObjInfoCountByDomainIdList(condition);
    }
    
    /**
     * 查询业务对象是否被引用
     * 
     * @param bizObjInfo 业务对象基本信息
     * @return 操作结果
     */
    public int checkObjInfoIsUse(BizObjInfoVO bizObjInfo) {
        return bizObjInfoAppService.checkObjInfoIsUse(bizObjInfo);
    }
    
    /**
     * 修改业务对象排序
     * 
     * @param bizObjInfo 业务对象基本信息
     */
    public void updateSortNo(BizObjInfoVO bizObjInfo) {
        bizObjInfoAppService.updateSortNo(bizObjInfo);
    }
}
