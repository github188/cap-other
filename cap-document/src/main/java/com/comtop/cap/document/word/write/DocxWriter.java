/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.write;

import static com.comtop.cap.document.util.Assert.notNull;

import java.io.IOException;
import java.text.MessageFormat;

import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.document.word.WordOptions;
import com.comtop.cap.document.word.docconfig.DocConfigManager;
import com.comtop.cap.document.word.docconfig.model.DCSection;
import com.comtop.cap.document.word.docconfig.model.DocConfig;
import com.comtop.cap.document.word.parse.WordParser;
import com.comtop.cap.document.word.write.writer.DocxFragmentWriterFactory;
import com.comtop.cap.document.word.write.writer.IDocxFragmentWriter;

/**
 * 文档写入器
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月23日 lizhongwen
 */
public class DocxWriter {
    
    /** 日志 */
    private final Logger logger = LoggerFactory.getLogger(WordParser.class);
    
    /**
     * 创建文件
     *
     * @param configuration 文档导出配置
     * @return 是否写入成功
     */
    public boolean write(DocxExportConfiguration configuration) {
        notNull(configuration);
        notNull(configuration.getTemplatePath());
        notNull(configuration.getFilePath());
        DocConfigManager parser = new DocConfigManager();
        WordOptions options = new WordOptions(configuration.getConfiguration(), configuration.getLogPath());
        DocConfig config = parser.parseXml(configuration.getTemplatePath(), options);
        DocxHelper helper = DocxHelper.getInstance();
        XWPFDocument docx = helper.createDocument();
        config.getSections();
        boolean result = true;
        IDocxFragmentWriter<DCSection> writer = null;
        for (DCSection section : config.getSections()) {
            try {
                writer = DocxFragmentWriterFactory.getFragementWriter(section);
                writer.write(configuration, docx, section, null);
            } catch (Exception e) {
                logger.error(e.getMessage(), e);
                result = false;
                break;
            }
        }
        try {
            helper.saveDocument(docx, configuration.getFilePath());
        } catch (IOException e) {
            logger.error(MessageFormat.format("文档保存失败，无法保存到指定路径''{0}''", configuration.getFilePath()), e);
        }
        return result;
    }
}
