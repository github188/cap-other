/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.parse.parser;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.xwpf.usermodel.IBodyElement;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFParagraph;
import org.apache.poi.xwpf.usermodel.XWPFTable;
import org.apache.poi.xwpf.usermodel.XWPFTableCell;
import org.apache.poi.xwpf.usermodel.XWPFTableRow;
import org.apache.xmlbeans.XmlCursor;
import org.apache.xmlbeans.XmlObject;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTRow;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTSdtCell;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTTc;

import com.comtop.cap.document.word.docconfig.datatype.CellContentType;
import com.comtop.cap.document.word.docconfig.datatype.DataStoreStrategy;
import com.comtop.cap.document.word.docconfig.datatype.TableType;
import com.comtop.cap.document.word.docconfig.model.ConfigElement;
import com.comtop.cap.document.word.docconfig.model.DCContainer;
import com.comtop.cap.document.word.docconfig.model.DCTable;
import com.comtop.cap.document.word.docconfig.model.DCTableCell;
import com.comtop.cap.document.word.docconfig.model.DCTableRow;
import com.comtop.cap.document.word.docmodel.data.CellContainer;
import com.comtop.cap.document.word.docmodel.data.Container;
import com.comtop.cap.document.word.docmodel.data.ContentSeg;
import com.comtop.cap.document.word.docmodel.data.ParagraphSet;
import com.comtop.cap.document.word.docmodel.data.Table;
import com.comtop.cap.document.word.docmodel.data.TableCell;
import com.comtop.cap.document.word.docmodel.data.TableRow;
import com.comtop.cap.document.word.docmodel.data.WordDocument;
import com.comtop.cap.document.word.parse.tohtml.XWPFTableConverter;
import com.comtop.cap.document.word.parse.util.ExprUtil;
import com.comtop.cap.document.word.parse.util.ValueUtil;
import com.comtop.cap.document.word.parse.util.XWPFTableUtil;

/**
 * 表格转换器
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年10月16日 lizhiyong
 */
public class TableParser extends DefaultParser {
    
    /** 必填值标识 */
    private final String requriedValueUri = "requriedValue";
    
    /** 段落转换器 */
    private final ParagraphParser paragraphParser;
    
    /**
     * 
     * 构造函数
     * 
     * @param document poi 文档
     * @param doc word文档
     * @param paragraphParser 段落转换器
     */
    public TableParser(XWPFDocument document, WordDocument doc, ParagraphParser paragraphParser) {
        super(document, doc);
        this.paragraphParser = paragraphParser;
    }
    
    /**
     * 解析Table
     *
     * @param table poiTable
     * @return 表格对象
     */
    public Table visitTable(XWPFTable table) {
        // 1) Compute colWidth
        float[] colWidths = XWPFTableUtil.computeColWidths(table);
        Table tc = new Table();
        tc.setXwpfTable(table);
        Container container = getCurrentContainer();
        // 将同级的上一个文本段落模型化
        DCTable definition = getTableDefinition(table, container);
        tc.setDefinition(definition);
        
        if (definition != null && definition.getType() != TableType.UNKNOWN) {
            ContentSeg contentSeg = container.getLastHtmlTextContent();
            ExprUtil.execHtmlText(expExecuter, contentSeg);
        }
        container.addChildElement(tc);
        if (definition != null && !definition.isNeedStore()) {
            // 表格有定义，且 不需要存储 直接返回
            return tc;
        }
        if (definition == null || definition.getType() == TableType.UNKNOWN) {
            if (definition == null) {
                checkLogger.warnTable(tc, "未找到表格定义");
            }
            // 表格未定义 或定义的类型为unknown ，则以非结构化文本存储
            XWPFTableConverter converter = new XWPFTableConverter(this.stylesDocument, this.paragraphParser);
            String html = converter.convertToHtml(table);
            tc.setContent(html);
            // tc.setType(TableType.UNKNOWN);
        } else {
            // 表格是已定义的结构化数据结构，则解析表格
            visitTableBody(table, colWidths, tc);
        }
        
        return tc;
    }
    
    /***
     * 
     * 获得指定章节下的表格定
     * 
     * @param table poi table
     * @param container 章节
     * @return 表格定义 ，未找到返回 null
     */
    private DCTable getTableDefinition(XWPFTable table, Container container) {
        DCContainer containerDef = (DCContainer) container.getDefinition();
        if (containerDef == null) {
            return null;
        }
        List<? extends ConfigElement> wtTables = containerDef.getElements(DCTable.class);
        if (wtTables == null) {
            return null;
        }
        return matchTableDefinition(table, wtTables);
    }
    
