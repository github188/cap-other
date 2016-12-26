/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.parse.util;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;

import org.apache.poi.xwpf.usermodel.XWPFTable;
import org.apache.poi.xwpf.usermodel.XWPFTableCell;
import org.apache.poi.xwpf.usermodel.XWPFTableRow;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTBorder;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTDecimalNumber;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTOnOff;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTRow;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTShortHexNumber;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTTbl;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTTblBorders;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTTblCellMar;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTTblGrid;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTTblGridCol;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTTblPr;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTTblWidth;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTTc;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTTcBorders;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTTcPr;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTTrPr;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTVMerge;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.STBorder;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.STMerge;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.STMerge.Enum;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.STOnOff;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.STTblWidth;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Attr;

import com.comtop.cap.document.word.docmodel.style.BorderLocation;
import com.comtop.cap.document.word.docmodel.style.Color;
import com.comtop.cap.document.word.docmodel.style.TableCellBorder;
import com.comtop.cap.document.word.docmodel.style.TableWidth;
import com.comtop.cap.document.word.util.ColorHelper;
import com.comtop.cap.document.word.util.MeasurementUnits;

/**
 * XWPFTable帮助 类.本类的代码拷贝自第三方的实现，拷贝的目的在于不引第三方的jar包
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年10月23日 lizhiyong
 */
public class XWPFTableUtil {
    
    /** MAIN_NAMESPACE */
    private static final String MAIN_NAMESPACE = "http://schemas.openxmlformats.org/wordprocessingml/2006/main";
    
    /**
     * logger
     */
    protected static final Logger LOGGER = LoggerFactory.getLogger(XWPFTableUtil.class);
    
    /** Hexa Bitmask for tblLook. */
    public static final int DEFAULT_TBLLOOK = 0x0000;
    
    /** Apply first row conditional formatting */
    public static final int APPLY_FIRST_ROW_CONDITIONNAL_FORMATTING = 0x0020;
    
    /** Apply last row conditional formatting */
    public static final int APPLY_LAST_ROW_CONDITIONNAL_FORMATTING = 0x0040;
    
    /** Apply first column conditional formatting */
    public static final int APPLY_FIRST_COLUMN_CONDITIONNAL_FORMATTING = 0x0080;
    
    /** Apply last column conditional formatting */
    public static final int APPLY_LAST_COLUMN_CONDITIONNAL_FORMATTING = 0x0100;
    
    /** Do not apply row banding conditional formatting */
    public static final int DO_NOT_APPLY_ROW_BANDING_CONDITIONNAL_FORMATTING = 0x0200;
    
    /** Do not apply column banding conditional formatting */
    public static final int DO_NOT_APPLY_COLUMN_BANDING_CONDITIONNAL_FORMATTING = 0x0400;
    
    /**
     * 
     * 计算列宽
     *
     * @param table table
     * @return float[]
     */
    public static float[] computeColWidths(CTTbl table) {
        CTTblGrid grid = table.getTblGrid();
        List<CTTblGridCol> cols = getGridColList(grid);
        int nbColumns = cols.size();
        float[] colWidths = new float[nbColumns];
        float colWidth = -1;
        int nbColumnsToIgnoreBefore = 0;
        for (int i = nbColumnsToIgnoreBefore; i < colWidths.length; i++) {
            CTTblGridCol tblGridCol = cols.get(i);
            colWidth = tblGridCol.getW().floatValue();
            colWidths[i] = MeasurementUnits.dxa2points(colWidth);
        }
        return colWidths;
    }
    
