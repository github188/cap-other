/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.database.analyze;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.database.datasource.CompareState;
import com.comtop.cap.bm.metadata.database.datasource.util.UuidGenerator;
import com.comtop.cap.bm.metadata.database.dbobject.model.ColumnVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.TableVO;
import com.comtop.cap.bm.metadata.database.dbobject.util.TableSysncEntityUtil;
import com.comtop.cap.bm.metadata.database.model.AnalyzeResult;
import com.comtop.cap.bm.metadata.database.model.CompareVO;
import com.comtop.cap.bm.metadata.database.util.CompareAnalyzerUtil;
import com.comtop.cap.bm.metadata.entity.model.EntityAttributeVO;
import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cip.jodd.util.StringUtil;
import com.comtop.corm.resource.util.CollectionUtils;

/**
 * 比较分析器
 * 
 * @author 许畅
 * @since JDK1.7
 * @version 2016年11月18日 许畅 新建
 */
public class CompareAnalyzer implements IAnalyzer {

	/** 目标对象 */
	private EntityVO targetObject;

	/** 对象比较上下文 */
	private final CompareContext context;

	/** 来源对象 */
	private final TableVO sourceObject;

	/** 参数 */
	private final Map<String, Object> param;

	/** LOGGER日志 */
	private static final Logger LOGGER = LoggerFactory
			.getLogger(CompareAnalyzer.class);

	/**
	 * 构造方法
	 * <p>
	 * 注入源对象和目标对象
	 * </p>
	 * 
	 * @param context
	 *            比较上下文
	 * 
	 */
	public CompareAnalyzer(CompareContext context) {
		this.context = context;
		this.sourceObject = (TableVO) context.getSourceObject();
		this.param = context.getParam();
	}

	/**
	 * 将源对象和目标对象进行分析比较
	 * 
	 * @return 深入分析
	 *
	 * @see com.comtop.cap.bm.metadata.database.analyze.IAnalyzer#deepAnalyze()
	 */
	@Override
	public CompareVO deepAnalyze() {
		TableVO objTable = getSourceObject();
		// 校验是否需要比较
		if (this.validateCompare()) {
			return new CompareVO();
		}
		// 获取表列信息
		Map<String, ColumnVO> columnMapping = this.initTableColumns();
		// 查询当前实体是否存在
		List<EntityVO> lstentitys = null;
		try {
			lstentitys = this.queryEntitys();
		} catch (OperateException e) {
			LOGGER.error("deepAnalyze查询失败:" + e.getMessage(), e);
		}
		if (CollectionUtils.isEmpty(lstentitys))
			return analyzeAddNew();
		if (lstentitys == null)
			return null;
		EntityVO objEntity = lstentitys.get(0);
		List<AnalyzeResult> lst = new ArrayList<AnalyzeResult>();
		Map<String, EntityAttributeVO> attrs = new HashMap<String, EntityAttributeVO>();

		List<EntityAttributeVO> attributes = objEntity.getAttributes();
		for (EntityAttributeVO attr : attributes) {
			if (StringUtil.isNotEmpty(attr.getDbFieldId())) {
				attrs.put(attr.getDbFieldId(), attr);
			}

			if (columnMapping.containsKey(attr.getDbFieldId())) {
				// 修改的属性
				String modifyInfo = getModifyInfo(columnMapping, attr);
				if (StringUtils.isNotEmpty(modifyInfo)) {
					TableSysncEntityUtil.setAttribute(
							columnMapping.get(attr.getDbFieldId()), attr);
					lst.add(getResultData(CompareState.MODIFY, attr, modifyInfo));
				}
			} else if (isRelationAttributs(attr)) {
				// 去除关系
			} else {
				// 删除的属性
				String expression = forDetails(CompareState.DELETE);
				String detail = CompareAnalyzerUtil
						.parsingExpression(expression, objEntity.getEngName(),
								attr.getDbFieldId());
				lst.add(getResultData(CompareState.DELETE, attr, detail));
			}
		}

		List<ColumnVO> columns = objTable.getColumns();
		for (int i = 0; i < columns.size(); i++) {
			if (!attrs.containsKey(columns.get(i).getEngName())) {
				EntityAttributeVO attr = TableSysncEntityUtil
						.columnConvertToAttribute(columns.get(i), i);
				String expression = forDetails(CompareState.ADD);
				String detail = CompareAnalyzerUtil
						.parsingExpression(expression, objEntity.getEngName(),
								attr.getDbFieldId());
				// 新增的属性
				lst.add(getResultData(CompareState.ADD, attr, detail));
			}
		}

		return this.createResult(objEntity, objTable, lst, false);
	}

	/**
	 * @param columnMapping
	 *            列信息
	 * @param attr
	 *            实体属性
	 * @return 差异信息
	 */
	private String getModifyInfo(Map<String, ColumnVO> columnMapping,
			EntityAttributeVO attr) {
		return TableSysncEntityUtil.compareColumnAndAttribute(
				columnMapping.get(attr.getDbFieldId()), attr);
	}

