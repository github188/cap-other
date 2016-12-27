/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.entity.facade;

import java.io.File;
import java.io.IOException;
import java.io.StringWriter;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.net.URL;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.LocalVariableTableParameterNameDiscoverer;
import org.springframework.core.ParameterNameDiscoverer;

import com.comtop.bpms.client.ClientFactory;
import com.comtop.bpms.common.AbstractBpmsException;
import com.comtop.bpms.common.model.ProcessInfo;
import com.comtop.cap.bm.metadata.base.consistency.model.ConsistencyCheckResult;
import com.comtop.cap.bm.metadata.base.facade.CapBmBaseFacade;
import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import com.comtop.cap.bm.metadata.common.model.CuiQueryVO;
import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.common.storage.exception.ValidateException;
import com.comtop.cap.bm.metadata.consistency.entity.EntityBeingDependOnFactory;
import com.comtop.cap.bm.metadata.consistency.entity.util.EntityConsistencyUtil;
import com.comtop.cap.bm.metadata.database.dbobject.facade.TableFacade;
import com.comtop.cap.bm.metadata.database.dbobject.model.ColumnVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.ReferenceJoinVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.ReferenceVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.TableVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.ViewColumnVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.ViewVO;
import com.comtop.cap.bm.metadata.database.dbobject.util.TableSysncEntityUtil;
import com.comtop.cap.bm.metadata.database.loader.DatabaseLoaderFactory;
import com.comtop.cap.bm.metadata.database.loader.IDatabaseLoader;
import com.comtop.cap.bm.metadata.database.util.MetaConnection;
import com.comtop.cap.bm.metadata.entity.model.AccessLevel;
import com.comtop.cap.bm.metadata.entity.model.AttributeCompareResult;
import com.comtop.cap.bm.metadata.entity.model.AttributeSourceType;
import com.comtop.cap.bm.metadata.entity.model.AttributeType;
import com.comtop.cap.bm.metadata.entity.model.CascadeAttributeVO;
import com.comtop.cap.bm.metadata.entity.model.ClassPattern;
import com.comtop.cap.bm.metadata.entity.model.DataTypeVO;
import com.comtop.cap.bm.metadata.entity.model.EntityAttributeVO;
import com.comtop.cap.bm.metadata.entity.model.EntityCompareResult;
import com.comtop.cap.bm.metadata.entity.model.EntityRelationshipVO;
import com.comtop.cap.bm.metadata.entity.model.EntitySource;
import com.comtop.cap.bm.metadata.entity.model.EntityType;
import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cap.bm.metadata.entity.model.MethodOperateType;
import com.comtop.cap.bm.metadata.entity.model.MethodVO;
import com.comtop.cap.bm.metadata.entity.model.OracleFieldType;
import com.comtop.cap.bm.metadata.entity.model.ParameterVO;
import com.comtop.cap.bm.metadata.entity.model.QueryRule;
import com.comtop.cap.bm.metadata.entity.model.RelatioMultiple;
import com.comtop.cap.bm.metadata.entity.util.EntityAliasConverter;
import com.comtop.cap.bm.metadata.entity.util.EntityImportUtils;
import com.comtop.cap.bm.metadata.entity.util.EntityUtils;
import com.comtop.cap.bm.metadata.pkg.model.ProjectVO;
import com.comtop.cap.bm.metadata.preferencesconfig.PreferenceConfigQueryUtil;
import com.comtop.cap.bm.metadata.preferencesconfig.facade.PreferencesFacade;
import com.comtop.cap.bm.metadata.serve.model.ServiceObjectVO;
import com.comtop.cap.bm.metadata.sysmodel.facade.SysmodelFacade;
import com.comtop.cap.bm.metadata.sysmodel.model.CapPackageVO;
import com.comtop.cap.bm.metadata.utils.FileUtils;
import com.comtop.cap.bm.metadata.utils.StringConvertor;
import com.comtop.cap.runtime.base.exception.CapMetaDataException;
import com.comtop.cap.runtime.base.util.BeanContextUtil;
import com.comtop.cip.common.util.DBUtil;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.corm.resource.util.CollectionUtils;
import com.comtop.top.cfg.facade.ConfigItemFacade;
import com.comtop.top.cfg.model.ConfigItemDTO;
import com.comtop.top.core.jodd.AppContext;
import com.comtop.top.core.util.IOUtil;
import com.comtop.top.core.util.StringUtil;
import com.comtop.top.core.util.constant.NumberConstant;

import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;
import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;

/**
 * 页面实体facade类
 * 
 * @author 章尊志
 * @since jdk1.6
 * @version 2015年9月18日 章尊志
 */
@DwrProxy
@PetiteBean
public class EntityFacade extends CapBmBaseFacade {
    
    /** 日志 */
    private final static Logger LOG = LoggerFactory.getLogger(EntityFacade.class);
    
    /** 包Facade */
    private final SysmodelFacade packageFacade = AppContext.getBean(SysmodelFacade.class);
    
    /** 表Facade */
    private final TableFacade tableFacade = AppContext.getBean(TableFacade.class);
    
    /** 首选项的facade实例 **/
    private final PreferencesFacade preferencesFacade = BeanContextUtil.getBean(PreferencesFacade.class);
    
    /*** grid list常量 */
    public final static String PAGE_LIST = "list";
    
    /*** 总记录数 */
    public final static String TOTAL_COUNT = "count";
    
    /**
     * 查询实体列表
     * 
     * @param packageId 当前模块包ID
     * 
     * @return 实体列表
     * @throws OperateException 异常
     */
    @RemoteMethod
    public List<EntityVO> queryEntityList(String packageId) throws OperateException {
        CapPackageVO objPackageVO = packageFacade.queryPackageById(packageId);
        String strPackageName = objPackageVO.getFullPath();
        List<EntityVO> lstEntityVOs = CacheOperator.queryList(strPackageName + "/entity", EntityVO.class);
        return lstEntityVOs;
    }
    
    /**
     * 查询实体列表
     * 
     * @param packageId 当前模块包ID
     * @param pageNo pageNo
     * @param pageSize pageSize
     * @return 实体列表
     * @throws OperateException 异常
     */
    @RemoteMethod
    public List<EntityVO> queryEntityList(String packageId, int pageNo, int pageSize) throws OperateException {
        CapPackageVO objPackageVO = packageFacade.queryPackageById(packageId);
        String strPackageName = objPackageVO.getFullPath();
        List<EntityVO> lstEntityVOs = CacheOperator.queryList(strPackageName + "/entity", EntityVO.class, pageNo,
            pageSize);
        return lstEntityVOs;
    }
    
    /**
     * 检查第三方类型是否存储在
     * 
     * @param classFullName 第三方类名
     * @return true 存在， false 不存在
     */
    @RemoteMethod
    public boolean checkClassExist(String classFullName) {
        try {
            Class.forName(classFullName);
            return true;
        } catch (ClassNotFoundException e) {
            LOG.debug("error", e);
            return false;
        }
    }
    
    /**
     * 根据当前实体ID，查询关联的当前实体的集合
     * 
     * @param entityId 当前实体ID
     * 
     * @return 实体列表
     * @throws OperateException 异常
     */
    @RemoteMethod
    public List<EntityVO> queryRelationEntityById(String entityId) throws OperateException {
        String strExpression = "entity[lstRelation/targetEntityId='" + entityId
            + "' or lstRelation/associateEntityId='" + entityId + "']";
        List<EntityVO> lstEntityVO = CacheOperator.queryList(strExpression, EntityVO.class);
        return lstEntityVO;
    }
    
    /**
     * 查询实体列表
     * 
     * @param pkgName 当前包名称
     * 
     * @return 实体列表
     * @throws OperateException 异常
     */
    @RemoteMethod
    public List<EntityVO> queryEntityListByPkgName(String pkgName) throws OperateException {
        List<EntityVO> lstEntityVOs = CacheOperator.queryList(pkgName + "/entity", EntityVO.class);
        return lstEntityVOs;
        
    }
    
    /**
     * 查询指定包下（包括当前包和所有子包）的所有实体关联关系
     * 
     * @param packagePath 当前模块包路径
     * @return 实体关联关系集合
     * @throws OperateException 异常
     */
    public List<EntityRelationshipVO> queryEntityRelationOfPackAndAllSub(String packagePath) throws OperateException {
        if (StringUtils.isBlank(packagePath)) {
            return new ArrayList<EntityRelationshipVO>(0);
        }
        String strExpression = "entity[contains(modelId,'" + packagePath + ".')]/lstRelation";
        List<EntityRelationshipVO> lstEntityRelation = CacheOperator.queryList(strExpression,
            EntityRelationshipVO.class);
        return lstEntityRelation;
    }
    
    /**
     * 查询所有实体
     * 
     * @return 所有实体
     * @throws OperateException 异常
     */
    public List<EntityVO> queryAllEntity() throws OperateException {
        List<EntityVO> lstEntityVO = CacheOperator.queryList("entity", EntityVO.class);
        return lstEntityVO;
    }
    
    /**
     * 通过实体属性ID查询实体属性
     * 
     * @param modelId 实体模型ID
     * @param packageId 包ID
     * @return 实体属性对象
     */
    @RemoteMethod
    public EntityVO loadEntity(String modelId, String packageId) {
        if (StringUtil.isBlank(modelId) && StringUtil.isBlank(packageId)) {
            return null;
        }
        EntityVO objEntityVO = new EntityVO();
        // 如果modelId为空则构造空EntityVO到新增页面
        if (StringUtil.isNotBlank(modelId)) {
            objEntityVO = (EntityVO) CacheOperator.readById(modelId);
        } else {
            CapPackageVO objPackageVO = packageFacade.queryPackageById(packageId);
            objEntityVO.setParentEntityId(getParentEntityId(null));
            objEntityVO.setModelPackage(objPackageVO.getFullPath());
            objEntityVO.setClassPattern(ClassPattern.COMMON.getValue());
            objEntityVO.setPackageVO(objPackageVO);
        }
        
        return objEntityVO;
    }
    
    /**
     * 通过实体反射获取属性列表
     * 
     * @param objEntityVO 需要反射的实体
     * @return 实体属性列表
     */
    private List<EntityAttributeVO> getEntityAttributesByInvokeEntity(EntityVO objEntityVO) {
        List<EntityAttributeVO> lstAttributes = new ArrayList<EntityAttributeVO>();
        try {
            Class classEntity = Class.forName(objEntityVO.getModelPackage() + ".model." + objEntityVO.getEngName()
                + "VO");
            Field[] fields = classEntity.getDeclaredFields();
            if (fields == null) {
                return lstAttributes;
            }
            for (int i = 0; i < fields.length; i++) {
                Field field = fields[i];
                if ("serialVersionUID".equals(field.getName())) {
                    continue;
                }
                EntityAttributeVO entityAttributeVO = new EntityAttributeVO();
                field.setAccessible(true);
                
                // 得到此属性的类型
                String type = field.getType().toString();
                DataTypeVO dataTypeVO = EntityUtils.getDataTypeVO(type);
                
                // 设置属性
                entityAttributeVO.setPrimaryKey(false);
                entityAttributeVO.setChName(field.getName());// 中文名称 需改
                entityAttributeVO.setAccessLevel(EntityUtils.getModifiers(Modifier.toString(field.getModifiers())));
                entityAttributeVO.setAllowNull(true);
                entityAttributeVO.setEngName(field.getName());
                entityAttributeVO.setAttributeType(dataTypeVO);
                // entityAttributeVO.setSortNo(i + 1);
                
                lstAttributes.add(entityAttributeVO);
            }
        } catch (Exception e) {
            // e.printStackTrace();
            LOG.info("找不到实体:" + objEntityVO.getModelPackage() + ".model." + objEntityVO.getEngName() + "VO，获取实体属性失败!");
        }
        
        // 重置属性排序号
        EntityUtils.resetAttrbutesSortNo(lstAttributes);
        
        return lstAttributes;
    }
    
    /**
     * 通过实体Facade反射获取方法列表
     * 
     * @param objEntityVO 需要反射的实体
     * @return 实体方法列表
     */
    private List<MethodVO> getEntityMethodsByInvokeFacade(EntityVO objEntityVO) {
        List<MethodVO> lstMethods = new ArrayList<MethodVO>();
        try {
            Class classFacade = Class.forName(objEntityVO.getModelPackage() + ".facade." + objEntityVO.getEngName()
                + "Facade");
            ParameterNameDiscoverer parameterNameDiscoverer = new LocalVariableTableParameterNameDiscoverer();
            Method[] methodList = classFacade.getDeclaredMethods();
            if (null == methodList) {
                return lstMethods;
            }
            for (int i = 0; i < methodList.length; i++) {
                Method method = methodList[i];
                // 只需要公有的函数
                if (!"public".equals(EntityUtils.getModifiers(Modifier.toString(method.getModifiers())))) {
                    continue;
                }
                method.setAccessible(true);
                MethodVO methodVO = new MethodVO();
                // 获取
                String type = method.getReturnType().toString();
                DataTypeVO dataTypeVO = EntityUtils.getDataTypeVO(type);
                
                Class<?>[] parameterTypes = method.getParameterTypes();
                String[] parameterNames = parameterNameDiscoverer.getParameterNames(method);
                
                // 获取参数
                List<ParameterVO> parameters = EntityUtils.getParameters(parameterTypes, parameterNames);
                // 设置方法属性
                methodVO.setEngName(method.getName());
                methodVO.setChName(method.getName());
                methodVO.setMethodId(i + 1 + "");
                methodVO.setReturnType(dataTypeVO);
                methodVO.setAccessLevel(EntityUtils.getModifiers(Modifier.toString(method.getModifiers())));
                methodVO.setAutoMethod(false);
                methodVO.setPrivateService(false);
                methodVO.setMethodType("blank");
                methodVO.setMethodSource("entity");
                methodVO.setParameters(parameters);
                lstMethods.add(methodVO);
            }
        } catch (Exception e) {
            // e.printStackTrace();
            LOG.info("找不到实体对应的Facade类:" + objEntityVO.getModelPackage() + ".facade." + objEntityVO.getEngName()
                + "Facade,获取方法失败");
        }
        return lstMethods;
    }
    
    /**
     * 通过实体反射判断所录入的已有实体是否存在
     * 
     * @param objEntityVO 需要反射的实体
     * @return true:存在已有实体 ,false:找不到已有实体
     */
    @RemoteMethod
    public boolean checkExistEntityByInvoke(EntityVO objEntityVO) {
        // 实体类型为查询实体，实体来源为已有实体
        if (isExistQueryEntity(objEntityVO)) {
            return validateQueryEntity(objEntityVO);
        } else if (isExistDataEntity(objEntityVO)) {
            return validateDataEntity(objEntityVO);
        }
        return true;
    }
    
