/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.ptc.notice.facade;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.comtop.cap.ptc.notice.appservice.CapPtcNoticeAppService;
import com.comtop.cap.ptc.notice.model.CapPtcNoticeVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.base.facade.BaseFacade;

/**
 * 公告基本信息 业务逻辑处理类 门面
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-9-25 CAP
 */
@PetiteBean
public class CapPtcNoticeFacade extends BaseFacade {
    
    /** 注入AppService **/
    @PetiteInject
    protected CapPtcNoticeAppService capPtcNoticeAppService;
    
    /**
     * 新增 公告基本信息
     * 
     * @param capPtcNoticeVO 公告基本信息对象
     * @return 公告基本信息
     */
    public Object insertCapPtcNotice(CapPtcNoticeVO capPtcNoticeVO) {
        return capPtcNoticeAppService.insertCapPtcNotice(capPtcNoticeVO);
    }
    
    /**
     * 更新 公告基本信息
     * 
     * @param capPtcNoticeVO 公告基本信息对象
     * @return 更新结果
     */
    public boolean updateCapPtcNotice(CapPtcNoticeVO capPtcNoticeVO) {
        return capPtcNoticeAppService.updateCapPtcNotice(capPtcNoticeVO);
    }
    
    /**
     * 保存或更新公告基本信息，根据ID是否为空
     * 
     * @param capPtcNoticeVO 公告基本信息ID
     * @return 公告基本信息保存后的主键ID
     */
    public String saveCapPtcNotice(CapPtcNoticeVO capPtcNoticeVO) {
        if (capPtcNoticeVO.getId() == null) {
            String strId = (String) this.insertCapPtcNotice(capPtcNoticeVO);
            capPtcNoticeVO.setId(strId);
        } else {
            this.updateCapPtcNotice(capPtcNoticeVO);
        }
        return capPtcNoticeVO.getId();
    }
    
    /**
     * 读取 公告基本信息 列表，分页查询--新版设计器使用
     * 
     * @param condition 查询条件
     * @return 公告基本信息列表
     */
    public Map<String, Object> queryCapPtcNoticeListByPage(CapPtcNoticeVO condition) {
        final Map<String, Object> ret = new HashMap<String, Object>(2);
        int count = capPtcNoticeAppService.queryCapPtcNoticeCount(condition);
        List<CapPtcNoticeVO> capPtcNoticeVOList = null;
        if (count > 0) {
            capPtcNoticeVOList = capPtcNoticeAppService.queryCapPtcNoticeList(condition);
        }
        ret.put("list", capPtcNoticeVOList);
        ret.put("count", count);
        return ret;
    }
    
    /**
     * 删除 公告基本信息
     * 
     * @param capPtcNoticeVO 公告基本信息对象
     * @return 删除结果
     */
    public boolean deleteCapPtcNotice(CapPtcNoticeVO capPtcNoticeVO) {
        return capPtcNoticeAppService.deleteCapPtcNotice(capPtcNoticeVO);
    }
    
    /**
     * 删除 公告基本信息集合
     * 
     * @param capPtcNoticeVOList 公告基本信息对象
     * @return 删除结果
     */
    public boolean deleteCapPtcNoticeList(List<CapPtcNoticeVO> capPtcNoticeVOList) {
        return capPtcNoticeAppService.deleteCapPtcNoticeList(capPtcNoticeVOList);
    }
    
    /**
     * 读取 公告基本信息
     * 
     * @param capPtcNoticeVO 公告基本信息对象
     * @return 公告基本信息
     */
    public CapPtcNoticeVO loadCapPtcNotice(CapPtcNoticeVO capPtcNoticeVO) {
        return capPtcNoticeAppService.loadCapPtcNotice(capPtcNoticeVO);
    }
    
    /**
     * 根据公告基本信息主键 读取 公告基本信息
     * 
     * @param id 公告基本信息主键
     * @return 公告基本信息
     */
    public CapPtcNoticeVO loadCapPtcNoticeById(String id) {
        return capPtcNoticeAppService.loadCapPtcNoticeById(id);
    }
    
    /**
     * 读取 公告基本信息 列表
     * 
     * @param condition 查询条件
     * @return 公告基本信息列表
     */
    public List<CapPtcNoticeVO> queryCapPtcNoticeList(CapPtcNoticeVO condition) {
        return capPtcNoticeAppService.queryCapPtcNoticeList(condition);
    }
    
    /**
     * 读取 公告基本信息 数据条数
     * 
     * @param condition 查询条件
     * @return 公告基本信息数据条数
     */
    public int queryCapPtcNoticeCount(CapPtcNoticeVO condition) {
        return capPtcNoticeAppService.queryCapPtcNoticeCount(condition);
    }
    
    /**
     * 公告基本信息对象列表 (不翻页)
     * @param condition 查询条件对象
     * @return 公告基本信息对象列表 
     */
    public List<CapPtcNoticeVO> queryCapPtcNoticeListNoPage(CapPtcNoticeVO condition) {
        return capPtcNoticeAppService.queryCapPtcNoticeListNoPage(condition);
    }
    
}
