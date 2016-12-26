/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docconfig.model;

import java.io.Serializable;
import java.util.regex.Pattern;
import java.util.regex.PatternSyntaxException;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlTransient;
import javax.xml.bind.annotation.XmlType;
import javax.xml.bind.annotation.XmlValue;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.document.word.docconfig.datatype.CellContentType;
import com.comtop.cap.document.word.docconfig.datatype.DataStoreStrategy;
import com.comtop.cap.document.word.docconfig.datatype.MergeCellType;

/**
 * 模板中的表格单元格对象
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年10月15日 lizhiyong
 */
@XmlType(name = "TableCellElementType")
@XmlAccessorType(XmlAccessType.FIELD)
public class DCTableCell implements Serializable {
	
	/**
     * logger
     */
    protected static final Logger LOGGER = LoggerFactory.getLogger(DCTableCell.class);
	
    /** 序列化号 */
    private static final long serialVersionUID = 1L;
    
    /**
     * 映射到 在非扩展单元格时，其值为类似于 aa.name的表达式，用于从某个对象中取值 。在可扩展单元格中，其值为一个数据集表达式，比如bb[] =
     * aa.xxList,或bb[]=#XXXX(condition1,condition2),代表一行中当前定义的动态单元格的所有实例的取值。
     */
    @XmlAttribute
    private String mappingTo;
    
    /**
     * 元素是否可选 。目前未启用
     * 
     * 对表格而言，可用于对表格进行非精确匹配。
     * 比如模板中定义的表格和word中的实际表格基本一致，但word中有一个非关键列不存在，
     * 此时optional值可以true,解析程序则可以根据该标志位来进行表格的模糊匹配。
     * 
     * 对章节而言，可以定义章节是否需要输出，对其它内容而言，可以定义内容是否必须存在。
     */
    @XmlAttribute
    private Boolean optional;
    
    /** 单元 格是否可以为空 。默认为true。配置为false会对单元格数据进行校验，如果为空解析程序会记录日志，并且抛弃该数据。 */
    @XmlAttribute
    private Boolean nullAble;
    
    /** 单元 表头名称，用于展示和匹配word中的实际表格 */
    @XmlValue
    private String headerName;
    
    /** 相同数据的合并类型,为空表示不合并。导出程序使用 */
    @XmlAttribute
    private MergeCellType mergeCellType;
    
    /** 横向合并的单元格个数。默认为1 */
    @XmlAttribute
    private Integer colspan;
    
    /** 纵向合并的单元格个数。默认为1 */
    @XmlAttribute
    private Integer rowspan;
    
    /** 是否是可扩展的单元格。默认为false */
    @XmlAttribute
    private Boolean extCell;
    
    /** 扩展 数据集表达式 只有在可扩展单元格时才有该属性值 */
    @XmlAttribute(name = "extData")
    private String extDataExpr;
    
    /** 扩展表头表达式。可扩展单元格是没有固定的表头的,需要从数据集中的一条数据的某个属性来取值作为表头的文本 */
    @XmlAttribute(name = "headerLabel")
    private String headerLabelExpr;
    
    /**
     * 扩展单元格的值，对于一个对象来说，所有的扩展单元格可以作为该对象的一个集合类的属性，可以是一个独立的集合数据。
     * 但无论怎么样，需要满足以下要求
     * 1）该集合数据总是和当前对象一一对应的。
     * 2）该集合的Key所有的Key都应该在extData属性中的某个具体的元素的属性值中出现 。
     * 在展开单元格时，需要从该集合中取出与列头对应的数据
     * 
     * 针对 extCell、extDataExpr、headerLabelExpr、valueKeyExpr、mappingTo举例如下：
     * extCell=true
     * extDataExpr: ch[]=#HeaderData(packageId=$domainId) HeaderData结构 {hcode: ,hname:}
     * headerLabelExpr:ch.name
     * valueKeyExpr:ch.code
     * mappingTo:rowData.map rowData.map的数据结构{"hcode-1":"value1","hcode-2":"value2"}
     */
    @XmlAttribute(name = "valueKey")
    private String valueKeyExpr;
    
    /** 数据存储策略.参见DataStoreStrategy定义 */
    @XmlAttribute
    private DataStoreStrategy storeStrategy;
    