    /**
     * 判断实体是否是查询实体，并且来源与已有实体
     * 
     * @param objEntityVO 需要验证的实体
     * @return true : 是 ，false :否
     */
    private boolean isExistQueryEntity(EntityVO objEntityVO) {
        if (EntityType.QUERY_ENTITY.getValue().equals(objEntityVO.getEntityType())
            && EntitySource.EXIST_ENTITY_INPUT.getValue().equals(objEntityVO.getEntitySource())) {
            return true;
        }
        return false;
    }
    
    /**
     * 判断实体是否是数据实体，并且来源与已有实体
     * 
     * @param objEntityVO 需要验证的实体
     * @return true : 是 ，false :否
     */
    private boolean isExistDataEntity(EntityVO objEntityVO) {
        if (EntityType.DATA_ENTITY.getValue().equals(objEntityVO.getEntityType())
            && EntitySource.EXIST_ENTITY_INPUT.getValue().equals(objEntityVO.getEntitySource())) {
            return true;
        }
        return false;
    }
    
    /**
     * 验证查询实体在工程包下同时存在存在对应的VO、Facade、AppService类
     * 
     * @param objEntityVO 需要验证的实体
     * @return true 是 ，false： 否
     */
    private boolean validateQueryEntity(EntityVO objEntityVO) {
        String voPath = FileUtils.getFilePath(EntityUtils.getProjectDir(objEntityVO),
            PreferenceConfigQueryUtil.getJavaCodePath(), objEntityVO.getModelPackage() + ".model",
            objEntityVO.getEngName() + "VO.java");
        String appServicePath = FileUtils.getFilePath(EntityUtils.getProjectDir(objEntityVO),
            PreferenceConfigQueryUtil.getJavaCodePath(), objEntityVO.getModelPackage() + ".appservice",
            objEntityVO.getEngName() + "AppService.java");
        String facadePath = FileUtils.getFilePath(EntityUtils.getProjectDir(objEntityVO),
            PreferenceConfigQueryUtil.getJavaCodePath(), objEntityVO.getModelPackage() + ".facade",
            objEntityVO.getEngName() + "Facade.java");
        File voFile = new File(voPath);
        File appServiceFile = new File(appServicePath);
        File facadeFile = new File(facadePath);
        if (voFile.exists() && appServiceFile.exists() && facadeFile.exists()) {
            return true;
        }
        LOG.warn("录入已有查询实体下找不到对应包下的类" + objEntityVO.getEngName() + "Facade、" + objEntityVO.getEngName() + "AppService、"
            + objEntityVO.getEngName() + "VO,必须同时存在三个类。");
        return false;
    }
    
    /**
     * 验证数据实体在工程包下同时存在存在对应的VO类
     * 
     * @param objEntityVO 需要验证的实体
     * @return true 是 ，false： 否
     */
    private boolean validateDataEntity(EntityVO objEntityVO) {
        String voPath = FileUtils.getFilePath(EntityUtils.getProjectDir(objEntityVO),
            PreferenceConfigQueryUtil.getJavaCodePath(), objEntityVO.getModelPackage() + ".model",
            objEntityVO.getEngName() + "VO.java");
        File file = new File(voPath);
        if (file.exists()) {
            return true;
        }
        LOG.warn("录入已有数据实体找不到model包路径下" + objEntityVO.getEngName() + "VO类。");
        return false;
    }
    
    /**
     * 判断实体继承了CapBase,或最终继承了CapBase
     * 
     * @param entityVO 需要验证的实体
     * @return true 是，false 否
     */
    @RemoteMethod
    public boolean isEntityExtendsCapBase(EntityVO entityVO) {
        if (null != entityVO) {
            // CapWorkflow继承了CapBase,如果父类为工作流直接推出，返回
            if (PreferenceConfigQueryUtil.DEFAULT_PARENT_ENTITY_ID_WORKFLOW.equals(entityVO.getModelId())
                || PreferenceConfigQueryUtil.DEFAULT_PARENT_ENTITY_ID_WORKFLOW.equals(entityVO.getParentEntityId())) {
                return false;
            }
            if (PreferenceConfigQueryUtil.DEFAULT_PARENT_ENTITY_ID.equals(entityVO.getModelId())
                || PreferenceConfigQueryUtil.DEFAULT_PARENT_ENTITY_ID.equals(entityVO.getParentEntityId())) {
                return true;
            }
            EntityVO objEntityVO = (EntityVO) CacheOperator.readById(entityVO.getParentEntityId());
            isEntityExtendsCapBase(objEntityVO);
        }
        return false;
    }
    
    /**
     * 
     * 判断实体继承了CapWorkflow,或最终继承了CapWorkflow
     * 
     * @param entityVO 需要验证的实体
     * @return true 是，false 否
     */
    @RemoteMethod
    public boolean isEntityExtendsCapWrokflow(EntityVO entityVO) {
        if (null != entityVO) {
            if (PreferenceConfigQueryUtil.DEFAULT_PARENT_ENTITY_ID_WORKFLOW.equals(entityVO.getModelId())
                || PreferenceConfigQueryUtil.DEFAULT_PARENT_ENTITY_ID_WORKFLOW.equals(entityVO.getParentEntityId())) {
                return true;
            }
            EntityVO objEntityVO = (EntityVO) CacheOperator.readById(entityVO.getParentEntityId());
            isEntityExtendsCapWrokflow(objEntityVO);
        }
        
        return false;
    }
    
    /**
     * 保存
     * 
     * @param entityVO 被保存的对象
     * @return 实体对象
     * @throws ValidateException 校验失败异常
     */
    @RemoteMethod
    public EntityVO saveEntity(EntityVO entityVO) throws ValidateException {
        // 通过反射获取已有实体的属性与方法
        if (EntitySource.EXIST_ENTITY_INPUT.getValue().equals(entityVO.getEntitySource())) {
            if (entityVO.getAttributes() == null) {
                entityVO.setAttributes(getEntityAttributesByInvokeEntity(entityVO));
            }
            // 只有已存在的查询实体才需要加载方法
            if (entityVO.getMethods() == null && EntityType.QUERY_ENTITY.getValue().equals(entityVO.getEntityType())) {
                entityVO.setMethods(getEntityMethodsByInvokeFacade(entityVO));
            }
        }
        boolean bResult = entityVO.saveModel();
        
        return bResult ? entityVO : null;
    }
    
    /**
     * 校验实体一致性校验主要为实体所依赖的属性
     * 
     * @param entityVO
     *            实体对象
     * @return Map map
     */
    @RemoteMethod
    public Map<String, Object> checkEntityConsistency(EntityVO entityVO) {
        Map<String, Object> objReult = this.checkConsistency(entityVO);
        System.out.println("实体一致性校验:" + objReult);
        
        return objReult;
    }
    
    /**
     * 通过开关校验实体元数据一致性
     * 
     * @param entityVO
     *            实体对象
     * @return map
     */
    @RemoteMethod
    public Map<String, Object> checkEntityConsistencyBySwitch(EntityVO entityVO) {
        // 已有实体不做校验
        if (EntitySource.EXIST_ENTITY_INPUT.getValue().equals(entityVO.getEntitySource())) {
            Map<String, Object> objReult = new HashMap<String, Object>();
            objReult.put("validateResult", true);
            return objReult;
        }
        
        return checkConsistencyBySwitch(entityVO);
    }
    
    /**
     * 校验实体一致性校验当前选中实体被哪些实体所依赖
     * 
     * @param selectedEntitys 选中实体集合
     * 
     * @return 校验信息
     */
    @RemoteMethod
    public Map<String, Object> checkEntityBeingDependOn(List<EntityVO> selectedEntitys) {
        
        return checkEntityBeingDependOn(selectedEntitys, true);
    }
    
    /**
     * 实体一致性校验(没有开关控制,直接校验)
     * 
     * @param selectedEntitys
     *            选中实体集合
     * @return 校验信息
     */
    @RemoteMethod
    public Map<String, Object> checkEntity4BeingDependOn(List<EntityVO> selectedEntitys) {
        
        return checkEntityBeingDependOn(selectedEntitys, false);
    }
    
    /**
     * 校验实体被依赖
     * 
     * @param selectedEntitys
     *            实体集合
     * @param isNeedSwitch
     *            是否需要开关
     * @return 校验信息
     */
    @SuppressWarnings("unchecked")
    private Map<String, Object> checkEntityBeingDependOn(List<EntityVO> selectedEntitys, boolean isNeedSwitch) {
        List<ConsistencyCheckResult> results = new ArrayList<ConsistencyCheckResult>();
        for (EntityVO entity : selectedEntitys) {
            List<ConsistencyCheckResult> objCheckResult = null;
            if (isNeedSwitch) {
                objCheckResult = EntityBeingDependOnFactory.getBeingDependOnValidater().beingDependOnRoot(entity);
            } else {
                objCheckResult = EntityBeingDependOnFactory.getNoSwtichValidater().beingDependOnRoot(entity);
            }
            results.addAll(objCheckResult);
        }
        
        return EntityConsistencyUtil.convertToBeingDependOnClientResult(results);
    }
    
    /**
     * 校验实体方法被依赖
     * 
     * @param methods 方法集合
     * @param entity 实体对象
     * @return 校验信息
     */
    @SuppressWarnings("unchecked")
    @RemoteMethod
    public Map<String, Object> checkEntityMethodBeingDependOn(List<MethodVO> methods, EntityVO entity) {
        
        List<ConsistencyCheckResult> results = EntityBeingDependOnFactory.getBeingDependOnValidater()
            .beingDependOnMethod(methods, entity);
        
        return EntityConsistencyUtil.convertToBeingDependOnClientResult(results);
    }
    
    /**
     * 校验实体属性被依赖
     * 
     * @param attributes
     *            属性集合
     * @param entity
     *            实体对象
     * @return 客户端校验信息
     */
    @SuppressWarnings("unchecked")
    @RemoteMethod
    public Map<String, Object> checkEntityAttributeBeingDependOn(List<EntityAttributeVO> attributes, EntityVO entity) {
        
        List<ConsistencyCheckResult> results = EntityBeingDependOnFactory.getBeingDependOnValidater()
            .beingDependOnAttribute(attributes, entity);
        
        return EntityConsistencyUtil.convertToBeingDependOnClientResult(results);
    }
    
    /**
     * 查询该包路径下是否存在相同实体名称
     * 
     * @param modelPackage 包全路径
     * @param engName 实体名称
     * @param modelId 实体模块ID
     * @return 是否存在（false： 不存在、true：存在）
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public boolean isExistSameNameEntity(String modelPackage, String engName, String modelId) throws OperateException {
        boolean bResult = false;
        List<EntityVO> lstEntityVO = CacheOperator.queryList(modelPackage + "/entity", EntityVO.class);
        for (EntityVO objEntityVO : lstEntityVO) {
            String strEngName = objEntityVO.getEngName();
            String strModelId = objEntityVO.getModelId();
            if (strEngName.equals(engName) && !strModelId.equals(modelId)) {
                bResult = true;
                break;
            }
        }
        return bResult;
    }
    
    /**
     * 查询该包路径下是否存在相同的中文名称
     * 
     * @param modelPackage 包全路径
     * @param chName 实体中文名称
     * @param modelId 实体模块ID
     * @return 是否存在（false： 不存在、true：存在）
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public boolean isExistSameChNameEntity(String modelPackage, String chName, String modelId) throws OperateException {
        boolean bResult = false;
        List<EntityVO> lstEntityVO = CacheOperator.queryList(modelPackage + "/entity", EntityVO.class);
        for (EntityVO objEntityVO : lstEntityVO) {
            String strChName = objEntityVO.getChName();
            String strModelId = objEntityVO.getModelId();
            if (strChName.equals(chName) && !strModelId.equals(modelId)) {
                bResult = true;
                break;
            }
        }
        return bResult;
    }
    
    /**
     * 查询该包路径下实体方法下是否存在别名
     * 
     * @param aliasName 方法别名
     * @param modelId 实体模块ID
     * @param methodId 实体方法ID
     * @return 是否存在（false： 不存在、true：存在）
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public boolean isExistSameMethodAliasName(String aliasName, String modelId, String methodId)
        throws OperateException {
        EntityVO entityVO = (EntityVO) CacheOperator.readById(modelId);
        List<MethodVO> methodVOs = entityVO.getMethods();
        if (methodVOs != null) {
            for (MethodVO methodVO : methodVOs) {
                if (!"".equals(aliasName) && aliasName.equals(methodVO.getAliasName())
                    && methodId.equals(methodVO.getMethodId())) {
                    return true;
                }
            }
        }
        return false;
    }
    
    /**
     * 查询服务下是否存在相同的实体别名 ，包括全服务下的 实体别名 和 服务实体别名
     * 
     * @param aliasName 实体名称
     * @param modelId 实体模块ID
     * @return 是否存在（false： 不存在、true：存在）
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public boolean isExistSameAliasNameEntity(String aliasName, String modelId) throws OperateException {
        boolean bResult = false;
        // 需要查询全服务下的实体别名是否存在重复,排除当前记录
        List<EntityVO> lstEntityVO = CacheOperator.queryList("/entity", EntityVO.class);
        if (lstEntityVO != null) {
            for (EntityVO objEntityVO : lstEntityVO) {
                String strAliasName = objEntityVO.getAliasName();
                String strModelId = objEntityVO.getModelId();
                if (StringUtil.isNotBlank(strAliasName)) {
                    if (strAliasName.equals(aliasName) && !strModelId.equals(modelId)) {
                        bResult = true;
                        break;
                    }
                }
            }
        }
        // 查询全服务下的服务实体是否存在别名重
        if (!bResult) {
            List<ServiceObjectVO> lstServiceObjectVO = CacheOperator.queryList("/serve", ServiceObjectVO.class);
            if (lstServiceObjectVO != null) {
                for (ServiceObjectVO objServiceObjectVO : lstServiceObjectVO) {
                    String strAliasName = objServiceObjectVO.getServiceAlias();
                    if (StringUtil.isNotBlank(strAliasName)) {
                        if (strAliasName.equals(aliasName)) {
                            bResult = true;
                            break;
                        }
                    }
                }
            }
        }
        return bResult;
    }
    
    /**
     * 删除模型
     * 
     * @param models ID集合
     * @return 是否成功
     */
    @RemoteMethod
    public boolean delEntitys(String[] models) {
        boolean bResult = true;
        try {
            for (int i = 0; i < models.length; i++) {
                EntityVO.deleteModel(models[i]);
            }
        } catch (Exception e) {
            bResult = false;
            LOG.error("删除实体文件失败", e);
        }
        return bResult;
    }
    
