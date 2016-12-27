/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.database.dbobject.util;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.beanutils.BeanUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.database.datasource.util.UuidGenerator;
import com.comtop.cap.bm.metadata.database.dbobject.model.ColumnVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.IndexColumnVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.TableIndexVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.TableVO;
import com.comtop.cap.bm.metadata.entity.facade.EntityFacade;
import com.comtop.cap.bm.metadata.entity.model.AccessLevel;
import com.comtop.cap.bm.metadata.entity.model.AttributeSourceType;
import com.comtop.cap.bm.metadata.entity.model.ClassPattern;
import com.comtop.cap.bm.metadata.entity.model.DataTypeVO;
import com.comtop.cap.bm.metadata.entity.model.EntityAttributeVO;
import com.comtop.cap.bm.metadata.entity.model.EntitySource;
import com.comtop.cap.bm.metadata.entity.model.EntityType;
import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cap.bm.metadata.entity.model.OracleFieldType;
import com.comtop.cap.bm.metadata.entity.model.QueryRule;
import com.comtop.cap.bm.metadata.preferencesconfig.PreferenceConfigQueryUtil;
import com.comtop.cap.bm.metadata.utils.StringConvertor;
import com.comtop.cip.common.util.builder.EqualsBuilder;
import com.comtop.top.core.jodd.AppContext;
import com.comtop.top.core.util.StringUtil;

/**
 * 元数据表同步实体工具类
 * 
 * @author 许畅
 * @since JDK1.7
 * @version 2016年11月8日 许畅 新建
 */
public final class TableSysncEntityUtil {

	/**
	 * 构造方法
	 */
	private TableSysncEntityUtil() {
		super();
	}

	/** 日志记录 */
	private static final Logger LOGGER = LoggerFactory
			.getLogger(TableSysncEntityUtil.class);

	/** 字段描述 */
	private static final Map<String, String> fieldDescription = new LinkedHashMap<String, String>();

	/** 主键类型 */
	private static final String PK_TYPE_ORACLE = "VARCHAR2";

	/** 主键类型 */
	private static final String PK_TYPE_MYSQL = "VARCHAR";

	/** 主键英文名 */
	private static final String PK_ENG = "ID";

	/** 主键中文名 */
	private static final String PK_CH = "主键";

	static {
		fieldDescription.put("dataType", "属性类型");
		fieldDescription.put("chName", "中文名称");
		fieldDescription.put("length", "总长度");
		fieldDescription.put("precision", "精度");
		fieldDescription.put("description", "描述");
		fieldDescription.put("canBeNull", "允许为空");
		fieldDescription.put("engName", "对应字段");
		fieldDescription.put("defaultValue", "默认值");
	}

	/**
	 * 比较数据库元数据列和实体属性
	 * <p>
	 * 比较属性类型,中文名称,总长度,精度,描述,对应字段,允许为空
	 * </p>
	 * 
	 * @param column
	 *            列信息
	 * @param attr
	 *            实体属性
	 * 
	 * @return 是否存在差异
	 */
	public static String compareColumnAndAttribute(ColumnVO column,
			EntityAttributeVO attr) {
		Map<String, Object> left = new LinkedHashMap<String, Object>();// 列信息
		Map<String, Object> right = new LinkedHashMap<String, Object>();// 实体属性

		// 属性类型
		left.put("dataType", OracleFieldType.getAttributeDataType(
				column.getDataType(), column.getPrecision()));
		right.put("dataType", attr.getAttributeType().getType());
		// 中文名称
		left.put("chName", column.getChName());
		right.put("chName", attr.getChName());
		// 描述
		left.put("description", column.getDescription());
		right.put("description", attr.getDescription());
		// 总长度
		left.put("length", column.getLength());
		right.put("length", attr.getAttributeLength());
		// 精度
		left.put("precision", column.getPrecision());
		right.put("precision", Integer.parseInt(attr.getPrecision()));
		// 允许为空
		left.put("canBeNull", column.getCanBeNull());
		right.put("canBeNull", attr.isAllowNull());
		// 对应字段
		left.put("engName", column.getEngName());
		right.put("engName", attr.getDbFieldId());
		// 默认值
		left.put("defaultValue", column.getDefaultValue());
		right.put("defaultValue", attr.getDefaultValue());
		return compareMapValue(left, right);
	}

