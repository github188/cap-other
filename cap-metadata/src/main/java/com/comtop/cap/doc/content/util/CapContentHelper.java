/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.content.util;

import java.text.NumberFormat;
import java.util.List;
import java.util.UUID;

import com.comtop.cap.document.word.docconfig.model.DCTableCell;
import com.comtop.cap.document.word.docconfig.model.DCTableRow;

/**
 * 文档内容编辑帮助类
 *
 * @author 李小芬
 * @since jdk1.6
 * @version 2015年11月13日 李小芬
 */
public class CapContentHelper {
    
    /**
     * 两个整数相除，返回百分比，无小数位。
     *
     * @param iColspan 小的整数
     * @param iMaxTd 大的整数
     * @return 百分比
     */
    public static String getPercentWidth(int iColspan, int iMaxTd) {
        double dMin = iColspan * 1.0;
        double dMax = iMaxTd * 1.0;
        double dResult = dMin / dMax;
        NumberFormat objNf = NumberFormat.getPercentInstance();
        objNf.setMinimumFractionDigits(0);
        return objNf.format(dResult);
    }
    
    /**
     * 获取32位UUID的值
     *
     * @return UUID
     */
    public static String getUUID() {
        UUID uuid = UUID.randomUUID();
        return uuid.toString().trim().replaceAll("-", "");
    }
    
    /**
     * 获取固定表的列数目
     *
     * @param rows table的tr节点
     * @return 最大列数
     */
    public static int getMaxTdCount(List<DCTableRow> rows) {
        int iMaxTd = 0;
        for (DCTableRow tableRow : rows) {
            int iTotalCells = 0;
            List<DCTableCell> cells = tableRow.getXmlCells();
            for (DCTableCell tableCell : cells) {
                iTotalCells += tableCell.getColspan();
            }
            if (iTotalCells > iMaxTd) {
                iMaxTd = iTotalCells;
            }
        }
        return iMaxTd;
    }
    
}