    /**
     * 
     * 查询实体
     * 
     * 
     * @param packageId 包ID
     * @return 查询结果
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public List<Map<String, Object>> queryEntityForNode(String packageId) throws OperateException {
        List<Map<String, Object>> lstReturn = new ArrayList<Map<String, Object>>();
        List<EntityVO> lstEntity = this.queryEntityList(packageId);
        for (EntityVO objEntity : lstEntity) {
            Map<String, Object> objMapEntity = new HashMap<String, Object>();
            objMapEntity.put("title", objEntity.getEngName());
            objMapEntity.put("key", objEntity.getModelId());
            objMapEntity.put("data", objEntity);
            lstReturn.add(objMapEntity);
        }
        
        return lstReturn;
    }
    
    /**
     * 
     * 根据包ID和试题类型查询实体
     * 
     * 
     * @param packageId 包ID
     * @param type 实体类型
     * @return 查询结果
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public List<Map<String, Object>> queryEntityForNodeByEntityType(String packageId, String type)
        throws OperateException {
        List<Map<String, Object>> lstReturn = new ArrayList<Map<String, Object>>();
        List<EntityVO> lstEntity = this.queryEntityListByEntityType(packageId, type);
        for (EntityVO objEntity : lstEntity) {
            Map<String, Object> objMapEntity = new HashMap<String, Object>();
            objMapEntity.put("title", objEntity.getEngName());
            objMapEntity.put("key", objEntity.getModelId());
            objMapEntity.put("data", objEntity);
            lstReturn.add(objMapEntity);
        }
        
        return lstReturn;
    }
    
    /**
     * 查询实体列表
     * 
     * @param packageId 当前模块包ID
     * @param type 实体类型
     * @return 实体列表
     * @throws OperateException 异常
     */
    @RemoteMethod
    public List<EntityVO> queryEntityListByEntityType(String packageId, String type) throws OperateException {
        CapPackageVO objPackageVO = packageFacade.queryPackageById(packageId);
        String strPackageName = objPackageVO.getFullPath();
        List<EntityVO> lstEntityVOs = CacheOperator.queryList(strPackageName + "/entity[entityType='" + type + "']",
            EntityVO.class);
        return lstEntityVOs;
        
    }
    
    /**
     * 快速查询系统模块
     * 
     * @param keyword
     *            关键字
     * @return 系统模块集合
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public List<EntityVO> fastQueryEntity(String keyword) throws OperateException {
        @SuppressWarnings("unchecked")
        List<EntityVO> lstEntityVOs = CacheOperator.queryList("entity[contains(engName,'" + keyword
            + "') or contains(chName,'" + keyword + "')]");
        return lstEntityVOs;
    }
    
    /**
     * 通过实体ID查询非关系生成属性
     * 
     * @param modelId
     *            实体ID
     * @return 实体属性集合
     */
    @RemoteMethod
    public Map<String, Object> queryAttributesAndNotRelationship(String modelId) {
        Map<String, Object> objQueryMap = new HashMap<String, Object>();
        EntityVO objEntityVO = (EntityVO) CacheOperator.readById(modelId);
        if (objEntityVO == null) {
            objQueryMap.put(PAGE_LIST, null);
            objQueryMap.put(TOTAL_COUNT, null);
            return objQueryMap;
        }
        List<EntityAttributeVO> lstEntityAttributeVOs = objEntityVO.getAttributes();
        List<EntityAttributeVO> lstRetEntityAttributeVOs = new ArrayList<EntityAttributeVO>();
        if (lstEntityAttributeVOs != null) {
            for (EntityAttributeVO objEntityAttributeVO : lstEntityAttributeVOs) {
                if (StringUtils.isEmpty(objEntityAttributeVO.getRelationId())) {
                    lstRetEntityAttributeVOs.add(objEntityAttributeVO);
                }
            }
        }
        objQueryMap.put(PAGE_LIST, lstRetEntityAttributeVOs);
        objQueryMap.put(TOTAL_COUNT, lstRetEntityAttributeVOs.size());
        return objQueryMap;
    }
    
    /**
     * 通过实体ID查询基础的属性
     * 
     * @param modelId
     *            实体ID
     * @return 实体属性集合
     */
    @RemoteMethod
    public Map<String, Object> queryBaseAttributes(String modelId) {
        Map<String, Object> objQueryMap = this.queryAttributesAndNotRelationship(modelId);
        if (objQueryMap.get("PAGE_LIST") == null) {
            return objQueryMap;
        }
        
        @SuppressWarnings("unchecked")
        List<EntityAttributeVO> lstEntityAttributeVO = (List<EntityAttributeVO>) objQueryMap.get(PAGE_LIST);
        List<EntityAttributeVO> lstRetEntityAttributeVOs = new ArrayList<EntityAttributeVO>();
        for (EntityAttributeVO objEntityAttributeVO : lstEntityAttributeVO) {
            if (objEntityAttributeVO.getAttributeType().getSource().equals(AttributeSourceType.PRIMITIVE.getValue())) {
                lstRetEntityAttributeVOs.add(objEntityAttributeVO);
            }
        }
        objQueryMap.put(PAGE_LIST, lstRetEntityAttributeVOs);
        objQueryMap.put(TOTAL_COUNT, lstRetEntityAttributeVOs.size());
        
        return objQueryMap;
    }
    
    /**
     * 通过实体ID查询带有数据库字段的属性
     * 
     * @param modelId
     *            实体ID
     * @return 实体属性集合
     */
    @RemoteMethod
    public Map<String, Object> queryDbFieldAttributes(String modelId) {
        Map<String, Object> objQueryMap = this.queryBaseAttributes(modelId);
        if (objQueryMap.get(PAGE_LIST) != null) {
            List<EntityAttributeVO> newAttributes = new ArrayList<EntityAttributeVO>();
            @SuppressWarnings("unchecked")
            List<EntityAttributeVO> attributes = (List<EntityAttributeVO>) objQueryMap.get(PAGE_LIST);
            for (EntityAttributeVO attribute : attributes) {
                if (StringUtils.isNotEmpty(attribute.getDbFieldId())) {
                    // 去除没有数据库字段的属性
                    newAttributes.add(attribute);
                }
            }
            objQueryMap.put(PAGE_LIST, newAttributes);
        }
        return objQueryMap;
    }
    
    /**
     * 根据实体ID、属性英文名、中文名关键字快速查询实体基本属性集合
     * 
     * @param modelId
     *            实体ID
     * @param keyword
     *            关键字
     * @throws OperateException 操作异常
     * @return 实体属性对象集合
     */
    @RemoteMethod
    public Map<String, Object> fastQueryEntityBaseAttributes(final String modelId, final String keyword)
        throws OperateException {
        Map<String, Object> objQueryMap = new HashMap<String, Object>();
        EntityVO objEntityVO = (EntityVO) CacheOperator.readById(modelId);
        if (objEntityVO == null) {
            objQueryMap.put(PAGE_LIST, null);
            objQueryMap.put(TOTAL_COUNT, null);
            return objQueryMap;
        }
        @SuppressWarnings("unchecked")
        List<EntityAttributeVO> lstEntityAttributeVOs = objEntityVO.queryList("attributes[contains(engName,'" + keyword
            + "') or contains(chName,'" + keyword + "')]");
        if (CollectionUtils.isEmpty(lstEntityAttributeVOs)) {
            objQueryMap.put(PAGE_LIST, null);
            objQueryMap.put(TOTAL_COUNT, null);
            return objQueryMap;
        }
        
        List<EntityAttributeVO> lstRetEntityAttributeVOs = new ArrayList<EntityAttributeVO>();
        for (EntityAttributeVO objEntityAttributeVO : lstEntityAttributeVOs) {
            if (objEntityAttributeVO.getAttributeType().getSource().equals(AttributeSourceType.PRIMITIVE.getValue())) {
                lstRetEntityAttributeVOs.add(objEntityAttributeVO);
            }
        }
        objQueryMap.put(PAGE_LIST, lstRetEntityAttributeVOs);
        objQueryMap.put(TOTAL_COUNT, lstRetEntityAttributeVOs.size());
        return objQueryMap;
    }
    
    /**
     * 根据实体ID、属性英文名、中文名关键字快速查询实体属性集合
     * 
     * @param modelId
     *            实体ID
     * @param keyword
     *            关键字
     * @throws OperateException 操作异常
     * @return 实体属性对象集合
     */
    @RemoteMethod
    public Map<String, Object> fastQueryEntityAttributes(final String modelId, final String keyword)
        throws OperateException {
        Map<String, Object> objQueryMap = new HashMap<String, Object>();
        EntityVO objEntityVO = (EntityVO) CacheOperator.readById(modelId);
        if (objEntityVO == null) {
            objQueryMap.put(PAGE_LIST, null);
            objQueryMap.put(TOTAL_COUNT, null);
            return objQueryMap;
        }
        @SuppressWarnings("unchecked")
        List<EntityAttributeVO> lstEntityAttributeVOs = objEntityVO.queryList("attributes[contains(engName,'" + keyword
            + "') or contains(chName,'" + keyword + "')]");
        objQueryMap.put(PAGE_LIST, lstEntityAttributeVOs);
        objQueryMap.put(TOTAL_COUNT, lstEntityAttributeVOs.size());
        return objQueryMap;
    }
    
    /**
     * 判断属性是否为其他属性的冗余属性
     * 
     * @param modelId 实体ID
     * @return String 实体属性变化信息
     * @throws OperateException OperateException
     */
    @RemoteMethod
    public Map<String, Object> compareEntity(String modelId) throws OperateException {
        EntityVO objEntityVO = (EntityVO) CacheOperator.readById(modelId);
        if (objEntityVO == null || StringUtils.isEmpty(objEntityVO.getDbObjectName())) {
            return null;
        }
        
        List<String> objTableNames = new ArrayList<String>();
        objTableNames.add(objEntityVO.getDbObjectName());
        MetaConnection objMetaConn = EntityImportUtils.getMetaConnection();
        List<EntityCompareResult> objLisEntityCompareResult = compareEntity(objEntityVO.getPackageId(),
            objMetaConn.getSchema(), objTableNames, 2, objMetaConn, "", "");
        DBUtil.closeConnection(objMetaConn.getConn(), null, null);
        // 目前数据源配置在app.props中，后续若去掉此配置文件，则修改下此异常提示
        if (null == objLisEntityCompareResult) {
            throw new RuntimeException("未能查询到此实体对应的数据库表，请检查首选项中导入实体数据源的配置是否正确或该数据源下是否存在此表");
        }
        // 是否改变
        boolean hasChanged = false;
        // 改变的属性
        List<Map<String, String>> changeAttributes = new ArrayList<Map<String, String>>();
        for (EntityCompareResult objResult : objLisEntityCompareResult) {
            if (EntityCompareResult.ENTITY_ATTR_DIFF == objResult.getResult()) {
                changeAttributes.addAll(EntityImportUtils.getChangedAttributes(objResult.getAttrResults()));
                hasChanged = true;
            }
        }
        // 返回的结果
        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("hasChanged", hasChanged);
        if (hasChanged) {
            // 改变了，就把实体比较的结果集合也一并返回，否则不返回
            resultMap.put("changedAttributes", changeAttributes);
            EntityImportUtils.saveCompareEntityToSession(objLisEntityCompareResult);
        }
        return resultMap;
    }
    
    /**
     * 同步数据表到实体元数据
     * 
     * @param syncAll 同步所有变化的属性
     * @param sycnAttributes 同步的属性的英文名称集合
     * @return List<EntityCompareResult> 实体比较结果
     * @throws ValidateException ValidateException
     * @throws OperateException OperateException
     */
    @RemoteMethod
    public List<EntityCompareResult> syncDatabaseToMeta(boolean syncAll, List<Map<String, String>> sycnAttributes)
        throws ValidateException, OperateException {
        List<EntityCompareResult> entityCompareResult = EntityImportUtils.getCompareEntityBySession();
        // 根据选择的需要同步的属性，来维护entityCompareResult中AttributeCompareResult，把未选择的，不需要同步的删除。
        if (!syncAll) {
            if (CollectionUtils.isEmpty(sycnAttributes)) {
                return null;
            }
            Iterator<EntityCompareResult> itEntity = entityCompareResult.iterator();
            while (itEntity.hasNext()) {
                List<AttributeCompareResult> lstAttributeCompareResult = itEntity.next().getAttrResults();
                Iterator<AttributeCompareResult> itAttri = lstAttributeCompareResult.iterator();
                while (itAttri.hasNext()) {
                    AttributeCompareResult attriCompareResult = itAttri.next();
                    // 该结果对应的属性是否要同步
                    boolean isSync = false;
                    for (int i = 0; i < sycnAttributes.size(); i++) {
                        Map<String, String> obj = sycnAttributes.get(i);
                        if (Integer.parseInt(obj.get("stateCode")) == attriCompareResult.getResult()) {
                            EntityAttributeVO srcVO = attriCompareResult.getSrcAttribute();
                            EntityAttributeVO tarVO = attriCompareResult.getTargetAttribute();
                            if ((srcVO != null && srcVO.getEngName().equals(obj.get("ename")))
                                || (tarVO != null && tarVO.getEngName().equals(obj.get("ename")))) {
                                isSync = true;
                                break;
                            }
                        }
                    }
                    if (!isSync) {
                        itAttri.remove();
                    }
                }
            }
        }
        syncDatabaseToMeta(entityCompareResult);
        return entityCompareResult;
    }
    
    /**
     * 删除session中的实体与数据表比较结果集
     */
    @RemoteMethod
    public void removeCompareEntity() {
        EntityImportUtils.removeCompareEntityBySession();
    }
    
    /**
     * 查询表达式生成
     * 
     * @param rule 规则
     * @param coll 列名称
     * @param attr 属性名称
     * @return 查询表达式
     */
    @RemoteMethod
    public String genQueryExpression(int rule, String coll, String attr) {
        Map<String, String> objParams = new HashMap<String, String>();
        objParams.put("coll", coll);
        objParams.put("attr", attr);
        String strRuleTemplate = QueryRule.getRuleTemplate(rule);
        if (strRuleTemplate == null) {
            return "";
        }
        Configuration objConfig = new Configuration();
        Template objTemplate;
        StringWriter objWriter = null;
        String strExpression = null;
        try {
            objWriter = new StringWriter();
            objTemplate = new Template("gen_query_expression", strRuleTemplate, objConfig);
            objTemplate.process(objParams, objWriter);
            strExpression = objWriter.getBuffer().toString();
        } catch (TemplateException e) {
            throw new RuntimeException("生成查询表达式错误！", e);
        } catch (IOException e) {
            throw new RuntimeException("生成查询表达式错误！", e);
        } finally {
            IOUtil.closeQuietly(objWriter);
        }
        return strExpression;
    }
    