    /**
     * Compute column widths of the XWPF table.
     * 
     * @param table t
     * @return float[]
     */
    public static float[] computeColWidths(XWPFTable table) {
        
        XWPFTableRow firstRow = getFirstRow(table);
        float[] colWidths;
        // Get first row to know if there is cell which have gridSpan to compute
        // columns number.
        int nbCols = getNumberOfColumns(firstRow);
        
        // Compare nbCols computed with number of grid colList
        CTTblGrid grid = table.getCTTbl().getTblGrid();
        List<CTTblGridCol> cols = getGridColList(grid);
        if (nbCols > cols.size()) {
            Collection<Float> maxColWidths = null;
            Collection<Float> currentColWidths = null;
            
            // nbCols computed is not equals to number of grid colList
            // columns width must be computed by looping for each row/cells
            List<XWPFTableRow> rows = table.getRows();
            for (XWPFTableRow row : rows) {
                currentColWidths = computeColWidths(row);
                if (maxColWidths == null) {
                    maxColWidths = currentColWidths;
                } else {
                    if (currentColWidths.size() > maxColWidths.size()) {
                        maxColWidths = currentColWidths;
                    }
                }
            }
            
            if (maxColWidths == null) {
                maxColWidths = new ArrayList<Float>();
            }
            
            colWidths = new float[maxColWidths.size()];
            int i = 0;
            for (Float colWidth : maxColWidths) {
                colWidths[i++] = colWidth;
            }
            return colWidths;
            
        }
        // If w:gridAfter is defined, ignore the last columns defined on the gridColumn
        int nbColumnsToIgnoreBefore = getNbColumnsToIgnore(firstRow, true);
        int nbColumnsToIgnoreAfter = getNbColumnsToIgnore(firstRow, false);
        int nbColumns = cols.size() - nbColumnsToIgnoreBefore - nbColumnsToIgnoreAfter;
        
        // nbCols computed is equals to number of grid colList
        // columns width can be computed by using the grid colList
        colWidths = new float[nbColumns];
        float colWidth = -1;
        for (int i = nbColumnsToIgnoreBefore; i < colWidths.length; i++) {
            CTTblGridCol tblGridCol = cols.get(i);
            colWidth = tblGridCol.getW().floatValue();
            colWidths[i] = MeasurementUnits.dxa2points(colWidth);
        }
        return colWidths;
    }
    
    /**
     * Returns number of column if the XWPF table by using the declared cell (which can declare gridSpan) from the first
     * row.
     * 
     * @param row t
     * @return i
     */
    public static int getNumberOfColumns(XWPFTableRow row) {
        if (row == null) {
            return 0;
        }
        // Get first row to know if there is cell which have gridSpan to compute
        // columns number.
        int nbCols = 0;
        List<XWPFTableCell> tableCellsOffFirstRow = row.getTableCells();
        for (XWPFTableCell tableCellOffFirstRow : tableCellsOffFirstRow) {
            CTDecimalNumber gridSpan = getGridSpan(tableCellOffFirstRow);
            if (gridSpan != null) {
                nbCols += gridSpan.getVal().intValue();
            } else {
                nbCols += 1;
            }
        }
        return nbCols;
    }
    
    /**
     * 获得第一行
     *
     * @param table t
     * @return XWPFTableRow
     */
    public static XWPFTableRow getFirstRow(XWPFTable table) {
        int numberOfRows = table.getNumberOfRows();
        if (numberOfRows > 0) {
            return table.getRow(0);
        }
        return null;
    }
    
    /**
     * 获得span值
     *
     * @param cell c
     * @return CTDecimalNumber
     */
    public static CTDecimalNumber getGridSpan(XWPFTableCell cell) {
        if (cell.getCTTc().getTcPr() != null)
            return cell.getCTTc().getTcPr().getGridSpan();
        
        return null;
    }
    
    /**
     * 获得单元格宽度
     *
     * @param cell c
     * @return CTTblWidth
     */
    public static CTTblWidth getWidth(XWPFTableCell cell) {
        return cell.getCTTc().getTcPr().getTcW();
    }
    
