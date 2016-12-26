/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.write.writer;

import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.BODY_ELEMENT;

import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFTable;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Node;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.document.word.docconfig.datatype.MergeCellType;
import com.comtop.cap.document.word.docconfig.model.DCTable;
import com.comtop.cap.document.word.docconfig.model.DCTableCell;
import com.comtop.cap.document.word.docconfig.model.DCTableRow;
import com.comtop.cap.document.word.docmodel.data.CellExtra;
import com.comtop.cap.document.word.docmodel.data.RowExtra;
import com.comtop.cap.document.word.docmodel.data.Table;
import com.comtop.cap.document.word.docmodel.data.TableExtra;
import com.comtop.cap.document.word.docmodel.style.CaptionType;
import com.comtop.cap.document.word.docmodel.style.TableMargin;
import com.comtop.cap.document.word.expression.ExpressionExecuteHelper;
import com.comtop.cap.document.word.write.DocxExportConfiguration;
import com.comtop.cap.document.word.write.DocxHelper;
import com.comtop.cap.document.word.write.ExportException;

/**
 * 表格写入器
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月23日 lizhongwen
 */
public abstract class TableWriter extends FragmentWriter<DCTable> {
	
	/**
     * logger
     */
    protected static final Logger LOGGER = LoggerFactory.getLogger(TableWriter.class);
    
    /** 最大列数 */
    protected static final int MAX_COLUMN = 63;
    
    /**
     * 将数据写入到单元格
     * 
     * @param config 文档导出配置
     * @param table 表格
     * @param rowIndex 行索引
     * @param colIndex 列索引
     * @param text 数据
     * @param uri 文档uri
     */
    protected void writeCellValue(final DocxExportConfiguration config, final XWPFTable table, final int rowIndex,
        final int colIndex, final String text, final String uri) {
        if (StringUtils.isBlank(text)) {
            return;
        }
        DocxHelper helper = DocxHelper.getInstance();
        Document document = Jsoup.parseBodyFragment(text);
        if (document != null) {
            Node body = document.body();
            IDocxFragmentWriter<Node> writer = DocxFragmentWriterFactory.getFragementWriter(body, BODY_ELEMENT);
            if (writer != null && writer instanceof ParagraphAppendWriter) {
                @SuppressWarnings("unchecked")
                ParagraphAppendWriter<Node> appender = (ParagraphAppendWriter<Node>) writer;
                appender.append(config, helper.getCellLastParagraph(table, rowIndex, colIndex), body, uri);
            } else {
                helper.setCellText(table, rowIndex, colIndex, document.text());
            }
        }
    }
    
    /**
     * 表格预处理
     *
     * @param table 表格配置
     * @param executer 表达式执行器
     * @return 预处理结果
     */
    protected TableExtra pretreatment(final DCTable table, final ExpressionExecuteHelper executer) {
        TableExtra extra = new TableExtra();
        extra.setDataSource(table.getMappingTo());
        extra.setRemark(table.getRemark());
        extra.setTitle(StringUtils.isBlank(table.getTitle()) ? table.getName() : table.getTitle());
        List<DCTableRow> rows = table.getRows();
        int rowNum = rows.size();
        List<TableMargin> margins = new ArrayList<TableMargin>(rowNum);
        extra.setMargins(margins);
        RowExtra[] rowExtras = new RowExtra[rowNum];
        extra.setRows(rowExtras);
        for (int rowIndex = 0; rowIndex < rowNum; rowIndex++) {
            DCTableRow row = rows.get(rowIndex);
            RowExtra rowExtra = new RowExtra();
            rowExtra.setDataSource(row.getMappingTo());
            rowExtra.setExt(row.isExtRow());
            rowExtras[rowIndex] = rowExtra;
            List<DCTableCell> cells = row.getXmlCells();
            int configedColSize = cells.size();
            int colIndex = 0;
            for (int i = 0; i < configedColSize; i++) {
                DCTableCell cell = cells.get(i);
                for (TableMargin margin : margins) {
                    while (margin.getStartRowIndex() < rowIndex && margin.getEndRowIndex() >= rowIndex
                        && margin.getStartColIndex() <= colIndex && margin.getEndColIndex() >= colIndex) {
                        colIndex++;
                    }
                }
                if (cell.getRowspan() > 1 || cell.getColspan() > 1) {
                    TableMargin margin = new TableMargin(rowIndex, colIndex, rowIndex + cell.getRowspan() - 1, colIndex
                        + cell.getColspan() - 1);
                    margins.add(margin);
                }
                handleCell(rowIndex, colIndex, cell, extra, executer, configedColSize);
                colIndex += cell.getColspan();
            }
            // 单元格列扩展计算完成后，重算偏移量
            CellExtra[] cellExtras = extra.getCells()[rowIndex];
            for (colIndex = 0; colIndex < cellExtras.length; colIndex++) {
                CellExtra cellExtra = cellExtras[colIndex];
                if (cellExtra == null) {
                    continue;
                }
                if (cellExtra.isExtra()) {
                    calcExtraCell(rowIndex, colIndex, extra);
                }
            }
        }
        extra.reduce();
        return extra;
    }
    
