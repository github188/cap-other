/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.req.cfg.dao;

import java.util.List;

import com.comtop.cap.bm.req.cfg.model.CapDocClassDefVO;
import com.comtop.cap.bm.req.cfg.util.ReqConstants;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.runtime.base.dao.BaseDAO;

/**
 * 需求对象信息表(系统初始数据，不允许修改)扩展DAO
 * 
 * @author 姜子豪
 * @since 1.0
 * @version 2015-9-11 姜子豪
 */
@PetiteBean
public class CapDocClassDefDAO extends BaseDAO<CapDocClassDefVO> {
    
    /**
     * 查询需求集合
     * 
     * @return 需求集合
     */
    public List<CapDocClassDefVO> queryReqList() {
        String T = ReqConstants.REQ_MODEL + ".queryReqList";
        return super.queryList(T, new CapDocClassDefVO());
    }
}
