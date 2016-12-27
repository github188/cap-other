/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.sqlfile;

import java.beans.BeanInfo;
import java.beans.Introspector;
import java.beans.PropertyDescriptor;
import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.database.dbobject.util.DBType;
import com.comtop.cap.bm.metadata.database.dbobject.util.DBTypeAdapter;
import com.comtop.top.core.base.model.CoreVO;

/**
 * 生成sqlFile抽象类
 * 
 * @author 许畅
 * @since JDK1.6
 * @version 2016年3月4日 许畅 新建
 */
public abstract class CoreGenerateSqlFile implements IGenerateSqlFile<CoreVO> {

	/** 资源文件路径 */
	protected static final String RESOURCE_PATH = "src/main/resources/";
	
	/** 日志记录 */
	private final static Logger LOGGER = LoggerFactory
			.getLogger(CoreGenerateSqlFile.class);

	/**
	 * sql
	 */
	protected StringBuffer sql;

	/**
	 * 生成Insert sql
	 * 
	 * @param coreVO
	 *            CoreVO
	 * @return str
	 */
	@Override
	public String createInsertSQL(CoreVO coreVO) {
		StringBuffer columns = new StringBuffer();
		StringBuffer values = new StringBuffer();
		String pk = "";
		String pkColumn="";
		// 通过反射获取FuncVO类中的所有Column列名
		Field[] fields = coreVO.getClass().getDeclaredFields();
		try {
			int i = 0;
			for (Field field : fields) {
				if (field.isAnnotationPresent(Column.class)) {
					String column = field.getAnnotation(Column.class).name();
					field.setAccessible(true);

					Object value = field.get(coreVO);
					if (field.isAnnotationPresent(Id.class)) {
						value = value == null ? UUID.randomUUID().toString()
								.replaceAll("-", "").toUpperCase() : value;
						pk = value.toString();
						pkColumn = column;
					}
					if (i == 0) {
						columns.append("" + column + "");
						if (value instanceof String) {
							values.append("'" + value + "'");
						} else if (value instanceof Date) {
							values.append("," + to_date((Date) value) + "");
						} else {
							values.append("" + value + "");
						}
						field.getName();
					} else {
						columns.append("," + column + "");
						if (value instanceof String) {
							values.append(",'" + value + "'");
						} else if (value instanceof Date) {
							values.append("," + to_date((Date) value) + "");
						} else {
							values.append("," + value + "");
						}
						field.getName();
					}
					i++;
				}
			}
		} catch (IllegalArgumentException e) {
			LOGGER.error(e.getMessage(),e);
		} catch (IllegalAccessException e) {
			LOGGER.error(e.getMessage(),e);
		}

		// 通过反射获取表名
		String tableName = getTableName(coreVO.getClass());
		
		// 先删除再插入
		sql.append("\t DELETE FROM " + tableName + " WHERE " + pkColumn
				+ " = '" + pk + "'; \n");

		// 生成insert插入语句
		sql.append("\t INSERT INTO " + tableName + " (" + columns
				+ ") VALUES (" + values + "); \n");
		return pk;
	}
	
	/**
	 * oracle转换为时间格式,同时适配MYSQL str_to_date('2016-12-21 17:34:00','%Y-%c-%d %H:%i:%s')
	 * 
	 * @param date
	 *            日期
	 * @return oracle时间格式
	 */
	private String to_date(Date date) {
		DBType dbType = DBTypeAdapter.getDBType();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		if (DBType.ORACLE.getValue().equals(dbType.getValue())) {
			return "to_date('" + sdf.format(date) + "','yyyy-MM-dd HH24:mi:ss')";
		} else if (DBType.MYSQL.getValue().equals(dbType.getValue())) {
			return "str_to_date('"+sdf.format(date) +"','%Y-%c-%d %H:%i:%s')";
		}
		return "to_date('" + sdf.format(date) + "','yyyy-MM-dd HH24:mi:ss')";
	}

