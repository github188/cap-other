/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.biz.facade;

import java.util.List;

import com.comtop.cap.doc.biz.appservice.BizFormNodeRelDocAppservice;
import com.comtop.cap.doc.biz.model.BizFormNodeDTO;
import com.comtop.cap.document.expression.annotation.DocumentService;
import com.comtop.cap.document.word.dao.IWordDataAccessor;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 业务表单和业务流程节点关系 文档操作 门面
 * 
 * @author 李志勇
 * @since 1.0
 * @version 2015-11-24 李志勇
 */
@PetiteBean
@DocumentService(name = "BizFormNode", dataType = BizFormNodeDTO.class)
public class BizFormNodeRelDocFacade implements IWordDataAccessor<BizFormNodeDTO> {
    
    /** 注入AppService **/
    @PetiteInject
    protected BizFormNodeRelDocAppservice bizFormNodeRelDocAppservice;
    
    @Override
    public void updatePropertyByID(String id, String property, Object value) {
        bizFormNodeRelDocAppservice.updatePropertyByID(id, property, value);
    }
    
    @Override
    public void saveData(List<BizFormNodeDTO> collection) {
        bizFormNodeRelDocAppservice.saveData(collection);
    }
    
    @Override
    public List<BizFormNodeDTO> loadData(BizFormNodeDTO condition) {
        return bizFormNodeRelDocAppservice.loadData(condition);
    }
}