	/**
	 * @param state
	 *            比较状态
	 * @param attr
	 *            实体属性
	 * @param detail
	 *            详细信息
	 * @return data
	 */
	private AnalyzeResult getResultData(CompareState state,
			EntityAttributeVO attr, String detail) {
		AnalyzeResult result = new AnalyzeResult();
		result.setState(state.getValue());
		result.setEngName(attr.getDbFieldId());
		result.setChName(attr.getChName());
		result.setDetail(detail);
		result.setAttribute(attr);
		result.setId(UuidGenerator.generateUpperUUID());
		return result;
	}

	/**
	 * @param attr
	 *            实体属性
	 * @return 是否关系属性
	 */
	private boolean isRelationAttributs(EntityAttributeVO attr) {
		return StringUtils.isNotEmpty(attr.getRelationId());
	}

	/**
	 * 查询实体
	 * 
	 * @return 查询实体
	 * @throws OperateException
	 *             OperateException
	 */
	private List<EntityVO> queryEntitys() throws OperateException {
		TableVO table = getSourceObject();
		String expression = table.getModelPackage() + "/entity[@dbObjectId='"
				+ table.getModelId() + "']";
		List<EntityVO> entitys = CacheOperator.queryList(expression,
				EntityVO.class);
		return entitys;
	}

	/**
	 * 初始化列信息
	 * 
	 * @return 列映射信息
	 */
	private Map<String, ColumnVO> initTableColumns() {
		Map<String, ColumnVO> columnMapping = new HashMap<String, ColumnVO>();

		List<ColumnVO> columns = getSourceObject().getColumns();
		for (ColumnVO column : columns) {
			columnMapping.put(column.getEngName(), column);
		}
		return columnMapping;
	}

	/**
	 * 分析新增变化
	 *
	 * @return 分析新增信息
	 *
	 * @see com.comtop.cap.bm.metadata.database.analyze.IAnalyzer#analyzeAddNew()
	 */
	@Override
	public CompareVO analyzeAddNew() {
		String packageId = getParam().containsKey("packageId") ? (String) getParam()
				.get("packageId") : null;
		EntityVO objEntity = TableSysncEntityUtil.tableConvertToEntity(
				getSourceObject(), packageId);
		List<EntityAttributeVO> lstAttributes = objEntity.getAttributes();
		List<AnalyzeResult> lst = new ArrayList<AnalyzeResult>();
		for (EntityAttributeVO attribute : lstAttributes) {
			String expression = forDetails(CompareState.ADD);
			String detail = CompareAnalyzerUtil.parsingExpression(expression,
					objEntity.getEngName(), attribute.getDbFieldId());
			lst.add(getResultData(CompareState.ADD, attribute, detail));
		}
		return this.createResult(objEntity, getSourceObject(), lst, true);
	}

	/**
	 * @param objEntity
	 *            实体
	 * @param table
	 *            表对象
	 * @param lst
	 *            属性集合
	 * @param isNew
	 *            是否新建
	 * @return result
	 */
	private CompareVO createResult(EntityVO objEntity, TableVO table,
			List<AnalyzeResult> lst, boolean isNew) {
		// 设置目标对象
		setTargetObject(objEntity);
		CompareVO compareVO = new CompareVO();
		compareVO.setSrc(table);
		compareVO.setTarget(objEntity);
		compareVO.setAnalyzeResults(lst);
		compareVO.setNew(isNew);
		return compareVO;
	}

	/**
	 *
	 * @return 获取分析详情
	 *
	 * @see com.comtop.cap.bm.metadata.database.analyze.IAnalyzer#forDetails(CompareState
	 *      state)
	 */
	@Override
	public String forDetails(CompareState state) {
		if (CompareState.ADD.getValue().equals(state.getValue())) {
			return "在实体[{0}]中新增属性{1}.";
		} else if (CompareState.MODIFY.getValue().equals(state.getValue())) {
			return "对实体[{0}]的属性{1}进行修改.";
		} else if (CompareState.DELETE.getValue().equals(state.getValue())) {
			return "对实体[{0}]的属性{1}进行删除.";
		}
		return null;
	}

	@Override
	public boolean validateCompare() {
		return !sourceObject.needCompare();
	}

	/**
	 * @return the sourceObject
	 */
	public TableVO getSourceObject() {
		return sourceObject;
	}

	/**
	 * @return the targetObject
	 */
	public EntityVO getTargetObject() {
		return targetObject;
	}

	/**
	 * @param targetObject
	 *            the targetObject to set
	 */
	public void setTargetObject(EntityVO targetObject) {
		this.targetObject = targetObject;
		this.context.getContext().put("TARGET", targetObject);
	}

	/**
	 * @return the context
	 */
	public CompareContext getContext() {
		return context;
	}

	/**
	 * @return the param
	 */
	public Map<String, Object> getParam() {
		return param;
	}

}
