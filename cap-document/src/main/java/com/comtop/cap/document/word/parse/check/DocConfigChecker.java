/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.parse.check;

import java.lang.reflect.Field;
import java.text.MessageFormat;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.document.util.ReflectionHelper;
import com.comtop.cap.document.word.docconfig.datatype.ChapterType;
import com.comtop.cap.document.word.docconfig.datatype.TableType;
import com.comtop.cap.document.word.docconfig.model.ConfigElement;
import com.comtop.cap.document.word.docconfig.model.DCChapter;
import com.comtop.cap.document.word.docconfig.model.DCSection;
import com.comtop.cap.document.word.docconfig.model.DCTable;
import com.comtop.cap.document.word.docconfig.model.DCTableCell;
import com.comtop.cap.document.word.docconfig.model.DCTableRow;
import com.comtop.cap.document.word.docconfig.model.DocConfig;
import com.comtop.cap.document.word.expression.ExprType;
import com.comtop.cap.document.word.parse.WordParseException;
import com.comtop.cap.document.word.parse.util.ExprUtil;

/**
 * 模板校验器
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年11月11日 lizhiyong
 */
public class DocConfigChecker {
    
    /** 模板对象 */
    private DocConfig docConfig;
    
    /** 表达式正则 */
    private final static Pattern EXPR_TITLE_PATTERN = Pattern.compile("[A-Za-z0-9]+\\.[A-Za-z0-9]+");
    
    /**
     * 构造函数
     * 
     * @param docConfig 模板对象
     */
    public DocConfigChecker(DocConfig docConfig) {
        this.docConfig = docConfig;
    }
    
    /**
     * 校验模板
     * 
     * @return xx
     *
     */
    public DocConfigCheckLogger check() {
        if (docConfig == null) {
            throw new WordParseException("模板对象为空");
        }
        DocConfigCheckLogger checkLogger = new DocConfigCheckLogger(this.docConfig);
        List<DCSection> sections = docConfig.getSections();
        for (DCSection section : sections) {
            List<? extends ConfigElement> tables = section.getElements(DCTable.class);
            if (tables != null && tables.size() > 0) {
                for (ConfigElement wordElement : tables) {
                    checkTable((DCTable) wordElement, checkLogger);
                }
            }
            List<DCChapter> chapters = section.getChapters();
            checkTableInChapter(chapters, checkLogger);
            checkChapter(chapters, checkLogger);
            
        }
        checkLogger.toString();
        return checkLogger;
    }
    
    /**
     * 检验章节定义
     *
     * @param chapters 章节集
     * @param checkLogger 日志记录
     */
    private void checkChapter(List<DCChapter> chapters, DocConfigCheckLogger checkLogger) {
        for (DCChapter chapter : chapters) {
            if (chapter.getChapterType() == ChapterType.DYNAMIC) {
                String mappingTo = chapter.getMappingTo();
                String title = chapter.getTitle();
                if (StringUtils.isBlank(mappingTo)) {
                    checkLogger.errorChapter(chapter, "模板中章节未定义mappingTo属性");
                }
                if (StringUtils.isBlank(mappingTo)) {
                    checkLogger.errorChapter(chapter, "模板中章节mappingTo属性取值格式错误");
                }
                if (StringUtils.isBlank(title)) {
                    checkLogger.errorChapter(chapter, "模板中章节未定义title属性");
                }
                if (EXPR_TITLE_PATTERN.matcher(title).find()) {
                    checkLogger.errorChapter(chapter, "模板中章节title属性取值格式错误");
                }
            }
            checkChapter(chapter.getChildChapters(), checkLogger);
        }
    }
    
    /**
     * 校验表格
     *
     * @param table 表格
     * @param checkLogger 日志记录器
     */
    private void checkTable(DCTable table, DocConfigCheckLogger checkLogger) {
        if (table.getType() != TableType.UNKNOWN) {
            if (StringUtils.isBlank(table.getMappingTo())) {
                checkLogger.warnTable(table, "模板中表格未定义映射关系");
            }
            switch (table.getType()) {
                case EXT_ROWS:
                    checkExtRowsTable(table, checkLogger);
                    break;
                case FIXED:
                    checkFixedTable(table, checkLogger);
                    break;
                default:
                    checkExtColsTable(table, checkLogger);
                    break;
            }
        }
    }
    
