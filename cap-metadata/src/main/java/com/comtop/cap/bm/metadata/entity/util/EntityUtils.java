/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.entity.util;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.entity.model.AttributeCompareResult;
import com.comtop.cap.bm.metadata.entity.model.CompareIgnore;
import com.comtop.cap.bm.metadata.entity.model.DataTypeVO;
import com.comtop.cap.bm.metadata.entity.model.EntityAttributeVO;
import com.comtop.cap.bm.metadata.entity.model.EntityCompareResult;
import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cap.bm.metadata.entity.model.JavaDatatypeEnum;
import com.comtop.cap.bm.metadata.entity.model.ParameterVO;
import com.comtop.cap.bm.metadata.preferencesconfig.PreferenceConfigQueryUtil;
import com.comtop.cap.bm.metadata.sysmodel.model.CapPackageVO;
import com.comtop.cap.bm.metadata.sysmodel.utils.CapSystemModelUtil;
import com.comtop.cap.runtime.base.enumeration.EnumReflectProvider;
import com.comtop.cap.runtime.base.exception.CapRuntimeException;
import com.comtop.cip.common.util.builder.EqualsBuilder;
import com.comtop.cip.jodd.util.StringUtil;
import com.comtop.corm.resource.util.CollectionUtils;

/**
 * 实体工具类
 * <P>
 * 这个比较工具类主要关注实体中与数据库相关的属性，对于自身的属性并不关注。
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2014-4-25 李忠文
 */
public final class EntityUtils {
    
    /** 比较后复制源数据ID */
    public static final int ID_COPY_MODE_SRC = -1;
    
    /** 比较后不复制ID */
    public static final int ID_COPY_MODE_IGNORE = 0;
    
    /** 比较后复制目标数据ID */
    public static final int ID_COPY_MODE_TARGET = 1;
    
    /** java类型映射 */
    public static List<Map<String, String>> lstJavaTypeMapper;
    
    static {
        try {
            lstJavaTypeMapper = EnumReflectProvider.invoke("com.comtop.cap.bm.metadata.entity.model.JavaDatatypeEnum");
        } catch (ClassNotFoundException e) {
            // do nothing
        }
    }
    
    /**
     * 构造函数
     */
    private EntityUtils() {
        super();
    }
    
    /**
     * 实体比较
     * 
     * 
     * @param srcEntitys 源实体集合
     * @param targetEntitys 目标实体集合
     * @param idCopyMode ID复制方式
     * @return 比较结果
     */
    public static List<EntityCompareResult> compareEntity(final List<EntityVO> srcEntitys, final List<EntityVO> targetEntitys, int idCopyMode) {
        Map<String, EntityVO> objMapTarget = new HashMap<String, EntityVO>();
        if (targetEntitys != null) {
            for (EntityVO objEntity : targetEntitys) {
                objMapTarget.put(objEntity.getDbObjectName(), objEntity);
            }
        }
        List<EntityCompareResult> objResults = new ArrayList<EntityCompareResult>();
        for (EntityVO objEntity : srcEntitys) {
            String strTable = objEntity.getDbObjectName();
            EntityCompareResult objResult = compareEntity(objEntity, objMapTarget.get(strTable), idCopyMode);
            objResults.add(objResult);
        }
        return objResults;
    }
    
