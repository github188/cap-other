/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.req.subfunc.appservice;
import java.util.List;

import com.comtop.cap.bm.req.subfunc.dao.ReqFunctionUsecaseDAO;
import com.comtop.cap.bm.req.subfunc.model.ReqFunctionUsecaseVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.base.appservice.BaseAppService;

/**
 * 功能用例 业务逻辑处理类
 * 
 * @author CIP
 * @since 1.0
 * @version 2015-12-22 CIP
 */
@PetiteBean
public class ReqFunctionUsecaseAppService extends BaseAppService {
   /** 注入DAO **/
    @PetiteInject
    protected ReqFunctionUsecaseDAO reqFunctionUsecaseDAO;
    
    /**
     * 新增 功能用例
     * 
     * @param reqFunctionUsecase 功能用例对象
     * @return  功能用例Id
     */
    public Object insertReqFunctionUsecase(ReqFunctionUsecaseVO reqFunctionUsecase) {
        return reqFunctionUsecaseDAO.insertReqFunctionUsecase(reqFunctionUsecase);
    }
    
    /**
     * 更新 功能用例
     * 
     * @param reqFunctionUsecase 功能用例对象
     * @return  更新成功与否
     */
    public boolean updateReqFunctionUsecase(ReqFunctionUsecaseVO reqFunctionUsecase) {
        return reqFunctionUsecaseDAO.updateReqFunctionUsecase(reqFunctionUsecase);
    }
    
   /**
     * 删除 功能用例
     * 
     * @param reqFunctionUsecase 功能用例对象
     * @return  删除成功与否
     */
    public boolean deleteReqFunctionUsecase(ReqFunctionUsecaseVO reqFunctionUsecase) {
        return reqFunctionUsecaseDAO.deleteReqFunctionUsecase(reqFunctionUsecase);
    }
    
   /**
     * 删除 功能用例集合
     * 
     * @param reqFunctionUsecaseList 功能用例对象
     * @return  删除成功与否
     */
    public boolean deleteReqFunctionUsecaseList(List<ReqFunctionUsecaseVO> reqFunctionUsecaseList) {
        if(reqFunctionUsecaseList == null){
            return true;
        }
        for(ReqFunctionUsecaseVO reqFunctionUsecase:reqFunctionUsecaseList){
            this.deleteReqFunctionUsecase(reqFunctionUsecase);
        }
        return true;
    }
    
    
    /**
     * 读取 功能用例
     * 
     * @param reqFunctionUsecase 功能用例对象
     * @return  功能用例
     */
    public ReqFunctionUsecaseVO loadReqFunctionUsecase(ReqFunctionUsecaseVO reqFunctionUsecase) {
        return reqFunctionUsecaseDAO.loadReqFunctionUsecase(reqFunctionUsecase);
    }
    
    /**
     * 根据功能用例主键读取 功能用例
     * 
     * @param id 功能用例主键
     * @return  功能用例
     */
    public ReqFunctionUsecaseVO loadReqFunctionUsecaseById(String id) {
    	return reqFunctionUsecaseDAO.loadReqFunctionUsecaseById(id);
    }
    
    /**
     * 读取 功能用例 列表
     * 
     * @param condition 查询条件
     * @return  功能用例列表
     */
    public List<ReqFunctionUsecaseVO> queryReqFunctionUsecaseList(ReqFunctionUsecaseVO condition) {
        return reqFunctionUsecaseDAO.queryReqFunctionUsecaseList(condition);
    }
    
     /**
     * 读取 功能用例 数据条数
     * 
     * @param condition 查询条件
     * @return  功能用例数据条数
     */
    public int queryReqFunctionUsecaseCount(ReqFunctionUsecaseVO condition) {
        return reqFunctionUsecaseDAO.queryReqFunctionUsecaseCount(condition);
    }
}