/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.consistency.entity;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.comtop.cap.bm.metadata.base.consistency.ConsistencyCheckUtil;
import com.comtop.cap.bm.metadata.base.consistency.DefaultFieldConsistencyCheck;
import com.comtop.cap.bm.metadata.base.consistency.model.ConsistencyCheckResult;
import com.comtop.cap.bm.metadata.base.consistency.model.FieldConsistencyCheckVO;
import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.consistency.ConsistencyResultAttrName;
import com.comtop.cap.bm.metadata.consistency.PageVOConsistencyCheck;
import com.comtop.cap.bm.metadata.consistency.entity.model.EntityDependOnMapping;
import com.comtop.cap.bm.metadata.consistency.entity.util.EntityConsistencyCheckType;
import com.comtop.cap.bm.metadata.consistency.entity.util.EntityConsistencyUtil;
import com.comtop.cap.bm.metadata.entity.model.CascadeAttributeVO;
import com.comtop.cap.bm.metadata.entity.model.DataTypeVO;
import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cap.bm.metadata.entity.model.MethodVO;
import com.comtop.cap.bm.metadata.entity.model.ParameterVO;

/**
 * 实体方法一致性校验
 * 
 * @author 许畅
 * @since JDK1.6
 * @version 2016年6月22日 许畅 新建
 */
public final class EntityMethodConsistencyCheck extends DefaultFieldConsistencyCheck<List<MethodVO>, EntityVO> {
    
    /** 初始化实例 */
    private static final EntityMethodConsistencyCheck methodConsistencyCheck = new EntityMethodConsistencyCheck();
    
    /**
     * 校验实体方法中的属性一致性
     *
     * @param methodVOs
     *            EntityMethodVO 实体方法
     * @param entity
     *            EntityVO
     * @return 一致性校验结果集
     */
    @Override
    public List<ConsistencyCheckResult> checkFieldDependOn(List<MethodVO> methodVOs, EntityVO entity) {
        System.out.println("start check entity method...");
        
        List<ConsistencyCheckResult> results = new ArrayList<ConsistencyCheckResult>();
        
        for (MethodVO methodVO : methodVOs) {
            List<FieldConsistencyCheckVO> lstField = ConsistencyCheckUtil
                .getFieldDependOnOtherObjectWithAnnotion(methodVO);
            results.addAll(ConsistencyCheckUtil.checkFieldDependOn(lstField, entity));
            
            this.validateReturnType(methodVO, entity, results);
            this.validateParameters(methodVO, entity, results);
            this.validateCascadeAttribute(methodVO, entity, results);
        }
        
        return results;
    }
    
    /**
     * 校验实体方法被依赖的属性
     * 
     * @param methods
     *            实体方法对象
     * @param entity
     *            实体对象
     * @return 一致性校验结果集
     */
    @Override
    public List<ConsistencyCheckResult> checkBeingDependOn(List<MethodVO> methods, EntityVO entity) {
        List<ConsistencyCheckResult> lstRes = new ArrayList<ConsistencyCheckResult>();
        PageVOConsistencyCheck objCheck = ConsistencyCheckUtil.getConsistencyCheck(
            "com.comtop.cap.bm.metadata.consistency.PageVOConsistencyCheck", PageVOConsistencyCheck.class);
        if (objCheck != null) {
            lstRes = objCheck.checkBeingDependOnMethod(methods, entity);
        }
        return lstRes;
    }
    
    /**
     * 校验实体返回值一致性
     * 
     * @param methodVO
     *            实体方法对象
     * 
     * @param entity
     *            实体VO
     * @param results xx
     */
    private void validateReturnType(MethodVO methodVO, EntityVO entity, List<ConsistencyCheckResult> results) {
        DataTypeVO dataType = methodVO.getReturnType();
        List<String> lst = dataType.readRelationEntityIds();
        if (lst != null && lst.size() > 0) {
            String relationEntityId = lst.get(0);
            Object relationEntity = CacheOperator.readById(relationEntityId);
            if (relationEntity == null) {
                this.addConsistencyCheckResult(methodVO, entity, EntityConsistencyCheckType.ENTITY_METHOD_RETURN_TYPE,
                    relationEntityId, results);
            }
        }
    }
    
    /**
     * 校验参数类型一致性
     * 
     * @param methodVO
     *            实体方法对象
     * @param entity
     *            实体对象
     * @param results xx
     */
    private void validateParameters(MethodVO methodVO, EntityVO entity, List<ConsistencyCheckResult> results) {
        List<ParameterVO> parameters = methodVO.getParameters();
        for (ParameterVO paramter : parameters) {
            List<String> lst = paramter.getDataType().readRelationEntityIds();
            if (lst != null && lst.size() > 0) {
                String relationEntityId = lst.get(0);
                Object relationEntity = CacheOperator.readById(relationEntityId);
                if (relationEntity == null) {
                    this.addConsistencyCheckResult(methodVO, entity,
                        EntityConsistencyCheckType.ENTITY_METHOD_PARAMETER_TYPE, relationEntityId, results);
                }
            }
        }
    }
    
    /**
     * 校验级联操作属性
     * 
     * @param methodVO
     *            实体方法对象
     * @param entity
     *            实体对象
     * @param results xx
     */
    private void validateCascadeAttribute(MethodVO methodVO, EntityVO entity, List<ConsistencyCheckResult> results) {
        List<CascadeAttributeVO> lstCascadeAttribute = methodVO.getLstCascadeAttribute();
        if (lstCascadeAttribute == null || lstCascadeAttribute.size() == 0)
            return;
        
        for (CascadeAttributeVO cascade : lstCascadeAttribute) {
            String entityRelationId = cascade.getGenerateCodeType();
            Object relationEntity = CacheOperator.readById(entityRelationId);
            if (relationEntity == null) {
                this.addConsistencyCheckResult(methodVO, entity, EntityConsistencyCheckType.ENTITY_METHOD_CASCADE_TYPE,
                    entityRelationId, results);
            }
        }
    }
    
    /**
     * 添加方法一致性集合
     * 
     * @param methodVO
     *            方法对象
     * @param entity
     *            实体对象
     * @param consistencyCheckType
     *            实体一致性校验类型
     * @param relationEntityId
     *            关联实体id
     * @param results 校验结果集
     */
    private void addConsistencyCheckResult(MethodVO methodVO, EntityVO entity, int consistencyCheckType,
        String relationEntityId, List<ConsistencyCheckResult> results) {
        String expression = EntityDependOnMapping.getMessagemapping().get(consistencyCheckType);
        String message = EntityConsistencyUtil.parsingExpression(expression, methodVO.getEngName(), relationEntityId);
        
        ConsistencyCheckResult consistencyCheckResult = new ConsistencyCheckResult();
        consistencyCheckResult.setType(EntityDependOnMapping.getTypemapping().get(consistencyCheckType));
        consistencyCheckResult.setMessage(message);
        
        Map<String,String> attrMap = new HashMap<String,String>();
		attrMap.put(ConsistencyResultAttrName.ENTITY_MODEL_ID.getValue(), entity.getModelId());
		consistencyCheckResult.setAttrMap(attrMap);
        results.add(consistencyCheckResult);
    }
    
    /**
     * 获取当前实例
     * 
     * @return EntityMethodConsistencyCheck
     */
    public static EntityMethodConsistencyCheck getInstance() {
        return methodConsistencyCheck;
    }
    
}