    /**
     * 匹配表格定义
     *
     * @param table poi table
     * @param tables 指定范围内的表格定义清单
     * @return 匹配的表格定义 未找到返回null
     */
    private DCTable matchTableDefinition(XWPFTable table, List<? extends ConfigElement> tables) {
        DCTable tableDef = null;
        DCTable tableDefRet = null;
        DCTable unknownTable = null;
        for (ConfigElement element : tables) {
            tableDef = (DCTable) element;
            switch (tableDef.getType()) {
                case EXT_ROWS:
                    tableDefRet = matchExtRowTable(tableDef, table);
                    if (tableDefRet != null) {
                        return tableDefRet;
                    }
                    break;
                case FIXED:
                    tableDefRet = matchFixedTable(tableDef, table);
                    if (tableDefRet != null) {
                        return tableDefRet;
                    }
                    break;
                case EXT_COLS:
                    tableDefRet = matchExtColTable(tableDef, table);
                    if (tableDefRet != null) {
                        return tableDefRet;
                    }
                    break;
                default:
                    unknownTable = tableDef;
                    break;
            }
        }
        return unknownTable;
    }
    
    /**
     * 匹配行扩展表
     *
     * @param wtTable 表格定义
     * @param table poi table
     * @return 匹配成功 返回表格定义 匹配失败 返回null
     */
    private DCTable matchExtRowTable(DCTable wtTable, XWPFTable table) {
        // DCTable tableDef = wtTable.clone();
        int index = wtTable.getRows().size();
        DCTableRow wtTr = wtTable.getRows().get(index - 1);
        XWPFTableRow row = table.getRows().get(index - 1);
        List<DCTableCell> cells = new ArrayList<DCTableCell>(wtTr.getCells());
        boolean isMatch = false;
        int i = 0;
        for (XWPFTableCell cell : row.getTableCells()) {
            for (; i < cells.size();) {
                isMatch = matchCell(cells.get(i), cell);
                if (!isMatch) {
                    cells.remove(i);
                } else {
                    i++;
                    break;
                }
            }
        }
        if (cells.size() == wtTr.getCells().size()) {
            return wtTable;
        }
        return null;
        
    }
    
    /**
     * 简单匹配行扩展表
     *
     * @param wtTable 表格定义
     * @param table 待解析表格
     * @return true 匹配 false 不匹配
     */
    boolean simpleMatchExtRowTable(DCTable wtTable, XWPFTable table) {
        int index = wtTable.getRows().size();
        DCTableRow wtTr = wtTable.getRows().get(index - 1);
        XWPFTableRow row = table.getRows().get(index - 1);
        // 列不相等，返回false
        if (wtTr.getCells().size() != row.getTableCells().size()) {
            return false;
        }
        int i = 0;
        // 表头不相等，返回false
        for (DCTableCell wtTd : wtTr.getCells()) {
            if (!matchCell(wtTd, row.getCell(i))) {
                return false;
            }
            i++;
        }
        // 列与表头都一样，返回true
        return true;
    }
    
    /**
     * 匹配列扩展表
     *
     * @param wtTable 表格定义
     * @param table poi table
     * @return true 匹配成功 false 匹配失败
     */
    private DCTable matchExtColTable(DCTable wtTable, XWPFTable table) {
        // DCTable tableDef = wtTable.clone();
        List<DCTableRow> wtTrs = new ArrayList<DCTableRow>(wtTable.getRows());
        List<XWPFTableRow> rows = table.getRows();
        
        int i = 0;
        boolean isMatch = false;
        // 表头不相等，返回false
        for (XWPFTableRow xwpfTableRow : rows) {
            for (; i < wtTrs.size();) {
                isMatch = matchCell(wtTrs.get(i).getCells().get(0), xwpfTableRow.getCell(0));
                if (!isMatch) {
                    wtTrs.remove(i);
                } else {
                    i++;
                    break;
                }
            }
        }
        
        if (wtTrs.size() == rows.size()) {
            return wtTable;
        }
        return null;
        
    }
    
    /**
     * 匹配列扩展表
     *
     * @param wtTable 表格定义
     * @param table poi table
     * @return true 匹配成功 false 匹配失败
     */
    boolean simpleMatchExtColTable(DCTable wtTable, XWPFTable table) {
        List<DCTableRow> wtTrs = wtTable.getRows();
        List<XWPFTableRow> rows = table.getRows();
        
        // 行不相等，返回false
        if (wtTrs.size() != rows.size()) {
            return false;
        }
        int i = 0;
        // 表头不相等，返回false
        for (XWPFTableRow xwpfTableRow : rows) {
            if (!matchCell(wtTrs.get(i).getCells().get(0), xwpfTableRow.getCell(0))) {
                return false;
            }
            i++;
        }
        // 行与表头都一样，返回true
        return true;
    }
    