    /** 所属表格 */
    @XmlTransient
    private DCTable table;
    
    /** 所在行 */
    @XmlTransient
    private DCTableRow row;
    
    /** 是否表头 */
    @XmlTransient
    private boolean tableHead;
    
    /** 文本样式正则 */
    @XmlTransient
    private Pattern textPattern;
    
    /** 行号 */
    @XmlTransient
    private int rowIndex;
    
    /** 列号 */
    @XmlTransient
    private int cellIndex;
    
    /** 单元格宽度 */
    @XmlAttribute
    private Float width;
    
    /** 是否是系统创建的单元格 */
    @XmlTransient
    private boolean systemCreate = false;
    
    /** 单元格内容类型 */
    @XmlAttribute
    private CellContentType contentType;
    
    /**
     * @return 获取 contentType属性值
     */
    public CellContentType getContentType() {
        return contentType == null ? CellContentType.SIMPLEX : contentType;
    }
    
    /**
     * @param contentType 设置 contentType 属性值为参数值 contentType
     */
    public void setContentType(CellContentType contentType) {
        this.contentType = contentType;
    }
    
    /**
     * @return 获取 systemCreate属性值
     */
    public boolean isSystemCreate() {
        return systemCreate;
    }
    
    /**
     * @param systemCreate 设置 systemCreate 属性值为参数值 systemCreate
     */
    public void setSystemCreate(boolean systemCreate) {
        this.systemCreate = systemCreate;
    }
    
    /**
     * @return 获取 extDataExpr属性值
     */
    public String getExtDataExpr() {
        return extDataExpr;
    }
    
    /**
     * @param extDataExpr 设置 extDataExpr 属性值为参数值 extDataExpr
     */
    public void setExtDataExpr(String extDataExpr) {
        this.extDataExpr = extDataExpr;
    }
    
    /**
     * @return 获取 headerLabelExpr属性值
     */
    public String getHeaderLabelExpr() {
        return headerLabelExpr;
    }
    
    /**
     * @param headerLabelExpr 设置 headerLabelExpr 属性值为参数值 headerLabelExpr
     */
    public void setHeaderLabelExpr(String headerLabelExpr) {
        this.headerLabelExpr = headerLabelExpr;
    }
    
    /**
     * @return 获取 valueKeyExpr属性值
     */
    public String getValueKeyExpr() {
        return valueKeyExpr;
    }
    
    /**
     * @param valueKeyExpr 设置 valueKeyExpr 属性值为参数值 valueKeyExpr
     */
    public void setValueKeyExpr(String valueKeyExpr) {
        this.valueKeyExpr = valueKeyExpr;
    }
    
    /**
     * @return 获取 extCell属性值
     */
    public boolean isExtCell() {
        return extCell == null ? Boolean.FALSE : extCell.booleanValue();
    }
    
    /**
     * @param width 设置 width 属性值为参数值 width
     */
    public void setWidth(Float width) {
        this.width = width;
    }
    
    /**
     * @return 获取 row属性值
     */
    public DCTableRow getRow() {
        return row;
    }
    
    /**
     * @param row 设置 row 属性值为参数值 row
     */
    public void setRow(DCTableRow row) {
        this.row = row;
    }
    
    /**
     * @return 获取 tableHead属性值
     */
    public boolean isTableHead() {
        return StringUtils.isNotEmpty(this.headerName);
    }
    
    /**
     * @param tableHead 设置 tableHead 属性值为参数值 tableHead
     */
    public void setTableHead(boolean tableHead) {
        this.tableHead = tableHead;
    }
    
    /**
     * @return 获取 table属性值
     */
    public DCTable getTable() {
        return table;
    }
    
    /**
     * @param table 设置 table 属性值为参数值 table
     */
    public void setTable(DCTable table) {
        this.table = table;
    }
    
    /**
     * @return 获取 nullAble属性值
     */
    public boolean isNullAble() {
        return nullAble == null ? Boolean.TRUE : nullAble;
    }
    
    /**
     * @param nullAble 设置 nullAble 属性值为参数值 nullAble
     */
    public void setNullAble(boolean nullAble) {
        this.nullAble = nullAble;
    }
    
