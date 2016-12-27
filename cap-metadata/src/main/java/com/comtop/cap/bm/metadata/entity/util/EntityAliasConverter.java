/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.entity.util;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cip.jodd.util.StringUtil;
import com.comtop.corm.resource.util.CollectionUtils;

/**
 * 实体别名转换器
 * 
 * @author 许畅
 * @since JDK1.7
 * @version 2016年12月21日 许畅 新建
 */
public final class EntityAliasConverter {

	/** 日志 */
	private static final Logger LOGGER = LoggerFactory
			.getLogger(EntityAliasConverter.class);

	/**
	 * 构造方法
	 */
	private EntityAliasConverter() {
		super();
	}

	/**
	 * 转换为唯一别名
	 * 
	 * @param engName
	 *            当前实体名
	 * @param modelId
	 *            当前实体modelId
	 * @return 转换为唯一别名
	 */
	public static String toUniqueAlias(String engName, String modelId) {
		List<EntityVO> list = null;
		try {
			String expression = "entity[@engName='" + engName
					+ "' and @modelId !='" + modelId + "']";
			list = CacheOperator.queryList(expression, EntityVO.class);
		} catch (OperateException e) {
			LOGGER.error(e.getMessage(), e);
		}
		if (list == null || CollectionUtils.isEmpty(list)) {
			return StringUtil.uncapitalize(engName);
		}

		String entityAlias = StringUtil.uncapitalize(engName
				+ (list.size() + 1));
		if (!checkUniqueAlias(entityAlias, list)) {
			entityAlias = StringUtil.uncapitalize(engName + "-"
					+ (list.size() + 1));
		}
		return entityAlias;
	}

	/**
	 * 校验别名是否相同
	 * 
	 * @param aliasName
	 *            实体别名
	 * @param list
	 *            实体集合
	 * @return boolean
	 */
	public static boolean checkUniqueAlias(String aliasName, List<EntityVO> list) {
		for (EntityVO entity : list) {
			if (entity.getAliasName().equals(aliasName))
				return false;
		}
		return true;
	}

}