    /**
     * 通过流程ID查询流程名称
     * 
     * @param id 实体Id
     * @return 名称
     */
    @RemoteMethod
	public String queryProcessNameById(String id) {
		String strProcessName = "";
		try {
			ProcessInfo processInfo = ClientFactory.getDefinitionQueryService()
					.readLastProcessInfoById(id);
			if (processInfo != null)
				strProcessName = processInfo.getName();
		} catch (AbstractBpmsException e) {
			LOG.error(e.getMessage(), e);
		}
		return strProcessName;
	}
    
    /**
     * 查询数据库表并转换为实体
     * 
     * @param queryText 过滤文本
     * @param prefix 忽略表前缀长度
     * @param vo cui查询对象
     * @return 实体属性对象
     */
    @RemoteMethod
    public Map<String, Object> loadEntityFromDatabase(String queryText, Integer prefix, CuiQueryVO vo) {
        MetaConnection objMetaConn = EntityImportUtils.getMetaConnection();
        Map<String, Object> objQueryMap = new HashMap<String, Object>();
        IDatabaseLoader objLoader = DatabaseLoaderFactory.getDataBaseLoader(objMetaConn);
        List<TableVO> lstTableVO = objLoader.loadEntityFromDatabase(objMetaConn.getSchema(), queryText, prefix, false,
            objMetaConn);
        DBUtil.closeConnection(objMetaConn.getConn(), null, null);
        if (lstTableVO == null || lstTableVO.size() == 0) {
            lstTableVO = new ArrayList<TableVO>();
            objQueryMap.put(TOTAL_COUNT, 0);
            objQueryMap.put(PAGE_LIST, lstTableVO);
            return objQueryMap;
        }
        int iCount = lstTableVO.size();
        if (iCount < vo.getPageSize()) {
            objQueryMap.put(PAGE_LIST, lstTableVO);
        } else {
            int iFromIndex = (vo.getPageNo() - 1) * vo.getPageSize();
            int iToIndex = (vo.getPageNo() - 1) * vo.getPageSize() + vo.getPageSize();
            if (iToIndex > iCount) {
                iToIndex = iCount;
            }
            objQueryMap.put(PAGE_LIST, lstTableVO.subList(iFromIndex, iToIndex));
        }
        
        objQueryMap.put(TOTAL_COUNT, lstTableVO.size());
        return objQueryMap;
        // 模糊查询模式
    }
    
    /**
     * 查询数据库表主键
     * 
     * @param tableNames 表名称数组
     * @return false :不存在非单主键数据；true:存在非主键数据
     */
    @RemoteMethod
    public boolean loadTablePrimitiveKeyFormDataBase(String[] tableNames) {
        MetaConnection objMetaConn = EntityImportUtils.getMetaConnection();
        IDatabaseLoader objLoader = DatabaseLoaderFactory.getDataBaseLoader(objMetaConn);
        for (String tableName : tableNames) {
            List<String> lstPK = null;
            lstPK = objLoader.loadTablePrimitiveKeyFormDataBase(objMetaConn.getSchema(), tableName, objMetaConn);
            if (lstPK.size() != 1) {
                return false;
            }
        }
        DBUtil.closeConnection(objMetaConn.getConn(), null, null);
        return true;
    }
    
    /**
     * 通过表集合导入实体
     * 
     * @param packageId 包Id
     * @param lstTableVO 表集合
     * @return 保存成功的数量
     */
    public int saveEntityFromTable(String packageId, List<TableVO> lstTableVO) {
        int iResult = 0;
        boolean bResult = false;
        if (lstTableVO == null || lstTableVO.size() == 0) {
            return iResult;
        }
        List<EntityVO> lstEntityVO = new ArrayList<EntityVO>();
        for (TableVO objTableVO : lstTableVO) {
            
            EntityVO objEntityVO = this.createEntityVOByTableVO(objTableVO, NumberConstant.MINUS_ONE);
            // 设置实体保存基本的属性信息
            setBaseModelAttr(packageId, objEntityVO);
            // 转换数据库列的数据类型，pdm导入为VARCHAR2(40)，直接读取数据库类型为VARCHAR2，统一为VARCHAR2模式
            convertTableColumnDataType(objTableVO.getColumns());
            List<EntityAttributeVO> lstEntityAttributeVO = createAttributeVOLstByColumnVOLst(objTableVO.getColumns(),
                objEntityVO);
            objEntityVO.setAttributes(lstEntityAttributeVO);
            // 根据pdm关系导入实体关系
            List<EntityRelationshipVO> lstRelation = createRelationVOLstByReferenceVOLst(objTableVO.getReferences(),
                objEntityVO);
            objEntityVO.setLstRelation(lstRelation);
            lstEntityVO.add(objEntityVO);
            // 检测实体之前是否已经存在，如果存在，实体方法，父实体和关联流程等信息不做更新
            checkExistEntityMethod(objEntityVO);
            try {
                bResult = objEntityVO.saveModel();
                if (bResult) {
                    iResult++;
                }
            } catch (ValidateException e) {
                LOG.error("实体元数据对象保存失败：" + objEntityVO, e);
            }
            
        }
        // 保存的实体关系中可能有一些实体不存在，所以需要删除，如果存在这样的关系则添加实体关系属性到当前实体中
        checkEntityRelationshipAndDelete(lstEntityVO);
        return iResult;
    }
    
    /**
     * 检测实体是否存在，如果存在，实体方法信息需要保留
     * 
     * @param objEntityVO 实体对象
     */
    private void checkExistEntityMethod(EntityVO objEntityVO) {
        EntityVO objExistEntityVO = this.loadEntity(objEntityVO.getModelId(), null);
        if (objExistEntityVO != null) {
            objEntityVO.setMethods(objExistEntityVO.getMethods());
            objEntityVO.setParentEntityId(objExistEntityVO.getParentEntityId());
            objEntityVO.setProcessId(objExistEntityVO.getProcessId());
        }
    }
    
    /**
     * 检测pdm导入的实体关系中的实体对象是否存在，如果不存在，则删除，如果存在，则添加对应的关系属性到实体中
     * 
     * @param lstEntityVO pdm导入的实体集合
     */
    private void checkEntityRelationshipAndDelete(List<EntityVO> lstEntityVO) {
        for (EntityVO objEntityVO : lstEntityVO) {
            boolean isSave = false;
            List<EntityRelationshipVO> lstRelation = objEntityVO.getLstRelation();
            for (EntityRelationshipVO objEntityRelationshipVO : lstRelation) {
                String strTargetEntityId = objEntityRelationshipVO.getTargetEntityId();
                EntityVO objTargetEntity = this.loadEntity(strTargetEntityId, null);
                if (objTargetEntity == null) {// 如果关系中的对象不存在，则删除
                    objEntityRelationshipVO = null;
                } else {// 如果关系中的对象存在，则添加对象属性
                    EntityAttributeVO objEntityAttributeVO = new EntityAttributeVO();
                    if (objEntityRelationshipVO.getMultiple().equals(RelatioMultiple.ONE_ONE.getValue())) {
                        objEntityAttributeVO.setRelationId(objEntityRelationshipVO.getRelationId());
                        objEntityAttributeVO.setSortNo(objEntityVO.getAttributes().size() + 1);
                        objEntityAttributeVO.setEngName("relation"
                            + objEntityRelationshipVO.getEngName().substring(0, 1).toUpperCase()
                            + objEntityRelationshipVO.getEngName().substring(1));
                        objEntityAttributeVO.setChName(objEntityRelationshipVO.getChName());
                        objEntityAttributeVO.setAccessLevel(AccessLevel.PRIVATE_LEVEL.getValue());
                        DataTypeVO objDataTypeVO = new DataTypeVO();
                        objDataTypeVO.setSource(AttributeSourceType.ENTITY.getValue());
                        objDataTypeVO.setValue(objEntityRelationshipVO.getTargetEntityId());
                        objDataTypeVO.setType(AttributeSourceType.ENTITY.getValue());
                        List<DataTypeVO> lstDataTypeVO = new ArrayList<DataTypeVO>();
                        objDataTypeVO.setGeneric(lstDataTypeVO);
                        objEntityAttributeVO.setAttributeType(objDataTypeVO);
                        List<EntityAttributeVO> lstEntityAttributeVO = objEntityVO.getAttributes();
                        lstEntityAttributeVO.add(objEntityAttributeVO);
                    } else if (objEntityRelationshipVO.getMultiple().equals(RelatioMultiple.ONE_MANY.getValue())) {
                        objEntityAttributeVO.setRelationId(objEntityRelationshipVO.getRelationId());
                        objEntityAttributeVO.setSortNo(objEntityVO.getAttributes().size() + 1);
                        objEntityAttributeVO.setEngName("relation"
                            + objEntityRelationshipVO.getEngName().substring(0, 1).toUpperCase()
                            + objEntityRelationshipVO.getEngName().substring(1));
                        objEntityAttributeVO.setChName(objEntityRelationshipVO.getChName());
                        objEntityAttributeVO.setAccessLevel(AccessLevel.PRIVATE_LEVEL.getValue());
                        DataTypeVO objDataTypeVO = new DataTypeVO();
                        objDataTypeVO.setSource(AttributeSourceType.COLLECTION.getValue());
                        objDataTypeVO.setValue("java.util.List<" + objEntityRelationshipVO.getTargetEntityId() + ">");
                        objDataTypeVO.setType(AttributeType.JAVA_UTIL_LIST.getValue());
                        List<DataTypeVO> lstDataTypeVO = new ArrayList<DataTypeVO>();
                        DataTypeVO objDataTypeVOGeneric = new DataTypeVO();
                        objDataTypeVOGeneric.setSource(AttributeSourceType.ENTITY.getValue());
                        objDataTypeVOGeneric.setValue(objEntityRelationshipVO.getTargetEntityId());
                        objDataTypeVOGeneric.setType(AttributeSourceType.ENTITY.getValue());
                        lstDataTypeVO.add(objDataTypeVOGeneric);
                        objDataTypeVO.setGeneric(lstDataTypeVO);
                        objEntityAttributeVO.setAttributeType(objDataTypeVO);
                        List<EntityAttributeVO> lstEntityAttributeVO = objEntityVO.getAttributes();
                        lstEntityAttributeVO.add(objEntityAttributeVO);
                    }
                    isSave = true;
                }
            }
            if (isSave) {
                try {
                    objEntityVO.saveModel();
                } catch (ValidateException e) {
                    LOG.error("实体元数据对象保存失败：" + objEntityVO, e);
                }
            }
        }
        
    }
    
    /**
     * 根据pdm关系创建实体关系
     * 
     * <pre>
     * 
     * </pre>
     * 
     * @param references pdm关系集合
     * @param objEntityVO 实体
     * @return 实体关系集合
     */
    private List<EntityRelationshipVO> createRelationVOLstByReferenceVOLst(List<ReferenceVO> references,
        EntityVO objEntityVO) {
        if (references == null) {
            return null;
        }
        List<EntityRelationshipVO> lstEntityRelationshipVO = new ArrayList<EntityRelationshipVO>();
        for (ReferenceVO objReferenceVO : references) {
            EntityRelationshipVO objEntityRelationshipVO = createRelationVOByReferenceVO(objReferenceVO, objEntityVO);
            lstEntityRelationshipVO.add(objEntityRelationshipVO);
        }
        
        return lstEntityRelationshipVO;
    }
    
    /**
     * 根据pdm关系创建实体关系
     * 
     * <pre>
     * 
     * </pre>
     * 
     * @param objReferenceVO pdm关系对象
     * @param objEntityVO 实体
     * @return 实体关系对象
     */
    private EntityRelationshipVO createRelationVOByReferenceVO(ReferenceVO objReferenceVO, EntityVO objEntityVO) {
        List<ReferenceJoinVO> joins = objReferenceVO.getJoins();
        if (joins == null) {
            return null;
        }
        ReferenceJoinVO objReferenceJoinVO = joins.get(0);
        EntityRelationshipVO objEntityRelationshipVO = new EntityRelationshipVO();
        objEntityRelationshipVO.setRelationId(String.valueOf(System.currentTimeMillis()));
        String strEngName = StringUtil.uncapitalize(StringConvertor.toCamelCase(
            objReferenceJoinVO.getChildTableColumnCode(),
            Integer.valueOf(preferencesFacade.getConfig("tableColumnPrefixIngore").getConfigValue())));
        objEntityRelationshipVO.setEngName(strEngName);// 英文名
        objEntityRelationshipVO.setChName(strEngName);// 中文名
        String strCardinality = objReferenceVO.getCardinality();
        objEntityRelationshipVO.setMultiple(convertPdmCardinalityToEntityMultiple(strCardinality));// 实体多重性
        objEntityRelationshipVO.setSourceEntityId(objEntityVO.getModelId());// 源实体ID
        String strSourceField = StringUtil.uncapitalize(StringConvertor.toCamelCase(
            objReferenceJoinVO.getParentTableColumnCode(),
            Integer.valueOf(preferencesFacade.getConfig("tableColumnPrefixIngore").getConfigValue())));
        objEntityRelationshipVO.setSourceField(strSourceField); // 源实体关联的属性
        String strTargetTableName = objReferenceVO.getChildTable().getCode();
        String strTargetEntityId = StringConvertor.toCamelCase(strTargetTableName,
            Integer.valueOf(preferencesFacade.getConfig("tablePrefixIngore").getConfigValue()));
        objEntityRelationshipVO.setTargetEntityId(objEntityVO.getModelPackage() + ".entity." + strTargetEntityId);// 目标实体ID
        String strTargetField = StringUtil.uncapitalize(StringConvertor.toCamelCase(
            objReferenceJoinVO.getChildTableColumnCode(),
            Integer.valueOf(preferencesFacade.getConfig("tableColumnPrefixIngore").getConfigValue())));
        objEntityRelationshipVO.setTargetField(strTargetField);// 目标实体关联的属性
        return objEntityRelationshipVO;
    }
    
    /**
     * 根据pdm导入的多重性转换为实体的多重性
     * 
     * <pre>
     * 
     * </pre>
     * 
     * @param strCardinality pdm的多重性
     * @return 实体的多重性
     */
    private String convertPdmCardinalityToEntityMultiple(String strCardinality) {
        if (strCardinality.equals("1..1") || strCardinality.equals("0..1")) {
            return RelatioMultiple.ONE_ONE.getValue();
        } else if (strCardinality.equals("1..*") || strCardinality.equals("0..*")) {
            return RelatioMultiple.ONE_MANY.getValue();
        } else {
            return null;
        }
    }
    
    /**
     * <pre>
     * 数据库列类型转换
     * </pre>
     * 
     * @param lstColumnVO lstColumnVO
     */
    private void convertTableColumnDataType(List<ColumnVO> lstColumnVO) {
        for (ColumnVO objColumnVO : lstColumnVO) {
            String strDataType = objColumnVO.getDataType();
            strDataType = strDataType.replaceAll("(\\(\\d+\\))", "");
            objColumnVO.setDataType(strDataType);
        }
    }
    
