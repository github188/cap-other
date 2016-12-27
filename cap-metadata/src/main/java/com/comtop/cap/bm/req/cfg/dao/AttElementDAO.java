/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.req.cfg.dao;

import java.util.List;

import com.comtop.cap.bm.req.cfg.model.AttElementVO;
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
public class AttElementDAO extends CoreDAO<AttElementVO> {
    
    //
    /**
     * 查询需求附件元素集合
     * 
     * @param attElement 需求附件元素
     * @param reqType 需求类型
     * @return 需求附件条数
     */
    public int queryAttElementCount(AttElementVO attElement, String reqType) {
        String T = ReqConstants.REQ_MODEL + ".queryAttElementCount";
        return ((Integer) super.selectOne(T, reqType)).intValue();
    }
    
    /**
     * 查询需求附件元素集合
     * 
     * @param attElement 需求附件元素
     * @param reqType 需求类型
     * @return 需求附件集合
     */
    public List<AttElementVO> queryAttElementList(AttElementVO attElement, String reqType) {
        String T = ReqConstants.REQ_MODEL + ".queryAttElementList";
        return super.queryList(T, reqType, attElement.getPageNo(), attElement.getPageSize());
    }
    
    /**
     * 新增需求附件集合
     * 
     * @param attElement 需求附件元素
     * @return 需求附件元素ID
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public String insertAttElement(AttElementVO attElement) {
        String result = (String) insert(attElement);
        return result;
    }
    
    /**
     * 修改需求附件集合
     * 
     * @param attElement 需求附件元素
     * @return 需求附件元素ID
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public boolean updateAttElement(AttElementVO attElement) {
        return update(attElement);
    }
    
    /**
     * 删除需求附件元素集合
     * 
     * @param attElementVOLst 需求附件元素集合
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public void deleteAttElementlst(List<AttElementVO> attElementVOLst) {
        super.delete(attElementVOLst);
    }
}
