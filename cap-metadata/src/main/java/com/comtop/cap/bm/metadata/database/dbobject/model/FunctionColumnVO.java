
package com.comtop.cap.bm.metadata.database.dbobject.model;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 字段VO
 * 
 * @author zhangzunzhi
 * @since 1.0
 * @version 2015-12-22 zhangzunzhi
 */
@DataTransferObject
public class FunctionColumnVO extends BaseMetadata {
    
    /** 序列化ID */
    private static final long serialVersionUID = -312245421173239869L;
    
    /** 数据类型 */
    private String dataType;
    
    /** 长度 */
    private int length;
    
    /** 精度 */
    private int precision;
    
    /** 参数名称 */
    private String parameterName;
    
    /** 参数中文名 */
    private String parameterChName;
    
    /** 参数类型 */
    private String parameterType;
    
    /** 描述 */
    private String description;
    
    /**
     * @return 获取 dataType属性值
     */
    public String getDataType() {
        return dataType;
    }
    
    /**
     * @param dataType 设置 dataType 属性值为参数值 dataType
     */
    public void setDataType(String dataType) {
        this.dataType = dataType;
    }
    
    /**
     * @return 获取 length属性值
     */
    public int getLength() {
        return length;
    }
    
    /**
     * @param length 设置 length 属性值为参数值 length
     */
    public void setLength(int length) {
        this.length = length;
    }
    
    /**
     * @return 获取 precision属性值
     */
    public int getPrecision() {
        return precision;
    }
    
    /**
     * @param precision 设置 precision 属性值为参数值 precision
     */
    public void setPrecision(int precision) {
        this.precision = precision;
    }
    
    /**
     * @return 获取 parameterName属性值
     */
    public String getParameterName() {
        return parameterName;
    }
    
    /**
     * @param parameterName 设置 parameterName 属性值为参数值 parameterName
     */
    public void setParameterName(String parameterName) {
        this.parameterName = parameterName;
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
     * @return 获取 description属性值
     */
    public String getDescription() {
        return description;
    }
    
    /**
     * @param description 设置 description 属性值为参数值 description
     */
    public void setDescription(String description) {
        this.description = description;
    }
    
    /**
     * @return 获取 parameterChName属性值
     */
    public String getParameterChName() {
        return parameterChName;
    }
    
    /**
     * @param parameterChName 设置 parameterChName 属性值为参数值 parameterChName
     */
    public void setParameterChName(String parameterChName) {
        this.parameterChName = parameterChName;
    }
    
}
