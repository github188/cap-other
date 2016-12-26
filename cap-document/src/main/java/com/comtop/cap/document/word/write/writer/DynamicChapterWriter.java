/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.write.writer;

import java.util.Collection;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.xwpf.usermodel.XWPFDocument;

import com.comtop.cap.document.expression.ExpressionUtils;
import com.comtop.cap.document.util.CollectionUtils;
import com.comtop.cap.document.util.ObjectUtils;
import com.comtop.cap.document.word.docconfig.model.DCChapter;
import com.comtop.cap.document.word.docconfig.model.DCContentSeg;
import com.comtop.cap.document.word.expression.ExpressionExecuteHelper;
import com.comtop.cap.document.word.write.DocxExportConfiguration;
import com.comtop.cap.document.word.write.DocxHelper;

/**
 * 动态章节写入器
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月23日 lizhongwen
 */
public class DynamicChapterWriter extends ChapterWriter {
    
    /**
     * 根据配置写入章节
     *
     * @param config 文档导出配置
     * @param docx 文档对象
     * @param chapter 章节配置元素
     * @param level 章节大纲级别
     * @param uri 章节URI
     * @see com.comtop.cap.document.word.write.writer.ChapterWriter#writeChapter(com.comtop.cap.document.word.write.DocxExportConfiguration,org.apache.poi.xwpf.usermodel.XWPFDocument,
     *      com.comtop.cap.document.word.docconfig.model.DCChapter, int,java.lang.String)
     */
    @Override
    protected void writeChapter(DocxExportConfiguration config, XWPFDocument docx, DCChapter chapter, int level,
        String uri) {
        this.chapterOverflow(config);
        if (!isEnable(config, chapter)) {
            return;
        }
        ExpressionExecuteHelper executer = config.getExecuter();
        executer.notifyStart();
        String dataSource = chapter.getMappingTo();
        Object datas = null;
        if (StringUtils.isNotBlank(dataSource)) {
            datas = executer.read(dataSource);
        }
        if (datas != null && datas instanceof Collection<?>) {
            Collection<?> coll = (Collection<?>) datas;
            for (int i = 0; i < coll.size(); i++) {
                writeChapterContent(config, docx, chapter, level, uri);
            }
        }
        executer.notifyEnd();
    }
    
    /**
     * 写章节内容
     *
     * @param config 文档导出配置
     * @param docx 文档对象
     * @param chapter 章节配置元素
     * @param level 章节大纲级别
     * @param uri 章节URI
     */
    private void writeChapterContent(DocxExportConfiguration config, XWPFDocument docx, DCChapter chapter, int level,
        String uri) {
        DocxHelper helper = DocxHelper.getInstance();
        ExpressionExecuteHelper executer = config.getExecuter();
        executer.notifyStart();
        String titleExpr = chapter.getTitle();
        if (StringUtils.isNotBlank(titleExpr) && (titleExpr.contains(".*") || titleExpr.contains("|"))) {
            titleExpr = titleExpr.replace(".*", "");
            if (titleExpr.contains("|")) {
                titleExpr = titleExpr.split("|")[0];
            }
        }
        String dataSource = chapter.getMappingTo();
        String title = ObjectUtils.objectToString(executer.read(titleExpr));
        helper.createParagraphTitle(docx, title, level);
        String uriExpr = StringUtils.remove(ExpressionUtils.readReference(dataSource), "[]") + ".id";
        String url = ObjectUtils.objectToString(executer.read(uriExpr));
        List<DCContentSeg> contents = chapter.getContents();
        if (!CollectionUtils.isEmpty(contents)) {
            IDocxFragmentWriter<DCContentSeg> writer = null;
            for (DCContentSeg content : contents) {
                writer = DocxFragmentWriterFactory.getFragementWriter(content);
                writer.write(config, docx, content, url);
            }
        }
        List<DCChapter> children = chapter.getChildChapters();
        if (!CollectionUtils.isEmpty(children)) {
            int childLevel = level + 1;
            ChapterWriter writer = null;
            for (DCChapter child : children) {
                writer = (ChapterWriter) DocxFragmentWriterFactory.getFragementWriter(child);
                writer.writeChapter(config, docx, child, childLevel, url);
            }
        }
        executer.notifyEnd();
    }
}
