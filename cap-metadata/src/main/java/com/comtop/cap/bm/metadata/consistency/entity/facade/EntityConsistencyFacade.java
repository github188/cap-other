/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.consistency.entity.facade;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.comtop.bpms.client.ClientFactory;
import com.comtop.bpms.common.AbstractBpmsException;
import com.comtop.bpms.common.model.ProcessInfo;
import com.comtop.cap.bm.metadata.base.facade.CapBmBaseFacade;
import com.comtop.cap.bm.metadata.consistency.entity.appservice.EntityConsistencyAppService;
import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cap.runtime.base.util.BeanContextUtil;
import com.comtop.cip.jodd.util.StringUtil;

/**
 * 实体一致性校验facade
 * 
 * @author 许畅
 * @since JDK1.6
 * @version 2016年6月28日 许畅 新建
 */
@Service
public class EntityConsistencyFacade extends CapBmBaseFacade {

	/** 日志 */
	private final static Logger LOGGER = LoggerFactory.getLogger(EntityConsistencyFacade.class);

	/** 注入AppService **/
	protected EntityConsistencyAppService entityConsistencyAppService = BeanContextUtil
			.getBean(EntityConsistencyAppService.class);

	/**
	 * 校验当前表是否存在
	 * 
	 * @param entity
	 *            实体对象
	 * @return 是否存在表
	 */
	public boolean validateIsExistTable(EntityVO entity) {
		Integer tables = entityConsistencyAppService.validateIsExistTable(entity);

		return tables == null ? false : true;
	}

	/**
	 * 校验当前流程是否存在
	 * 
	 * @param entity
	 *            实体对象
	 * @return 当前流程是否存在
	 */
	public boolean validateProcessEnable(EntityVO entity) {
		if (StringUtil.isEmpty(entity.getProcessId()))
			return true;

		ProcessInfo processInfo = null;

		try {
			processInfo = ClientFactory.getDefinitionQueryService()
					.readLastProcessInfoById(entity.getProcessId());
		} catch (AbstractBpmsException e) {
			LOGGER.error(e.getMessage(), e);
		}

		return processInfo == null ? false : true;
	}

}
