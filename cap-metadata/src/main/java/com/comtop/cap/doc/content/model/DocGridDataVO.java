/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.content.model;

import java.util.List;

import com.comtop.top.core.base.model.CoreVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 章节内容结构。章节的所有内容均会在此表中存在。以类型字段区分具体的内容存储在什么地方。如果是文本、图片、嵌入式对象内容，则对应存储在文本内容表、图片内容表、嵌入式对象内容表。如果已定义的表格内容，
 * 则将表格内容对应的模型定义将其存储在已定义的模型存储结构中，比如业务事项表、业务对象表等。如果某段纯文本归属于一个已经定义的对象，则会将该文本存储在该对象自己的结构中。
 * 
 * @author 李小芬
 * @since 1.0
 * @version 2015-11-24 李小芬
 */
@DataTransferObject
public class DocGridDataVO extends CoreVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 章名称 */
    private String gridId;
    
    /** 上级ID */
    private String gridJsonData;
    
    /** 上级ID */
    private int count;
    
    /** 数据源的键，当前div的值 */
    private String key;
    
    /** 数据源的值 */
    private List lstGrid;
    
    /**
     * @return gridId
     */
    public String getGridId() {
        return gridId;
    }
    
    /**
     * @param gridId gridId
     */
    public void setGridId(String gridId) {
        this.gridId = gridId;
    }
    
    /**
     * @return gridJsonData
     */
    public String getGridJsonData() {
        return gridJsonData;
    }
    
    /**
     * @param gridJsonData gridJsonData
     */
    public void setGridJsonData(String gridJsonData) {
        this.gridJsonData = gridJsonData;
    }
    
    /**
     * @return count
     */
    public int getCount() {
        return count;
    }
    
    /**
     * @param count count
     */
    public void setCount(int count) {
        this.count = count;
    }
    
    /**
     * @return key
     */
    public String getKey() {
        return key;
    }
    
    /**
     * @param key key
     */
    public void setKey(String key) {
        this.key = key;
    }
    
    /**
     * @return lstGrid
     */
    public List getLstGrid() {
        return lstGrid;
    }
    
    /**
     * @param lstGrid lstGrid
     */
    public void setLstGrid(List lstGrid) {
        this.lstGrid = lstGrid;
    }
    
}
