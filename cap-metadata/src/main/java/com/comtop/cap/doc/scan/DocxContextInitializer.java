/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.scan;

import javax.servlet.ServletContext;

import com.comtop.cap.component.loader.config.LoaderConfigFactory;
import com.comtop.cap.document.word.expression.ContainerInitializer;
import com.comtop.cap.ptc.preferencesconfig.TopConfig4FtpConfigReader;
import com.comtop.cap.runtime.core.InitBean;

/**
 * Docx文档初始化
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年11月26日 lizhiyong
 */
@InitBean
public class DocxContextInitializer {
    
    /**
     * 初始化
     * 
     * @param context web上下文
     */
    public void init(ServletContext context) {
        String[] objScanServiceRegex = { "com.comtop.cap.**.service.*Service", "com.comtop.cap.**.facade.*Facade" };
        String[] objScanFuncRegex = { "com.comtop.cap.document.expression.util.*Utils", "com.comtop.cap.document.util.*",
            "com.comtop.cap.doc.util.*" };
        ContainerAutoScanInitializer objHelper = new ContainerAutoScanInitializer(objScanServiceRegex, objScanFuncRegex);
        context.setAttribute(ContainerInitializer.class.getName(), objHelper);
        LoaderConfigFactory.setFtpConfigReader(new TopConfig4FtpConfigReader());
    }
}
