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

import com.comtop.cap.bm.req.subfunc.appservice.ReqFunctionUsecaseAppService;
import com.comtop.cap.bm.req.subfunc.model.ReqFunctionUsecaseVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.base.facade.BaseFacade;
import com.comtop.cap.runtime.core.AppBeanUtil;

/**
 * 功能用例 业务逻辑处理类 门面
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-12-22 CAP
 */
@PetiteBean
public class ReqFunctionUsecaseFacade extends BaseFacade {
    
    /** 注入AppService **/
    @PetiteInject
    protected ReqFunctionUsecaseAppService reqFunctionUsecaseAppService;
    
    /** 功能用例关联业务表单 Facade */
    protected final ReqUsecaseRelFormFacade reqUsecaseRelFormFacade = AppBeanUtil
        .getBean(ReqUsecaseRelFormFacade.class);
    
    /**
     * 新增 功能用例
     * 
     * @param reqFunctionUsecaseVO 功能用例对象
     * @return 功能用例
     */
    public Object insertReqFunctionUsecase(ReqFunctionUsecaseVO reqFunctionUsecaseVO) {
        return reqFunctionUsecaseAppService.insertReqFunctionUsecase(reqFunctionUsecaseVO);
    }
    
    /**
     * 更新 功能用例
     * 
     * @param reqFunctionUsecaseVO 功能用例对象
     * @return 更新结果
     */
    public boolean updateReqFunctionUsecase(ReqFunctionUsecaseVO reqFunctionUsecaseVO) {
        return reqFunctionUsecaseAppService.updateReqFunctionUsecase(reqFunctionUsecaseVO);
    }
    
    /**
     * 保存或更新功能用例，根据ID是否为空
     * 
     * @param reqFunctionUsecaseVO 功能用例ID
     * @return 功能用例保存后的主键ID
     */
    public String saveReqFunctionUsecase(ReqFunctionUsecaseVO reqFunctionUsecaseVO) {
        if (reqFunctionUsecaseVO.getId() == null) {
            String strId = (String) this.insertReqFunctionUsecase(reqFunctionUsecaseVO);
            reqFunctionUsecaseVO.setId(strId);
        } else {
            this.updateReqFunctionUsecase(reqFunctionUsecaseVO);
        }
        return reqFunctionUsecaseVO.getId();
    }
    
    /**
     * 读取 功能用例 列表，分页查询--新版设计器使用
     * 
     * @param condition 查询条件
     * @return 功能用例列表
     */
    public Map<String, Object> queryReqFunctionUsecaseListByPage(ReqFunctionUsecaseVO condition) {
        final Map<String, Object> ret = new HashMap<String, Object>(2);
        int count = reqFunctionUsecaseAppService.queryReqFunctionUsecaseCount(condition);
        List<ReqFunctionUsecaseVO> reqFunctionUsecaseVOList = null;
        if (count > 0) {
            reqFunctionUsecaseVOList = reqFunctionUsecaseAppService.queryReqFunctionUsecaseList(condition);
        }
        ret.put("list", reqFunctionUsecaseVOList);
        ret.put("count", count);
        return ret;
    }
    
    /**
     * 删除 功能用例
     * 
     * @param subitemId 功能子项id
     */
    public void deleteReqFunctionUsecase(String subitemId) {
        ReqFunctionUsecaseVO functionUsecaseVO = new ReqFunctionUsecaseVO();
        functionUsecaseVO.setSubitemId(subitemId);
        List<ReqFunctionUsecaseVO> functionUsecaseVOs = this.queryReqFunctionUsecaseList(functionUsecaseVO);
        if (functionUsecaseVOs.size() > 0) {
            ReqFunctionUsecaseVO usecaseVO = functionUsecaseVOs.get(0);
            reqUsecaseRelFormFacade.deleteReqUsecaseRelFormByUsecaseId(usecaseVO.getId());
            reqFunctionUsecaseAppService.deleteReqFunctionUsecase(usecaseVO);
        }
    }
    
    /**
     * 删除 功能用例集合
     * 
     * @param reqFunctionUsecaseVOList 功能用例对象
     * @return 删除结果
     */
    public boolean deleteReqFunctionUsecaseList(List<ReqFunctionUsecaseVO> reqFunctionUsecaseVOList) {
        return reqFunctionUsecaseAppService.deleteReqFunctionUsecaseList(reqFunctionUsecaseVOList);
    }
    
    /**
     * 读取 功能用例
     * 
     * @param reqFunctionUsecaseVO 功能用例对象
     * @return 功能用例
     */
    public ReqFunctionUsecaseVO loadReqFunctionUsecase(ReqFunctionUsecaseVO reqFunctionUsecaseVO) {
        return reqFunctionUsecaseAppService.loadReqFunctionUsecase(reqFunctionUsecaseVO);
    }
    
    /**
     * 根据功能用例主键 读取 功能用例
     * 
     * @param id 功能用例主键
     * @return 功能用例
     */
    public ReqFunctionUsecaseVO loadReqFunctionUsecaseById(String id) {
        return reqFunctionUsecaseAppService.loadReqFunctionUsecaseById(id);
    }
    
    /**
     * 读取 功能用例 列表
     * 
     * @param condition 查询条件
     * @return 功能用例列表
     */
    public List<ReqFunctionUsecaseVO> queryReqFunctionUsecaseList(ReqFunctionUsecaseVO condition) {
        return reqFunctionUsecaseAppService.queryReqFunctionUsecaseList(condition);
    }
    
    /**
     * 读取 功能用例 数据条数
     * 
     * @param condition 查询条件
     * @return 功能用例数据条数
     */
    public int queryReqFunctionUsecaseCount(ReqFunctionUsecaseVO condition) {
        return reqFunctionUsecaseAppService.queryReqFunctionUsecaseCount(condition);
    }
}
