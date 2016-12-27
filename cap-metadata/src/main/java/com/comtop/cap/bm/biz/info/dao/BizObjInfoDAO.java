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
import com.comtop.cap.bm.biz.info.model.BizObjInfoVO;
import com.comtop.cip.common.constant.CapNumberConstant;
import com.comtop.cip.jodd.jtx.JtxPropagationBehavior;
import com.comtop.cip.jodd.jtx.meta.Transaction;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 业务对象基本信息扩展DAO
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-11-10 CAP
 */
@PetiteBean
public class BizObjInfoDAO extends MDBaseDAO<BizObjInfoVO> {
    
    /** 注入BizObjDataItemDAO **/
    @PetiteInject
    protected BizObjDataItemDAO bizObjDataItemDAO;
    
    /**
     * 新增 业务对象基本信息
     * 
     * @param bizObjInfo
     *            业务对象基本信息对象
     * @return 业务对象基本信息Id
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public Object insertBizObjInfo(BizObjInfoVO bizObjInfo) {
        bizObjInfo.setSortNo(queryBizObjNextSortNoByDomainId(bizObjInfo.getDomainId()));
        Object result = insert(bizObjInfo);
        saveOrUpdateBizObjDataItems(result.toString(), bizObjInfo.getDataItems());
        return result;
    }
    
    /**
     * 更新 业务对象基本信息
     * 
     * @param bizObjInfo
     *            业务对象基本信息对象
     * @return 更新成功与否
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean updateBizObjInfo(BizObjInfoVO bizObjInfo) {
        deleteBizObjDataItemListByBizObjInfoId(bizObjInfo.getId());
        saveOrUpdateBizObjDataItems(bizObjInfo.getId(), bizObjInfo.getDataItems());
        return update(bizObjInfo);
    }
    
    /***
     * 获取指定业务域之下的下一条业务对象数据序号
     * 
     * @param domainId
     *            业务域ID
     * @return 下一个业务对象序号，
     */
    public int queryBizObjNextSortNoByDomainId(String domainId) {
        return ((Integer) selectOne("com.comtop.cap.bm.biz.info.model.queryBizObjNextSortNoByDomainId", domainId)).intValue();
    }
    
    /***
     * 新增或更新业务对象明细
     * 
     * @param bizObjId
     *            业务对象
     * @param bizObjDataItemByReldatas
     *            业务对象数据项
     */
    private void saveOrUpdateBizObjDataItems(String bizObjId, List<BizObjDataItemVO> bizObjDataItemByReldatas) {
        if (bizObjDataItemByReldatas != null) {
            for (int i = 0; i < bizObjDataItemByReldatas.size(); i++) {
                BizObjDataItemVO bizObjDataItem = bizObjDataItemByReldatas.get(i);
                bizObjDataItem.setSortNo(Integer.valueOf(i + 1));
                bizObjDataItem.setBizObjId(bizObjId);
                bizObjDataItemDAO.insertBizObjDataItem(bizObjDataItem);
            }
        }
    }
    
    /**
     * 删除 业务对象基本信息
     * 
     * @param bizObjInfo
     *            业务对象基本信息对象
     * @return 删除成功与否
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean deleteBizObjInfo(BizObjInfoVO bizObjInfo) {
        deleteBizObjDataItemListByBizObjInfoId(bizObjInfo.getId());
        
        return delete(bizObjInfo);
    }
    
    /**
     * 读取 业务对象基本信息
     * 
     * @param bizObjInfo
     *            业务对象基本信息对象
     * @return 业务对象基本信息
     */
    public BizObjInfoVO loadBizObjInfo(BizObjInfoVO bizObjInfo) {
        BizObjInfoVO objBizObjInfo = load(bizObjInfo);
        return objBizObjInfo;
    }
    
    /**
     * 根据业务对象基本信息主键读取 业务对象基本信息
     * 
     * @param id
     *            业务对象基本信息主键
     * @return 业务对象基本信息
     */
    public BizObjInfoVO loadBizObjInfoById(String id) {
        BizObjInfoVO objBizObjInfo = new BizObjInfoVO();
        objBizObjInfo.setId(id);
        return loadBizObjInfo(objBizObjInfo);
    }
    
    /**
     * 根据业务对象ID集合查询对应的业务对象VO集合
     * 
     * @param bizInfoIds 业务对象的ID集合，为空是返回空集合
     * @return 符合条件的业务对象VO集合
     */
    public List<BizObjInfoVO> queryBizInfoListByIds(List<String> bizInfoIds) {
        return queryList("com.comtop.cap.bm.biz.info.model.queryBizObjInListByIds", bizInfoIds);
    }
    
