/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cip.graph.xmi.bean;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.dom4j.Element;

import com.comtop.cip.graph.xmi.utils.XMIUtil;

/**
 * 
 * 类方法元素
 *
 * @author duqi
 * @since jdk1.6
 * @version 2015年10月20日 duqi
 */
public class UMLOperation extends BaseXMIBean {
    
    /** 可见性 */
    private String visibility = "public";
    
    /** 拥有者域 */
    private String ownerScope = "instance";
    
    /** 是否查询 */
    private String isQuery = "false";
    
    /** 并发性 */
    private String concurrency = "sequential";
    
    /** taggedValuesMap */
    private Map<String, String> taggedValuesMap = new LinkedHashMap<String, String>();
    
    /** 方法参数 */
    private List<UMLOperationParameter> operationParameters = new ArrayList<UMLOperationParameter>();
    
    /** 方法位置 */
    private int position;
    
    /** 数据类型 */
    private UMLDatatype datatype;
    
    /**
     * 构造函数
     * 
     * @param datatype 数据类型 方法的返回类型
     * @param name 方法名称
     * @param visibility 可见性
     * @param position 方法位置
     */
    public UMLOperation(UMLDatatype datatype, String name, String visibility, int position) {
        this.datatype = datatype;
        this.name = name;
        this.position = position;
        this.visibility = visibility;
        initTaggedValue();
    }
    
    /**
     * 初始化taggedValues
     *
     */
    private void initTaggedValue() {
        taggedValuesMap.put("type", datatype.getName());
        taggedValuesMap.put("const", "false");
        taggedValuesMap.put("synchronised", "0");
        taggedValuesMap.put("concurrency", "Sequential");
        taggedValuesMap.put("position", "" + position);
        taggedValuesMap.put("returnarray", "0");
        taggedValuesMap.put("pure", "0");
        taggedValuesMap.put("ea_guid", XMIUtil.getGUID());
        taggedValuesMap.put("ea_localid", "" + XMIUtil.getLocalID());
    }
    
    /**
     * 
     * 转换为XML的DOM结构
     *
     * @param parent 父DOM元素
     */
    public void toDom(Element parent) {
        Element operationElement = parent.addElement("UML:Operation");
        XMIUtil.addElementAttribute(operationElement, "name", this.name);
        XMIUtil.addElementAttribute(operationElement, "visibility", this.visibility);
        XMIUtil.addElementAttribute(operationElement, "ownerScope", this.ownerScope);
        XMIUtil.addElementAttribute(operationElement, "concurrency", this.concurrency);
        XMIUtil.addElementAttribute(operationElement, "isQuery", this.isQuery);
        XMIUtil.addTaggedValueElement(operationElement, taggedValuesMap);
        
        Element behavioralFeatureParameterElement = operationElement.addElement("UML:BehavioralFeature.parameter");
        for (Iterator<UMLOperationParameter> operationParameterIterator = operationParameters.iterator(); operationParameterIterator
            .hasNext();) {
            UMLOperationParameter next = operationParameterIterator.next();
            next.toDom(behavioralFeatureParameterElement);
        }
        
    }
    
    /**
     * 方法参数
     *
     * @param parameter 添加方法参数
     */
    public void addParameter(UMLOperationParameter parameter) {
        operationParameters.add(parameter);
    }
    
    /**
     * @return 获取 visibility属性值
     */
    public String getVisibility() {
        return visibility;
    }
    
    /**
     * @param visibility 设置 visibility 属性值为参数值 visibility
     */
    public void setVisibility(String visibility) {
        this.visibility = visibility;
    }
    
    /**
     * @return 获取 ownerScope属性值
     */
    public String getOwnerScope() {
        return ownerScope;
    }
    
    /**
     * @param ownerScope 设置 ownerScope 属性值为参数值 ownerScope
     */
    public void setOwnerScope(String ownerScope) {
        this.ownerScope = ownerScope;
    }
    
    /**
     * @return 获取 isQuery属性值
     */
    public String getIsQuery() {
        return isQuery;
    }
    
    /**
     * @param isQuery 设置 isQuery 属性值为参数值 isQuery
     */
    public void setIsQuery(String isQuery) {
        this.isQuery = isQuery;
    }
    
    /**
     * @return 获取 concurrency属性值
     */
    public String getConcurrency() {
        return concurrency;
    }
    
    /**
     * @param concurrency 设置 concurrency 属性值为参数值 concurrency
     */
    public void setConcurrency(String concurrency) {
        this.concurrency = concurrency;
    }
    
    /**
     * @return 获取 taggedValuesMap属性值
     */
    public Map<String, String> getTaggedValuesMap() {
        return taggedValuesMap;
    }
    
    /**
     * @param taggedValuesMap 设置 taggedValuesMap 属性值为参数值 taggedValuesMap
     */
    public void setTaggedValuesMap(Map<String, String> taggedValuesMap) {
        this.taggedValuesMap = taggedValuesMap;
    }
    
    /**
     * @return 获取 operationParameters属性值
     */
    public List<UMLOperationParameter> getOperationParameters() {
        return operationParameters;
    }
    
    /**
     * @param operationParameters 设置 operationParameters 属性值为参数值 operationParameters
     */
    public void setOperationParameters(List<UMLOperationParameter> operationParameters) {
        this.operationParameters = operationParameters;
    }
    
    /**
     * @return 获取 position属性值
     */
    public int getPosition() {
        return position;
    }
    
    /**
     * @param position 设置 position 属性值为参数值 position
     */
    public void setPosition(int position) {
        this.position = position;
    }
    
    /**
     * @return 获取 datatype属性值
     */
    public UMLDatatype getDatatype() {
        return datatype;
    }
    
    /**
     * @param datatype 设置 datatype 属性值为参数值 datatype
     */
    public void setDatatype(UMLDatatype datatype) {
        this.datatype = datatype;
    }
    
}