    /**
     * 通过表集合导入实体
     * 
     * @param packagePath 包路径
     * @param lstViewVO 视图集合
     * @return 保存成功的数量
     */
    public int saveEntityFromView(String packagePath, List<ViewVO> lstViewVO) {
        int iResult = 0;
        boolean bResult = false;
        if (lstViewVO == null || lstViewVO.size() == 0) {
            return iResult;
        }
        
        for (ViewVO objViewVO : lstViewVO) {
            EntityVO objEntityVO = this.createEntityVOByViewVO(objViewVO);
            // 转换数据库列的数据类型，pdm导入为VARCHAR2(40)，直接读取数据库类型为VARCHAR2，统一为VARCHAR2模式
            convertViewColumnDataType(objViewVO.getColumns());
            List<EntityAttributeVO> lstEntityAttributeVO = createAttributeVOLstByViewColumnVOLst(
                objViewVO.getColumns(), objEntityVO);
            objEntityVO.setAttributes(lstEntityAttributeVO);
            setBaseModelAttr(packagePath, objEntityVO);
            try {
                bResult = objEntityVO.saveModel();
                if (bResult) {
                    iResult++;
                }
            } catch (ValidateException e) {
                LOG.error("实体元数据对象保存失败：" + objEntityVO, e);
            }
        }
        return iResult;
    }
    
    /**
     * <pre>
     * 数据库列类型转换
     * </pre>
     * 
     * @param lstViewColumnVO lstViewColumnVO
     */
    private void convertViewColumnDataType(List<ViewColumnVO> lstViewColumnVO) {
        for (ViewColumnVO objViewColumnVO : lstViewColumnVO) {
            String strDataType = objViewColumnVO.getDataType();
            strDataType = strDataType.replaceAll("(\\(\\d+\\))", "");
            objViewColumnVO.setDataType(strDataType);
        }
    }
    
    /**
     * 设置实体保存时的基础属性信息
     * 
     * @param packageId 包Id
     * @param objEntityVO 实体
     */
    private void setBaseModelAttr(String packageId, EntityVO objEntityVO) {
        CapPackageVO objPackageVO = packageFacade.queryPackageById(packageId);
        String packagePath = objPackageVO == null ? null : objPackageVO.getFullPath();
        objEntityVO.setPackageId(packageId);
        objEntityVO.setModelPackage(packagePath);
        objEntityVO.setModelType("entity");
        objEntityVO.setModelName(objEntityVO.getEngName());
        String strModelId = objEntityVO.getModelPackage() + "." + objEntityVO.getModelType() + "."
            + objEntityVO.getModelName();
        objEntityVO.setModelId(strModelId);
        objEntityVO.setDbObjectId(objEntityVO.getModelPackage() + ".table." + objEntityVO.getDbObjectName());
        objEntityVO.setAliasName(EntityAliasConverter.toUniqueAlias(objEntityVO.getEngName(), strModelId));
    }
    
    /**
     * 根据数据库导入时选择的条件查询对应的实体
     * 
     * @param packageId 应用id
     * @param tableNames 数据库表名
     * @param prefix 导入前缀
     * @return 符合对应条件的实体列表
     */
    @RemoteMethod
    public List<EntityVO> loadEntityListByTableName(String packageId, String[] tableNames, Integer prefix) {
        if (StringUtils.isBlank(packageId) || tableNames == null || tableNames.length == 0 || prefix == null) {
            return new ArrayList<EntityVO>(0);
        }
        CapPackageVO objPackageVO = packageFacade.queryPackageById(packageId);
        if (objPackageVO == null) {
            return new ArrayList<EntityVO>(0);
        }
        List<EntityVO> entityVOList = new ArrayList<EntityVO>(tableNames.length);
        for (String tableName : tableNames) {
            String modelTail = StringConvertor.toCamelCase(tableName, prefix);
            if (StringUtils.isBlank(modelTail)) {
                continue;
            }
            EntityVO entityVO = loadEntity(objPackageVO.getFullPath() + ".entity." + modelTail, packageId);
            if (entityVO != null) {
                entityVOList.add(entityVO);
            }
        }
        return entityVOList;
    }
    
    /**
     * 通过table导入实体
     * 
     * @param packageId 节点ID
     * @param tableNames 表名称集合
     * @param prefix 忽略表前缀长度
     * @param codePath 代码路径
     * @param curUserId 当前用户ID
     * @param curUserName 当前用户名字
     * @param entityList 别名冲突实体列表
     * @throws ValidateException 异常
     * @throws OperateException 异常
     * @return 是否导入成功
     */
    @RemoteMethod
    public boolean importTableToProject(String packageId, String[] tableNames, Integer prefix, String codePath,
        String curUserId, String curUserName, List<EntityVO> entityList) throws ValidateException, OperateException {
        
        if (tableNames == null || tableNames.length == 0) {
            // 如果未选中任何数据，则直接return
            return false;
        }
        
        List<String> lstTableName = Arrays.asList(tableNames);
        
        MetaConnection objMetaConn = EntityImportUtils.getMetaConnection();
        // 比较实体
        List<EntityCompareResult> objRets = this.compareEntity(packageId, objMetaConn.getSchema(), lstTableName,
            prefix, objMetaConn, curUserId, curUserName);
        
        // 设置别名
        objRets = updateEntityCompareResult(objRets, entityList);
        
        // 实体同步，添加新的，或者更新
        this.syncDatabaseToMeta(objRets);
        
        this.importTableToLocation(packageId, objMetaConn.getSchema(), lstTableName, prefix, objMetaConn, curUserId,
            curUserName);
        DBUtil.closeConnection(objMetaConn.getConn(), null, null);
        return true;
    }
    
    /**
     * 更新实体比较结果，确保导入别名唯一
     * 
     * @param objRets 实体比较结果列表
     * @param entityList 实体列表
     * @return 实体比较结果列表
     */
    private List<EntityCompareResult> updateEntityCompareResult(List<EntityCompareResult> objRets,
        List<EntityVO> entityList) {
        if (objRets != null && entityList != null && entityList.size() > 0) {
            List<EntityCompareResult> entityCompareResultList = new ArrayList<EntityCompareResult>();
            for (EntityCompareResult entityCompareResult : objRets) {
                for (EntityVO entityVO : entityList) {
                    if (entityVO.getModelId().equals(entityCompareResult.getSrcEntity().getModelId())) {
                        entityCompareResult.getSrcEntity().setAliasName(entityVO.getAliasName());
                    }
                }
                entityCompareResultList.add(entityCompareResult);
            }
            return entityCompareResultList;
        }
        return objRets;
    }
    
    /**
     * 导入实体前需要验证别名是否存在，如果存在需要先修改别名
     * 
     * @param packageId 节点ID
     * @param tableNames 表名称集合
     * @param prefix 忽略表前缀长度
     * @throws OperateException 异常
     * @return 返回别名存在的实体列表
     */
    @RemoteMethod
    public Map<String, Object> beforeImportTableToProject(String packageId, String[] tableNames, Integer prefix)
        throws OperateException {
        List<EntityVO> existSameAliasNameEntityVOs = new ArrayList<EntityVO>();
        Map<String, Object> objQueryMap = new HashMap<String, Object>();
        if (tableNames == null || tableNames.length == 0) {
            // 如果未选中任何数据，则直接return
            objQueryMap.put(TOTAL_COUNT, 0);
            objQueryMap.put(PAGE_LIST, existSameAliasNameEntityVOs);
            return objQueryMap;
        }
        
        CapPackageVO objPackageVO = packageFacade.queryPackageById(packageId);
        List<String> lstTableName = Arrays.asList(tableNames);
        
        MetaConnection objMetaConn = EntityImportUtils.getMetaConnection();
        // 获取数据库元数据的表名称集合
        List<EntityVO> lstEntity = this.loadEntitysFromDataBase(objMetaConn.getSchema(), lstTableName, prefix,
            objMetaConn);
        
        // 判断实体别名是否存在重复，如果存在重复，则弹出页面更改方法别名。
        for (EntityVO entityVO : lstEntity) {
            entityVO.setModelId(objPackageVO.getFullPath() + ".entity." + entityVO.getEngName());
            boolean existAliasName = this.isExistSameAliasNameEntity(entityVO.getAliasName(), entityVO.getModelId());
            if (existAliasName) {
                existSameAliasNameEntityVOs.add(entityVO);
            }
        }
        objQueryMap.put(TOTAL_COUNT, existSameAliasNameEntityVOs.size());
        objQueryMap.put(PAGE_LIST, existSameAliasNameEntityVOs);
        
        DBUtil.closeConnection(objMetaConn.getConn(), null, null);
        return objQueryMap;
    }
    
    /**
     * 通过table导入表对象到本地
     * 
     * @param packageId 包ID
     * @param schema 数据库模式
     * @param lstTableName 表名称集合
     * @param prefix 忽略表名长度
     * @param objMetaConn 数据库连接元数据
     * @param curUserId 当前用户ID
     * @param curUserName 当前用户名字
     * @return 是否导入成功
     */
    public boolean importTableToLocation(String packageId, String schema, List<String> lstTableName, Integer prefix,
        MetaConnection objMetaConn, String curUserId, String curUserName) {
        List<TableVO> lstTableVO = new ArrayList<TableVO>();
        for (String strTableName : lstTableName) {
            List<TableVO> lstSubTableVO = tableFacade.loadTableFromDatabase(schema, strTableName, prefix, true, true,
                objMetaConn);
            lstTableVO.addAll(lstSubTableVO);
        }
        
        // 向表对象中添加创建人信息
        for (TableVO objTableVO : lstTableVO) {
            if (StringUtils.isNotBlank(curUserId)) {
                objTableVO.setCreaterId(curUserId);
                objTableVO.setCreaterName(curUserName);
                objTableVO.setCreateTime(System.currentTimeMillis());
            }
            // 表解析时，engName是根据忽略表名长度截取过的，所以这里直接用code为表名
            objTableVO.setEngName(objTableVO.getCode());
        }
        
        // 查询指定的包
        CapPackageVO objPackageVO = packageFacade.queryPackageById(packageId);
        if (objPackageVO == null) {
            throw new CapMetaDataException("指定id:{0}的元数据包不存在。", packageId);
        }
        
        tableFacade.saveTableList(objPackageVO.getFullPath(), lstTableVO);
        return true;
    }
    
    /**
     * 同步数据表到实体元数据
     * 
     * @param objRets 实体与数据表比较结果集
     * @throws OperateException 异常
     * @throws ValidateException 异常
     */
    private void syncDatabaseToMeta(List<EntityCompareResult> objRets) throws ValidateException, OperateException {
        if (objRets == null || objRets.isEmpty()) {
            return;
        }
        
        for (EntityCompareResult objResult : objRets) {
            // 维护属性的序号
            setEntityAttributeSourtNo(objResult);
            switch (objResult.getResult()) {
                case EntityCompareResult.ENTITY_NOT_EXISTS:
                    
                    // 保存重新导入的实体,判断是否有重复名称的实体
                    if (!isExistSameNameEntity(objResult.getSrcEntity().getModelPackage(), objResult.getSrcEntity()
                        .getEngName(), objResult.getSrcEntity().getModelId())) {
                        objResult.getSrcEntity().saveModel();
                    } else {
                        insertNewTypeEntity(objResult.getSrcEntity());
                    }
                    
                    break;
                case EntityCompareResult.ENTITY_DESC_DIFF: // 忽略
                    break;
                case EntityCompareResult.ENTITY_ATTR_DIFF: // 更新
                    updateEntityAttributes(objResult);
                    objResult.getTargetEntity().saveModel();// 原实体保存
                    break;
                case EntityCompareResult.ENTITY_TYPE_DIFF: // 实体类型不同（查询实体和业务实体）
                    insertNewTypeEntity(objResult.getSrcEntity());
                    break;
                default:
                    break;
            }
        }
    }
    
    /**
     * 更新实体属性
     * 
     * @param results 实体比较结果
     */
    private void updateEntityAttributes(EntityCompareResult results) {
        List<AttributeCompareResult> lstAttributeCompareResult = results.getAttrResults();
        // 更新更新已存在的实体，获取已存在实体的属性
        List<EntityAttributeVO> lstEntityAttribute = results.getTargetEntity().getAttributes();
        for (AttributeCompareResult objResult : lstAttributeCompareResult) {
            switch (objResult.getResult()) {
                case AttributeCompareResult.ATTR_NOT_EXISTS:
                    lstEntityAttribute.add(objResult.getSrcAttribute());
                    break;
                case AttributeCompareResult.ATTR_DESC_DIFF: // 忽略
                    EntityAttributeVO objDescSrc = objResult.getSrcAttribute();
                    for (EntityAttributeVO objEntityAttributeVO : lstEntityAttribute) {
                        if (objDescSrc.getDbFieldId().equals(objEntityAttributeVO.getDbFieldId())) {
                            objEntityAttributeVO.setDescription(objDescSrc.getDescription());
                        }
                    }
                    break;
                case AttributeCompareResult.ATTR_DEL: // 删除
                    String strEngName = objResult.getTargetAttribute().getDbFieldId();
                    Iterator<EntityAttributeVO> it = lstEntityAttribute.iterator();
                    while (it.hasNext()) {
                        String dbFieldId = it.next().getDbFieldId();
                        if (StringUtils.isNotBlank(dbFieldId) && dbFieldId.equals(strEngName)) {
                            it.remove();
                            break;
                        }
                    }
                    break;
                case AttributeCompareResult.ATTR_DIFF: // 更新必要字段
                    EntityAttributeVO objSrc = objResult.getSrcAttribute();
                    for (EntityAttributeVO objEntityAttributeVO : lstEntityAttribute) {
                        if (objSrc.getDbFieldId().equals(objEntityAttributeVO.getDbFieldId())) {
                            objEntityAttributeVO.setAllowNull(objSrc.isAllowNull());
                            objEntityAttributeVO.setPrimaryKey(objSrc.isPrimaryKey());
                            objEntityAttributeVO.setChName(objSrc.getChName());
                            // objEntityAttributeVO.setDescription(objSrc.getChName());
                            objEntityAttributeVO.setAttributeLength(objSrc.getAttributeLength());
                            objEntityAttributeVO.setPrecision(objSrc.getPrecision());
                            objEntityAttributeVO.getAttributeType().setType(objSrc.getAttributeType().getType());
                            objEntityAttributeVO.setDefaultValue(objSrc.getDefaultValue());
                        }
                    }
                    break;
                default:
                    break;
            }
        }
        
        // 重新维护序号
        for (int i = 0; i < lstEntityAttribute.size(); i++) {
            EntityAttributeVO objAttr = lstEntityAttribute.get(i);
            objAttr.setSortNo(i + 1);
        }
    }
    
