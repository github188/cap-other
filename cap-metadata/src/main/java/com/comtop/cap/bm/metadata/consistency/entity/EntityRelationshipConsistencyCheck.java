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
import com.comtop.cap.bm.metadata.consistency.entity.model.EntityDependOnMapping;
import com.comtop.cap.bm.metadata.consistency.entity.util.EntityConsistencyCheckType;
import com.comtop.cap.bm.metadata.consistency.entity.util.EntityConsistencyUtil;
import com.comtop.cap.bm.metadata.entity.model.EntityRelationshipVO;
import com.comtop.cap.bm.metadata.entity.model.EntityVO;

/**
 * 实体关系一致性校验
 * 
 * @author 许畅
 * @since JDK1.6
 * @version 2016年6月22日 许畅 新建
 */
public final class EntityRelationshipConsistencyCheck extends
		DefaultFieldConsistencyCheck<List<EntityRelationshipVO>, EntityVO> {

	/**
	 * 校验实体关系中的属性一致性
	 *
	 * @param entityRelationships
	 *            实体关系集合
	 * @param entity
	 *            实体对象
	 * @return 校验结果集合
	 */
	@Override
	public List<ConsistencyCheckResult> checkFieldDependOn(
			List<EntityRelationshipVO> entityRelationships, EntityVO entity) {
		System.out.println("start check entity relationship...");

		List<ConsistencyCheckResult> results = new ArrayList<ConsistencyCheckResult>();
		
		for (EntityRelationshipVO entityRelationship : entityRelationships) {
			List<FieldConsistencyCheckVO> lstField = ConsistencyCheckUtil.getFieldDependOnOtherObjectWithAnnotion(entityRelationship);
			results.addAll(ConsistencyCheckUtil.checkFieldDependOn(lstField,entity));

			this.validateRelationShip(entityRelationship, entity ,results);
		}

		return results;
	}

	/**
	 * 校验实体关系一致性
	 * 
	 * @param entityRelationship
	 *            实体关系
	 * @param entity
	 *            实体对象
	 * @param results xx
	 */
	private void validateRelationShip(EntityRelationshipVO entityRelationship,
			EntityVO entity,List<ConsistencyCheckResult> results) {
		//
		String relationEntityId = entityRelationship.getTargetEntityId();
		Object relationEntity = CacheOperator.readById(relationEntityId);

		if (relationEntity == null) {
			this.addConsistencyCheckResult(entityRelationship, entity,
					EntityConsistencyCheckType.ENTITY_RELATIONSHIP_TYPE,
					relationEntityId,results);
		}

	}

	/**
	 * 添加关系一致性集合
	 * 
	 * @param entityRelationship
	 *            实体关系
	 * @param entity
	 *            实体对象
	 * @param consistencyCheckType
	 *            实体一致性校验类型
	 * @param relationEntityId
	 *            关联实体id
	 * @param results xx
	 */
	private void addConsistencyCheckResult(
			EntityRelationshipVO entityRelationship, EntityVO entity,
			int consistencyCheckType, String relationEntityId,List<ConsistencyCheckResult> results) {
		
		String expression = EntityDependOnMapping.getMessagemapping().get(consistencyCheckType);
		String message = EntityConsistencyUtil.parsingExpression(expression,  entityRelationship.getEngName(), relationEntityId);
		
		ConsistencyCheckResult consistencyCheckResult = new ConsistencyCheckResult();
		consistencyCheckResult.setType(EntityDependOnMapping.getTypemapping().get(consistencyCheckType));
		consistencyCheckResult.setMessage(message);
		
		Map<String,String> attrMap = new HashMap<String,String>();
	    attrMap.put(ConsistencyResultAttrName.ENTITY_MODEL_ID.getValue(), entity.getModelId());
		consistencyCheckResult.setAttrMap(attrMap);
		
		results.add(consistencyCheckResult);
	}

}
