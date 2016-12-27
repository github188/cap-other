/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.pdm.model;

import java.util.ArrayList;
import java.util.List;

import com.comtop.cap.bm.metadata.database.dbobject.model.TableVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * PDM物理图VO
 * 
 * @author 陈志伟
 * @since 1.0
 * @version 2015-10-08 陈志伟
 */
@DataTransferObject
public class PdmPhysicalDiagramVO extends PdmBaseVO {
    
    /** 字段集合 */
    private List<TableVO> tables = new ArrayList<TableVO>();
    
    /**
     * @return 获取 tables属性值
     */
    public List<TableVO> getTables() {
        return tables;
    }
    
    /**
     * @param tables 设置 tables 属性值为参数值 tables
     */
    public void setTables(List<TableVO> tables) {
        this.tables = tables;
    }
    
    /**
     * @param table 设置 table 属性值为参数值 table
     */
    public void addTable(TableVO table) {
        tables.add(table);
    }
    
}