    /**
     * 匹配固定结构表
     *
     * @param wtTable 表格定义
     * @param table poi table
     * @return true 匹配成功 false 匹配失败
     */
    private DCTable matchFixedTable(DCTable wtTable, XWPFTable table) {
        // 行不相等，返回false
        if (wtTable.getRows().size() != table.getRows().size()) {
            return null;
        }
        int i = 0;
        // 每行的单元格数不相等，返回false
        for (DCTableRow wtTr : wtTable.getRows()) {
            if (wtTr.getCells().size() != table.getRow(i).getTableCells().size()) {
                return null;
            }
            i++;
        }
        // 行数与单元格数均相等，返回true
        return wtTable;
    }
    
    /**
     * 匹配固定结构表
     *
     * @param wtTable 表格定义
     * @param table poi table
     * @return true 匹配成功 false 匹配失败
     */
    boolean simpleMatchFixedTable(Table wtTable, XWPFTable table) {
        // 行不相等，返回false
        if (wtTable.getRows().size() != table.getRows().size()) {
            return false;
        }
        int i = 0;
        // 每行的单元格数不相等，返回false
        for (TableRow wtTr : wtTable.getRows()) {
            if (wtTr.getCells().size() != table.getRow(i).getTableCells().size()) {
                return false;
            }
            i++;
        }
        // 行数与单元格数均相等，返回true
        return true;
    }
    
    /**
     * 匹配单元格
     *
     * @param wtTd 单元格定义
     * @param cell poi 单元格
     * @return true 匹配成功 false 匹配失败
     */
    private boolean matchCell(DCTableCell wtTd, XWPFTableCell cell) {
        if (StringUtils.isNotBlank(wtTd.getMappingTo()) && StringUtils.isBlank(wtTd.getHeaderName())) {
            return true;
        }
        String sourceName = StringUtils.trim(cell.getText());
        String tempName = StringUtils.trim(wtTd.getHeaderName());
        // 比较文本是否完全相同
        boolean match = StringUtils.equals(sourceName, tempName);
        // 如果文本完全相同，返回true。否则进行正则判断
        return match ? true : matchString(wtTd.getTextPattern(), sourceName);
    }
    
    /**
     * 匹配字符串
     *
     * @param regex 模式字符串
     * @param input 待匹配字符串
     * @return true 表示能够匹配 false不能够匹配
     */
    private boolean matchString(Pattern regex, String input) {
        if (regex == null || StringUtils.isEmpty(input)) {
            return false;
        }
        boolean match = regex.matcher(input).find();
        // 反向匹配，很多情况可能不必要，先注释
        // if (!match) {
        // pattern = Pattern.compile(input2);
        // match = pattern.matcher(input1).find();
        // }
        return match;
    }
    
    /**
     * 解析表格体
     *
     * @param table poi表格
     * @param colWidths 列宽
     * @param tc 当前表格模型
     */
    private void visitTableBody(XWPFTable table, float[] colWidths, Table tc) {
        // Proces Row
        List<XWPFTableRow> rows = table.getRows();
        DCTable tableDefinition = (DCTable) tc.getDefinition();
        
        switch (tableDefinition.getType()) {
            case EXT_ROWS:
                visitExtRowTableRows(rows, colWidths, tableDefinition, tc);
                break;
            case FIXED:
                visitFixedTableRows(rows, colWidths, tableDefinition, tc);
                break;
            default:
                visitExtColTableRows(rows, colWidths, tableDefinition, tc);
                break;
        }
        
    }
    
    /**
     * 解析列扩展表格行
     *
     * @param rows poi行集
     * @param colWidths 列宽
     * @param tableDefinition 表格定义
     * @param tc tc
     */
    private void visitExtColTableRows(List<XWPFTableRow> rows, float[] colWidths, DCTable tableDefinition, Table tc) {
        List<DCTableCell> rowDefinitions = getColunmsDefinitions(tableDefinition);
        String mappingTo = tableDefinition.getMappingTo();
        int rowsSize = rows.size();
        List<Map<String, Object>> valueMapList = new ArrayList<Map<String, Object>>(10);
        TableRow tableRow = null;
        for (int i = 0; i < rowsSize; i++) {
            XWPFTableRow row = rows.get(i);
            tableRow = new TableRow();
            tc.addRow(tableRow);
            tableRow.setRowIndex(i);
            visitExtColTableRow(row, colWidths, tableRow, rowDefinitions, valueMapList);
        }
        // 将解析的结果添加到模型对象管理器中
        ExprUtil.startTable(expExecuter, tc);
        for (Map<String, Object> map : valueMapList) {
            // 如果当前数据中有数据不完整 即要求必填而未填，则放弃当条数据
            if (map != null && map.size() > 0 && map.get(requriedValueUri) == null) {
                String selectExpr = tableDefinition.getSelector();
                selectExpr = ExprUtil.getSelectExprWithType(expExecuter, tableDefinition, selectExpr, map);
                ExprUtil.execOneBizObject(expExecuter, selectExpr, mappingTo, map, getDoc(), tc.getContainer());
            }
        }
        ExprUtil.endTable(expExecuter, tc);
    }
    
