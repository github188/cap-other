/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.biz.facade;

import java.util.List;

import com.comtop.cap.doc.biz.appservice.BizRelationDocAppservice;
import com.comtop.cap.doc.biz.model.BizRelationDTO;
import com.comtop.cap.document.expression.annotation.DocumentService;
import com.comtop.cap.document.word.dao.IWordDataAccessor;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 业务关联文档操作门面。对于业务关联的导入，只处理配置具体的流程节点下的关联数。其它数据只是汇总处理。咨询过生产陶伟伟确认。
 * 
 * @author 李志勇
 * @since 1.0
 * @version 2015-11-16 李志勇
 */
@PetiteBean
@DocumentService(name = "BizRelation", dataType = BizRelationDTO.class)
public class BizRelationDocFacade implements IWordDataAccessor<BizRelationDTO> {
    
    /** 注入AppService **/
    @PetiteInject
    protected BizRelationDocAppservice bizRelationDocAppservice;
    
    @Override
    public void updatePropertyByID(String id, String property, Object value) {
        bizRelationDocAppservice.updatePropertyByID(id, property, value);
    }
    
    @Override
    public void saveData(List<BizRelationDTO> collection) {
        bizRelationDocAppservice.saveData(collection);
    }
    
    @Override
    public List<BizRelationDTO> loadData(BizRelationDTO condition) {
        return bizRelationDocAppservice.loadData(condition);
    }
    
    /**
     * 更新roleadomainId
     *
     */
    public void updateRoleaDomainId() {
        bizRelationDocAppservice.updateRoleaDomainId();
    }
}
