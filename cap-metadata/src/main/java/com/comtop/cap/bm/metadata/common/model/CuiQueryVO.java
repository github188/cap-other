/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.common.model;

import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 前端查询分页使用的VO
 * 
 * 
 * @author 徐庆庆
 * @since 1.0
 * @version 2014-9-3 徐庆庆
 */
@DataTransferObject
public class CuiQueryVO {
    
    /** 每页显示数量 */
    private int pageSize = 50;
    
    /** 页码 */
    private int pageNo = 1;
    
    /** 排序字段 */
    private String[] sortName;
    
    /** 排序类型 */
    private String[] sortType;
    
    /**
     * @return 获取 pageSize属性值
     */
    public int getPageSize() {
        return pageSize;
    }
    
    /**
     * @param pageSize 设置 pageSize 属性值为参数值 pageSize
     */
    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }
    
    /**
     * @return 获取 pageNo属性值
     */
    public int getPageNo() {
        return pageNo;
    }
    
    /**
     * @param pageNo 设置 pageNo 属性值为参数值 pageNo
     */
    public void setPageNo(int pageNo) {
        this.pageNo = pageNo;
    }
    
    /**
     * @return 获取 sortName属性值
     */
    public String[] getSortName() {
        return sortName;
    }
    
    /**
     * @param sortName 设置 sortName 属性值为参数值 sortName
     */
    public void setSortName(String[] sortName) {
        this.sortName = sortName;
    }
    
    /**
     * @return 获取 sortType属性值
     */
    public String[] getSortType() {
        return sortType;
    }
    
    /**
     * @param sortType 设置 sortType 属性值为参数值 sortType
     */
    public void setSortType(String[] sortType) {
        this.sortType = sortType;
    }
    
}