    /**
     * a
     * 读取 业务对象基本信息 列表
     * 
     * @param condition
     *            查询条件
     * @return 业务对象基本信息列表
     */
    public List<BizObjInfoVO> queryBizObjInfoList(BizObjInfoVO condition) {
        return super.queryList("com.comtop.cap.bm.biz.info.model.queryBizObjInfoList", condition);
    }
    
    /**
     * 读取 业务对象基本信息 数据条数
     * 
     * @param condition
     *            查询条件
     * @return 业务对象基本信息数据条数
     */
    public int queryBizObjInfoCount(BizObjInfoVO condition) {
        return ((Integer) selectOne("com.comtop.cap.bm.biz.info.model.queryBizObjInfoCount", condition)).intValue();
    }
    
    /**
     * a
     * 根据业务域id列表 读取 业务对象基本信息 列表
     * 
     * @param condition
     *            查询条件
     * @return 业务对象基本信息列表
     */
    public List<BizObjInfoVO> queryBizObjInfoListByDomainIdList(BizObjInfoVO condition) {
        return super.queryList("com.comtop.cap.bm.biz.info.model.queryBizObjInfoListByDomainIdList", condition);
    }
    
    /**
     * 读取 业务对象基本信息 数据条数
     * 
     * @param condition
     *            查询条件
     * @return 业务对象基本信息数据条数
     */
    public int queryBizObjInfoCountByDomainIdList(BizObjInfoVO condition) {
        return ((Integer) selectOne("com.comtop.cap.bm.biz.info.model.queryBizObjInfoCountByDomainIdList", condition)).intValue();
    }
    
    /**
     * 通过bizObjInfoId删除相关业务对象数据项
     * 
     * @param bizObjInfoId
     *            业务对象基本信息Id
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public void deleteBizObjDataItemListByBizObjInfoId(String bizObjInfoId) {
        this.delete("com.comtop.cap.bm.biz.info.model.deleteBizObjDataItemListByBizObjInfoId", bizObjInfoId);
    }
    
    /****
     * 判断指定的业务域下是否已存在同名业务对象
     * 
     * @param bizObjInfo
     *            业务对象, 业务域ID、业务名称必须(如果是修改还需要传ID)
     * @return 如果存在则返回true;否则返回false
     */
    
    public boolean isExistSameNameBizInfo(final BizObjInfoVO bizObjInfo) {
        int i = ((Integer) selectOne("com.comtop.cap.bm.biz.info.model.isExistSameNameBizInfo", bizObjInfo)).intValue();
        return i > 0;
    }
    
    /****
     * 判断指定的业务域下是否已存在相同编号的业务对象
     * 
     * @param bizObjInfo
     *            业务对象, 业务域ID、业务编号必须(如果是修改还需要传ID)
     * @return 如果存在则返回true;否则返回false
     */
    public boolean isExistSameCodeBizInfo(final BizObjInfoVO bizObjInfo) {
        int i = ((Integer) selectOne("com.comtop.cap.bm.biz.info.model.isExistSameCodeBizInfo", bizObjInfo)).intValue();
        return i > 0;
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
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean updateSortNo(final BizObjInfoVO bizObjInfo, int type) {
        Map<String, Object> objParam = new HashMap<String, Object>();
        objParam.put("id", bizObjInfo.getId());
        if (CapNumberConstant.NUMBER_INT_ONE == type) {
            this.queryList("com.comtop.cap.bm.biz.info.model.proCapBizObjUpSortNo", objParam);
            return true;
        }
        if (CapNumberConstant.NUMBER_INT_MINUS == type) {
            this.queryList("com.comtop.cap.bm.biz.info.model.proCapBizObjDownSortNo", objParam);
            return true;
        }
        return false;
    }
    
    /**
     * 查询业务对象是否被引用
     * 
     * @param bizObjInfo 业务对象基本信息
     * @return 操作结果
     */
    public int checkObjInfoIsUse(BizObjInfoVO bizObjInfo) {
        int i = ((Integer) selectOne("com.comtop.cap.bm.biz.info.model.checkObjInfoIsUse", bizObjInfo)).intValue();
        return i;
    }
    
    /**
     * 获取业务对象名称集合
     * 
     * @param bizObjInfo 业务对象
     * @return 业务对象名称集合
     */
    public String queryBizObjInfoNames(BizObjInfoVO bizObjInfo) {
        return (String) selectOne("com.comtop.cap.bm.biz.info.model.queryBizObjInfoNames", bizObjInfo);
    }
    
    /**
     * 修改业务对象排序
     * 
     * @param bizObjInfo 业务对象基本信息
     */
    public void updateSortNo(BizObjInfoVO bizObjInfo) {
        selectOne("com.comtop.cap.bm.biz.info.model.updateSortNo", bizObjInfo);
    }
}