    /**
     * Returns table width of teh XWPF table.
     * 
     * @param table table
     * @return TableWidth
     */
    public static TableWidth getTableWidth(XWPFTable table) {
        float width = 0;
        boolean percentUnit = false;
        CTTblPr tblPr = table.getCTTbl().getTblPr();
        if (tblPr.isSetTblW()) {
            CTTblWidth tblWidth = tblPr.getTblW();
            return getTableWidth(tblWidth);
        }
        return new TableWidth(width, percentUnit);
    }
    
    /**
     * 获得表格宽度
     *
     * @param cell cell
     * @return TableWidth
     */
    public static TableWidth getTableWidth(XWPFTableCell cell) {
        float width = 0;
        boolean percentUnit = false;
        CTTcPr tblPr = cell.getCTTc().getTcPr();
        if (tblPr.isSetTcW()) {
            CTTblWidth tblWidth = tblPr.getTcW();
            return getTableWidth(tblWidth);
        }
        return new TableWidth(width, percentUnit);
    }
    
    /**
     * 获得表格宽度
     *
     * @param tblWidth tblWidth
     * @return TableWidth
     */
    public static TableWidth getTableWidth(CTTblWidth tblWidth) {
        if (tblWidth == null) {
            return null;
        }
        Float width = getTblWidthW(tblWidth);
        if (width == null) {
            return null;
        }
        boolean percentUnit = (STTblWidth.INT_PCT == tblWidth.getType().intValue());
        if (percentUnit) {
            width = width / 100f;
        } else {
            width = MeasurementUnits.dxa2points(width);
        }
        return new TableWidth(width, percentUnit);
    }
    
    /**
     * Returns the float value of <w:tblW w:w="9288.0" w:type="dxa" />
     * 
     * @param tblWidth tblWidth
     * @return Float
     */
    public static Float getTblWidthW(CTTblWidth tblWidth) {
        try {
            return tblWidth.getW().floatValue();
        } catch (Throwable e) {
        	LOGGER.debug("error.",e);
            // Sometimes w:w is a float value.Ex : <w:tblW w:w="9288.0" w:type="dxa" />
            // see https://code.google.com/p/xdocreport/issues/detail?id=315
            Attr attr = (Attr) tblWidth.getDomNode().getAttributes()
                .getNamedItemNS("http://schemas.openxmlformats.org/wordprocessingml/2006/main", "w");
            if (attr != null) {
                return Float.valueOf(attr.getValue());
            }
        }
        return null;
    }
    
    /**
     * 获得表格属性
     *
     * @param table table
     * @return CTTblPr
     */
    public static CTTblPr getTblPr(XWPFTable table) {
        CTTbl tbl = table.getCTTbl();
        if (tbl != null) {
            return tbl.getTblPr();
        }
        return null;
    }
    
    /**
     * 获得表格边框
     *
     * @param table table
     * @return CTTblBorders
     */
    public static CTTblBorders getTblBorders(XWPFTable table) {
        CTTblPr tblPr = getTblPr(table);
        if (tblPr != null) {
            return tblPr.getTblBorders();
        }
        return null;
    }
    
    /**
     * 获得表格单元格Mar
     *
     * @param table table
     * @return CTTblCellMar
     */
    public static CTTblCellMar getTblCellMar(XWPFTable table) {
        CTTblPr tblPr = getTblPr(table);
        if (tblPr != null) {
            return tblPr.getTblCellMar();
        }
        return null;
    }
    
    /**
     * 获得表格外观
     *
     * @param table t
     * @return CTShortHexNumber
     */
    public static CTShortHexNumber getTblLook(XWPFTable table) {
        CTTblPr tblPr = getTblPr(table);
        if (tblPr != null) {
            return tblPr.getTblLook();
        }
        return null;
        
    }
    
