/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.biz;

import com.comtop.cap.doc.biz.facade.BizProcessInfoDocFacade;
import com.comtop.cap.doc.biz.facade.BizProcessNodeDocFacade;
import com.comtop.cap.doc.biz.facade.BizRelationDocFacade;
import com.comtop.cap.doc.service.DefaultDocDataImportProcessor;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 业务模型导入器
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年11月26日 lizhiyong
 */
public class BizModelImportProcessor extends DefaultDocDataImportProcessor {
    
    /** 服务代理 */
    @PetiteInject
    protected BizProcessInfoDocFacade bizProcessInfoDocFacade;
    
    /** 服务代理 */
    @PetiteInject
    protected BizProcessNodeDocFacade bizProcessNodeDocFacade;
    
    /** 服务代理 */
    @PetiteInject
    protected BizRelationDocFacade bizRelationDocFacade;
    
    @Override
    public void afterImport(boolean isSuccesss) {
        bizProcessInfoDocFacade.updateProcessDomainId();
        bizProcessNodeDocFacade.updateProcessNodeDomainId();
        bizRelationDocFacade.updateRoleaDomainId();
    }
    
    // @Override
    // protected Map<Class<? extends BaseDTO>, IIndexBuilder> getIndexBuilders() {
    // Map<Class<? extends BaseDTO>, IIndexBuilder> map = new HashMap<Class<? extends BaseDTO>, IIndexBuilder>();
    // map.put(BizFormDataItemDTO.class, AppBeanUtil.getBean(BizFormDataDocAppservice.class));
    // map.put(BizFormDTO.class, AppBeanUtil.getBean(BizFormDocAppservice.class));
    // map.put(BizFormNodeDTO.class, AppBeanUtil.getBean(BizFormNodeRelDocAppservice.class));
    // map.put(BizItemDTO.class, AppBeanUtil.getBean(BizItemsDocAppservice.class));
    // map.put(BizNodeConstraintDTO.class, AppBeanUtil.getBean(BizNodeConstraintDocAppservice.class));
    // map.put(BizObjectDataItemDTO.class, AppBeanUtil.getBean(BizObjDataItemDocAppservice.class));
    // map.put(BizObjectDTO.class, AppBeanUtil.getBean(BizObjInfoDocAppservice.class));
    // map.put(BizProcessDTO.class, AppBeanUtil.getBean(BizProcessInfoDocAppservice.class));
    // map.put(BizProcessNodeDTO.class, AppBeanUtil.getBean(BizProcessNodeDocAppservice.class));
    // map.put(BizRelationDataItemDTO.class, AppBeanUtil.getBean(BizRelDataDocAppservice.class));
    // map.put(BizRelationDTO.class, AppBeanUtil.getBean(BizRelationDocAppservice.class));
    // map.put(BizRoleDTO.class, AppBeanUtil.getBean(BizRoleDocAppservice.class));
    // map.put(BizDomainDTO.class, AppBeanUtil.getBean(BizDomainDocAppservice.class));
    // return map;
    // }
}
