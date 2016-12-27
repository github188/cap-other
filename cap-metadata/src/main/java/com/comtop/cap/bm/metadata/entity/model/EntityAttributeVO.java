/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.entity.model;

import java.util.List;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 实体属性VO
 * 
 * @author 章尊志
 * @since 1.0
 * @version 2014-9-17 章尊志
 */
@DataTransferObject
public class EntityAttributeVO extends BaseMetadata {
    
    /** 序列化ID */
    @CompareIgnore
    private static final long serialVersionUID = 1L;
    
    /** 访问级别 {@link com.comtop.cap.bm.metadata.entity.model.AccessLevel} */
    @CompareIgnore
    private String accessLevel;
    
    /** 实体属性数据类型 {@link com.comtop.cap.bm.metadata.entity.model.AttributeSourceType} */
    @CompareIgnore
    private DataTypeVO attributeType;
    
    /** 属性的长度，非数据库字段的长度 */
    private int attributeLength;
    
    /** 属性的精度，非数据库字段的精度，如：(3,2) */
    private String precision;
    
    /** 默认值 */
    private String defaultValue;
    
    /** 是否为空 */
    private boolean allowNull;
    
    /** 是否为主键 */
    private boolean primaryKey;
    
    /** 序号 */
    @CompareIgnore
    private int sortNo;
    
    /** 是否作为查询字段 */
    @CompareIgnore
    private boolean queryField;
    
    /** 查询表达式 */
    @CompareIgnore
    private String queryExpr;
    
    /** 范围查询表达式1 */
    @CompareIgnore
    private String queryRange_1;
    
    /** 范围查询表达式2 */
    @CompareIgnore
    private String queryRange_2;
    
    /** 范围查询标识（记录该字段属于哪个字段的范围查询字段） */
    @CompareIgnore
    private String queryRangeBy;
    
    /** 属性对应的数据库字段对象的对应的Id */
    private String dbFieldId;
    
    /** 属性中文名称 */
    @CompareIgnore
    private String chName;
    
    /** 属性英文名称 */
    @CompareIgnore
    private String engName;
    
    /** 属性描述 */
    private String description;
    
    /** 约束类型 ConstraintType {@link com.comtop.cap.bm.metadata.entity.model.ConstraintType} */
    @CompareIgnore
    private String constraintType;
    
    /** 约束内容，正则表达式内容，脚本内容，数值的最大最小值用；隔开组成字符串 */
    @CompareIgnore
    private String content;
    
    /** 错误消息 */
    @CompareIgnore
    private String errorInfo;
    
    /** 区间开始点 */
    @CompareIgnore
    private String startRange;
    
    /** 区间结束点 */
    @CompareIgnore
    private String endRange;
    
    /** 关联关系的Id */
    @CompareIgnore
    private String relationId;
    
    /** 查询语句的匹配规则 */
    @CompareIgnore
    private String queryMatchRule;
    
    /** 是否是（多对多关系生成的）中间表集合(<code>List<中间实体></code>)字段 */
    @CompareIgnore
    private boolean associateListAttr = false;
    
    /** 与属性相对应的数据项集合 */
    @CompareIgnore
    private List<String> dataItemIds;
    
    /**
     * @return 获取 accessLevel属性值
     */
    public String getAccessLevel() {
        return accessLevel;
    }
    
    /**
     * @param accessLevel 设置 accessLevel 属性值为参数值 accessLevel
     */
    public void setAccessLevel(String accessLevel) {
        this.accessLevel = accessLevel;
    }
    
    /**
     * @return 获取 attributeType属性值
     */
    public DataTypeVO getAttributeType() {
        return attributeType;
    }
    
    /**
     * @param attributeType 设置 attributeType 属性值为参数值 attributeType
     */
    public void setAttributeType(DataTypeVO attributeType) {
        this.attributeType = attributeType;
    }
    
    /**
     * @return 获取 attributeLength属性值
     */
    public int getAttributeLength() {
        return attributeLength;
    }
    
    /**
     * @param attributeLength 设置 attributeLength 属性值为参数值 attributeLength
     */
    public void setAttributeLength(int attributeLength) {
        this.attributeLength = attributeLength;
    }
    
    /**
     * @return 获取 precision属性值
     */
    public String getPrecision() {
        return precision;
    }
    
    /**
     * @param precision 设置 precision 属性值为参数值 precision
     */
    public void setPrecision(String precision) {
        this.precision = precision;
    }
    
    /**
     * @return 获取 defaultValue属性值
     */
    public String getDefaultValue() {
        return defaultValue;
    }
    
    /**
     * @param defaultValue 设置 defaultValue 属性值为参数值 defaultValue
     */
    public void setDefaultValue(String defaultValue) {
        this.defaultValue = defaultValue;
    }
    
    /**
     * @return 获取 allowNull属性值
     */
    public boolean isAllowNull() {
        return allowNull;
    }
    
    /**
     * @param allowNull 设置 allowNull 属性值为参数值 allowNull
     */
    public void setAllowNull(boolean allowNull) {
        this.allowNull = allowNull;
    }
    
    /**
     * @return 获取 primaryKey属性值
     */
    public boolean isPrimaryKey() {
        return primaryKey;
    }
    
    /**
     * @param primaryKey 设置 primaryKey 属性值为参数值 primaryKey
     */
    public void setPrimaryKey(boolean primaryKey) {
        this.primaryKey = primaryKey;
    }
    
    /**
     * @return 获取 sortNo属性值
     */
    public int getSortNo() {
        return sortNo;
    }
    
