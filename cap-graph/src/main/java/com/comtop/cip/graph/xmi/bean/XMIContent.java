/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cip.graph.xmi.bean;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.dom4j.Element;

/**
 * 
 * 整个XMI文档填充内容的根元素
 *
 * @author duqi
 * @since jdk1.6
 * @version 2015年10月20日 duqi
 */
public class XMIContent {
    
    /** UMLModel集合 */
    private List<UMLModel> models = new ArrayList<UMLModel>();
    
    /** UMLDiagram集合 */
    private List<UMLDiagram> diagrams = new ArrayList<UMLDiagram>();
    
    /**
     * 添加一个UMLModel
     *
     * @param model UMLModel
     */
    public void addModel(UMLModel model) {
        models.add(model);
    }
    
    /**
     * 添加一个图表
     *
     * @param diagram 图表
     */
    public void addDiagram(UMLDiagram diagram) {
        diagrams.add(diagram);
    }
    
    /**
     * 
     * 转换为XML的DOM结构
     *
     * @param parent 父DOM元素
     */
    public void toDom(Element parent) {
        Element elem = (Element) parent.selectSingleNode("XMI.content");
        if (elem == null) {
            elem = parent.addElement("XMI.content");
        }
        for (Iterator<UMLModel> iterator = models.iterator(); iterator.hasNext();) {
            UMLModel model = iterator.next();
            model.toDom(elem);
        }
        for (Iterator<UMLDiagram> iterator = diagrams.iterator(); iterator.hasNext();) {
            UMLDiagram diagram = iterator.next();
            diagram.toDom(elem);
        }
    }
    
    /**
     * @return 获取 models属性值
     */
    public List<UMLModel> getModels() {
        return models;
    }
    
    /**
     * @param models 设置 models 属性值为参数值 models
     */
    public void setModels(List<UMLModel> models) {
        this.models = models;
    }
    
    /**
     * @return 获取 diagrams属性值
     */
    public List<UMLDiagram> getDiagrams() {
        return diagrams;
    }
    
    /**
     * @param diagrams 设置 diagrams 属性值为参数值 diagrams
     */
    public void setDiagrams(List<UMLDiagram> diagrams) {
        this.diagrams = diagrams;
    }
    
}
