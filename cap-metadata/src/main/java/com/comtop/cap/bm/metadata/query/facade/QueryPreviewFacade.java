/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.query.facade;

import java.lang.reflect.Method;
import java.net.URL;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.base.facade.CapBmBaseFacade;
import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cap.bm.metadata.query.model.QueryPreview;
import com.comtop.cap.runtime.base.dao.CapBaseCommonDAO;
import com.comtop.cap.runtime.base.model.CapBaseVO;
import com.comtop.cap.runtime.base.util.CapRuntimeUtils;
import com.comtop.cap.runtime.base.util.MyBatisSqlHelper;
import com.comtop.cap.runtime.base.util.SystemHelper;
import com.comtop.cap.runtime.base.util.WorkflowHelper;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.util.StringUtil;
import com.comtop.cip.json.JSONObject;
import com.comtop.corm.session.SqlSession;
import com.comtop.top.core.jodd.AppContext;
import com.comtop.top.core.util.DBUtil;
import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;

/**
 * SQL预览Facade类
 * 
 * @author 许畅
 * @since JDK1.6
 * @version 2016年6月13日 许畅 新建
 */
@DwrProxy
@PetiteBean
public class QueryPreviewFacade extends CapBmBaseFacade {

	/** 取得coreDAO实例 */
	@SuppressWarnings("rawtypes")
	private final CapBaseCommonDAO coreDAO = AppContext
			.getBean(CapBaseCommonDAO.class);

	/** 日志 */
	private final static Logger LOGGER = LoggerFactory
			.getLogger(QueryPreviewFacade.class);

	/**
	 * SQL预览
	 * 
	 * @param queryPreview
	 *            sql预览对象
	 * 
	 * @return sql预览对象
	 */
	@RemoteMethod
	public QueryPreview previewSQL(QueryPreview queryPreview) {

		Connection connection = coreDAO.getConnection();
		String fullNamespace = queryPreview.getNamespace() + "."
				+ queryPreview.getStatementId();

		Exception exception = null;
		try {
			SqlSession sqlSession = coreDAO.getFactory()
					.openSession(connection);
			Map<String, Object> param = new HashMap<String, Object>();

			EntityVO entity = (EntityVO) CacheOperator.readById(queryPreview.getModelId());  
			String processId = entity.getProcessId();

			// 自定义参数
			if (StringUtil.isNotEmpty(queryPreview.getParams())) {
				String voClassName = queryPreview.getNamespace() + "."
						+ entity.getEngName() + "VO";
				Class<?> voClass = CapBaseVO.class;
				try {
					voClass = Class.forName(voClassName);
				} catch (ClassNotFoundException e) {
					LOGGER.error("class not found:" + e.getMessage(), e);
				}

				CapBaseVO capBaseVO = (CapBaseVO) JSONObject.parseObject(
						queryPreview.getParams(), voClass);
				Map<String, Object> beanMap = CapRuntimeUtils
						.beanConvertToMap(capBaseVO);
				param.putAll(beanMap);
			}

			// 流程实体预览
			if (StringUtil.isNotEmpty(processId)) {
				param.put("transActor", SystemHelper.getUserId());
				param.put("processId", processId);
				if (queryPreview.getStatementId().indexOf("Todo") > -1
						|| queryPreview.getStatementId().indexOf("ToEntry") > -1) {
					param.put("transTableName",
							WorkflowHelper.readTaskTableName(processId, false));
				} else {
					param.put("transTableName",
							WorkflowHelper.readTaskTableName(processId, true));
				}

				List<String> nodes = WorkflowHelper.queryFirstNodeIds(
						processId, null);
				param.put("nodeId", nodes.get(0));
				param.put("firstNodeIds", nodes);
			}

			queryPreview.setSql(MyBatisSqlHelper.getSqlByNamespace(sqlSession,
					fullNamespace, param));

		} catch (Exception e) {
			LOGGER.error("can not find mybatis sql xml's statmentId:"
					+ fullNamespace + ",/n" + e.getMessage(), e);
			exception = e;
		} finally {
			if (connection != null)
				try {
					connection.close();
				} catch (SQLException e) {
					LOGGER.error("DB close exception:" + e.getMessage(), e);
				}
		}

		if (exception != null)
			throw new RuntimeException(exception);

		return queryPreview;
	}

	/**
	 * 是否能够SQL预览
	 * 
	 * @param packageName
	 *            包名
	 * @param xmlName
	 *            xml名称
	 * @param methodName
	 *            方法名称
	 * @param entityId
	 *            实体id
	 * @return 是否存在sql xml
	 */
	@RemoteMethod
	public String isCanPreview(String packageName, String xmlName,
			String methodName, String entityId) {
		URL url = QueryPreviewFacade.class.getClassLoader().getResource(
				packageName.replace(".", "/") + xmlName);
		EntityVO entityVO = (EntityVO) CacheOperator.readById(entityId);
		String facadeName = entityVO.getModelPackage() + ".facade."
				+ entityVO.getEngName() + "Facade";

		// 校验xml是否存在
		if (url == null) {
			return "必须生成sql脚本代码才能预览SQL.";
		}

		// 检查方法是否存在
		if (!isMethodExist(facadeName, methodName)) {
			return "当前方法后台不存在,请先生成代码后才能预览SQL";
		}

		return "SUCCESS";
	}

	/**
	 * 执行SQL
	 * 
	 * @param sql
	 *            SQL内容
	 * @return 查询结果集
	 */
	@RemoteMethod
	public Map<String, Object> sqlExecute(String sql) {
		List<Map<String, Object>> datas = new ArrayList<Map<String, Object>>();// 数据集合
		List<String> columns = new ArrayList<String>();// 列名集合
		Map<String, Object> rst = new HashMap<String, Object>();
		Connection objConnect = null;
		Statement objStmt = null;
		ResultSet result = null;
		SQLException sqlException = null;
		try {
			objConnect = coreDAO.getConnection();
			if (objConnect != null)
				objStmt = objConnect.createStatement();

			if (objStmt != null) {
				result = objStmt.executeQuery(sql);
				ResultSetMetaData metadata = result.getMetaData();
				int columnCount = metadata.getColumnCount();
				for (int i = 1; i <= columnCount; i++) {
					columns.add(metadata.getColumnName(i));
				}

				while (result.next()) {
					Map<String, Object> data = new HashMap<String, Object>();
					for (String column : columns) {
						data.put(column, result.getObject(column));
					}
					datas.add(data);
				}

				rst.put("datas", datas);
				rst.put("columns", columns);
			}
		} catch (SQLException e) {
			LOGGER.error("执行SQL失败:" + e.getMessage(), e);
			sqlException = e;
		} finally {
			DBUtil.closeConnection(objConnect, objStmt, result);
		}

		if (sqlException != null)
			throw new RuntimeException(sqlException);

		return rst;
	}

	/**
	 * 方法是否存在
	 * 
	 * @param facadeName
	 *            xx
	 * @param methodName
	 *            xx
	 * @return xx
	 */
	private boolean isMethodExist(String facadeName, String methodName) {
		try {
			Class<?> cls = Class.forName(facadeName);
			Method[] methods = cls.getMethods();

			for (Method method : methods) {
				if (method.getName().equals(methodName)) {
					return true;
				}
			}
		} catch (ClassNotFoundException e) {
			LOGGER.error("can not find " + facadeName + e.getMessage(), e);
		}
		return false;
	}

}