    /**
     * @param sortNo 设置 sortNo 属性值为参数值 sortNo
     */
    public void setSortNo(int sortNo) {
        this.sortNo = sortNo;
    }
    
    /**
     * @return 获取 queryField属性值
     */
    public boolean isQueryField() {
        return queryField;
    }
    
    /**
     * @param queryField 设置 queryField 属性值为参数值 queryField
     */
    public void setQueryField(boolean queryField) {
        this.queryField = queryField;
    }
    
    /**
     * @return 获取 queryExpr属性值
     */
    public String getQueryExpr() {
        return queryExpr;
    }
    
    /**
     * @param queryExpr 设置 queryExpr 属性值为参数值 queryExpr
     */
    public void setQueryExpr(String queryExpr) {
        this.queryExpr = queryExpr;
    }
    
    /**
     * @return 获取 queryRange_1属性值
     */
    public String getQueryRange_1() {
        return queryRange_1;
    }
    
    /**
     * @param queryRange_1 设置 queryRange_1 属性值为参数值 queryRange_1
     */
    public void setQueryRange_1(String queryRange_1) {
        this.queryRange_1 = queryRange_1;
    }
    
    /**
     * @return 获取 queryRange_2属性值
     */
    public String getQueryRange_2() {
        return queryRange_2;
    }
    
    /**
     * @param queryRange_2 设置 queryRange_2 属性值为参数值 queryRange_2
     */
    public void setQueryRange_2(String queryRange_2) {
        this.queryRange_2 = queryRange_2;
    }
    
    /**
     * @return 获取 queryRangeBy属性值
     */
    public String getQueryRangeBy() {
        return queryRangeBy;
    }
    
    /**
     * @param queryRangeBy 设置 queryRangeBy 属性值为参数值 queryRangeBy
     */
    public void setQueryRangeBy(String queryRangeBy) {
        this.queryRangeBy = queryRangeBy;
    }
    
    /**
     * @return 获取 dbFieldId属性值
     */
    public String getDbFieldId() {
        return dbFieldId;
    }
    
    /**
     * @param dbFieldId 设置 dbFieldId 属性值为参数值 dbFieldId
     */
    public void setDbFieldId(String dbFieldId) {
        this.dbFieldId = dbFieldId;
    }
    
    /**
     * @return 获取 chName属性值
     */
    public String getChName() {
        return chName;
    }
    
    /**
     * @param chName 设置 chName 属性值为参数值 chName
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
     * @param engName 设置 engName 属性值为参数值 engName
     */
    public void setEngName(String engName) {
        this.engName = engName;
    }
    
    /**
     * @return 获取 description属性值
     */
    public String getDescription() {
        return description;
    }
    
    /**
     * @param description 设置 description 属性值为参数值 description
     */
    public void setDescription(String description) {
        this.description = description;
    }
    
    /**
     * @return 获取 constraintType属性值
     */
    public String getConstraintType() {
        return constraintType;
    }
    
    /**
     * @param constraintType 设置 constraintType 属性值为参数值 constraintType
     */
    public void setConstraintType(String constraintType) {
        this.constraintType = constraintType;
    }
    
    /**
     * @return 获取 content属性值
     */
    public String getContent() {
        return content;
    }
    
    /**
     * @param content 设置 content 属性值为参数值 content
     */
    public void setContent(String content) {
        this.content = content;
    }
    
    /**
     * @return 获取 errorInfo属性值
     */
    public String getErrorInfo() {
        return errorInfo;
    }
    
    /**
     * @param errorInfo 设置 errorInfo 属性值为参数值 errorInfo
     */
    public void setErrorInfo(String errorInfo) {
        this.errorInfo = errorInfo;
    }
    
    /**
     * @return 获取 startRange属性值
     */
    public String getStartRange() {
        return startRange;
    }
    
    /**
     * @param startRange 设置 startRange 属性值为参数值 startRange
     */
    public void setStartRange(String startRange) {
        this.startRange = startRange;
    }
    
    /**
     * @return 获取 endRange属性值
     */
    public String getEndRange() {
        return endRange;
    }
    
    /**
     * @param endRange 设置 endRange 属性值为参数值 endRange
     */
    public void setEndRange(String endRange) {
        this.endRange = endRange;
    }
    
    /**
     * @return 获取 relationId属性值
     */
    public String getRelationId() {
        return relationId;
    }
    
    /**
     * @param relationId 设置 relationId 属性值为参数值 relationId
     */
    public void setRelationId(String relationId) {
        this.relationId = relationId;
    }
    
    /**
     * @return 获取 queryMatchRule属性值
     */
    public String getQueryMatchRule() {
        return queryMatchRule;
    }
    
    /**
     * @param queryMatchRule 设置 queryMatchRule 属性值为参数值 queryMatchRule
     */
    public void setQueryMatchRule(String queryMatchRule) {
        this.queryMatchRule = queryMatchRule;
    }
    
    /**
     * @return 获取 associateListAttr属性值
     */
    public boolean isAssociateListAttr() {
        return associateListAttr;
    }
    
    /**
     * @param associateListAttr 设置 associateListAttr 属性值为参数值 associateListAttr
     */
    public void setAssociateListAttr(boolean associateListAttr) {
        this.associateListAttr = associateListAttr;
    }
    
    /**
     * @return 获取 dataItemIds属性值
     */
    public List<String> getDataItemIds() {
        return dataItemIds;
    }
    
    /**
     * @param dataItemIds 设置 dataItemIds 属性值为参数值 dataItemIds
     */
    public void setDataItemIds(List<String> dataItemIds) {
        this.dataItemIds = dataItemIds;
    }
    
}
