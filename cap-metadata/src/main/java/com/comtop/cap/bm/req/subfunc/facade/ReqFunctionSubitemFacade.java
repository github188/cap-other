/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.req.subfunc.facade;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.bm.biz.flow.appservice.BizProcessInfoAppService;
import com.comtop.cap.bm.biz.flow.model.BizProcessInfoVO;
import com.comtop.cap.bm.biz.info.appservice.BizObjInfoAppService;
import com.comtop.cap.bm.biz.info.model.BizObjInfoVO;
import com.comtop.cap.bm.req.func.appservice.ReqFunctionItemAppService;
import com.comtop.cap.bm.req.subfunc.appservice.ReqFunctionSubitemAppService;
import com.comtop.cap.bm.req.subfunc.model.ReqFunctionSubitemVO;
import com.comtop.cap.runtime.component.facade.AutoGenNumberFacade;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.base.facade.BaseFacade;
import com.comtop.cap.runtime.core.AppBeanUtil;

/**
 * 功能子项,建在功能项下面扩展实现
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-11-25 CAP
 */
@PetiteBean
public class ReqFunctionSubitemFacade extends BaseFacade {
    
    /** 注入AppService **/
    @PetiteInject
    protected ReqFunctionSubitemAppService reqFunctionSubitemAppService;
    
    /** 注入AppService **/
    @PetiteInject
    protected BizProcessInfoAppService bizProcessInfoAppService;
    
    /** 注入AppService **/
    @PetiteInject
    protected BizObjInfoAppService bizObjInfoAppService;
    
    /** 注入AppService **/
    @PetiteInject
    protected ReqFunctionItemAppService reqFunctionItemAppService;
    
    /**
     * 新增 功能子项,建在功能项下面
     * 
     * @param reqFunctionSubitemVO 功能子项,建在功能项下面对象
     * @return 功能子项,建在功能项下面
     */
    public Object insertReqFunctionSubitem(ReqFunctionSubitemVO reqFunctionSubitemVO) {
        String id = (String) reqFunctionSubitemAppService.insertReqFunctionSubitem(reqFunctionSubitemVO);
        reqFunctionSubitemVO.setId(id);
        this.updateCodeAndSortNo(reqFunctionSubitemVO);
        return id;
    }
    
    /**
     * 更新 功能子项,建在功能项下面
     * 
     * @param reqFunctionSubitemVO 功能子项,建在功能项下面对象
     * @return 更新结果
     */
    public boolean updateReqFunctionSubitem(ReqFunctionSubitemVO reqFunctionSubitemVO) {
        return reqFunctionSubitemAppService.updateReqFunctionSubitem(reqFunctionSubitemVO);
    }
    
    /**
     * 保存或更新功能子项,建在功能项下面，根据ID是否为空
     * 
     * @param reqFunctionSubitemVO 功能子项,建在功能项下面ID
     * @return 功能子项,建在功能项下面保存后的主键ID
     */
    public String saveReqFunctionSubitem(ReqFunctionSubitemVO reqFunctionSubitemVO) {
        if (reqFunctionSubitemVO.getId() == null) {
            String strId = (String) this.insertReqFunctionSubitem(reqFunctionSubitemVO);
            reqFunctionSubitemVO.setId(strId);
        } else {
            this.updateReqFunctionSubitem(reqFunctionSubitemVO);
        }
        return reqFunctionSubitemVO.getId();
    }
    
    /**
     * 读取 功能子项,建在功能项下面 列表，分页查询--新版设计器使用
     * 
     * @param condition 查询条件
     * @return 功能子项,建在功能项下面列表
     */
    public Map<String, Object> queryReqFunctionSubitemListByPage(ReqFunctionSubitemVO condition) {
        final Map<String, Object> ret = new HashMap<String, Object>(2);
        int count = reqFunctionSubitemAppService.queryReqFunctionSubitemCount(condition);
        List<ReqFunctionSubitemVO> reqFunctionSubitemVOList = null;
        if (count > 0) {
            reqFunctionSubitemVOList = reqFunctionSubitemAppService.queryReqFunctionSubitemList(condition);
        }
        ret.put("list", reqFunctionSubitemVOList);
        ret.put("count", count);
        return ret;
    }
    
    /**
     * 删除 功能子项,建在功能项下面
     * 
     * @param reqFunctionSubitemVO 功能子项,建在功能项下面对象
     * @return 删除结果
     */
    public boolean deleteReqFunctionSubitem(ReqFunctionSubitemVO reqFunctionSubitemVO) {
        return reqFunctionSubitemAppService.deleteReqFunctionSubitem(reqFunctionSubitemVO);
    }
    
