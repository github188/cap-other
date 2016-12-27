/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.service;

import com.comtop.cap.doc.DocProcessParams;
import com.comtop.cap.doc.info.model.DocumentVO;

/**
 * 缺省的数据处理器
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2016年1月29日 lizhiyong
 */
public class DefaultDocDataImportProcessor extends DocDataImportProcessor {
    
    @Override
    protected void beforeImport(DocProcessParams params) {
        DocumentVO documentVO = params.getDocument();
        addGlobalVar("$domainId", documentVO.getBizDomain());
        addGlobalVar("$documentId", documentVO.getId());
    }
    
    @Override
    protected void afterImport(boolean isSuccesss) {
        // 无须处理 子类按需要实现
    }
    
}
