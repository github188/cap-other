/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.database.dbobject.model;

import java.util.List;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 索引比较结果
 * 
 * @author 林玉千
 * @since jdk1.6
 * @version 2016-9-26 林玉千 新建
 */
@DataTransferObject
public class IndexCompareResult extends BaseMetadata {
    
    /** 序索引化ID */
    private static final long serialVersionUID = 1L;
    
    /**
     * -2 表示删除该所以, 源索引中存在而目标索引不存在
     */
    public final static int INDEX_DEL = -2;
    
    /**
     * -1 表示新增该索引 ,目标索引中存在而源索引不存在
     */
    public final static int INDEX_ADD = -1;
    
    /**
     * 0 表示相同
     */
    public final static int INDEX_EQUAL = 0;
    
    /**
     * 1 表示索引存在不同
     */
    public final static int INDEX_DIFF = 1;
    
    /** 索引ID */
    private String id;
    
    /** 比较结果：0 表示相同,-2 标识索引被删除 ,-1 表示索引不存在，需要新增，1 表示索引存在不同 */
    private int result;
    
    /** 源表的索引 */
    private TableIndexVO srcIndex;
    
    /** 目标表的索引 */
    private TableIndexVO targetIndex;
    
    /** 目标索引列拼接字符串 */
    private String strTargetIndexColumn;
    
    /**
     * 
     * 构造函数
     */
    public IndexCompareResult() {
        this.result = INDEX_EQUAL;
    }
    
    /**
     * 构造函数
     * 
     * @param id id
     */
    public IndexCompareResult(String id) {
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
     * @return 获取 srcIndex属性值
     */
    public TableIndexVO getSrcIndex() {
        return srcIndex;
    }
    
    /**
     * @param srcIndex 设置 srcIndex 属性值为参数值 srcIndex
     */
    public void setSrcIndex(TableIndexVO srcIndex) {
        this.srcIndex = srcIndex;
    }
    
    /**
     * @return 获取 targetIndex属性值
     */
    public TableIndexVO getTargetIndex() {
        return targetIndex;
    }
    
    /**
     * @param targetIndex 设置 targetIndex 属性值为参数值 targetIndex
     */
    public void setTargetIndex(TableIndexVO targetIndex) {
        this.targetIndex = targetIndex;
    }
    
    /**
     * @return 获取 strTargetIndexColumn属性值
     */
    public String getStrTargetIndexColumn() {
        return strTargetIndexColumn;
    }
    
    /**
     * @param targetIndex 设置 属性值为参数值
     */
    public void setStrTargetIndexColumn(TableIndexVO targetIndex) {
    	strTargetIndexColumn  = strTargetIndexColumn == null ? "" : strTargetIndexColumn;
        List<IndexColumnVO> lstColumn = targetIndex.getColumns();
        for (int i = 0; i < lstColumn.size(); i++) {
            if (i == lstColumn.size() - 1) {
            	 this.strTargetIndexColumn += lstColumn.get(i).getColumn().getCode();
            } else {
                 this.strTargetIndexColumn += lstColumn.get(i).getColumn().getCode() + ",";
            }
        }
    }
    
    /**
     * @param strTargetIndexColumn xx
     */
    public void setStrTargetIndexColumn(String strTargetIndexColumn){
    	this.strTargetIndexColumn = strTargetIndexColumn;
    }
    
}
