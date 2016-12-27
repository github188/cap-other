/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.doc.info.model.DocumentVO;
import com.comtop.cap.doc.service.DefaultDocDataImportProcessor;
import com.comtop.cap.doc.service.DocType;
import com.comtop.cap.doc.service.IDocDataProcessor;
import com.comtop.cap.doc.tmpl.facade.CapDocTemplateFacade;
import com.comtop.cap.doc.tmpl.model.CapDocTemplateVO;
import com.comtop.cap.runtime.core.AppBeanUtil;

/**
 * 文档导入服务
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2016年2月18日 lizhiyong
 */
public class DocImportService {
    
    /** 文档模板Facade */
    private transient final CapDocTemplateFacade capDocTemplateFacade = AppBeanUtil.getBean(CapDocTemplateFacade.class);
    
    /**
     * 导入文档
     *
     * @param docProcessParams 导入 参数
     */
    public void importDoc(final DocProcessParams docProcessParams) {
        // 加载并设置文档模板信息
        DocumentVO document = docProcessParams.getDocument();
        CapDocTemplateVO capDocTemplateVO = capDocTemplateFacade.loadCapDocTemplateById(document.getDocTmplId());
        docProcessParams.setDocTemplateVO(capDocTemplateVO);
        if (StringUtils.isBlank(document.getDocType())) {
            document.setDocType(capDocTemplateVO.getType());
        }
        
        // 获得当前文档类型下的文档处理器
        DocType docType = DocType.getDocType(document.getDocType());
        Class<? extends IDocDataProcessor> clazz = docType.getDocDataProcessor();
        if (clazz == null) {
            clazz = DefaultDocDataImportProcessor.class;
        }
        // 初始化文档处理器
        IDocDataProcessor dataProcessor = AppBeanUtil.getBean(clazz);
        // 处理
        dataProcessor.process(docProcessParams);
    }
}
