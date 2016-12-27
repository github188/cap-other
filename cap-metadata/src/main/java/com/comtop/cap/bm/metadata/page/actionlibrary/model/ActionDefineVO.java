/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.actionlibrary.model;

import java.util.ArrayList;
import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlElementWrapper;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;

import org.apache.commons.beanutils.BeanUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.base.consistency.model.FieldConsistencyConfigVO;
import com.comtop.cap.bm.metadata.base.model.BaseModel;
import com.comtop.cap.bm.metadata.page.uilibrary.model.PropertyVO;
import com.comtop.cap.common.xml.CDataAdaptor;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 行为定义模型
 * 
 * @author 诸焕辉
 * @version jdk1.6
 * @version 2015-6-03 诸焕辉
 */
@XmlRootElement(name = "action")
@DataTransferObject
public class ActionDefineVO extends BaseModel {
    
    /** 日志对象 **/
    private static final Logger LOGGER = LoggerFactory.getLogger(ActionDefineVO.class);
    
    /** 标识 */
    private static final long serialVersionUID = 6969959504922530864L;
    
    /** 模块类型 */
    public static final String MODELTYPE = "action";
    
    /** 中文名称 */
    private String cname;
    
    /** 关键字 */
    private String keyword;
    
    /** 描述 */
    private String description;
    
    /** 属性编辑器模式 */
    private String propertyEditor;
    
    /** 属性编辑器页面URL */
    private String propertyEditorPage;
    
    /** 行为类型 */
    private String type;
    
    /** 是否是特殊行为函数（true：表示函数名称不能更改，false：表示函数名称可更改） */
    private Boolean specialMethod;
    
    /** 行为方法名称 */
    private String methodName;
    
    /** 行为方法中文名称 */
    private String methodCname;
    
    /** 行为方法描述 */
    private String methodDescription;
    
    /** 模型包中文名称 */
    private String modelPackageCnName;
    
    /** js引用文件 */
    private List<String> js = new ArrayList<String>();
    
    /** css引用文件 */
    private List<String> css = new ArrayList<String>();
    
    /** 脚本模板 */
    private String script;
    
    /** 控件属性 */
    private List<PropertyVO> properties = new ArrayList<PropertyVO>();
    
    /** 一致性校验配置 */
    private FieldConsistencyConfigVO consistencyConfig;
    
    /**
     * @return the consistencyConfig
     */
    public FieldConsistencyConfigVO getConsistencyConfig() {
        return consistencyConfig;
    }
    
    /**
     * @param consistencyConfig the consistencyConfig to set
     */
    public void setConsistencyConfig(FieldConsistencyConfigVO consistencyConfig) {
        this.consistencyConfig = consistencyConfig;
    }
    
