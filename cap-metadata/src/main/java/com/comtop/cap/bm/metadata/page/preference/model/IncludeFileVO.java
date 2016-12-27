/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.preference.model;

import javax.persistence.Id;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 引入文件
 *
 * @author 诸焕辉
 * @version jdk1.6
 * @version 2015-5-28 诸焕辉
 */
@DataTransferObject
public class IncludeFileVO extends BaseMetadata {
    
    /** serialVersionUID */
    private static final long serialVersionUID = -5621936167463846383L;
    
    /** 文件名称 */
    private String fileName;
    
    /** 文件路径 */
    @Id
    private String filePath;
    
    /** 文件类型 */
    private String fileType;
    
    /** 是否是默认引用文件 */
    private Boolean defaultReference = Boolean.FALSE;
    
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
     * @return 获取 filePath属性值
     */
    public String getFilePath() {
        return filePath;
    }
    
    /**
     * @param filePath 设置 filePath 属性值为参数值 filePath
     */
    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }
    
    /**
     * @return 获取 fileType属性值
     */
    public String getFileType() {
        return fileType;
    }
    
    /**
     * @param fileType 设置 fileType 属性值为参数值 fileType
     */
    public void setFileType(String fileType) {
        this.fileType = fileType;
    }
    
    /**
     * @return 获取 defaultReference属性值
     */
    public Boolean getDefaultReference() {
        return defaultReference;
    }
    
    /**
     * @param defaultReference 设置 defaultReference 属性值为参数值 defaultReference
     */
    public void setDefaultReference(Boolean defaultReference) {
        this.defaultReference = defaultReference;
    }
}
