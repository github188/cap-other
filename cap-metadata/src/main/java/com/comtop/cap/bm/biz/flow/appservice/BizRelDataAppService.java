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
import com.comtop.cap.bm.biz.flow.dao.BizRelDataDAO;
import com.comtop.cap.bm.biz.flow.model.BizRelDataVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 业务关联数据项 业务逻辑处理类
 * 
 * @author CIP
 * @since 1.0
 * @version 2015-11-26 CIP
 */
@PetiteBean
public class BizRelDataAppService extends MDBaseAppservice<BizRelDataVO> {
    
    /** 注入DAO **/
    @PetiteInject
    protected BizRelDataDAO bizRelDataDAO;
    
    /** 注入DAO **/
    @PetiteInject
    protected BizRelInfoAppService bizRelInfoAppService;
    
    /**
     * 新增 业务关联数据项
     * 
     * @param bizRelData 业务关联数据项对象
     * @return 业务关联数据项Id
     */
    public Object insertBizRelData(BizRelDataVO bizRelData) {
        return bizRelDataDAO.insertBizRelData(bizRelData);
    }
    
    /**
     * 更新 业务关联数据项
     * 
     * @param bizRelData 业务关联数据项对象
     * @return 更新成功与否
     */
    public boolean updateBizRelData(BizRelDataVO bizRelData) {
        return bizRelDataDAO.updateBizRelData(bizRelData);
    }
    
    /**
     * 删除 业务关联数据项
     * 
     * @param bizRelData 业务关联数据项对象
     * @return 删除成功与否
     */
    public boolean deleteBizRelData(BizRelDataVO bizRelData) {
        return bizRelDataDAO.deleteBizRelData(bizRelData);
    }
    
    /**
     * 删除 业务关联数据项集合
     * 
     * @param bizRelDataList 业务关联数据项对象
     * @return 删除成功与否
     */
    public boolean deleteBizRelDataList(List<BizRelDataVO> bizRelDataList) {
        if (bizRelDataList == null) {
            return true;
        }
        for (BizRelDataVO bizRelData : bizRelDataList) {
            this.deleteBizRelData(bizRelData);
        }
        return true;
    }
    
    /**
     * 读取 业务关联数据项
     * 
     * @param bizRelData 业务关联数据项对象
     * @return 业务关联数据项
     */
    public BizRelDataVO loadBizRelData(BizRelDataVO bizRelData) {
        return bizRelDataDAO.loadBizRelData(bizRelData);
    }
    
    /**
     * 根据业务关联数据项主键读取 业务关联数据项
     * 
     * @param id 业务关联数据项主键
     * @return 业务关联数据项
     */
    public BizRelDataVO loadBizRelDataById(String id) {
        return bizRelDataDAO.loadBizRelDataById(id);
    }
    
    /**
     * 读取 业务关联数据项 列表
     * 
     * @param condition 查询条件
     * @return 业务关联数据项列表
     */
    public List<BizRelDataVO> queryBizRelDataList(BizRelDataVO condition) {
        return bizRelDataDAO.queryBizRelDataList(condition);
    }
    
    /**
     * 读取 业务关联数据项 数据条数
     * 
     * @param condition 查询条件
     * @return 业务关联数据项数据条数
     */
    public int queryBizRelDataCount(BizRelDataVO condition) {
        return bizRelDataDAO.queryBizRelDataCount(condition);
    }
    
    @Override
    protected MDBaseDAO<BizRelDataVO> getDAO() {
        return bizRelDataDAO;
    }
    
}
