/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.desinger.model;

import com.comtop.cap.bm.metadata.base.consistency.annotation.ConsistencyDependOnField;
import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import com.comtop.cap.bm.metadata.common.storage.annotation.IgnoreField;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 页面控件状态模型
 * 
 * @author 诸焕辉
 * @version jdk1.6
 * @version 2015-4-28 诸焕辉
 */
@DataTransferObject
public class PageComponentStateVO extends BaseMetadata {
    
    /** serialVersionUID */
    private static final long serialVersionUID = -6431827245864617127L;
    
    /** 控件Id */
    @ConsistencyDependOnField(expression="./layoutVO//children[id=\"{0}\"]")
    private String componentId;
    
    /**
     * 用户自定义的控件Id
     */
    @IgnoreField
    private String uiConfigId;
    
    /** 控件中文名 */
    @IgnoreField
    private String cname;
    
    /** 控件英文名 */
    @IgnoreField
    private String ename;
    
    /** 状态 */
    private String state;
    
    /** 是否校验 */
    private boolean hasValidate;
    
    /**
     * @return 获取 componentId属性值
     */
    public String getComponentId() {
        return componentId;
    }
    
    /**
     * @param componentId 设置 componentId 属性值为参数值 componentId
     */
    public void setComponentId(String componentId) {
        this.componentId = componentId;
    }
    
    /**
     * @return 获取 cname属性值
     */
    public String getCname() {
        return cname;
    }
    
    /**
     * @param cname 设置 cname 属性值为参数值 cname
     */
    public void setCname(String cname) {
        this.cname = cname;
    }
    
    /**
     * @return 获取 ename属性值
     */
    public String getEname() {
        return ename;
    }
    
    /**
     * @param ename 设置 ename 属性值为参数值 ename
     */
    public void setEname(String ename) {
        this.ename = ename;
    }
    
    /**
     * @return 获取 state属性值
     */
    public String getState() {
        return state;
    }
    
    /**
     * @param state 设置 state 属性值为参数值 state
     */
    public void setState(String state) {
        this.state = state;
    }
    
    /**
     * @return the hasValidate
     */
    public boolean isHasValidate() {
        return hasValidate;
    }
    
    /**
     * @param hasValidate the hasValidate to set
     */
    public void setHasValidate(boolean hasValidate) {
        this.hasValidate = hasValidate;
    }
    
    /**
     * @return the uiConfigId
     */
    public String getUiConfigId() {
        return uiConfigId;
    }
    
    /**
     * @param uiConfigId the uiConfigId to set
     */
    public void setUiConfigId(String uiConfigId) {
        this.uiConfigId = uiConfigId;
    }
}