	/**
	 * 更新实体属性
	 * 
	 * @param column
	 *            列信息
	 * @param attr
	 *            实体属性
	 */
	public static void setAttribute(ColumnVO column, EntityAttributeVO attr) {
		attr.setDbFieldId(column.getEngName());
		attr.setChName(column.getChName());
		attr.setAttributeLength(column.getLength());
		attr.setPrecision(String.valueOf(column.getPrecision()));
		attr.setDescription(column.getDescription());
		attr.setAllowNull(column.getCanBeNull());
		attr.setDefaultValue(column.getDefaultValue());
		DataTypeVO dataType = new DataTypeVO();
		dataType.setSource("primitive");
		dataType.setType(OracleFieldType.getAttributeDataType(
				column.getDataType(), column.getPrecision()));
		dataType.setValue("");
		attr.setAttributeType(dataType);
	}

	/**
	 * 列转换为实体属性
	 * 
	 * @param objColumnVO
	 *            列信息
	 * @param iSort
	 *            序号
	 * 
	 * @return 实体属性
	 */
	public static EntityAttributeVO columnConvertToAttribute(
			ColumnVO objColumnVO, int iSort) {
		int iSortNo = iSort + 1;
		EntityAttributeVO objEntityAttributeVO = new EntityAttributeVO();
		objEntityAttributeVO.setAccessLevel(AccessLevel.PRIVATE_LEVEL
				.getValue());
		objEntityAttributeVO.setAllowNull(objColumnVO.getCanBeNull());
		objEntityAttributeVO.setPrimaryKey(objColumnVO.getIsPrimaryKEY());
		objEntityAttributeVO.setSortNo(iSortNo);
		objEntityAttributeVO.setQueryField(true); // 数据库字段，都可作为查询字段
		objEntityAttributeVO.setQueryMatchRule(String.valueOf(QueryRule.EQ));
		String strEngName = StringUtil
				.uncapitalize(StringConvertor.toCamelCase(
						objColumnVO.getEngName(),
						PreferenceConfigQueryUtil.getTableColumnPrefixIngore()));
		String strQueryExpr = getEntityFacadeInstance().genQueryExpression(
				QueryRule.EQ, objColumnVO.getCode(), strEngName);
		objEntityAttributeVO.setQueryExpr(strQueryExpr);
		objEntityAttributeVO.setChName(objColumnVO.getChName());

		objEntityAttributeVO.setEngName(strEngName);
		objEntityAttributeVO.setDescription(objColumnVO.getDescription());
		DataTypeVO objDataTypeVO = new DataTypeVO();

		objDataTypeVO.setSource(AttributeSourceType.PRIMITIVE.getValue());// 属性来源为基本类型
		objDataTypeVO.setType(OracleFieldType.getAttributeDataType(
				objColumnVO.getDataType(), objColumnVO.getPrecision()));// 需要根据数据库类型，转换为java类型
		objDataTypeVO.setValue(""); // 空的属性也需要添加，数据库同步时比较有问题
		objEntityAttributeVO.setAttributeType(objDataTypeVO);// 实体属性数据类型
		objEntityAttributeVO.setDbFieldId(objColumnVO.getCode());// 数据库对应的字段
		objEntityAttributeVO.setAttributeLength(objColumnVO.getLength());// 属性长度
		objEntityAttributeVO.setPrecision(String.valueOf(objColumnVO
				.getPrecision()));// 属性精度
		objEntityAttributeVO.setDefaultValue(objColumnVO.getDefaultValue());// 默认值
		return objEntityAttributeVO;
	}

	/**
	 * 表对象转实体对象
	 * 
	 * @param objTableVO
	 *            表对象
	 * @param packageId
	 *            包id
	 * @return 实体VO
	 */
	public static EntityVO tableConvertToEntity(TableVO objTableVO,
			String packageId) {
		EntityVO objEntityVO = new EntityVO();
		String strEngName = StringConvertor.toCamelCase(
				objTableVO.getEngName(),
				PreferenceConfigQueryUtil.getTablePrefixIngore());
		String aliasName = strEngName.substring(0, 1).toLowerCase()
				+ strEngName.substring(1);
		objEntityVO.setEngName(strEngName);
		objEntityVO.setAliasName(aliasName);
		objEntityVO.setChName(objTableVO.getChName());
		objEntityVO.setDescription(objTableVO.getDescription());
		objEntityVO.setDbObjectName(objTableVO.getCode());
		objEntityVO.setClassPattern(ClassPattern.COMMON.getValue());
		objEntityVO.setEntityType(EntityType.BIZ_ENTITY.getValue());
		objEntityVO.setEntitySource(EntitySource.TABLE_METADATA_IMPORT
				.getValue());
		Set<String> objAllColumn = new HashSet<String>();
		for (ColumnVO objColumnVO : objTableVO.getColumns()) {
			objAllColumn.add(objColumnVO.getCode());
		}
		objEntityVO.setParentEntityId(getEntityFacadeInstance()
				.getParentEntityId(objAllColumn));// 默认父实体id
		// 设置实体基本信息
		objEntityVO.setPackageId(packageId);
		objEntityVO.setModelPackage(objTableVO.getModelPackage());
		objEntityVO.setModelType("entity");
		objEntityVO.setModelName(objEntityVO.getEngName());
		String strModelId = objEntityVO.getModelPackage() + "."
				+ objEntityVO.getModelType() + "." + objEntityVO.getModelName();
		objEntityVO.setModelId(strModelId);
		objEntityVO.setDbObjectId(objTableVO.getModelId());
		List<EntityAttributeVO> attributes = new ArrayList<EntityAttributeVO>();
		for (int i = 0; i < objTableVO.getColumns().size(); i++) {
			attributes.add(columnConvertToAttribute(objTableVO.getColumns()
					.get(i), i));
		}
		objEntityVO.setAttributes(attributes);
		return objEntityVO;
	}

