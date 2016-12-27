/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.desinger.model;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import com.comtop.cap.bm.metadata.common.storage.annotation.IgnoreField;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 权限VO
 * 
 * @author 郑重
 * @version jdk1.6
 * @version 2015-6-30 郑重
 */
@DataTransferObject
public class RightVO extends BaseMetadata{
    
    /** FIXME */
    private static final long serialVersionUID = -2354734494780133304L;

    /** 权限ID */
    private String funcId;
    
    /** 权限名称 */
    @IgnoreField
    private String funcName;
    
    /** 权限编码 */
    @IgnoreField
    private String funcCode;
    
    /**
     * 权限描述
     */
    @IgnoreField
    private String description;
    
    /**
     * 父功能Code
     */
    @IgnoreField
    private String parentFuncCode;
    
    /**
     * @return the funcId
     */
    public String getFuncId() {
        return funcId;
    }
    
    /**
     * @param funcId the funcId to set
     */
    public void setFuncId(String funcId) {
        this.funcId = funcId;
    }
    
    /**
     * @return the funcName
     */
    public String getFuncName() {
        return funcName;
    }
    
    /**
     * @param funcName the funcName to set
     */
    public void setFuncName(String funcName) {
        this.funcName = funcName;
    }
    
    /**
     * @return the funcCode
     */
    public String getFuncCode() {
        return funcCode;
    }
    
    /**
     * @param funcCode the funcCode to set
     */
    public void setFuncCode(String funcCode) {
        this.funcCode = funcCode;
    }
    
    /**
     * @return the description
     */
    public String getDescription() {
        return description;
    }
    
    /**
     * @param description the description to set
     */
    public void setDescription(String description) {
        this.description = description;
    }
    
    /**
     * @return the parentFuncCode
     */
    public String getParentFuncCode() {
        return parentFuncCode;
    }
    
    /**
     * @param parentFuncCode the parentFuncCode to set
     */
    public void setParentFuncCode(String parentFuncCode) {
        this.parentFuncCode = parentFuncCode;
    }
}
