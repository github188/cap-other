/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.biz.facade;

import java.util.List;
import java.util.Map;

import com.comtop.cap.doc.biz.appservice.BizRoleDocAppservice;
import com.comtop.cap.doc.biz.model.BizRoleDTO;
import com.comtop.cap.doc.service.IIndexBuilder;
import com.comtop.cap.document.expression.annotation.DocumentService;
import com.comtop.cap.document.word.dao.IWordDataAccessor;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 业务角色文档操作门面
 * 
 * @author 李志勇
 * @since 1.0
 * @version 2015-11-11 李志勇
 */
@PetiteBean
@DocumentService(name = "BizRole", dataType = BizRoleDTO.class)
public class BizRoleDocFacade implements IWordDataAccessor<BizRoleDTO>, IIndexBuilder {
    
    /** 注入AppService **/
    @PetiteInject
    protected BizRoleDocAppservice bizRoleDocAppservice;
    
    @Override
    public void updatePropertyByID(String id, String property, Object value) {
        bizRoleDocAppservice.updatePropertyByID(id, property, value);
    }
    
    @Override
    public void saveData(List<BizRoleDTO> collection) {
        bizRoleDocAppservice.saveData(collection);
    }
    
    @Override
    public List<BizRoleDTO> loadData(BizRoleDTO condition) {
        return bizRoleDocAppservice.loadData(condition);
    }
    
    @Override
    public Map<String, String> fixIndexMap(String packageId) {
        return bizRoleDocAppservice.fixIndexMap(packageId);
    }
}