    /**
     * 处理列配置
     *
     * @param rowIndex 行索引
     * @param colIndex 列索引
     * @param cell 单元格
     * @param extra 表格预处理缓存
     * @param executer 表达式执行器
     * @param configedColSize 配置列数
     */
    private void handleCell(final int rowIndex, final int colIndex, final DCTableCell cell, final TableExtra extra,
        final ExpressionExecuteHelper executer, final int configedColSize) {
        CellExtra cellExtra = new CellExtra();
        cellExtra.setExtra(Boolean.FALSE);
        cellExtra.setWidth(cell.getWidth());
        cellExtra.setHeader(cell.getHeaderName());
        cellExtra.setRowspan(cell.getRowspan());
        cellExtra.setColspan(cell.getColspan());
        cellExtra.setDataSource(cell.getMappingTo());
        cellExtra.setKeyExpr(cell.getValueKeyExpr());
        cellExtra.setLabel(cell.getHeaderLabelExpr());
        extra.setCell(rowIndex, colIndex, cellExtra);
        MergeCellType merge = cell.getMergeCellType();
        if (MergeCellType.VERTICAL.equals(merge)) {
            cellExtra.setAutoMerge(Boolean.TRUE);
        }
        if (cell.isExtCell()) { // 扩展列
            handleExtCell(rowIndex, colIndex, cell, extra, executer, configedColSize);
        } else {
            cellExtra.setOccupy(cell.getColspan());
            if (cell.getRowspan() > 1 || cell.getColspan() > 1) {
                CellExtra addOn;
                for (int colExt = 0; colExt < cell.getColspan(); colExt++) {
                    for (int rowExt = 0; rowExt < cell.getRowspan(); rowExt++) {
                        if (colExt == 0 && rowExt == 0) {
                            continue;
                        }
                        addOn = new CellExtra();
                        addOn.setMerged(Boolean.TRUE);
                        addOn.setExtra(Boolean.FALSE);
                        addOn.setWidth(cellExtra.getWidth());
                        addOn.setColspan(cellExtra.getColspan());
                        addOn.setDataSource(cellExtra.getDataSource());
                        addOn.setKeyExpr(cellExtra.getKeyExpr());
                        addOn.setLabel(cellExtra.getLabel());
                        addOn.setOccupy(cellExtra.getOccupy());
                        addOn.setAutoMerge(cellExtra.isAutoMerge());
                        extra.setCell(rowIndex + rowExt, colIndex + colExt, addOn);
                    }
                }
            }
        }
    }
    