    /**
     * 获得列定义
     *
     * @param tableDefinition xx
     * @return xx
     */
    private List<DCTableCell> getColunmsDefinitions(DCTable tableDefinition) {
        List<DCTableCell> rowDefinitions = new ArrayList<DCTableCell>(10);
        for (DCTableRow tableRow : tableDefinition.getRows()) {
            rowDefinitions.add(tableRow.getCells().get(0));
        }
        return rowDefinitions;
    }
    
    /**
     * 解析行扩展表格行
     *
     * @param row poi行
     * @param colWidths 列宽
     * @param tableRow 表格行
     * @param rowDefinitions 单元格定义
     * @param valueMapList 当前列扩展表的所有模型对象集
     */
    private void visitExtColTableRow(XWPFTableRow row, float[] colWidths, TableRow tableRow,
        List<DCTableCell> rowDefinitions, List<Map<String, Object>> valueMapList) {
        int nbColumns = colWidths.length;
        // Process cell
        List<XWPFTableCell> cells = row.getTableCells();
        if (nbColumns > cells.size()) {
            // Columns number is not equal to cells number.
            // POI have a bug with
            // <w:tr w:rsidR="00C55C20">
            // <w:tc>
            // <w:tc>...
            // <w:sdt>
            // <w:sdtContent>
            // <w:tc> <= this tc which is a XWPFTableCell is not included in the row.getTableCells();
            
            int cellIndex = -1;
            CTRow ctRow = row.getCtRow();
            XmlCursor c = ctRow.newCursor();
            c.selectPath("./*");
            while (c.toNextSelection()) {
                XmlObject o = c.getObject();
                if (o instanceof CTTc) {
                    CTTc tc = (CTTc) o;
                    XWPFTableCell cell = row.getTableCell(tc);
                    cellIndex++;
                    
                    TableCell tableCell = new TableCell();
                    tableCell.setCellIndex(cellIndex);
                    tableCell.setRowIndex(tableRow.getRowIndex());
                    tableRow.addCell(tableCell);
                    
                    visitExtColTableCell(cell, rowDefinitions, tableCell, valueMapList);
                } else if (o instanceof CTSdtCell) {
                    // Fix bug of POI
                    CTSdtCell sdtCell = (CTSdtCell) o;
                    List<CTTc> tcList = sdtCell.getSdtContent().getTcList();
                    for (CTTc ctTc : tcList) {
                        XWPFTableCell cell = new XWPFTableCell(ctTc, row, row.getTable().getBody());
                        cellIndex++;
                        
                        TableCell tableCell = new TableCell();
                        tableCell.setCellIndex(cellIndex);
                        tableCell.setRowIndex(tableRow.getRowIndex());
                        tableRow.addCell(tableCell);
                        visitExtColTableCell(cell, rowDefinitions, tableCell, valueMapList);
                    }
                }
            }
            c.dispose();
        } else {
            // Column number is equal to cells number.
            for (int i = 0; i < cells.size(); i++) {
                XWPFTableCell cell = cells.get(i);
                TableCell tableCell = new TableCell();
                tableCell.setCellIndex(i);
                tableCell.setRowIndex(tableRow.getRowIndex());
                tableRow.addCell(tableCell);
                visitExtColTableCell(cell, rowDefinitions, tableCell, valueMapList);
            }
        }
    }
    
