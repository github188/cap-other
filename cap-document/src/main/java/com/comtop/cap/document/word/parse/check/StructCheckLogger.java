
package com.comtop.cap.document.word.parse.check;

import com.comtop.cap.document.word.docconfig.model.DCTable;
import com.comtop.cap.document.word.docconfig.model.DCTableCell;
import com.comtop.cap.document.word.docconfig.model.DCTableRow;

/**
 * 结构校验日志记录 主要是对模板和文档本身的校验日志
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年11月11日 lizhiyong
 */
public abstract class StructCheckLogger extends AbstractCheckLogger {
    
    /**
     * 构造函数
     * 
     * @param logRecorder 日志记录器
     */
    public StructCheckLogger(ILogRecorder logRecorder) {
        super(logRecorder);
    }
    
    /**
     * 警告日志
     *
     * @param tableCell 对象
     * @param message 提示消息代码
     */
    public void warnCell(DCTableCell tableCell, String message) {
        String fixedMessage = fixTableCellMessage(FSTR_WARN, tableCell, message);
        getLogRecorder().output(fixedMessage);
    }
    
    /**
     * 警告日志
     *
     * @param tableCell 对象
     * @param message 提示消息代码
     */
    public void errorCell(DCTableCell tableCell, String message) {
        String fixedMessage = fixTableCellMessage(FSTR_ERR, tableCell, message);
        getLogRecorder().output(fixedMessage);
    }
    
    /**
     * 警告日志
     *
     * @param tableCell 对象
     * @param message 提示消息代码
     */
    public void infoCell(DCTableCell tableCell, String message) {
        String fixedMessage = fixTableCellMessage(FSTR_INFO, tableCell, message);
        getLogRecorder().output(fixedMessage);
    }
    
    /**
     * 警告日志
     *
     * @param tableRow 对象
     * @param message 提示消息代码
     */
    public void warnTableRow(DCTableRow tableRow, String message) {
        String fixedMessage = fixTableRowMessage(FSTR_WARN, tableRow, message);
        getLogRecorder().output(fixedMessage);
    }
    
    /**
     * 警告日志
     *
     * @param tableRow 对象
     * @param message 提示消息代码
     */
    public void errorTableRow(DCTableRow tableRow, String message) {
        String fixedMessage = fixTableRowMessage(FSTR_ERR, tableRow, message);
        getLogRecorder().output(fixedMessage);
    }
    
    /**
     * 警告日志
     *
     * @param table 对象
     * @param message 提示消息代码
     */
    public void warnTable(DCTable table, String message) {
        String fixedMessage = fixTableMessage(FSTR_WARN, table, message);
        getLogRecorder().output(fixedMessage);
    }
    
    /**
     * 警告日志
     *
     * @param table 对象
     * @param message 提示消息代码
     */
    public void errorTable(DCTable table, String message) {
        String fixedMessage = fixTableMessage(FSTR_ERR, table, message);
        getLogRecorder().output(fixedMessage);
    }
    
    /**
     * 警告日志
     *
     * @param table 对象
     * @param message 提示消息代码
     */
    public void infoTable(DCTable table, String message) {
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
    abstract protected String fixTableRowMessage(String level, DCTableRow tableRow, String message);
    
    /**
     * 组装表格消息
     *
     * @param level 级别
     * @param table 表格
     * @param message 消息
     * @return 规格化消息串
     */
    abstract protected String fixTableMessage(String level, DCTable table, String message);
    
    /**
     * 组装表格单元格消息
     *
     * @param level 级别
     * @param tableCell 单元格
     * @param message 消息
     * @return 规格化消息串
     */
    abstract protected String fixTableCellMessage(String level, DCTableCell tableCell, String message);
}
