/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docconfig.model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;
import java.util.regex.PatternSyntaxException;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlElements;
import javax.xml.bind.annotation.XmlTransient;
import javax.xml.bind.annotation.XmlType;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.document.word.docconfig.datatype.MergeCellType;
import com.comtop.cap.document.word.docconfig.datatype.TableType;
import com.comtop.cap.document.word.parse.util.ExprUtil;

/**
 * 模板中的表格对象。
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年10月15日 lizhiyong
 */
@XmlType(name = "TableElementType")
@XmlAccessorType(XmlAccessType.FIELD)
public class DCTable extends DCContentSeg implements Cloneable {
    
    /** 类序列号 */
    private static final long serialVersionUID = 1L;
    
    /**
     * logger
     */
    protected static final Logger LOGGER = LoggerFactory.getLogger(DCTable.class);
    
    /** 表格行 */
    @XmlElements(@XmlElement(name = "tr", type = DCTableRow.class))
    private List<DCTableRow> rows = new ArrayList<DCTableRow>(20);
    
    /** 表格标题，用于人工识别 */
    @XmlAttribute
    private String title;
    
    /** 表格编号，暂未使用 */
    @XmlTransient
    private String serialNo;
    
    /** 类型： 行扩展表 列扩展表 固定表。必填 */
    @XmlAttribute(required = true)
    private TableType type;
    
    /** 表格填写说明,暂时未用 */
    @XmlAttribute
    private String fillDescription;
    
    /** 表格内容说明 表格备注 */
    @XmlTransient
    private String remark;
    
    /** 表格内容说明 表格前，用于生成表格前的固定描述字符串，比如业务关联表前 会有一段描述 ：“业务关联信息：” */
    @XmlAttribute
    private String descriptionBefore;
    
    /** 表格前描述字符串模式，根据descriptionBefore属性的值来创建 */
    @XmlTransient
    private Pattern descriptionBeforePattern;
    
    /** 数据是否需要持久化。对于结构化表格，可能不需要存储，则在解析时可以不处理。这种场景一般是汇总类的表格，导出时需要具体的定义，导入时可以完全忽略 */
    @XmlAttribute
    private Boolean needStore;
    
    /**
     * 从数据集中获得单条数据的表达式 用于从数据集中查找指定条件的数据。
     * 目前对于该值不需要写完成的表达式，只需要写 形如 “变量名.属性名1，变量名.属性名2”的字符串.如：
     * 
     * <pre>
     * &lt;table type="EXT_ROWS" name="业务分类及业务流程清单"
     *         mappingTo="bizProcessInfo[]=#BizProcess(domainId=$domainId)"
     * selector="bizProcessInfo.bizItemName,bizProcessInfo.processName"&gt;
     * 
     * <pre>
     */
    @XmlAttribute
    private String selector;
    
    /**
     * 表格对应的模型对象的类，用于构建数据选择表达式。
     * 对于固定表，指固定表对应的对象类型。对于行扩展表和列扩展表，指数据据集中的元素的类型。
     * 如：业务关联表是固定表，该表对应的数据是单个的关联对象（BizRelationDTO类的一个实例），对应的类BizRelationDTO类的Class。
     * 又如：业务对象表是行扩展表，该表对应的数据是多个数据对象（BizObjectDTO类的集合），那 么mappingToClass则为BizObjectDTO类的Class。
     * */
    @XmlTransient
    private Class<?> mappingToClass;
    
    /** 表格宽度 */
    @XmlAttribute
    private Float width;
    
    /** 表格索引号 */
    @XmlTransient
    private int tableIndex;
    
    /** 查询参数表达式集 包含该容器下所有内容涉及的查询表达式的参数值表达式 */
    @XmlTransient
    private final Map<String, String> queryParamExprs = new HashMap<String, String>(10);
    
    @Override
    public void initConfig() {
        super.initConfig();
        if (StringUtils.isNotBlank(super.getMappingTo())) {
            mappingToClass = ExprUtil.getExprClass(this);
            Map<String, String> queryParams = ExprUtil.getQueryParams(super.getMappingTo());
            // 初始化查询参数
            addQueryParamExprs(queryParams);
            getContainer().addQueryParamExprs(queryParams);
        }
        // 初始化行
        initRows();
        // 初始化合并的单元格
        initMergeCells();
    }
    
    /**
     * 初始化表格中的单元格信息
     *
     */
    private void initRows() {
        // 初始化方法中处理 行合并的配置问题 对rowspan进行处理
        // 保持原来的行信不变化，变化均在内存计算的rows进行。
        int rowIndex = 0;
        for (DCTableRow tr : rows) {
            tr.setTable(this);
            tr.setRowIndex(rowIndex++);
            // 行初始化
            tr.initConfig();
        }
    }
    
