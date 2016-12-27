/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.common.model;

import com.comtop.cip.common.util.builder.EqualsBuilder;
import com.comtop.cip.common.util.builder.HashCodeBuilder;
import com.comtop.cip.common.util.builder.ReflectionToStringBuilder;
import com.comtop.cip.common.util.builder.ToStringStyle;
import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cap.bm.metadata.pkg.model.PackageVO;

/**
 * 节点对应元数据VO
 * 
 * 
 * @author 沈康
 * @since 1.0
 * @version 2014-6-17 沈康
 */
public class MetadataNodeVO {
    
    /** 节点ID */
    private String nodeId;
    
    /** 需要创建的目录 */
    private String workPath;
    
    /** 实体VO */
    private EntityVO entity;
    
    /** 包VO */
    private PackageVO packageVO;
    
    /** 节点类型 */
    private String nodeType;
    
    /**
     * @return 获取 nodeType属性值
     */
    public String getNodeType() {
        return nodeType;
    }
    
    /**
     * @param nodeType 设置 nodeType 属性值为参数值 nodeType
     */
    public void setNodeType(String nodeType) {
        this.nodeType = nodeType;
    }
    
    /**
     * @return 获取 nodeId属性值
     */
    public String getNodeId() {
        return nodeId;
    }
    
    /**
     * @param nodeId 设置 nodeId 属性值为参数值 nodeId
     */
    public void setNodeId(String nodeId) {
        this.nodeId = nodeId;
    }
    
    /**
     * @return 获取 workPath属性值
     */
    public String getWorkPath() {
        return workPath;
    }
    
    /**
     * @param workPath 设置 workPath 属性值为参数值 workPath
     */
    public void setWorkPath(String workPath) {
        this.workPath = workPath;
    }
    
    /**
     * @return 获取 entity属性值
     */
    public EntityVO getEntity() {
        return entity;
    }
    
    /**
     * @param entity 设置 entity 属性值为参数值 entity
     */
    public void setEntity(EntityVO entity) {
        this.entity = entity;
    }
    
    /**
     * @return 获取 packageVO属性值
     */
    public PackageVO getPackageVO() {
        return packageVO;
    }
    
    /**
     * @param packageVO 设置 packageVO 属性值为参数值 packageVO
     */
    public void setPackageVO(PackageVO packageVO) {
        this.packageVO = packageVO;
    }
    
    /**
     * 比较对象是否相等
     * 
     * @param objValue 比较对象
     * @return 对象是否相等
     */
    @Override
    public boolean equals(Object objValue) {
        boolean bEqual = super.equals(objValue);
        if (super.equals(objValue)) {
            bEqual = true;
        } else {
            bEqual = EqualsBuilder.reflectionEquals(this, objValue);
        }
        return bEqual;
    }
    
    /**
     * 生成hashCode
     * 
     * @return hashCode值
     * @see java.lang.Object#hashCode()
     */
    @Override
    public int hashCode() {
        return HashCodeBuilder.reflectionHashCode(this);
    }
    
    /**
     * 通用toString
     * 
     * @return 类信息
     */
    @Override
    public String toString() {
        return ReflectionToStringBuilder.toString(this, ToStringStyle.MULTI_LINE_STYLE);
    }
}
