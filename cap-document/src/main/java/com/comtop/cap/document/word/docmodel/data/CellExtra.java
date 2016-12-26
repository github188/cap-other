/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docmodel.data;

import java.util.List;

/**
 * 表格单元格扩展封装
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年1月12日 lizhongwen
 */
public class CellExtra {
    
    /** 根据内容自动合并 */
    private boolean autoMerge;
    
    /** 被合并的单元格 */
    private boolean merged;
    
    /** 扩展数据 */
    private List<?> data;
    
    /** 数据选择Key表达式 */
    private String keyExpr;
    
    /** 数据选择Key */
    private Object[] keys;
    
    /** 列头标题 表达式 */
    private String label;
    
    /** 变量 */
    private String veriable;
    
    /** 表头 */
    private String header;
    
    /** 扩展槽 */
    private int[] slots;
    
    /** 是否扩展 */
    private boolean extra;
    
    /** 偏移量 */
    private int offset = 1;
    
    /** 占位值 */
    private int occupy = 1;
    
    /** 列宽 */
    private float width;
    
    /** 占行 */
    private int rowspan;
    
    /** 占列 */
    private int colspan;
    
    /** 数据映射 */
    private String dataSource;
    
    /**
     * @return 获取 autoMerge属性值
     */
    public boolean isAutoMerge() {
        return autoMerge;
    }
    
    /**
     * @param autoMerge 设置 autoMerge 属性值为参数值 autoMerge
     */
    public void setAutoMerge(boolean autoMerge) {
        this.autoMerge = autoMerge;
    }
    
    /**
     * @return 获取 merged属性值
     */
    public boolean isMerged() {
        return merged;
    }
    
    /**
     * @param merged 设置 merged 属性值为参数值 merged
     */
    public void setMerged(boolean merged) {
        this.merged = merged;
    }
    
    /**
     * @return 获取 data属性值
     */
    public List<?> getData() {
        return data;
    }
    
    /**
     * @param data 设置 data 属性值为参数值 data
     */
    public void setData(List<?> data) {
        this.data = data;
    }
    
    /**
     * @return 获取 keyExpr属性值
     */
    public String getKeyExpr() {
        return keyExpr;
    }
    
    /**
     * @param keyExpr 设置 keyExpr 属性值为参数值 keyExpr
     */
    public void setKeyExpr(String keyExpr) {
        this.keyExpr = keyExpr;
    }
    
    /**
     * @return 获取 keys属性值
     */
    public Object[] getKeys() {
        return keys;
    }
    
    /**
     * @param keys 设置 keys 属性值为参数值 keys
     */
    public void setKeys(Object[] keys) {
        this.keys = keys;
    }
    
    /**
     * @return 获取 label属性值
     */
    public String getLabel() {
        return label;
    }
    
    /**
     * @param label 设置 label 属性值为参数值 label
     */
    public void setLabel(String label) {
        this.label = label;
    }
    
    /**
     * @return 获取 veriable属性值
     */
    public String getVeriable() {
        return veriable;
    }
    
    /**
     * @param veriable 设置 veriable 属性值为参数值 veriable
     */
    public void setVeriable(String veriable) {
        this.veriable = veriable;
    }
    
    /**
     * @return 获取 header属性值
     */
    public String getHeader() {
        return header;
    }
    
    /**
     * @param header 设置 header 属性值为参数值 header
     */
    public void setHeader(String header) {
        this.header = header;
    }
    
    /**
     * @return 获取 slots属性值
     */
    public int[] getSlots() {
        return slots;
    }
    
    /**
     * @param slots 设置 slots 属性值为参数值 slots
     */
    public void setSlots(int[] slots) {
        this.slots = slots;
    }
    
    /**
     * @return 获取 extra属性值
     */
    public boolean isExtra() {
        return extra;
    }
    
    /**
     * @param extra 设置 extra 属性值为参数值 extra
     */
    public void setExtra(boolean extra) {
        this.extra = extra;
    }
    
    /**
     * @return 获取 offset属性值
     */
    public int getOffset() {
        return offset;
    }
    
    /**
     * @param offset 设置 offset 属性值为参数值 offset
     */
    public void setOffset(int offset) {
        this.offset = offset;
    }
    
    /**
     * @return 获取 occupy属性值
     */
    public int getOccupy() {
        return occupy;
    }
    
    /**
     * @param occupy 设置 occupy 属性值为参数值 occupy
     */
    public void setOccupy(int occupy) {
        this.occupy = occupy;
    }
    
    /**
     * @return 获取 width属性值
     */
    public float getWidth() {
        return width;
    }
    
    /**
     * @param width 设置 width 属性值为参数值 width
     */
    public void setWidth(float width) {
        this.width = width;
    }
    
    /**
     * @return 获取 rowspan属性值
     */
    public int getRowspan() {
        return rowspan;
    }
    
    /**
     * @param rowspan 设置 rowspan 属性值为参数值 rowspan
     */
    public void setRowspan(int rowspan) {
        this.rowspan = rowspan;
    }
    
    /**
     * @return 获取 colspan属性值
     */
    public int getColspan() {
        return colspan;
    }
    
    /**
     * @param colspan 设置 colspan 属性值为参数值 colspan
     */
    public void setColspan(int colspan) {
        this.colspan = colspan;
    }
    
    /**
     * @return 获取 dataSource属性值
     */
    public String getDataSource() {
        return dataSource;
    }
    
    /**
     * @param dataSource 设置 dataSource 属性值为参数值 dataSource
     */
    public void setDataSource(String dataSource) {
        this.dataSource = dataSource;
    }
    
    /**
     * 
     * @see java.lang.Object#toString()
     */
    @Override
    public String toString() {
        return "CellExtra [merged=" + merged + ", rowspan=" + rowspan + ", colspan=" + colspan + "]";
    }
}
