/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.consistency.entity.validate;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.base.consistency.ConsistencyCheckUtil;
import com.comtop.cap.bm.metadata.base.consistency.model.ConsistencyCheckResult;
import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.consistency.ConsistencyResultAttrName;
import com.comtop.cap.bm.metadata.consistency.PageVOConsistencyCheck;
import com.comtop.cap.bm.metadata.consistency.entity.EntityAttributeConsistencyCheck;
import com.comtop.cap.bm.metadata.consistency.entity.EntityMethodConsistencyCheck;
import com.comtop.cap.bm.metadata.consistency.entity.IBeingDependOnValidate;
import com.comtop.cap.bm.metadata.consistency.entity.model.EntityAttrBeingDependOnMapping;
import com.comtop.cap.bm.metadata.consistency.entity.util.EntityConsistencyUtil;
import com.comtop.cap.bm.metadata.entity.model.EntityAttributeVO;
import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cap.bm.metadata.preferencesconfig.PreferenceConfigQueryUtil;

/**
 * 实体被依赖校验器
 * 
 * @author 许畅
 * @since JDK1.6
 * @version 2016年7月1日 许畅 新建
 */
public class EntityBeingDependOnValidater implements
		IBeingDependOnValidate<EntityVO, List<?>> {

	/** 日志 */
	private final static Logger LOGGER = LoggerFactory
			.getLogger(EntityBeingDependOnValidater.class);

	/** 是否需要开关 */
	private final boolean isNeedSwich;

	/**
	 * 构造方法
	 */
	private EntityBeingDependOnValidater() {
		super();
		this.isNeedSwich = true;
	}

	/**
	 * 构造方法
	 * 
	 * @param isNeedSwich
	 *            是否进行校验
	 */
	private EntityBeingDependOnValidater(boolean isNeedSwich) {
		super();
		this.isNeedSwich = isNeedSwich;
	}

	/** 初始化校验器 延迟加载 */
	private static EntityBeingDependOnValidater validater = null;

	/**
	 * @return 获取需要开关的实例
	 */
	public static EntityBeingDependOnValidater getInstance() {
		return getInstance(true);
	}

	/**
	 * @return 获取无需要开关的实例
	 */
	public static EntityBeingDependOnValidater getNoSwitchInstance() {
		return getInstance(false);
	}

	/**
	 * 获取实体被依赖校验器
	 * 
	 * @param isNeedSwich
	 *            是否需要开关
	 * 
	 * @return EntityBeingDependOnValidater
	 */
	private static EntityBeingDependOnValidater getInstance(boolean isNeedSwich) {
		if (validater == null) {
			syncInit(isNeedSwich);
		}
		return validater;
	}

	/**
	 * 同步创建实例
	 * 
	 * @param isNeedSwich
	 *            是否需要开关
	 */
	private static synchronized void syncInit(boolean isNeedSwich) {
		if (validater == null) {
			if (isNeedSwich)
				validater = new EntityBeingDependOnValidater();
			else
				validater = new EntityBeingDependOnValidater(isNeedSwich);
		}
	}

	/**
	 * 校验当前实体被其他元数据所依赖
	 *
	 * @param sourceData
	 *            来源实体
	 * @return 校验结果集
	 */
	@Override
	public List<ConsistencyCheckResult> beingDependOnRoot(EntityVO sourceData) {
		// 检查元数据一致性校验开关
		if (!isCheckConsistency()) {
			return new ArrayList<ConsistencyCheckResult>();
		}

		// 检查实体
		List<ConsistencyCheckResult> lstRes = EntityConsistencyUtil
				.checkEntityBeingDependOn(sourceData);
		// 检查页面
		List<ConsistencyCheckResult> lstRes4Page = this
				.beingDependOnEntity4Page(sourceData);
		if (lstRes4Page != null && lstRes4Page.size() > 0) {
			lstRes.addAll(lstRes4Page);
		}
		return lstRes;
	}

	/**
	 * 校验当前实体属性其他页面所依赖
	 *
	 * @param attributes
	 *            实体属性集合
	 * @param sourceData
	 *            来源实体
	 * @return 校验结果集
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Override
	public List<ConsistencyCheckResult> beingDependOnAttribute(List attributes,
			EntityVO sourceData) {
		// 检查元数据一致性校验开关
		if (!isCheckConsistency()) {
			return new ArrayList<ConsistencyCheckResult>();
		}

		// 校验页面
		List<ConsistencyCheckResult> result = EntityAttributeConsistencyCheck
				.getInstance().checkBeingDependOn(attributes, sourceData);
		// 校验实体
		for (Object obj : attributes) {
			EntityAttributeVO attribute = (EntityAttributeVO) obj;
			this.addConsistencyCheckResult(attribute, sourceData, result);
		}

		return result;
	}

	/**
	 * 校验当前实体方法被页面行为依赖
	 *
	 * @param methods
	 *            实体方法集合
	 * @param sourceData
	 *            来源实体
	 * @return 校验结果集
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Override
	public List<ConsistencyCheckResult> beingDependOnMethod(List methods,
			EntityVO sourceData) {
		// 检查元数据一致性校验开关
		if (!isCheckConsistency()) {
			return new ArrayList<ConsistencyCheckResult>();
		}
		// 校验页面
		return EntityMethodConsistencyCheck.getInstance().checkBeingDependOn(
				methods, sourceData);
	}

	/**
	 * 增加实体校验结果集
	 * 
	 * @param attribute
	 *            实体属性对象
	 * @param sourceData
	 *            来源实体
	 * @param result
	 *            校验结果集
	 */
	private void addConsistencyCheckResult(EntityAttributeVO attribute,
			EntityVO sourceData, List<ConsistencyCheckResult> result) {
		Map<Integer, String> expressionMapping = EntityAttrBeingDependOnMapping
				.getExpressionmapping();
		Map<Integer, String> messageMapping = EntityAttrBeingDependOnMapping
				.getMessagemapping();
		Map<Integer, String> typeMapping = EntityAttrBeingDependOnMapping
				.getTypemapping();

		Set<Integer> keys = expressionMapping.keySet();
		try {
			for (Integer key : keys) {
				String expression = EntityConsistencyUtil.parsingExpression(
						expressionMapping.get(key), attribute.getEngName(),sourceData.getModelId());

				List<EntityVO> lst = CacheOperator.queryList(expression,
						EntityVO.class);

				for (EntityVO targetEntity : lst) {
					String message = EntityConsistencyUtil.parsingExpression(
							messageMapping.get(key), attribute.getEngName(),
							targetEntity.getModelId());
					String type = typeMapping.get(key);
					ConsistencyCheckResult checkResult = new ConsistencyCheckResult();
					checkResult.setType(type);
					checkResult.setMessage(message);
					Map<String, String> attrMap = new HashMap<String, String>();
					attrMap.put(ConsistencyResultAttrName.ENTITY_MODEL_ID
							.getValue(), targetEntity.getModelId());
					checkResult.setAttrMap(attrMap);
					result.add(checkResult);
				}
			}

		} catch (OperateException e) {
			LOGGER.error(e.getMessage(), e);
		}
	}

	/**
	 * 校验当前实体被其他页面所依赖
	 *
	 * @param sourceData
	 *            来源实体
	 * @return 校验结果集
	 */
	private List<ConsistencyCheckResult> beingDependOnEntity4Page(
			EntityVO sourceData) {
		List<ConsistencyCheckResult> lstRes = new ArrayList<ConsistencyCheckResult>();
		PageVOConsistencyCheck objCheck = ConsistencyCheckUtil
				.getConsistencyCheck(
						"com.comtop.cap.bm.metadata.consistency.PageVOConsistencyCheck",
						PageVOConsistencyCheck.class);
		if (objCheck != null) {
			lstRes = objCheck.checkBeingDependOnEntity(sourceData);
		}
		return lstRes;
	}

	/**
	 * 是否元数据一致性校验
	 *
	 * @return 是否元数据一致性校验
	 */
	@Override
	public boolean isCheckConsistency() {
		// 判断是否需要开关
		if (isNeedSwich()) {
			return PreferenceConfigQueryUtil.isMetadataConsistency();
		}
		// 无需开关则开启校验
		return true;
	}

	/**
	 * @return the isNeedSwich
	 */
	public boolean isNeedSwich() {
		return isNeedSwich;
	}

}
