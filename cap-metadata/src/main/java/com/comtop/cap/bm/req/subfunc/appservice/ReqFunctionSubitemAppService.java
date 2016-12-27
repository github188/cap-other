/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.req.subfunc.appservice;

import java.util.List;

import com.comtop.cap.base.MDBaseAppservice;
import com.comtop.cap.base.MDBaseDAO;
import com.comtop.cap.bm.req.subfunc.dao.ReqFunctionSubitemDAO;
import com.comtop.cap.bm.req.subfunc.model.ReqFunctionSubitemVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 功能子项,建在功能项下面服务扩展类
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-11-25 CAP
 */
@PetiteBean
public class ReqFunctionSubitemAppService extends MDBaseAppservice<ReqFunctionSubitemVO> {
    
    /** 注入DAO **/
    @PetiteInject
    protected ReqFunctionSubitemDAO reqFunctionSubitemDAO;
    
    /**
     * 新增 功能子项,建在功能项下面
     * 
     * @param reqFunctionSubitem 功能子项,建在功能项下面对象
     * @return 功能子项,建在功能项下面Id
     */
    public Object insertReqFunctionSubitem(ReqFunctionSubitemVO reqFunctionSubitem) {
        return reqFunctionSubitemDAO.insertReqFunctionSubitem(reqFunctionSubitem);
    }
    
    /**
     * 更新 功能子项,建在功能项下面
     * 
     * @param reqFunctionSubitem 功能子项,建在功能项下面对象
     * @return 更新成功与否
     */
    public boolean updateReqFunctionSubitem(ReqFunctionSubitemVO reqFunctionSubitem) {
        return reqFunctionSubitemDAO.updateReqFunctionSubitem(reqFunctionSubitem);
    }
    
    /**
     * 删除 功能子项,建在功能项下面
     * 
     * @param reqFunctionSubitem 功能子项,建在功能项下面对象
     * @return 删除成功与否
     */
    public boolean deleteReqFunctionSubitem(ReqFunctionSubitemVO reqFunctionSubitem) {
        return reqFunctionSubitemDAO.deleteReqFunctionSubitem(reqFunctionSubitem);
    }
    
    /**
     * 删除 功能子项,建在功能项下面集合
     * 
     * @param reqFunctionSubitemList 功能子项,建在功能项下面对象
     * @return 删除成功与否
     */
    public boolean deleteReqFunctionSubitemList(List<ReqFunctionSubitemVO> reqFunctionSubitemList) {
        if (reqFunctionSubitemList == null) {
            return true;
        }
        for (ReqFunctionSubitemVO reqFunctionSubitem : reqFunctionSubitemList) {
            this.deleteReqFunctionSubitem(reqFunctionSubitem);
        }
        return true;
    }
    
    /**
     * 读取 功能子项,建在功能项下面
     * 
     * @param reqFunctionSubitem 功能子项,建在功能项下面对象
     * @return 功能子项,建在功能项下面
     */
    public ReqFunctionSubitemVO loadReqFunctionSubitem(ReqFunctionSubitemVO reqFunctionSubitem) {
        return reqFunctionSubitemDAO.loadReqFunctionSubitem(reqFunctionSubitem);
    }
    
    /**
     * 根据功能子项,建在功能项下面主键读取 功能子项,建在功能项下面
     * 
     * @param id 功能子项,建在功能项下面主键
     * @return 功能子项,建在功能项下面
     */
    public ReqFunctionSubitemVO loadReqFunctionSubitemById(String id) {
        return reqFunctionSubitemDAO.loadReqFunctionSubitemById(id);
    }
    
    /**
     * 读取 功能子项,建在功能项下面 列表
     * 
     * @param condition 查询条件
     * @return 功能子项,建在功能项下面列表
     */
    public List<ReqFunctionSubitemVO> queryReqFunctionSubitemList(ReqFunctionSubitemVO condition) {
        return reqFunctionSubitemDAO.queryReqFunctionSubitemList(condition);
    }
    
    /**
     * 读取 功能子项,建在功能项下面 数据条数
     * 
     * @param condition 查询条件
     * @return 功能子项,建在功能项下面数据条数
     */
    public int queryReqFunctionSubitemCount(ReqFunctionSubitemVO condition) {
        return reqFunctionSubitemDAO.queryReqFunctionSubitemCount(condition);
    }
    
    /**
     * 
     * @see com.comtop.cap.base.MDBaseAppservice#getDAO()
     */
    @Override
    protected MDBaseDAO<ReqFunctionSubitemVO> getDAO() {
        return reqFunctionSubitemDAO;
    }
    
    /**
     * 查询功能项及功能子项
     *
     * @param condition 查询条件
     * @return 功能项以及功能子项
     */
    public List<ReqFunctionSubitemVO> querySubitemsWithItem(ReqFunctionSubitemVO condition) {
        return reqFunctionSubitemDAO.querySubitemsWithItem(condition);
    }
    
    /**
     * 更新 排序号
     * 
     * @param reqFunctionSubitemVO 功能子项
     *
     */
    public void updateSortNoById(ReqFunctionSubitemVO reqFunctionSubitemVO) {
        reqFunctionSubitemDAO.updateSortNoById(reqFunctionSubitemVO);
    }
    
    /**
     * 查询对应业务域下documentId为null的功能子项列表，也就是在CAP新建而非文档导入生成的功能子项
     * @param domainId	域id
     * @return 对应业务域下documentId为null的功能子项列表
     */
    public List<ReqFunctionSubitemVO> queryNoDoumentSubitemVO(String domainId) {
    	ReqFunctionSubitemVO condition = new ReqFunctionSubitemVO();
    	condition.setDomainId(domainId);
    	return reqFunctionSubitemDAO.queryList("com.comtop.cap.bm.req.subfunc.model.queryNoDocumentSubitemList", condition);
    }
}