    /**
     * @return 获取 headerName属性值
     */
    public String getHeaderName() {
        return headerName;
    }
    
    /**
     * @param headerName 设置 headerName 属性值为参数值 headerName
     */
    public void setHeaderName(String headerName) {
        this.headerName = headerName;
    }
    
    /**
     * @return 获取 mergecellType属性值
     */
    public MergeCellType getMergeCellType() {
        return mergeCellType;
    }
    
    /**
     * @param mergecellType 设置 mergecellType 属性值为参数值 mergecellType
     */
    public void setMergeCellType(MergeCellType mergecellType) {
        this.mergeCellType = mergecellType;
    }
    
    /**
     * @return 获取 colspan属性值
     */
    public int getColspan() {
        return colspan == null ? 1 : (colspan <= 0 ? 1 : colspan);
    }
    
    /**
     * @param colspan 设置 colspan 属性值为参数值 colspan
     */
    public void setColspan(int colspan) {
        this.colspan = colspan;
    }
    
    /**
     * @return 获取 rowspan属性值
     */
    public int getRowspan() {
        return rowspan == null ? 1 : (rowspan <= 0 ? 1 : rowspan);
    }
    
    /**
     * @param rowspan 设置 rowspan 属性值为参数值 rowspan
     */
    public void setRowspan(Integer rowspan) {
        this.rowspan = rowspan;
    }
    
    /**
     * @return 获取 storeStrategy属性值
     */
    public DataStoreStrategy getStoreStrategy() {
        return storeStrategy == null ? DataStoreStrategy.STORE : storeStrategy;
    }
    
    /**
     * @param storeStrategy 设置 storeStrategy 属性值为参数值 storeStrategy
     */
    public void setStoreStrategy(DataStoreStrategy storeStrategy) {
        this.storeStrategy = storeStrategy;
    }
    
    /**
     * @return 获取 mappingTo属性值
     */
    public String getMappingTo() {
        return mappingTo;
    }
    
    /**
     * @param mappingTo 设置 mappingTo 属性值为参数值 mappingTo
     */
    public void setMappingTo(String mappingTo) {
        this.mappingTo = mappingTo;
    }
    
    /**
     * @return 获取 optional属性值
     */
    public Boolean getOptional() {
        return optional == null ? Boolean.FALSE : optional;
    }
    
    /**
     * @param optional 设置 optional 属性值为参数值 optional
     */
    public void setOptional(Boolean optional) {
        this.optional = optional;
    }
    
    /**
     * 初始化配置
     *
     */
    public void initConfig() {
        // 无须处理
    }
    
    /**
     * @return 获取 textPattern属性值
     */
    public Pattern getTextPattern() {
        if (textPattern == null) {
            try {
                if (StringUtils.isNotBlank(headerName)) {
                    textPattern = Pattern.compile(this.headerName);
                }
            } catch (PatternSyntaxException e) {
            	LOGGER.debug("获取 textPattern属性值出错", e);
                return null;
            }
        }
        return textPattern;
    }
    
    /**
     * @param textPattern 设置 textPattern 属性值为参数值 textPattern
     */
    public void setTextPattern(Pattern textPattern) {
        this.textPattern = textPattern;
    }
    
    /**
     * @return 获取 rowIndex属性值
     */
    public int getRowIndex() {
        return rowIndex;
    }
    
    /**
     * @param rowIndex 设置 rowIndex 属性值为参数值 rowIndex
     */
    public void setRowIndex(int rowIndex) {
        this.rowIndex = rowIndex;
    }
    
    /**
     * @return 获取 cellIndex属性值
     */
    public int getCellIndex() {
        return cellIndex;
    }
    
    /**
     * @param cellIndex 设置 cellIndex 属性值为参数值 cellIndex
     */
    public void setCellIndex(int cellIndex) {
        this.cellIndex = cellIndex;
    }
    
    @Override
    public String toString() {
        return this.headerName + ":" + this.mappingTo;
    }
    
    /**
     * @return 获取 width属性值
     */
    public float getWidth() {
        return width == null ? 0f : width;
    }
    
    /**
     * @param width 设置 width 属性值为参数值 width
     */
    public void setWidth(float width) {
        this.width = width;
    }
}