    /**
     * 实体比较
     * 
     * @param srcEntity 源实体
     * @param targetEntity 目标实体
     * @param idCopyMode ID复制方式
     * @return 比较结果
     */
    public static EntityCompareResult compareEntity(final EntityVO srcEntity, final EntityVO targetEntity, final int idCopyMode) {
        // 复制id，确保当数据存在差异时，能够进行更新
        String strId = null;
        switch (idCopyMode) {
            case ID_COPY_MODE_SRC:
                strId = srcEntity.getModelId();
                break;
            case ID_COPY_MODE_TARGET:
                if (null != targetEntity) {
                    strId = targetEntity.getModelId();
                }
                break;
            default:
                break;
        }
        EntityCompareResult objResult = new EntityCompareResult(strId);
        objResult.setSrcEntity(srcEntity);
        objResult.setTargetEntity(targetEntity);
        // 目标实体不存在
        if (null == targetEntity) {
            objResult.setResult(EntityCompareResult.ENTITY_NOT_EXISTS);
            return objResult;
        }
        // 实体描述不同
        if (srcEntity.getDescription() != null && !srcEntity.getDescription().equals(targetEntity.getDescription())) {
            objResult.setResult(EntityCompareResult.ENTITY_DESC_DIFF);
        }
        // 实体类型不同（查询实体和业务实体）
        if (!srcEntity.getEntityType().equals(targetEntity.getEntityType())) {
            objResult.setResult(EntityCompareResult.ENTITY_TYPE_DIFF);
        }
        // 获取目标实体的属性，并进行整理
        List<EntityAttributeVO> lstTargetAttr = targetEntity.getAttributes();
        Map<String, EntityAttributeVO> objMapTargetAttr = new HashMap<String, EntityAttributeVO>();
        for (EntityAttributeVO objAttr : lstTargetAttr) {
            if (StringUtil.isBlank(objAttr.getRelationId())) {
                objMapTargetAttr.put(objAttr.getDbFieldId(), objAttr);
            }
        }
        // 获取源实体属性，并进行比较
        List<EntityAttributeVO> lstSrcAttr = srcEntity.getAttributes();
        for (EntityAttributeVO objSrcAttr : lstSrcAttr) {
            if (null != objSrcAttr.getDbFieldId()) {
                AttributeCompareResult objRet = compareAttribute(objSrcAttr, objMapTargetAttr.get(objSrcAttr.getDbFieldId()), idCopyMode);
                objResult.addAtrrResult(objRet);
            }
        }
        // 删除字段
        deleteAttribute(objResult, lstTargetAttr);
        return objResult;
    }
    
    /**
     * 删除字段
     * 
     * @param result 比较结果
     * @param targetAttrs 目标实体属性
     */
    private static void deleteAttribute(EntityCompareResult result, List<EntityAttributeVO> targetAttrs) {
        List<AttributeCompareResult> lstAttrResults = result.getAttrResults();
        Map<String, AttributeCompareResult> objMap = new HashMap<String, AttributeCompareResult>();
        for (AttributeCompareResult objAttrResult : lstAttrResults) {
            String strKey = objAttrResult.getId();
            objMap.put(strKey, objAttrResult);
        }
        for (EntityAttributeVO objAttr : targetAttrs) {
            if (StringUtil.isNotBlank(objAttr.getRelationId()) || StringUtil.isBlank(objAttr.getDbFieldId())) {
                continue;
            }
            String strKey = objAttr.getDbFieldId();
            if (!objMap.containsKey(strKey)) {
                AttributeCompareResult objAttrResult = new AttributeCompareResult(strKey);
                objAttrResult.setTargetAttribute(objAttr);
                objAttrResult.setResult(AttributeCompareResult.ATTR_DEL);
                objMap.put(strKey, objAttrResult);
                result.addAtrrResult(objAttrResult);
            }
        }
    }
    