    /**
     * 初始化计算单元格信息，使用得在解析word中表格数据时，能够根据具体表格数据的行号的列号找到对应的单元格定义信息。如 <br/>
     * 
     * <pre>
     * &lt;table type="EXT_ROWS" mappingTo="bizRelation[]=#BizRelation(domainId=$domainId)" name="业务事项关联表" needStore="false"&gt;
     *              &lt;tr&gt;
     *                  &lt;td colspan="10" &gt;.*业务事项关联关系&lt;/td&gt;
     *              &lt;/tr&gt;
     *              &lt;tr&gt;
     *                   &lt;td colspan="3" mappingTo="$domainName"/&gt;
     *                   &lt;td colspan="4"&gt;关联领域&lt;/td&gt;
     *                   &lt;td colspan="2"&gt;关联关系&lt;/td&gt;
     *                   &lt;td rowspan="2" mappingTo="bizRelation.remark"&gt;备注&lt;/td&gt;
     *               &lt;/tr&gt;
     *               &lt;tr&gt;
     *                   &lt;td mappingTo="bizRelation.roleaFirstLevelBiz"&gt;一级业务&lt;/td&gt;
     *                   &lt;td mappingTo="bizRelation.roleaSecondLevelBiz"&gt;二级业务&lt;/td&gt;
     *                   &lt;td mappingTo="bizRelation.roleaItemName"&gt;业务事项&lt;/td&gt;
     *                   &lt;td mappingTo="bizRelation.rolebDomainName"&gt;领域名称&lt;/td&gt;
     *                   &lt;td mappingTo="bizRelation.rolebFirstLevelBiz"&gt;一级业务&lt;/td&gt;
     *                   &lt;td mappingTo="bizRelation.rolebSecondLevelBiz"&gt;二级业务&lt;/td&gt;
     *                   &lt;td mappingTo="bizRelation.rolebItemName"&gt;业务事项&lt;/td&gt;
     *                   &lt;td mappingTo="bizRelation.relType"&gt;关联类型&lt;/td&gt;
     *                   &lt;td mappingTo="bizRelation.description"&gt;关联关系描述&lt;/td&gt;
     *              &lt;/tr&gt;
     *          &lt;/table&gt;
     * </pre>
     * 
     * 对于上表的配置而言,表明表头有三行，第一行全部单元格行合并（表现为只有一个单元格），第二行的最后一列列合并，第三行都不合并（总共只有9个单元格）。
     * 那么对于模板而言，这个表格总共有十列，word中的数据也会有十列。在解析word时，会根据一个具体单元格的行号和列号来查找具体的单元格定义信息。
     * 当处理第10列的数据时，会因为原始的配置只有9列而无法找到单元格定义信息，导致第十列的数据无法被转换为具体的对象属性。事实上，第10列的信息
     * 是在第二行中定义的，因此我们需要将第二行定义的信息添加到第三行最后一个单元格，这样即可找到定义，进而进行转换。除了上述情况外，如果在某行
     * 的中间存在单元格列合并的情况，也需要将合并的单元格添加到所有被合并的行上。
     * 本方法即是对此情况进行处理，保证只要表格能够匹配，其中的数据即可找到定义。
     * 
     */
    private void initMergeCells() {
        int rowsSize = rows.size();
        for (int i = 0; i < rowsSize; i++) {
            List<DCTableCell> rowCells = rows.get(i).getCells();
            int columnIndex = 0;
            for (int j = 0; j < rowCells.size(); j++) {
                DCTableCell cell = rowCells.get(j);
                int rowspan = cell.getRowspan();
                columnIndex += cell.getColspan();
                if (rowspan <= 1) {
                    continue;
                }
                int lastIndex = (i + rowspan) > rowsSize ? rowsSize : (i + rowspan);
                for (int k = i + 1; k < lastIndex; k++) {
                    DCTableCell mergeCell = new DCTableCell();
                    mergeCell.setTable(this);
                    mergeCell.setSystemCreate(true);
                    mergeCell.setHeaderName("");
                    mergeCell.setMappingTo(cell.getMappingTo());
                    mergeCell.setMergeCellType(MergeCellType.VERTICAL);
                    mergeCell.setNullAble(cell.isNullAble());
                    mergeCell.setTableHead(cell.isTableHead());
                    mergeCell.setTextPattern(cell.getTextPattern());
                    mergeCell.setColspan(cell.getColspan());
                    mergeCell.setRowIndex(k);
                    int cellIndex = getAddCellIndex(j, k, columnIndex - cell.getColspan());
                    mergeCell.setCellIndex(cellIndex);
                    rows.get(k).addCell(cellIndex, mergeCell);
                }
            }
        }
    }
    
    /**
     * 获得新加单元元的cellIndex
     *
     * @param preRowCellIndex 前一行
     * @param curRowIndex 待添加单元格的行号
     * @param preRowcolumnIndex 前一行截止当前处理单元格的 列总列数
     * @return 待添加单元格的列号
     */
    private int getAddCellIndex(int preRowCellIndex, int curRowIndex, int preRowcolumnIndex) {
        if (preRowCellIndex == 0) {
            return preRowCellIndex;
        }
        DCTableRow row = rows.get(curRowIndex);
        int nextRowColumnIndex = 0;
        for (DCTableCell td : row.getCells()) {
            nextRowColumnIndex += td.getColspan();
            if (nextRowColumnIndex >= preRowcolumnIndex) {
                return td.getCellIndex() + 1;
            }
        }
        return row.getCells().size();
    }
    