    /**
     * 解析行扩展表格行
     *
     * @param cell poi单元格
     * @param rowDefinitions 单元格定义
     * @param tableCell 单元格
     * @param valueMapList 值集
     */
    private void visitExtColTableCell(XWPFTableCell cell, List<DCTableCell> rowDefinitions, TableCell tableCell,
        List<Map<String, Object>> valueMapList) {
        int rowIndex = tableCell.getRowIndex();
        int cellIndex = tableCell.getCellIndex();
        int cellSpan = XWPFTableUtil.getCellSpan(cell);
        DCTableCell cellDefinition = rowDefinitions.get(rowIndex);
        
        List<XWPFTableCell> vMergedCells = XWPFTableUtil.getVMergedCells(cell, rowIndex, cellIndex);
        Map<String, Object> valueMap = getModelObject(valueMapList, cellIndex);
        
        // 如果当前单元格的cellspan大于0，即当前单元格有横向合并的情况，则对每个横向合并的单元格进行处理。
        String mappingTo = cellDefinition.getMappingTo();
        if (StringUtils.isBlank(mappingTo)) {
            return;
        }
        Object value = null;
        if (vMergedCells == null || vMergedCells.size() > 0) {
            value = calCellData(cell, tableCell, cellDefinition, valueMap);
        } else {
            // 否则表示当前单元格是纵向合并单元格中的非第一个单元格，则从其上一行中对应的单元格中取值。
            DCTableCell precellDefinition = rowDefinitions.get(rowIndex - 1);
            mappingTo = precellDefinition.getMappingTo();
            if (StringUtils.isNotBlank(mappingTo)) {
                value = valueMap.get(mappingTo);
                valueMap.put(cellDefinition.getMappingTo(), value);
            }
        }
        
        if (cellSpan > 1) {
            for (int i = 1; i < cellSpan; i++) {
                Map<String, Object> nextValueMap = getModelObject(valueMapList, cellIndex + i);
                nextValueMap.put(cellDefinition.getMappingTo(), value);
            }
        }
    }
    
    /**
     * 处理合并单元格的第一个单元格或非合并单元格的数据
     *
     * @param cell 单元格
     * @param tableCell 单元格对象
     * @param cellDef 单元格定义
     * @param valueMap 值集
     * @return 值
     */
    private Object calCellData(XWPFTableCell cell, TableCell tableCell, DCTableCell cellDef,
        Map<String, Object> valueMap) {
        String mappingTo = cellDef.getMappingTo();
        if (StringUtils.isBlank(mappingTo) || cellDef.getStoreStrategy() == DataStoreStrategy.NO_STORE) {
            return null;
        }
        // 如果当前单元格不是合并过的单元格，或者是合并单元格的纵向合并的第一个，则直接取值
        String strValue = null;
        if (cellDef.getContentType() == CellContentType.SIMPLEX) {
            strValue = ValueUtil.getValue(cell.getText());
        } else {
            // 复合内容处理
            CellContainer cellContainer = visitTableCellBody(cell);
            if (cellContainer.getLastHtmlTextContent() != null) {
                strValue = cellContainer.getLastHtmlTextContent().getContent();
            }
        }
        
        if (!cellDef.isNullAble() && (StringUtils.isBlank(strValue))) {
            checkLogger.errorCell(tableCell, "单元格内容不允许为空");
            valueMap.put(requriedValueUri, mappingTo);
        } else {
            if (StringUtils.isNotBlank(strValue) || cellDef.getStoreStrategy() != DataStoreStrategy.NULL_VALUE_NO_STORE) {
                valueMap.put(mappingTo, strValue);
            }
        }
        return strValue;
    }
    
    /**
     * 解析行扩展表格行
     *
     * @param rows poi行集
     * @param colWidths 列宽
     * @param tableDefinition 表格定义
     * @param tc tc
     */
    private void visitExtRowTableRows(List<XWPFTableRow> rows, float[] colWidths, DCTable tableDefinition, Table tc) {
        // List<TableRow> rowDefs = tableDefinition.getRows();
        // List<TableCell> cellDefinitions = rowDefs.get(rowDefs.size() - 1).getCells();
        String mappingTo = tableDefinition.getMappingTo();
        int rowsSize = rows.size();
        int index = tableDefinition.getRows().size();
        List<DCTableCell> definitions = tableDefinition.getRow(index - 1).getCells();
        List<Map<String, Object>> valueMapList = new ArrayList<Map<String, Object>>(10);
        for (int i = 0; i < rowsSize; i++) {
            // 表格相匹配，至少要表头相同。因此如果表格的 行号<表格定义的行数 表示当前行是表头
            if (i < tableDefinition.getRows().size()) {
                continue;
            }
            XWPFTableRow row = rows.get(i);
            // boolean isHeaderRow = XWPFTableUtil.isTableRowHeader(row.getCtRow());
            // if (!isHeaderRow) {
            TableRow tableRow = new TableRow();
            tableRow.setRowIndex(i);
            tc.addRow(tableRow);
            visitExtRowTableRow(row, colWidths, definitions, valueMapList, tableRow);
            // }
        }
        ExprUtil.startTable(expExecuter, tc);
        // 将解析的结果添加到模型对象管理器中
        
        for (Map<String, Object> map : valueMapList) {
            // 如果当前数据中有数据不完整 即要求必填而未填，则放弃当条数据
            if (map != null && map.size() > 0 && map.get(requriedValueUri) == null) {
                String selectExpr = tableDefinition.getSelector();
                selectExpr = ExprUtil.getSelectExprWithType(expExecuter, tableDefinition, selectExpr, map);
                ExprUtil.execOneBizObject(expExecuter, selectExpr, mappingTo, map, getDoc(), tc.getContainer());
            }
        }
        ExprUtil.endTable(expExecuter, tc);
    }
    
