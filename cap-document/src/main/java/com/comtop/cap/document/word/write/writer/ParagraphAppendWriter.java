/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.write.writer;

import org.apache.poi.xwpf.usermodel.XWPFParagraph;

import com.comtop.cap.document.word.write.DocxExportConfiguration;

/**
 * 向段落内添加写入器
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年12月16日 lizhongwen
 * @param <T> 类型
 */
public interface ParagraphAppendWriter<T> {
    
    /**
     * 添加到指定段落
     *
     * @param config 文档导出配置
     * @param paragraph 文档段落对象
     * @param node 配置元素
     * @param uri 文档URI
     */
    void append(final DocxExportConfiguration config, final XWPFParagraph paragraph, final T node, final String uri);
}