	/**
	 * 获取实体Facade
	 * 
	 * @return EntityFacade
	 */
	public static EntityFacade getEntityFacadeInstance() {
		return AppContext.getBean(EntityFacade.class);
	}

	/**
	 * 排序实体属性
	 * 
	 * @param lstAttributes
	 *            实体属性
	 */
	public static void sortEntityAttributes(
			List<EntityAttributeVO> lstAttributes) {
		for (int i = 0; i < lstAttributes.size(); i++) {
			EntityAttributeVO entityAttribute = lstAttributes.get(i);
			entityAttribute.setSortNo(i + 1);
		}
	}

	/**
	 * 自动创建主键列
	 * 
	 * @param tableCode
	 *            表名
	 * 
	 * @return ColumnVO 主键列
	 */
	public static ColumnVO autoCreatePrimarykeyColumn(String tableCode) {
		ColumnVO primarykey = new ColumnVO();
		primarykey.setCanBeNull(false);
		primarykey.setChName(PK_CH);
		primarykey.setCode(PK_ENG);
		primarykey.setDataType(PK_TYPE_ORACLE);
		primarykey.setDescription(PK_CH);
		primarykey.setEngName(PK_ENG);
		primarykey.setId(UuidGenerator.generateUpperUUID());
		primarykey.setIsForeignKey(false);
		primarykey.setIsPrimaryKEY(true);
		primarykey.setIsUnique(true);
		primarykey.setLength(36);
		primarykey.setPrecision(0);
		primarykey.setTableCode(tableCode);
		return primarykey;
	}

	/**
	 * 自动创建主键列
	 * 
	 * @param tableCode
	 *            表名
	 * 
	 * @return ColumnVO 主键列
	 */
	public static ColumnVO autoCreatePrimarykeyColumnMySQL(String tableCode) {
		ColumnVO primarykey = new ColumnVO();
		primarykey.setCanBeNull(false);
		primarykey.setChName(PK_CH);
		primarykey.setCode(PK_ENG);
		primarykey.setDataType(PK_TYPE_MYSQL);
		primarykey.setDescription(PK_CH);
		primarykey.setEngName(PK_ENG);
		primarykey.setId(UuidGenerator.generateUpperUUID());
		primarykey.setIsForeignKey(false);
		primarykey.setIsPrimaryKEY(true);
		primarykey.setIsUnique(true);
		primarykey.setLength(36);
		primarykey.setPrecision(0);
		primarykey.setTableCode(tableCode);
		return primarykey;
	}

	/**
	 * 反射比较对象是否相等
	 * 
	 * @param lhs
	 *            左对象
	 * @param rhs
	 *            右操作对象
	 * @return boolean
	 */
	public static boolean reflectionEquals(final Object lhs, final Object rhs) {
		return EqualsBuilder.reflectionEquals(lhs, rhs);
	}

	/**
	 * 设置Table元数据中主键为索引与数据库保持一致
	 * 
	 * @param objTableVO
	 *            tableVO
	 */
	public static void initPrimarykeyIndex(TableVO objTableVO) {
		if (isExsitPkIndex(objTableVO))
			return;

		// 将主键索引加入Index集合中
		List<ColumnVO> objColumns = objTableVO.getColumns();
		for (ColumnVO columnVO : objColumns) {
			if (columnVO.getIsPrimaryKEY()) {
				addPrimaryKeyIndex(objTableVO, columnVO);
				break;
			}
		}
	}
	
