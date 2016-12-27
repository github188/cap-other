/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.hld.facade;

import java.util.List;

import com.comtop.cap.doc.hld.model.SystemIntegrationDTO;
import com.comtop.cap.doc.service.AbstractExportFacade;
import com.comtop.cap.document.expression.annotation.DocumentService;

/**
 * FIXME 类注释信息
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年12月30日 lizhiyong
 */
@DocumentService(name = "SystemIntegration", dataType = SystemIntegrationDTO.class)
public class SystemIntegrationFacede extends AbstractExportFacade<SystemIntegrationDTO> {
    
    @Override
    public List<SystemIntegrationDTO> loadData(SystemIntegrationDTO condition) {
        // TODO 自动生成方法存根注释，方法实现时请删除此注释
        return null;
    }
    
}
