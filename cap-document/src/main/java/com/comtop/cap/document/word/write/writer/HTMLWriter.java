/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.write.writer;

import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.BODY_ELEMENT;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Node;

import com.comtop.cap.document.word.write.DocxExportConfiguration;
import com.comtop.cap.document.word.write.DocxHelper;

/**
 * HTML写入
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月26日 lizhongwen
 */
public class HTMLWriter extends FragmentWriter<String> {
    
    /**
     * 根据文档配置写入文档HTML片段
     *
     * @param config 文档导出配置
     * @param docx 文档对象
     * @param html HTML配置元素
     * @param uri 文档URI
     * @see com.comtop.cap.document.word.write.writer.FragmentWriter#internalWrite(com.comtop.cap.document.word.write.DocxExportConfiguration,
     *      org.apache.poi.xwpf.usermodel.XWPFDocument, java.lang.Object, java.lang.String)
     */
    @Override
    protected void internalWrite(final DocxExportConfiguration config, final XWPFDocument docx, final String html,
        final String uri) {
        DocxHelper helper = DocxHelper.getInstance();
        if (StringUtils.isEmpty(html)) {
            helper.createTextParagraph(docx, "");
            return;
        }
        Document document = Jsoup.parseBodyFragment(html);
        if (document == null) {
            helper.createTextParagraph(docx, "");
            return;
        }
        Node body = document.body();
        IDocxFragmentWriter<Node> writer = DocxFragmentWriterFactory.getFragementWriter(body, BODY_ELEMENT);
        writer.write(config, docx, body, uri);
    }
    
}
