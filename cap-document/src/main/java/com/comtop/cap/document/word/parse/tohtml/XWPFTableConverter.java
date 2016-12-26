/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.parse.tohtml;

import java.math.BigInteger;
import java.util.List;

import org.apache.poi.xwpf.usermodel.IBodyElement;
import org.apache.poi.xwpf.usermodel.XWPFParagraph;
import org.apache.poi.xwpf.usermodel.XWPFStyles;
import org.apache.poi.xwpf.usermodel.XWPFTable;
import org.apache.poi.xwpf.usermodel.XWPFTableCell;
import org.apache.poi.xwpf.usermodel.XWPFTableRow;
import org.apache.xmlbeans.XmlCursor;
import org.apache.xmlbeans.XmlObject;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTRow;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTSdtCell;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTTblPr;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTTc;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTTcPr;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.xml.sax.Attributes;
import org.xml.sax.helpers.AttributesImpl;

import com.comtop.cap.document.word.docmodel.data.CellContainer;
import com.comtop.cap.document.word.docmodel.data.ParagraphSet;
import com.comtop.cap.document.word.docmodel.style.BorderLocation;
import com.comtop.cap.document.word.docmodel.style.CSSStyle;
import com.comtop.cap.document.word.docmodel.style.TableCellBorder;
import com.comtop.cap.document.word.parse.parser.ParagraphParser;
import com.comtop.cap.document.word.parse.util.XWPFTableUtil;
import com.comtop.cap.document.word.util.ColorHelper;
import com.comtop.cap.document.word.util.SAXHelper;

/**
 * 表格转换器
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年11月3日 lizhiyong
 */
public class XWPFTableConverter {
    
    /** 简单handler */
    private final SimpleContentHandler contentHandler;
    
    /** 样式对象 */
    private final CSSStylesDocument stylesDocument;
    
    /** 日志对象 */
    private final Logger logger = LoggerFactory.getLogger(XWPFTableConverter.class);
    
    /** 段落解析器 */
    private final ParagraphParser paragraphParser;
    
    /**
     * 构造函数
     * 
     * @param styles 样式
     * @param paragraphParser 段落解析器
     */
    public XWPFTableConverter(XWPFStyles styles, ParagraphParser paragraphParser) {
        this.contentHandler = new SimpleContentHandler(0);
        this.paragraphParser = paragraphParser;
        stylesDocument = new CSSStylesDocument(styles, false, 0);
    }
    
    /**
     * 将XWPFTable转为html字符串
     *
     * @param table XWPFTable表格
     * @return 转换结果
     */
    public String convertToHtml(XWPFTable table) {
        // 1) Compute colWidth
        float[] colWidths = XWPFTableUtil.computeColWidths(table);
        startVisitTable(table, colWidths);
        visitTableBody(table, colWidths);
        endVisitTable(table);
        return this.contentHandler.getHtml();
    }
    
    /**
     * 开始处理表格
     *
     * @param table XWPFTable
     * @param colWidths 列数
     * @return x
     */
    private Object startVisitTable(XWPFTable table, float[] colWidths) {
        // 1) create attributes
        // 1.1) Create class attributes.
        AttributesImpl attributes = stylesDocument.createClassAttribute(table.getStyleID());
        
        // 1.2) Create "style" attributes.
        CTTblPr tblPr = table.getCTTbl().getTblPr();
        CSSStyle cssStyle = stylesDocument.createCSSStyle(tblPr);
        if (cssStyle != null) {
            cssStyle.addProperty(CSSStylesConstants.BORDER_COLLAPSE, CSSStylesConstants.BORDER_COLLAPSE_COLLAPSE);
        }
        attributes = stylesDocument.createStyleAttribute(cssStyle, attributes);
        
        // 2) create element
        startElement(HTMLConstants.TABLE_ELEMENT, attributes);
        return null;
    }
    
    /**
     * 处理表格体
     *
     * @param table XWPFTable
     * @param colWidths 列数
     */
    private void visitTableBody(XWPFTable table, float[] colWidths) {
        // Proces Row
        boolean firstRow = false;
        boolean lastRow = false;
        
        List<XWPFTableRow> rows = table.getRows();
        int rowsSize = rows.size();
        for (int i = 0; i < rowsSize; i++) {
            firstRow = (i == 0);
            // lastRow = isLastRow(i, rowsSize);
            XWPFTableRow row = rows.get(i);
            visitTableRow(row, colWidths, firstRow, lastRow, i, rowsSize);
        }
    }
    
