/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cip.graph.uml.facade;

import java.io.File;

import com.comtop.cip.graph.entity.model.GraphModuleVO;
import com.comtop.cip.graph.uml.appservice.GraphUmlAppService;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.base.facade.BaseFacade;

/**
 * 模型门面
 * 
 * @author 陈志伟
 * @since 1.0
 * @version 2015-7-17 陈志伟
 */
@PetiteBean
public class GraphUmlFacadeImpl extends BaseFacade implements IGraphUmlFacade {
    
    /** 实体服务 */
    @PetiteInject
    protected GraphUmlAppService graphUmlAppService;
    
    /**
     * 查询实体关系
     * 
     * @see com.comtop.cip.graph.entity.facade.IGraphFacade#queryGraphEntityByPackageId(java.lang.String)
     */
    @Override
    public GraphModuleVO queryGraphUmlByPackageId(String packageId) {
        return graphUmlAppService.queryGraphUmlByPackageId(packageId);
    }
    
    /**
     * 
     * @see com.comtop.cip.graph.uml.facade.IGraphUmlFacade#exportXMIFile(java.io.File,java.lang.String)
     */
    @Override
    public void exportXMIFile(File file, String moduldId) {
        graphUmlAppService.exportXMIFile(file, moduldId);
    }
    
}
