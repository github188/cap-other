/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.soareg;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.preferencesconfig.PreferenceConfigQueryUtil;
import com.comtop.cap.bm.metadata.soareg.model.SoaBaseVO;
import com.comtop.cap.bm.metadata.soareg.util.SoaReqServiceUtil;
import com.comtop.cap.runtime.base.facade.CapSoaExtendFacade;
import com.comtop.cap.runtime.core.AppBeanUtil;
import com.comtop.soa.bus.CommonCallHelper;
import com.comtop.soa.bus.ICommonCall;

/**
 * soa服务执行器
 * 
 * @author 许畅
 * @since JDK1.6
 * @version 2016年5月19日 许畅 新建
 */
public abstract class SoaServiceExecutor implements ISoaServiceManager {

	/** 日志记录器 */
	private static final Logger LOGGER = LoggerFactory
			.getLogger(SoaServiceExecutor.class);

	/**
	 * @return 获取CapSoaExtendFacade实例
	 */
	protected CapSoaExtendFacade getCapSoaExtendFacade() {
		return AppBeanUtil.getBean(CapSoaExtendFacade.class);
	}
	
	/** soa注册脚本 */
	private final StringBuffer strSoaRegScript = new StringBuffer();
	
	/**
	 * 初始化soa注册脚本
	 * 
	 * @param soaBaseVO
	 *            SoaBaseVO
	 * @return SoaRegScript
	 *
	 * @see com.comtop.cap.bm.metadata.soareg.ISoaServiceManager#initSoaRegScript(com.comtop.cap.bm.metadata.soareg.model.SoaBaseVO)
	 */
	@Override
	public String initSoaRegScript(SoaBaseVO soaBaseVO) {
		if (strSoaRegScript.length() <= 0) {
			strSoaRegScript.append(SoaReqServiceUtil.getSoaRegScript(soaBaseVO));
		}
		return strSoaRegScript.toString();
	}
	
	/**
	 * 通过EHCache缓存查询是否需要执行soa远端服务(后续改为了通过XPath存储首选项xml)
	 * 
	 * @return 是否调用执行soa远端服务
	 */
	@Override
	public boolean isCallSoaRemoteService() {
		boolean isCallSoaService = PreferenceConfigQueryUtil
				.isCallSoaRemoteService();

		LOGGER.info("调用soa远端服务开关为:" + isCallSoaService + "...");

		return isCallSoaService;
	}

	/**
	 * 注册实体soa服务
	 * 
	 * @param sqlContent
	 *            soa 注册脚本内容
	 */
	@Override
	public void registerSoaSql(String sqlContent) {
		getCapSoaExtendFacade().registerEntitySoaSql(sqlContent);
	}

	/**
	 * 调用soa远程服务
	 *
	 * @param sid
	 *            soa服务id
	 * @param param
	 *            参数
	 */
	@Override
	public void callSoaRemoteService(String sid, Object... param) {
		if (!isCallSoaRemoteService())
			return;

		try {
			ICommonCall commonCall = CommonCallHelper.getService();
			if (commonCall.hasService(sid)) {
				LOGGER.info("调用soa远程服务，执行实体soa服务注册脚本...");
				CommonCallHelper.getService().call(sid, null, param);
			} else {
				LOGGER.info("sid为:" + sid + "的soa远程服务不存在，不需执行实体soa服务注册脚本");
			}
		} catch (Exception ex) {
			LOGGER.info("调用sid为:" + sid + "的soa远程服务，插入实体soa服务注册脚本时发生异常" + ex);
		}
	}

	/**
	 * 刷新soa服务
	 * 
	 * @param lstServiceCodes
	 *            服务编码集合
	 */
	@Override
	public void refreshSoaService(List<String> lstServiceCodes) {
		getCapSoaExtendFacade().refreshSoaService(lstServiceCodes);
	}

}
