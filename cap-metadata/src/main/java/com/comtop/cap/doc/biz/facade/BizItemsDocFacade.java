/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.biz.facade;

import java.util.List;

import com.comtop.cap.doc.biz.appservice.BizItemsDocAppservice;
import com.comtop.cap.doc.biz.model.BizItemDTO;
import com.comtop.cap.document.expression.annotation.DocumentService;
import com.comtop.cap.document.word.dao.IWordDataAccessor;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 业务事项 文档操作 门面
 * 
 * @author 李志勇
 * @since 1.0
 * @version 2015-11-11 李志勇
 */
@PetiteBean
@DocumentService(name = "BizItem", dataType = BizItemDTO.class)
public class BizItemsDocFacade implements IWordDataAccessor<BizItemDTO> {
    
    /** 注入AppService **/
    @PetiteInject
    protected BizItemsDocAppservice bizItemsDocAppservice;
    
    @Override
    public void updatePropertyByID(String id, String property, Object value) {
        bizItemsDocAppservice.updatePropertyByID(id, property, value);
    }
    
    @Override
    public void saveData(List<BizItemDTO> collection) {
        bizItemsDocAppservice.saveData(collection);
    }
    
    @Override
    public List<BizItemDTO> loadData(BizItemDTO condition) {
        return bizItemsDocAppservice.loadData(condition);
    }
}
