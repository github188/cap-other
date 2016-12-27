/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.biz.flow.appservice;

import java.util.List;

import com.comtop.cap.base.MDBaseAppservice;
import com.comtop.cap.base.MDBaseDAO;
import com.comtop.cap.bm.biz.flow.dao.BizRelInfoDAO;
import com.comtop.cap.bm.biz.flow.model.BizRelInfoVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 业务关联 业务逻辑处理类
 * 
 * @author CIP
 * @since 1.0
 * @version 2015-11-25 CIP
 */
@PetiteBean
public class BizRelInfoAppService extends MDBaseAppservice<BizRelInfoVO> {
    
    /** 注入DAO **/
    @PetiteInject
    protected BizRelInfoDAO bizRelInfoDAO;
    
    /**
     * 新增 业务关联
     * 
     * @param bizRelInfo 业务关联对象
     * @return 业务关联Id
     */
    public Object insertBizRelInfo(BizRelInfoVO bizRelInfo) {
        return bizRelInfoDAO.insertBizRelInfo(bizRelInfo);
    }
    
    /**
     * 更新 业务关联
     * 
     * @param bizRelInfo 业务关联对象
     * @return 更新成功与否
     */
    public boolean updateBizRelInfo(BizRelInfoVO bizRelInfo) {
        return bizRelInfoDAO.updateBizRelInfo(bizRelInfo);
    }
    
    /**
     * 删除 业务关联
     * 
     * @param bizRelInfo 业务关联对象
     * @return 删除成功与否
     */
    public boolean deleteBizRelInfo(BizRelInfoVO bizRelInfo) {
        return bizRelInfoDAO.deleteBizRelInfo(bizRelInfo);
    }
    
    /**
     * 删除 业务关联集合
     * 
     * @param bizRelInfoList 业务关联对象
     * @return 删除成功与否
     */
    public boolean deleteBizRelInfoList(List<BizRelInfoVO> bizRelInfoList) {
        if (bizRelInfoList == null) {
            return true;
        }
        for (BizRelInfoVO bizRelInfo : bizRelInfoList) {
            this.deleteBizRelInfo(bizRelInfo);
        }
        return true;
    }
    
    /**
     * 读取 业务关联
     * 
     * @param bizRelInfo 业务关联对象
     * @return 业务关联
     */
    public BizRelInfoVO loadBizRelInfo(BizRelInfoVO bizRelInfo) {
        return bizRelInfoDAO.loadBizRelInfo(bizRelInfo);
    }
    
    /**
     * 根据业务关联主键读取 业务关联
     * 
     * @param id 业务关联主键
     * @return 业务关联
     */
    public BizRelInfoVO loadBizRelInfoById(String id) {
        return bizRelInfoDAO.loadBizRelInfoById(id);
    }
    
    /**
     * 读取 业务关联 列表
     * 
     * @param condition 查询条件
     * @return 业务关联列表
     */
    public List<BizRelInfoVO> queryBizRelInfoList(BizRelInfoVO condition) {
        return bizRelInfoDAO.queryBizRelInfoList(condition);
    }
    
    /**
     * 读取 业务关联 数据条数
     * 
     * @param condition 查询条件
     * @return 业务关联数据条数
     */
    public int queryBizRelInfoCount(BizRelInfoVO condition) {
        return bizRelInfoDAO.queryBizRelInfoCount(condition);
    }
    
    /**
     * 同步数据
     * 
     * @param condition 业务关联
     */
    public void synBizNodeConstraint(BizRelInfoVO condition) {
        bizRelInfoDAO.synBizNodeConstraint(condition);
    }
    
    @Override
    protected MDBaseDAO<BizRelInfoVO> getDAO() {
        return bizRelInfoDAO;
    }
}
