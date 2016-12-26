/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.write.writer;

import static com.comtop.cap.document.word.docmodel.style.Style.VAlign.CENTER;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.BODY_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.COLON_ENTITY;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.COLSPAN_ATTR;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.PERCENT_ENTITY;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.POUND_ENTITY;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.ROWSPAN_ATTR;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.SEMICOLON_ENTITY;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.STYLE_ATTR;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.TD_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.TH_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.TR_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.WIDTH_ATTR;
import static com.comtop.cap.document.word.write.DocxConstants.DEFAULT_TABLE_WIDTH;
import static com.comtop.cap.document.word.write.DocxConstants.STYLE_TABLE_TITLE;

import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFTable;
import org.jsoup.nodes.Element;
import org.jsoup.nodes.Node;
import org.jsoup.select.Elements;

import com.comtop.cap.document.word.docmodel.style.TableMargin;
import com.comtop.cap.document.word.parse.tohtml.HTMLConstants;
import com.comtop.cap.document.word.util.MeasurementUnits;
import com.comtop.cap.document.word.write.DocxExportConfiguration;
import com.comtop.cap.document.word.write.DocxHelper;
import com.comtop.cap.document.word.write.ExportException;

/**
 * HTML表格写入器
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月24日 lizhongwen
 */
public class TagTableWriter extends FragmentWriter<Element> {
    
    /** 最大列数 */
    protected static final int MAX_COLUMN = 63;
    
    /**
     * 根据文档配置写入文档表格片段
     *
     * @param config 文档导出配置
     * @param docx 文档对象
     * @param element 表格配置元素
     * @param uri 文档URI
     * @see com.comtop.cap.document.word.write.writer.FragmentWriter#internalWrite(com.comtop.cap.document.word.write.DocxExportConfiguration,
     *      org.apache.poi.xwpf.usermodel.XWPFDocument, java.lang.Object, java.lang.String)
     */
    @Override
    protected void internalWrite(final DocxExportConfiguration config, final XWPFDocument docx, final Element element,
        final String uri) {
        // TODO 表格样式
        DocxHelper helper = DocxHelper.getInstance();
        String tableCss = element.attr(STYLE_ATTR);
        Map<String, String> tableCssStyles = parseCss(tableCss);
        String tWidthValue = tableCssStyles.get(WIDTH_ATTR);
        float factor = 1f;
        if (StringUtils.isNotBlank(tWidthValue)) {
            factor = DEFAULT_TABLE_WIDTH / Float.parseFloat(tWidthValue);
        }
        int rowNum = this.getTableRowCount(element);
        int colNum = this.getTableColumnCount(element);
        try {
            this.columnOverflow(colNum, uri);
        } catch (Exception ex) {
            this.getLogger().error(ex.getMessage(), ex);
            return;
        }
        Elements elements = element.getElementsByTag(TR_ELEMENT);
        XWPFTable table = helper.createTable(docx, rowNum, colNum);
        Iterator<Element> iterator = elements.iterator();
        List<TableMargin> margins = new ArrayList<TableMargin>();
        int rowIndex = 0;
        while (iterator.hasNext()) { // tr
            Element e = iterator.next();
            if (e.getElementsByTag(TH_ELEMENT).size() > 0) {
                helper.setRowStyle(table, rowIndex, STYLE_TABLE_TITLE).setRowBackground(table, rowIndex, "F3F3F3")
                    .setRowAlign(table, rowIndex, CENTER, null);
            }
            Elements children = e.children();
            Iterator<Element> it = children.iterator();
            int colIndex = 0;
            while (it.hasNext()) {
                Element child = it.next();
                if (isVerticallyMargined(rowIndex, colIndex, margins)) {
                    colIndex++;
                }
                if (TH_ELEMENT.equals(child.nodeName()) || TD_ELEMENT.equals(child.nodeName())) {
                    String css = child.attr(STYLE_ATTR);
                    int colspan = colspan(child);
                    int rowspan = rowspan(child);
                    if (colspan > 1 || rowspan > 1) {
                        margins.add(new TableMargin(rowIndex, colIndex, (rowIndex + rowspan - 1),
                            (colIndex + colspan - 1)));
                    }
                    Map<String, String> styles = parseCss(css);
                    String widthValue = styles.get(WIDTH_ATTR);
                    if (StringUtils.isNotBlank(widthValue)) {
                        helper.setColWidth(table, colIndex, Float.parseFloat(widthValue) * factor);
                    }
                    this.writeCellValue(config, table, rowIndex, colIndex, child, uri);
                    // helper.setCellText(table, rowIndex, colIndex, child.text());
                    colIndex = colIndex + colspan;
                }
            }
            rowIndex++;
        }
        for (TableMargin margin : margins) {
            helper.mergeCells(table, margin.getStartRowIndex(), margin.getStartColIndex(), margin.getEndRowIndex(),
                margin.getEndColIndex());
        }
        helper.createEmptyParagraph(docx);
    }
    
