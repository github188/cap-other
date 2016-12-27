/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.database.dbobject.model;

import java.util.ArrayList;
import java.util.List;

import com.comtop.cap.bm.metadata.database.analyze.Compareable;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * PDM实体基类VO
 * 
 * @author 陈志伟
 * @since 1.0
 * @version 2015-10-08 陈志伟
 */
@DataTransferObject
public class TableVO extends BaseTableVO implements Compareable{
    
    /** 序列化ID */
    private static final long serialVersionUID = -7835839784462129855L;
    
    /** 包含索引 */
    private List<TableIndexVO> indexs = new ArrayList<TableIndexVO>();
    
    /** 关联关系 */
    private List<ReferenceVO> references = new ArrayList<ReferenceVO>();
    
    /** 包含字段 */
    private List<ColumnVO> columns = new ArrayList<ColumnVO>();
    
    /**
     * 构造函数
     */
    public TableVO() {
        this.setModelType("table");
    }
    
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
     * @param colId id
     * @return 获取 columns属性值
     * @throws Exception Exception
     */
    public ColumnVO getColumnVO(String colId) throws Exception {
        for (ColumnVO column : columns) {
            if (colId.equals(column.getId())) {
                return column;
            }
        }
        throw new Exception("");
    }
    
    /**
     * @param strEngName strEngName
     * @return 获取 columns属性值
     */
    @Override
    public ColumnVO getColumnVOByColumnEngName(String strEngName) {
        for (ColumnVO column : columns) {
            if (strEngName.equals(column.getEngName())) {
                return column;
            }
        }
        return null;
    }
    
    /**
     * @return 获取 indexs属性值
     */
    public List<TableIndexVO> getIndexs() {
        return indexs;
    }
    
    /**
     * @param indexs 设置 indexs 属性值为参数值 indexs
     */
    public void setIndexs(List<TableIndexVO> indexs) {
        this.indexs = indexs;
    }
    
    /**
     * @param index 设置 index 属性值为参数值 index
     */
    public void addIndex(TableIndexVO index) {
        indexs.add(index);
    }
    
    /**
     * @return 获取 references属性值
     */
    public List<ReferenceVO> getReferences() {
        return references;
    }
    
    /**
     * @param references 设置 references 属性值为参数值 references
     */
    public void setReferences(List<ReferenceVO> references) {
        this.references = references;
    }

	/**
	 * @return 是否需要比较
	 *
	 * @see com.comtop.cap.bm.metadata.database.analyze.Compareable#needCompare()
	 */
	@Override
	public boolean needCompare() {
		return true;
	}


}
