/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.database.dbobject.util;

/**
 * 数据库类型
 * 
 * @author 许畅
 * @since JDK1.7
 * @version 2016年10月20日 许畅 新建
 */
public enum DBType {
    
    /** oracle */
    ORACLE("oracle", 0),
    
    /** MYSQL */
    MYSQL("mysql", 1),
    /** SYBASE */
    SYBASE("sybase", 2),
    
    /** DB2 */
    DB2("DB2", 3),
    
    /** SQL server */
    SQL_SERVER("sqlserver", 4),
    
    /** ACCESS */
    ACCESS("access", 5),
    
    /** 其他类型数据库 */
    OTHER("other", 6);
    
    /** 数据库类型值 */
    private String value;
    
    /** 数据库类型值 */
    private int number;
    
    /**
     * 构造方法
     * 
     * @param value
     *            值
     * @param number number值
     */
    private DBType(String value, int number) {
        this.value = value;
        this.number = number;
    }
    
    /**
     * @return the value
     */
    public String getValue() {
        return value;
    }
    
    /**
     * @return 获取 number属性值
     */
    public int getNumber() {
        return number;
    }
    
}
