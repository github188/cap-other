/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.ptc.notice.appservice;

import java.util.List;

import com.comtop.cap.ptc.notice.dao.CapPtcNoticeDAO;
import com.comtop.cap.ptc.notice.model.CapPtcNoticeVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.base.appservice.BaseAppService;

/**
 * 公告基本信息 业务逻辑处理类
 * 
 * @author CIP
 * @since 1.0
 * @version 2015-9-25 CIP
 */
@PetiteBean
public class CapPtcNoticeAppService extends BaseAppService {
    
    /** 注入DAO **/
    @PetiteInject
    protected CapPtcNoticeDAO capPtcNoticeDAO;
    
    /**
     * 新增 公告基本信息
     * 
     * @param capPtcNotice 公告基本信息对象
     * @return 公告基本信息Id
     */
    public Object insertCapPtcNotice(CapPtcNoticeVO capPtcNotice) {
        return capPtcNoticeDAO.insertCapPtcNotice(capPtcNotice);
    }
    
    /**
     * 更新 公告基本信息
     * 
     * @param capPtcNotice 公告基本信息对象
     * @return 更新成功与否
     */
    public boolean updateCapPtcNotice(CapPtcNoticeVO capPtcNotice) {
        return capPtcNoticeDAO.updateCapPtcNotice(capPtcNotice);
    }
    
    /**
     * 删除 公告基本信息
     * 
     * @param capPtcNotice 公告基本信息对象
     * @return 删除成功与否
     */
    public boolean deleteCapPtcNotice(CapPtcNoticeVO capPtcNotice) {
        return capPtcNoticeDAO.deleteCapPtcNotice(capPtcNotice);
    }
    
    /**
     * 删除 公告基本信息集合
     * 
     * @param capPtcNoticeList 公告基本信息对象
     * @return 删除成功与否
     */
    public boolean deleteCapPtcNoticeList(List<CapPtcNoticeVO> capPtcNoticeList) {
        if (capPtcNoticeList == null) {
            return true;
        }
        for (CapPtcNoticeVO capPtcNotice : capPtcNoticeList) {
            this.deleteCapPtcNotice(capPtcNotice);
        }
        return true;
    }
    
    /**
     * 读取 公告基本信息
     * 
     * @param capPtcNotice 公告基本信息对象
     * @return 公告基本信息
     */
    public CapPtcNoticeVO loadCapPtcNotice(CapPtcNoticeVO capPtcNotice) {
        return capPtcNoticeDAO.loadCapPtcNotice(capPtcNotice);
    }
    
    /**
     * 根据公告基本信息主键读取 公告基本信息
     * 
     * @param id 公告基本信息主键
     * @return 公告基本信息
     */
    public CapPtcNoticeVO loadCapPtcNoticeById(String id) {
        return capPtcNoticeDAO.loadCapPtcNoticeById(id);
    }
    
    /**
     * 读取 公告基本信息 列表
     * 
     * @param condition 查询条件
     * @return 公告基本信息列表
     */
    public List<CapPtcNoticeVO> queryCapPtcNoticeList(CapPtcNoticeVO condition) {
        return capPtcNoticeDAO.queryCapPtcNoticeList(condition);
    }
    
    /**
     * 读取 公告基本信息 数据条数
     * 
     * @param condition 查询条件
     * @return 公告基本信息数据条数
     */
    public int queryCapPtcNoticeCount(CapPtcNoticeVO condition) {
        return capPtcNoticeDAO.queryCapPtcNoticeCount(condition);
    }
    
    /**
     * 公告基本信息对象列表 (不翻页)
     * @param condition 查询条件对象
     * @return 公告基本信息对象列表 
     */
    public List<CapPtcNoticeVO> queryCapPtcNoticeListNoPage(CapPtcNoticeVO condition) {
        return capPtcNoticeDAO.queryCapPtcNoticeListNoPage(condition);
    }
    
}
