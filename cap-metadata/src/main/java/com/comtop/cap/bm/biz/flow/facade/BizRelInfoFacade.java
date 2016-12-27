/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.biz.flow.facade;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.comtop.cap.bm.biz.flow.appservice.BizRelInfoAppService;
import com.comtop.cap.bm.biz.flow.model.BizRelInfoVO;
import com.comtop.cap.runtime.component.facade.AutoGenNumberFacade;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.base.facade.BaseFacade;
import com.comtop.cap.runtime.core.AppBeanUtil;

/**
 * 业务关联 业务逻辑处理类 门面
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-11-25 CAP
 */
@PetiteBean
public class BizRelInfoFacade extends BaseFacade {
    
    /** 注入AppService **/
    @PetiteInject
    protected BizRelInfoAppService bizRelInfoAppService;
    
    /**
     * 新增 业务关联
     * 
     * @param bizRelInfoVO 业务关联对象
     * @return 业务关联
     */
    public Object insertBizRelInfo(BizRelInfoVO bizRelInfoVO) {
    	AutoGenNumberFacade autoGenNumberService = AppBeanUtil.getBean(AutoGenNumberFacade.class);
    	String code = autoGenNumberService.genNumber(BizRelInfoVO.getCodeExpr(), null);
    	bizRelInfoVO.setCode(code);
    	String id = (String)bizRelInfoAppService.insertBizRelInfo(bizRelInfoVO);
    	bizRelInfoAppService.updatePropertyById(id, "code", code);
    	return id;
    }
    
    /**
     * 更新 业务关联
     * 
     * @param bizRelInfoVO 业务关联对象
     * @return 更新结果
     */
    public boolean updateBizRelInfo(BizRelInfoVO bizRelInfoVO) {
        return bizRelInfoAppService.updateBizRelInfo(bizRelInfoVO);
    }
    
    /**
     * 保存或更新业务关联，根据ID是否为空
     * 
     * @param bizRelInfoVO 业务关联ID
     * @return 业务关联保存后的主键ID
     */
    public String saveBizRelInfo(BizRelInfoVO bizRelInfoVO) {
        if (bizRelInfoVO.getId() == null) {
            String strId = (String) this.insertBizRelInfo(bizRelInfoVO);
            bizRelInfoVO.setId(strId);
        } else {
            this.updateBizRelInfo(bizRelInfoVO);
        }
        return bizRelInfoVO.getId();
    }
    
    /**
     * 读取 业务关联 列表，分页查询--新版设计器使用
     * 
     * @param condition 查询条件
     * @return 业务关联列表
     */
    public Map<String, Object> queryBizRelInfoListByPage(BizRelInfoVO condition) {
        final Map<String, Object> ret = new HashMap<String, Object>(2);
        int count = bizRelInfoAppService.queryBizRelInfoCount(condition);
        List<BizRelInfoVO> bizRelInfoVOList = null;
        if (count > 0) {
            bizRelInfoVOList = bizRelInfoAppService.queryBizRelInfoList(condition);
        }
        ret.put("list", bizRelInfoVOList);
        ret.put("count", count);
        return ret;
    }
    
    /**
     * 删除 业务关联
     * 
     * @param bizRelInfoVO 业务关联对象
     * @return 删除结果
     */
    public boolean deleteBizRelInfo(BizRelInfoVO bizRelInfoVO) {
        return bizRelInfoAppService.deleteBizRelInfo(bizRelInfoVO);
    }
    
    /**
     * 删除 业务关联集合
     * 
     * @param bizRelInfoVOList 业务关联对象
     * @return 删除结果
     */
    public boolean deleteBizRelInfoList(List<BizRelInfoVO> bizRelInfoVOList) {
        return bizRelInfoAppService.deleteBizRelInfoList(bizRelInfoVOList);
    }
    
    /**
     * 读取 业务关联
     * 
     * @param bizRelInfoVO 业务关联对象
     * @return 业务关联
     */
    public BizRelInfoVO loadBizRelInfo(BizRelInfoVO bizRelInfoVO) {
        return bizRelInfoAppService.loadBizRelInfo(bizRelInfoVO);
    }
    
    /**
     * 根据业务关联主键 读取 业务关联
     * 
     * @param id 业务关联主键
     * @return 业务关联
     */
    public BizRelInfoVO loadBizRelInfoById(String id) {
        return bizRelInfoAppService.loadBizRelInfoById(id);
    }
    
    /**
     * 读取 业务关联 列表
     * 
     * @param condition 查询条件
     * @return 业务关联列表
     */
    public List<BizRelInfoVO> queryBizRelInfoList(BizRelInfoVO condition) {
        return bizRelInfoAppService.queryBizRelInfoList(condition);
    }
    
    /**
     * 读取 业务关联 数据条数
     * 
     * @param condition 查询条件
     * @return 业务关联数据条数
     */
    public int queryBizRelInfoCount(BizRelInfoVO condition) {
        return bizRelInfoAppService.queryBizRelInfoCount(condition);
    }
}