	/**
	 * 添加主键索引
	 * 
	 * @param objTableVO
	 *            表对象
	 * @param columnVO
	 *            列对象
	 */
	public static void addPrimaryKeyIndex(TableVO objTableVO, ColumnVO columnVO) {
		DBType dbType = DBTypeAdapter.getDBType();
		String pkIndexName = getIndexName(dbType, objTableVO, columnVO);
		TableIndexVO objTableIndexVO = new TableIndexVO();
		objTableIndexVO.setChName(pkIndexName);
		objTableIndexVO.setEngName(pkIndexName);
		objTableIndexVO.setDescription(pkIndexName);
		objTableIndexVO.setType(getIndexType(dbType));
		objTableIndexVO.setUnique(true);
		objTableIndexVO.setPrimary(true);
		List<IndexColumnVO> columns = new ArrayList<IndexColumnVO>();
		IndexColumnVO indexColumn = new IndexColumnVO();
		ColumnVO column = new ColumnVO();
		column.setEngName(columnVO.getCode());
		column.setCode(columnVO.getCode());
		column.setIsPrimaryKEY(true);
		indexColumn.setColumn(column);
		columns.add(indexColumn);
		objTableIndexVO.setColumns(columns);
		objTableVO.addIndex(objTableIndexVO);
	}

	/**
	 * mysql btree索引自带primary需特殊处理
	 * 
	 * @param dbType
	 *            数据库类型
	 * @param objTableVO
	 *            Table对象
	 * @param objTableIndexVO
	 *            索引对象
	 */
	public static void addColumnIndex(DBType dbType, TableVO objTableVO,
			TableIndexVO objTableIndexVO) {
		objTableVO.addIndex(objTableIndexVO);
		if (DBType.MYSQL.getValue().equals(dbType.getValue())) {
			try {
				TableIndexVO mysqlIndex = (TableIndexVO) BeanUtils
						.cloneBean(objTableIndexVO);
				mysqlIndex.setChName("PRIMARY");
				mysqlIndex.setEngName("PRIMARY");
				mysqlIndex.setDescription("PRIMARY");
				objTableVO.addIndex(mysqlIndex);
			} catch (IllegalAccessException e) {
				LOGGER.error("copy index bean failed:" + e.getMessage(), e);
			} catch (InstantiationException e) {
				LOGGER.error("copy index bean failed:" + e.getMessage(), e);
			} catch (InvocationTargetException e) {
				LOGGER.error("copy index bean failed:" + e.getMessage(), e);
			} catch (NoSuchMethodException e) {
				LOGGER.error("copy index bean failed:" + e.getMessage(), e);
			}
		}
	}

	/**
	 * @param dbType
	 *            数据库类型
	 * @param objTableVO
	 *            表对象
	 * @param columnVO
	 *            列对象
	 * @return 索引名称
	 */
	private static String getIndexName(DBType dbType, TableVO objTableVO,
			ColumnVO columnVO) {
		if (DBType.ORACLE.getValue().equals(dbType.getValue())) {
			return "PK_" + objTableVO.getCode();
		}
		if (DBType.MYSQL.getValue().equals(dbType.getValue())) {
			return "PRIMARY";
		}
		return "PK_" + objTableVO.getCode();
	}

	/**
	 * @param dbType
	 *            数据库类型
	 * @return 索引类型
	 */
	private static String getIndexType(DBType dbType) {
		if (DBType.ORACLE.getValue().equals(dbType.getValue())) {
			return "1";
		}
		if (DBType.MYSQL.getValue().equals(dbType.getValue())) {
			return "3";// mysql btree索引
		}
		return "1";
	}

	/**
	 * @param objTableVO
	 *            tableVO
	 * @return 是否存在主键索引
	 */
	private static boolean isExsitPkIndex(TableVO objTableVO) {
		List<TableIndexVO> indexs = objTableVO.getIndexs();
		for (TableIndexVO index : indexs) {
			if (index.isPrimary())
				return true;
		}
		return false;
	}

	/**
	 * 比较Map中Value
	 * 
	 * @param lhs
	 *            列信息
	 * @param rhs
	 *            实体信息
	 * @return boolean
	 */
	public static String compareMapValue(final Map<String, Object> lhs,
			final Map<String, Object> rhs) {
		StringBuffer detail = new StringBuffer();
		List<String> lst = new ArrayList<String>();
		Set<String> set = lhs.keySet();
		for (String key : set) {
			Object lhsValue = lhs.get(key);
			Object rhsValue = rhs.get(key);

			if (lhsValue != null && !lhsValue.equals(rhsValue)) {
				lst.add(fieldDescription.get(key) + "发生变化[" + rhsValue + "-->"
						+ lhsValue + "]");
			}
		}
		if (lst.size() == 1) {
			return lst.get(0);
		}
		for (int i = 0; i < lst.size(); i++) {
			if (i == 0) {
				detail.append((i + 1) + "." + lst.get(i));
			} else {
				detail.append("," + (i + 1) + "." + lst.get(i));
			}
		}
		return detail.toString();
	}
}
