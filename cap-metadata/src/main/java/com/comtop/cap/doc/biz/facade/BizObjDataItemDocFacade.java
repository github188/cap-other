/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.biz.facade;

import java.util.List;

import com.comtop.cap.doc.biz.appservice.BizObjDataItemDocAppservice;
import com.comtop.cap.doc.biz.model.BizObjectDataItemDTO;
import com.comtop.cap.document.expression.annotation.DocumentService;
import com.comtop.cap.document.word.dao.IWordDataAccessor;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 业务对象数据项文档操作门面
 * 
 * @author 李志勇
 * @since 1.0
 * @version 2015-11-10 李志勇
 */
@PetiteBean
@DocumentService(name = "BizObjectDataItem", dataType = BizObjectDataItemDTO.class)
public class BizObjDataItemDocFacade implements IWordDataAccessor<BizObjectDataItemDTO> {
    
    /** 注入AppService **/
    @PetiteInject
    protected BizObjDataItemDocAppservice bizFormDataDocAppservice;
    
    @Override
    public void updatePropertyByID(String id, String property, Object value) {
        bizFormDataDocAppservice.updatePropertyByID(id, property, value);
    }
    
    @Override
    public void saveData(List<BizObjectDataItemDTO> collection) {
        bizFormDataDocAppservice.saveData(collection);
    }
    
    @Override
    public List<BizObjectDataItemDTO> loadData(BizObjectDataItemDTO condition) {
        return bizFormDataDocAppservice.loadData(condition);
    }
}