    /**
     * @return 获取 mappingToClass属性值
     */
    public Class<?> getMappingToClass() {
        return mappingToClass;
    }
    
    /**
     * @return 获取 rows属性值
     */
    public List<DCTableRow> getRows() {
        return rows;
    }
    
    /**
     * 
     * 获得第一行
     *
     * @return 第一行
     */
    public DCTableRow getFirstRow() {
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
    public DCTableRow getLastRow() {
        if (rows.size() <= 0) {
            return null;
        }
        return rows.get(rows.size() - 1);
    }
    
    /**
     * @param alRows 设置 rows 属性值为参数值 alRows
     */
    public void addRows(List<DCTableRow> alRows) {
        this.rows.addAll(alRows);
        for (DCTableRow tableRow : alRows) {
            tableRow.setTable(this);
        }
    }
    
    /**
     * @param row 设置 rows 属性值为参数值 row
     */
    public void addRow(DCTableRow row) {
        this.rows.add(row);
        row.setTable(this);
    }
    
    /**
     * @param rowIndex 获得指定索引的行
     * @return TableRow 索引错误返回null
     */
    public DCTableRow getRow(int rowIndex) {
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
     * @return 获取 type属性值
     */
    public TableType getType() {
        return type;
    }
    
    /**
     * @param type 设置 type 属性值为参数值 type
     */
    public void setType(TableType type) {
        this.type = type;
    }
    
    /**
     * @return 获取 fillDescription属性值
     */
    public String getFillDescription() {
        return fillDescription;
    }
    
    /**
     * @param fillDescription 设置 fillDescription 属性值为参数值 fillDescription
     */
    public void setFillDescription(String fillDescription) {
        this.fillDescription = fillDescription;
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
     * 获得表格前描述文字的文本模式
     *
     * @return 表格前描述文字的文本模式
     */
    public Pattern getDescriptionBeforePattern() {
        if (descriptionBeforePattern == null) {
            try {
                if (StringUtils.isBlank(descriptionBefore)) {
                    return null;
                }
                descriptionBeforePattern = Pattern.compile(descriptionBefore);
            } catch (PatternSyntaxException e) {
            	LOGGER.debug("获得表格前描述文字的文本模式错误", e);
                return null;
            }
        }
        return descriptionBeforePattern;
    }
    
    /**
     * @param descriptionBeforePattern 设置 descriptionBeforePattern 属性值为参数值 descriptionBeforePattern
     */
    public void setDescriptionBeforePattern(Pattern descriptionBeforePattern) {
        this.descriptionBeforePattern = descriptionBeforePattern;
    }
    
    /**
     * @param descriptionBefore 设置 descriptionBefore 属性值为参数值 descriptionBefore
     */
    public void setDescriptionBefore(String descriptionBefore) {
        this.descriptionBefore = descriptionBefore;
    }
    
    /**
     * @return 获取 needStore属性值
     */
    @Override
    public boolean isNeedStore() {
        return needStore == null ? Boolean.TRUE : needStore;
    }
    
    /**
     * @param needStore 设置 needStore 属性值为参数值 needStore
     */
    @Override
    public void setNeedStore(boolean needStore) {
        this.needStore = needStore;
    }
    
    @Override
    public String toString() {
        StringBuffer sb = new StringBuffer();
        sb.append("表格:{}");
        return sb.toString();
    }
    
    /**
     * @return 获取 needStore属性值
     */
    public Boolean getNeedStore() {
        return needStore == null ? Boolean.TRUE : needStore;
    }
    
    /**
     * @return 获取 selector属性值
     */
    public String getSelector() {
        return selector;
    }
    
    /**
     * @param selector 设置 selector 属性值为参数值 selector
     */
    public void setSelector(String selector) {
        this.selector = selector;
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
    
    /**
     * @return 获取 queryExprParams属性值
     */
    public Map<String, String> getQueryParamExprs() {
        return queryParamExprs;
    }
    
    /**
     * @param queryExprParamSet 设置 queryExprParams 属性值为参数值 queryExprParams
     */
    public void addQueryParamExprs(Map<String, String> queryExprParamSet) {
        if (queryExprParamSet != null && queryExprParamSet.size() > 0) {
            this.queryParamExprs.putAll(queryExprParamSet);
        }
    }
    
    /**
     * @param attributeExpr 属性的表达式
     * @param valueExpr valueExpr 值的表达式
     */
    public void addQueryParamExpr(String attributeExpr, String valueExpr) {
        this.queryParamExprs.put(attributeExpr, valueExpr);
    }
    
}
