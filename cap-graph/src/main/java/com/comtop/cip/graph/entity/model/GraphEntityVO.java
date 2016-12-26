/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cip.graph.entity.model;

import java.util.List;

import javax.persistence.Column;
import javax.persistence.Table;

import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 实体VO
 * 
 * @author 陈志伟
 * @since 1.0
 * @version 2015-7-22 陈志伟
 */
@DataTransferObject
@Table(name = "CIP_ENTITY")
public class GraphEntityVO extends EntityVO {
    
    /** 标识 */
    private static final long serialVersionUID = 1L;
    
    /** 实体属性 */
    @Column(name = "PROCESS_NAME", length = 40)
    private String processName;
    
    /** 实体属性 */
    private List<GraphPageVO> graphPages;
    
    /** 实体与外部模块实体的关联关系 */
    private List<GraphModuleVO> graphFromModules;
    
    /** 实体与外部模块实体的关联关系 */
    private List<GraphModuleVO> graphToModules;
    
    /** 实体属性 */
    //private List<GraphEntityAttributeVO> graphAttributes;
    
    /** 实体方法 */
    //private List<GraphMethodVO> graphMethods;
    
    /**
     * @return 获取 processName属性值
     */
    public String getProcessName() {
        return processName;
    }
    
    /**
     * @param processName 设置 processName 属性值为参数值 processName
     */
    public void setProcessName(String processName) {
        this.processName = processName;
    }
    
    /**
     * @return 获取 graphPages属性值
     */
    public List<GraphPageVO> getGraphPages() {
        return graphPages;
    }
    
    /**
     * @param graphPages 设置 graphPages 属性值为参数值 graphPages
     */
    public void setGraphPages(List<GraphPageVO> graphPages) {
        this.graphPages = graphPages;
    }
    
    /**
     * @return 获取 graphAttributes属性值
     */
//    public List<GraphEntityAttributeVO> getGraphAttributes() {
//        return graphAttributes;
//    }
    
    /**
     * @return 获取 graphFromModules属性值
     */
    public List<GraphModuleVO> getGraphFromModules() {
        return graphFromModules;
    }
    
    /**
     * @param graphFromModules 设置 graphFromModules 属性值为参数值 graphFromModules
     */
    public void setGraphFromModules(List<GraphModuleVO> graphFromModules) {
        this.graphFromModules = graphFromModules;
    }
    
    /**
     * @return 获取 graphToModules属性值
     */
    public List<GraphModuleVO> getGraphToModules() {
        return graphToModules;
    }
    
    /**
     * @param graphToModules 设置 graphToModules 属性值为参数值 graphToModules
     */
    public void setGraphToModules(List<GraphModuleVO> graphToModules) {
        this.graphToModules = graphToModules;
    }
    
    /**
     * @param graphAttributes 设置 graphAttributes 属性值为参数值 graphAttributes
     */
//    public void setGraphAttributes(List<GraphEntityAttributeVO> graphAttributes) {
//        this.graphAttributes = graphAttributes;
//    }
//    
//    /**
//     * @return 获取 graphMethods属性值
//     */
//    public List<GraphMethodVO> getGraphMethods() {
//        return graphMethods;
//    }
//    
//    /**
//     * @param graphMethods 设置 graphMethods 属性值为参数值 graphMethods
//     */
//    public void setGraphMethods(List<GraphMethodVO> graphMethods) {
//        this.graphMethods = graphMethods;
//    }
    
    /**
     * @return 获取 serialversionuid属性值
     */
    public static long getSerialversionuid() {
        return serialVersionUID;
    }
    
}