    /**
     * 解析行扩展表格行
     *
     * @param row poi行
     * @param colWidths 列宽
     * @param definitions 表格定义
     * @param valueMapList 前一行的数据
     * @param tableRow 表格行
     */
    private void visitExtRowTableRow(XWPFTableRow row, float[] colWidths, List<DCTableCell> definitions,
        List<Map<String, Object>> valueMapList, TableRow tableRow) {
        int nbColumns = colWidths.length;
        // Process cell
        List<XWPFTableCell> cells = row.getTableCells();
        int rowIndex = tableRow.getRowIndex();
        if (nbColumns > cells.size()) {
            // Columns number is not equal to cells number.
            // POI have a bug with
            // <w:tr w:rsidR="00C55C20">
            // <w:tc>
            // <w:tc>...
            // <w:sdt>
            // <w:sdtContent>
            // <w:tc> <= this tc which is a XWPFTableCell is not included in the row.getTableCells();
            
            int cellIndex = -1;
            CTRow ctRow = row.getCtRow();
            XmlCursor c = ctRow.newCursor();
            c.selectPath("./*");
            while (c.toNextSelection()) {
                XmlObject o = c.getObject();
                if (o instanceof CTTc) {
                    CTTc tc = (CTTc) o;
                    XWPFTableCell cell = row.getTableCell(tc);
                    cellIndex++;
                    TableCell tableCell = new TableCell();
                    tableCell.setCellIndex(cellIndex);
                    tableCell.setRowIndex(rowIndex);
                    tableRow.addCell(tableCell);
                    visitExtRowTableCell(cell, definitions, tableCell, valueMapList);
                } else if (o instanceof CTSdtCell) {
                    // Fix bug of POI
                    CTSdtCell sdtCell = (CTSdtCell) o;
                    List<CTTc> tcList = sdtCell.getSdtContent().getTcList();
                    for (CTTc ctTc : tcList) {
                        XWPFTableCell cell = new XWPFTableCell(ctTc, row, row.getTable().getBody());
                        cellIndex++;
                        TableCell tableCell = new TableCell();
                        tableCell.setCellIndex(cellIndex);
                        tableCell.setRowIndex(rowIndex);
                        tableRow.addCell(tableCell);
                        visitExtRowTableCell(cell, definitions, tableCell, valueMapList);
                    }
                }
            }
            c.dispose();
        } else {
            // Column number is equal to cells number.
            for (int i = 0; i < cells.size(); i++) {
                XWPFTableCell cell = cells.get(i);
                TableCell tableCell = new TableCell();
                tableCell.setCellIndex(i);
                tableCell.setRowIndex(rowIndex);
                tableRow.addCell(tableCell);
                visitExtRowTableCell(cell, definitions, tableCell, valueMapList);
            }
        }
    }
    
    /**
     * 解析行扩展表格行
     *
     * @param cell poi单元格
     * @param definitions 单元格定义
     * @param tableCell 列号
     * @param valueMapList 表格的所有模型对象集
     */
    private void visitExtRowTableCell(XWPFTableCell cell, List<DCTableCell> definitions, TableCell tableCell,
        List<Map<String, Object>> valueMapList) {
        DCTableCell cellDef = definitions.get(tableCell.getCellIndex());
        
        Map<String, Object> valueMap = getModelObject(valueMapList, tableCell.getRowIndex());
        
        int cellSpan = XWPFTableUtil.getCellSpan(cell);
        List<XWPFTableCell> vMergedCells = XWPFTableUtil.getVMergedCells(cell, tableCell.getRowIndex(),
            tableCell.getCellIndex());
        
        Object value = null;
        if (vMergedCells == null || vMergedCells.size() > 0) {
            // 当前单元格是纵向合并单元格的第一个单元格或非合并单元格
            value = calCellData(cell, tableCell, cellDef, valueMap);
        } else {
            // 否则表示当前单元格是纵向合并单元格中的非第一个单元格。
            value = calMergedCellData(tableCell, valueMapList, cellDef, valueMap);
        }
        // 如果当前单元格的cellspan大于1，即当前单元格有横向合并的情况，则对每个横向合并的单元格进行处理。
        if (cellSpan > 1) {
            for (int j = 1; j < cellSpan; j++) {
                DCTableCell tempDefinition = definitions.get(tableCell.getCellIndex() + j);
                String mappingTo = tempDefinition.getMappingTo();
                if (StringUtils.isNotBlank(mappingTo)) {
                    valueMap.put(mappingTo, value);
                }
            }
        }
    }
    
