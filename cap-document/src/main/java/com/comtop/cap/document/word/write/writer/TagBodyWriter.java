/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.write.writer;

import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.jsoup.nodes.Node;

import com.comtop.cap.document.word.write.DocxExportConfiguration;

/**
 * HTML body标签写入
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年12月16日 lizhongwen
 */
public class TagBodyWriter extends TagWriter {
    
    /**
     * 根据文档配置写入文档片段
     *
     * @param config 文档导出配置
     * @param docx 文档对象
     * @param node 配置元素
     * @param uri 文档URI
     * @see com.comtop.cap.document.word.write.writer.TagWriter#internalWrite(com.comtop.cap.document.word.write.DocxExportConfiguration,
     *      org.apache.poi.xwpf.usermodel.XWPFDocument, org.jsoup.nodes.Node, java.lang.String)
     */
    @Override
    protected void internalWrite(DocxExportConfiguration config, XWPFDocument docx, Node node, String uri) {
        this.writeNode(config, docx, node, uri);
    }
}
