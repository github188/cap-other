/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.req.cfg.appservice;

import java.util.List;

import com.comtop.cap.bm.req.cfg.dao.CapDocAttributeDAO;
import com.comtop.cap.bm.req.cfg.model.CapDocAttributeDefVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.base.appservice.BaseAppService;

/**
 * 需求对象元素服务扩展类
 * 
 * @author 姜子豪
 * @since 1.0
 * @version 2015-9-11 姜子豪
 */
@PetiteBean
public class CapDocAttributeDefAppService extends BaseAppService {
    
    /** 注入DAO **/
    @PetiteInject
    protected CapDocAttributeDAO reqElementDAO;
    
    /**
     * 查询需求对象元素集合条数
     * 
     * @param reqElement 需求对象元素
     * @param reqType 需求类型
     * @return 需求对象元素对象条数
     */
    public int queryReqElementCount(CapDocAttributeDefVO reqElement, String reqType) {
        return reqElementDAO.queryReqElementCount(reqElement, reqType);
    }
    
    /**
     * 查询需求对象元素集合列表
     * 
     * @param reqElement 需求对象元素
     * @param reqType 需求类型
     * @return 需求对象元素对象列表
     */
    public List<CapDocAttributeDefVO> queryReqElementList(CapDocAttributeDefVO reqElement, String reqType) {
        return reqElementDAO.queryReqElementList(reqElement, reqType);
    }
    
    /**
     * 新增需求对象元素集合
     * 
     * @param reqElement 需求对象元素
     * @return 需求对象元素ID
     */
    public String insertReqElement(CapDocAttributeDefVO reqElement) {
        return reqElementDAO.insertReqElement(reqElement);
    }
    
    /**
     * 修改需求对象元素集合
     * 
     * @param reqElement 需求对象元素
     * @return 需求对象元素ID
     */
    public boolean updateReqElement(CapDocAttributeDefVO reqElement) {
        return reqElementDAO.updateReqElement(reqElement);
    }
    
    /**
     * 删除对象元素集合
     * 
     * @param reqElementLst 需求对象元素集合
     */
    public void deleteReqElementlst(List<CapDocAttributeDefVO> reqElementLst) {
        reqElementDAO.deleteReqElementlst(reqElementLst);
    }
    
    /**
     * 根据对象的URI查询对象属性定义
     *
     * @param uri 对象定义URI
     * @return 对象属性定义
     */
    public List<CapDocAttributeDefVO> queryObjectAttribute(String uri) {
        return reqElementDAO.queryObjectAttribute(uri);
    }
    
    /**
     * 查询属性定义
     *
     * @param classUri 对象定义URI
     * @param engName 属性英文名称
     * @return 属性定义
     */
    public CapDocAttributeDefVO queryReqElementByURI(String classUri, String engName) {
        CapDocAttributeDefVO objReqElementVO = new CapDocAttributeDefVO();
        // objReqElementVO.setClassUri(classUri);
        objReqElementVO.setEngName(engName);
        return reqElementDAO.queryReqElementByURI(objReqElementVO);
    }
    
}
