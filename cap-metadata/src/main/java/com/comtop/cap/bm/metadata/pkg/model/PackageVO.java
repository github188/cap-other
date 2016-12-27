/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.pkg.model;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

import com.comtop.cap.bm.metadata.base.model.AbstractBaseMetaDataVO;
import com.comtop.cap.bm.metadata.base.model.IMetaNode;
import com.comtop.cap.bm.metadata.common.model.NodeType;
import com.comtop.cip.validator.org.hibernate.validator.constraints.Length;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 
 * 描述包的元数据实体
 * 
 * @author 柯尚福
 * @since 1.0
 * @version 2014-2-26 柯尚福
 */
@DataTransferObject
@Table(name = "CIP_PACKAGE")
public class PackageVO extends AbstractBaseMetaDataVO implements IMetaNode {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** ID */
    @Id
    @Column(name = "PACKAGE_ID")
    private String id;
    
    /** 包简称 */
    @Length(max = 15)
    @Column(name = "SHORT_NAME", length = 15)
    private String shortName;
    
    /** 包全路径 */
    @Length(max = 300)
    @Column(name = "FULL_PATH", length = 300)
    private String fullPath;
    
    /** 包类型 ,0表示普通包，1表示模块 */
    @Column(name = "PACKAGE_TYPE")
    private int packageType;
    
    /** 父ID */
    private String parentId;
    
    /**
     * @return 获取 parentId属性值
     */
    public String getParentId() {
        return parentId;
    }
    
    /**
     * @param parentId 设置 parentId 属性值为参数值 parentId
     */
    public void setParentId(String parentId) {
        this.parentId = parentId;
    }
    
    /**
     * @return 获取 id属性值
     * @see com.comtop.cap.runtime.base.model.BaseVO#getId()
     */
    @Override
    public String getId() {
        return this.id;
    }
    
    /**
     * @param id 设置 id 属性值为参数值 id
     * 
     * @see com.comtop.cap.runtime.base.model.BaseVO#setId(java.lang.String)
     */
    @Override
    public void setId(String id) {
        this.id = id;
    }
    
    /**
     * @return 获取 shortName属性值
     */
    public String getShortName() {
        return shortName;
    }
    
    /**
     * @param shortName 设置 shortName 属性值为参数值 shortName
     */
    public void setShortName(String shortName) {
        this.shortName = shortName;
    }
    
    /**
     * @return 获取 fullPath属性值
     */
    public String getFullPath() {
        return fullPath;
    }
    
    /**
     * @param fullPath 设置 fullPath 属性值为参数值 fullPath
     */
    public void setFullPath(String fullPath) {
        this.fullPath = fullPath;
    }
    
    /**
     * @return 获取 packageType属性值
     */
    public int getPackageType() {
        return packageType;
    }
    
    /**
     * @param packageType 设置 packageType 属性值为参数值 packageType
     */
    public void setPackageType(int packageType) {
        this.packageType = packageType;
    }
    
    /**
     * 获取节点Id
     * 
     * @return 节点Id
     * @see com.comtop.cap.bm.metadata.base.model.IMetaNode#getNodeId()
     */
    @Override
    public String getNodeId() {
        return this.getId();
    }
    
    /**
     * @return 获取 nodeType属性值
     */
    @Override
    public String getNodeType() {
        String strNodeType;
        switch (packageType) {
            case PackageType.PROJECT_PKG:
                strNodeType = NodeType.PROJECT_NODE;
                break;
            default:
                strNodeType = NodeType.PKG_NODE;
                break;
        }
        return strNodeType;
    }
    
    /**
     * 获取表名称
     * 
     * @return 表名称
     * @see com.comtop.cap.bm.metadata.base.model.IMetaNode#getTableName()
     */
    @Override
    public String getTableName() {
        return null;
    }
    
}
