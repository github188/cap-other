/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.write.writer;

import org.apache.poi.xwpf.usermodel.XWPFDocument;

import com.comtop.cap.document.word.write.DocxExportConfiguration;

/**
 * 文档片段写入
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月23日 lizhongwen
 * @param <T> 文档元素类型
 */
public interface IDocxFragmentWriter<T> {
    
    /**
     * 根据文档配置写入文档片段
     *
     * @param config 文档导出配置
     * @param docx 文档对象
     * @param element 配置元素
     * @param uri 文档URI
     */
    void write(final DocxExportConfiguration config, final XWPFDocument docx, final T element, final String uri);
}
