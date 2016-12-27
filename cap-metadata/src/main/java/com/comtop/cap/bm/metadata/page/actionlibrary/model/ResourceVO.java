/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.actionlibrary.model;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 引用资源文件VO
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年10月31日 lizhongwen
 */
@DataTransferObject
public class ResourceVO extends BaseMetadata {
    
    /** 文件类型 */
    private String fileType;
    
    /** 文件名称 */
    private String fileName;
    
    /** 包路径 */
    private String packagePath;
    
    /** 内容 */
    private String content;
    
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
     * @return 获取 packagePath属性值
     */
    public String getPackagePath() {
        return packagePath;
    }
    
    /**
     * @param packagePath 设置 packagePath 属性值为参数值 packagePath
     */
    public void setPackagePath(String packagePath) {
        this.packagePath = packagePath;
    }
    
    /**
     * @return 获取 content属性值
     */
    public String getContent() {
        return content;
    }
    
    /**
     * @param content 设置 content 属性值为参数值 content
     */
    public void setContent(String content) {
        this.content = content;
    }
    
}