    /**
     * 结束处理表格
     *
     * @param table XWPFTable
     */
    private void endVisitTable(XWPFTable table) {
        endElement(HTMLConstants.TABLE_ELEMENT);
    }
    
    /**
     * 处理表格行
     *
     * @param row x
     * @param colWidths x
     * @param firstRow x
     * @param lastRowIfNoneVMerge x
     * @param rowIndex x
     * @param rowsSize x
     */
    private void visitTableRow(XWPFTableRow row, float[] colWidths, boolean firstRow, boolean lastRowIfNoneVMerge,
        int rowIndex, int rowsSize) {
        
        boolean headerRow = XWPFTableUtil.isTableRowHeader(row.getCtRow());
        startVisitTableRow(row, rowIndex, headerRow);
        
        int nbColumns = colWidths.length;
        // Process cell
        boolean firstCol = true;
        boolean lastCol = false;
        boolean lastRow = false;
        List<XWPFTableCell> vMergedCells = null;
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
            
            firstCol = true;
            int cellIndex = -1;
            CTRow ctRow = row.getCtRow();
            XmlCursor c = ctRow.newCursor();
            c.selectPath("./*");
            while (c.toNextSelection()) {
                XmlObject o = c.getObject();
                if (o instanceof CTTc) {
                    CTTc tc = (CTTc) o;
                    XWPFTableCell cell = row.getTableCell(tc);
                    cellIndex = XWPFTableUtil.getCellIndex(cellIndex, cell);
                    lastCol = (cellIndex == nbColumns);
                    vMergedCells = XWPFTableUtil.getVMergedCells(cell, rowIndex, cellIndex);
                    if (vMergedCells == null || vMergedCells.size() > 0) {
                        lastRow = XWPFTableUtil.isLastRow(lastRowIfNoneVMerge, rowIndex, rowsSize, vMergedCells);
                        visitCell(cell, firstRow, lastRow, firstCol, lastCol, rowIndex, cellIndex, vMergedCells);
                    }
                    firstCol = false;
                } else if (o instanceof CTSdtCell) {
                    // Fix bug of POI
                    CTSdtCell sdtCell = (CTSdtCell) o;
                    List<CTTc> tcList = sdtCell.getSdtContent().getTcList();
                    for (CTTc ctTc : tcList) {
                        XWPFTableCell cell = new XWPFTableCell(ctTc, row, row.getTable().getBody());
                        cellIndex = XWPFTableUtil.getCellIndex(cellIndex, cell);
                        lastCol = (cellIndex == nbColumns);
                        List<XWPFTableCell> rowCells = row.getTableCells();
                        if (!rowCells.contains(cell)) {
                            rowCells.add(cell);
                        }
                        vMergedCells = XWPFTableUtil.getVMergedCells(cell, rowIndex, cellIndex);
                        if (vMergedCells == null || vMergedCells.size() > 0) {
                            lastRow = XWPFTableUtil.isLastRow(lastRowIfNoneVMerge, rowIndex, rowsSize, vMergedCells);
                            visitCell(cell, firstRow, lastRow, firstCol, lastCol, rowIndex, cellIndex, vMergedCells);
                        }
                        firstCol = false;
                    }
                }
            }
            c.dispose();
        } else {
            // Column number is equal to cells number.
            for (int i = 0; i < cells.size(); i++) {
                lastCol = (i == cells.size() - 1);
                XWPFTableCell cell = cells.get(i);
                vMergedCells = XWPFTableUtil.getVMergedCells(cell, rowIndex, i);
                if (vMergedCells == null || vMergedCells.size() > 0) {
                    lastRow = XWPFTableUtil.isLastRow(lastRowIfNoneVMerge, rowIndex, rowsSize, vMergedCells);
                    visitCell(cell, firstRow, lastRow, firstCol, lastCol, rowIndex, i, vMergedCells);
                }
                firstCol = false;
            }
        }
        
