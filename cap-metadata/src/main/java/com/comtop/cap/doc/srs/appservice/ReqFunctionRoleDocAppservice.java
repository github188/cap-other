/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.srs.appservice;

import java.util.List;

import com.comtop.cap.base.MDBaseAppservice;
import com.comtop.cap.bm.req.func.model.ReqFunctionItemVO;
import com.comtop.cap.doc.service.AbstractWordDataAccessor;
import com.comtop.cap.doc.srs.model.ReqFunctionRoleDTO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 业务功能以及业务角色关联
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年12月28日 lizhongwen
 */
@PetiteBean
public class ReqFunctionRoleDocAppservice extends AbstractWordDataAccessor<ReqFunctionItemVO, ReqFunctionRoleDTO> {
    
    /** 注入AppService **/
    @PetiteInject
    protected ReqFunctionItemDocAppservice reqFunctionItemDocAppservice;
    
    /**
     * 
     * @see com.comtop.cap.document.word.dao.IWordDataAccessor#loadData(java.lang.Object)
     */
    @Override
    public List<ReqFunctionRoleDTO> loadData(ReqFunctionRoleDTO condition) {
        return reqFunctionItemDocAppservice.queryReqFunctionItemWithRole(condition);
    }
    
    /**
     * 保存业务数据
     *
     * @param collection 业务数据集
     * @see com.comtop.cap.doc.service.AbstractWordDataAccessor#saveBizData(java.util.List)
     */
    @Override
    protected void saveBizData(List<ReqFunctionRoleDTO> collection) {
        return;
    }
    
    /**
     * 获得appservice
     *
     * @return appservice
     * @see com.comtop.cap.doc.service.AbstractWordDataAccessor#getBaseAppservice()
     */
    @Override
    protected MDBaseAppservice<ReqFunctionItemVO> getBaseAppservice() {
        return null;
    }
    
    /**
     * 将DTO转换为VO
     *
     * @param data 数据集
     * @return VO
     * @see com.comtop.cap.doc.service.AbstractWordDataAccessor#dto2VO(com.comtop.cap.document.word.docmodel.data.BaseDTO)
     */
    @Override
    protected ReqFunctionItemVO dto2VO(ReqFunctionRoleDTO data) {
        return null;
    }
    
    /**
     * VO转换为DTO .一般情况下，子类应该重写本方法
     *
     * @param vo vo
     * @return DTO
     * @see com.comtop.cap.doc.service.AbstractWordDataAccessor#vo2DTO(com.comtop.top.core.base.model.CoreVO)
     */
    @Override
    protected ReqFunctionRoleDTO vo2DTO(ReqFunctionItemVO vo) {
        return null;
    }
    
}
