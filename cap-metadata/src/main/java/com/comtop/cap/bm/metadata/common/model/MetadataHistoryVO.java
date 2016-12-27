/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.common.model;

import java.util.Date;

import com.comtop.cip.common.util.builder.EqualsBuilder;
import com.comtop.cip.common.util.builder.HashCodeBuilder;
import com.comtop.cip.common.util.builder.ReflectionToStringBuilder;
import com.comtop.cip.common.util.builder.ToStringStyle;

/**
 * 元数据SVN库历史数据VO
 * 
 * 
 * @author 沈康
 * @since 1.0
 * @version 2014-6-6 沈康
 */
public class MetadataHistoryVO {
    
    /** 历史版本号 */
    private long versionId;
    
    /** 文件全路径 */
    private String fileFullName;
    
    /** 创建者 */
    private String operator;
    
    /** 创建时间 */
    private Date operateTime;
    
    /** 注释 */
    private String message;
    
    /** 文件名称 */
    private String fileName;
    
    /**
     * @return 获取 fileName属性值
     */
    public String getFileName() {
        return fileName;
    }
    
    /**
     * @param fileName 设置 fileName 属性值为参数值 fileName
     */
    public void setFileName(String fileName) {
        this.fileName = fileName;
    }
    
    /**
     * @return 获取 fileFullName属性值
     */
    public String getFileFullName() {
        return fileFullName;
    }
    
    /**
     * @param fileFullName 设置 fileFullName 属性值为参数值 fileFullName
     */
    public void setFileFullName(String fileFullName) {
        this.fileFullName = fileFullName;
    }
    
    /**
     * @return 获取 versionId属性值
     */
    public long getVersionId() {
        return versionId;
    }
    
    /**
     * @param versionId 设置 versionId 属性值为参数值 versionId
     */
    public void setVersionId(long versionId) {
        this.versionId = versionId;
    }
    
    /**
     * @return 获取 operator属性值
     */
    public String getOperator() {
        return operator;
    }
    
    /**
     * @param operator 设置 operator 属性值为参数值 operator
     */
    public void setOperator(String operator) {
        this.operator = operator;
    }
    
    /**
     * @return 获取 operateTime属性值
     */
    public Date getOperateTime() {
        return operateTime;
    }
    
    /**
     * @param operateTime 设置 operateTime 属性值为参数值 operateTime
     */
    public void setOperateTime(Date operateTime) {
        this.operateTime = operateTime;
    }
    
    /**
     * @return 获取 message属性值
     */
    public String getMessage() {
        return message;
    }
    
    /**
     * @param message 设置 message 属性值为参数值 message
     */
    public void setMessage(String message) {
        this.message = message;
    }
    
    /**
     * 比较对象是否相等
     * 
     * @param objValue 比较对象
     * @return 对象是否相等
     */
    @Override
    public boolean equals(Object objValue) {
        boolean bEqual = super.equals(objValue);
        if (super.equals(objValue)) {
            bEqual = true;
        } else {
            bEqual = EqualsBuilder.reflectionEquals(this, objValue);
        }
        return bEqual;
    }
    
    /**
     * 生成hashCode
     * 
     * @return hashCode值
     * @see java.lang.Object#hashCode()
     */
    @Override
    public int hashCode() {
        return HashCodeBuilder.reflectionHashCode(this);
    }
    
    /**
     * 通用toString
     * 
     * @return 类信息
     */
    @Override
    public String toString() {
        return ReflectionToStringBuilder.toString(this, ToStringStyle.MULTI_LINE_STYLE);
    }
}