    /**
     * 计算非第一个合并单元格的数据
     *
     * @param tableCell 单元格
     * @param valueMapList 对象集
     * @param cellDef 单元格定义
     * @param valueMap 值集
     * @return 对象
     */
    private Object calMergedCellData(TableCell tableCell, List<Map<String, Object>> valueMapList, DCTableCell cellDef,
        Map<String, Object> valueMap) {
        String mappingTo = cellDef.getMappingTo();
        if (StringUtils.isBlank(mappingTo) || cellDef.getStoreStrategy() == DataStoreStrategy.NO_STORE) {
            return null;
        }
        Map<String, Object> preRowData = valueMapList.get(tableCell.getRowIndex() - 1);
        if (preRowData == null) {
            return null;
        }
        Object value = preRowData.get(mappingTo);
        String strValue = (value == null ? null : value.toString());
        if (!cellDef.isNullAble() && (StringUtils.isBlank(strValue))) {
            checkLogger.errorCell(tableCell, "单元格内容不允许为空");
            valueMap.put(requriedValueUri, mappingTo);
        } else {
            if (StringUtils.isNotBlank(strValue) || cellDef.getStoreStrategy() != DataStoreStrategy.NULL_VALUE_NO_STORE) {
                valueMap.put(mappingTo, strValue);
            }
        }
        return value;
    }
    
    /**
     * 解析固定结构表
     * 
     * @param rows poi表格行集
     * @param colWidths 列宽
     * @param tableDefinition 表格定义
     * @param tc 表格对象
     *
     */
    private void visitFixedTableRows(List<XWPFTableRow> rows, float[] colWidths, DCTable tableDefinition, Table tc) {
        int rowsSize = rows.size();
        Map<String, Object> valueMap = new HashMap<String, Object>();
        TableRow tableRow = null;
        for (int i = 0; i < rowsSize; i++) {
            XWPFTableRow row = rows.get(i);
            tableRow = new TableRow();
            tc.addRow(tableRow);
            tableRow.setRowIndex(i);
            List<DCTableCell> tableCellDefinitions = tableDefinition.getRow(i).getCells();
            visitFixedTableRow(row, colWidths, tableRow, valueMap, tableCellDefinitions);
        }
        
        String mappingTo = tableDefinition.getMappingTo();
        
        // 如果当前数据中有数据不完整 即要求必填而未填，则放弃当条数据
        if (valueMap.get(requriedValueUri) != null) {
            return;
        }
        
        String selectExpr = tableDefinition.getSelector();
        if (StringUtils.isBlank(mappingTo)) {
            ExprUtil.addAttribute(expExecuter, valueMap);
        } else {
            selectExpr = ExprUtil.getSelectExprWithType(expExecuter, tableDefinition, selectExpr, valueMap);
            ExprUtil.execOneBizObjectOnFixTable(expExecuter, selectExpr, mappingTo, valueMap, getDoc(),
                tc.getContainer());
        }
    }
    
