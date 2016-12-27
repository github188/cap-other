/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.preference.model;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 内置行为函数
 * 
 * @author 诸焕辉
 * @version jdk1.6
 * @version 2015-5-28 诸焕辉
 */
@DataTransferObject
public class BuiltInActionVO extends BaseMetadata {
    
    /** serialVersionUID */
    private static final long serialVersionUID = 5067744171402494963L;
    
    /** 方法名称 */
    private String actionMethodName;
    
    /** 行为类型（等同于元数据中的modelId） */
    private String type;
    
    /** 关联内置行为函数引入文件名称 */
    private String fileName;
    
    /** 描述 */
    private String description;
    
    /**
     * @return 获取 actionMethodName属性值
     */
    public String getActionMethodName() {
        return actionMethodName;
    }
    
    /**
     * @param actionMethodName 设置 actionMethodName 属性值为参数值 actionMethodName
     */
    public void setActionMethodName(String actionMethodName) {
        this.actionMethodName = actionMethodName;
    }
    
    /**
     * @return 获取 type属性值
     */
    public String getType() {
        return type;
    }
    
    /**
     * @param type 设置 type 属性值为参数值 type
     */
    public void setType(String type) {
        this.type = type;
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
}
