/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.desinger.model;

import java.util.ArrayList;
import java.util.List;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlRootElement;

import com.comtop.cap.bm.metadata.base.consistency.annotation.ConsistencyDependOnField;
import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 页面控件状态表达式模型
 * 
 * @author 诸焕辉
 * @version jdk1.6
 * @version 2015-4-28 诸焕辉
 */
@XmlRootElement(name = "pagecomponentexpression")
@XmlAccessorType(XmlAccessType.PROPERTY)
@DataTransferObject
public class PageComponentExpressionVO extends BaseMetadata {
    
    /** serialVersionUID */
    private static final long serialVersionUID = 6395610635954308944L;
    
    /** 表达式Id */
    private String expressionId;
    
    /** 表达式 */
    private String expression;
    
    /** 表达式类型 */
    private String expressionType;
    
    /**
     * 如果为java表达式是否设置控件状态
     */
    private boolean hasSetState;
    
    /** 页面控件状态集合 */
    @ConsistencyDependOnField
    private List<PageComponentStateVO> pageComponentStateList = new ArrayList<PageComponentStateVO>();
    
    /**
     * @return 获取 expression属性值
     */
    public String getExpression() {
        return expression;
    }
    
    /**
     * @param expression 设置 expression 属性值为参数值 expression
     */
    public void setExpression(String expression) {
        this.expression = expression;
    }
    
    /**
     * @return 获取 expressionType属性值
     */
    public String getExpressionType() {
        return expressionType;
    }
    
    /**
     * @param expressionType 设置 expressionType 属性值为参数值 expressionType
     */
    public void setExpressionType(String expressionType) {
        this.expressionType = expressionType;
    }
    
    /**
     * @return 获取 pageComponentStateList属性值
     */
    public List<PageComponentStateVO> getPageComponentStateList() {
        return pageComponentStateList;
    }
    
    /**
     * @param pageComponentStateList 设置 pageComponentStateList 属性值为参数值 pageComponentStateList
     */
    public void setPageComponentStateList(List<PageComponentStateVO> pageComponentStateList) {
        this.pageComponentStateList = pageComponentStateList;
    }
    
    /**
     * @return the expressionId
     */
    public String getExpressionId() {
        return expressionId;
    }
    
    /**
     * @param expressionId the expressionId to set
     */
    public void setExpressionId(String expressionId) {
        this.expressionId = expressionId;
    }
    
    /**
     * @return the hasSetState
     */
    public boolean isHasSetState() {
        return hasSetState;
    }
    
    /**
     * @param hasSetState the hasSetState to set
     */
    public void setHasSetState(boolean hasSetState) {
        this.hasSetState = hasSetState;
    }
}
