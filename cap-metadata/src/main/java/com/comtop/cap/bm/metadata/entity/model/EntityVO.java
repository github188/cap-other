/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.entity.model;

import java.util.List;

import com.comtop.cap.bm.metadata.base.consistency.annotation.BaseModelConsistency;
import com.comtop.cap.bm.metadata.base.consistency.annotation.ConsistencyDependOnField;
import com.comtop.cap.bm.metadata.base.inter.SoaRegisterBaseData;
import com.comtop.cap.bm.metadata.base.model.BmBizBaseModel;
import com.comtop.cap.bm.metadata.base.model.SoaBaseType;
import com.comtop.cap.bm.metadata.common.storage.annotation.AggregationField;
import com.comtop.cap.bm.metadata.common.storage.annotation.IgnoreField;
import com.comtop.cap.bm.metadata.consistency.entity.EntityVOConsistencyCheck;
import com.comtop.cap.bm.metadata.database.analyze.Compareable;
import com.comtop.cap.bm.metadata.database.dbobject.model.BaseTableVO;
import com.comtop.cap.bm.metadata.sysmodel.model.CapPackageVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 实体VO
 * 
 * @author 章尊志
 * @since 1.0
 * @version 2014-9-17 章尊志
 */
@DataTransferObject
@BaseModelConsistency(checkClass = EntityVOConsistencyCheck.class)
public class EntityVO extends BmBizBaseModel implements SoaRegisterBaseData, Compareable {
    
    /**
     * 构造方法
     */
    public EntityVO() {
        this.setModelType("entity");
    }
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /**
     * 实体类型 {@link com.comtop.cap.bm.metadata.entity.model.EntityType}
     */
    private String entityType = EntityType.BIZ_ENTITY.getValue();
    
    /** 关联的流程Id */
    private String processId;
    
    /** 对应的表 */
    private String dbObjectName;
    
    /** 包对象的Id */
    private String packageId;
    
    /** 实体关联的数据库对象，视图或者是表 */
    @IgnoreField
    @AggregationField(value = "dbObjectId")
    private BaseTableVO objBaseTableVO;
    
    /** 所在包 */
    @IgnoreField
    private CapPackageVO packageVO;
    
    /** 父实体对象Id */
    private String parentEntityId;
    
    /** 父实体 */
    @IgnoreField
    @AggregationField(value = "parentEntityId")
    private EntityVO parentEntity;
    
    /**
     * 类模式 : common-普通的,abstract-抽象的
     * <P>
     * {@link com.comtop.cap.bm.metadata.entity.model.ClassPattern}
     */
    private String classPattern;
    
    /** 数据库对象Id(表、视图元数据的Id) */
    private String dbObjectId;
    
    /** 是否生成代码 */
    private boolean generateCode = true;
    
    /** 中文名称 */
    private String chName;
    
    /** 实体英文名称 */
    private String engName;
    
    /** 实体别名 */
    private String aliasName;
    
    /** 描述 */
    private String description;
    
    /** 实体属性 */
    @ConsistencyDependOnField(checkClass = "com.comtop.cap.bm.metadata.consistency.entity.EntityAttributeConsistencyCheck")
    private List<EntityAttributeVO> attributes;
    
    /** 实体方法 */
    @ConsistencyDependOnField(checkClass = "com.comtop.cap.bm.metadata.consistency.entity.EntityMethodConsistencyCheck")
    private List<MethodVO> methods;
    
    /** 实体拥有的关系 */
    @ConsistencyDependOnField(checkClass = "com.comtop.cap.bm.metadata.consistency.entity.EntityRelationshipConsistencyCheck")
    private List<EntityRelationshipVO> lstRelation;
    
    /** 与实体相对应的业务对象集合 */
    private List<String> bizObjectIds;
    
    /** 自定义SQL查询条件 */
    private String customSqlCondition;
    
    /** 是否启用自定义SQL查询条件 */
    private boolean customSqlConditionEnable;
    
    /** 文件存储状态 false：表示暂存，不能用于生成代码 true：表示可以用于生成代码 */
    private boolean state = Boolean.TRUE;
    
