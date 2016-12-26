/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.write.writer;

import java.util.List;

import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFParagraph;
import org.jsoup.nodes.Node;

import com.comtop.cap.document.word.write.DocxExportConfiguration;
import com.comtop.cap.document.word.write.DocxHelper;

/**
 * HTML P标签写入
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月26日 lizhongwen
 */
public class TagPWriter extends TagWriter {
    
    /**
     * 根据文档配置写入HTML文档标签片段
     *
     * @param config 文档导出配置
     * @param docx 文档对象
     * @param node HTML文档标签配置元素
     * @param uri 文档URI
     * @see com.comtop.cap.document.word.write.writer.TagWriter#internalWrite(com.comtop.cap.document.word.write.DocxExportConfiguration,
     *      org.apache.poi.xwpf.usermodel.XWPFDocument, org.jsoup.nodes.Node, java.lang.String)
     */
    @Override
    protected void internalWrite(final DocxExportConfiguration config, final XWPFDocument docx, final Node node,
        final String uri) {
        DocxHelper helper = DocxHelper.getInstance();
        XWPFParagraph paragraph = helper.createBodyParagraph(docx);
        List<Node> nodes = node.childNodes();
        for (Node n : nodes) {
            super.append(config, paragraph, n, uri);
        }
    }
    
    /**
     * 添加到指定段落
     *
     * @param config 文档导出配置
     * @param paragraph 文档段落对象
     * @param node HTML节点
     * @param uri 文档URI
     * @see com.comtop.cap.document.word.write.writer.TagWriter#append(com.comtop.cap.document.word.write.DocxExportConfiguration,
     *      org.apache.poi.xwpf.usermodel.XWPFParagraph, org.jsoup.nodes.Node, java.lang.String)
     */
    @Override
    public void append(final DocxExportConfiguration config, final XWPFParagraph paragraph, final Node node,
        final String uri) {
        DocxHelper helper = DocxHelper.getInstance();
        XWPFParagraph para = helper.createSameStyleParagraph(paragraph);
        if (para == null) {
            getLogger().error("数据格式错误。");
        }
        List<Node> nodes = node.childNodes();
        for (Node n : nodes) {
            super.append(config, para, n, uri);
        }
    }
}