    /**
     * 实体属性比较
     * 
     * 
     * @param srcAttr 源属性
     * @param targetAttr 目标属性
     * @param idCopyMode ID复制方式
     * @return 比较结果
     */
    public static AttributeCompareResult compareAttribute(final EntityAttributeVO srcAttr, final EntityAttributeVO targetAttr, final int idCopyMode) {
        // 复制id，确保当数据存在差异时，能够进行更新
        String strId = null;
        switch (idCopyMode) {
            case ID_COPY_MODE_SRC:
                strId = srcAttr.getDbFieldId();// 表字段属性当做唯一
                break;
            case ID_COPY_MODE_TARGET:
                if (null != targetAttr) {
                    strId = targetAttr.getDbFieldId();
                }
                break;
            default:
                break;
        }
        AttributeCompareResult objResult = new AttributeCompareResult(strId);
        objResult.setSrcAttribute(srcAttr);
        objResult.setTargetAttribute(targetAttr);
        if (targetAttr == null) {
            objResult.setResult(AttributeCompareResult.ATTR_NOT_EXISTS);
            return objResult;
        }
        
        // 比较时忽略的属性
        List<String> lstExcludeField = getExcludeFields();
        
        boolean bEquals = EqualsBuilder.reflectionEquals(srcAttr, targetAttr, lstExcludeField);
        if (!srcAttr.getAttributeType().getType().equals(targetAttr.getAttributeType().getType())) {
            bEquals = false;
        }
        if (bEquals) {
            objResult.setResult(AttributeCompareResult.ATTR_EQUAL);
            return objResult;
        }
        lstExcludeField.add("description");
        bEquals = EqualsBuilder.reflectionEquals(srcAttr, targetAttr, lstExcludeField);
        if (bEquals) {
            objResult.setResult(AttributeCompareResult.ATTR_DESC_DIFF);
        } else {
            objResult.setResult(AttributeCompareResult.ATTR_DIFF);
        }
        return objResult;
    }
    
    /**
     * 取得实体属性VO中忽略比较的字段名称集合
     * 
     * @return 忽略比较的字段名称集合
     */
    private static List<String> getExcludeFields() {
        List<String> lstExcludeFields = new ArrayList<String>();
        Field[] fields = EntityAttributeVO.class.getDeclaredFields();
        for (Field field : fields) {
            if (null != field.getAnnotation(CompareIgnore.class)) {
                lstExcludeFields.add(field.getName());
            }
        }
        return lstExcludeFields;
    }
    
    /**
     * 处理反射获取的修饰符
     * 
     * @param str 反射获取的的修饰符字符串
     * @return 修饰符
     */
    public static String getModifiers(String str) {
        String result = "";
        if (str != null) {
            result = str.indexOf("public") != -1 ? "public" : (str.indexOf("protected") != -1 ? "protected" : (str.indexOf("private") != -1 ? "private" : ""));
        }
        return result;
    }
    
    /**
     * 根据类型名称获取标准类型名称
     * 
     * @param typeName 类型名称
     * @return 标准名
     */
    public static DataTypeVO getDataTypeVO(String typeName) {
        DataTypeVO dataTypeVO = new DataTypeVO();
        if (StringUtil.isBlank(typeName)) {
            return dataTypeVO;
        }
        if (CollectionUtils.isEmpty(lstJavaTypeMapper)) {
            throw new RuntimeException("无法获取反射的枚举类");
        }
        
        // 先检查是否在枚举类里面
        for (int i = 0; i < lstJavaTypeMapper.size(); i++) {
            Map<String, String> map = lstJavaTypeMapper.get(i);
            if (map.get("value").equals(typeName)) {
                dataTypeVO.setType(map.get("text"));
                dataTypeVO.setSource(map.get("name"));
                // TODO 设置value及泛型
                return dataTypeVO;
            }
        }
        // try to find entity
        if (typeName.indexOf("class ") != -1) {
            typeName = typeName.replaceFirst("class\\s", "");
            String modelId = findSpecifyEntity(typeName);
            if (StringUtil.isNotBlank(modelId)) {
                dataTypeVO.setSource("entity");
                dataTypeVO.setType("entity");
                dataTypeVO.setValue(modelId);
                return dataTypeVO;
            }
        }
        
        // 如果不属于以上两类，统一转换为 java.lang.Object
        dataTypeVO.setType(JavaDatatypeEnum.OBJECT_TYPE.getValue());
        dataTypeVO.setSource(JavaDatatypeEnum.OBJECT_TYPE.getSource());
        return dataTypeVO;
    }
    
    /**
     * 获取工程路径
     * 
     * @param entityVO 实体对象
     * @return 工程路径
     */
    public static String getProjectDir(EntityVO entityVO) {
        CapPackageVO capPackageVO = CapSystemModelUtil.queryCapPackageByEntity(entityVO);
        if (capPackageVO == null || StringUtil.isBlank(capPackageVO.getJavaCodePath())) {
            String codePath = PreferenceConfigQueryUtil.getCodePath();
            if (StringUtil.isEmpty(codePath)) {
                throw new CapRuntimeException("请在首选项中配置项目工程路径");
            }
            return codePath;
        }
        return capPackageVO.getJavaCodePath();
    }
    
