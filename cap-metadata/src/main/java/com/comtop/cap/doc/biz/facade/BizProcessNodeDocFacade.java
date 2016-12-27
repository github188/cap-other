/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.biz.facade;

import java.util.List;

import com.comtop.cap.doc.biz.appservice.BizProcessNodeDocAppservice;
import com.comtop.cap.doc.biz.model.BizProcessNodeDTO;
import com.comtop.cap.document.expression.annotation.DocumentService;
import com.comtop.cap.document.word.dao.IWordDataAccessor;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 业务流程节点 文档操作 门面
 * 
 * @author 李志勇
 * @since 1.0
 * @version 2015-11-16 李志勇
 */
@PetiteBean
@DocumentService(name = "BizProcessNode", dataType = BizProcessNodeDTO.class)
public class BizProcessNodeDocFacade implements IWordDataAccessor<BizProcessNodeDTO> {
    
    /** 注入AppService **/
    @PetiteInject
    protected BizProcessNodeDocAppservice bizProcessNodeDocAppservice;
    
    @Override
    public void updatePropertyByID(String id, String property, Object value) {
        bizProcessNodeDocAppservice.updatePropertyByID(id, property, value);
    }
    
    @Override
    public void saveData(List<BizProcessNodeDTO> collection) {
        bizProcessNodeDocAppservice.saveData(collection);
    }
    
    @Override
    public List<BizProcessNodeDTO> loadData(BizProcessNodeDTO condition) {
        return bizProcessNodeDocAppservice.loadData(condition);
    }
    
    /**
     * 更新流程节点的业务域
     *
     */
    public void updateProcessNodeDomainId() {
        bizProcessNodeDocAppservice.updateProcessNodeDomainId();
    }
}
