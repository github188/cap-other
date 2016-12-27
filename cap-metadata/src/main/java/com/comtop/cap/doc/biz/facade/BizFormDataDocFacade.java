/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.biz.facade;

import java.util.List;

import com.comtop.cap.doc.biz.appservice.BizFormDataDocAppservice;
import com.comtop.cap.doc.biz.model.BizFormDataItemDTO;
import com.comtop.cap.document.expression.annotation.DocumentService;
import com.comtop.cap.document.word.dao.IWordDataAccessor;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 业务表单数据项 文档操作门面
 * 
 * @author 李志勇
 * @since 1.0
 * @version 2015-11-11 李志勇
 */
@PetiteBean
@DocumentService(name = "BizFormDataItem", dataType = BizFormDataItemDTO.class)
public class BizFormDataDocFacade implements IWordDataAccessor<BizFormDataItemDTO> {
    
    /** 注入AppService **/
    @PetiteInject
    protected BizFormDataDocAppservice bizFormDataDocAppservice;
    
    @Override
    public void updatePropertyByID(String id, String property, Object value) {
        bizFormDataDocAppservice.updatePropertyByID(id, property, value);
    }
    
    @Override
    public void saveData(List<BizFormDataItemDTO> collection) {
        bizFormDataDocAppservice.saveData(collection);
    }
    
    @Override
    public List<BizFormDataItemDTO> loadData(BizFormDataItemDTO condition) {
        return bizFormDataDocAppservice.loadData(condition);
    }
}
