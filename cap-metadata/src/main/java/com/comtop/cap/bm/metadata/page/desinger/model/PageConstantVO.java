/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.desinger.model;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import com.comtop.cap.bm.metadata.common.dwr.CapMap;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 页面常量VO
 * 
 * @author 郑重
 * @version jdk1.5
 * @version 2015-7-10 郑重
 */
@DataTransferObject
public class PageConstantVO extends BaseMetadata {
    
    /** serialVersionUID */
    private static final long serialVersionUID = -2373265771751194068L;
    
    /** 常量名称 */
    private String constantName;
    
    /** 常量类型 */
    private String constantType;
    
    /** 常量值 */
    private String constantValue;
    
    /** 常量描述 */
    private String constantDescription;
    
    /** 常量元数据 */
    private CapMap constantOption;
    
    /**
     * @return the constantName
     */
    public String getConstantName() {
        return constantName;
    }
    
    /**
     * @param constantName the constantName to set
     */
    public void setConstantName(String constantName) {
        this.constantName = constantName;
    }
    
    /**
     * @return the constantType
     */
    public String getConstantType() {
        return constantType;
    }
    
    /**
     * @param constantType the constantType to set
     */
    public void setConstantType(String constantType) {
        this.constantType = constantType;
    }
    
    /**
     * @return the constantValue
     */
    public String getConstantValue() {
        return constantValue;
    }
    
    /**
     * @param constantValue the constantValue to set
     */
    public void setConstantValue(String constantValue) {
        this.constantValue = constantValue;
    }
    
    /**
     * @return the constantDescription
     */
    public String getConstantDescription() {
        return constantDescription;
    }
    
    /**
     * @param constantDescription the constantDescription to set
     */
    public void setConstantDescription(String constantDescription) {
        this.constantDescription = constantDescription;
    }
    
    /**
     * @return the constantOption
     */
    public CapMap getConstantOption() {
        return constantOption;
    }
    
    /**
     * @param constantOption the constantOption to set
     */
    public void setConstantOption(CapMap constantOption) {
        this.constantOption = constantOption;
    }
}
