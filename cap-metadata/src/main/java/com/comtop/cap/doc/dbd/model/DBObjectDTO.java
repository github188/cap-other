/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.dbd.model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.comtop.cap.document.word.docmodel.data.BaseDTO;

/**
 * 数据库文档处理数据转换对象-数据表转换对象
 * 
 * @author 李小强
 * @since 1.0
 * @version 2015-12-30 李小强
 */
public class DBObjectDTO extends BaseDTO {
    
    /** 数据对象类型之数据表 */
    public static final int DBOBJECT_TYPE_TABLE = 1;
    
    /** 数据对象类型之数据表 */
    public static final int DBOBJECT_TYPE_VIEW = 2;
    
    /** 数据对象类型之数据表 */
    public static final int DBOBJECT_TYPE_PROCEDURE = 3;
    
    /** 数据对象类型之数据表 */
    public static final int DBOBJECT_TYPE_FUNCTION = 4;
    
    /** 类别对应关系 */
    public static final Map<Integer, String> TYPE_MAP = new HashMap<Integer, String>();
    
    static {
        TYPE_MAP.put(DBOBJECT_TYPE_TABLE, "数据表");
        TYPE_MAP.put(DBOBJECT_TYPE_VIEW, "视图");
        TYPE_MAP.put(DBOBJECT_TYPE_PROCEDURE, "存储过程");
        TYPE_MAP.put(DBOBJECT_TYPE_FUNCTION, "函数");
    }
    
    /**
     * 序列号
     */
    private static final long serialVersionUID = 8094286960351521087L;
    
    /** 注释-表注释 */
    private String comment;
    
    /** 类型<扩展字段>-对象类型（1、表；2、视图；3、存储过程；4：函数） */
    private int type;
    
    /** 类别描述 */
    private String typeDescription;
    
    /** 中文名 */
    private String cnName;
    
    /** 对于数据表、视图的字段集合; 存储过程、函数的参数集合 */
    private List<DBColumnDTO> columnList = new ArrayList<DBColumnDTO>();
    
    /**
     * @return 获取 cnName属性值
     */
    public String getCnName() {
        return cnName;
    }
    
    /**
     * @param cnName 设置 cnName 属性值为参数值 cnName
     */
    public void setCnName(String cnName) {
        this.cnName = cnName;
    }
    
    /**
     * @return 获取 typeDescription属性值
     */
    public String getTypeDescription() {
        return typeDescription;
    }
    
    /**
     * @return 表注释
     */
    public String getComment() {
        return comment;
    }
    
    /***
     * 
     * @param comment 表注释
     */
    public void setComment(String comment) {
        this.comment = comment;
    }
    
    /**
     * @return 类型<扩展字段>-对象类型（1、表；2、视图；3、存储过程；4：函数）
     */
    public int getType() {
        return type;
    }
    
    /**
     * @param type 类型<扩展字段>-对象类型（1、表；2、视图；3、存储过程；4：函数）
     */
    public void setType(int type) {
        this.type = type;
        this.typeDescription = TYPE_MAP.get(type);
    }
    
    /**
     * 获取 对于数据表、视图的字段集合; 存储过程、函数的参数集合
     * 
     * @return 对于数据表、视图的字段集合; 存储过程、函数的参数集合
     */
    public List<DBColumnDTO> getColumnList() {
        return columnList;
    }
    
    /**
     * 设置对于数据表、视图的字段集合; 存储过程、函数的参数集合
     * 
     * @param columnList 对于数据表、视图的字段集合; 存储过程、函数的参数集合
     */
    public void setColumnList(List<DBColumnDTO> columnList) {
        this.columnList = columnList;
    }
    
    @Override
    public String toString() {
        return "DataBaseTableDTO [name=" + getName() + ", code=" + getCode() + ", comment=" + comment + ", type="
            + type + "]";
    }
}
