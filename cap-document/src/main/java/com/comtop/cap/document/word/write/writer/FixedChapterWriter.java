/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.write.writer;

import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.xwpf.usermodel.XWPFDocument;

import com.comtop.cap.document.util.CollectionUtils;
import com.comtop.cap.document.word.docconfig.model.DCChapter;
import com.comtop.cap.document.word.docconfig.model.DCContentSeg;
import com.comtop.cap.document.word.expression.ExpressionExecuteHelper;
import com.comtop.cap.document.word.write.DocxExportConfiguration;
import com.comtop.cap.document.word.write.DocxHelper;

/**
 * 固定章节写入器
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月23日 lizhongwen
 */
public class FixedChapterWriter extends ChapterWriter {
    
    /**
     * 根据文档配置写入固定章节文档片段
     *
     * @param config 文档导出配置
     * @param docx 文档对象
     * @param chapter 固定章节配置元素
     * @param level 章节大纲级别
     * @param uri 章节URI
     * @see com.comtop.cap.document.word.write.writer.ChapterWriter#writeChapter(com.comtop.cap.document.word.write.DocxExportConfiguration,org.apache.poi.xwpf.usermodel.XWPFDocument,
     *      com.comtop.cap.document.word.docconfig.model.DCChapter, int,java.lang.String)
     */
    @Override
    public void writeChapter(final DocxExportConfiguration config, final XWPFDocument docx, final DCChapter chapter,
        final int level, final String uri) {
        this.chapterOverflow(config);
        if (!isEnable(config, chapter)) {
            return;
        }
        DocxHelper helper = DocxHelper.getInstance();
        ExpressionExecuteHelper executer = config.getExecuter();
        executer.notifyStart();
        String dataSource = chapter.getMappingTo();
        if (StringUtils.isNotBlank(dataSource)) {
            executer.read(dataSource);
        }
        String title = chapter.getTitle();
        if (StringUtils.isNotBlank(title) && (title.contains(".*") || title.contains("|"))) {
            title = title.replace(".*", "");
            if (title.contains("|")) {
                title = title.split("\\|")[0];
            }
        }
        helper.createParagraphTitle(docx, title, level);
        String url = uri + "/" + title;
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
