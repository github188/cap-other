/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.preferencesconfig;

import com.comtop.cap.bm.metadata.preferencesconfig.facade.PreferencesFacade;
import com.comtop.cap.bm.metadata.preferencesconfig.model.PreferenceConfigVO;
import com.comtop.top.core.jodd.AppContext;
import com.comtop.top.core.util.StringUtil;

/**
 * 首选项配置查询类
 * 
 * @author 罗珍明
 * @version jdk1.6
 * @version 2016-5-27
 * @version 2016-5-30 许畅 修改
 */
public class PreferenceConfigQueryUtil {

	/*** 默认父实体id */
	public final static String DEFAULT_PARENT_ENTITY_ID = "com.comtop.cap.runtime.base.entity.CapBase";

	/*** 流程审批默认父实体id */
	public final static String DEFAULT_PARENT_ENTITY_ID_WORKFLOW = "com.comtop.cap.runtime.base.entity.CapWorkflow";

	/** 工作流父实体匹配分隔符 */
	private final static String SPLIT_FLAG_WORKFLOW_MATCH_RULE = ",";

	/** 生成代码的技术框架：jodd **/
	public static final String GENERATECODE_FRAMEWORK_JODD = "jodd";

	/** 生成代码的技术框架：spring **/
	public static final String GENERATECODE_FRAMEWORK_SPRING = "spring";

	/** 代码生成路径 **/
	private static final String CODE_PATH_KEY = "projectFilePath";

	/** java代码生成路径 **/
	private static final String JAVA_CODE_PATH_KEY = "javaMainFilePath";

	/** 配置文件生成路径 **/
	private static final String RESOURCE_FILE_PATH_KEY = "resourcesFilePath";

	/** 页面文件路径 **/
	private static final String PAGE_FILE_PATH_KEY = "webappFilePath";

	/** 界面原型图片生成路径 **/
	private static final String PROTOTYPE_IMG_PATH = "prototypeImagePath";

	/** 表列前缀忽略标识 */
	private static final String TABLE_COLUMN_PREFIX_INGORE = "tableColumnPrefixIngore";

	/** 表前缀忽略标识 */
	private static final String TABLE_PREFIX_INGORE = "tablePrefixIngore";

	/** jdbc配置 */
	private static final String JDBC_URL = "jdbcURL";
	/** jdbc配置 */
	private static final String JDBC_USERNAME = "jdbcUserName";
	/** jdbc配置 */
	private static final String JDBC_PASSWORD = "jdbcPassword";
	/** jdbc配置 */
	private static final String DRIVER_NAME = "driverClassName";

	/**
	 * 获取配置项中父类配置信息
	 * 
	 * @return 父实体ID
	 */
	public static String getDefaultParentEntityId() {
		PreferencesFacade objPerferencesFacade = AppContext
				.getBean(PreferencesFacade.class);
		// 默认父实体配置对象
		PreferenceConfigVO objPreferenceConfigVO = objPerferencesFacade
				.getConfig("defaultParentEntityId");
		if (objPreferenceConfigVO == null
				|| StringUtil.isBlank(objPreferenceConfigVO.getConfigValue())) {
			return DEFAULT_PARENT_ENTITY_ID;
		}
		return objPreferenceConfigVO.getConfigValue();
	}

	/**
	 * 获取配置项中流程父类配置信息
	 * 
	 * @return 父实体ID
	 */
	public static String getDefaultWorkflowParentEntityId() {
		PreferencesFacade objPerferencesFacade = AppContext
				.getBean(PreferencesFacade.class);
		// 默认工作流父实体配置对象
		PreferenceConfigVO objWorkflowConfigVO = objPerferencesFacade
				.getConfig("defaultWorkflowParentEntityId");
		if (objWorkflowConfigVO == null
				|| StringUtil.isBlank(objWorkflowConfigVO.getConfigValue())) {
			return DEFAULT_PARENT_ENTITY_ID_WORKFLOW;
		}
		return objWorkflowConfigVO.getConfigValue();
	}

	/**
	 * 获取配置项中流程父类匹配规则
	 * 
	 * @return 字段名称集合
	 */
	public static String[] getWorkflowMarchRule() {
		PreferencesFacade objPerferencesFacade = AppContext
				.getBean(PreferencesFacade.class);
		// 默认工作流父实体匹配规则
		PreferenceConfigVO objWorkflowMarchRuleConfigVO = objPerferencesFacade
				.getConfig("defaultWorkflowMatchRule");
		String[] strMatch = objWorkflowMarchRuleConfigVO.getConfigValue()
				.split(SPLIT_FLAG_WORKFLOW_MATCH_RULE);
		return strMatch;
	}

	/**
	 * 获取页面url的截取前缀
	 * 
	 * @return 字符串
	 */
	public static final String getPageUrlPrefix() {
		PreferencesFacade objFacade = AppContext
				.getBean(PreferencesFacade.class);
		PreferenceConfigVO objConfigVO = objFacade
				.getConfig("pagePrefixConfig");
		if (objConfigVO == null) {
			return "^com.comtop.";
		}
		if (objConfigVO.getConfigValue().endsWith(".")) {
			return "^" + objConfigVO.getConfigValue();
		}
		return "^" + objConfigVO.getConfigValue() + ".";
	}

