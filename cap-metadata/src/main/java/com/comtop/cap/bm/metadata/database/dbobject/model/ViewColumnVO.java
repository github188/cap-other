/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.database.dbobject.model;

import java.util.ArrayList;
import java.util.List;

import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 字段VO
 * 
 * @author 陈志伟
 * @since 1.0
 * @version 2015-10-08 陈志伟
 */
@DataTransferObject
public class ViewColumnVO extends ColumnVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 引用的table列 */
    private List<String> tableColumns = new ArrayList<String>();

	/**
	 * @return the tableColumns
	 */
	public List<String> getTableColumns() {
		return tableColumns;
	}

	/**
	 * @param tableColumns the tableColumns to set
	 */
	public void setTableColumns(List<String> tableColumns) {
		this.tableColumns = tableColumns;
	}
    
}
