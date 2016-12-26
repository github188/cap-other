/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docmodel.data;

import java.util.ArrayList;
import java.util.List;

import org.apache.poi.xwpf.usermodel.XWPFTable;

import com.comtop.cap.document.word.docmodel.datatype.ContentType;
import com.comtop.cip.json.annotation.JSONField;

/**
 * 表格内容。
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年10月15日 lizhiyong
 */
public class Table extends ContentSeg implements Cloneable {
    
    /** 类序列号 */
    private static final long serialVersionUID = 1L;
    
    /** 表格行 */
    @JSONField(serialize = false)
    private List<TableRow> rows = new ArrayList<TableRow>(20);
    
    /** poi表格 */
    @JSONField(serialize = false)
    private XWPFTable xwpfTable;
    
    /** 名称 */
    private String title;
    
    /** 编号 */
    private String serialNo;
    
    /** 表格内容说明 表格备注 */
    private String remark;
    
    /** 表格内容说明 表格前 */
    private String descriptionBefore;
    
    /** 表格内容说明 表格后 */
    private String descriptionAfter;
    
    /** 表格索引号 */
    private int tableIndex;
    
    /**
     * @return 获取 rows属性值
     */
    public List<TableRow> getRows() {
        return rows;
    }
    
    /**
     * 
     * 获得第一行
     *
     * @return 第一行
     */
    public TableRow getFirstRow() {
        if (rows.size() <= 0) {
            return null;
        }
        return rows.get(0);
    }
    
    /**
     * 
     * 获得第一行
     *
     * @return 第一行
     */
    public TableRow getLastRow() {
        if (rows.size() <= 0) {
            return null;
        }
        return rows.get(rows.size() - 1);
    }
    
    /**
     * @param alRows 设置 rows 属性值为参数值 alRows
     */
    public void addRows(List<TableRow> alRows) {
        this.rows.addAll(alRows);
        for (TableRow tableRow : alRows) {
            tableRow.setTable(this);
        }
    }
    
    /**
     * @param row 设置 rows 属性值为参数值 row
     */
    public void addRow(TableRow row) {
        this.rows.add(row);
        row.setTable(this);
    }
    
    /**
     * @param rowIndex 获得指定索引的行
     * @return TableRow 索引错误返回null
     */
    public TableRow getRow(int rowIndex) {
        return (rowIndex > this.rows.size() - 1) ? null : this.rows.get(rowIndex);
    }
    
    /**
     * @return 获取 name属性值
     */
    public String getTitle() {
        return title;
    }
    
    /**
     * @param title 设置 title 属性值为参数值 title
     */
    public void setTitle(String title) {
        this.title = title;
    }
    
    /**
     * @return 获取 serialNo属性值
     */
    public String getSerialNo() {
        return serialNo;
    }
    
    /**
     * @param serialNo 设置 serialNo 属性值为参数值 serialNo
     */
    public void setSerialNo(String serialNo) {
        this.serialNo = serialNo;
    }
    
    /**
     * @return 获取 remark属性值
     */
    public String getRemark() {
        return remark;
    }
    
    /**
     * @param remark 设置 remark 属性值为参数值 remark
     */
    public void setRemark(String remark) {
        this.remark = remark;
    }
    
    /**
     * @return 获取 descriptionBefore属性值
     */
    public String getDescriptionBefore() {
        return descriptionBefore;
    }
    
    /**
     * @param descriptionBefore 设置 descriptionBefore 属性值为参数值 descriptionBefore
     */
    public void setDescriptionBefore(String descriptionBefore) {
        this.descriptionBefore = descriptionBefore;
    }
    
    /**
     * @return 获取 descriptionAfter属性值
     */
    public String getDescriptionAfter() {
        return descriptionAfter;
    }
    
    /**
     * @param descriptionAfter 设置 descriptionAfter 属性值为参数值 descriptionAfter
     */
    public void setDescriptionAfter(String descriptionAfter) {
        this.descriptionAfter = descriptionAfter;
    }
    
    @Override
    public String getContentType() {
        return ContentType.TABLE.name();
    }
    
    /**
     * @return 获取 xwpfTable属性值
     */
    public XWPFTable getXwpfTable() {
        return xwpfTable;
    }
    
    /**
     * @param xwpfTable 设置 xwpfTable 属性值为参数值 xwpfTable
     */
    public void setXwpfTable(XWPFTable xwpfTable) {
        this.xwpfTable = xwpfTable;
    }
    
    @Override
    public String toString() {
        StringBuffer sb = new StringBuffer();
        sb.append("表格:{}");
        return sb.toString();
    }
    
    /**
     * 设置htmlText
     *
     * @param htmlText html文本
     */
    @Override
    public void setContent(String htmlText) {
        super.content = htmlText;
    }
    
    /**
     * @return 获取 tableIndex属性值
     */
    public int getTableIndex() {
        return tableIndex;
    }
    
    /**
     * @param tableIndex 设置 tableIndex 属性值为参数值 tableIndex
     */
    public void setTableIndex(int tableIndex) {
        this.tableIndex = tableIndex;
    }
}