    /**
     * 获得表格外观变量
     *
     * @param table t
     * @return int
     */
    public static int getTblLookVal(XWPFTable table) {
        int tblLook = DEFAULT_TBLLOOK;
        CTShortHexNumber hexNumber = getTblLook(table);
        if (hexNumber != null && !hexNumber.isNil()) {
            // CTShortHexNumber#getVal() returns byte[] and not byte, use attr value ???
            Attr attr = (Attr) hexNumber.getDomNode().getAttributes().getNamedItemNS(MAIN_NAMESPACE, "val");
            if (attr != null) {
                String value = attr.getValue();
                try {
                    tblLook = Integer.parseInt(value, 16);
                } catch (Throwable e) {
                    e.printStackTrace();
                }
            }
        }
        return tblLook;
    }
    
    /**
     * 外观是否可以应用于第一行
     *
     * @param tblLookVal tblLookVal
     * @return boolean
     */
    public static boolean canApplyFirstRow(int tblLookVal) {
        int mask = APPLY_FIRST_ROW_CONDITIONNAL_FORMATTING;
        return (tblLookVal & mask) == mask;
    }
    
    /**
     * 外观是否可以应用于最后一行
     *
     * @param tblLookVal tblLookVal
     * @return boolean
     */
    public static boolean canApplyLastRow(int tblLookVal) {
        int mask = APPLY_LAST_ROW_CONDITIONNAL_FORMATTING;
        return (tblLookVal & mask) == mask;
    }
    
    /**
     * 外观是否可以应用于第一列
     *
     * @param tblLookVal tblLookVal
     * @return boolean
     */
    public static boolean canApplyFirstCol(int tblLookVal) {
        int mask = APPLY_FIRST_COLUMN_CONDITIONNAL_FORMATTING;
        return (tblLookVal & mask) == mask;
    }
    
    /**
     * 外观是否可以应用于最后一列
     *
     * @param tblLookVal tblLookVal
     * @return boolean
     */
    public static boolean canApplyLastCol(int tblLookVal) {
        int mask = APPLY_LAST_COLUMN_CONDITIONNAL_FORMATTING;
        return (tblLookVal & mask) == mask;
    }
    
    /**
     * For isBold, isItalic etc
     * 
     * @param onoff onoff
     * @return boolean
     */
    public static boolean isCTOnOff(CTOnOff onoff) {
        if (onoff == null) {
            return false;
        }
        if (!onoff.isSetVal())
            return true;
        if (onoff.getVal() == STOnOff.ON)
            return true;
        if (onoff.getVal() == STOnOff.TRUE)
            return true;
        if (onoff.getVal() == STOnOff.X_1)
            // sometimes bold, italic are with w="1". Ex : <w:i w:val="1" />
            // see https://code.google.com/p/xdocreport/issues/detail?id=315
            return true;
        return false;
    }
    
    /**
     * 是否是表头
     *
     * @param row 行
     * @return true 是 false 否
     */
    public static Boolean isTableRowHeader(CTRow row) {
        if (row == null) {
            return false;
        }
        CTTrPr trPr = row.getTrPr();
        if (trPr == null) {
            return false;
        }
        List<CTOnOff> headers = trPr.getTblHeaderList();
        if (headers != null && headers.size() > 0) {
            return XWPFTableUtil.isCTOnOff(headers.get(0));
        }
        return false;
    }
    
    /**
     * 是否最后一行
     *
     * @param lastRowIfNoneVMerge x
     * @param rowIndex x
     * @param rowsSize x
     * @param vMergedCells x
     * @return x
     */
    public static boolean isLastRow(boolean lastRowIfNoneVMerge, int rowIndex, int rowsSize,
        List<XWPFTableCell> vMergedCells) {
        if (vMergedCells == null) {
            return lastRowIfNoneVMerge;
        }
        return isLastRow(rowIndex - 1 + vMergedCells.size(), rowsSize);
    }
    
    /**
     * 是否最后一行
     *
     * @param rowIndex x
     * @param rowsSize x
     * @return x
     */
    public static boolean isLastRow(int rowIndex, int rowsSize) {
        return rowIndex == rowsSize - 1;
    }
    