    /**
     * 解析行扩展表格行
     *
     * @param row poi行
     * @param colWidths 列宽
     * @param tableRow 表格行
     * @param valueMap 当前表格模型
     * @param tableCellDefs 单元格定义
     */
    private void visitFixedTableRow(XWPFTableRow row, float[] colWidths, TableRow tableRow,
        Map<String, Object> valueMap, List<DCTableCell> tableCellDefs) {
        
        int nbColumns = colWidths.length;
        // Process cell
        List<XWPFTableCell> cells = row.getTableCells();
        if (nbColumns > cells.size()) {
            int cellIndex = -1;
            CTRow ctRow = row.getCtRow();
            XmlCursor c = ctRow.newCursor();
            c.selectPath("./*");
            while (c.toNextSelection()) {
                XmlObject o = c.getObject();
                if (o instanceof CTTc) {
                    CTTc tc = (CTTc) o;
                    XWPFTableCell cell = row.getTableCell(tc);
                    cellIndex++;
                    
                    TableCell tableCell = new TableCell();
                    tableCell.setCellIndex(cellIndex);
                    tableCell.setRowIndex(tableRow.getRowIndex());
                    tableRow.addCell(tableCell);
                    
                    visitFixedTableCell(valueMap, tableCellDefs, tableCell, cell);
                } else if (o instanceof CTSdtCell) {
                    // Fix bug of POI
                    CTSdtCell sdtCell = (CTSdtCell) o;
                    List<CTTc> tcList = sdtCell.getSdtContent().getTcList();
                    for (CTTc ctTc : tcList) {
                        XWPFTableCell cell = new XWPFTableCell(ctTc, row, row.getTable().getBody());
                        cellIndex++;
                        TableCell tableCell = new TableCell();
                        tableCell.setCellIndex(cellIndex);
                        tableCell.setRowIndex(tableRow.getRowIndex());
                        tableRow.addCell(tableCell);
                        visitFixedTableCell(valueMap, tableCellDefs, tableCell, cell);
                    }
                }
            }
            c.dispose();
        } else {
            // Column number is equal to cells number.
            for (int i = 0; i < cells.size(); i++) {
                XWPFTableCell cell = cells.get(i);
                TableCell tableCell = new TableCell();
                tableCell.setCellIndex(i);
                tableCell.setRowIndex(tableRow.getRowIndex());
                tableRow.addCell(tableCell);
                visitFixedTableCell(valueMap, tableCellDefs, tableCell, cell);
            }
        }
        
    }
    
    /**
     * 处理固定结构表单元格
     *
     * @param valueMap 模型对象
     * @param tableCellDefs 单元格定义集
     * @param tableCell 单元格
     * @param cell poi cell
     */
    private void visitFixedTableCell(Map<String, Object> valueMap, List<DCTableCell> tableCellDefs,
        TableCell tableCell, XWPFTableCell cell) {
        DCTableCell cellDef = tableCellDefs.get(tableCell.getCellIndex());
        calCellData(cell, tableCell, cellDef, valueMap);
    }
    
    /**
     * 获得指定列索引下对应的模型对象，没有则创建。
     *
     * @param valueMapList 当前列扩展表的所有模型对象集
     * @param index 列索引
     * @return 指定列索引下对应的模型对象
     */
    private Map<String, Object> getModelObject(List<Map<String, Object>> valueMapList, int index) {
        if (index < 0) {
            return null;
        }
        Map<String, Object> valueMap = null;
        if (index < valueMapList.size()) {
            valueMap = valueMapList.get(index);
            if (valueMap == null) {
                valueMap = new HashMap<String, Object>(16);
                valueMapList.add(index, valueMap);
            }
            return valueMap;
        }
        for (int i = valueMapList.size(); i < index; i++) {
            valueMapList.add(i, null);
        }
        valueMap = new HashMap<String, Object>(16);
        valueMapList.add(index, valueMap);
        return valueMap;
    }
    
    /**
     * 解析单元格体.该 方法暂时无用。如果存在单元格内嵌套其它元素的情况，可能需要用。
     *
     * @param cell 单元格
     * @return cellContainer 容器
     */
    protected CellContainer visitTableCellBody(XWPFTableCell cell) {
        CellContainer cellContainer = new CellContainer();
        cellContainer.setDocument(getDoc());
        cellContainer.setDocConfig(getDoc().getDocConfig());
        List<IBodyElement> bodyElements = cell.getBodyElements();
        ParagraphSet paragraphSet = null;
        XWPFTableConverter tableConverter = new XWPFTableConverter(getStylesDocument(), this.paragraphParser);
        for (int i = 0; i < bodyElements.size(); i++) {
            IBodyElement bodyElement = bodyElements.get(i);
            switch (bodyElement.getElementType()) {
                case PARAGRAPH:
                    XWPFParagraph paragraph = (XWPFParagraph) bodyElement;
                    if (paragraphSet == null) {
                        paragraphSet = new ParagraphSet();
                        cellContainer.addChildElement(paragraphSet);
                    }
                    paragraphParser.visitParagraphInTableCell(paragraph, i, paragraphSet);
                    break;
                case TABLE:
                    String htmlTable = tableConverter.convertToHtml((XWPFTable) bodyElement);
                    Table table = new Table();
                    table.setContent(htmlTable);
                    // table.setType(TableType.UNKNOWN);
                    cellContainer.addChildElement(table);
                    paragraphSet = null;
                    break;
                default:
                    break;
            }
        }
        
        return cellContainer;
    }
}
