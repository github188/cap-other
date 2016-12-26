/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cip.graph.entity.model;

import javax.persistence.Column;

import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 模块依赖关系实体
 * 
 * @author 杜祺
 * @since 1.0
 * @version 2015-7-7 杜祺
 */
@DataTransferObject
public class GraphModuleRelaVO {
    
    /** 源模块ID */
    @Column(name = "SOURCE_MODULE_ID")
    private String sourceModuleId;
    
    /** 目标模块ID */
    @Column(name = "TARGET_MODULE_ID")
    private String targetModuleId;
    
    /**
     * @return 获取 sourceModuleId属性值
     */
    public String getSourceModuleId() {
        return sourceModuleId;
    }
    
    /**
     * @param sourceModuleId 设置 sourceModuleId 属性值为参数值 sourceModuleId
     */
    public void setSourceModuleId(String sourceModuleId) {
        this.sourceModuleId = sourceModuleId;
    }
    
    /**
     * @return 获取 targetModuleId属性值
     */
    public String getTargetModuleId() {
        return targetModuleId;
    }
    
    /**
     * @param targetModuleId 设置 targetModuleId 属性值为参数值 targetModuleId
     */
    public void setTargetModuleId(String targetModuleId) {
        this.targetModuleId = targetModuleId;
    }
    
    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((sourceModuleId == null) ? 0 : sourceModuleId.hashCode());
        result = prime * result + ((targetModuleId == null) ? 0 : targetModuleId.hashCode());
        return result;
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        GraphModuleRelaVO other = (GraphModuleRelaVO) obj;
        if (sourceModuleId == null) {
            if (other.sourceModuleId != null)
                return false;
        } else if (!sourceModuleId.equals(other.sourceModuleId))
            return false;
        if (targetModuleId == null) {
            if (other.targetModuleId != null)
                return false;
        } else if (!targetModuleId.equals(other.targetModuleId))
            return false;
        return true;
    }
    
}
