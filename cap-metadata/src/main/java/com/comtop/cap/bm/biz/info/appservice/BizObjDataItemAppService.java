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
import com.comtop.cap.bm.biz.info.dao.BizObjDataItemDAO;
import com.comtop.cap.bm.biz.info.model.BizObjDataItemVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 业务对象数据项服务扩展类
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-11-10 CAP
 */
@PetiteBean
public class BizObjDataItemAppService extends MDBaseAppservice<BizObjDataItemVO> {
    
    /** 注入DAO **/
    @PetiteInject
    protected BizObjDataItemDAO bizObjDataItemDAO;
    
    /**
     * 新增 业务对象数据项
     * 
     * @param bizObjDataItem 业务对象数据项对象
     * @return 业务对象数据项Id
     */
    public Object insertBizObjDataItem(BizObjDataItemVO bizObjDataItem) {
        return bizObjDataItemDAO.insertBizObjDataItem(bizObjDataItem);
    }
    
    /**
     * 更新 业务对象数据项
     * 
     * @param bizObjDataItem 业务对象数据项对象
     * @return 更新成功与否
     */
    public boolean updateBizObjDataItem(BizObjDataItemVO bizObjDataItem) {
        return bizObjDataItemDAO.updateBizObjDataItem(bizObjDataItem);
    }
    
    /**
     * 删除 业务对象数据项
     * 
     * @param bizObjDataItem 业务对象数据项对象
     * @return 删除成功与否
     */
    public boolean deleteBizObjDataItem(BizObjDataItemVO bizObjDataItem) {
        return bizObjDataItemDAO.deleteBizObjDataItem(bizObjDataItem);
    }
    
    /**
     * 根据业务对象数据项的ID集合查询对应的业务对象数据项VO集合
     * @param ids 业务对象数据项的ID集合，为空是返回空集合
     * @return 符合条件的业务对象数据项VO集合
     */
    public List<BizObjDataItemVO> queryBizObjDataItemListByIds(List<String> ids) {
    	 return bizObjDataItemDAO.queryBizObjDataItemListByIds(ids);
    }

    /**
     * 读取 业务对象数据项
     * 
     * @param bizObjDataItem 业务对象数据项对象
     * @return 业务对象数据项
     */
    public BizObjDataItemVO loadBizObjDataItem(BizObjDataItemVO bizObjDataItem) {
        return bizObjDataItemDAO.loadBizObjDataItem(bizObjDataItem);
    }
    
    /**
     * 根据业务对象数据项主键读取 业务对象数据项
     * 
     * @param id 业务对象数据项主键
     * @return 业务对象数据项
     */
    public BizObjDataItemVO loadBizObjDataItemById(String id) {
        return bizObjDataItemDAO.loadBizObjDataItemById(id);
    }
    
    /**
     * 读取 业务对象数据项 列表
     * 
     * @param condition 查询条件
     * @return 业务对象数据项列表
     */
    public List<BizObjDataItemVO> queryBizObjDataItemList(BizObjDataItemVO condition) {
        return bizObjDataItemDAO.queryBizObjDataItemList(condition);
    }
    
    /**
     * 读取 业务对象数据项 数据条数
     * 
     * @param condition 查询条件
     * @return 业务对象数据项数据条数
     */
    public int queryBizObjDataItemCount(BizObjDataItemVO condition) {
        return bizObjDataItemDAO.queryBizObjDataItemCount(condition);
    }
    
    @Override
    protected MDBaseDAO<BizObjDataItemVO> getDAO() {
        return bizObjDataItemDAO;
    }
    
    /**
     * 加载不存在编码或排序号的数据
     *
     * @return 数据集
     */
    public List<BizObjDataItemVO> loadBizObjDataItemNotExistCodeOrSortNo() {
        return bizObjDataItemDAO.queryList("com.comtop.cap.bm.biz.info.model.loadBizObjDataItemNotExistCodeOrSortNo",
            null);
    }
    
    /**
     * 根据业务对象ID集合查询业务对象数据项集合
     *
     * @param objIds 业务对象ID集合
     * @return 业务对象数据项集合
     */
    public List<BizObjDataItemVO> loadBizObjDataItemsByIds(String[] objIds) {
        return bizObjDataItemDAO.loadBizObjDataItemsByIds(objIds);
    }
}
