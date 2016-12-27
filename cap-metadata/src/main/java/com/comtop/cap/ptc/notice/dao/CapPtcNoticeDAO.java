/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.ptc.notice.dao;

import java.util.ArrayList;
import java.util.List;

import com.comtop.cap.ptc.notice.model.CapPtcNoticeVO;
import com.comtop.cip.jodd.jtx.JtxPropagationBehavior;
import com.comtop.cip.jodd.jtx.meta.Transaction;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.top.core.base.dao.CoreDAO;

/**
 * 公告基本信息DAO
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-9-25 CAP
 */
@PetiteBean
public class CapPtcNoticeDAO extends CoreDAO<CapPtcNoticeVO> {
    
    /**
     * 新增 公告基本信息
     * 
     * @param capPtcNotice 公告基本信息对象
     * @return 公告基本信息Id
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public Object insertCapPtcNotice(CapPtcNoticeVO capPtcNotice) {
        Object result = insert(capPtcNotice);
        return result;
    }
    
    /**
     * 更新 公告基本信息
     * 
     * @param capPtcNotice 公告基本信息对象
     * @return 更新成功与否
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean updateCapPtcNotice(CapPtcNoticeVO capPtcNotice) {
        return update(capPtcNotice);
    }
    
    /**
     * 删除 公告基本信息
     * 
     * @param capPtcNotice 公告基本信息对象
     * @return 删除成功与否
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean deleteCapPtcNotice(CapPtcNoticeVO capPtcNotice) {
        return delete(capPtcNotice);
    }
    
    /**
     * 读取 公告基本信息
     * 
     * @param capPtcNotice 公告基本信息对象
     * @return 公告基本信息
     */
    public CapPtcNoticeVO loadCapPtcNotice(CapPtcNoticeVO capPtcNotice) {
        CapPtcNoticeVO objCapPtcNotice = load(capPtcNotice);
        return objCapPtcNotice;
    }
    
    /**
     * 根据公告基本信息主键读取 公告基本信息
     * 
     * @param id 公告基本信息主键
     * @return 公告基本信息
     */
    public CapPtcNoticeVO loadCapPtcNoticeById(String id) {
        CapPtcNoticeVO objCapPtcNotice = new CapPtcNoticeVO();
        objCapPtcNotice.setId(id);
        return loadCapPtcNotice(objCapPtcNotice);
    }
    
    /**
     * 读取 公告基本信息 列表
     * 
     * @param condition 查询条件
     * @return 公告基本信息列表
     */
    public List<CapPtcNoticeVO> queryCapPtcNoticeList(CapPtcNoticeVO condition) {
        return queryList("com.comtop.cap.ptc.notice.model.queryCapPtcNoticeList", condition, condition.getPageNo(),
            condition.getPageSize());
    }
    
    /**
     * 读取 公告基本信息 数据条数
     * 
     * @param condition 查询条件
     * @return 公告基本信息数据条数
     */
    public int queryCapPtcNoticeCount(CapPtcNoticeVO condition) {
        return ((Integer) selectOne("com.comtop.cap.ptc.notice.model.queryCapPtcNoticeCount", condition)).intValue();
    }
    
    /**
     * 公告基本信息对象列表 (不翻页)
     * @param condition 查询条件对象
     * @return 公告基本信息对象列表 
     */
    public List<CapPtcNoticeVO> queryCapPtcNoticeListNoPage(CapPtcNoticeVO condition) {
    	List<CapPtcNoticeVO> lstCapPtcNoticeVO = queryList("com.comtop.cap.ptc.notice.model.queryCapPtcNoticeList", condition); 
        return lstCapPtcNoticeVO == null ? new ArrayList<CapPtcNoticeVO>(0) : lstCapPtcNoticeVO;
    }
    
}
