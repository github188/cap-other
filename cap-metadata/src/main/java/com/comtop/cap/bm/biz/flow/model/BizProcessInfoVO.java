/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.biz.flow.model;

import java.util.List;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

import com.comtop.cap.bm.biz.common.model.BizBaseVO;
import com.comtop.cap.bm.biz.items.model.BizItemsVO;
import com.comtop.cip.common.util.CAPStringUtils;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 业务流程
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-11-30 CAP
 */
@DataTransferObject
@Table(name = "CAP_BIZ_PROCESS_INFO")
public class BizProcessInfoVO extends BizBaseVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 根据关系BizProcessNode生成业务关联集合,由CIP自动创建。 */
    private List<BizProcessNodeVO> bizProcessNodes;
    
    /** 业务事项 */
    private BizItemsVO bizItem;
    
    /** 主键 */
    @Id
    @Column(name = "ID", length = 40)
    private String id;
    
    /** 流程ID */
    @Column(name = "PROCESS_ID", length = 40)
    private String processId;
    
    /** 流程名称 */
    @Column(name = "PROCESS_NAME", length = 200)
    private String processName;
    
    /** 业务事项ID */
    @Column(name = "ITEMS_ID", length = 40)
    private String itemsId;
    
    /** 编码 */
    @Column(name = "CODE", length = 250)
    private String code;
    
    /** IT实现(实现系统名称，如：oms,生产系统) */
    @Column(name = "SYS_NAME", length = 64)
    private String sysName;
    
    /** 业务流程图ID */
    @Column(name = "FLOW_CHART_ID", length = 40)
    private String flowChartId;
    
    /** 管控策略:指导型，负责型 */
    @Column(name = "MANAGE_POLICY", length = 10)
    private String managePolicy;
    
    /** 南网，省公司，地市局 */
    @Column(name = "PROCESS_LEVEL", length = 10)
    private String processLevel;
    
    /** 全局统一型，地市统一型 */
    @Column(name = "NORM_POLICY", length = 10)
    private String normPolicy;
    
    /** 流程定义 */
    @Column(name = "PROCESS_DEF", length = 4000)
    private String processDef;
    
    /** 工作要求 */
    @Column(name = "WORK_DEMAND", length = 4000)
    private String workDemand;
    
    /** 工作内容 */
    @Column(name = "WORK_CONTEXT", length = 4000)
    private String workContext;
    
    /**查询id*/
    private String queryId;
    
    /** 编码表达式 */
    private static final String codeExpr = "BP-${seq('BizProcess',10,1,1)}";
    
    /**
     * @return 获取 codeExpr属性值
     */
    public static String getCodeExpr() {
        return codeExpr;
    }
    
    /**
     * 
     * 根据关系BizProcessNode生成业务关联集合
     * 
     * @return 根据关系BizProcessNode生成业务关联集合
     */
    public List<BizProcessNodeVO> getBizProcessNodes() {
        return bizProcessNodes;
    }
    
    /**
     * 
     * 设置 根据关系BizProcessNode生成业务关联集合
     * 
     * @param bizProcessNodes 根据关系BizProcessNode生成业务关联集合
     */
    public void setBizProcessNodes(List<BizProcessNodeVO> bizProcessNodes) {
        this.bizProcessNodes = bizProcessNodes;
    }
    
    /**
     * 
     * 获取业务事项
     * 
     * @return 业务事项
     */
    public BizItemsVO getBizItem() {
        return bizItem;
    }
    
    /**
     * 
     * 设置业务事项
     * 
     * @param bizItem 业务事项
     */
    public void setBizItem(BizItemsVO bizItem) {
        this.bizItem = bizItem;
    }
    
    /**
     * @return 获取 主键属性值
     */
    
    public String getId() {
        return id;
    }
    
    /**
     * @param id 设置 主键属性值为参数值 id
     */
    
    public void setId(String id) {
        this.id = id;
    }
    
    /**
     * @return 获取 流程ID属性值
     */
    
    public String getProcessId() {
    	if(CAPStringUtils.isBlank(processId)){
    		this.processId=code;
    	}
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
        return processName;
    }
    
    /**
     * @param processName 设置 流程名称属性值为参数值 processName
     */
    
    public void setProcessName(String processName) {
        this.processName = processName;
    }
    
    /**
     * @return 获取 业务事项ID属性值
     */
    
    public String getItemsId() {
        return itemsId;
    }
    
    /**
     * @param itemsId 设置 业务事项ID属性值为参数值 itemsId
     */
    
    public void setItemsId(String itemsId) {
        this.itemsId = itemsId;
    }
    
    /**
     * @return 获取 编码属性值
     */
    
    public String getCode() {
        return code;
    }
    
    /**
     * @param code 设置 编码属性值为参数值 code
     */
    
    public void setCode(String code) {
        this.code = code;
    }
    
    /**
     * @return 获取 IT实现(实现系统名称，如：oms,生产系统)属性值
     */
    
    public String getSysName() {
        return sysName;
    }
    
    /**
     * @param sysName 设置 IT实现(实现系统名称，如：oms,生产系统)属性值为参数值 sysName
     */
    
    public void setSysName(String sysName) {
        this.sysName = sysName;
    }
    
    /**
     * 获取业务流程图ID
     * 
     * @return 获取业务流程图ID
     */
    public String getFlowChartId() {
        return flowChartId;
    }
    
    /**
     * 
     * 设置业务流程图ID
     * 
     * @param flowChartId 业务流程图ID
     */
    public void setFlowChartId(String flowChartId) {
        this.flowChartId = flowChartId;
    }
    
    /**
     * @return 获取 指导型，负责型属性值
     */
    
    public String getManagePolicy() {
        return managePolicy;
    }
    
    /**
     * @param managePolicy 设置 指导型，负责型属性值为参数值 managePolicy
     */
    
    public void setManagePolicy(String managePolicy) {
        this.managePolicy = managePolicy;
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
     * @return 获取 全局统一型，地市统一型属性值
     */
    
    public String getNormPolicy() {
        return normPolicy;
    }
    
    /**
     * @param normPolicy 设置 全局统一型，地市统一型属性值为参数值 normPolicy
     */
    
    public void setNormPolicy(String normPolicy) {
        this.normPolicy = normPolicy;
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
     * 获取查询id
     * @return 查询id
     */
    public String getQueryId() {
		return queryId;
	}

    /**
     * 设置查询id
     * @param queryId 查询id
     */
	public void setQueryId(String queryId) {
		this.queryId = queryId;
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
    
}