    /**
     * 重置属性排序号
     * 
     * @param lstAttr 属性列表
     */
    public static void resetAttrbutesSortNo(List<EntityAttributeVO> lstAttr) {
        for (int i = 0; i < lstAttr.size(); i++) {
            EntityAttributeVO objAttr = lstAttr.get(i);
            objAttr.setSortNo(i + 1);
        }
    }
    
    /**
     * 
     * 通过类的全路径，寻找对应的entity
     * 
     * @param fullPackage 类的全路径
     * @return entity的modelId
     */
    private static String findSpecifyEntity(String fullPackage) {
        // com.comtop.user.model.UserVO
        Matcher matcher = Pattern.compile("((.+)[.])model([.]\\w+)VO").matcher(fullPackage);
        if (matcher.find()) {
            String modelId = matcher.group(1) + "entity" + matcher.group(3);
            int count;
            try {
                count = CacheOperator.queryCount(matcher.group(2) + "/entity[modelId='" + modelId + "']");
                // EntityVO objEntity = (EntityVO) CacheOperator.readById(modelId);
                return count > 0 ? modelId : null;
            } catch (Exception e) {
                throw new RuntimeException("录入已有实体时，查询实体元数据异常");
            }
        }
        return null;
    }
    
    /**
     * 
     * 获取方法参数列表
     * 
     * 
     * @param parameterTypes 方法类型数组
     * @param parameterNames 方法参数名称数组
     * @return 方法参数列表
     */
    public static List<ParameterVO> getParameters(Class<?>[] parameterTypes, String[] parameterNames) {
        List<ParameterVO> parameters = new ArrayList<ParameterVO>();
        if (null == parameterNames || parameterNames.length == 0) {
            return parameters;
        }
        for (int k = 0; k < parameterTypes.length; k++) {
            ParameterVO parameterVO = new ParameterVO();
            Class<?> objClas = parameterTypes[k];
            String strParamterName = parameterNames[k];
            parameterVO.setDataType(getParamterDataType(objClas.getName()));
            parameterVO.setEngName(strParamterName);
            parameterVO.setChName(strParamterName);
            parameterVO.setParameterId(String.valueOf(System.currentTimeMillis() + k * 1000));
            parameterVO.setSortNo(k);
            parameters.add(parameterVO);
        }
        return parameters;
    }
    
    /**
     * 
     * 获取来源
     * 
     * @param typeName 类型名称
     * @return 获取来源
     */
    private static DataTypeVO getParamterDataType(String typeName) {
        DataTypeVO dataTypeVO = new DataTypeVO();
        if (StringUtil.isBlank(typeName)) {
            return dataTypeVO;
        }
        if (CollectionUtils.isEmpty(lstJavaTypeMapper)) {
            throw new RuntimeException("无法获取反射的枚举类");
        }
        
        // 先检查是否在枚举类里面
        for (int i = 0; i < lstJavaTypeMapper.size(); i++) {
            Map<String, String> map = lstJavaTypeMapper.get(i);
            if (map.get("value").indexOf(typeName) != -1) {
                dataTypeVO.setType(map.get("text"));
                dataTypeVO.setSource(map.get("name"));
                // TODO 设置value及泛型
                return dataTypeVO;
            }
        }
        String modelId = findSpecifyEntity(typeName);
        if (StringUtil.isNotBlank(modelId)) {
            dataTypeVO.setSource("entity");
            dataTypeVO.setType("entity");
            dataTypeVO.setValue(modelId);
            return dataTypeVO;
        }
        
        // 如果不属于以上两类，统一转换为 java.lang.Object
        dataTypeVO.setType(JavaDatatypeEnum.OBJECT_TYPE.getValue());
        dataTypeVO.setSource(JavaDatatypeEnum.OBJECT_TYPE.getSource());
        return dataTypeVO;
    }
}
