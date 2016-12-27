/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.req.subfunc.appservice;
import java.util.List;

import com.comtop.cap.bm.req.subfunc.dao.ReqUsecaseRelFormDAO;
import com.comtop.cap.bm.req.subfunc.model.ReqUsecaseRelFormVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.base.appservice.BaseAppService;

/**
 * 功能用例关联业务表单 业务逻辑处理类
 * 
 * @author CIP
 * @since 1.0
 * @version 2015-12-22 CIP
 */
@PetiteBean
public class ReqUsecaseRelFormAppService extends BaseAppService {
   /** 注入DAO **/
    @PetiteInject
    protected ReqUsecaseRelFormDAO reqUsecaseRelFormDAO;
    
    /**
     * 新增 功能用例关联业务表单
     * 
     * @param reqUsecaseRelForm 功能用例关联业务表单对象
     * @return  功能用例关联业务表单Id
     */
    public Object insertReqUsecaseRelForm(ReqUsecaseRelFormVO reqUsecaseRelForm) {
        return reqUsecaseRelFormDAO.insertReqUsecaseRelForm(reqUsecaseRelForm);
    }
    
    /**
     * 更新 功能用例关联业务表单
     * 
     * @param reqUsecaseRelForm 功能用例关联业务表单对象
     * @return  更新成功与否
     */
    public boolean updateReqUsecaseRelForm(ReqUsecaseRelFormVO reqUsecaseRelForm) {
        return reqUsecaseRelFormDAO.updateReqUsecaseRelForm(reqUsecaseRelForm);
    }
    
   /**
     * 删除 功能用例关联业务表单
     * 
     * @param reqUsecaseRelForm 功能用例关联业务表单对象
     * @return  删除成功与否
     */
    public boolean deleteReqUsecaseRelForm(ReqUsecaseRelFormVO reqUsecaseRelForm) {
        return reqUsecaseRelFormDAO.deleteReqUsecaseRelForm(reqUsecaseRelForm);
    }
    
   /**
     * 删除 功能用例关联业务表单集合
     * 
     * @param reqUsecaseRelFormList 功能用例关联业务表单对象
     * @return  删除成功与否
     */
    public boolean deleteReqUsecaseRelFormList(List<ReqUsecaseRelFormVO> reqUsecaseRelFormList) {
        if(reqUsecaseRelFormList == null){
            return true;
        }
        for(ReqUsecaseRelFormVO reqUsecaseRelForm:reqUsecaseRelFormList){
            this.deleteReqUsecaseRelForm(reqUsecaseRelForm);
        }
        return true;
    }
    
    
    /**
     * 读取 功能用例关联业务表单
     * 
     * @param reqUsecaseRelForm 功能用例关联业务表单对象
     * @return  功能用例关联业务表单
     */
    public ReqUsecaseRelFormVO loadReqUsecaseRelForm(ReqUsecaseRelFormVO reqUsecaseRelForm) {
        return reqUsecaseRelFormDAO.loadReqUsecaseRelForm(reqUsecaseRelForm);
    }
    
    /**
     * 根据功能用例关联业务表单主键读取 功能用例关联业务表单
     * 
     * @param id 功能用例关联业务表单主键
     * @return  功能用例关联业务表单
     */
    public ReqUsecaseRelFormVO loadReqUsecaseRelFormById(String id) {
    	return reqUsecaseRelFormDAO.loadReqUsecaseRelFormById(id);
    }
    
    /**
     * 读取 功能用例关联业务表单 列表
     * 
     * @param condition 查询条件
     * @return  功能用例关联业务表单列表
     */
    public List<ReqUsecaseRelFormVO> queryReqUsecaseRelFormList(ReqUsecaseRelFormVO condition) {
        return reqUsecaseRelFormDAO.queryReqUsecaseRelFormList(condition);
    }
    
     /**
     * 读取 功能用例关联业务表单 数据条数
     * 
     * @param condition 查询条件
     * @return  功能用例关联业务表单数据条数
     */
    public int queryReqUsecaseRelFormCount(ReqUsecaseRelFormVO condition) {
        return reqUsecaseRelFormDAO.queryReqUsecaseRelFormCount(condition);
    }

    /**
     * 读取功能用例关联业务表单
     * 
     * @param subitemId 功能用例ID
     * @return 功能用例关联业务表单
     */
	public ReqUsecaseRelFormVO queryReqUsecaseRelFormBysubitemId(
			String subitemId) {
		return reqUsecaseRelFormDAO.queryReqUsecaseRelFormBysubitemId(subitemId);
	}

	/**
     * 删除原有的功能用例关联业务表单
     * 
     * @param subitemId 功能用例ID
     */
	public void deleteReqUsecaseRelFormByUsecaseId(String subitemId) {
		reqUsecaseRelFormDAO.deleteReqUsecaseRelFormByUsecaseId(subitemId);
		
	}
    
}