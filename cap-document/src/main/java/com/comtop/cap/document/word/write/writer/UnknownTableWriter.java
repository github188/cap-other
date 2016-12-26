/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.write.writer;

import org.apache.poi.xwpf.usermodel.XWPFDocument;

import com.comtop.cap.document.word.docconfig.model.DCTable;
import com.comtop.cap.document.word.write.DocxExportConfiguration;

/**
 * HTML表格写入器
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月24日 lizhongwen
 */
public class UnknownTableWriter extends TableWriter {
    
    /**
     * 根据文档配置写入HTML表格文档片段
     *
     * @param config 文档导出配置
     * @param docx 文档对象
     * @param table HTML表格配置元素
     * @param uri 文档URI
     * @see com.comtop.cap.document.word.write.writer.FragmentWriter#internalWrite(com.comtop.cap.document.word.write.DocxExportConfiguration,
     *      org.apache.poi.xwpf.usermodel.XWPFDocument,java.lang.Object, java.lang.String)
     */
    @Override
    protected void internalWrite(DocxExportConfiguration config, XWPFDocument docx, DCTable table, String uri) {
        //
    }
    
}
