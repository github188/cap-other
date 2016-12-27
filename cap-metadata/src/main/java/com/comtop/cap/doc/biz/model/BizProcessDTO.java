/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.biz.model;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.document.word.docmodel.data.BaseDTO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 业务流程DTO
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年11月19日 lizhiyong
 */
@DataTransferObject
public class BizProcessDTO extends BaseDTO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 根据关系BizProcessNode生成业务关联集合,由CIP自动创建。 */
    private transient List<BizProcessNodeDTO> bizProcessNodes;
    
    /** 流程ID */
    private String processId;
    
    /** 流程名称 */
    private String processName;
    
    /** 业务事项ID */
    private String bizItemId;
    
    /** 南网，省公司，地市局 */
    private String processLevel;
    
    /** 业务流程分布 */
    private Map<String, String> distributionMap;
    
    /** 流程定义 */
    private String processDef;
    
    /** 工作要求 */
    private String workDemand;
    
    /** 工作内容 */
    private String workContext;
    
    /** 一级业务 */
    private String firstLevelBiz;
    
    /** 二级业务 */
    private String secondLevelBiz;
    
    /** 业务事项编码 */
    private String bizItemCode;
    
    /** 业务事项名称 */
    private String bizItemName;
    
    /** 业务事项业务域 */
    private String bizItemDomainId;
    
    /** 把控策略(指导型，负责型) */
    private String managePolicy;
    
    /** 统一规范策略(全局统一型，地市统一型) */
    private String normPolicy;
    
    /** IT实现 **/
    private String itImpl;
    
    /** 业务事项 **/
    private BizItemDTO bizItem;
    
    /** 业务流程图 */
    private String flowChartId;
    
    /**
     * @return 获取 distributionMap属性值
     */
    public Map<String, String> getDistributionMap() {
        return distributionMap;
    }
    
    /**
     * @param distributionMap 设置 distributionMap 属性值为参数值 distributionMap
     */
    public void setDistributionMap(Map<String, String> distributionMap) {
        this.distributionMap = distributionMap;
    }
    
    /**
     * @return 获取 流程ID属性值
     */
    
    public String getProcessId() {
        return processId;
    }
    
    /**
     * @param processId 设置 流程ID属性值为参数值 processId
     */
    
    public void setProcessId(String processId) {
        this.processId = processId;
    }
    
    /**
     * @return 获取 流程名称属性值
     */
    
    public String getProcessName() {
        return StringUtils.isBlank(processName) ? getName() : processName;
    }
    
    /**
     * @param processName 设置 流程名称属性值为参数值 processName
     */
    
    public void setProcessName(String processName) {
        this.processName = processName;
        setName(processName);
    }
    
    /**
     * @return 获取 南网，省公司，地市局属性值
     */
    
    public String getProcessLevel() {
        return processLevel;
    }
    
    /**
     * @param processLevel 设置 南网，省公司，地市局属性值为参数值 processLevel
     */
    
    public void setProcessLevel(String processLevel) {
        this.processLevel = processLevel;
    }
    
    /**
     * @return 获取 流程定义属性值
     */
    
    public String getProcessDef() {
        return processDef;
    }
    
    /**
     * @param processDef 设置 流程定义属性值为参数值 processDef
     */
    
    public void setProcessDef(String processDef) {
        this.processDef = processDef;
    }
    
    /**
     * @return 获取 工作要求属性值
     */
    
    public String getWorkDemand() {
        return workDemand;
    }
    
    /**
     * @param workDemand 设置 工作要求属性值为参数值 workDemand
     */
    
    public void setWorkDemand(String workDemand) {
        this.workDemand = workDemand;
    }
    
    /**
     * @return 获取 工作内容属性值
     */
    
    public String getWorkContext() {
        return workContext;
    }
    
    /**
     * @param workContext 设置 工作内容属性值为参数值 workContext
     */
    
    public void setWorkContext(String workContext) {
        this.workContext = workContext;
    }
    
    /**
     * @return 获取 bizProcessNodes属性值
     */
    public List<BizProcessNodeDTO> getBizProcessNodes() {
        return bizProcessNodes;
    }
    
    /**
     * @param bizProcessNodeList 设置 bizProcessNodes 属性值为参数值 bizProcessNodes
     */
    public void addBizProcessNodes(List<BizProcessNodeDTO> bizProcessNodeList) {
        if (bizProcessNodeList != null && bizProcessNodeList.size() > 0) {
            for (BizProcessNodeDTO bizProcessNodeDTO : bizProcessNodeList) {
                addBizProcessNode(bizProcessNodeDTO);
            }
        }
    }
    
    /**
     * @param bizProcessNode 设置 bizProcessNodes 属性值为参数值 bizProcessNodes
     */
    public void addBizProcessNode(BizProcessNodeDTO bizProcessNode) {
        if (this.bizProcessNodes == null) {
            bizProcessNodes = new ArrayList<BizProcessNodeDTO>(10);
        }
        bizProcessNodes.add(bizProcessNode);
        bizProcessNode.setBizProcess(this);
    }
    
    /**
     * @return 获取 bizItemId属性值
     */
    public String getBizItemId() {
        return StringUtils.isNotBlank(bizItemId) ? bizItemId : (bizItem == null ? null : bizItem.getId());
    }
    
    /**
     * @param bizItemId 设置 bizItemId 属性值为参数值 bizItemId
     */
    public void setBizItemId(String bizItemId) {
        this.bizItemId = bizItemId;
    }
    
    /**
     * @return 获取 firstLevelBiz属性值
     */
    public String getFirstLevelBiz() {
        return firstLevelBiz;
    }
    
    /**
     * @param firstLevelBiz 设置 firstLevelBiz 属性值为参数值 firstLevelBiz
     */
    public void setFirstLevelBiz(String firstLevelBiz) {
        this.firstLevelBiz = firstLevelBiz;
    }
    
    /**
     * @return 获取 secondLevelBiz属性值
     */
    public String getSecondLevelBiz() {
        return secondLevelBiz;
    }
    
    /**
     * @param secondLevelBiz 设置 secondLevelBiz 属性值为参数值 secondLevelBiz
     */
    public void setSecondLevelBiz(String secondLevelBiz) {
        this.secondLevelBiz = secondLevelBiz;
    }
    
    /**
     * @return 获取 bizItemCode属性值
     */
    public String getBizItemCode() {
        return bizItemCode;
    }
    
    /**
     * @param bizItemCode 设置 bizItemCode 属性值为参数值 bizItemCode
     */
    public void setBizItemCode(String bizItemCode) {
        this.bizItemCode = bizItemCode;
    }
    
    /**
     * @return 获取 bizItemName属性值
     */
    public String getBizItemName() {
        return bizItemName;
    }
    
    /**
     * @param bizItemName 设置 bizItemName 属性值为参数值 bizItemName
     */
    public void setBizItemName(String bizItemName) {
        this.bizItemName = bizItemName;
    }
    
    /**
     * @return 获取 managePolicy属性值
     */
    public String getManagePolicy() {
        return managePolicy;
    }
    
    /**
     * @param managePolicy 设置 managePolicy 属性值为参数值 managePolicy
     */
    public void setManagePolicy(String managePolicy) {
        this.managePolicy = managePolicy;
    }
    
    /**
     * @return 获取 normPolicy属性值
     */
    public String getNormPolicy() {
        return normPolicy;
    }
    
    /**
     * @param normPolicy 设置 normPolicy 属性值为参数值 normPolicy
     */
    public void setNormPolicy(String normPolicy) {
        this.normPolicy = normPolicy;
    }
    
    /**
     * @return 获取 itImpl属性值
     */
    public String getItImpl() {
        return itImpl;
    }
    
    /**
     * @param itImpl 设置 itImpl 属性值为参数值 itImpl
     */
    public void setItImpl(String itImpl) {
        this.itImpl = itImpl;
    }
    
    /**
     * @return 获取 bizItemDTO属性值
     */
    public BizItemDTO getBizItem() {
        return bizItem;
    }
    
    /**
     * @param bizItemDTO 设置 bizItemDTO 属性值为参数值 bizItemDTO
     */
    public void setBizItem(BizItemDTO bizItemDTO) {
        this.bizItem = bizItemDTO;
    }
    
    /**
     * @return 获取 bizItemDomainId属性值
     */
    public String getBizItemDomainId() {
        return bizItemDomainId;
    }
    
    /**
     * @param bizItemDomainId 设置 bizItemDomainId 属性值为参数值 bizItemDomainId
     */
    public void setBizItemDomainId(String bizItemDomainId) {
        this.bizItemDomainId = bizItemDomainId;
    }
    
    /**
     * @return 获取 flowChartId属性值
     */
    public String getFlowChartId() {
        return flowChartId;
    }
    
    /**
     * @param flowChartId 设置 flowChartId 属性值为参数值 flowChartId
     */
    public void setFlowChartId(String flowChartId) {
        this.flowChartId = flowChartId;
    }
    
}
