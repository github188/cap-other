/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.soareg;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.bm.metadata.soareg.model.SoaBaseVO;
import com.comtop.cap.bm.metadata.soareg.util.SoaReqServiceUtil;

/**
 * MySQL版SOA服务执行器
 * 
 * @author 许畅
 * @since JDK1.7
 * @version 2016年12月16日 许畅 新建
 */
public class SoaServiceExecutorMySQL extends SoaServiceExecutor {

	/**
	 * 构造方法
	 */
	public SoaServiceExecutorMySQL() {
		super();
	}

	/**
	 * 获取SQL客户端可执行SQL
	 * 
	 * @param soaBaseVO
	 *            SoaBaseVO
	 * @return client sql
	 *
	 * @see com.comtop.cap.bm.metadata.soareg.ISoaServiceManager#getClientSQL(com.comtop.cap.bm.metadata.soareg.model.SoaBaseVO)
	 */
	@Override
	public String getClientSQL(SoaBaseVO soaBaseVO) {
		String soaReqScript = initSoaRegScript(soaBaseVO);

		StringBuilder sbProExecSql = new StringBuilder();
		// 获取soa扩展参数脚本
		String strExtendParamINfoScript = "CALL "+SoaReqServiceUtil
				.getSoaExtendParamInfoScript(soaBaseVO);
		if (StringUtils.isNotBlank(strExtendParamINfoScript)) {
			sbProExecSql.append("\t /*开始注册实体SOA扩展参数信息*/\n");
			sbProExecSql.append("\t");
			sbProExecSql.append(strExtendParamINfoScript);
			sbProExecSql.append("\n");
		}
		if (StringUtils.isNotBlank(soaReqScript)) {
			// 获取实体soa服务注册信息
			sbProExecSql.append("\t/*开始注册实体SOA服务信息*/\n");
			sbProExecSql.append(soaReqScript);
		}

		StringBuilder sbRegSql = new StringBuilder();
		sbRegSql.append(sbProExecSql);
		sbRegSql.append("\n");
		sbRegSql.append("commit;");
		return sbRegSql.toString();
	}

	/**
	 * 获取JDBC可执行SQL
	 * 
	 *
	 * @param soaBaseVO
	 *            SoaBaseVO
	 * @return JDBC sql
	 *
	 * @see com.comtop.cap.bm.metadata.soareg.ISoaServiceManager#getExecuteSQL(com.comtop.cap.bm.metadata.soareg.model.SoaBaseVO)
	 */
	@Override
	public String getExecuteSQL(SoaBaseVO soaBaseVO) {
		// 初始化soa注册脚本
		String soaReqScript = initSoaRegScript(soaBaseVO);

		StringBuffer produceJdbcSql = new StringBuffer();
		String strExtendParamINfoScript ="CALL " +SoaReqServiceUtil.getSoaExtendParamInfoScript(soaBaseVO);
		produceJdbcSql.append(strExtendParamINfoScript);
		produceJdbcSql.append("\n");
		produceJdbcSql.append(soaReqScript);

		return produceJdbcSql.toString();
	}
	
}
