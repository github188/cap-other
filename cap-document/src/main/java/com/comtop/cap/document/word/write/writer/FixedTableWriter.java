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

import com.comtop.cap.document.util.CollectionUtils;
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
 * 固定的表格写入器
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月23日 lizhongwen
 */
public class FixedTableWriter extends TableWriter {
    
    /**
     * 根据文档配置写入固定表格文档片段
     *
     * @param docx 文档对象
     * @param tableConfig 固定表格配置元素
     * @param config 文档导出配置
     * @param uri 文档uri
     * @see com.comtop.cap.document.word.write.writer.FragmentWriter#internalWrite(com.comtop.cap.document.word.write.DocxExportConfiguration,org.apache.poi.xwpf.usermodel.XWPFDocument,
     *      java.lang.Object, java.lang.String)
     */
    @Override
    public void internalWrite(final DocxExportConfiguration config, final XWPFDocument docx, final DCTable tableConfig,
        final String uri) {
        ExpressionExecuteHelper executer = config.getExecuter();
        executer.notifyStart();
        String dataSource = tableConfig.getMappingTo();
        if (StringUtils.isNotBlank(dataSource)) {
            executer.read(dataSource);
        }
        TableExtra tableExtra = this.pretreatment(tableConfig, executer);
        DocxHelper helper = DocxHelper.getInstance();
        int colNum = calcTableColumnCount(tableExtra);
        int rowNum = calcTableRowCount(tableExtra, executer);
        try {
            this.columnOverflow(colNum, uri);
        } catch (Exception e) {
            executer.notifyEnd();
            this.getLogger().error(e.getMessage(), e);
            return;
        }
        XWPFTable table = helper.createTable(docx, rowNum, colNum);
        int rowIndex = 0;
        WriteType wirteType = WriteType.BOTH;
        RowExtra[] rows = tableExtra.getRows();
        int configedLastRowIndex = rows.length - 1;
        for (int i = 0; i < rows.length; i++) {
            RowExtra rowExtra = rows[i];
            if (rowExtra.isExt()) {
                String rowDataSource = rowExtra.getDataSource();
                fillTableCell(config, rowIndex, rowExtra, WriteType.TITLE, table, uri);
                rowIndex++;
                if (StringUtils.isNotBlank(rowDataSource)) {
                    Object datas = executer.read(rowDataSource);
                    if (datas != null && datas instanceof Collection) {
                        Collection<?> coll = (Collection<?>) datas;
                        for (int j = 0; j < coll.size(); j++) {
                            executer.notifyStart();
                            fillTableCell(config, rowIndex, rowExtra, WriteType.DATA, table, uri);
                            executer.notifyEnd();
                            rowIndex++;
                        }
                    } else {
                        rowIndex++;
                    }
                } else {
                    rowIndex++;
                }
            } else {
                fillTableCell(config, rowIndex, rowExtra, wirteType, table, uri);
                rowIndex++;
            }
        }
        int lastRowIndex = rowIndex - 1;
        boolean updateLastRowIndex = configedLastRowIndex != lastRowIndex;
        List<TableMargin> margins = tableExtra.getMargins();
        for (TableMargin margin : margins) {
            int startRowIndex = margin.getStartRowIndex();
            int endRowIndex = margin.getEndRowIndex();
            if (updateLastRowIndex && startRowIndex == configedLastRowIndex) {
                startRowIndex = lastRowIndex;
            }
            if (updateLastRowIndex && endRowIndex == configedLastRowIndex) {
                endRowIndex = lastRowIndex;
            }
            helper.mergeCells(table, startRowIndex, margin.getStartColIndex(), endRowIndex, margin.getEndColIndex());
        }
        this.createTableCaption(docx, tableConfig.getName());
        executer.notifyEnd();
    }
    
    /**
     * 填充表格
     *
     * @param config 文档导出配置
     * @param rowIndex 行索引
     * @param row 行配置
     * @param wirteType 写入方式
     * @param table 表格
     * @param uri 文档uri
     */
    private void fillTableCell(final DocxExportConfiguration config, final int rowIndex, final RowExtra row,
        final WriteType wirteType, final XWPFTable table, final String uri) {
        ExpressionExecuteHelper executer = config.getExecuter();
        DocxHelper helper = DocxHelper.getInstance();
        CellExtra[] cells = row.getCells();
        for (int colIndex = 0; colIndex < cells.length; colIndex++) {
            CellExtra cell = cells[colIndex];
            if (cell.isMerged()) { // 当前列在合并列中
                continue;
            }
            String text = cell.getHeader();
            if (StringUtils.isNotBlank(text) && !WriteType.DATA.equals(wirteType)) {
                helper.setCellStyle(table, rowIndex, colIndex, STYLE_TABLE_TITLE).setCellBackground(table, rowIndex,
                    colIndex, "F3F3F3");
            }
            float width = cell.getWidth();
            if (width > 0) {
                helper.setColWidth(table, colIndex, width);
            }
            if (!WriteType.TITLE.equals(wirteType)) {
                String expression = cell.getDataSource();
                if (StringUtils.isNotBlank(expression)) {
                    text = ObjectUtils.objectToString(executer.read(expression));
                }
                // if (StringUtils.isNotBlank(text)) {
                // text = Jsoup.parse(text).text();
                // }
            }
            writeCellValue(config, table, rowIndex, colIndex, text, uri);
            // helper.setCellText(table, rowIndex, colIndex, text);
        }
    }
    
    /**
     * 获取表格行数
     *
     * @param table 表格
     * @param executer 表达式执行器
     * @return 行数
     */
    protected int calcTableRowCount(final TableExtra table, final ExpressionExecuteHelper executer) {
        RowExtra[] rows = table.getRows();
        int rowNum = 0;
        for (RowExtra row : rows) {
            rowNum++;
            if (!row.isExt()) {
                continue;
            }
            String dataSource = row.getDataSource();
            int expandRowNum = 1;
            if (StringUtils.isNotBlank(dataSource)) {
                Object datas = executer.read(dataSource);
                if (datas != null && datas instanceof Collection && !CollectionUtils.isEmpty(((Collection<?>) datas))) {
                    expandRowNum = ((Collection<?>) datas).size();
                }
            }
            rowNum += expandRowNum;
            
        }
        return rowNum;
    }
    
    /**
     * 写入方式
     *
     * @author lizhongwen
     * @since jdk1.6
     * @version 2016年1月8日 lizhongwen
     */
    enum WriteType {
        /** 表头 */
        TITLE,
        /** 数据 */
        DATA,
        /** 混合 */
        BOTH;
    }
}
