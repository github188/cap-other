/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.parse.check;

import com.comtop.cap.document.word.docconfig.model.DCChapter;
import com.comtop.cap.document.word.docconfig.model.DCContainer;
import com.comtop.cap.document.word.docconfig.model.DCSection;
import com.comtop.cap.document.word.docconfig.model.DCTable;
import com.comtop.cap.document.word.docconfig.model.DCTableCell;
import com.comtop.cap.document.word.docconfig.model.DCTableRow;
import com.comtop.cap.document.word.docconfig.model.DocConfig;

/**
 * 模板检验日志记录器
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年11月11日 lizhiyong
 */
public class DocConfigCheckLogger extends StructCheckLogger {
    
    /** 被校验的模板 */
    protected final DocConfig docConfig;
    
    /**
     * 构造函数
     * 
     * @param docConfig 模板
     */
    public DocConfigCheckLogger(DocConfig docConfig) {
        super(docConfig.getOptions().getLogRecorder());
        this.docConfig = docConfig;
        // getLogRecorder().output("当前模板配置文件：" + docConfig.getUri());
    }
    
    /**
     * 填充表格日志消息
     *
     * @param level 级别
     * @param table 表格
     * @param message 消息
     * @return 消息串
     */
    @Override
    protected String fixTableMessage(String level, DCTable table, String message) {
        StringBuffer stringBuffer = new StringBuffer();
        stringBuffer.append(level).append(message).append("。位置:");
        fixTableLocationMessage(stringBuffer, table);
        stringBuffer.append(FSTR_TABLE).append(table.getName());
        return stringBuffer.toString();
    }
    
    /**
     * 填充表格单元格日志消息
     *
     * @param level 日志级别
     * @param tableCell 单元 格
     * @param message 消息
     * @return 返回消息
     */
    @Override
    protected String fixTableCellMessage(String level, DCTableCell tableCell, String message) {
        StringBuffer stringBuffer = new StringBuffer();
        stringBuffer.append(level).append(message).append("。位置:");
        
        DCTable table = tableCell.getTable();
        fixTableCellLocationMessage(stringBuffer, table);
        stringBuffer.append(FSTR_CELL).append(FSTR_LEFT_BRACKET).append(tableCell.getRowIndex()).append(FSTR_COMMA)
            .append(tableCell.getCellIndex()).append(FSTR_RIGHT_BRACKET);
        return stringBuffer.toString();
    }
    
    /**
     * 填充表格定位消息
     *
     * @param stringBuffer 消息串
     * @param table 表格
     */
    private void fixTableLocationMessage(StringBuffer stringBuffer, DCTable table) {
        DCContainer container = table.getContainer();
        if (container instanceof DCSection) {
            DCSection section = (DCSection) container;
            stringBuffer.append(FSTR_SECTION).append(section.getUri()).append(FSTR_LEFT_BIAS);
        } else {
            DCChapter chapter = (DCChapter) container;
            stringBuffer.append(FSTR_CHAPTER).append(chapter.getUri()).append(FSTR_LEFT_BIAS);
        }
    }
    
    /**
     * 填充表格单元格定位消息
     *
     * @param stringBuffer 消息串
     * @param table 表格
     */
    private void fixTableCellLocationMessage(StringBuffer stringBuffer, DCTable table) {
        DCContainer container = table.getContainer();
        if (container instanceof DCSection) {
            DCSection section = (DCSection) container;
            stringBuffer.append(FSTR_SECTION).append(section.getUri()).append(FSTR_LEFT_BIAS);
        } else {
            DCChapter chapter = (DCChapter) container;
            stringBuffer.append(FSTR_CHAPTER).append(chapter.getUri()).append(FSTR_LEFT_BIAS);
        }
        stringBuffer.append(FSTR_TABLE).append(table.getName()).append(FSTR_LEFT_BIAS);
    }
    
    /**
     * 章节错误日志
     *
     * @param chapter 章节
     * @param message 消息
     */
    public void errorChapter(DCChapter chapter, String message) {
        StringBuffer stringBuffer = new StringBuffer();
        stringBuffer.append(FSTR_ERR).append(message).append('。');
        stringBuffer.append(FSTR_CHAPTER).append(chapter.getUri());
    }
    
    @Override
    protected String fixTableRowMessage(String level, DCTableRow tableRow, String message) {
        StringBuffer stringBuffer = new StringBuffer();
        stringBuffer.append(level).append(message).append("。位置:");
        fixTableLocationMessage(stringBuffer, tableRow.getTable());
        stringBuffer.append(FSTR_TABLE).append(tableRow.getTable().getName());
        stringBuffer.append(FSTR_TABLE_ROW).append('第').append(tableRow.getRowIndex()).append('行');
        return stringBuffer.toString();
    }
}
