/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.workbenchconfig.facade;

import java.util.Map;

import com.comtop.cap.bm.metadata.workbenchconfig.appservice.WorkbenchConfigAppService;
import com.comtop.cap.bm.metadata.workbenchconfig.model.WorkbenchConfigVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 工作台待办配置业务实现类
 * 
 * @author 许畅
 * @since JDK1.6
 * @version 2016年2月24日 许畅 新建
 */
@PetiteBean
public class WorkbenchConfigFacadeImpl implements IWorkbenchConfigFacade {

	/** 注入workbenchConfigAppService **/
	@PetiteInject
	protected WorkbenchConfigAppService workbenchConfigAppService;

	/**
	 * 调用存储过程插入待办流程
	 *
	 * @param page
	 *            PageVO
	 * @return str
	 */
	@Override
	public String save(WorkbenchConfigVO page) {

		return workbenchConfigAppService.save(page);
	}

	/**
	 * 删除该待办流程
	 *
	 * @param parameter
	 *            parameter
	 */
	@Override
	public void delete(Map<String, Object> parameter) {

		if (parameter != null && parameter.containsKey("processIdList"))
			workbenchConfigAppService.delete(parameter);
		else
			throw new RuntimeException("关联流程id不能为空!");
	}

	/**
	 * 获取列表数据
	 *
	 * @param map
	 *            map
	 * @return map
	 */
	@Override
	public Map<String, Object> getWorkbenchConfigListData(
			Map<String, Object> map) {
		if (map != null && map.containsKey("processIdList"))
			return workbenchConfigAppService.getListData(map);

		return null;
	}

}
