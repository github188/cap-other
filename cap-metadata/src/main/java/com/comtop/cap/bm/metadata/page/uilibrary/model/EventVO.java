/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.uilibrary.model;

import javax.persistence.Id;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;
import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;

import com.comtop.cap.bm.metadata.base.consistency.model.FieldConsistencyConfigVO;
import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import com.comtop.cap.common.xml.CDataAdaptor;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 控件事件处理
 * 
 * 
 * @author 诸焕辉
 * @since 1.0
 * @version 2015-5-12 诸焕辉
 */
@DataTransferObject
@XmlType(name = "event")
public class EventVO extends BaseMetadata {
    
    /** serialVersionUID */
    private static final long serialVersionUID = 5944239872821252103L;
    
    /** 事件名称 */
    private String cname;
    
    /** 事件类型名称 */
    @Id
    private String ename;
    
    /** 系统内置行为类型 */
    private String type;
    
    /** 默认值 */
    private String defaultValue;
    
    /** 对应的行为模板 */
    private String methodTemplate;
    
    /** 描述 */
    private String description;
    
    /** 行为参数选项 */
    private String methodOption;
    
    /** 是否是常用属性 */
    private Boolean commonAttr;
    
    /** 属性过滤规则 */
    private String filterRule;
    
    /** 是否自动生成需要的行为 */
    private Boolean hasAutoCreate = true;
    
    /** 该属性是否支持批量修改 */
    private Boolean hasBatchEdit;
    
    /** 该属性是否隐藏 */
    private Boolean hide;
    
    /** 行为模板定义 */
    private String actionDefine;
    
    /** 是否生成代码时，忽略属性 */
    private Boolean generateCodeIgnore;
    
    /** 一致性校验配置 */
    private FieldConsistencyConfigVO consistencyConfig;
    
    /**
     * @return the consistencyConfig
     */
    public FieldConsistencyConfigVO getConsistencyConfig() {
        if (this.consistencyConfig != null) {
            this.consistencyConfig.setFieldName(ename);
        }
        return consistencyConfig;
    }
    
    /**
     * @param consistencyConfig the consistencyConfig to set
     */
    public void setConsistencyConfig(FieldConsistencyConfigVO consistencyConfig) {
        this.consistencyConfig = consistencyConfig;
    }
    
    /**
     * @return 获取 cname属性值
     */
    @XmlElement(name = "cname")
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
    @XmlElement(name = "ename")
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
     * @return 获取 methodTemplate属性值
     */
    @XmlElement(name = "methodTemplate")
    public String getMethodTemplate() {
        return methodTemplate;
    }
    
    /**
     * @param methodTemplate 设置 methodTemplate 属性值为参数值 methodTemplate
     */
    public void setMethodTemplate(String methodTemplate) {
        this.methodTemplate = methodTemplate;
    }
    
    /**
     * @return 获取 description属性值
     */
    @XmlElement(name = "description")
    @XmlJavaTypeAdapter(value = CDataAdaptor.class)
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
     * @return 获取 methodOption属性值
     */
    public String getMethodOption() {
        return methodOption;
    }
    
    /**
     * @param methodOption 设置 methodOption 属性值为参数值 methodOption
     */
    public void setMethodOption(String methodOption) {
        this.methodOption = methodOption;
    }
    
    /**
     * @return 获取 commonAttr属性值
     */
    public Boolean getCommonAttr() {
        return commonAttr;
    }
    
    /**
     * @param commonAttr 设置 commonAttr 属性值为参数值 commonAttr
     */
    public void setCommonAttr(Boolean commonAttr) {
        this.commonAttr = commonAttr;
    }
    
    /**
     * @return 获取 defaultValue属性值
     */
    @XmlElement(name = "default")
    public String getDefaultValue() {
        return defaultValue;
    }
    
    /**
     * @param defaultValue 设置 defaultValue 属性值为参数值 defaultValue
     */
    public void setDefaultValue(String defaultValue) {
        this.defaultValue = defaultValue;
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
     * @return 获取 filterRule属性值
     */
    public String getFilterRule() {
        return filterRule;
    }
    
    /**
     * @param filterRule 设置 filterRule 属性值为参数值 filterRule
     */
    public void setFilterRule(String filterRule) {
        this.filterRule = filterRule;
    }
    
    /**
     * @return 获取 hasBatchEdit属性值
     */
    public Boolean getHasBatchEdit() {
        return hasBatchEdit;
    }
    
    /**
     * @param hasBatchEdit 设置 hasBatchEdit 属性值为参数值 hasBatchEdit
     */
    public void setHasBatchEdit(Boolean hasBatchEdit) {
        this.hasBatchEdit = hasBatchEdit;
    }
    
    /**
     * @return 获取 hasAutoCreate属性值
     */
    public Boolean getHasAutoCreate() {
        return hasAutoCreate;
    }
    
    /**
     * @param hasAutoCreate 设置 hasAutoCreate 属性值为参数值 hasAutoCreate
     */
    public void setHasAutoCreate(Boolean hasAutoCreate) {
        this.hasAutoCreate = hasAutoCreate;
    }
    
    /**
     * @return 获取 hide属性值
     */
    public Boolean getHide() {
        return hide;
    }
    
    /**
     * @param hide 设置 hide 属性值为参数值 hide
     */
    public void setHide(Boolean hide) {
        this.hide = hide;
    }
    
    /**
     * @return 获取 actionDefine属性值
     */
    public String getActionDefine() {
        return actionDefine;
    }
    
    /**
     * @param actionDefine 设置 actionDefine 属性值为参数值 actionDefine
     */
    public void setActionDefine(String actionDefine) {
        this.actionDefine = actionDefine;
    }
    
    /**
     * @return 获取 generateCodeIgnore属性值
     */
    public Boolean getGenerateCodeIgnore() {
        return generateCodeIgnore;
    }
    
    /**
     * @param generateCodeIgnore 设置 generateCodeIgnore 属性值为参数值 generateCodeIgnore
     */
    public void setGenerateCodeIgnore(Boolean generateCodeIgnore) {
        this.generateCodeIgnore = generateCodeIgnore;
    }
    
}
