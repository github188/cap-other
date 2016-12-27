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

import com.comtop.cap.bm.metadata.base.consistency.DefaultConsistencyCheck;
import com.comtop.cap.bm.metadata.base.consistency.model.ConsistencyCheckResult;
import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.consistency.ConsistencyResultAttrName;
import com.comtop.cap.bm.metadata.consistency.entity.facade.EntityConsistencyFacade;
import com.comtop.cap.bm.metadata.consistency.entity.model.EntityDependOnMapping;
import com.comtop.cap.bm.metadata.consistency.entity.util.EntityConsistencyCheckType;
import com.comtop.cap.bm.metadata.consistency.entity.util.EntityConsistencyUtil;
import com.comtop.cap.bm.metadata.entity.model.EntityAttributeVO;
import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cap.runtime.base.util.BeanContextUtil;
import com.comtop.cip.jodd.util.StringUtil;

/**
 * 实体对象一致性校验
 * 
 * @author 许畅
 * @since JDK1.6
 * @version 2016年6月22日 许畅 新建
 */
public final class EntityVOConsistencyCheck extends
		DefaultConsistencyCheck<EntityVO> {

	/** 实体校验facade */
	protected EntityConsistencyFacade entityConsistencyFacade = BeanContextUtil.getBean(EntityConsistencyFacade.class);

	/**
	 * 校验实体自身属性一致性
	 * 
	 * @param entity
	 *            实体对象
	 * @return 校验结果集合
	 */
	@Override
	public List<ConsistencyCheckResult> checkCurrentDependOn(EntityVO entity) {
		System.out.println("start check entity vo...");
		List<ConsistencyCheckResult> results = new ArrayList<ConsistencyCheckResult>();
		
		List<ConsistencyCheckResult> defaultResut = super.checkCurrentDependOn(entity);
		results.addAll(defaultResut);

		this.validateOneToOneAttribute(entity,results);
		
		System.out.println("end check entity ...");

		return results;
	}
	
	/**
	 * 校验当前实体属性在改变时被依赖的一致性
	 * 
	 * @param currentEntity
	 *            当前页面实体
	 * @return 校验结果集
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<ConsistencyCheckResult> checkBeingDependOnWhenChange(EntityVO currentEntity) {
		Object obj = CacheOperator.readById(currentEntity.getModelId());
		if (obj == null) {
			return new ArrayList<ConsistencyCheckResult>();
		}
		EntityVO oldEntity = (EntityVO) obj;
		
		List<EntityAttributeVO> oldAttributes = oldEntity.getAttributes();
		List<EntityAttributeVO> currentAttributes =currentEntity.getAttributes();
		List<EntityAttributeVO> changedAttributes = this.getChangedAttributes(oldAttributes, currentAttributes);
		@SuppressWarnings("rawtypes")
		IBeingDependOnValidate iBeingDependOnValidate = EntityBeingDependOnFactory.getBeingDependOnValidater();

		return iBeingDependOnValidate.beingDependOnAttribute(changedAttributes, oldEntity);
	}
	
	/**
	 * 获取修改过的属性
	 * 
	 * @param oldAttributes 之前属性
	 * @param currentAttributes 当前属性
	 * @return 修改过的属性
	 */
	private List<EntityAttributeVO> getChangedAttributes(List<EntityAttributeVO> oldAttributes,
			List<EntityAttributeVO> currentAttributes) {
		List<EntityAttributeVO> changedAttributes = new ArrayList<EntityAttributeVO>();
		for (EntityAttributeVO oldAttribute : oldAttributes) {
			if(!isAttributeExsit(currentAttributes, oldAttribute.getEngName())){
				changedAttributes.add(oldAttribute);
			}
		}
		
		return changedAttributes;
	}
	
	/**
	 * 校验属性是否存在
	 * 
	 * @param currentAttributes 当前属性
	 * @param oldAttributeValue 之前属性
	 * @return 属性是否存在
	 */
	private boolean isAttributeExsit(List<EntityAttributeVO> currentAttributes,String oldAttributeValue){
		for(EntityAttributeVO currentAttribute : currentAttributes){
			String currentAttributeValue = currentAttribute.getEngName();
			if(currentAttributeValue!=null && currentAttributeValue.equals(oldAttributeValue)){
				return true;
			}
		}
		return false;
	}

	/**
	 * 校验实体一对一属性的一致性校验
	 * 
	 * @param entity
	 *            实体对象
	 * @param results 校验结果集
	 */
	private void validateOneToOneAttribute(EntityVO entity,List<ConsistencyCheckResult> results) {
		
		//父实体是否存在校验
		String parentEntityId = entity.getParentEntityId();
		if (StringUtil.isNotEmpty(parentEntityId)) {
			Object relationEntity = CacheOperator.readById(parentEntityId);
			if (relationEntity == null) {
				this.addConsistencyCheckResult(entity,
						EntityConsistencyCheckType.ENTITY_PARENT_ENTITY_TYPE,
						parentEntityId,results);
			}
		}

		//工作流流程校验
		if (StringUtil.isNotEmpty(entity.getProcessId())) {
			//
			boolean isProcesEnable = entityConsistencyFacade.validateProcessEnable(entity);
			if(!isProcesEnable){
				this.addConsistencyCheckResult(entity, EntityConsistencyCheckType.ENTITY_PROCESS_TYPE, entity.getProcessId(),results);
			}
			
		}

		//数据库表校验
		if (StringUtil.isNotEmpty(entity.getDbObjectName())) {
			//
			boolean isExistTable = entityConsistencyFacade.validateIsExistTable(entity);
			if(!isExistTable){
				this.addConsistencyCheckResult(entity, EntityConsistencyCheckType.ENTITY_TABLE_TYPE, entity.getDbObjectName(),results);
			}

		}

	}

	/**
	 * 增加实体一对一一致性校验信息
	 * 
	 * @param entity
	 *            实体对象
	 * @param consistencyCheckType
	 *            实体校验类型
	 * @param relationEntityId
	 *            关联实体
	 * @param results 校验结果集
	 */
	private void addConsistencyCheckResult(EntityVO entity,
			int consistencyCheckType, String relationEntityId,List<ConsistencyCheckResult> results) {
		
		String expression = EntityDependOnMapping.getMessagemapping().get(consistencyCheckType);
		String message = EntityConsistencyUtil.parsingExpression(expression, entity.getEngName(), relationEntityId);
		
		ConsistencyCheckResult consistencyCheckResult = new ConsistencyCheckResult();
		consistencyCheckResult.setType(EntityDependOnMapping.getTypemapping().get(consistencyCheckType));
		consistencyCheckResult.setMessage(message);
		Map<String,String> attrMap = new HashMap<String,String>();
		attrMap.put(ConsistencyResultAttrName.ENTITY_MODEL_ID.getValue(), entity.getModelId());
		consistencyCheckResult.setAttrMap(attrMap);
		results.add(consistencyCheckResult);
	}

}
