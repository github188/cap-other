/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.hld.model;

import java.util.Map;

import com.comtop.cap.document.word.docmodel.data.BaseDTO;

/**
 * 数据流转
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年12月30日 lizhiyong
 */
public class DataFlowDTO extends BaseDTO {
    
    /** FIXME */
    private static final long serialVersionUID = 1L;
    
    /** 流转分布 */
    private Map<String, String> flowMap;
    
    /** 实体名称 */
    private String entityName;
    
    /** 实体中文名 */
    private String entityCnName;
    
    /** 实体编码 */
    private String entityCode;
    
    /** 实体id */
    private String entityId;
    
    /**
     * @return 获取 flowMap属性值
     */
    public Map<String, String> getFlowMap() {
        return flowMap;
    }
    
    /**
     * @param flowMap 设置 flowMap 属性值为参数值 flowMap
     */
    public void setFlowMap(Map<String, String> flowMap) {
        this.flowMap = flowMap;
    }
    
    /**
     * @return 获取 entityName属性值
     */
    public String getEntityName() {
        return entityName;
    }
    
    /**
     * @param entityName 设置 entityName 属性值为参数值 entityName
     */
    public void setEntityName(String entityName) {
        this.entityName = entityName;
    }
    
    /**
     * @return 获取 entityCnName属性值
     */
    public String getEntityCnName() {
        return entityCnName;
    }
    
    /**
     * @param entityCnName 设置 entityCnName 属性值为参数值 entityCnName
     */
    public void setEntityCnName(String entityCnName) {
        this.entityCnName = entityCnName;
    }
    
    /**
     * @return 获取 entityCode属性值
     */
    public String getEntityCode() {
        return entityCode;
    }
    
    /**
     * @param entityCode 设置 entityCode 属性值为参数值 entityCode
     */
    public void setEntityCode(String entityCode) {
        this.entityCode = entityCode;
    }
    
    /**
     * @return 获取 entityId属性值
     */
    public String getEntityId() {
        return entityId;
    }
    
    /**
     * @param entityId 设置 entityId 属性值为参数值 entityId
     */
    public void setEntityId(String entityId) {
        this.entityId = entityId;
    }
    
}