    /**
     * 实体来源 {@link com.comtop.cap.bm.metadata.entity.model.EntitySource}
     */
    private String entitySource = EntitySource.TABLE_METADATA_IMPORT.getValue();
    
    /**
     * @return 获取 state属性值
     */
    public boolean isState() {
        return state;
    }
    
    /**
     * @param state
     *            设置 state 属性值为参数值 state
     */
    public void setState(boolean state) {
        this.state = state;
    }
    
    /**
     * @return 获取 objAbstractTableVO属性值
     */
    public BaseTableVO getObjBaseTableVO() {
        return objBaseTableVO;
    }
    
    /**
     * @param objBaseTableVO
     *            设置 objAbstractTableVO 属性值为参数值 objBaseTableVO
     */
    public void setObjBaseTableVO(BaseTableVO objBaseTableVO) {
        this.objBaseTableVO = objBaseTableVO;
    }
    
    /**
     * @return 获取 entityType属性值
     */
    public String getEntityType() {
        return entityType;
    }
    
    /**
     * @param entityType
     *            设置 entityType 属性值为参数值 entityType
     */
    public void setEntityType(String entityType) {
        this.entityType = entityType;
    }
    
    /**
     * @return 获取 processId属性值
     */
    public String getProcessId() {
        return processId;
    }
    
    /**
     * @param processId
     *            设置 processId 属性值为参数值 processId
     */
    public void setProcessId(String processId) {
        this.processId = processId;
    }
    
    /**
     * @return 获取 dbObjectName属性值
     */
    public String getDbObjectName() {
        return dbObjectName;
    }
    
    /**
     * @param dbObjectName
     *            设置 dbObjectName 属性值为参数值 dbObjectName
     */
    public void setDbObjectName(String dbObjectName) {
        this.dbObjectName = dbObjectName;
    }
    
    /**
     * @return 获取 packageId属性值
     */
    public String getPackageId() {
        return packageId;
    }
    
    /**
     * @param packageId
     *            设置 packageId 属性值为参数值 packageId
     */
    public void setPackageId(String packageId) {
        this.packageId = packageId;
    }
    
    /**
     * @return 获取 packageVO属性值
     */
    public CapPackageVO getPackageVO() {
        return packageVO;
    }
    
    /**
     * @param packageVO
     *            设置 packageVO 属性值为参数值 packageVO
     */
    public void setPackageVO(CapPackageVO packageVO) {
        this.packageVO = packageVO;
    }
    
    /**
     * @return 获取 parentEntityId属性值
     */
    public String getParentEntityId() {
        return parentEntityId;
    }
    
    /**
     * @param parentEntityId
     *            设置 parentEntityId 属性值为参数值 parentEntityId
     */
    public void setParentEntityId(String parentEntityId) {
        this.parentEntityId = parentEntityId;
    }
    
    /**
     * @return 获取 parentEntity属性值
     */
    public EntityVO getParentEntity() {
        return parentEntity;
    }
    
    /**
     * @param parentEntity
     *            设置 parentEntity 属性值为参数值 parentEntity
     */
    public void setParentEntity(EntityVO parentEntity) {
        this.parentEntity = parentEntity;
    }
    
    /**
     * @return 获取 classPattern属性值
     */
    public String getClassPattern() {
        return classPattern;
    }
    
    /**
     * @param classPattern
     *            设置 classPattern 属性值为参数值 classPattern
     */
    public void setClassPattern(String classPattern) {
        this.classPattern = classPattern;
    }
    
    /**
     * @return 获取 dbObjectId属性值
     */
    public String getDbObjectId() {
        return dbObjectId;
    }
    
    /**
     * @param dbObjectId
     *            设置 dbObjectId 属性值为参数值 dbObjectId
     */
    public void setDbObjectId(String dbObjectId) {
        this.dbObjectId = dbObjectId;
    }
    
    /**
     * @return 获取 generateCode属性值
     */
    public boolean isGenerateCode() {
        return generateCode;
    }
    
    /**
     * @param generateCode
     *            设置 generateCode 属性值为参数值 generateCode
     */
    public void setGenerateCode(boolean generateCode) {
        this.generateCode = generateCode;
    }
    
