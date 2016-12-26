/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.parse.check;

import com.comtop.cap.document.word.docmodel.data.Chapter;
import com.comtop.cap.document.word.docmodel.data.Container;
import com.comtop.cap.document.word.docmodel.data.ContentSeg;
import com.comtop.cap.document.word.docmodel.data.Section;
import com.comtop.cap.document.word.docmodel.data.Table;
import com.comtop.cap.document.word.docmodel.data.TableCell;
import com.comtop.cap.document.word.docmodel.data.TableRow;
import com.comtop.cap.document.word.docmodel.data.WordDocument;

/**
 * 文档校验日志
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年11月11日 lizhiyong
 */
public class DocCheckLogger extends AbstractCheckLogger {
    
    /** 文档对象 */
    protected WordDocument document;
    
    /**
     * 构造函数
     * 
     * @param document 文档对象
     */
    public DocCheckLogger(WordDocument document) {
        super(document.getOptions().getLogRecorder());
        this.document = document;
        // getLogRecorder().output("当前文档：" + this.document.getUri());
        // getLogRecorder().output("当前模板配置文件：" + this.document.getDocConfig().getUri());
    }
    
    /**
     * 填充表格日志消息
     *
     * @param level 级别
     * @param table 表格
     * @param message 消息
     * @return 消息串
     */
    protected String fixTableMessage(String level, Table table, String message) {
        StringBuffer stringBuffer = new StringBuffer();
        stringBuffer.append(level);
        stringBuffer.append(message);
        stringBuffer.append("。位置:");
        fixTableLocationMessage(stringBuffer, table);
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
    protected String fixTableCellMessage(String level, TableCell tableCell, String message) {
        StringBuffer stringBuffer = new StringBuffer();
        stringBuffer.append(level).append(message).append("。位置:");
        Table table = tableCell.getTable();
        fixTableLocationMessage(stringBuffer, table);
        stringBuffer.append(FSTR_CELL).append(FSTR_LEFT_BRACKET).append(tableCell.getRowIndex()).append(FSTR_COMMA)
            .append(tableCell.getCellIndex()).append(FSTR_RIGHT_BRACKET).append(FSTR_COLON);
        return stringBuffer.toString();
    }
    
    /**
     * 填充表格位置消息
     *
     * @param stringBuffer 消息串
     * @param table 表格
     */
    private void fixTableLocationMessage(StringBuffer stringBuffer, Table table) {
        fixDocLocationMessage(stringBuffer);
        Container container = table.getContainer();
        if (container instanceof Section) {
            Section section = (Section) container;
            stringBuffer.append(FSTR_SECTION).append(section.getUriChain()).append(FSTR_LEFT_BIAS);
        } else {
            Chapter chapter = (Chapter) container;
            stringBuffer.append(FSTR_CHAPTER).append(chapter.getUriChain()).append(FSTR_LEFT_BIAS);
        }
        stringBuffer.append("第").append(table.getTableIndex()).append("个表格");
    }
    
    /**
     * 填充文档定位日志消息
     *
     * @param stringBuffer 消息串
     */
    private void fixDocLocationMessage(StringBuffer stringBuffer) {
        // stringBuffer.append(FSTR_DOC).append(this.document.getUri()).append(FSTR_LEFT_BIAS);
        // stringBuffer.append(FSTR_LEFT_BRACKET).append(FSTR_TPL).append(this.document.getDocConfig().getUri())
        // .append(FSTR_RIGHT_BRACKET);
        //
    }
    
    /**
     * 记录章节校验警告信息
     *
     * @param chapter 章节
     * @param message 消息
     */
    public void warnChapter(Chapter chapter, String message) {
        String fixedMessage = fixChapterMessage(FSTR_WARN, chapter, message);
        getLogRecorder().output(fixedMessage);
    }
    
    /**
     * 记录章节校验错误信息
     *
     * @param chapter 章节
     * @param message 消息
     */
    public void errorChapter(Chapter chapter, String message) {
        String fixedMessage = fixChapterMessage(FSTR_ERR, chapter, message);
        getLogRecorder().output(fixedMessage);
    }
    
    /**
     * 填充章节日志消息
     * 
     * @param level 级别
     * @param chapter 章节
     *
     * @param message 消息
     * @return xx
     */
    private String fixChapterMessage(String level, Chapter chapter, String message) {
        StringBuffer stringBuffer = new StringBuffer();
        stringBuffer.append(level).append(message).append("。位置:").append(FSTR_CHAPTER).append(chapter.getUriChain());
        fixDocLocationMessage(stringBuffer);
        return stringBuffer.toString();
    }
    
    /**
     * 记录分节校验错误信息
     *
     * @param section 章节
     * @param message 消息
     */
    public void warnSection(Section section, String message) {
        String fixedMessage = fixSectionMessage(FSTR_WARN, section, message);
        getLogRecorder().output(fixedMessage);
    }
    
    /**
     * 记录分节校验错误信息
     *
     * @param section 章节
     * @param message 消息
     */
    public void errorSection(Section section, String message) {
        String fixedMessage = fixSectionMessage(FSTR_ERR, section, message);
        getLogRecorder().output(fixedMessage);
    }
    
    /**
     * 填充分节日志消息
     * 
     * @param level 级别
     * @param section 章节
     *
     * @param message 消息
     * @return xx
     */
    private String fixSectionMessage(String level, Section section, String message) {
        StringBuffer stringBuffer = new StringBuffer();
        stringBuffer.append(level).append(section.getName()).append(FSTR_COLON).append(message);
        fixDocLocationMessage(stringBuffer);
        return stringBuffer.toString();
    }
    
    /**
     * 记录分节校验错误信息
     *
     * @param content 章节
     * @param message 消息
     */
    public void warnContent(ContentSeg content, String message) {
        String fixedMessage = fixContentMessage(FSTR_WARN, content, message);
        getLogRecorder().output(fixedMessage);
    }
    
    /**
     * 记录分节校验错误信息
     *
     * @param content 章节
     * @param message 消息
     */
    public void errorContent(ContentSeg content, String message) {
        String fixedMessage = fixContentMessage(FSTR_ERR, content, message);
        getLogRecorder().output(fixedMessage);
    }
    
    /**
     * 填充内容片断日志消息
     * 
     * @param level 级别
     * @param content 章节或分节内容
     *
     * @param message 消息
     * @return xx
     */
    private String fixContentMessage(String level, ContentSeg content, String message) {
        StringBuffer stringBuffer = new StringBuffer();
        stringBuffer.append(level).append(content.getClass().getSimpleName()).append(message);
        fixContentLocationMessage(stringBuffer, content);
        return stringBuffer.toString();
    }
    
    /**
     * 填充内容位置日志消息
     *
     * @param stringBuffer 消息串
     * @param content 表格
     */
    private void fixContentLocationMessage(StringBuffer stringBuffer, ContentSeg content) {
        fixDocLocationMessage(stringBuffer);
        
        Container container = content.getContainer();
        if (container instanceof Section) {
            Section section = (Section) container;
            stringBuffer.append(FSTR_SECTION).append(section.getUriChain()).append(FSTR_LEFT_BIAS);
        } else {
            Chapter chapter = (Chapter) container;
            stringBuffer.append(FSTR_CHAPTER).append(chapter.getUriChain()).append(FSTR_LEFT_BIAS);
        }
    }
    
    /**
     * 记录章节校验错误信息
     *
     * @param text 章节
     * @param message 消息
     */
    public void warnText(String text, String message) {
        String fixedMessage = fixTextMessage(FSTR_WARN, text, message);
        getLogRecorder().output(fixedMessage);
    }
    
    /**
     * 记录章节校验错误信息
     *
     * @param text 章节
     * @param message 消息
     */
    public void errorText(String text, String message) {
        String fixedMessage = fixTextMessage(FSTR_ERR, text, message);
        getLogRecorder().output(fixedMessage);
    }
    
    /**
     * 填充文本日志
     * 
     * @param level 级别
     * @param text 章节或分节内容
     * @param message 消息
     * @return xx
     */
    private String fixTextMessage(String level, String text, String message) {
        StringBuffer stringBuffer = new StringBuffer();
        stringBuffer.append(level).append(FSTR_TEXT).append(text).append(FSTR_COLON).append(message);
        fixDocLocationMessage(stringBuffer);
        return stringBuffer.toString();
    }
    
    /**
     * 警告日志
     *
     * @param tableCell 对象
     * @param message 提示消息代码
     */
    public void warnCell(TableCell tableCell, String message) {
        String fixedMessage = fixTableCellMessage(FSTR_WARN, tableCell, message);
        getLogRecorder().output(fixedMessage);
    }
    
    /**
     * 警告日志
     *
     * @param tableCell 对象
     * @param message 提示消息代码
     */
    public void errorCell(TableCell tableCell, String message) {
        String fixedMessage = fixTableCellMessage(FSTR_ERR, tableCell, message);
        getLogRecorder().output(fixedMessage);
    }
    
    /**
     * 警告日志
     *
     * @param tableCell 对象
     * @param message 提示消息代码
     */
    public void infoCell(TableCell tableCell, String message) {
        String fixedMessage = fixTableCellMessage(FSTR_INFO, tableCell, message);
        getLogRecorder().output(fixedMessage);
    }
    
    /**
     * 警告日志
     *
     * @param tableRow 对象
     * @param message 提示消息代码
     */
    public void warnTableRow(TableRow tableRow, String message) {
        String fixedMessage = fixTableRowMessage(FSTR_WARN, tableRow, message);
        getLogRecorder().output(fixedMessage);
    }
    
    /**
     * 警告日志
     *
     * @param tableRow 对象
     * @param message 提示消息代码
     */
    public void errorTableRow(TableRow tableRow, String message) {
        String fixedMessage = fixTableRowMessage(FSTR_ERR, tableRow, message);
        getLogRecorder().output(fixedMessage);
    }
    
    /**
     * 警告日志
     *
     * @param table 对象
     * @param message 提示消息代码
     */
    public void warnTable(Table table, String message) {
        String fixedMessage = fixTableMessage(FSTR_WARN, table, message);
        getLogRecorder().output(fixedMessage);
    }
    
    /**
     * 警告日志
     *
     * @param table 对象
     * @param message 提示消息代码
     */
    public void errorTable(Table table, String message) {
        String fixedMessage = fixTableMessage(FSTR_ERR, table, message);
        getLogRecorder().output(fixedMessage);
    }
    
    /**
     * 警告日志
     *
     * @param table 对象
     * @param message 提示消息代码
     */
    public void infoTable(Table table, String message) {
        String fixedMessage = fixTableMessage(FSTR_INFO, table, message);
        getLogRecorder().output(fixedMessage);
    }
    
    /**
     * 组装表格行消息
     *
     * @param level 级别
     * @param tableRow 表格
     * @param message 消息
     * @return 规格化消息串
     */
    protected String fixTableRowMessage(String level, TableRow tableRow, String message) {
        return null;
    }
}
