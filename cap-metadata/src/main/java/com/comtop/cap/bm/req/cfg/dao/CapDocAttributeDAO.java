/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.req.cfg.dao;

import java.util.List;

import com.comtop.cap.bm.req.cfg.model.CapDocAttributeDefVO;
import com.comtop.cap.bm.req.cfg.util.ReqConstants;
import com.comtop.cip.jodd.jtx.JtxPropagationBehavior;
import com.comtop.cip.jodd.jtx.meta.Transaction;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.top.core.base.dao.CoreDAO;

/**
 * 需求对象元素扩展DAO
 * 
 * @author 姜子豪
 * @since 1.0
 * @version 2015-9-11 姜子豪
 */
@PetiteBean
public class CapDocAttributeDAO extends CoreDAO<CapDocAttributeDefVO> {
    
    /**
     * 查询需求对象元素集合条数
     * 
     * @param reqElement 需求对象元素
     * @param reqType 需求类型
     * @return 需求对象元素对象条数
     */
    public int queryReqElementCount(CapDocAttributeDefVO reqElement, String reqType) {
        String str = ReqConstants.REQ_MODEL + ".queryReqElementCount";
        return ((Integer) super.selectOne(str, reqType)).intValue();
    }
    
    /**
     * 查询需求对象元素集合列表
     * 
     * @param reqElement 需求对象元素
     * @param reqType 需求类型
     * @return 需求对象元素对象列表
     */
    public List<CapDocAttributeDefVO> queryReqElementList(CapDocAttributeDefVO reqElement, String reqType) {
        String str = ReqConstants.REQ_MODEL + ".queryReqElementList";
        return super.queryList(str, reqType, reqElement.getPageNo(), reqElement.getPageSize());
    }
    
    /**
     * 新增需求对象元素集合
     * 
     * @param reqElement 需求对象元素
     * @return 需求对象元素ID
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public String insertReqElement(CapDocAttributeDefVO reqElement) {
        String str = (String) insert(reqElement);
        return str;
    }
    
    /**
     * 修改需求对象元素集合
     * 
     * @param reqElement 需求对象元素
     * @return 需求对象元素ID
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean updateReqElement(CapDocAttributeDefVO reqElement) {
        return update(reqElement);
    }
    
    /**
     * 删除对象元素集合
     * 
     * @param reqElementLst 需求对象元素集合
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public void deleteReqElementlst(List<CapDocAttributeDefVO> reqElementLst) {
        super.delete(reqElementLst);
    }
    
    /**
     * 根据对象的URI查询对象属性定义
     *
     * @param strUri 对象定义URI
     * @return 对象属性定义
     */
    public List<CapDocAttributeDefVO> queryObjectAttribute(String strUri) {
        return this.queryList("com.comtop.cap.bm.req.cfg.model.queryObjectAttribute", strUri);
    }
    
    /**
     * 查询属性定义
     *
     * @param objReqElementVO 查询条件
     * @return 属性定义
     */
    public CapDocAttributeDefVO queryReqElementByURI(CapDocAttributeDefVO objReqElementVO) {
        List<CapDocAttributeDefVO> lstReqElement = this.queryList("com.comtop.cap.bm.req.cfg.model.queryReqElementByURI",
            objReqElementVO);
        return lstReqElement.get(0);
    }
    
}