    /**
     * @return 获取 chName属性值
     */
    public String getChName() {
        return chName;
    }
    
    /**
     * @param chName
     *            设置 chName 属性值为参数值 chName
     */
    public void setChName(String chName) {
        this.chName = chName;
    }
    
    /**
     * @return 获取 engName属性值
     */
    public String getEngName() {
        return engName;
    }
    
    /**
     * @param engName
     *            设置 engName 属性值为参数值 engName
     */
    public void setEngName(String engName) {
        this.engName = engName;
    }
    
    /**
     * @return 获取 aliasName属性值
     */
    public String getAliasName() {
        return aliasName;
    }
    
    /**
     * @param aliasName
     *            设置 aliasName 属性值为参数值 aliasName
     */
    public void setAliasName(String aliasName) {
        this.aliasName = aliasName;
    }
    
    /**
     * @return 获取 description属性值
     */
    public String getDescription() {
        return description;
    }
    
    /**
     * @param description
     *            设置 description 属性值为参数值 description
     */
    public void setDescription(String description) {
        this.description = description;
    }
    
    /**
     * @return 获取 attributes属性值
     */
    public List<EntityAttributeVO> getAttributes() {
        return attributes;
    }
    
    /**
     * @param attributes
     *            设置 attributes 属性值为参数值 attributes
     */
    public void setAttributes(List<EntityAttributeVO> attributes) {
        this.attributes = attributes;
    }
    
    /**
     * @return 获取 methods属性值
     */
    public List<MethodVO> getMethods() {
        return methods;
    }
    
    /**
     * @param methods
     *            设置 methods 属性值为参数值 methods
     */
    public void setMethods(List<MethodVO> methods) {
        this.methods = methods;
    }
    
    /**
     * @return 获取 lstRelation属性值
     */
    public List<EntityRelationshipVO> getLstRelation() {
        return lstRelation;
    }
    
    /**
     * @param lstRelation
     *            设置 lstRelation 属性值为参数值 lstRelation
     */
    public void setLstRelation(List<EntityRelationshipVO> lstRelation) {
        this.lstRelation = lstRelation;
    }
    
    /**
     * @return 获取 bizObjectIds属性值
     */
    public List<String> getBizObjectIds() {
        return bizObjectIds;
    }
    
    /**
     * @param bizObjectIds
     *            设置 bizObjectIds 属性值为参数值 bizObjectIds
     */
    public void setBizObjectIds(List<String> bizObjectIds) {
        this.bizObjectIds = bizObjectIds;
    }
    
    /**
     * @return the customSqlCondition
     */
    public String getCustomSqlCondition() {
        return customSqlCondition;
    }
    
    /**
     * @param customSqlCondition
     *            the customSqlCondition to set
     */
    public void setCustomSqlCondition(String customSqlCondition) {
        this.customSqlCondition = customSqlCondition;
    }
    
    /**
     * @return the isCustomSqlConditionEnable
     */
    public boolean isCustomSqlConditionEnable() {
        return customSqlConditionEnable;
    }
    
    /**
     * @param customSqlConditionEnable
     *            the isCustomSqlConditionEnable to set
     */
    public void setCustomSqlConditionEnable(boolean customSqlConditionEnable) {
        this.customSqlConditionEnable = customSqlConditionEnable;
    }
    
    /**
     * 
     * @see com.comtop.cap.bm.metadata.base.inter.SoaRegisterBaseData#gainObjectType()
     */
    @Override
    public String gainObjectType() {
        return SoaBaseType.ENTITY_TYPE.getValue();
    }
    
    /**
     * @return 是否需要比较
     * 
     * @see com.comtop.cap.bm.metadata.database.analyze.Compareable#needCompare()
     */
    @Override
    public boolean needCompare() {
        return true;
    }
    
    /**
     * @return 获取 entitySource属性值
     */
    public String getEntitySource() {
        return entitySource;
    }
    
    /**
     * @param entitySource 设置 entitySource 属性值为参数值 entitySource
     */
    public void setEntitySource(String entitySource) {
        this.entitySource = entitySource;
    }
    
}