	/**
	 * 生成 update更新sql脚本
	 * 
	 * @param coreVO
	 *            CoreVO
	 * @return sql
	 */
	@Override
	public String createUpdateSQL(CoreVO coreVO) {
		StringBuffer update = new StringBuffer();
		StringBuffer main = new StringBuffer();
		String primaryKeyName = "";
		Object primaryKeyValue = "";
		Field[] fields = coreVO.getClass().getDeclaredFields();
		try {
			int i = 0;
			for (Field field : fields) {
				if (field.isAnnotationPresent(Column.class)) {
					field.setAccessible(true);
					if (field.isAnnotationPresent(Id.class)) {
						primaryKeyName = field.getAnnotation(Column.class)
								.name();
						primaryKeyValue = field.get(coreVO) == null ? ""
								: field.get(coreVO);
					} else {
						String columnName = field.getAnnotation(Column.class)
								.name();
						Object value = field.get(coreVO);
						if (i == 0) {
							if (value instanceof String) {
								main.append("" + columnName + "='" + value + "'");
							} else if (value instanceof Date) {
								main.append("" + columnName + "=" + to_date((Date)value) + "");
							} else {
								main.append("" + columnName + "=" + value + "");
							}
						} else {
							if (value instanceof String) {
								main.append("," + columnName + "='" + value + "'");
							} else if (value instanceof Date) {
								main.append("," + columnName + "=" + to_date((Date)value) + "");
							} else {
								main.append("," + columnName + "=" + value + "");
							}
						}
						i++;
					}
				}
			}
		} catch (IllegalArgumentException e) {
			LOGGER.error(e.getMessage(), e);
		} catch (IllegalAccessException e) {
			LOGGER.error(e.getMessage(), e);
		}
		update.append("\t update " + getTableName(coreVO.getClass()) + " set ");
		update.append(main + " ");
		update.append("where " + primaryKeyName + " = '" + primaryKeyValue
				+ "'; \n");
		return update.toString();
	}

	/**
	 * 根据类上的Table注解获取表名
	 * 
	 * @param cls
	 *            class
	 * 
	 * @return tableName
	 */
	public String getTableName(Class<?> cls) {

		Annotation[] anotations = cls.getDeclaredAnnotations();
		for (Annotation annotation : anotations) {
			if (annotation instanceof Table) {
				return ((Table) annotation).name();
			}
		}
		return null;
	}

	/**
	 * javabean转换为map
	 * 
	 * @param bean
	 *            bean
	 * @return map
	 */
	protected Map<String, Object> beanConvertToMap(Object bean) {
		Class<?> type = bean.getClass();
		Map<String, Object> returnMap = new HashMap<String, Object>();
		try {
			BeanInfo beanInfo = Introspector.getBeanInfo(type);
			PropertyDescriptor[] propertyDescriptors = beanInfo
					.getPropertyDescriptors();
			for (int i = 0; i < propertyDescriptors.length; i++) {
				PropertyDescriptor descriptor = propertyDescriptors[i];
				String propertyName = descriptor.getName();
				if (!propertyName.equals("class")) {
					Method readMethod = descriptor.getReadMethod();
					Object result = readMethod.invoke(bean, new Object[0]);
					if (result != null) {
						returnMap.put(propertyName, result);
					} else {
						returnMap.put(propertyName, "");
					}
				}
			}
		} catch (Exception e) {
			LOGGER.error(e.getMessage(), e);
		}
		return returnMap;
	}

	/**
	 * 生成文件内容
	 * 
	 * @return 文件内容
	 */
	protected String getFileContent() {
		DBType dbType = DBTypeAdapter.getDBType();
		if (DBType.ORACLE.getValue().equals(dbType.getValue())) {
			return getOracleFileContent();
		} else if (DBType.MYSQL.getValue().equals(dbType.getValue())) {
			return getMySQLFileContent();
		}
		return getOracleFileContent();
	}
	
	/**
	 * @return oracle 脚本内容
	 */
	private String getOracleFileContent() {
		StringBuffer content = new StringBuffer();
		content.append("begin \n");
		content.append(sql);
		content.append("end; \n");
		content.append("/ \n");
		content.append("commit; ");
		return content.toString();
	}
	
	/**
	 * @return mysql脚本内容
	 */
	private String getMySQLFileContent() {
		StringBuffer content = new StringBuffer();
		content.append(sql);
		content.append("commit; ");
		return content.toString();
	}

	/**
	 * 生成文件名称
	 * 
	 * @param packageName
	 *            包名
	 * @param endPrefix
	 *            后缀名
	 * @return 文件名称
	 */
	protected String getFileName(String packageName, String endPrefix) {
		if (StringUtils.isNotEmpty(packageName)) {
			if (packageName.indexOf(".") > -1) {
				String fileName = packageName.substring(packageName
						.lastIndexOf('.') + 1);
				// 进行字母的ascii编码前移实现首字母大写
				String value = fileName + endPrefix;
				char[] cs = value.toCharArray();
				cs[0] -= 32;
				return String.valueOf(cs);
			}
			// 没有.则直接去包名
			String fileName = packageName.substring(0, 1).toUpperCase()
					+ packageName.substring(1, packageName.length());
			String value = "[3]" + fileName + endPrefix;
			return value;
		}
		return "NewFile.sql";
	}

	/**
	 * @return the sql
	 */
	@Override
	public StringBuffer getSql() {
		return sql;
	}

	/**
	 * @param sql
	 *            the sql to set
	 */
	protected void setSql(StringBuffer sql) {
		this.sql = sql;
	}
}
