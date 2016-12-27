/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.database.dbobject.model;

import java.util.ArrayList;
import java.util.List;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 列比较结果
 * 
 * @author 林玉千
 * @since jdk1.6
 * @version 2016-9-26 林玉千 新建
 */
@DataTransferObject
public class ColumnCompareResult extends BaseMetadata {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /**
     * -2 表示删除该列, 源列中存在而目标列不存在
     */
    public final static int COLUMN_DEL = -2;
    
    /**
     * -1 表示新增该列 ,目标列中存在而源列不存在
     */
    public final static int COLUMN_ADD = -1;
    
    /**
     * 0 表示相同
     */
    public final static int COLUMN_EQUAL = 0;
    
    /**
     * 1 表示列存在不同
     */
    public final static int COLUMN_DIFF = 1;
    
    /**
     * 12 表示列描述不同
     */
    public final static int COLUMN_DESCRIPTION_DIFF = 12;
    
    /**
     * 13 表示列编码述不同
     */
    public final static int COLUMN_CODE_DIFF = 13;
    
    /**
     * 14 表示列中文名称不同
     */
    public final static int COLUMN_CHNAME_DIFF = 14;
    
    /**
     * 15 表示列英文名称不同
     */
    public final static int COLUMN_ENGNAME_DIFF = 15;
    
    /**
     * 16 表示列类型不同
     */
    public final static int COLUMN_DATATYPE_DIFF = 16;
    
    /**
     * 17 标识主键不同
     */
    public final static int COLUMN_ISPRIMARYKEY_DIFF = 17;
    
    /**
     * 18 是否可为空
     */
    public final static int COLUMN_CANBENULL_DIFF = 18;
    
    /**
     * 19 表示列默认值不同
     */
    public final static int COLUMN_DEFAULTVALUE_DIFF = 19;
    
    /** 列ID */
    private String id;
    
    /** 表名 */
    private String tableName;
    
    /** 比较结果：0 表示相同,-1 表示列不存在，需要新增，1 表示列存在不同, 2 表示列描述不同 */
    private int result;
    
    /** 比较属性差异结果列表 */
    private List<Integer> lstResult = new ArrayList<Integer>();
    
    /** 源表的列 */
    private ColumnVO srcColumn;
    
    /** 目标表的列 */
    private ColumnVO targetColumn;
    
    /**
     * 
     * 构造函数
     */
    public ColumnCompareResult() {
        this.result = COLUMN_EQUAL;
    }
    
    /**
     * 构造函数
     * 
     * @param id id
     */
    public ColumnCompareResult(String id) {
        super();
        this.id = id;
    }
    
    /**
     * 
     * @return xx
     */
    public String getId() {
        return id;
    }
    
    /**
     * @param id 设置 id 属性值为参数值 id
     */
    public void setId(String id) {
        this.id = id;
    }
    
    /**
     * @return 获取 tableName属性值
     */
    public String getTableName() {
        return tableName;
    }
    
    /**
     * @param tableName 设置 tableName 属性值为参数值 tableName
     */
    public void setTableName(String tableName) {
        this.tableName = tableName;
    }
    
    /**
     * @return 获取 result属性值
     */
    public int getResult() {
        return result;
    }
    
    /**
     * @param result 设置 result 属性值为参数值 result
     */
    public void setResult(int result) {
        this.result = result;
    }
    
    /**
     * @return 获取 srcColumn属性值
     */
    public ColumnVO getSrcColumn() {
        return srcColumn;
    }
    
    /**
     * @param srcColumn 设置 srcColumn 属性值为参数值 srcColumn
     */
    public void setSrcColumn(ColumnVO srcColumn) {
        this.srcColumn = srcColumn;
    }
    
    /**
     * @return 获取 targetColumn属性值
     */
    public ColumnVO getTargetColumn() {
        return targetColumn;
    }
    
    /**
     * @param targetColumn 设置 targetColumn 属性值为参数值 targetColumn
     */
    public void setTargetColumn(ColumnVO targetColumn) {
        this.targetColumn = targetColumn;
    }
    
    /**
     * @return 获取 lstResult属性值
     */
    public List<Integer> getLstResult() {
        return lstResult;
    }
    
    /**
     * @param lstResult 设置 lstResult 属性值为参数值 lstResult
     */
    public void setLstResult(List<Integer> lstResult) {
        this.lstResult = lstResult;
    }
    
    /**
     * 获取对象属性差异类型
     * 
     * @param fileName 字段名称
     * @return 差异类型
     */
    public static int getDiffType(String fileName) {
        if ("code".equals(fileName)) {
            return COLUMN_CODE_DIFF;
        } else if ("chName".equals(fileName)) {
            return COLUMN_CHNAME_DIFF;
        } else if ("engName".equals(fileName)) {
            return COLUMN_ENGNAME_DIFF;
        } else if ("description".equals(fileName)) {
            return COLUMN_DESCRIPTION_DIFF;
        } else if ("dataType".equals(fileName) || "length".equals(fileName) || "precision".equals(fileName)) {
            return COLUMN_DATATYPE_DIFF;
        } else if ("isPrimaryKEY".equals(fileName)) {
            return COLUMN_ISPRIMARYKEY_DIFF;
        } else if ("defaultValue".equals(fileName)) {
            return COLUMN_DEFAULTVALUE_DIFF;
        } else if ("canBeNull".equals(fileName)) {
            return COLUMN_CANBENULL_DIFF;
        }
        return COLUMN_CODE_DIFF;
    }
    
}