    /***
     * 
     * 设置比较结果中，属性的序号
     * 
     * @param objResult 实体比较结果
     */
    private void setEntityAttributeSourtNo(EntityCompareResult objResult) {
        List<EntityAttributeVO> lstEntityAttributeVO = objResult.getSrcEntity().getAttributes();
        for (int i = 0; i < lstEntityAttributeVO.size(); i++) {
            EntityAttributeVO objAttr = lstEntityAttributeVO.get(i);
            objAttr.setSortNo(i + 1);
        }
        
    }
    
    /**
     * 已有同名的查询实体，新增一个业务实体
     * 
     * @param entity 实体
     * @throws OperateException 异常
     * @throws ValidateException 异常
     */
    public void insertNewTypeEntity(final EntityVO entity) throws ValidateException, OperateException {
        int iIndex = 0;
        String strEntityName = entity.getEngName();
        while (true) {
            if (isExistSameNameEntity(entity.getModelPackage(), entity.getEngName(), entity.getModelId())) {
                iIndex++;
                String strName = strEntityName + iIndex;
                entity.setEngName(strName);
                continue;
            }
            entity.saveModel();
            return;
        }
    }
    
    /**
     * 获取实体与数据表比较结果集
     * 
     * @param packageId 包ID
     * @param schema 数据库模式
     * @param lstTableName 表名称集合
     * @param prefix 忽略表名长度
     * @param objMetaConn 数据库连接元数据
     * @param curUserId 当前用户ID
     * @param curUserName 当前用户名字
     * @return List<EntityCompareResult> 实体与数据表比较结果集
     * @throws OperateException 异常
     */
    private List<EntityCompareResult> compareEntity(String packageId, String schema, List<String> lstTableName,
        Integer prefix, MetaConnection objMetaConn, String curUserId, String curUserName) throws OperateException {
        // 查询指定的包
        CapPackageVO objPackageVO = packageFacade.queryPackageById(packageId);
        if (objPackageVO == null) {
            throw new CapMetaDataException("指定id:{0}的元数据包不存在。", packageId);
        }
        // 成功获取数据库元数据的表名称集合
        List<EntityVO> lstEntity = this.loadEntitysFromDataBase(schema, lstTableName, prefix, objMetaConn);
        if (CollectionUtils.isEmpty(lstEntity)) {
            return null;
        }
        // 向实体中添加包的属性
        for (EntityVO objEntity : lstEntity) {
            objEntity.setPackageId(packageId);
            objEntity.setPackageVO(objPackageVO);
            // 保存为文件时，需要添加的相关属性信息
            objEntity.setModelId(objPackageVO.getFullPath() + ".entity." + objEntity.getEngName());
            objEntity.setModelPackage(objPackageVO.getFullPath());
            objEntity.setModelName(objEntity.getEngName());
            objEntity.setModelType("entity");
            // 设置表ID
            objEntity.setDbObjectId(objPackageVO.getFullPath() + ".table." + objEntity.getDbObjectName());
            if (StringUtils.isNotBlank(curUserId)) {
                objEntity.setCreaterId(curUserId);
                objEntity.setCreaterName(curUserName);
            }
        }
        // 获取实体元数据中含有相同表名称的实体
        List<EntityVO> lstExistEntity = queryEntityByTableName(packageId, lstTableName, prefix);
        
        // 比较实体
        List<EntityCompareResult> objRets = EntityUtils.compareEntity(lstEntity, lstExistEntity,
            EntityUtils.ID_COPY_MODE_TARGET);
        return objRets;
    }
    
    /**
     * 根据表名称和包ID查询已经存在的实体
     * 
     * @param packageId 包ID
     * @param lstTableName 表名称集合
     * @param prefix 忽略表名长度
     * @return List<EntityCompareResult> 实体与数据表比较结果集
     * @throws OperateException 异常
     */
    private List<EntityVO> queryEntityByTableName(String packageId, List<String> lstTableName, Integer prefix)
        throws OperateException {
        List<EntityVO> lstEntityVO = this.queryEntityList(packageId);
        List<EntityVO> lstExistEntity = new ArrayList<EntityVO>();
        for (EntityVO objEntityVO : lstEntityVO) {
            for (String strTableName : lstTableName) {
                // 比较表名称
                if (strTableName.equals(objEntityVO.getDbObjectName())) {
                    lstExistEntity.add(objEntityVO);
                }
            }
        }
        
        return lstExistEntity;
    }
    
    /**
     * 获取指定名称的数据库表元数据
     * 
     * @param schema 数据库模式
     * @param tableNames 表名称集合
     * @param prefix 忽略表名节点数
     * @param conn 数据库连接元数据
     * @return 数据库表元数据
     */
    private List<EntityVO> loadEntitysFromDataBase(final String schema, final List<String> tableNames,
        final Integer prefix, final MetaConnection conn) {
        // 获取表的元数据
        List<EntityVO> lstEntity = new ArrayList<EntityVO>();
        for (String strTableName : tableNames) {
            List<EntityVO> lstSub = this.loadEntityFromDatabase(schema, strTableName, prefix, true, true, conn);
            if (!CollectionUtils.isEmpty(lstSub)) {
                lstEntity.addAll(lstSub);
            }
        }
        return lstEntity;
    }
    
    /**
     * 从数据库中获取表
     * 
     * @param schema 数据库模式
     * @param tablePatten 表名称模式
     * @param prefix 忽略前缀数
     * @param exact 精确的，TRUE表示精确查询，false表示模糊查询
     * @param cascade 是否级联查询表字段和表索引
     * @param conn 数据库连接元数据
     * 
     * @return 表对象集合，当为精确查询时，返回的集合中应该只有一个表对象
     */
    public List<EntityVO> loadEntityFromDatabase(final String schema, final String tablePatten, final Integer prefix,
        final boolean exact, final boolean cascade, final MetaConnection conn) {
        List<TableVO> lstTableVO = tableFacade.loadTableFromDatabase(schema, tablePatten, prefix, true, true, conn);
        
        if (CollectionUtils.isEmpty(lstTableVO)) {
            return null;
        }
        // 数据库表转实体
        List<EntityVO> lstEntity = new ArrayList<EntityVO>();
        for (TableVO objTableVO : lstTableVO) {
            EntityVO objEntityVO = this.createEntityVOByTableVO(objTableVO, prefix);
            if (!CollectionUtils.isEmpty(objTableVO.getColumns())) {
                List<EntityAttributeVO> lstEntityAttributeVO = createAttributeVOLstByColumnVOLst(
                    objTableVO.getColumns(), objEntityVO);
                objEntityVO.setAttributes(lstEntityAttributeVO);
            }
            lstEntity.add(objEntityVO);
        }
        
        return lstEntity;
    }
    
    /**
     * 
     * 数据库表VO转换为实体VO
     * 
     * <pre>
     * 
     * @param prefix 忽略表前缀长度
     * 
     * @param objTableVO 表实体对象
     * @return 实体对象
     */
    private EntityVO createEntityVOByTableVO(TableVO objTableVO, Integer prefix) {
        EntityVO objEntityVO = new EntityVO();
        String strEngName;
        if (prefix == NumberConstant.MINUS_ONE) {
            strEngName = StringConvertor.toCamelCase(objTableVO.getEngName(),
                Integer.valueOf(preferencesFacade.getConfig("tablePrefixIngore").getConfigValue()));
        } else {
            strEngName = StringConvertor.toCamelCase(objTableVO.getEngName(), prefix);
        }
        String aliasName = strEngName.substring(0, 1).toLowerCase() + strEngName.substring(1);
        objEntityVO.setEngName(strEngName);
        objEntityVO.setAliasName(aliasName);
        objEntityVO.setChName(objTableVO.getChName());
        objEntityVO.setDescription(objTableVO.getDescription());
        objEntityVO.setDbObjectName(objTableVO.getCode());
        objEntityVO.setClassPattern(ClassPattern.COMMON.getValue());
        objEntityVO.setEntityType(EntityType.BIZ_ENTITY.getValue());
        objEntityVO.setEntitySource(EntitySource.TABLE_METADATA_IMPORT.getValue());
        Set<String> objAllColumn = new HashSet<String>();
        for (ColumnVO objColumnVO : objTableVO.getColumns()) {
            objAllColumn.add(objColumnVO.getCode());
        }
        objEntityVO.setParentEntityId(getParentEntityId(objAllColumn));// 默认父实体id
        return objEntityVO;
    }
    
    /**
     * 
     * 数据库视图VO转换为实体VO
     * 
     * <pre>
     * 
     * </pre>
     * 
     * @param objViewVO 表实体对象
     * @return 实体对象
     */
    private EntityVO createEntityVOByViewVO(ViewVO objViewVO) {
        EntityVO objEntityVO = new EntityVO();
        String strEngName = StringConvertor.toCamelCase(objViewVO.getEngName(),
            Integer.valueOf(preferencesFacade.getConfig("tablePrefixIngore").getConfigValue()));
        String aliasName = strEngName.substring(0, 1).toLowerCase() + strEngName.substring(1);
        objEntityVO.setAliasName(aliasName);
        objEntityVO.setChName(objViewVO.getChName());
        objEntityVO.setEngName(strEngName);
        objEntityVO.setDescription(objViewVO.getDescription());
        objEntityVO.setDbObjectName(objViewVO.getCode());
        objEntityVO.setClassPattern(ClassPattern.COMMON.getValue());
        objEntityVO.setEntityType(EntityType.QUERY_ENTITY.getValue());
        objEntityVO.setEntitySource(EntitySource.VIEW_METADATA_IMPORT.getValue());
        Set<String> objAllColumn = new HashSet<String>();
        for (ViewColumnVO objViewColumnVO : objViewVO.getColumns()) {
            objAllColumn.add(objViewColumnVO.getCode());
        }
        objEntityVO.setParentEntityId(getParentEntityId(objAllColumn));// 默认父实体id
        return objEntityVO;
    }
    
    /**
     * 
     * 数据库表VO转换为实体VO
     * 
     * <pre>
     * 
     * </pre>
     * 
     * @param objColumnVO 表实体对象
     * @param iSort 实体序号
     * @param objEntityVO 实体对象
     * @return 实体对象
     */
    private EntityAttributeVO createAttributeVOByColumnVO(ColumnVO objColumnVO, int iSort, EntityVO objEntityVO) {
        return TableSysncEntityUtil.columnConvertToAttribute(objColumnVO, iSort);
    }
    
    /**
     * 
     * 数据库视图VO转换为实体VO
     * 
     * <pre>
     * 
     * </pre>
     * 
     * @param objViewColumnVO 表实体对象
     * @param iSort 实体序号
     * @param objEntityVO 实体对象
     * @return 实体对象
     */
    private EntityAttributeVO createAttributeVOByViewColumnVO(ViewColumnVO objViewColumnVO, int iSort,
        EntityVO objEntityVO) {
        int iSortNo = iSort + 1;
        EntityAttributeVO objEntityAttributeVO = new EntityAttributeVO();
        objEntityAttributeVO.setAccessLevel(AccessLevel.PRIVATE_LEVEL.getValue());
        objEntityAttributeVO.setSortNo(iSortNo);
        objEntityAttributeVO.setQueryField(true); // 数据库字段，都可作为查询字段
        objEntityAttributeVO.setQueryMatchRule(String.valueOf(QueryRule.EQ));
        String strQueryExpr = this.genQueryExpression(QueryRule.EQ, objViewColumnVO.getCode(),
            objViewColumnVO.getEngName());
        objEntityAttributeVO.setQueryExpr(strQueryExpr);
        objEntityAttributeVO.setChName(objViewColumnVO.getChName());
        String strEngName = StringUtil.uncapitalize(StringConvertor.toCamelCase(objViewColumnVO.getEngName(),
            Integer.valueOf(preferencesFacade.getConfig("tableColumnPrefixIngore").getConfigValue())));
        objEntityAttributeVO.setEngName(strEngName);
        objEntityAttributeVO.setDescription(objViewColumnVO.getDescription());
        DataTypeVO objDataTypeVO = new DataTypeVO();
        if (objViewColumnVO.getDataType().equals(OracleFieldType.BLOB.getValue())) {
            objDataTypeVO.setSource(AttributeSourceType.JAVA_OBJECT.getValue());// 属性来源为对象
        } else {
            objDataTypeVO.setSource(AttributeSourceType.PRIMITIVE.getValue());// 属性来源为基本类型
        }
        objDataTypeVO.setType(OracleFieldType.getAttributeDataType(objViewColumnVO.getDataType(),
            objViewColumnVO.getPrecision()));// 需要根据数据库类型，转换为java类型
        objDataTypeVO.setValue(""); // 空的属性也需要添加，数据库同步时比较有问题
        objEntityAttributeVO.setAttributeType(objDataTypeVO);// 实体属性数据类型
        objEntityAttributeVO.setDbFieldId(objViewColumnVO.getCode());// 数据库对应的字段
        objEntityAttributeVO.setAttributeLength(objViewColumnVO.getLength());// 属性长度
        objEntityAttributeVO.setPrecision(String.valueOf(objViewColumnVO.getPrecision()));// 属性精度
        return objEntityAttributeVO;
    }
    
    /**
     * 
     * 数据库表VO转换为实体VO
     * 
     * <pre>
     * 
     * </pre>
     * 
     * @param objEntityVO 实体对象
     * @param lstColumnVO 表属性对象
     * @return 实体属性对象
     */
    private List<EntityAttributeVO> createAttributeVOLstByColumnVOLst(List<ColumnVO> lstColumnVO, EntityVO objEntityVO) {
        List<EntityAttributeVO> lstEntityAttributeVO = new ArrayList<EntityAttributeVO>();
        for (int i = 0; i < lstColumnVO.size(); i++) {
            lstEntityAttributeVO.add(createAttributeVOByColumnVO(lstColumnVO.get(i), i, objEntityVO));
        }
        return lstEntityAttributeVO;
    }
    
    /**
     * 
     * 数据库表VO转换为实体VO
     * 
     * <pre>
     * 
     * </pre>
     * 
     * @param objEntityVO 实体对象
     * @param lstViewColumnVO 表属性对象
     * @return 实体属性对象
     */
    private List<EntityAttributeVO> createAttributeVOLstByViewColumnVOLst(List<ViewColumnVO> lstViewColumnVO,
        EntityVO objEntityVO) {
        List<EntityAttributeVO> lstEntityAttributeVO = new ArrayList<EntityAttributeVO>();
        for (int i = 0; i < lstViewColumnVO.size(); i++) {
            lstEntityAttributeVO.add(createAttributeVOByViewColumnVO(lstViewColumnVO.get(i), i, objEntityVO));
        }
        return lstEntityAttributeVO;
    }
    
