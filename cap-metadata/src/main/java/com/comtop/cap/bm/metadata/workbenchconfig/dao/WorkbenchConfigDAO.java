/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.workbenchconfig.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.comtop.cap.bm.metadata.workbenchconfig.model.WorkbenchConfigVO;
import com.comtop.cap.bm.metadata.workbenchconfig.utils.WorkbenchConfigConstants;
import com.comtop.cap.runtime.base.dao.CapBaseCommonDAO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;

/**
 * 工作台待办配置DAO
 * 
 * @author 许畅
 * @since JDK1.6
 * @version 2016年2月24日 许畅 新建
 */
@PetiteBean
public class WorkbenchConfigDAO extends CapBaseCommonDAO<WorkbenchConfigVO> {

	/**
	 * 调用存储过程修改待办/已办路径
	 * 
	 * @param processId
	 *            流程ID
	 * @param processName
	 *            流程名称
	 * @param pathUrl
	 *            待办/已办地址
	 * @param pathType
	 *            地址类型 1.todo;2.done
	 */
	public void callProCapWbProcesscfg(String processId, String processName,
			String pathUrl, int pathType) {
		Map<String, Object> objParam = new HashMap<String, Object>();
		objParam.put("processId", processId);
		objParam.put("processName", processName);
		objParam.put("pathUrl", pathUrl);
		objParam.put("pathType", pathType);
		this.queryList(WorkbenchConfigConstants.CALL_WORKBENCH_CONFIG_ID,
				objParam);
	}

	/**
	 * 获取工作台配置列表数据
	 * 
	 * @param map
	 *            parameter
	 * @return map
	 */
	public Map<String, Object> getWorkbenchConfigListData(
			Map<String, Object> map) {
		Integer count = (Integer) this.selectOne(
				WorkbenchConfigConstants.QUERY_COUNT_ID, map);
		List<WorkbenchConfigVO> lstPage = this.queryList(
				WorkbenchConfigConstants.QUERY_LIST_ID, map);

		Map<String, Object> objQueryMap = new HashMap<String, Object>();
		objQueryMap.put("list", lstPage);
		objQueryMap.put("count", count);
		return objQueryMap;
	}

	/**
	 * 删除工作台配置数据
	 * 
	 * @param parameter
	 *            parameter
	 */
	public void deleteWorkbenchConfig(Map<String, Object> parameter) {

		this.delete(WorkbenchConfigConstants.DELETE_ID, parameter);
	}
}
