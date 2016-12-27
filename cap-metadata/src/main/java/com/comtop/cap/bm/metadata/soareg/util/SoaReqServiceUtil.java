/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.soareg.util;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.soareg.ISoaServiceManager;
import com.comtop.cap.bm.metadata.soareg.SoaServiceFactory;
import com.comtop.cap.bm.metadata.soareg.SoaSqlRegister;
import com.comtop.cap.bm.metadata.soareg.model.SoaBaseVO;
import com.comtop.cap.runtime.base.util.CapRuntimeUtils;
import com.comtop.cip.jodd.util.StringUtil;

/**
 * SOA服务注册工具类
 * 
 * @author 许畅
 * @since JDK1.7
 * @version 2016年12月16日 许畅 新建
 */
public final class SoaReqServiceUtil {
	
	/** 日志记录器 */
	private static final Logger LOGGER = LoggerFactory.getLogger(SoaReqServiceUtil.class);

	/**
	 * 构造方法
	 */
	private SoaReqServiceUtil() {
		super();
	}

	/**
	 * 获取实体soa注册脚本
	 * 
	 * @param soaBaseVO
	 *            实体VO
	 * @return 实体soa注册脚本
	 */
	public static String getSoaRegScript(SoaBaseVO soaBaseVO) {
		String regex = soaBaseVO.getModelPackage() + ".facade." + soaBaseVO.getEngName() + "Facade(*)";
		LOGGER.info("开始获取实体" + soaBaseVO.getEngName() + "的soa服务sql注册脚本");
		// 通过元数据生成SOA注册的脚本--soaService服务对象的转换器,暂采用扫描
		String sqlContent = SoaSqlRegister.getEntityRegisterSqlByRegex(regex);
		return StringUtil.isNotEmpty(sqlContent) ? sqlContent : "";
	}
	
	/**
	 * 获取插入扩展参数的sql脚本
	 * 
	 * @param soaBaseVO
	 *            soa实体VO
	 * @return 扩展参数脚本
	 */
	public static String getSoaExtendParamInfoScript(SoaBaseVO soaBaseVO) {
		String entityName = CapRuntimeUtils.firstLetterToLower(soaBaseVO
				.getEngName());
		String entityAliasName = StringUtil.isEmpty(soaBaseVO.getAliasName()) ? entityName
				: soaBaseVO.getAliasName();
		String pkgName = soaBaseVO.getModelPackage();
		String proName = soaBaseVO.getProcessId();
		int flag = StringUtil.isBlank(proName) ? 0 : 1;
		return "P_CAP_INSERT_SOA_PARAM_EXT('" + entityName + "','" + pkgName + "'," + flag + ",'" + entityAliasName + "');";
	}
	
	/**
	 * 拼装成jdbc可调用版存储过程语句
	 * 
	 * @param sqlContent
	 *            执行sql脚本
	 * @return 带有call的存储过程
	 */
	public static String assembleToJdbcExecSQL(String sqlContent) {
		StringBuffer produce = new StringBuffer();
		if (StringUtils.isEmpty(sqlContent))
			return produce.toString();

		String[] sqls = sqlContent.trim().split(";");
		for (String sql : sqls) {
			produce.append("CALL " + sql.trim() + "; \n");
		}
		return produce.toString();
	}
	
	/**
	 * 执行存储过程(此处的sqlContent如果是存储过程需要加 call关键字,
	 * 调用此方法前可以先调用assembleToProduce方法转为调用存储过程形式)
	 * 
	 * @param sqlContent
	 *            sql脚本
	 */
	public static void executeProcedureSql(String sqlContent) {
		ISoaServiceManager soaServiceExecutor = SoaServiceFactory.getSoaServiceExecutor();
		// 注册实体方法的soa服务sql脚本
		soaServiceExecutor.registerSoaSql(sqlContent);
		// 通过soa远程调用，执行soa服务注册脚本
		String sid = "capSoaExtendFacade.registerEntitySoaSql";
		soaServiceExecutor.callSoaRemoteService(sid, sqlContent);
	}

}
