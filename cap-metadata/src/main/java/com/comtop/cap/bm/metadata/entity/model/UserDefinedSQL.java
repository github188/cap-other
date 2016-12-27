/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.entity.model;

import java.util.List;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 自定义SQL调用信息
 *
 * @author 凌晨
 * @since jdk1.6
 * @version 2015年10月8日 凌晨
 */
@DataTransferObject
public class UserDefinedSQL extends BaseMetadata {
    
    /** 序列化版本号 */
    private static final long serialVersionUID = 1L;
    
    /** 查询参数 */
    private List<String> queryParams;
    
    /** 返回结果 */
    private List<String> returnResult;
    
    /** 查询SQL */
    private String querySQL;
    
    /** 排序语句 */
    private String sortSQL;
    
    /** 用于生成mybatis配置文件中的parameterType */
    private String parameterType;
    
    /** 用于生成mybatis配置文件中的resultType */
    private String resultType;
    
    /**
     * @return 获取 queryParams属性值
     */
    public List<String> getQueryParams() {
        return queryParams;
    }
    
    /**
     * @param queryParams 设置 queryParams 属性值为参数值 queryParams
     */
    public void setQueryParams(List<String> queryParams) {
        this.queryParams = queryParams;
    }
    
    /**
     * @return 获取 returnResult属性值
     */
    public List<String> getReturnResult() {
        return returnResult;
    }
    
    /**
     * @param returnResult 设置 returnResult 属性值为参数值 returnResult
     */
    public void setReturnResult(List<String> returnResult) {
        this.returnResult = returnResult;
    }
    
    /**
     * @return 获取 querySQL属性值
     */
    public String getQuerySQL() {
        return querySQL;
    }
    
    /**
     * @param querySQL 设置 querySQL 属性值为参数值 querySQL
     */
    public void setQuerySQL(String querySQL) {
        this.querySQL = querySQL;
    }
    
    /**
     * @return 获取 sortSQL属性值
     */
    public String getSortSQL() {
        return sortSQL;
    }
    
    /**
     * @param sortSQL 设置 sortSQL 属性值为参数值 sortSQL
     */
    public void setSortSQL(String sortSQL) {
        this.sortSQL = sortSQL;
    }
    
    /**
     * @return 获取 parameterType属性值
     */
    public String getParameterType() {
        return parameterType;
    }
    
    /**
     * @param parameterType 设置 parameterType 属性值为参数值 parameterType
     */
    public void setParameterType(String parameterType) {
        this.parameterType = parameterType;
    }
    
    /**
     * @return 获取 resultType属性值
     */
    public String getResultType() {
        return resultType;
    }
    
    /**
     * @param resultType 设置 resultType 属性值为参数值 resultType
     */
    public void setResultType(String resultType) {
        this.resultType = resultType;
    }
    
}