        endVisitTableRow(row, firstRow, lastRow, headerRow);
    }
    
    /**
     * 开始处理行
     *
     * @param row x
     * @param rowIndex x
     * @param headerRow x
     */
    private void startVisitTableRow(XWPFTableRow row, int rowIndex, boolean headerRow) {
        
        // 1) create attributes
        // Create class attributes.
        XWPFTable table = row.getTable();
        AttributesImpl attributes = stylesDocument.createClassAttribute(table.getStyleID());
        CSSStyle cssStyle = stylesDocument.createCSSStyle(row.getCtRow().getTrPr());
        attributes = stylesDocument.createStyleAttribute(cssStyle, attributes);
        // 2) create element
        // if (headerRow) {
        // startElement(XHTMLConstants.TH_ELEMENT, attributes);
        // } else {
        startElement(HTMLConstants.TR_ELEMENT, attributes);
        // }
    }
    
    /**
     * 结束处理行
     *
     * @param row x
     * @param firstRow x
     * @param lastRow x
     * @param headerRow x
     */
    private void endVisitTableRow(XWPFTableRow row, boolean firstRow, boolean lastRow, boolean headerRow) {
        // if (headerRow) {
        // endElement(XHTMLConstants.TH_ELEMENT);
        // } else {
        endElement(HTMLConstants.TR_ELEMENT);
        // }
    }
    
    /**
     * 处理单元格
     *
     * @param cell z
     * @param firstRow z
     * @param lastRow z
     * @param firstCol z
     * @param lastCol z
     * @param rowIndex z
     * @param cellIndex z
     * @param vMergedCells z
     */
    private void visitCell(XWPFTableCell cell, boolean firstRow, boolean lastRow, boolean firstCol, boolean lastCol,
        int rowIndex, int cellIndex, List<XWPFTableCell> vMergedCells) {
        startVisitTableCell(cell, firstRow, lastRow, firstCol, lastCol, vMergedCells);
        visitTableCellBody(cell, vMergedCells);
        endVisitTableCell(cell);
    }
    
    /**
     * 开始处理单元格
     *
     * @param cell x
     * @param firstRow x
     * @param lastRow x
     * @param firstCell x
     * @param lastCell x
     * @param vMergeCells x
     * @return x
     */
    private Object startVisitTableCell(XWPFTableCell cell, boolean firstRow, boolean lastRow, boolean firstCell,
        boolean lastCell, List<XWPFTableCell> vMergeCells) {
        // 1) create attributes
        // 1.1) Create class attributes.
        XWPFTableRow row = cell.getTableRow();
        XWPFTable table = row.getTable();
        AttributesImpl attributes = stylesDocument.createClassAttribute(table.getStyleID());
        
        // 1.2) Create "style" attributes.
        CTTcPr tcPr = cell.getCTTc().getTcPr();
        CSSStyle cssStyle = stylesDocument.createCSSStyle(tcPr);
        // At lease support solid borders for now
        if (cssStyle != null) {
            
            TableCellBorder border = XWPFTableUtil.getTableBorder(table, cell, BorderLocation.TOP);
            if (border != null && border.getBorderSize() != null) {
                String style = borderPx(border.getBorderSize()) + "px solid "
                    + ColorHelper.toHexString(border.getBorderColor());
                cssStyle.addProperty(CSSStylesConstants.BORDER_TOP, style);
            }
            
            border = XWPFTableUtil.getTableBorder(table, cell, BorderLocation.BOTTOM);
            if (border != null && border.getBorderSize() != null) {
                String style = borderPx(border.getBorderSize()) + "px solid "
                    + ColorHelper.toHexString(border.getBorderColor());
                cssStyle.addProperty(CSSStylesConstants.BORDER_BOTTOM, style);
            }
            
            border = XWPFTableUtil.getTableBorder(table, cell, BorderLocation.LEFT);
            if (border != null && border.getBorderSize() != null) {
                String style = borderPx(border.getBorderSize()) + "px solid "
                    + ColorHelper.toHexString(border.getBorderColor());
                cssStyle.addProperty(CSSStylesConstants.BORDER_LEFT, style);
            }
            
            border = XWPFTableUtil.getTableBorder(table, cell, BorderLocation.RIGHT);
            if (border != null && border.getBorderSize() != null) {
                String style = borderPx(border.getBorderSize()) + "px solid "
                    + ColorHelper.toHexString(border.getBorderColor());
                cssStyle.addProperty(CSSStylesConstants.BORDER_RIGHT, style);
            }
        }
        attributes = stylesDocument.createStyleAttribute(cssStyle, attributes);
        
        // colspan attribute
        BigInteger gridSpan = XWPFTableUtil.getTableCellGridSpan(cell.getCTTc());
        if (gridSpan != null) {
            attributes = SAXHelper.addAttrValue(attributes, HTMLConstants.COLSPAN_ATTR, gridSpan.intValue());
        }
        
        if (vMergeCells != null) {
            attributes = SAXHelper.addAttrValue(attributes, HTMLConstants.ROWSPAN_ATTR, vMergeCells.size());
        }
        
        // 2) create element
        startElement(HTMLConstants.TD_ELEMENT, attributes);
        
        return null;
    }
    
    /**
     * 小于1，返回1
     *
     * @param fBorderSize 计算出来的borderSize
     * @return borderSize
     */
    private float borderPx(Float fBorderSize) {
        float f1 = 1;
        if (fBorderSize < f1) {
            return f1;
        }
        return fBorderSize.floatValue();
    }
    
    /**
     * 处理单元格体
     *
     * @param cell x
     * @param vMergeCells x
     */
    private void visitTableCellBody(XWPFTableCell cell, List<XWPFTableCell> vMergeCells) {
        if (vMergeCells != null) {
            for (XWPFTableCell mergedCell : vMergeCells) {
                List<IBodyElement> bodyElements = mergedCell.getBodyElements();
                visitBodyElements(bodyElements);
            }
        } else {
            List<IBodyElement> bodyElements = cell.getBodyElements();
            visitBodyElements(bodyElements);
        }
    }
    
    /**
     * 处理body元素
     *
     * @param bodyElements xxx
     */
    private void visitBodyElements(List<IBodyElement> bodyElements) {
        // String previousParagraphStyleName = null;
        ParagraphSet paragraphSet = null;
        CellContainer cellContainer = new CellContainer();
        cellContainer.setDocument(paragraphParser.getDoc());
        cellContainer.setDocConfig(paragraphParser.getDoc().getDocConfig());
        for (int i = 0; i < bodyElements.size(); i++) {
            IBodyElement bodyElement = bodyElements.get(i);
            switch (bodyElement.getElementType()) {
                case PARAGRAPH:
                    XWPFParagraph paragraph = (XWPFParagraph) bodyElement;
                    // String paragraphStyleName = paragraph.getStyleID();
                    // boolean sameStyleBelow = (paragraphStyleName != null && paragraphStyleName
                    // .equals(previousParagraphStyleName));
                    // AttributesImpl currentRunAttributes =
                    // stylesDocument.createClassAttribute(paragraph.getStyleID());
                    // if (currentRunAttributes != null) {
                    // startElement(HTMLConstants.SPAN_ELEMENT, currentRunAttributes);
                    // }
                    // String text = paragraph.getText();
                    
                    if (paragraphSet == null) {
                        paragraphSet = new ParagraphSet();
                        cellContainer.addChildElement(paragraphSet);
                    }
                    paragraphParser.visitParagraphInTableCell(paragraph, i, paragraphSet);
                    
                    // if (StringUtils.isNotEmpty(text)) {
                    // Escape with HTML characters
                    // SAXHelper.characters(contentHandler, text);
                    // }
                    // if (currentRunAttributes != null) {
                    // endElement(HTMLConstants.SPAN_ELEMENT);
                    // }
                    break;
                case TABLE:
                    try {
                        if (paragraphSet != null) {
                            String htmlContent = paragraphSet.getContent();
                            SAXHelper.characters(contentHandler, htmlContent);
                            paragraphSet = null;
                        }
                        String htmlTable = convertToHtml((XWPFTable) bodyElement);
                        SAXHelper.characters(contentHandler, htmlTable);
                    } catch (Exception e) {
                        logger.error("解析表格中的表格时发生异常", e);
                    }
                    break;
                default:
                    break;
            }
        }
        if (paragraphSet != null) {
            String htmlContent = paragraphSet.getContent();
            SAXHelper.characters(contentHandler, htmlContent);
            paragraphSet = null;
        }
    }
    
    /**
     * 结束处理单元格
     *
     * @param cell x
     */
    private void endVisitTableCell(XWPFTableCell cell) {
        endElement(HTMLConstants.TD_ELEMENT);
    }
    
    /**
     * 开始元素
     *
     * @param name x
     * @param attributes x
     */
    private void startElement(String name, Attributes attributes) {
        SAXHelper.startElement(contentHandler, name, attributes);
    }
    
    /**
     * 结束元素
     *
     * @param name x
     */
    private void endElement(String name) {
        SAXHelper.endElement(contentHandler, name);
    }
}
