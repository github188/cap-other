/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.write.writer;

import static com.comtop.cap.document.word.write.DocxConstants.STYLE_TABLE_TITLE;

import java.util.Collection;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFTable;

import com.comtop.cap.document.util.ObjectUtils;
import com.comtop.cap.document.word.docconfig.model.DCTable;
import com.comtop.cap.document.word.docmodel.data.CellExtra;
import com.comtop.cap.document.word.docmodel.data.RowExtra;
import com.comtop.cap.document.word.docmodel.data.TableExtra;
import com.comtop.cap.document.word.docmodel.style.TableMargin;
import com.comtop.cap.document.word.expression.ExpressionExecuteHelper;
import com.comtop.cap.document.word.write.DocxExportConfiguration;
import com.comtop.cap.document.word.write.DocxHelper;

/**
 * 行扩展表格写入
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月23日 lizhongwen
 */
public class ExpandRowTableWriter extends DynamicTableWriter {
    
    /**
     * 根据文档配置写入行扩展表格文档片段
     *
     * @param config 文档导出配置
     * @param docx 文档对象
     * @param tableConfig 行扩展表格配置元素
     * @param uri 文档uri
     * @see com.comtop.cap.document.word.write.writer.DynamicTableWriter#write(com.comtop.cap.document.word.write.DocxExportConfiguration,org.apache.poi.xwpf.usermodel.XWPFDocument,
     *      com.comtop.cap.document.word.docconfig.model.DCTable, java.lang.String)
     */
    @Override
    public void internalWrite(final DocxExportConfiguration config, final XWPFDocument docx, final DCTable tableConfig,
        final String uri) {
        ExpressionExecuteHelper executer = config.getExecuter();
        executer.notifyStart();
        String dataSource = tableConfig.getMappingTo();
        Collection<?> datas = null;
        if (StringUtils.isNotBlank(dataSource)) {
            Object result = executer.read(dataSource);
            if (result instanceof Collection) {
                datas = (Collection<?>) result;
            }
        }
        TableExtra tableExtra = this.pretreatment(tableConfig, executer);
        int expandRowNum = 1;
        if (datas != null && !datas.isEmpty()) {
            expandRowNum = datas.size();
        }
        int rowCount = calcTableRowCount(tableExtra);
        int rowNum = rowCount + expandRowNum;
        int colNum = calcTableColumnCount(tableExtra);
        DocxHelper helper = DocxHelper.getInstance();
        try {
            this.columnOverflow(colNum, uri);
        } catch (Exception e) {
            executer.notifyEnd();
            this.getLogger().error(e.getMessage(), e);
            return;
        }
        XWPFTable table = helper.createTable(docx, rowNum, colNum);
        this.createTableHeader(tableExtra, table);
        if (datas != null && !datas.isEmpty()) {
            this.fillTableDatas(config, tableExtra, table, uri, expandRowNum);
        }
        this.marginTableData(table, tableExtra.getMargins(), rowCount, rowNum - 1);
        this.autoMargin(table, tableExtra.getCells()[rowCount - 1], rowCount);
        this.createTableCaption(docx, tableConfig.getName());
        executer.notifyEnd();
    }
    
    /**
     * 创建表头
     *
     * @param config 表格配置
     * @param table 表格对象
     */
    private void createTableHeader(final TableExtra config, final XWPFTable table) {
        DocxHelper helper = DocxHelper.getInstance();
        RowExtra[] rows = config.getRows();
        for (int rowIndex = 0; rowIndex < rows.length; rowIndex++) {
            RowExtra row = rows[rowIndex];
            helper.setRowStyle(table, rowIndex, STYLE_TABLE_TITLE).setRowBackground(table, rowIndex, "F3F3F3");
            CellExtra[] cells = row.getCells();
            for (int colIndex = 0; colIndex < cells.length; colIndex++) {
                CellExtra cell = cells[colIndex];
                float width = cell.getWidth();
                if (cell.isMerged()) {
                    continue;
                }
                if (width > 0) {
                    helper.setColWidth(table, colIndex, width);
                }
                String text = cell.getHeader();
                helper.setCellText(table, rowIndex, colIndex, text);
            }
        }
        List<TableMargin> margins = config.getMargins();
        this.marginTable(table, margins);
        if (margins.isEmpty()) {
            helper.setTableHeader(table, rows.length);
        }
    }
    
    /**
     * 填充表格数据
     * 
     * @param configuration 文档导出配置
     *
     * @param config 表格配置
     * @param table 表格对象
     * @param uri 文档uri
     * @param dataSize 数据量
     */
    private void fillTableDatas(final DocxExportConfiguration configuration, final TableExtra config,
        final XWPFTable table, final String uri, final int dataSize) {
        ExpressionExecuteHelper executer = configuration.getExecuter();
        int rowCount = calcTableRowCount(config);
        int lastHeaderIndex = rowCount - 1;
        RowExtra[] rows = config.getRows();
        for (int i = 0; i < dataSize; i++) {
            RowExtra row = rows[lastHeaderIndex];
            executer.notifyStart();
            CellExtra[] cells = row.getCells();
            int rowIndex = i + lastHeaderIndex + 1;
            for (int colIndex = 0; colIndex < cells.length; colIndex++) {
                CellExtra cell = cells[colIndex];
                String expression = cell.getDataSource();
                if (StringUtils.isNotBlank(expression)) {
                    String text = ObjectUtils.objectToString(executer.read(expression));
                    this.writeCellValue(configuration, table, rowIndex, colIndex, text, uri);
                }
            }
            executer.notifyEnd();
        }
        
    }
    
}