    /**
     * 校验行扩展表格
     *
     * @param table 表格
     * @param checkLogger 日志记录器
     */
    private void checkExtRowsTable(DCTable table, DocConfigCheckLogger checkLogger) {
        
        List<DCTableRow> rows = table.getRows();
        if (rows == null || rows.size() == 0) {
            checkLogger.warnTable(table, "模板中表格未定义行");
            return;
        }
        int lastRowIndex = rows.size() - 1;
        int i = 0;
        int[] columns = new int[rows.size()];
        for (DCTableRow tr : rows) {
            String mappingTo = tr.getMappingTo();
            if (tr.isExtRow() && StringUtils.isBlank(mappingTo)) {
                checkLogger.errorTableRow(tr, "模板中表格可扩展行未定义mappingTo属性");
            } else if (!tr.isExtRow() && StringUtils.isNotBlank(mappingTo)) {
                checkLogger.warnTableRow(tr, "模板中表格不可扩展行定义了mapptingTo属性");
            }
            List<DCTableCell> cells = tr.getCells();
            for (DCTableCell tableCell : cells) {
                if (lastRowIndex == i) {
                    if (StringUtils.isBlank(tableCell.getHeaderName()) && !tableCell.isExtCell()
                        && !tableCell.isSystemCreate()) {
                        checkLogger.warnCell(tableCell, "模板中单元格未定义表头");
                    }
                    if (StringUtils.isBlank(tableCell.getMappingTo())) {
                        checkLogger.warnCell(tableCell, "模板中单元格未定义映射关系");
                    }
                }
                columns[i] += tableCell.getColspan();
            }
            i++;
        }
        for (int j = 0; j < columns.length - 1; j++) {
            if (columns[j] != columns[j + 1]) {
                checkLogger.errorTable(table, MessageFormat.format("第{0}行与其后一行的列宽不一致", j));
            }
        }
    }
    