	/**
	 * 获取首选项中配置的生成代码的技术框架
	 * 
	 * @return 技术框架
	 */
	public static final String getGenerateCodeFramework() {
		PreferencesFacade objFacade = AppContext
				.getBean(PreferencesFacade.class);
		PreferenceConfigVO objConfigVO = objFacade
				.getConfig("generateframework");
		if (objConfigVO == null
				|| StringUtil.isBlank(objConfigVO.getConfigValue())) {
			return GENERATECODE_FRAMEWORK_JODD;
		}
		return objConfigVO.getConfigValue();
	}

	/**
	 * 获取首选项中的是否执行soa远端服务配置
	 * 
	 * @return 是否执行soa远端服务
	 */
	public static final boolean isCallSoaRemoteService() {
		PreferencesFacade objFacade = AppContext
				.getBean(PreferencesFacade.class);

		PreferenceConfigVO objConfigVO = objFacade.getConfig("callSoaService");
		if (objConfigVO == null
				|| StringUtil.isBlank(objConfigVO.getConfigValue())) {
			return false;
		}
		return Boolean.valueOf(objConfigVO.getConfigValue());
	}

	/**
	 * 是否元数据一致性校验
	 * 
	 * @return 是否元数据一致性校验
	 */
	public static final boolean isMetadataConsistency() {
		PreferencesFacade objFacade = AppContext
				.getBean(PreferencesFacade.class);

		PreferenceConfigVO objConfigVO = objFacade.getConfig("isConsistency");
		if (objConfigVO == null
				|| StringUtil.isBlank(objConfigVO.getConfigValue())) {
			return false;
		}
		return Boolean.valueOf(objConfigVO.getConfigValue());
	}

	/**
	 * 获取首选项xml 代码生成路径
	 * 
	 * @return 首选项值
	 */
	public static final String getCodePath() {
		String codePath = getPreferenceConfigValue(CODE_PATH_KEY);
		return codePath != null ? codePath.trim() : codePath;
	}

	/**
	 * 获取生成java路径
	 * 
	 * @return java代码路径
	 */
	public static final String getJavaCodePath() {
		String javaCodePath = getPreferenceConfigValue(JAVA_CODE_PATH_KEY);
		return javaCodePath != null ? javaCodePath.trim() : "src/main/java/";
	}

	/**
	 * 获取资源配置文件路径
	 * 
	 * @return 资源文件路径
	 */
	public static final String getResourceFilePath() {
		String resource = getPreferenceConfigValue(RESOURCE_FILE_PATH_KEY);
		return resource != null ? resource.trim() : "src/main/resources/";
	}

	/**
	 * 获取界面文件路径
	 * 
	 * @return 界面文件路径
	 */
	public static final String getPageFilePath() {
		String pagePath = getPreferenceConfigValue(PAGE_FILE_PATH_KEY);
		return pagePath != null ? pagePath.trim() : "src/main/webapp/";
	}

	/**
	 * 获取界面原型图片生成路径
	 *
	 * @return 图片生成路径
	 */
	public static final String getPrototypeImagePath() {
		String imgPath = getPreferenceConfigValue(PROTOTYPE_IMG_PATH);
		return imgPath != null ? imgPath.trim() : imgPath;
	}

	/**
	 * 获取表列前缀忽略标识
	 * 
	 * @return 获取表列忽略标识
	 */
	public static final int getTableColumnPrefixIngore() {
		return Integer
				.parseInt(getPreferenceConfigValue(TABLE_COLUMN_PREFIX_INGORE));
	}

	/**
	 * 获取表前缀忽略标识
	 * 
	 * @return 获取表列忽略标识
	 */
	public static final int getTablePrefixIngore() {
		return Integer.parseInt(getPreferenceConfigValue(TABLE_PREFIX_INGORE));
	}

	/**
	 * JDBC URL
	 * 
	 * @return jdbcURL
	 */
	public static final String getJdbcURL() {
		return getPreferenceConfigValue(JDBC_URL);
	}

	/**
	 * JDBC username
	 * 
	 * @return JDBC username
	 */
	public static final String getJdbcUserName() {
		return getPreferenceConfigValue(JDBC_USERNAME);
	}

	/**
	 * JDBC password
	 * 
	 * @return JDBC password
	 */
	public static final String getJdbcPassword() {
		return getPreferenceConfigValue(JDBC_PASSWORD);
	}

	/**
	 * JDBC 驱动名称
	 * 
	 * @return JDBC 驱动名
	 */
	public static final String getDriverName() {
		return getPreferenceConfigValue(DRIVER_NAME);
	}
	
	/**
	 * 根据首选项xml key获取 首选项值
	 * 
	 * @param key
	 *            根据首选项xml key获取 首选项值
	 * @return 首选项值
	 */
	private static final String getPreferenceConfigValue(String key) {
		PreferencesFacade objFacade = AppContext
				.getBean(PreferencesFacade.class);
		if (objFacade == null) {
			objFacade = new PreferencesFacade();
		}

		PreferenceConfigVO objConfigVO = objFacade.getConfig(key);
		return objConfigVO.getConfigValue();
	}

	/**
	 * 获取页面web请求路径的后缀
	 * 
	 * @return 字符串
	 */
	public static final String getPageUrlSuffix() {
		PreferencesFacade objFacade = AppContext
				.getBean(PreferencesFacade.class);
		PreferenceConfigVO objConfigVO;
		if (GENERATECODE_FRAMEWORK_JODD.equals(objFacade.getConfig(
				"generateframework").getConfigValue())) {
			objConfigVO = objFacade.getConfig("joddPageUrlSuffix");
		} else {
			objConfigVO = objFacade.getConfig("springPageUrlSuffix");
		}

		if (objConfigVO == null) {
			return null;
		}
		return objConfigVO.getConfigValue();
	}
}
