/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.write.writer;

import java.util.List;

import org.apache.poi.xwpf.usermodel.XWPFTable;

import com.comtop.cap.document.word.docmodel.data.CellExtra;
import com.comtop.cap.document.word.docmodel.style.TableMargin;
import com.comtop.cap.document.word.write.DocxHelper;

/**
 * 动态表格写入器
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月23日 lizhongwen
 */
public abstract class DynamicTableWriter extends TableWriter {
    
    /**
     * 合并表格单元格
     *
     * @param table 表格对象
     * @param margins 单元格合并对象
     */
    protected void marginTable(final XWPFTable table, final List<TableMargin> margins) {
        DocxHelper helper = DocxHelper.getInstance();
        for (TableMargin margin : margins) {
            helper.mergeCells(table, margin.getStartRowIndex(), margin.getStartColIndex(), margin.getEndRowIndex(),
                margin.getEndColIndex());
        }
    }
    
    /**
     * 合并表格单元格
     *
     * @param table 表格对象
     * @param margins 单元格合并对象
     * @param startRowIndex 起始行位置
     * @param endRowIndex 结束行位置
     */
    protected void marginTableData(final XWPFTable table, final List<TableMargin> margins, final int startRowIndex,
        final int endRowIndex) {
        DocxHelper helper = DocxHelper.getInstance();
        int lastHeaderRowIndex = startRowIndex - 1;
        for (TableMargin margin : margins) {
            if (lastHeaderRowIndex != margin.getStartRowIndex() || lastHeaderRowIndex != margin.getEndRowIndex()) {
                continue;
            }
            int startColIndex = margin.getStartColIndex();
            int endColIndex = margin.getEndColIndex();
            for (int rowIndex = startRowIndex; rowIndex <= endRowIndex; rowIndex++) {
                helper.mergeCellsHorizontal(table, rowIndex, startColIndex, endColIndex);
            }
        }
    }
    
    /**
     * 根据内容自动合并
     * 
     * @param table 表格对象
     * @param cells 单元格扩展封装集合
     * @param startRowIndex 起始行索引
     */
    protected void autoMargin(final XWPFTable table, final CellExtra[] cells, final int startRowIndex) {
        DocxHelper helper = DocxHelper.getInstance();
        for (int colIndex = 0; colIndex < cells.length; colIndex++) {
            CellExtra cell = cells[colIndex];
            if (cell.isAutoMerge()) {
                helper.mergeSameContentRowVertically(table, colIndex, startRowIndex);
            }
        }
    }
}