    /**
     * 删除 功能子项,建在功能项下面集合
     * 
     * @param reqFunctionSubitemVOList 功能子项,建在功能项下面对象
     * @return 删除结果
     */
    public boolean deleteReqFunctionSubitemList(List<ReqFunctionSubitemVO> reqFunctionSubitemVOList) {
        return reqFunctionSubitemAppService.deleteReqFunctionSubitemList(reqFunctionSubitemVOList);
    }
    
    /**
     * 读取 功能子项,建在功能项下面
     * 
     * @param reqFunctionSubitemVO 功能子项,建在功能项下面对象
     * @return 功能子项,建在功能项下面
     */
    public ReqFunctionSubitemVO loadReqFunctionSubitem(ReqFunctionSubitemVO reqFunctionSubitemVO) {
        return reqFunctionSubitemAppService.loadReqFunctionSubitem(reqFunctionSubitemVO);
    }
    
    /**
     * 根据功能子项,建在功能项下面主键 读取 功能子项,建在功能项下面
     * 
     * @param id 功能子项,建在功能项下面主键
     * @return 功能子项,建在功能项下面
     */
    public ReqFunctionSubitemVO loadById(String id) {
        return reqFunctionSubitemAppService.loadReqFunctionSubitemById(id);
    }
    
    /**
     * 根据功能子项,建在功能项下面主键 读取 功能子项,建在功能项下面
     * 
     * @param id 功能子项,建在功能项下面主键
     * @return 功能子项,建在功能项下面
     */
    public ReqFunctionSubitemVO loadReqFunctionSubitemById(String id) {
        ReqFunctionSubitemVO functionSubitemVO = reqFunctionSubitemAppService.loadReqFunctionSubitemById(id);
        if (functionSubitemVO == null) {
            return null;
        }
        if (StringUtils.isNotBlank(functionSubitemVO.getNodeIds())) {
            BizProcessInfoVO bizProcessInfoVO = new BizProcessInfoVO();
            bizProcessInfoVO.setIdList(functionSubitemVO.getNodeIds().split(","));
            functionSubitemVO.setNodeNames(bizProcessInfoAppService.queryProcessNodeNames(bizProcessInfoVO));
        }
        if (StringUtils.isNotBlank(functionSubitemVO.getBizObjectIds())) {
            BizObjInfoVO bizObjInfoVO = new BizObjInfoVO();
            bizObjInfoVO.setIdList(functionSubitemVO.getBizObjectIds().split(","));
            functionSubitemVO.setBizObjectNames(bizObjInfoAppService.queryBizObjInfoNames(bizObjInfoVO));
        }
        return functionSubitemVO;
    }
    
    /**
     * 读取 功能子项,建在功能项下面 列表
     * 
     * @param condition 查询条件
     * @return 功能子项,建在功能项下面列表
     */
    public List<ReqFunctionSubitemVO> queryReqFunctionSubitemList(ReqFunctionSubitemVO condition) {
        return reqFunctionSubitemAppService.queryReqFunctionSubitemList(condition);
    }
    
    /**
     * 读取 功能子项,建在功能项下面 数据条数
     * 
     * @param condition 查询条件
     * @return 功能子项,建在功能项下面数据条数
     */
    public int queryReqFunctionSubitemCount(ReqFunctionSubitemVO condition) {
        return reqFunctionSubitemAppService.queryReqFunctionSubitemCount(condition);
    }
    
    /**
     * 更新编码和序号
     * 
     * @param functionSubitemVO ReqFunctionSubitemVO
     */
    public void updateCodeAndSortNo(ReqFunctionSubitemVO functionSubitemVO) {
        String itemCode = reqFunctionItemAppService.queryReqFunctionItemById(functionSubitemVO.getItemId()).getCode();
        // sortNo
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("itemCode", itemCode);
        AutoGenNumberFacade autoGenNumberService = AppBeanUtil.getBean(AutoGenNumberFacade.class);
        String sortNo = autoGenNumberService.genNumber(ReqFunctionSubitemVO.SORT_EXPR, params);
        bizProcessInfoAppService.updatePropertyById(functionSubitemVO.getId(), "sortNo", sortNo);
        functionSubitemVO.setSortNo(Integer.parseInt(sortNo));
        // code
        String code = autoGenNumberService.genNumber(ReqFunctionSubitemVO.CODE_EXPR, params);
        functionSubitemVO.setCode(code);
        bizProcessInfoAppService.updatePropertyById(functionSubitemVO.getId(), "code", code);
        this.updateReqFunctionSubitem(functionSubitemVO);
    }
    
    /**
     * 更新 排序号
     * 
     * @param reqFunctionSubitemVO 功能子项
     *
     */
    public void updateSortNoById(ReqFunctionSubitemVO reqFunctionSubitemVO) {
        reqFunctionSubitemAppService.updateSortNoById(reqFunctionSubitemVO);
    }
    
}
