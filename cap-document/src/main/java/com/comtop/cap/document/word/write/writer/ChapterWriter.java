/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.write.writer;

import java.text.MessageFormat;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.xwpf.usermodel.XWPFDocument;

import com.comtop.cap.document.word.docconfig.model.DCChapter;
import com.comtop.cap.document.word.expression.ExpressionExecuteHelper;
import com.comtop.cap.document.word.write.DocxExportConfiguration;
import com.comtop.cap.document.word.write.ExportException;

/**
 * 章节片段写入器
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月23日 lizhongwen
 */
public abstract class ChapterWriter extends FragmentWriter<DCChapter> {
    
    /**
     * 根据文档配置写入章节文档片段
     *
     * @param config 文档导出配置
     * @param docx 文档对象
     * @param element 章节配置元素
     * @param uri 文档uri
     * @see com.comtop.cap.document.word.write.writer.FragmentWriter#internalWrite(com.comtop.cap.document.word.write.DocxExportConfiguration,org.apache.poi.xwpf.usermodel.XWPFDocument,
     *      java.lang.Object, java.lang.String)
     */
    @Override
    public void internalWrite(final DocxExportConfiguration config, final XWPFDocument docx, final DCChapter element,
        final String uri) {
        writeChapter(config, docx, element, 1, uri);
    }
    
    /**
     * 根据配置写入章节
     *
     * @param config 文档导出配置
     * @param docx 文档对象
     * @param element 章节配置元素
     * @param level 章节大纲级别
     * @param uri 章节URI
     */
    protected abstract void writeChapter(final DocxExportConfiguration config, final XWPFDocument docx,
        final DCChapter element, final int level, final String uri);
    
    /**
     * 是否章节溢出
     *
     * @param config 文档导出配置
     */
    protected void chapterOverflow(final DocxExportConfiguration config) {
        int count = config.getAndIncrementChapterCounter();
        if (count > config.getMaxChapterCount()) {
            throw new ExportException(MessageFormat.format("章节数目超过{0}，不支持过多的章节内容，请合理配置导出的内容。",
                config.getMaxChapterCount()));
        }
    }
    
    /**
     * 章节是否启用
     *
     * @param config 文档导出配置
     * @param chapter 章节配置元素
     * @return 章节是否启用
     */
    protected boolean isEnable(final DocxExportConfiguration config, final DCChapter chapter) {
        if (StringUtils.isNotBlank(chapter.getEnable())) {
            ExpressionExecuteHelper executer = config.getExecuter();
            Object result = executer.read(chapter.getEnable());
            if (result != null && result instanceof Boolean && !((Boolean) result)) {
                return false;
            }
        }
        return true;
    }
}
