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
 * TestmodelDicItem
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-6-24 CAP超级管理员
 */
@Table(name = "CAP_TESTMODEL_DIC_ITEM")
@DataTransferObject
public class TestmodelDicItemVO extends CoreVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 测试建模字典分类ID */
    @Id
    @Column(name = "ID", length = 50, precision = 0)
    private String id;
    
    /** 测试建模字典分类ID */
    @Column(name = "CLASSIFY_ID", length = 50, precision = 0)
    private String classifyId;
    
    /** 测试建模字典编码 */
    @Column(name = "DICTIONARY_CODE", length = 100, precision = 0)
    private String dictionaryCode;
    
    /** 测试建模字典名称 */
    @Column(name = "DICTIONARY_NAME", length = 100, precision = 0)
    private String dictionaryName;
    
    /** 测试建模字典类型 */
    @Column(name = "DICTIONARY_TYPE", length = 100, precision = 0)
    private String dictionaryType;
    
    /** 测试建模字典值 */
    @Column(name = "DICTIONARY_VALUE", length = 200, precision = 0)
    private String dictionaryValue;
    
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
     * @return 获取 测试建模字典分类ID 属性值
     */
    public String getClassifyId() {
        return classifyId;
    }
    
    /**
     * @param classifyId 设置 测试建模字典分类ID 属性值为参数值 classifyId
     */
    public void setClassifyId(String classifyId) {
        this.classifyId = classifyId;
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
     * @return 获取 测试建模字典类型 属性值
     */
    public String getDictionaryType() {
        return dictionaryType;
    }
    
    /**
     * @param dictionaryType 设置 测试建模字典类型 属性值为参数值 dictionaryType
     */
    public void setDictionaryType(String dictionaryType) {
        this.dictionaryType = dictionaryType;
    }
    
    /**
     * @return 获取 测试建模字典值 属性值
     */
    public String getDictionaryValue() {
        return dictionaryValue;
    }
    
    /**
     * @param dictionaryValue 设置 测试建模字典值 属性值为参数值 dictionaryValue
     */
    public void setDictionaryValue(String dictionaryValue) {
        this.dictionaryValue = dictionaryValue;
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
    
}
