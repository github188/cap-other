/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.workbenchconfig.appservice;

import java.util.Map;

import com.comtop.cap.bm.metadata.workbenchconfig.dao.WorkbenchConfigDAO;
import com.comtop.cap.bm.metadata.workbenchconfig.model.WorkbenchConfigVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cip.jodd.util.StringUtil;
import com.comtop.cap.runtime.base.appservice.BaseAppService;

/**
 * 工作台待办配置AppService
 * 
 * @author 许畅
 * @since JDK1.6
 * @version 2016年2月24日 许畅 新建
 */
@PetiteBean
public class WorkbenchConfigAppService extends BaseAppService {

	/** 注入DAO **/
	@PetiteInject
	protected WorkbenchConfigDAO workbenchConfigDAO;

	/**
	 * 插入待办/已办路径
	 * 
	 * @param page
	 *            工作台配置
	 * @return pageId
	 */
	public String save(WorkbenchConfigVO page) {
		if (StringUtil.isNotEmpty(page.getProcessId())) {
			// 待办
			workbenchConfigDAO.callProCapWbProcesscfg(page.getProcessId(),
					page.getProcessName(), page.getDone_url(), 2);
			// 已办
			workbenchConfigDAO.callProCapWbProcesscfg(page.getProcessId(),
					page.getProcessName(), page.getTodo_url(), 1);

		} else {
			throw new RuntimeException("工作台配置中流程ID不能为空!");
		}
		return page.getProcessId();
	}

	/**
	 * 删除待办流程
	 * 
	 * @param parameter
	 *            parameter
	 * 
	 */
	public void delete(Map<String, Object> parameter) {

		workbenchConfigDAO.deleteWorkbenchConfig(parameter);
	}

	/**
	 * 获取列表界面数据
	 * 
	 * @param map
	 *            流程id集合
	 * @return map
	 */
	public Map<String, Object> getListData(Map<String, Object> map) {

		return workbenchConfigDAO.getWorkbenchConfigListData(map);
	}
}