    /**
     * 删除实体
     * 
     * @param lstDelEntityVO 需要删除的实体列表
     * @return 操作结果
     * @throws OperateException 异常
     */
    @RemoteMethod
    public String isAbleDelete(List<EntityVO> lstDelEntityVO) throws OperateException {
        if (lstDelEntityVO == null || lstDelEntityVO.size() == 0) {
            return "";
        }
        // 获取所以实体
        List<EntityVO> lstAllEntityVO = queryAllEntity();
        List<EntityVO> lstNoDelEntityVO = getNoDelEntityVO(lstAllEntityVO, lstDelEntityVO);
        
        StringBuilder strMsg = new StringBuilder();
        for (EntityVO objVo : lstDelEntityVO) {
            if (!isAbleDeleteNode(objVo.getModelId(), lstNoDelEntityVO)) {
                if (strMsg.length() == 0) {
                    strMsg.append("以下实体被引用不能删除：");
                } else {
                    strMsg.append("、");
                }
                strMsg.append(objVo.getEngName());
            }
        }
        return strMsg.toString();
    }
    
    /**
     * 单个删除实体
     * 
     * @param entity 实体
     * @return 操作结果
     * @throws OperateException 异常
     */
    @RemoteMethod
    public String isAbleDeleteEntity(EntityVO entity) throws OperateException {
        if (entity == null || entity.getModelId() == null) {
            return "";
        }
        EntityVO objDelEntityVO = this.loadEntity(entity.getModelId(), null);
        List<EntityVO> lstDelEntityVO = new ArrayList<EntityVO>();
        lstDelEntityVO.add(objDelEntityVO);
        // 获取所以实体
        List<EntityVO> lstAllEntityVO = queryAllEntity();
        List<EntityVO> lstNoDelEntityVO = getNoDelEntityVO(lstAllEntityVO, lstDelEntityVO);
        if (!isAbleDeleteNode(objDelEntityVO.getModelId(), lstNoDelEntityVO)) {
            return "当前实体被引用不能删除！";
        }
        return "";
    }
    
    /**
     * 
     * 
     * <pre>
     * 
     * </pre>
     * 
     * @param lstAllEntityVO 所有实体
     * @param lstDelEntityVO 被删除的实体
     * @return 不被删除的实体集合
     */
    private List<EntityVO> getNoDelEntityVO(List<EntityVO> lstAllEntityVO, List<EntityVO> lstDelEntityVO) {
        List<EntityVO> lstRet = new ArrayList<EntityVO>();
        boolean bDel = false;
        for (int i = 0; i < lstAllEntityVO.size(); i++) {
            for (int j = 0; j < lstDelEntityVO.size(); j++) {
                if (lstAllEntityVO.get(i).getModelId().equals(lstDelEntityVO.get(j).getModelId())) {
                    bDel = true;
                }
            }
            if (!bDel) {
                lstRet.add(lstAllEntityVO.get(i));
            }
        }
        return lstRet;
    }
    
    /**
     * 根据实体ID、判断实体是否能够被删除
     * 
     * @param modelId 删除实体ID
     * @param lstNoDelEntityVO 不被删除的实体集合
     * @return boolean true or false 是否能被删除
     */
    private boolean isAbleDeleteNode(String modelId, List<EntityVO> lstNoDelEntityVO) {
        // 循环所有实体
        for (EntityVO objEntityVO : lstNoDelEntityVO) {
            // 判断是否是其他实体的父实体
            if (modelId.equals(objEntityVO.getParentEntityId())) {
                return false;
            }
            
            // 判断是否是其他实体的属性
            List<EntityAttributeVO> lstAttributes = objEntityVO.getAttributes();
            if (lstAttributes != null) {
                for (EntityAttributeVO objEntityAttributeVO : lstAttributes) {
                    if (AttributeSourceType.ENTITY.getValue().equals(
                        objEntityAttributeVO.getAttributeType().getSource())
                        && modelId.equals(objEntityAttributeVO.getAttributeType().getValue())) {
                        return false;
                    }
                }
            }
            // 判断是否是其他实体的源实体，或者是目标实体
            List<EntityRelationshipVO> lstEntityRelationshipVO = objEntityVO.getLstRelation();
            if (lstEntityRelationshipVO != null) {
                for (EntityRelationshipVO objEntityRelationshipVO : lstEntityRelationshipVO) {
                    if (modelId.equals(objEntityRelationshipVO.getTargetEntityId())
                        || modelId.equals(objEntityRelationshipVO.getSourceEntityId())
                        || modelId.equals(objEntityRelationshipVO.getAssociateEntityId())) {
                        return false;
                    }
                }
            }
            
            // 校验实体的所有方法的返回值终极类型以及方法的所有参数的终极类型是否与指定的实体为同一个实体
            List<MethodVO> lstMethods = objEntityVO.getMethods();
            boolean result = validateMethods4DelEntity(lstMethods, modelId);
            if (!result) {
                return false;
            }
            
        }
        return true;
    }
    
    /**
     * 
     * 校验实体的所有的方法的返回值终极类型（实体）及每个方法的所有参数终极类型（实体）是否是指定的实体
     * 
     * @param lst 实体的所有方法
     * @param modelId 指定的实体
     * @return true表示校验通过（不是指定的实体），false表示校验不通过（是指定的实体）
     */
    private boolean validateMethods4DelEntity(List<MethodVO> lst, String modelId) {
        if (lst != null) {
            // 循环校验方法
            for (int n = 0, len = lst.size(); n < len; n++) {
                // 校验方法的返回值
                boolean mResult = validateDataType(lst.get(n).getReturnType(), modelId);
                if (!mResult) {
                    return false;
                }
                // 校验方法的所有参数
                boolean pResult = validateMethodParams4DelEntity(lst.get(n).getParameters(), modelId);
                if (!pResult) {
                    return false;
                }
            }
        }
        return true;
    }
    
    /**
     * 
     * 校验方法的参数的终极类型（实体）是否是指定实体
     * 
     * @param lst 所有参数的集合
     * @param modelId 指定的实体
     * @return 校验的结果，如果是同一个则返回false，不是同一个则返回true
     */
    private boolean validateMethodParams4DelEntity(List<ParameterVO> lst, String modelId) {
        if (lst != null) {
            // 循环校验参数
            for (int i = 0, len = lst.size(); i < len; i++) {
                boolean result = validateDataType(lst.get(i).getDataType(), modelId);
                if (!result) {
                    return false;
                }
            }
        }
        return true;
    }
    
    /**
     * 
     * 校验数据(返回值、参数)终极类型（实体）是否与指定的实体是同一个
     * 
     * 
     * @param dvo 返回值、参数的类型的DataTypeVO
     * @param modelId 指定的实体Id
     * @return 是同一个实体返回false，否则返回true
     */
    private boolean validateDataType(DataTypeVO dvo, String modelId) {
        // 获得DataTypeVO的属性值
        String source = dvo.getSource();
        String value = dvo.getValue();
        String type = dvo.getType();
        List<DataTypeVO> generic = dvo.getGeneric();
        
        // 来源于实体
        if (AttributeSourceType.ENTITY.getValue().equals(source)) {
            if (modelId.equals(value)) {
                return false;
            }
        } else if (AttributeSourceType.COLLECTION.getValue().equals(source)) { // 来源于集合
            if (AttributeType.JAVA_UTIL_LIST.getValue().equals(type)) { // 类型为java.util.List
                if (modelId.equals(generic.get(0).getValue())) {
                    return false;
                }
            } else if (AttributeType.JAVA_UTIL_MAP.getValue().equals(type)) { // 类型为java.util.Map
                if (modelId.equals(generic.get(1).getValue())) {
                    return false;
                }
            }
        }
        
        return true;
    }
    
    /**
     * 
     * 获取实体的级联属性
     * 
     * 
     * @param currentEntityVO 当前实体
     * @param curMethodOperType 方法操作类型
     * @param parentId 级联属性的父Id
     * @param indent 级联属性在页面上显示的缩进单位数
     * @param _relaId 级联属性ID的前缀
     * @return 级联属性集合
     */
    @RemoteMethod
    public List<CascadeAttributeVO> getCascadeAttribute(final EntityVO currentEntityVO, final String curMethodOperType,
        final String parentId, int indent, final String _relaId) {
        // 取得当前实体VO
        if (currentEntityVO == null) {
            return null;
        }
        // 取得当前实体所有的关系VO
        List<EntityRelationshipVO> lstRelation = currentEntityVO.getLstRelation();
        // 取得当前实体所有属性VO
        List<EntityAttributeVO> attributes = currentEntityVO.getAttributes();
        
        if (CollectionUtils.isEmpty(lstRelation) || CollectionUtils.isEmpty(attributes)) {
            return null;
        }
        
        List<CascadeAttributeVO> lstCascadeAttribute = null; // new ArrayList<CascadeAttributeVO>(); //在这里创建，当空的时候持久化为[]
        // 遍历所有关系和所有属性
        for (int i = 0, len = lstRelation.size(); i < len; i++) {
            for (int j = 0, _len = attributes.size(); j < _len; j++) {
                if (lstRelation.get(i).getRelationId().equals(attributes.get(j).getRelationId())) {
                    // 为空则创建。
                    if (lstCascadeAttribute == null) {
                        lstCascadeAttribute = new ArrayList<CascadeAttributeVO>(); // 在这里创建，当空的时候，持久化到文件中没lstCascadeAttribute属性
                    }
                    // 创建一个级联属性VO
                    CascadeAttributeVO cascadeAttributeVo = new CascadeAttributeVO();
                    // 设置级联属性的ID及parentId
                    String relaId = null;
                    if (_relaId == null) {
                        relaId = lstRelation.get(i).getRelationId();
                    } else {
                        relaId = _relaId;
                    }
                    cascadeAttributeVo.setId(relaId + "/" + currentEntityVO.getModelId() + "."
                        + attributes.get(j).getEngName()); // 1446435782285/com.comtop.user.entity.RelationTest.relationO_o
                    String _parentId = StringUtil.isBlank(parentId) ? "-1" : parentId;
                    cascadeAttributeVo.setParentId(_parentId);
                    cascadeAttributeVo.setName(attributes.get(j).getEngName());
                    // 设置级联属性界面显示的类型（中间表集合和业务表集合（一对多关系）一般都是java.util.List，一对一关系就是Entity）
                    cascadeAttributeVo.setDisplayType(attributes.get(j).getAttributeType().getType());
                    // 设置级联属性生成代码的类型，属性对应的实体类型
                    cascadeAttributeVo.setGenerateCodeType(lstRelation.get(i).getTargetEntityId());
                    // 设置级联属性界面表格中显示的缩进单位数
                    cascadeAttributeVo.setIndent(indent);
                    
                    String relMultiple = lstRelation.get(i).getMultiple();
                    // 判断当前属性是否是（多对多关系生成的）中间表集合(List<中间实体>>)字段，中间表集合属性字段不读取
                    if (!attributes.get(j).isAssociateListAttr()) {
                        // 如果是级联查询或是一对一关系或是一对多关系，则递归查出下一级级联属性；
                        // 如果不是级联查询(新增、修改、删除)并且是多对一关系或多对多关系，则只查询当前一级级联属性（即当前实体的级联属性），不再递归往下查
                        if (MethodOperateType.QUERY.getValue().equals(curMethodOperType)
                            || RelatioMultiple.ONE_MANY.getValue().equals(relMultiple)
                            || RelatioMultiple.ONE_ONE.getValue().equals(relMultiple)) {
                            // 赋值临时变量，在递归里面使用自增（不能直接在递归里使用++indent,否则会影响外层循环的indent值）
                            int tempIndent = indent;
                            cascadeAttributeVo.setLstCascadeAttribute(getCascadeAttribute(
                                loadEntity(lstRelation.get(i).getTargetEntityId(), null), curMethodOperType,
                                cascadeAttributeVo.getId(), ++tempIndent, relaId));
                        }
                        lstCascadeAttribute.add(cascadeAttributeVo);
                    }
                }
            }
        }
        return lstCascadeAttribute;
    }
    
    /**
     * 
     * 通过实体的一级父实体ID获取该实体的所有父实体
     * 
     * @param parentEntityModelId 父实体的modelId
     * @return 所有父实体的集合
     */
    @RemoteMethod
    public List<EntityVO> getAllParentEntity(String parentEntityModelId) {
        // 父实体的ID为空，直接返回null
        if (StringUtil.isBlank(parentEntityModelId)) {
            return null;
        }
        
        final EntityVO firstPEntityVO = loadEntity(parentEntityModelId, null);
        // 父实体为空直接返回null
        if (firstPEntityVO == null) {
            return null;
        } else if (StringUtil.isBlank(firstPEntityVO.getParentEntityId())) {
            return new ArrayList<EntityVO>() {
                
                /** 序列化版本ID */
                private static final long serialVersionUID = 1L;
                
                {
                    this.add(firstPEntityVO);
                }
            };
        }
        
        /**
         * 
         * <code>getAllParentEntity(String modelId)</code>方法内部类。
         * 
         * @author 凌晨
         * @since jdk1.6
         * @version 2015年10月28日 凌晨
         */
        class T {
            
            // 存放父实体的list(从二级父实体开始存)
            private List<EntityVO> lstParentEntitys;
            
            public void getParentEntityVO(String parentModelId) {
                EntityVO parentEntityVO = loadEntity(parentModelId, null);
                if (parentEntityVO != null) {
                    if (lstParentEntitys == null) {
                        lstParentEntitys = new ArrayList<EntityVO>();
                    }
                    
                    // 把父实体添加到list中
                    lstParentEntitys.add(parentEntityVO);
                    
                    // 如果父实体里面还有“父实体ID”，则再取得父实体，一直递归到没有父实体为止
                    if (StringUtil.isNotBlank(parentEntityVO.getParentEntityId())) {
                        getParentEntityVO(parentEntityVO.getParentEntityId());
                    }
                }
            }
            
            /**
             * @return 获取 lstParentEntitys属性值
             */
            public List<EntityVO> getLstParentEntitys() {
                return lstParentEntitys;
            }
            
        }
        
        // 创建T的匿名类对象，在创建对象的过程中，获取所有父实体（从二级父实体开始的所有父实体），最后返回所有父实体的集合
        List<EntityVO> lstPEntityVO = new T() {
            
            {
                this.getParentEntityVO(firstPEntityVO.getParentEntityId());
            }
        }.getLstParentEntitys();
        
        // 把一级父实体添加到集合的第一个位置
        if (lstPEntityVO == null) {
            lstPEntityVO = new ArrayList<EntityVO>();
        }
        lstPEntityVO.add(0, firstPEntityVO);
        
        return lstPEntityVO;
    }
    
