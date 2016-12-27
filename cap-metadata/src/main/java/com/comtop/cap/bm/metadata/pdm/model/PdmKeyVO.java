/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.pdm.model;

import java.util.ArrayList;
import java.util.List;

import com.comtop.cap.bm.metadata.database.dbobject.model.ColumnVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * PDM键VO
 * 
 * @author 陈志伟
 * @since 1.0
 * @version 2015-10-08 陈志伟
 */
@DataTransferObject
public class PdmKeyVO extends PdmBaseVO {
    
    /** 字段集合 */
    private List<ColumnVO> columns = new ArrayList<ColumnVO>();
    
    /**
     * @return 获取 columns属性值
     */
    public List<ColumnVO> getColumns() {
        return columns;
    }
    
    /**
     * @param columns 设置 columns 属性值为参数值 columns
     */
    public void setColumns(List<ColumnVO> columns) {
        this.columns = columns;
    }
    
    /**
     * @param column 设置 column 属性值为参数值 column
     */
    public void addColumn(ColumnVO column) {
        columns.add(column);
    }
}
