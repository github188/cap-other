/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.soareg;

import java.util.List;

import com.comtop.cap.bm.metadata.soareg.model.SoaBaseVO;

/**
 * SOA服务管理器接口
 * 
 * @author 许畅
 * @since JDK1.6
 * @version 2016年5月19日 许畅 新建
 */
public interface ISoaServiceManager {

	/**
	 * 是否调用soa远端调用
	 * 
	 * @return 是否调用soa远端调用
	 */
	public boolean isCallSoaRemoteService();

	/**
	 * 调用soa服务注册脚本
	 * 
	 * @param sqlContent
	 *            soa sql注册脚本内容
	 */
	public void registerSoaSql(String sqlContent);

	/**
	 * 调用soa远程服务
	 * 
	 * @param sid
	 *            soa服务id
	 * @param param
	 *            参数
	 */
	public void callSoaRemoteService(String sid, Object... param);

	/**
	 * 刷新soa服务
	 * 
	 * @param lstServiceCodes
	 *            服务编码集合
	 */
	public void refreshSoaService(List<String> lstServiceCodes);
	
	/**
	 * 初始化soa注册脚本
	 * 
	 * @param soaBaseVO
	 *            SoaBaseVO
	 * @return soa注册脚本
	 */
	public String initSoaRegScript(SoaBaseVO soaBaseVO);

	/**
	 * 获取SOA的SQL客户端可执行SQL
	 * 
	 * @param soaBaseVO
	 *            SoaBaseVO
	 * 
	 * @return 客户端SQL如plsql客户端等
	 */
	public String getClientSQL(SoaBaseVO soaBaseVO);

	/**
	 * 获取SOA JDBC可执行SQL
	 * 
	 * @param soaBaseVO
	 *            SoaBaseVO
	 * 
	 * @return jdbc可执行SQL
	 */
	public String getExecuteSQL(SoaBaseVO soaBaseVO);

}
