/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.preference.model;

import java.sql.Timestamp;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

import com.comtop.top.core.base.model.CoreVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * TestmodelDicClassify
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-6-24 CAP超级管理员
 */
@Table(name = "CAP_TESTMODEL_DIC_CLASSIFY")
@DataTransferObject
public class TestmodelDicClassifyVO extends CoreVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 测试建模字典分类ID */
    @Id
    @Column(name = "ID", length = 50, precision = 0)
    private String id;
    
    /** 测试建模字典分类父ID */
    @Column(name = "PARENT_ID", length = 50, precision = 0)
    private String parentId;
    
    /** 测试建模字典编码 */
    @Column(name = "DICTIONARY_CODE", length = 100, precision = 0)
    private String dictionaryCode;
    
    /** 测试建模字典名称 */
    @Column(name = "DICTIONARY_NAME", length = 100, precision = 0)
    private String dictionaryName;
    
    /** 测试建模字典分类描述 */
    @Column(name = "DICTIONARY_DES", length = 500, precision = 0)
    private String dictionaryDes;
    
    /** 测试建模字典分类创建人ID */
    @Column(name = "CREATOR_ID", length = 32, precision = 0)
    private String creatorId;
    
    /** 测试建模字典分类创建时间 */
    @Column(name = "CREATE_TIME", precision = 0)
    private Timestamp createTime;
    
    /** 测试建模字典分类修改人ID */
    @Column(name = "MODIFIER_ID", length = 32, precision = 0)
    private String modifierId;
    
    /** 测试建模字典分类修改时间 */
    @Column(name = "UPDATE_TIME", precision = 0)
    private Timestamp updateTime;
    
    /** childCount */
    private int childCount;
    
    /**
     * @return 获取 测试建模字典分类ID 属性值
     */
    public String getId() {
        return id;
    }
    
    /**
     * @param id 设置 测试建模字典分类ID 属性值为参数值 id
     */
    public void setId(String id) {
        this.id = id;
    }
    
    /**
     * @return 获取 测试建模字典分类父ID 属性值
     */
    public String getParentId() {
        return parentId;
    }
    
    /**
     * @param parentId 设置 测试建模字典分类父ID 属性值为参数值 parentId
     */
    public void setParentId(String parentId) {
        this.parentId = parentId;
    }
    
    /**
     * @return 获取 测试建模字典编码 属性值
     */
    public String getDictionaryCode() {
        return dictionaryCode;
    }
    
    /**
     * @param dictionaryCode 设置 测试建模字典编码 属性值为参数值 dictionaryCode
     */
    public void setDictionaryCode(String dictionaryCode) {
        this.dictionaryCode = dictionaryCode;
    }
    
    /**
     * @return 获取 测试建模字典名称 属性值
     */
    public String getDictionaryName() {
        return dictionaryName;
    }
    
    /**
     * @param dictionaryName 设置 测试建模字典名称 属性值为参数值 dictionaryName
     */
    public void setDictionaryName(String dictionaryName) {
        this.dictionaryName = dictionaryName;
    }
    
    /**
     * @return 获取 测试建模字典分类描述 属性值
     */
    public String getDictionaryDes() {
        return dictionaryDes;
    }
    
    /**
     * @param dictionaryDes 设置 测试建模字典分类描述 属性值为参数值 dictionaryDes
     */
    public void setDictionaryDes(String dictionaryDes) {
        this.dictionaryDes = dictionaryDes;
    }
    
    /**
     * @return 获取 测试建模字典分类创建人ID 属性值
     */
    public String getCreatorId() {
        return creatorId;
    }
    
    /**
     * @param creatorId 设置 测试建模字典分类创建人ID 属性值为参数值 creatorId
     */
    public void setCreatorId(String creatorId) {
        this.creatorId = creatorId;
    }
    
    /**
     * @return 获取 测试建模字典分类创建时间 属性值
     */
    public Timestamp getCreateTime() {
        return createTime;
    }
    
    /**
     * @param createTime 设置 测试建模字典分类创建时间 属性值为参数值 createTime
     */
    public void setCreateTime(Timestamp createTime) {
        this.createTime = createTime;
    }
    
    /**
     * @return 获取 测试建模字典分类修改人ID 属性值
     */
    public String getModifierId() {
        return modifierId;
    }
    
    /**
     * @param modifierId 设置 测试建模字典分类修改人ID 属性值为参数值 modifierId
     */
    public void setModifierId(String modifierId) {
        this.modifierId = modifierId;
    }
    
    /**
     * @return 获取 测试建模字典分类修改时间 属性值
     */
    public Timestamp getUpdateTime() {
        return updateTime;
    }
    
    /**
     * @param updateTime 设置 测试建模字典分类修改时间 属性值为参数值 updateTime
     */
    public void setUpdateTime(Timestamp updateTime) {
        this.updateTime = updateTime;
    }
    
    /**
     * childCount
     *
     * <pre>
     * 
     * </pre>
     * 
     * @return childCount
     */
    public int getChildCount() {
        return childCount;
    }
    
    /**
     * childCount
     *
     * <pre>
     * 
     * </pre>
     * 
     * @param childCount childCount
     */
    public void setChildCount(int childCount) {
        this.childCount = childCount;
    }
}
