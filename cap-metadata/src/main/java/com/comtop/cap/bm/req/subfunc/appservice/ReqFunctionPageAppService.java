/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.req.subfunc.appservice;

import java.util.List;

import com.comtop.cap.bm.req.subfunc.dao.ReqFunctionPageDAO;
import com.comtop.cap.bm.req.subfunc.model.ReqPageVO;
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
public class ReqFunctionPageAppService extends BaseAppService {
    
    /** 注入AppService **/
    @PetiteInject
    protected ReqFunctionPageDAO reqFunctionPageDAO;
    
    /**
     * 新增界面原型基本信息
     * 
     * @param reqFunctionPage 界面原型基本信息
     * @return id
     */
    public String insertReqFunctionPage(ReqPageVO reqFunctionPage) {
        return reqFunctionPageDAO.insertReqFunctionPage(reqFunctionPage);
    }
    
    /**
     * 修改界面原型基本信息
     * 
     * @param reqFunctionPage 界面原型基本信息
     */
    public void updateReqFunctionPage(ReqPageVO reqFunctionPage) {
        reqFunctionPageDAO.updateReqFunctionPage(reqFunctionPage);
    }
    
    /**
     * 根据界面原型的ID集合查询对应的界面原型VO集合
     * 
     * @param pageIds 界面原型的ID集合，为空是返回空集合
     * @return 符合条件的界面原型VO集合
     */
    public List<ReqPageVO> queryReqPageListByIds(List<String> pageIds) {
        return reqFunctionPageDAO.queryReqPageListByIds(pageIds);
    }
    
    /**
     * 
     * 获取界面原型数据条数（分页）
     * 
     * @param reqFunctionPage 查询条件
     * @return 数据条数
     */
    public int queryReqPageCount(ReqPageVO reqFunctionPage) {
        return reqFunctionPageDAO.queryReqPageCount(reqFunctionPage);
    }
    
    /**
     * 
     * 获取界面原型列表（分页）
     *
     * @param reqFunctionPage 查询条件
     * @return 界面原型列表
     */
    public List<ReqPageVO> queryReqPageList(ReqPageVO reqFunctionPage) {
        return reqFunctionPageDAO.queryReqPageList(reqFunctionPage);
    }
    
    /**
     * 
     * 删除界面原型
     * 
     * @param reqFunctionPageList 界面原型
     */
    public void deleteReqPageList(List<ReqPageVO> reqFunctionPageList) {
        reqFunctionPageDAO.deleteReqPageList(reqFunctionPageList);
    }
    
    /**
     * 通过功能子项删除界面原型
     * 
     * @param subitemId 功能子项id
     */
    public void deleteReqPageBySubitemId(String subitemId) {
        reqFunctionPageDAO.deleteReqPageBySubitemId(subitemId);
    }
    
    /**
     * 
     * 批量保存界面原型
     * 
     * @param pageList 界面原型list
     */
    public void updatePageList(List<ReqPageVO> pageList) {
        reqFunctionPageDAO.updatePageList(pageList);
    }
    
    /**
     * 根据子项ID查询所有界面
     *
     * @param subitemId 子项ID
     * @return 所有界面
     */
    public List<ReqPageVO> queryReqPageBySubitemId(String subitemId) {
        return reqFunctionPageDAO.queryList("com.comtop.cap.bm.req.subfunc.model.queryReqPageBySubitemId", subitemId);
    }
    
}
