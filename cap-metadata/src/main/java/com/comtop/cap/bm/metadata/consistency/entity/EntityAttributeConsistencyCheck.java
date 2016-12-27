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

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

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
import com.comtop.cap.bm.metadata.entity.model.DataTypeVO;
import com.comtop.cap.bm.metadata.entity.model.EntityAttributeVO;
import com.comtop.cap.bm.metadata.entity.model.EntityVO;

/**
 * 实体属性一致性校验
 * 
 * @author 许畅
 * @since JDK1.6
 * @version 2016年6月22日 许畅 新建
 */
public final class EntityAttributeConsistencyCheck extends
    DefaultFieldConsistencyCheck<List<EntityAttributeVO>, EntityVO> {
    
    /** 日志 */
    private final static Logger LOGGER = LoggerFactory.getLogger(EntityAttributeConsistencyCheck.class);
    
    /** 初始化实例 */
    private static final EntityAttributeConsistencyCheck attributeConsistencyCheck = new EntityAttributeConsistencyCheck();
    
    /**
     * 校验实体属性一致性
     *
     * @param entityAttributes
     *            实体属性集合
     * @param entity
     *            实体对象
     * @return 校验结果集
     */
    @Override
    public List<ConsistencyCheckResult> checkFieldDependOn(List<EntityAttributeVO> entityAttributes, EntityVO entity) {
        System.out.println("start check entity attribute...");
        List<ConsistencyCheckResult> results = new ArrayList<ConsistencyCheckResult>();
        
        for (EntityAttributeVO entityAttributeVO : entityAttributes) {
            List<FieldConsistencyCheckVO> lstField = ConsistencyCheckUtil
                .getFieldDependOnOtherObjectWithAnnotion(entityAttributeVO);
            results.addAll(ConsistencyCheckUtil.checkFieldDependOn(lstField, entity));
            
            this.validateAttributes(entityAttributeVO, entity, results);
        }
        
        return results;
    }
    
    /**
     * 校验实体属性关联的一致性
     * 
     * @param entityAttributeVO
     *            实体属性
     * @param entity
     *            实体
     * @param results 校验结果集
     */
    private void validateAttributes(EntityAttributeVO entityAttributeVO, EntityVO entity,
        List<ConsistencyCheckResult> results) {
        DataTypeVO dataTypeVO = entityAttributeVO.getAttributeType();
        String source = dataTypeVO.getSource();
        if ("otherEntityAttibute".equals(source)) {
            // 关联属性校验
            String relationEntityId = dataTypeVO.getValue().substring(0, dataTypeVO.getValue().lastIndexOf("."));
            
            Object relationEntity = CacheOperator.readById(relationEntityId);
            if (relationEntity == null) {
                addConsistencyCheckResult(entityAttributeVO, entity,
                    EntityConsistencyCheckType.ENTITY_ATTRIBUTE_RELATION_TYPE, relationEntityId, results);
            }
        } else if ("enumType".equals(source)) {
            // 关联枚举校验
            String enumValue = dataTypeVO.getValue();
            Class<?> cls = null;
            try {
                cls = Thread.currentThread().getContextClassLoader().loadClass(enumValue);
            } catch (ClassNotFoundException e) {
                LOGGER.debug(e.getMessage(), e);
            }
            
            if (cls == null) {
                addConsistencyCheckResult(entityAttributeVO, entity,
                    EntityConsistencyCheckType.ENTITY_ATTRIBUTE_ENUM_TYPE, enumValue, results);
            }
        }
    }
    
    /**
     * 添加关系一致性集合
     * 
     * @param entityAttributeVO
     *            实体关系
     * 
     * @param entity
     *            实体对象
     * @param consistencyCheckType
     *            实体一致性校验类型
     * @param relationEntityId
     *            关联实体id
     * @param results 校验结果集
     */
    private void addConsistencyCheckResult(EntityAttributeVO entityAttributeVO, EntityVO entity,
        int consistencyCheckType, String relationEntityId, List<ConsistencyCheckResult> results) {
        String expression = EntityDependOnMapping.getMessagemapping().get(consistencyCheckType);
        String message = EntityConsistencyUtil.parsingExpression(expression, entityAttributeVO.getEngName(),
            relationEntityId);
        
        ConsistencyCheckResult consistencyCheckResult = new ConsistencyCheckResult();
        consistencyCheckResult.setType(EntityDependOnMapping.getTypemapping().get(consistencyCheckType));
        consistencyCheckResult.setMessage(message);
        
        Map<String, String> attrMap = new HashMap<String, String>();
        attrMap.put(ConsistencyResultAttrName.ENTITY_MODEL_ID.getValue(), entity.getModelId());
        consistencyCheckResult.setAttrMap(attrMap);
        
        results.add(consistencyCheckResult);
    }
    
    /**
     * 获取当前实例
     * 
     * @return EntityAttributeConsistencyCheck
     */
    public static EntityAttributeConsistencyCheck getInstance() {
        return attributeConsistencyCheck;
    }
    
    /**
     * 校验实体属性被其他元数据所依赖
     * 
     * @param data 实体属性集合
     * @param root 实体对象
     * @return 校验结果集
     */
    @Override
    public List<ConsistencyCheckResult> checkBeingDependOn(List<EntityAttributeVO> data, EntityVO root) {
        List<ConsistencyCheckResult> lstRes = new ArrayList<ConsistencyCheckResult>();
        
        List<EntityVO> relationEntitys= EntityConsistencyUtil.getRelationEntity(root);
        
        // 校验实体属性被页面所依赖
        List<ConsistencyCheckResult> lstRes4Page = this.checkBeingDependOnEntityAttr4Page(data, root ,relationEntitys);
        if (lstRes4Page != null && lstRes4Page.size() > 0) {
            lstRes.addAll(lstRes4Page);
        }
        return lstRes;
    }
    
    /**
     * 校验实体属性被页面所依赖
     *
     * @param data 要删除的实体属性集合
     * @param root 实体对象
     * @param relationEntitys 关联实体
     * @return 返回校验结果
     */
    private List<ConsistencyCheckResult> checkBeingDependOnEntityAttr4Page(List<EntityAttributeVO> data, EntityVO root,
        List<EntityVO> relationEntitys) {
        List<ConsistencyCheckResult> lstRes = new ArrayList<ConsistencyCheckResult>();
        PageVOConsistencyCheck objCheck = ConsistencyCheckUtil.getConsistencyCheck(
            "com.comtop.cap.bm.metadata.consistency.PageVOConsistencyCheck", PageVOConsistencyCheck.class);
        if (objCheck != null) {
            lstRes = objCheck.checkBeingDependOnEntityAttr(data, root, relationEntitys);
        }
        return lstRes;
    }
}