    /**
     * 处理扩展列配置
     *
     * @param rowIndex 行索引
     * @param colIndex 列索引
     * @param cell 单元格
     * @param extra 扩展缓存
     * @param executer 表达式执行器
     * @param configedColSize 配置列数
     */
    private void handleExtCell(final int rowIndex, final int colIndex, final DCTableCell cell, final TableExtra extra,
        final ExpressionExecuteHelper executer, final int configedColSize) {
        int expandColNum = 1;
        CellExtra parentExtra = extra.getCell(rowIndex - 1, colIndex); // 上级扩展对象
        String extDataSource = cell.getExtDataExpr();
        List<Object> cache = new ArrayList<Object>();
        List<?> datas = null;
        String veriable = null;
        if (parentExtra == null || !parentExtra.isExtra()) {
            if (StringUtils.isNotBlank(extDataSource)) {
                veriable = executer.readReference(extDataSource);
                datas = (List<?>) executer.read(extDataSource);
            }
            if (datas != null && !datas.isEmpty()) {
                expandColNum = datas.size();
                cache.addAll(datas);
            }
        } else {
            String pV = parentExtra.getVeriable();
            List<?> pD = parentExtra.getData();
            int[] parentSlots = parentExtra.getSlots();
            if (StringUtils.isNotBlank(pV) && pD != null) {
                executer.write(pV, pD);
                for (int i = 0; i < pD.size(); i++) {
                    executer.notifyStart();
                    int colNum = 1;
                    if (StringUtils.isNotBlank(extDataSource)) {
                        veriable = executer.readReference(extDataSource);
                        datas = (List<?>) executer.read(extDataSource);
                    }
                    if (datas != null && !datas.isEmpty()) {
                        colNum = datas.size();
                        cache.addAll(datas);
                    } else {
                        cache.add(null);// 占位
                    }
                    executer.notifyEnd();
                    parentSlots[i] = colNum;
                    expandColNum = i == 0 ? colNum : (expandColNum + colNum);
                }
                parentExtra.setOccupy(expandColNum);
            }
        }
        CellExtra cellExtra = extra.getCell(rowIndex, colIndex);
        cellExtra.setExtra(Boolean.TRUE);
        cellExtra.setData(cache);
        cellExtra.setVeriable(veriable);
        int[] slots = new int[expandColNum];
        Arrays.fill(slots, 1);
        cellExtra.setSlots(slots);
        Object[] keys = new Object[expandColNum];
        cellExtra.setKeys(keys);
        if (StringUtils.isNotBlank(veriable)) {
            executer.write(veriable, cache);
        }
    }
    
    /**
     * 重算影响到的单元格的占位和偏移
     *
     * @param rowIndex 行索引
     * @param colIndex 列索引
     * @param extra 扩展缓存
     */
    private void calcExtraCell(final int rowIndex, final int colIndex, final TableExtra extra) {
        CellExtra[] currentRow = extra.getCells()[rowIndex];
        CellExtra currentCell = currentRow[colIndex];
        int occupy = currentCell.getSlots().length;
        CellExtra cell;
        CellExtra temp;
        for (int i = rowIndex; i >= 0; i--) {
            CellExtra[] rowCells = extra.getCells()[i];
            int variation = occupy;// 对于一行偏移量的变化应该一致，且为（当前占位数-原占位数）
            if (i < rowIndex) { // 将扩展单元格的上方单元格进行重算所占格数
                cell = extra.getCell(i, colIndex);
                if (extra != null) {
                    variation = occupy - cell.getOccupy();
                    cell.setOccupy(occupy);
                    if (cell.isExtra() && i < rowIndex) {
                        temp = extra.getCell(i + 1, colIndex);
                        int[] childSlots = temp.getSlots();
                        int[] slots = cell.getSlots();
                        for (int j = 0, m = 0; j < slots.length; j++) {
                            int value = 0;
                            for (int k = 0; k < slots[j]; k++, m++) {
                                value += childSlots[m];
                            }
                            slots[j] = value;
                        }
                    }
                }
            }
            for (int j = colIndex + 1, colNum = rowCells.length; j < colNum; j++) {// 将右侧的单元格重新计算偏移量
                cell = rowCells[j];
                if (cell == null || cell.isMerged()) {
                    continue;
                }
                cell.setOffset(cell.getOffset() + variation);
                updateMargin(i, j, variation, colNum, extra.getMargins());
            }
        }
    }
    
