/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.entity.model;

import java.util.ArrayList;
import java.util.List;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import com.comtop.cap.bm.metadata.entity.model.query.QueryModel;

import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 实体方法VO
 * 
 * @author 凌晨
 * @since 1.0
 * @version 2014-9-17 凌晨
 */
@DataTransferObject
public class MethodVO extends BaseMetadata {
    
    /** 序列化版本号 */
    private static final long serialVersionUID = 1L;
    
    /** 方法Id */
    private String methodId;
    
    /** 方法访问级别 {@link com.comtop.cap.bm.metadata.entity.model.AccessLevel} */
    private String accessLevel;
    
    /** 是否自动生成的方法 */
    private boolean autoMethod;
    
    /** 级联属性 */
    private List<CascadeAttributeVO> lstCascadeAttribute;
    
    /** 方法中文名称 */
    private String chName;
    
    /** 方法英文名称 */
    private String engName;
    
    /** 方法别名 */
    private String aliasName;
    
    /** 方法描述 */
    private String description;
    
    /** 方法throws的异常 */
    private List<ExceptionVO> exceptions;
    
    /** 方法来源 {@link com.comtop.cap.bm.metadata.entity.model.MethodSource} */
    private String methodSource;
    
    /** 方法类型 {@link com.comtop.cap.bm.metadata.entity.model.MethodType} */
    private String methodType;
    
    /** 方法参数 */
    private List<ParameterVO> parameters;
    
    /** 返回值类型 */
    private DataTypeVO returnType;
    
    /** 文档导入导出添加开始 */
    /** 服务特点 */
    private String features;
    
    /** 预期性能 */
    private String expPerformance;
    
    /** 约束设计 */
    private String constraint;
    
    /** 对内，对外 */
    private boolean privateService;
    
    /** 文档导入导出添加结束 */
    
    /**
     * 服务增量类型
     * 
     * {@link com.comtop.cap.bm.metadata.entity.model.ServiceExType}
     */
    private String serviceEx;
    
    /** 是否标注只读事务 */
    private boolean transaction;
    
    /** 方法操作类型 {@link com.comtop.cap.bm.metadata.entity.model.MethodOperateType} */
    private String methodOperateType;
    
    /** 调用的数据库对象 */
    private DBObject dbObjectCalled;
    
    /** 用户自定义sql调用 */
    private UserDefinedSQL userDefinedSQL;
    
    /** 查询建模 */
    private QueryModel queryModel;
    
    /** 查询重写 */
    private QueryExtend queryExtend;
    
    /** 是否需要生成获取count的方法 */
    private boolean needCount;
    
    /** 是否需要分页（生成map里面存listVo和count的方法） */
    private boolean needPagination;
    
    /** 关联的方法名称（用于生成分页方法和记录数方法时，记录原始方法的名称,查询重写也记录关联方法） */
    private String assoMethodName;
    
    /**
     * @return 获取 methodId属性值
     */
    public String getMethodId() {
        return methodId;
    }
    
    /**
     * @param methodId 设置 methodId 属性值为参数值 methodId
     */
    public void setMethodId(String methodId) {
        this.methodId = methodId;
    }
    
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
     * @return 获取 autoMethod属性值
     */
    public boolean isAutoMethod() {
        return autoMethod;
    }
    
    /**
     * @param autoMethod 设置 autoMethod 属性值为参数值 autoMethod
     */
    public void setAutoMethod(boolean autoMethod) {
        this.autoMethod = autoMethod;
    }
    
    /**
     * @return 获取 lstCascadeAttribute属性值
     */
    public List<CascadeAttributeVO> getLstCascadeAttribute() {
        return lstCascadeAttribute;
    }
    