    /**
     * 获得 列号
     *
     * @param cellIndex x
     * @param cell x
     * @return x
     */
    public static int getCellIndex(int cellIndex, XWPFTableCell cell) {
        BigInteger gridSpan = getTableCellGridSpan(cell.getCTTc());
        int iCellIndex = cellIndex;
        if (gridSpan != null) {
            iCellIndex = iCellIndex + gridSpan.intValue();
        } else {
            iCellIndex++;
        }
        return iCellIndex;
    }
    
    /**
     * 获得单元格合并的枚举值
     *
     * @param tc tc
     * @return Enum
     */
    public static Enum getTableCellVMerge(CTTc tc) {
        if (tc == null) {
            return null;
        }
        CTTcPr tcPr = tc.getTcPr();
        if (tcPr != null) {
            CTVMerge vMerge = tcPr.getVMerge();
            if (vMerge != null) {
                Enum val = vMerge.getVal();
                if (val == null) {
                    return STMerge.CONTINUE;
                }
                return val;
            }
        }
        return null;
    }
    
    /**
     * 获得纵向合并的单元格集合
     *
     * @param cell 单元 格
     * @param rowIndex 行号
     * @param cellIndex 列号
     * @return 集合
     */
    public static List<XWPFTableCell> getVMergedCells(XWPFTableCell cell, int rowIndex, int cellIndex) {
        List<XWPFTableCell> vMergedCells = null;
        STMerge.Enum vMerge = getTableCellVMerge(cell.getCTTc());
        if (vMerge != null) {
            if (vMerge.equals(STMerge.RESTART)) {
                // vMerge="restart"
                // Loop for each table cell of each row upon vMerge="restart" was found or cell without vMerge
                // was declared.
                vMergedCells = new ArrayList<XWPFTableCell>();
                vMergedCells.add(cell);
                
                XWPFTableRow row = null;
                XWPFTableCell c;
                XWPFTable table = cell.getTableRow().getTable();
                for (int i = rowIndex + 1; i < table.getRows().size(); i++) {
                    row = table.getRow(i);
                    c = row.getCell(cellIndex);
                    if (c == null) {
                        break;
                    }
                    vMerge = XWPFTableUtil.getTableCellVMerge(c.getCTTc());
                    if (vMerge != null && vMerge.equals(STMerge.CONTINUE)) {
                        
                        vMergedCells.add(c);
                    } else {
                        return vMergedCells;
                    }
                }
            } else {
                // vMerge="continue", ignore the cell because it was already processed
                return Collections.emptyList();
            }
        }
        return vMergedCells;
    }
    
    /**
     * 获得表格单元格边框
     *
     * @param table z
     * @param cell x
     * @param borderSide z
     * @return z
     */
    public static TableCellBorder getTableBorder(XWPFTable table, XWPFTableCell cell, BorderLocation borderSide) {
        CTTcBorders borders = cell.getCTTc().getTcPr().getTcBorders();
        CTBorder border = null;
        if (borders != null) {
            switch (borderSide) {
                case TOP:
                    border = borders.getTop();
                    break;
                case BOTTOM:
                    border = borders.getBottom();
                    break;
                case LEFT:
                    border = borders.getLeft();
                    break;
                default:
                    border = borders.getRight();
                    break;
            }
            if (border != null) {
                return getTableCellBorder(border, true);
            }
        }
        CTTblBorders tblBorders = table.getCTTbl().getTblPr().getTblBorders();
        if (tblBorders == null) {
            return null;
        }
        switch (borderSide) {
            case TOP:
                border = tblBorders.getTop();
                break;
            case BOTTOM:
                border = tblBorders.getBottom();
                break;
            case LEFT:
                border = tblBorders.getLeft();
                break;
            default:
                border = tblBorders.getRight();
                break;
        }
        return getTableCellBorder(border, false);
        
    }
    