    /**
     * 更新列扩展后，单元格合并信息
     * 
     * @param rowIndex 行索引
     * @param colIndex 列索引
     * @param variation 偏移量
     * @param colNum 最大列数
     * @param margins 原始的单元格合并信息
     */
    private void updateMargin(int rowIndex, int colIndex, int variation, int colNum, List<TableMargin> margins) {
        for (TableMargin margin : margins) {
            int startRowIndex = margin.getStartRowIndex();
            int endRowIndex = margin.getEndRowIndex();
            if (rowIndex == startRowIndex && rowIndex <= endRowIndex) {// 只需要在第一次出现的时候更新即可
                int begin = margin.getStartColIndex();
                int end = margin.getEndColIndex();
                if (colIndex <= end) {// 原合并单元格的结束位置是在动态扩展起始列之后
                    begin += variation;
                    end += variation;
                    margin.setStartColIndex(begin);
                    margin.setEndColIndex(end);
                }
            }
        }
    }
    
    /**
     * 计算表格最大列数
     *
     * @param table 表格预处理封装对象
     * @return 列数
     */
    protected int calcTableColumnCount(final TableExtra table) {
        int count = 0;
        CellExtra[][] tableCells = table.getCells();
        for (CellExtra[] rows : tableCells) {
            int temp = 0;
            for (CellExtra cell : rows) {
                if (cell.isExtra()) {// 列扩展
                    int[] slots = cell.getSlots();
                    for (int slot : slots) {
                        temp += slot;
                    }
                } else {
                    temp++;
                }
            }
            if (temp > count) {
                count = temp;
            }
        }
        return count;
    }
    
    /**
     * 计算表格最大列数
     *
     * @param table 表格
     * @return 列数
     */
    protected int calcTableColumnCount(DCTable table) {
        List<DCTableRow> rows = table.getRows();
        int count = 0;
        for (DCTableRow row : rows) {
            int temp = 0;
            for (DCTableCell cell : row.getXmlCells()) {
                temp += cell.getColspan();
            }
            if (temp > count) {
                count = temp;
            }
        }
        return count;
    }
    
    /**
     * 获取表格行数
     *
     * @param table 表格
     * @return 行数
     */
    protected int calcTableRowCount(final TableExtra table) {
        return table.getRows().length;
    }
    
    /**
     * 获取表格行数
     *
     * @param table 表格
     * @return 行数
     */
    protected int calcTableRowCount(Table table) {
        return table.getRows().size();
    }
    
    /**
     * 创建表格题注
     *
     * @param docx 文档对新浪
     * @param caption 题注
     */
    protected void createTableCaption(final XWPFDocument docx, final String caption) {
        DocxHelper helper = DocxHelper.getInstance();
        if (StringUtils.isNotBlank(caption)) {
            try {
                helper.createCaption(docx, CaptionType.TABLE, caption);
            } catch (Exception e) {
            	LOGGER.debug("error", e);
                helper.createEmptyParagraph(docx);
            }
        } else {
            helper.createEmptyParagraph(docx);
        }
    }
    
    /**
     * 是否章节溢出
     * 
     * @param columnNum 文档导出配置
     * @param uri 文档uri
     */
    protected void columnOverflow(final int columnNum, final String uri) {
        if (columnNum > MAX_COLUMN) {
            throw new ExportException(MessageFormat.format("位置''{0}'':该表格的列数为{1},超过允许的最大列数{2}，无法创建该表格。", uri,
                columnNum, MAX_COLUMN));
        }
    }
}