    /**
     * @param lstCascadeAttribute 设置 lstCascadeAttribute 属性值为参数值 lstCascadeAttribute
     */
    public void setLstCascadeAttribute(List<CascadeAttributeVO> lstCascadeAttribute) {
        this.lstCascadeAttribute = lstCascadeAttribute;
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
     * @return 获取 aliasName属性值
     */
    public String getAliasName() {
        return aliasName;
    }
    
    /**
     * @param aliasName 设置 aliasName 属性值为参数值 aliasName
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
     * @param description 设置 description 属性值为参数值 description
     */
    public void setDescription(String description) {
        this.description = description;
    }
    
    /**
     * @return 获取 exceptions属性值
     */
    public List<ExceptionVO> getExceptions() {
        return exceptions;
    }
    
    /**
     * @param exceptions 设置 exceptions 属性值为参数值 exceptions
     */
    public void setExceptions(List<ExceptionVO> exceptions) {
        this.exceptions = exceptions;
    }
    
    /**
     * @return 获取 methodSource属性值
     */
    public String getMethodSource() {
        return methodSource;
    }
    
    /**
     * @param methodSource 设置 methodSource 属性值为参数值 methodSource
     */
    public void setMethodSource(String methodSource) {
        this.methodSource = methodSource;
    }
    
    /**
     * @return 获取 methodType属性值
     */
    public String getMethodType() {
        return methodType;
    }
    
    /**
     * @param methodType 设置 methodType 属性值为参数值 methodType
     */
    public void setMethodType(String methodType) {
        this.methodType = methodType;
    }
    
    /**
     * @return 获取 parameters属性值
     */
    public List<ParameterVO> getParameters() {
        return parameters;
    }
    
    /**
     * @param parameters 设置 parameters 属性值为参数值 parameters
     */
    public void setParameters(List<ParameterVO> parameters) {
        this.parameters = parameters;
    }
    
    /**
     * @return 获取 returnType属性值
     */
    public DataTypeVO getReturnType() {
        return returnType;
    }
    
    /**
     * @param returnType 设置 returnType 属性值为参数值 returnType
     */
    public void setReturnType(DataTypeVO returnType) {
        this.returnType = returnType;
    }
    
    /**
     * @return 获取 serviceEx属性值
     */
    public String getServiceEx() {
        return serviceEx;
    }
    
    /**
     * @param serviceEx 设置 serviceEx 属性值为参数值 serviceEx
     */
    public void setServiceEx(String serviceEx) {
        this.serviceEx = serviceEx;
    }
    
    /**
     * @return 获取 transaction属性值
     */
    public boolean isTransaction() {
        return transaction;
    }
    
    /**
     * @param transaction 设置 transaction 属性值为参数值 transaction
     */
    public void setTransaction(boolean transaction) {
        this.transaction = transaction;
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
     * @return 获取 methodOperateType属性值
     */
    public String getMethodOperateType() {
        return methodOperateType;
    }
    
    /**
     * @param methodOperateType 设置 methodOperateType 属性值为参数值 methodOperateType
     */
    public void setMethodOperateType(String methodOperateType) {
        this.methodOperateType = methodOperateType;
    }
    
    /**
     * @return 获取 dbObjectCalled属性值
     */
    public DBObject getDbObjectCalled() {
        return dbObjectCalled;
    }
    
    /**
     * @param dbObjectCalled 设置 dbObjectCalled 属性值为参数值 dbObjectCalled
     */
    public void setDbObjectCalled(DBObject dbObjectCalled) {
        this.dbObjectCalled = dbObjectCalled;
    }
    
    /**
     * @return 获取 userDefinedSQL属性值
     */
    public UserDefinedSQL getUserDefinedSQL() {
        return userDefinedSQL;
    }
    
    /**
     * @param userDefinedSQL 设置 userDefinedSQL 属性值为参数值 userDefinedSQL
     */
    public void setUserDefinedSQL(UserDefinedSQL userDefinedSQL) {
        this.userDefinedSQL = userDefinedSQL;
    }
    
    /**
     * @return 获取 queryModel属性值
     */
    public QueryModel getQueryModel() {
        return queryModel;
    }
    
    /**
     * @param queryModel 设置 queryModel 属性值为参数值 queryModel
     */
    public void setQueryModel(QueryModel queryModel) {
        this.queryModel = queryModel;
    }
    
    /**
     * @return 获取 needCount属性值
     */
    public boolean isNeedCount() {
        return needCount;
    }
    
    /**
     * @param needCount 设置 needCount 属性值为参数值 needCount
     */
    public void setNeedCount(boolean needCount) {
        this.needCount = needCount;
    }
    
    /**
     * @return 获取 needPagination属性值
     */
    public boolean isNeedPagination() {
        return needPagination;
    }
    
    /**
     * @param needPagination 设置 needPagination 属性值为参数值 needPagination
     */
    public void setNeedPagination(boolean needPagination) {
        this.needPagination = needPagination;
    }
    
    /**
     * @return 获取 assoMethodName属性值
     */
    public String getAssoMethodName() {
        return assoMethodName;
    }
    
    /**
     * @param assoMethodName 设置 assoMethodName 属性值为参数值 assoMethodName
     */
    public void setAssoMethodName(String assoMethodName) {
        this.assoMethodName = assoMethodName;
    }
    
    /**
     * @return 获取方法返回值实体ID集合（供文档导入导出使用）
     */
    public List<String> queryReturnEntityIds() {
        return this.returnType.readRelationEntityIds();
    }
    
    /**
     * @return 获取 features属性值
     */
    public String getFeatures() {
        return features;
    }
    
    /**
     * @param features 设置 features 属性值为参数值 features
     */
    public void setFeatures(String features) {
        this.features = features;
    }
    
    /**
     * @return 获取 expPerformance属性值
     */
    public String getExpPerformance() {
        return expPerformance;
    }
    
    /**
     * @param expPerformance 设置 expPerformance 属性值为参数值 expPerformance
     */
    public void setExpPerformance(String expPerformance) {
        this.expPerformance = expPerformance;
    }
    
    /**
     * @return 获取 constraint属性值
     */
    public String getConstraint() {
        return constraint;
    }
    
    /**
     * @param constraint 设置 constraint 属性值为参数值 constraint
     */
    public void setConstraint(String constraint) {
        this.constraint = constraint;
    }
    
    /**
     * @return 获取 privateService属性值
     */
    public boolean isPrivateService() {
        return privateService;
    }
    
    /**
     * @param privateService 设置 privateService 属性值为参数值 privateService
     */
    public void setPrivateService(boolean privateService) {
        this.privateService = privateService;
    }
    
    /**
     * @return 获取方法参数实体ID集合（供文档导入导出使用）
     */
    public List<String> queryParamEntityIds() {
        List<String> lstResut = new ArrayList<String>();
        if (this.parameters == null || this.parameters.size() == 0) {
            return lstResut;
        }
        for (ParameterVO objParameterVO : this.parameters) {
            lstResut.addAll(objParameterVO.getDataType().readRelationEntityIds());
        }
        
        return lstResut;
    }

	/**
	 * @return the queryExtend 查询重写
	 */
	public QueryExtend getQueryExtend() {
		return queryExtend;
	}

	/**
	 * @param queryExtend the queryExtend to set 查询增强
	 */
	public void setQueryExtend(QueryExtend queryExtend) {
		this.queryExtend = queryExtend;
	}
}
