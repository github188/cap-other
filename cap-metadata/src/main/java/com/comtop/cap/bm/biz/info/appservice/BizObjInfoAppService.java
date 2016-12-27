/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.biz.info.appservice;

import java.util.List;

import com.comtop.cap.base.MDBaseAppservice;
import com.comtop.cap.base.MDBaseDAO;
import com.comtop.cap.bm.biz.info.dao.BizObjInfoDAO;
import com.comtop.cap.bm.biz.info.model.BizObjInfoVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 业务对象基本信息服务扩展类
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-11-10 CAP
 */
@PetiteBean
public class BizObjInfoAppService extends MDBaseAppservice<BizObjInfoVO> {
    
    /** 注入DAO **/
    @PetiteInject
    protected BizObjInfoDAO bizObjInfoDAO;
    
    /**
     * 新增 业务对象基本信息
     * 
     * @param bizObjInfo 业务对象基本信息对象
     * @return 业务对象基本信息Id
     */
    public Object insertBizObjInfo(BizObjInfoVO bizObjInfo) {
        return bizObjInfoDAO.insertBizObjInfo(bizObjInfo);
    }
    
    /**
     * 更新 业务对象基本信息
     * 
     * @param bizObjInfo 业务对象基本信息对象
     * @return 更新成功与否
     */
    public boolean updateBizObjInfo(BizObjInfoVO bizObjInfo) {
        return bizObjInfoDAO.updateBizObjInfo(bizObjInfo);
    }
    
    /**
     * 删除 业务对象基本信息
     * 
     * @param bizObjInfo 业务对象基本信息对象
     * @return 删除成功与否
     */
    public boolean deleteBizObjInfo(BizObjInfoVO bizObjInfo) {
        return bizObjInfoDAO.deleteBizObjInfo(bizObjInfo);
    }
    
    /**
     * 删除 业务对象基本信息集合
     * 
     * @param bizObjInfoList 业务对象基本信息对象
     * @return 删除成功与否
     */
    public boolean deleteBizObjInfoList(List<BizObjInfoVO> bizObjInfoList) {
        if (bizObjInfoList == null) {
            return true;
        }
        for (BizObjInfoVO bizObjInfo : bizObjInfoList) {
            this.deleteBizObjInfo(bizObjInfo);
        }
        return true;
    }
    
    /**
     * 读取 业务对象基本信息
     * 
     * @param bizObjInfo 业务对象基本信息对象
     * @return 业务对象基本信息
     */
    public BizObjInfoVO loadBizObjInfo(BizObjInfoVO bizObjInfo) {
        return bizObjInfoDAO.loadBizObjInfo(bizObjInfo);
    }
    
    /**
     * 根据业务对象基本信息主键读取 业务对象基本信息
     * 
     * @param id 业务对象基本信息主键
     * @return 业务对象基本信息
     */
    public BizObjInfoVO loadBizObjInfoById(String id) {
        return bizObjInfoDAO.loadBizObjInfoById(id);
    }
    
    /**
     * 读取 业务对象基本信息 列表
     * 
     * @param condition 查询条件
     * @return 业务对象基本信息列表
     */
    public List<BizObjInfoVO> queryBizObjInfoList(BizObjInfoVO condition) {
        return bizObjInfoDAO.queryBizObjInfoList(condition);
    }
    
    /**
     * 读取 业务对象基本信息 列表
     * 
     * @param condition 查询条件
     * @return 业务对象基本信息列表
     */
    public List<BizObjInfoVO> queryBizObjInfoListByDomainIdList(BizObjInfoVO condition) {
        return bizObjInfoDAO.queryBizObjInfoListByDomainIdList(condition);
    }
    
    /**
     * 根据业务对象ID集合查询对应的业务对象VO集合
     * 
     * @param bizInfoIds 业务对象的ID集合，为空是返回空集合
     * @return 符合条件的业务对象VO集合
     */
    public List<BizObjInfoVO> queryBizInfoListByIds(List<String> bizInfoIds) {
        return bizObjInfoDAO.queryBizInfoListByIds(bizInfoIds);
    }
    
    /****
     * 判断指定的业务域下是否已存在同名业务对象
     * 
     * @param bizObjInfo 业务对象, 业务域ID、业务名称必须(如果是修改还需要传ID)
     * @return 如果存在则返回true;否则返回false
     */
    public boolean isExistSameNameBizInfo(BizObjInfoVO bizObjInfo) {
        return bizObjInfoDAO.isExistSameNameBizInfo(bizObjInfo);
    }
    
    /****
     * 判断指定的业务域下是否已存在相同编号的业务对象
     * 
     * @param bizObjInfo 业务对象, 业务域ID、业务编号必须(如果是修改还需要传ID)
     * @return 如果存在则返回true;否则返回false
     */
    public boolean isExistSameCodeBizInfo(final BizObjInfoVO bizObjInfo) {
        return bizObjInfoDAO.isExistSameCodeBizInfo(bizObjInfo);
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
        return bizObjInfoDAO.updateSortNo(bizObjInfo, type);
    }
    
    /**
     * /**
     * 读取 业务对象基本信息 数据条数
     * 
     * @param condition 查询条件
     * @return 业务对象基本信息数据条数
     */
    public int queryBizObjInfoCount(BizObjInfoVO condition) {
        return bizObjInfoDAO.queryBizObjInfoCount(condition);
    }
    
    /**
     * /**
     * 读取 业务对象基本信息 数据条数
     * 
     * @param condition 查询条件
     * @return 业务对象基本信息数据条数
     */
    public int queryBizObjInfoCountByDomainIdList(BizObjInfoVO condition) {
        return bizObjInfoDAO.queryBizObjInfoCountByDomainIdList(condition);
    }
    
    @Override
    protected MDBaseDAO<BizObjInfoVO> getDAO() {
        return bizObjInfoDAO;
    }
    
    /**
     * 查询业务对象是否被引用
     * 
     * @param bizObjInfo 业务对象基本信息
     * @return 操作结果
     */
    public int checkObjInfoIsUse(BizObjInfoVO bizObjInfo) {
        return bizObjInfoDAO.checkObjInfoIsUse(bizObjInfo);
    }
    
    /**
     * 获取业务对象名称集合
     * 
     * @param bizObjInfo 业务对象
     * @return 业务对象名称集合
     */
    public String queryBizObjInfoNames(BizObjInfoVO bizObjInfo) {
        return bizObjInfoDAO.queryBizObjInfoNames(bizObjInfo);
    }
    
    /**
     * 加载不存在编码或排序号的数据
     * 
     * @return 数据集
     */
    public List<BizObjInfoVO> loadBizObjInfoNotExistCodeOrSortNo() {
        return bizObjInfoDAO.queryList("com.comtop.cap.bm.biz.info.model.loadBizObjInfoNotExistCodeOrSortNo", null);
    }
    
    /**
     * 加载不存在编码或排序号的数据
     * 
     * @param condition 条件
     * 
     * @return 数据集
     */
    public List<BizObjInfoVO> loadBizObjInfoVOListWithNoPackageId(BizObjInfoVO condition) {
        return bizObjInfoDAO.queryList("com.comtop.cap.bm.biz.info.model.loadBizObjInfoVOListWithNoPackageId", condition);
    }
    
    /**
     * 修改业务对象排序
     * 
     * @param bizObjInfo 业务对象基本信息
     */
    public void updateSortNo(BizObjInfoVO bizObjInfo) {
        bizObjInfoDAO.updateSortNo(bizObjInfo);
    }
}
