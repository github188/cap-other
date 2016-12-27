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

import com.comtop.cap.bm.biz.flow.appservice.BizRelDataAppService;
import com.comtop.cap.bm.biz.flow.model.BizRelDataVO;
import com.comtop.cap.bm.biz.info.appservice.BizObjInfoAppService;
import com.comtop.cap.bm.util.CapBmHelper;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.base.facade.BaseFacade;

/**
 * 业务关联数据项 业务逻辑处理类 门面
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-11-26 CAP
 */
@PetiteBean
public class BizRelDataFacade extends BaseFacade {
    
    /** 注入AppService **/
    @PetiteInject
    protected BizRelDataAppService bizRelDataAppService;
    
    /** 节点服务 */
    @PetiteInject
    protected BizObjInfoAppService bizObjInfoAppService;
    
    /**
     * 新增 业务关联数据项
     * 
     * @param bizRelDataVO 业务关联数据项对象
     * @return 业务关联数据项
     */
    public Object insertBizRelData(BizRelDataVO bizRelDataVO) {
        bizRelDataVO.setSortNo(CapBmHelper.generateSortNo("BizRelDataVO-SortNo"));
        return bizRelDataAppService.insertBizRelData(bizRelDataVO);
    }
    
    /**
     * 更新 业务关联数据项
     * 
     * @param bizRelDataVO 业务关联数据项对象
     * @return 更新结果
     */
    public boolean updateBizRelData(BizRelDataVO bizRelDataVO) {
        return bizRelDataAppService.updateBizRelData(bizRelDataVO);
    }
    
    /**
     * 保存或更新业务关联数据项，根据ID是否为空
     * 
     * @param bizRelDataVO 业务关联数据项ID
     * @return 业务关联数据项保存后的主键ID
     */
    public String saveBizRelData(BizRelDataVO bizRelDataVO) {
        if (bizRelDataVO.getId() == null) {
            String strId = (String) this.insertBizRelData(bizRelDataVO);
            bizRelDataVO.setId(strId);
        } else {
            this.updateBizRelData(bizRelDataVO);
        }
        return bizRelDataVO.getId();
    }
    
    /**
     * 读取 业务关联数据项 列表，分页查询--新版设计器使用
     * 
     * @param condition 查询条件
     * @return 业务关联数据项列表
     */
    public Map<String, Object> queryBizRelDataListByPage(BizRelDataVO condition) {
        final Map<String, Object> ret = new HashMap<String, Object>(2);
        int count = bizRelDataAppService.queryBizRelDataCount(condition);
        List<BizRelDataVO> bizRelDataVOList = null;
        if (count > 0) {
            bizRelDataVOList = bizRelDataAppService.queryBizRelDataList(condition);
        }
        ret.put("list", bizRelDataVOList);
        ret.put("count", count);
        return ret;
    }
    
    /**
     * 删除 业务关联数据项
     * 
     * @param bizRelDataVO 业务关联数据项对象
     * @return 删除结果
     */
    public boolean deleteBizRelData(BizRelDataVO bizRelDataVO) {
        return bizRelDataAppService.deleteBizRelData(bizRelDataVO);
    }
    
    /**
     * 删除 业务关联数据项集合
     * 
     * @param bizRelDataVOList 业务关联数据项对象
     * @return 删除结果
     */
    public boolean deleteBizRelDataList(List<BizRelDataVO> bizRelDataVOList) {
        return bizRelDataAppService.deleteBizRelDataList(bizRelDataVOList);
    }
    
    /**
     * 读取 业务关联数据项
     * 
     * @param bizRelDataVO 业务关联数据项对象
     * @return 业务关联数据项
     */
    public BizRelDataVO loadBizRelData(BizRelDataVO bizRelDataVO) {
        return bizRelDataAppService.loadBizRelData(bizRelDataVO);
    }
    
    /**
     * 根据业务关联数据项主键 读取 业务关联数据项
     * 
     * @param id 业务关联数据项主键
     * @return 业务关联数据项
     */
    public BizRelDataVO loadBizRelDataById(String id) {
        return bizRelDataAppService.loadBizRelDataById(id);
    }
    
    /**
     * 读取 业务关联数据项 列表
     * 
     * @param condition 查询条件
     * @return 业务关联数据项列表
     */
    public List<BizRelDataVO> queryBizRelDataList(BizRelDataVO condition) {
        return bizRelDataAppService.queryBizRelDataList(condition);
    }
    
    /**
     * 读取 业务关联数据项 数据条数
     * 
     * @param condition 查询条件
     * @return 业务关联数据项数据条数
     */
    public int queryBizRelDataCount(BizRelDataVO condition) {
        return bizRelDataAppService.queryBizRelDataCount(condition);
    }
}
