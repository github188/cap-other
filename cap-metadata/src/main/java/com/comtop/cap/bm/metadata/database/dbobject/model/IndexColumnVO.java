/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.database.dbobject.model;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 字段VO
 * 
 * @author 陈志伟
 * @since 1.0
 * @version 2015-10-08 陈志伟
 */
@DataTransferObject
public class IndexColumnVO extends BaseMetadata {
    
    /** 序列化ID */
    private static final long serialVersionUID = 4762025163898325166L;
    
    /** 排序 */
    private String ascending;
    
    /** 表达式 */
    private String expression;
    
    /**	字段	*/
    private ColumnVO column;
    
	/**
	 * @return 获取 column属性值
	 */
	public ColumnVO getColumn() {
		return column;
	}

	/**
	 * @param column 设置 column 属性值为参数值 column
	 */
	public void setColumn(ColumnVO column) {
		this.column = column;
	}

	/**
     * @return 获取 ascending属性值
     */
    public String getAscending() {
        return ascending;
    }
    
    /**
     * @param ascending 设置 ascending 属性值为参数值 ascending
     */
    public void setAscending(String ascending) {
        this.ascending = ascending;
    }
    
    /**
     * @return 获取 expression属性值
     */
    public String getExpression() {
        return expression;
    }
    
    /**
     * @param expression 设置 expression 属性值为参数值 expression
     */
    public void setExpression(String expression) {
        this.expression = expression;
    }
    
}
