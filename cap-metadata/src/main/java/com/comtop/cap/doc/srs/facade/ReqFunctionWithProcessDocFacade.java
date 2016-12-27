/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.srs.facade;

import java.util.List;

import com.comtop.cap.doc.srs.appservice.ReqFunctionWithProcessDocAppservice;
import com.comtop.cap.doc.srs.model.ReqFunctionWithProcessDTO;
import com.comtop.cap.document.expression.annotation.DocumentService;
import com.comtop.cap.document.word.dao.IWordDataAccessor;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 业务功能项关联业务流程
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年12月28日 lizhongwen
 */
@PetiteBean
@DocumentService(name = "ReqFunctionWithProcess", dataType = ReqFunctionWithProcessDTO.class)
public class ReqFunctionWithProcessDocFacade implements IWordDataAccessor<ReqFunctionWithProcessDTO> {
    
    /** 注入AppService **/
    @PetiteInject
    protected ReqFunctionWithProcessDocAppservice reqFunctionWithProcessDocAppservice;
    
    /**
     * 根据id和属性名更新属性
     *
     * @param id 对象id
     * @param property 属性名
     * @param value 值
     */
    @Override
    public void updatePropertyByID(String id, String property, Object value) {
        reqFunctionWithProcessDocAppservice.updatePropertyByID(id, property, value);
    }
    
    /**
     * 保存业务数据
     *
     * @param collection 业务数据集
     * 
     * @see com.comtop.cap.document.word.dao.IWordDataAccessor#saveData(java.util.List)
     */
    @Override
    public void saveData(List<ReqFunctionWithProcessDTO> collection) {
        reqFunctionWithProcessDocAppservice.saveData(collection);
    }
    
    /**
     * 据据条件加载数据
     *
     * @param condition 条件集
     * @return 加载的数据结构 List 表示对象集合
     */
    @Override
    public List<ReqFunctionWithProcessDTO> loadData(ReqFunctionWithProcessDTO condition) {
        return reqFunctionWithProcessDocAppservice.loadData(condition);
    }
}