    /**
     * 获得表格单元格边框
     *
     * @param border x
     * @param fromTableCell 经
     * @return x
     */
    public static TableCellBorder getTableCellBorder(CTBorder border, boolean fromTableCell) {
        if (border != null) {
            boolean noBorder = (STBorder.NONE == border.getVal() || STBorder.NIL == border.getVal());
            if (noBorder) {
                return new TableCellBorder(!noBorder, fromTableCell);
            }
            Float borderSize = null;
            BigInteger size = border.getSz();
            if (size != null) {
                // http://officeopenxml.com/WPtableBorders.php
                // if w:sz="4" => 1/4 points
                borderSize = size.floatValue() / 4f;
            }
            Color borderColor = ColorHelper.getBorderColor(border);
            return new TableCellBorder(borderSize, borderColor, fromTableCell);
        }
        return null;
    }
    
    /**
     * 获得单元格的列合并值
     *
     * @param cell 单元格
     * @return 合并个数
     */
    public static int getCellSpan(XWPFTableCell cell) {
        BigInteger gridSpan = getTableCellGridSpan(cell.getCTTc());
        return gridSpan == null ? 0 : gridSpan.intValue();
    }
    
    /**
     * 获得单元格的列合并值
     *
     * @param tc 单元格
     * @return null 没有 BigInteger 合并个数
     */
    public static BigInteger getTableCellGridSpan(CTTc tc) {
        if (tc == null) {
            return null;
        }
        CTTcPr tcPr = tc.getTcPr();
        if (tcPr == null) {
            return null;
        }
        CTDecimalNumber gridSpan = tcPr.getGridSpan();
        return gridSpan == null ? null : gridSpan.getVal();
    }
    
    /**
     * <w:gridCol list should be filtered to ignore negative value.
     * <p>
     * Ex : <w:gridCol w:w="-54" /> should be ignored. See https://code.google.com/p/xdocreport/issues/detail?id=315
     * </p>
     * 
     * @param grid grid
     * @return List<CTTblGridCol>
     */
    private static List<CTTblGridCol> getGridColList(CTTblGrid grid) {
        List<CTTblGridCol> newCols = new ArrayList<CTTblGridCol>();
        List<CTTblGridCol> cols = grid.getGridColList();
        for (CTTblGridCol col : cols) {
            if (col.getW().floatValue() >= 0) {
                newCols.add(col);
            }
        }
        return newCols;
    }
    
    /**
     * getNbColumnsToIgnore
     *
     * @param row row
     * @param before before
     * @return int
     */
    private static int getNbColumnsToIgnore(XWPFTableRow row, boolean before) {
        CTTrPr trPr = row.getCtRow().getTrPr();
        if (trPr == null) {
            return 0;
        }
        
        List<CTDecimalNumber> gridBeforeAfters = before ? trPr.getGridBeforeList() : trPr.getGridAfterList();
        if (gridBeforeAfters == null || gridBeforeAfters.size() < 1) {
            return 0;
        }
        int nbColumns = 0;
        BigInteger val = null;
        for (CTDecimalNumber gridBeforeAfter : gridBeforeAfters) {
            val = gridBeforeAfter.getVal();
            if (val != null) {
                nbColumns += val.intValue();
            }
        }
        
        return nbColumns;
    }
    
    /**
     * computeColWidths
     *
     * @param row r
     * @return Collection<Float>
     */
    private static Collection<Float> computeColWidths(XWPFTableRow row) {
        List<Float> colWidths = new ArrayList<Float>();
        List<XWPFTableCell> cells = row.getTableCells();
        for (XWPFTableCell cell : cells) {
            
            // Width
            CTTblWidth width = getWidth(cell);
            if (width != null) {
                int nb = 1;
                CTDecimalNumber gridSpan = getGridSpan(cell);
                TableWidth tableCellWidth = getTableWidth(cell);
                if (gridSpan != null) {
                    nb = gridSpan.getVal().intValue();
                }
                for (int i = 0; i < nb; i++) {
                    colWidths.add(tableCellWidth.width / nb);
                }
            }
        }
        return colWidths;
    }
    
}
