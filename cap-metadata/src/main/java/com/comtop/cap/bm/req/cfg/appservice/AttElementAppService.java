/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.req.cfg.appservice;

import java.util.List;

import com.comtop.cap.bm.req.cfg.dao.AttElementDAO;
import com.comtop.cap.bm.req.cfg.model.AttElementVO;
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
public class AttElementAppService extends BaseAppService {
    
    /** 注入DAO **/
    @PetiteInject
    protected AttElementDAO attElementDAO;
    
    /**
     * 查询需求附件元素集合
     * 
     * @param attElement 需求附件元素
     * @param reqType 需求类型
     * @return 需求附件条数
     */
    public int queryAttElementCount(AttElementVO attElement, String reqType) {
        return attElementDAO.queryAttElementCount(attElement, reqType);
        
    }
    
    /**
     * 查询需求附件元素集合
     * 
     * @param attElement 需求附件元素
     * @param reqType 需求类型
     * @return 需求附件集合
     */
    public List<AttElementVO> queryAttElementList(AttElementVO attElement, String reqType) {
        return attElementDAO.queryAttElementList(attElement, reqType);
        
    }
    
    /**
     * 删除需求附件元素集合
     * 
     * @param attElementVOLst 需求附件元素集合集合
     */
    public void deleteAttElementlst(List<AttElementVO> attElementVOLst) {
        attElementDAO.deleteAttElementlst(attElementVOLst);
    }
    
    /**
     * 新增需求附件集合
     * 
     * @param attElement 需求附件元素
     * @return 需求附件元素ID
     */
    public String insertAttElement(AttElementVO attElement) {
        return attElementDAO.insertAttElement(attElement);
    }
    
    /**
     * 修改需求附件集合
     * 
     * @param attElement 需求附件元素
     * @return 需求附件元素ID
     */
    public boolean updateAttElement(AttElementVO attElement) {
        return attElementDAO.updateAttElement(attElement);
    }
    
}