    /**
     * 
     * 获取本实体及所有父实体的所有方法或属性。
     * 
     * @param modelId 本实体的modelId
     * @param instance 具体获取实体信息的实现类
     * @return 所有方法或属性的集合（有序的，先放本实体的方法或属性，再放父实体的方法或属性，父实体是从一级父实体往后顺序放置）
     */
    public List<? extends BaseMetadata> getSelfAndParentInfo(String modelId, IEntitysInfo instance) {
        // 获得当前实体
        EntityVO currentEntityVO = loadEntity(modelId, null);
        if (currentEntityVO == null) {
            return null;
        }
        List<EntityVO> lstSelfAndParentEntityVO = new ArrayList<EntityVO>();
        lstSelfAndParentEntityVO.add(currentEntityVO);
        // 获得所有父实体
        List<EntityVO> allParentEntityVO = getAllParentEntity(currentEntityVO.getParentEntityId());
        if (!CollectionUtils.isEmpty(allParentEntityVO)) {
            lstSelfAndParentEntityVO.addAll(allParentEntityVO);
        }
        
        return instance.getAllEntitysInfo(lstSelfAndParentEntityVO);
    }
    
    /**
     * 
     * 获取本实体及所有父实体的所有属性。
     * 
     * @param modelId 本实体的modelId
     * @return 所有属性的集合（有序的，先放本实体的属性，再放父实体的属性，父实体是从一级父实体往后顺序放置）
     */
    @SuppressWarnings("unchecked")
    @RemoteMethod
    public List<EntityAttributeVO> getSelfAndParentAttributes(String modelId) {
        return (List<EntityAttributeVO>) getSelfAndParentInfo(modelId, new IEntitysInfo() {
            
            @Override
            public List<EntityAttributeVO> getAllEntitysInfo(List<EntityVO> lstEntityVOs) {
                List<EntityAttributeVO> lstAllAttributes = new ArrayList<EntityAttributeVO>();
                // 取所有实体的所有方法
                for (EntityVO entityVO : lstEntityVOs) {
                    if (!CollectionUtils.isEmpty(entityVO.getAttributes())) {
                        lstAllAttributes.addAll(entityVO.getAttributes());
                    }
                }
                
                return lstAllAttributes;
            }
        });
        
    }
    
    /**
     * 
     * 获取应用下所有服务清单（供文档导入导出使用）
     * 
     * @param appId 应用id，即包id
     * @return 应用下所有服务集合
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public List<MethodVO> queryMethodsByAppId(String appId) throws OperateException {
        List<MethodVO> lstAllMethod = new ArrayList<MethodVO>();
        List<EntityVO> lstEntityVO = this.queryEntityList(appId);
        if (lstEntityVO != null) {
            for (EntityVO objEntityVO : lstEntityVO) {
                List<MethodVO> lstTempMethodVO = getSelfAndParentMethods(objEntityVO.getModelId());
                if (lstTempMethodVO != null) {
                    lstAllMethod.addAll(lstTempMethodVO);
                }
            }
        }
        return lstAllMethod;
    }
    
    /**
     * 
     * 获取本实体及所有父实体的所有方法。
     * 
     * @param modelId 本实体的modelId
     * @return 所有方法的集合（有序的，先放本实体的方法，再放父实体的方法，父实体是从一级父实体往后顺序放置）
     */
    @SuppressWarnings("unchecked")
    @RemoteMethod
    public List<MethodVO> getSelfAndParentMethods(String modelId) {
        return (List<MethodVO>) getSelfAndParentInfo(modelId, new IEntitysInfo() {
            
            @Override
            public List<MethodVO> getAllEntitysInfo(List<EntityVO> lstEntityVOs) {
                List<MethodVO> lstAllMethods = new ArrayList<MethodVO>();
                // 取所有实体的所有方法
                for (EntityVO entityVO : lstEntityVOs) {
                    if (!CollectionUtils.isEmpty(entityVO.getMethods())) {
                        lstAllMethods.addAll(entityVO.getMethods());
                    }
                }
                
                return lstAllMethods;
            }
        });
        
    }
    
    /**
     * 根据过滤条件过滤实体方法
     * 
     * @param modelId
     *            实体modelId
     * @param filter
     *            过滤条件
     * @return 实体方法集合
     */
    @RemoteMethod
    public List<MethodVO> filterMethods(String modelId, String filter) {
        if (StringUtil.isBlank(modelId)) {
            return new ArrayList<MethodVO>();
        }
        
        if (StringUtil.isBlank(filter)) {
            return getSelfAndParentMethods(modelId);
        }
        
        List<MethodVO> filterMethods = new ArrayList<MethodVO>();
        List<EntityVO> allEntitys = new ArrayList<EntityVO>();
        EntityVO selfEntity = (EntityVO) CacheOperator.readById(modelId);
        allEntitys.add(selfEntity);
        if (StringUtil.isNotBlank(selfEntity.getParentEntityId())) {
            allEntitys.addAll(getAllParentEntity(selfEntity.getParentEntityId()));
        }
        
        try {
            for (EntityVO entity : allEntitys) {
                String exp = entity.getModelPackage()
                    + "/entity[@modelId ='{1}']/methods[contains(engName,'{0}') or contains(chName,'{0}')]";
                String expression = EntityConsistencyUtil.parsingExpression(exp, filter, entity.getModelId());
                List<MethodVO> methods = CacheOperator.queryList(expression, MethodVO.class);
                filterMethods.addAll(methods);
            }
        } catch (OperateException e) {
            LOG.error("查询实体方法出错:" + e.getMessage(), e);
        }
        
        return filterMethods;
    }
    
    /**
     * 获取级联属性最终的类型（如：com.comtop.entity.UserVO）
     * 
     * @param attributeVO 级联属性
     * @return 返回的级联属性的类型
     */
    public String getEntityCascadeAttrFinalType(EntityAttributeVO attributeVO) {
        // 获得级联属性的类型，只有两种（其他实体和List）
        String source = attributeVO.getAttributeType().getSource();
        String type = attributeVO.getAttributeType().getType();
        // 如果来源于集合
        if (StringUtil.isNotBlank(source) && source.equals(AttributeSourceType.COLLECTION.getValue())) {
            // 并且是java.util.List类型，则取泛型中的类型
            if (StringUtil.isNotBlank(type) && type.equals(AttributeType.JAVA_UTIL_LIST.getValue())) {
                return attributeVO.getAttributeType().getGeneric().get(0).getValue();
            }
        } else if (StringUtil.isNotBlank(source) && source.equals(AttributeSourceType.ENTITY.getValue())) { // 如果来源于其他实体，直接获取类型
            return attributeVO.getAttributeType().getValue();
        }
        return null;
    }
    
    /**
     * 获取配置项中父类配置信息
     * 
     * @param objAllColumn 数据库字段集合字符串
     * 
     * @return 父实体ID
     */
    public String getParentEntityId(Set<String> objAllColumn) {
        // 默认父实体配置对象
        if (objAllColumn == null) {
            return PreferenceConfigQueryUtil.getDefaultParentEntityId();
        }
        // 默认工作流父实体匹配规则
        String[] strMatch = PreferenceConfigQueryUtil.getWorkflowMarchRule();
        Set<String> objMatch = new HashSet<String>(Arrays.asList(strMatch));
        if (objAllColumn.containsAll(objMatch)) {
            // 默认工作流父实体配置对象
            return PreferenceConfigQueryUtil.getDefaultWorkflowParentEntityId();
        }
        return PreferenceConfigQueryUtil.getDefaultParentEntityId();
    }
    
    /**
     * 通过配置项（数据字典）的全编码查询配置项（数据字典）所属的模块Id
     * 
     * @param cfgFullCode 配置项的全编码
     * @return 配置项VO
     */
    @RemoteMethod
    public ConfigItemDTO getModulIdByCfgFullCode(String cfgFullCode) {
        ConfigItemFacade configItemFacade = AppContext.getBean(ConfigItemFacade.class);
        ConfigItemDTO configItemDTO = configItemFacade.queryBaseConfigItemVOByFullcode(cfgFullCode);
        return configItemDTO;
    }
    
    /**
     * 对应实体是否有对应属性存在
     * 
     * @param entityVO 实体
     * @param attributeName 属性名
     * @return true 存在 false 不存在
     */
    public boolean hasAttribute(EntityVO entityVO, String attributeName) {
        if (entityVO == null || StringUtils.isBlank(attributeName)) {
            return false;
        }
        LOG.debug("查询实体{}是否拥有属性{}", entityVO.getModelId(), attributeName);
        // 先查询自己的属性是否存在
        EntityAttributeVO entityAttributeVO;
        try {
            entityAttributeVO = entityVO
                .query("./attributes[engName='" + attributeName + "']", EntityAttributeVO.class);
        } catch (OperateException e) {
            LOG.debug("查询实体属性{}出错", attributeName, e);
            return false;
        }
        // 自身属性找到
        if (entityAttributeVO != null) {
            return true;
        }
        // 查询父实体
        if (entityVO.getParentEntity() == null) {
            entityVO.setParentEntity(loadEntity(entityVO.getParentEntityId(), null));
        }
        return hasAttribute(entityVO.getParentEntity(), attributeName);
        
    }
    
    /**
     * 根据包ID查询实体列表
     * 
     * @param pkgId 当前包ID packageId
     * 
     * @return 实体列表
     * @throws OperateException 异常
     */
    @RemoteMethod
    public List<EntityVO> queryEntityListByPkgId(String pkgId) throws OperateException {
        String expression = "/entity[packageId='" + pkgId + "']";
        List<EntityVO> lstEntityVOs = CacheOperator.queryList(expression, EntityVO.class);
        return lstEntityVOs;
    }
    
    /**
     * 获取未生成代码实体
     * 
     * @param entities 待过滤实体集合
     * 
     * @return 实体列表
     * @throws OperateException 异常
     */
    @RemoteMethod
    public List<EntityVO> filterUnGenerateCodeEntities(List<EntityVO> entities) throws OperateException {
        List<EntityVO> lstEntities = new ArrayList<EntityVO>();
        
        for (EntityVO entityVO : entities) {
            String filePath = FileUtils.getFilePath(PreferenceConfigQueryUtil.getCodePath(),
                PreferenceConfigQueryUtil.getJavaCodePath(), entityVO.getModelPackage() + ".model",
                entityVO.getEngName() + "VO.java");
            File srcFile = new File(filePath);
            
            String classPath = (entityVO.getModelPackage() + ".model.").replace(".", "/") + entityVO.getEngName()
                + "VO.class";
            URL url = Thread.currentThread().getContextClassLoader().getResource(classPath);
            if (url == null) {
                lstEntities.add(entityVO);
                continue;
            }
            
            if (!srcFile.exists()) {
                lstEntities.add(entityVO);
            } else {
                LOG.info("当前类" + entityVO.getEngName() + "已存在.");
            }
        }
        
        return lstEntities;
    }
    
    /**
     * 根据包ID查询实体列表
     * 
     * @param pkgId 当前包ID packageId
     * 
     * @return 实体列表
     * @throws OperateException 异常
     */
    @RemoteMethod
    public List<EntityVO> queryUnGenerCodeEntityListByPkgId(String pkgId) throws OperateException {
        List<EntityVO> lstEntityVOs = this.queryEntityListByPkgId(pkgId);
        return this.filterUnGenerateCodeEntities(lstEntityVOs);
    }
    
    /**
     * 获取实体所在项目
     * 
     * 
     * @return 项目目录
     */
    public static ProjectVO getProject() {
        ProjectVO objProject = new ProjectVO();
        objProject.setSrcDir(PreferenceConfigQueryUtil.getJavaCodePath());
        objProject.setSrcResourceDir(PreferenceConfigQueryUtil.getResourceFilePath());
        objProject.setWebDir(PreferenceConfigQueryUtil.getPageFilePath());
        return objProject;
    }
    
    /**
     * 根据当前实体ID，查询当前实体关联的实体集合
     * 
     * @param entityVO 当前实体
     * 
     * @return 实体列表
     * @throws OperateException 异常
     */
    @RemoteMethod
    public List<EntityVO> queryEntityRelationVO(EntityVO entityVO) throws OperateException {
        List<EntityRelationshipVO> lstRelation = entityVO.getLstRelation();
        List<EntityVO> lstRelationVOs = new ArrayList<EntityVO>();
        if (lstRelation == null) {
            return lstRelationVOs;
        }
        for (Iterator<EntityRelationshipVO> iterator = lstRelation.iterator(); iterator.hasNext();) {
            EntityRelationshipVO objRelation = iterator.next();
            String strAssoicateEntityId = objRelation.getAssociateEntityId();
            EntityVO assoicateEntity = null;
            EntityVO targetEntity = null;
            if (StringUtil.isNotBlank(strAssoicateEntityId)) {
                List<EntityVO> lstAssoicateEntityVO = CacheOperator.queryList("entity[modelId ='"
                    + strAssoicateEntityId + "']", EntityVO.class);
                if (lstAssoicateEntityVO != null) {
                    assoicateEntity = lstAssoicateEntityVO.get(0);
                    lstRelationVOs.add(assoicateEntity);
                }
            }
            String strTargetEntityId = objRelation.getTargetEntityId();
            if (StringUtil.isNotBlank(strTargetEntityId)) {
                List<EntityVO> lstTargetEntityVO = CacheOperator.queryList("entity[modelId ='" + strTargetEntityId
                    + "']", EntityVO.class);
                if (lstTargetEntityVO != null) {
                    targetEntity = lstTargetEntityVO.get(0);
                    lstRelationVOs.add(targetEntity);
                }
            }
        }
        // 关联当前实体的集合
        // List lstRelationEntities = this.queryRelationEntityById(entityVO.getModelId());
        return lstRelationVOs;
    }
    
    /**
     * 保存级联方法
     * 
     * @param cascadeMethodList 级联方法
     * @param entityId 实体id
     * @throws ValidateException ValidateException
     */
    public void saveCascadeMethodList(List<MethodVO> cascadeMethodList, String entityId) throws ValidateException {
        if (cascadeMethodList == null || cascadeMethodList.isEmpty()) {
            return;
        }
        EntityVO entityVO = loadEntity(entityId, null);
        if (entityVO == null) {
            return;
        }
        
        if (entityVO.getMethods() == null) {
            entityVO.setMethods(cascadeMethodList);
        } else {
            Iterator<MethodVO> entityIterator = entityVO.getMethods().iterator();
            while (entityIterator.hasNext()) {
                MethodVO methodVO = entityIterator.next();
                Iterator<MethodVO> iterator = cascadeMethodList.iterator();
                while (iterator.hasNext()) {
                    MethodVO cMethodVO = iterator.next();
                    if (cMethodVO.getEngName().equals(methodVO.getEngName())
                        && cMethodVO.getParameters().size() == methodVO.getParameters().size()) {
                        methodVO = cMethodVO;
                        entityIterator.remove();
                        break;
                    }
                }
            }
            entityVO.getMethods().addAll(cascadeMethodList);
        }
        saveEntity(entityVO);
    }
}