    /**
     * 将数据写入到单元格
     * 
     * @param config 文档导出配置
     * @param table 表格
     * @param rowIndex 行索引
     * @param colIndex 列索引
     * @param element 数据
     * @param uri 文档uri
     */
    protected void writeCellValue(final DocxExportConfiguration config, final XWPFTable table, final int rowIndex,
        final int colIndex, final Element element, final String uri) {
        DocxHelper helper = DocxHelper.getInstance();
        IDocxFragmentWriter<Node> writer = DocxFragmentWriterFactory.getFragementWriter(element, BODY_ELEMENT);
        if (writer != null && writer instanceof ParagraphAppendWriter) {
            @SuppressWarnings("unchecked")
            ParagraphAppendWriter<Node> appender = (ParagraphAppendWriter<Node>) writer;
            appender.append(config, helper.getCellLastParagraph(table, rowIndex, colIndex), element, uri);
        } else {
            helper.setCellText(table, rowIndex, colIndex, element.text());
        }
    }
    
    /**
     * 当前单元格是否被行合并
     *
     * @param rowIndex 行索引
     * @param colIndex 列索引
     * @param margins 合并单元格
     * @return 是否被行合并
     */
    private boolean isVerticallyMargined(int rowIndex, int colIndex, List<TableMargin> margins) {
        for (TableMargin margin : margins) {
            if (rowIndex > margin.getStartRowIndex() && rowIndex <= margin.getEndRowIndex()
                && colIndex >= margin.getStartColIndex() && colIndex <= margin.getEndColIndex()) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * 横跨的行数
     *
     * @param element TD元素
     * @return 横跨的行数
     */
    private int rowspan(final Element element) {
        String str = element.attr(ROWSPAN_ATTR);
        int span;
        if (StringUtils.isBlank(str)) {
            span = 1;
        } else {
            span = Integer.parseInt(str);
        }
        return span;
    }
    
    /**
     * 横跨的列数
     *
     * @param element TD元素
     * @return 横跨的列数
     */
    private int colspan(final Element element) {
        String str = element.attr(COLSPAN_ATTR);
        int span;
        if (StringUtils.isBlank(str)) {
            span = 1;
        } else {
            span = Integer.parseInt(str);
        }
        return span;
    }
    
    /**
     * 解析CSS
     *
     * @param css css样式
     * @return 样式
     */
    protected Map<String, String> parseCss(String css) {
        Map<String, String> map = new HashMap<String, String>(12);
        if (StringUtils.isNotBlank(css)) {
            String[] styles = css.split(SEMICOLON_ENTITY);
            if (styles != null) {
                for (String style : styles) {
                    String[] keyValue = style.split(COLON_ENTITY);
                    if (keyValue != null && keyValue.length >= 2) {
                        String key = keyValue[0];
                        if (WIDTH_ATTR.equalsIgnoreCase(key)) {
                            String value = keyValue[1];
                            if (value.contains(PERCENT_ENTITY)) {
                                float widthCent = Float.parseFloat(value.replace(PERCENT_ENTITY, ""));
                                float width = widthCent * DEFAULT_TABLE_WIDTH / 100;
                                map.put(key, String.valueOf(width));
                            } else if (value.contains("pt")) {
                                float widthPT = Float.parseFloat(value.replace("pt", ""));
                                float width = MeasurementUnits.pt2cm(widthPT);
                                map.put(key, String.valueOf(width));
                            }
                        } else {
                            map.put(key, keyValue[1].replace(POUND_ENTITY, ""));
                        }
                    }
                }
            }
        }
        return map;
    }
    
    /**
     * 获取表格最大列数
     *
     * @param element 表格元素
     * @return 列数
     */
    protected int getTableColumnCount(Element element) {
        int count = 0;
        Elements elements = element.getElementsByTag(TR_ELEMENT);
        Iterator<Element> iterator = elements.iterator();
        while (iterator.hasNext()) { //
            Elements children = iterator.next().children();
            Iterator<Element> it = children.iterator();
            int temp = 0;
            while (it.hasNext()) {
                Element child = it.next();
                if (TH_ELEMENT.equals(child.nodeName()) || TD_ELEMENT.equals(child.nodeName())) {
                    int colspan = colspan(child);
                    if (colspan > 0) {
                        temp += colspan;
                    } else {
                        temp++;
                    }
                }
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
     * @param element 表格元素
     * @return 行数
     */
    protected int getTableRowCount(Element element) {
        Elements elements = element.getElementsByTag(HTMLConstants.TR_ELEMENT);
        if (elements == null) {
            return 0;
        }
        return elements.size();
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