    /**
     * 校验列扩展表格
     *
     * @param table 表格
     * @param checkLogger 日志记录器
     */
    private void checkExtColsTable(DCTable table, DocConfigCheckLogger checkLogger) {
        List<DCTableRow> rows = table.getRows();
        int lastRowIndex = rows.size() - 1;
        int i = 0;
        int[] columns = new int[rows.size()];
        for (DCTableRow row : rows) {
            for (DCTableCell tableCell : row.getCells()) {
                columns[i] += tableCell.getColspan();
                if (tableCell.isExtCell()) {
                    String extData = tableCell.getExtDataExpr();
                    if (StringUtils.isBlank(extData)) {
                        checkLogger.errorCell(tableCell, "模板中可扩展单元格未定义extData属性表达式");
                    }
                    String extVar = ExprUtil.getVarNameFromExpr(extData);
                    String headerLabel = tableCell.getHeaderLabelExpr();
                    if (StringUtils.isBlank(headerLabel)) {
                        checkLogger.errorCell(tableCell, "模板中可扩展单元格未定义headerLabel属性表达式");
                    } else {
                        Matcher matcher = ExprType.ATTRIBUTE.getPattern().matcher(headerLabel);
                        if (matcher.find()) {
                            String varName = matcher.group(1);
                            if (!StringUtils.equals(extVar, varName)) {
                                checkLogger.errorCell(tableCell, MessageFormat.format(
                                    "模板中可扩展单元格headerLabel表达式变量{0}与extData变量{1}不一致", varName, extVar));
                            }
                        } else {
                            checkLogger.errorCell(tableCell, "模板中可扩展单元格headerLabel表达式只支持属性表达式");
                        }
                    }
                    if (lastRowIndex == tableCell.getRowIndex()) {
                        String valueKey = tableCell.getValueKeyExpr();
                        if (StringUtils.isBlank(valueKey)) {
                            checkLogger.errorCell(tableCell, "模板中可扩展单元格未定义valueKey属性表达式");
                        } else {
                            Matcher matcher = ExprType.ATTRIBUTE.getPattern().matcher(headerLabel);
                            if (matcher.find()) {
                                String varName = matcher.group(1);
                                if (!StringUtils.equals(extVar, varName)) {
                                    checkLogger.errorCell(tableCell, MessageFormat.format(
                                        "模板中可扩展单元格valueKey表达式变量{0}与extData变量{1}不一致", varName, extVar));
                                }
                            } else {
                                checkLogger.errorCell(tableCell, "模板中可扩展单元格valueKey表达式只支持属性表达式");
                            }
                        }
                        String mappingTo = tableCell.getMappingTo();
                        if (StringUtils.isBlank(mappingTo)) {
                            checkLogger.errorCell(tableCell, "模板中可扩展单元格未定义mappingTo属性表达式");
                        } else {
                            Matcher matcher = ExprType.ATTRIBUTE.getPattern().matcher(mappingTo);
                            if (!matcher.find()) {
                                checkLogger.errorCell(tableCell, "模板中可扩展单元格mappingTo属性表达式只支持属性表达式");
                            } else {
                                Class<?> mappingClass = table.getMappingToClass();
                                if (mappingClass != null) {
                                    String fieldName = matcher.group(2);
                                    Field field = ReflectionHelper.findField(mappingClass, fieldName);
                                    if (field != null) {
                                        Class<?> type = field.getType();
                                        if (!Map.class.isAssignableFrom(type)) {
                                            checkLogger.errorCell(tableCell,
                                                "模板中可扩展单元格未定义mappingTo属性表达式代表的字段不是Map类型的属性");
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                if (lastRowIndex == i) {
                    if (StringUtils.isBlank(tableCell.getHeaderName()) && !tableCell.isExtCell()
                        && !tableCell.isSystemCreate()) {
                        checkLogger.warnCell(tableCell, "模板中单元格未定义表头");
                    }
                    
                    if (StringUtils.isBlank(tableCell.getMappingTo())) {
                        checkLogger.warnCell(tableCell, "模板中单元格未定义映射关系");
                    }
                }
            }
            i++;
        }
        // for (TableRow row : rows) {
        // TableCell tableCell = row.getLastCell();
        // if (StringUtils.isBlank(tableCell.getHeaderName())) {
        // checkLogger.warnCell(tableCell, "模板中单元格未定义表头");
        // }
        //
        // if (StringUtils.isBlank(tableCell.getMappingTo())) {
        // checkLogger.warnCell(tableCell, "模板中单元格未定义映射关系");
        // }
        // }
        
        for (int j = 0; j < columns.length - 1; j++) {
            if (columns[j] != columns[j + 1]) {
                checkLogger.errorTable(table, MessageFormat.format("第{0}行与其后一行的列宽不一致", j));
            }
        }
    }
    
    /**
     * 校验固定表格
     *
     * @param table 表格
     * @param checkLogger 日志记录器
     */
    private void checkFixedTable(DCTable table, DocConfigCheckLogger checkLogger) {
        List<DCTableRow> rows = table.getRows();
        for (DCTableRow row : rows) {
            String mappingTo = row.getMappingTo();
            if (row.isExtRow() && StringUtils.isBlank(mappingTo)) {
                checkLogger.errorTableRow(row, "模板中表格可扩展行未定义mappingTo属性");
            } else if (!row.isExtRow() && StringUtils.isNotBlank(mappingTo)) {
                checkLogger.warnTableRow(row, "模板中表格不可扩展行定义了mapptingTo属性");
            }
            List<DCTableCell> cells = row.getCells();
            for (DCTableCell tableCell : cells) {
                if (StringUtils.isBlank(tableCell.getHeaderName()) && StringUtils.isBlank(tableCell.getMappingTo())) {
                    checkLogger.warnCell(tableCell, "模板中单元格既未定义表头，又未定义映射关系");
                }
            }
        }
    }
    
    /**
     * 校验章节中的表格
     *
     * @param chapters 章节集
     * @param checkLogger 校验日志
     */
    private void checkTableInChapter(List<DCChapter> chapters, DocConfigCheckLogger checkLogger) {
        if (chapters == null || chapters.size() == 0) {
            return;
        }
        for (DCChapter chapter : chapters) {
            List<? extends ConfigElement> tables = chapter.getElements(DCTable.class);
            if (tables != null && tables.size() > 0) {
                for (ConfigElement configElement : tables) {
                    checkTable((DCTable) configElement, checkLogger);
                }
            }
            checkTableInChapter(chapter.getChildChapters(), checkLogger);
        }
    }
}
