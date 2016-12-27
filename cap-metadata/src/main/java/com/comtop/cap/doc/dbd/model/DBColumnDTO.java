
package com.comtop.cap.doc.dbd.model;

import com.comtop.cap.document.word.docmodel.data.BaseDTO;

/**
 * 数据库文档处理数据转换对象-数据库列对象
 * 
 * @author 李小强
 * @since 1.0
 * @version 2015-12-30 李小强
 */
public class DBColumnDTO extends BaseDTO {
    
    /**
     * 序列号
     */
    private static final long serialVersionUID = 6190678786328829539L;
    
    /** 字段类型 */
    private String dataType;
    
    /** 字段长度 */
    private int length;
    
    /** 可否为空；可以：Y；否则：N */
    private String enableNull;
    
    /** 字段精度 */
    private int precision;
    
    /** 字段描述 */
    private String comment;
    
    /** 列类型-主要在存储过程、函数上使用；入参：InPUt; 出参：Output */
    private String columnType;
    
    /** 是否是主键,是：Y；不是：N */
    private String isPrimaryKey;
    
    /** 缺省值 */
    private String defaultValue;
    
    /** 中文名 */
    private String cnName;
    
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
     * @return 字段类型
     */
    public String getDataType() {
        return dataType;
    }
    
    /**
     * @return 获取 defaultValue属性值
     */
    public String getDefaultValue() {
        return defaultValue;
    }
    
    /**
     * @param defaultValue 设置 defaultValue 属性值为参数值 defaultValue
     */
    public void setDefaultValue(String defaultValue) {
        this.defaultValue = defaultValue;
    }
    
    /**
     * @param dataType 字段类型
     */
    public void setDataType(String dataType) {
        this.dataType = dataType;
    }
    
    /**
     * @return 可否为空；可以：Y；否则：N
     */
    public String getEnableNull() {
        return enableNull;
    }
    
    /**
     * @param enableNull 可否为空；可以：Y；否则：N
     */
    public void setEnableNull(String enableNull) {
        this.enableNull = enableNull;
    }
    
    /**
     * @return 字段精度
     */
    public int getPrecision() {
        return precision;
    }
    
    /**
     * @param precision 字段精度
     */
    public void setPrecision(int precision) {
        this.precision = precision;
    }
    
    /**
     * @return 字段描述
     */
    public String getComment() {
        return comment;
    }
    
    /**
     * @param comment 字段描述
     */
    public void setComment(String comment) {
        this.comment = comment;
    }
    
    /**
     * 是否是主键,是：Y；不是：N
     * 
     * @return 是否是主键,是：Y；不是：N
     */
    public String getIsPrimaryKey() {
        return isPrimaryKey;
    }
    
    /**
     * 是否是主键,是：Y；不是：N
     * 
     * @param isPrimaryKey 是否是主键,是：Y；不是：N
     */
    public void setIsPrimaryKey(String isPrimaryKey) {
        this.isPrimaryKey = isPrimaryKey;
    }
    
    /**
     * @return 列类型-主要在存储过程、函数上使用；入参：InPUt; 出参：Output
     */
    public String getColumnType() {
        return columnType;
    }
    
    /**
     * @param columnType 列类型-主要在存储过程、函数上使用；入参：InPUt; 出参：Output
     */
    public void setColumnType(String columnType) {
        this.columnType = columnType;
    }
    
    /**
     * @return 字段长度
     */
    public int getLength() {
        return length;
    }
    
    /**
     * @param length 字段长度
     */
    public void setLength(int length) {
        this.length = length;
    }
    
    @Override
    public String toString() {
        return "DBColumnBaseDTO [name=" + getName() + ", code=" + getCode() + ", dataType=" + dataType + ", length="
            + length + ", enableNull=" + enableNull + ", precision=" + precision + ", comment=" + comment
            + ", columnType=" + columnType + ", isPrimaryKey=" + isPrimaryKey + "]";
    }
    
}
