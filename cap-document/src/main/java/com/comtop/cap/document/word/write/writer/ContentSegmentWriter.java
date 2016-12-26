/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.write.writer;

import java.text.MessageFormat;
import java.util.Collection;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.xwpf.usermodel.XWPFDocument;

import com.comtop.cap.document.word.docconfig.model.DCContentSeg;
import com.comtop.cap.document.word.docmodel.data.ContentSeg;
import com.comtop.cap.document.word.expression.ExpressionExecuteHelper;
import com.comtop.cap.document.word.write.DocxExportConfiguration;

/**
 * 文档内容片段写入器
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月24日 lizhongwen
 */
public class ContentSegmentWriter extends FragmentWriter<DCContentSeg> {
    
    /**
     * 根据文档配置写入文档内容片段片段
     *
     * @param config 文档导出配置
     * @param docx 文档对象
     * @param segment 文档内容片段配置元素
     * @param uri 文档URi
     * @see com.comtop.cap.document.word.write.writer.FragmentWriter#internalWrite(com.comtop.cap.document.word.write.DocxExportConfiguration,org.apache.poi.xwpf.usermodel.XWPFDocument,
     *      java.lang.Object, java.lang.String)
     */
    @Override
    protected void internalWrite(final DocxExportConfiguration config, final XWPFDocument docx,
        final DCContentSeg segment, final String uri) {
        ExpressionExecuteHelper executer = config.getExecuter();
        String expression = segment.getMappingTo();
        if (StringUtils.isBlank(expression)) {
            return;
        }
        String param = "''";
        if (StringUtils.isNotBlank(uri)) {
            param = "'" + uri + "'";
        }
        expression = MessageFormat.format(expression, param);
        executer.notifyStart();
        Object result = executer.read(expression);
        if (result != null) {
            if (result instanceof String) {
                String seg = (String) result;
                writeHtmlSegment(config, docx, seg, uri);
            } else if (result instanceof ContentSeg) {
                ContentSeg seg = (ContentSeg) result;
                String html = seg.getContent();
                writeHtmlSegment(config, docx, html, uri);
            } else if (result instanceof Collection) {// 集合
                Collection<?> coll = (Collection<?>) result;
                if (!coll.isEmpty()) {
                    String html;
                    for (Object e : coll) {
                        ContentSeg seg = (ContentSeg) e;
                        html = seg.getContent();
                        writeHtmlSegment(config, docx, html, uri);
                    }
                }
            }
        }
        executer.notifyEnd();
    }
    
    /**
     * 写入HTML片段
     *
     * @param config 文档导出配置
     * @param docx 文档对象
     * @param content 文档内容片段
     * @param uri 文档URi
     */
    private void writeHtmlSegment(DocxExportConfiguration config, XWPFDocument docx, String content, String uri) {
        IDocxFragmentWriter<String> writer;
        if (StringUtils.isNotBlank(content)) {
            writer = DocxFragmentWriterFactory.getFragementWriter(content);
            writer.write(config, docx, content, uri);
        }
    }
}