    /**
     * 构造函数
     */
    public ActionDefineVO() {
        this.setModelType(MODELTYPE);
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
     * @return 获取 propertyEditor属性值
     */
    public String getPropertyEditor() {
        return propertyEditor;
    }
    
    /**
     * @param propertyEditor 设置 propertyEditor 属性值为参数值 propertyEditor
     */
    public void setPropertyEditor(String propertyEditor) {
        this.propertyEditor = propertyEditor;
    }
    
    /**
     * @return 获取 propertyEditorPage属性值
     */
    public String getPropertyEditorPage() {
        return propertyEditorPage;
    }
    
    /**
     * @param propertyEditorPage 设置 propertyEditorPage 属性值为参数值 propertyEditorPage
     */
    public void setPropertyEditorPage(String propertyEditorPage) {
        this.propertyEditorPage = propertyEditorPage;
    }
    
    /**
     * @return 获取 js属性值
     */
    @XmlElementWrapper(name = "js")
    @XmlElement(name = "list")
    public List<String> getJs() {
        return js;
    }
    
    /**
     * @param js 设置 js 属性值为参数值 js
     */
    public void setJs(List<String> js) {
        this.js = js;
    }
    
    /**
     * @return 获取 css属性值
     */
    @XmlElementWrapper(name = "css")
    @XmlElement(name = "list")
    public List<String> getCss() {
        return css;
    }
    
    /**
     * @param css 设置 css 属性值为参数值 css
     */
    public void setCss(List<String> css) {
        this.css = css;
    }
    
    /**
     * @return 获取 script属性值
     */
    @XmlElement(name = "script")
    @XmlJavaTypeAdapter(value = CDataAdaptor.class)
    public String getScript() {
        return script;
    }
    
    /**
     * @param script 设置 script 属性值为参数值 script
     */
    public void setScript(String script) {
        this.script = script;
    }
    
    /**
     * @return 获取 properties属性值
     */
    @XmlElementWrapper(name = "properties")
    @XmlElement(name = "property")
    public List<PropertyVO> getProperties() {
        return properties;
    }
    
    /**
     * @param properties 设置 properties 属性值为参数值 properties
     */
    public void setProperties(List<PropertyVO> properties) {
        this.properties = properties;
    }
    
    /**
     * @return 获取 specialMethod属性值
     */
    public Boolean getSpecialMethod() {
        return specialMethod;
    }
    
    /**
     * @param specialMethod 设置 specialMethod 属性值为参数值 specialMethod
     */
    public void setSpecialMethod(Boolean specialMethod) {
        this.specialMethod = specialMethod;
    }
    
    /**
     * @return 获取 methodName属性值
     */
    public String getMethodName() {
        return methodName;
    }
    
    /**
     * @param methodName 设置 methodName 属性值为参数值 methodName
     */
    public void setMethodName(String methodName) {
        this.methodName = methodName;
    }
    
    /**
     * @return 获取 methodCname属性值
     */
    public String getMethodCname() {
        return methodCname;
    }
    
    /**
     * @param methodCname 设置 methodCname 属性值为参数值 methodCname
     */
    public void setMethodCname(String methodCname) {
        this.methodCname = methodCname;
    }
    
    /**
     * @return 获取 methodDescription属性值
     */
    public String getMethodDescription() {
        return methodDescription;
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
     * @param methodDescription 设置 methodDescription 属性值为参数值 methodDescription
     */
    public void setMethodDescription(String methodDescription) {
        this.methodDescription = methodDescription;
    }
    
    /**
     * @return 获取 keyword属性值
     */
    public String getKeyword() {
        return keyword;
    }
    
    /**
     * @param keyword 设置 keyword 属性值为参数值 keyword
     */
    public void setKeyword(String keyword) {
        this.keyword = keyword;
    }
    
    /**
     * @return 获取 modelPackageCnName属性值
     */
    public String getModelPackageCnName() {
        return modelPackageCnName;
    }
    
    /**
     * @param modelPackageCnName 设置 modelPackageCnName 属性值为参数值 modelPackageCnName
     */
    public void setModelPackageCnName(String modelPackageCnName) {
        this.modelPackageCnName = modelPackageCnName;
    }
    
    /*
     * (non-Javadoc)
     * 
     * @see java.lang.Object#clone()
     */
    @Override
    public Object clone() throws CloneNotSupportedException {
        ActionDefineVO objActionDefineVO = new ActionDefineVO();
        try {
            BeanUtils.copyProperties(objActionDefineVO, this);
            List<String> lstJS = new ArrayList<String>(js.size());
            for (int i = 0; i < js.size(); i++) {
                lstJS.add(js.get(i));
            }
            objActionDefineVO.setJs(lstJS);
            List<PropertyVO> lstProperties = new ArrayList<PropertyVO>(properties.size());
            for (int i = 0; i < properties.size(); i++) {
                lstProperties.add(properties.get(i));
            }
            objActionDefineVO.setProperties(lstProperties);
            return objActionDefineVO;
        } catch (Exception e) {
            LOGGER.debug("error", e);
            throw new CloneNotSupportedException("克隆失败");
        }
    }
}
