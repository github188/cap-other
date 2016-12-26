/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.write.writer;

import static com.comtop.cap.document.word.write.DocxConstants.STYLE_COVER_SIMHEI_3;
import static com.comtop.cap.document.word.write.DocxConstants.STYLE_TABLE_CONTENT_LEFT;

import java.text.MessageFormat;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFTable;

import com.comtop.cap.document.word.docconfig.model.ConfigElement;
import com.comtop.cap.document.word.docconfig.model.DCChapter;
import com.comtop.cap.document.word.docconfig.model.DCSection;
import com.comtop.cap.document.word.docconfig.model.DCTable;
import com.comtop.cap.document.word.docmodel.style.Style.VAlign;
import com.comtop.cap.document.word.write.DocxExportConfiguration;
import com.comtop.cap.document.word.write.DocxHelper;

/**
 * 文档分解写入
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月23日 lizhongwen
 */
public class SectionWriter extends FragmentWriter<DCSection> {
    
    /**
     * 根据文档配置写入文档分节片段
     *
     * @param config 文档导出配置
     * @param docx 文档对象
     * @param section 分节元素
     * @param uri 文档URI
     * @see com.comtop.cap.document.word.write.writer.FragmentWriter#write(com.comtop.cap.document.word.write.DocxExportConfiguration,org.apache.poi.xwpf.usermodel.XWPFDocument,
     *      java.lang.Object, java.lang.String)
     */
    @Override
    public void internalWrite(final DocxExportConfiguration config, final XWPFDocument docx, final DCSection section,
        final String uri) {
        String name = section.getName();
        if ("封面".equals(name)) {
            writeFrontCover(config, docx);
        } else if ("文档基本信息".equals(name)) {
            writeDocumentInfo(config, docx, section);
        } else if ("目录".equals(name)) {
            writeCatalogue(docx);
        } else if ("正文".equals(name)) {
            List<DCChapter> chapters = section.getChapters();
            IDocxFragmentWriter<DCChapter> writer = null;
            for (DCChapter chapter : chapters) {
                writer = DocxFragmentWriterFactory.getFragementWriter(chapter);
                writer.write(config, docx, chapter, name);
            }
        }
    }
    
    /**
     * 写入封面
     *
     * @param config 文档导出配置
     * @param docx 文档对象
     */
    private void writeFrontCover(final DocxExportConfiguration config, final XWPFDocument docx) {
        getLogger().debug(MessageFormat.format("创建封面，封面标题为：{0}。", config.getTitle()));
        DocxHelper helper = DocxHelper.getInstance();
        try {
            helper.createFrontCover(docx, config.getTitle()).createDefaultHeader(docx, config.getTitle())
                .createDefaultFooter(docx);
        } catch (Exception e) {
            helper.createTextParagraph(docx, "无法创建封面，请手工创建。").createPageBreak(docx);
            getLogger().error("无法创建封面，请手工创建。", e);
        }
        getLogger().debug("写入封面完成。");
    }
    
    /**
     * 写入文档信息
     *
     * @param config 文档导出配置
     * @param docx 文档对象
     * @param section 文档子节
     */
    private void writeDocumentInfo(final DocxExportConfiguration config, final XWPFDocument docx,
        final DCSection section) {
        getLogger().debug(MessageFormat.format("正在写入：{0}。", section.getName()));
        List<? extends ConfigElement> elements = section.getElements(DCTable.class);
        if (elements == null) {
            this.createModifyRecords(docx);
            return;
        }
        DocxHelper helper = DocxHelper.getInstance();
        IDocxFragmentWriter<DCTable> writer = null;
        for (ConfigElement element : elements) {
            DCTable table = (DCTable) element;
            if (StringUtils.isNotBlank(table.getName())) {
                helper.createTextParagraph(docx, table.getName()).getLastParagraph(docx).setStyle(STYLE_COVER_SIMHEI_3);
            }
            if ("修订记录".equals(table.getName())) {
                this.createModifyRecords(docx);
                continue;
            }
            writer = DocxFragmentWriterFactory.getFragementWriter(table);
            writer.write(config, docx, table, null);
            helper.createEmptyParagraph(docx);
        }
        helper.removeSectionFooter(docx);
        getLogger().debug(MessageFormat.format("写入：{0}完成。", section.getName()));
    }
    
    /**
     * 创建修改记录
     *
     * @param docx 文档对象
     */
    private void createModifyRecords(final XWPFDocument docx) {
        DocxHelper helper = DocxHelper.getInstance();
        XWPFTable table = helper.createTable(docx, 8, 7, 2.43f, 0.7f);
        helper.setTableStyle(table, STYLE_TABLE_CONTENT_LEFT).setTableHeader(table, 1)
            .setRowAlign(table, 0, VAlign.CENTER, null).setRowBackground(table, 0, "F3F3F3")
            .setColsWidth(table, new float[] { 2.43f, 3.42f, 2.43f, 2.43f, 1.93f, 1.93f, 2.43f });
        String[] titles = { "修订人", "修订内容摘要", "产生版本", "修订日期 ", "审核人", "批准人", "批准时间" };
        for (int i = 0; i < 7; i++) {
            helper.setCellText(table, 0, i, titles[i]);
        }
    }
    
    /**
     * 写入目录
     *
     * @param docx 文档对象
     */
    private void writeCatalogue(final XWPFDocument docx) {
        getLogger().debug("正在写入目录。");
        DocxHelper helper = DocxHelper.getInstance();
        try {
            helper.createCataloguePage(docx);
        } catch (Exception e) {
            helper.createTextParagraph(docx, "无法创建目录，请手工创建。").createPageBreak(docx);
            getLogger().error("无法创建目录，请手工创建。", e);
        }
        getLogger().debug("写入目录完成。");
    }
}
