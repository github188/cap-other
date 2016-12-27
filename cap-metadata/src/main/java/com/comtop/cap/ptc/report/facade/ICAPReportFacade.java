/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.ptc.report.facade;

import java.util.List;

import com.comtop.cap.ptc.report.model.CAPReportVO;
import com.comtop.cap.ptc.report.model.ReportCondition;

/**
 * 
 * CAP统计报表Facade接口
 * 
 * @author 杨赛
 * @since jdk1.6
 * @version 2015年9月21日
 */
public interface ICAPReportFacade {
	
	/**
     * 查询系统整体资源统计数据
     * 
     * @return ReportVO 统计数据
     */
	CAPReportVO querySystemIntegralityReportVO();
	
	/**
	 * 根据条件查询阶段性资源统计数据
	 * @param reportCondition 查询条件
	 * @return 统计数据
	 */
	List<CAPReportVO> queryPhasedReportVO(ReportCondition reportCondition);
	
	/**
	 * 根据条件查询对应模块资源统计数据
	 * @param reportCondition 查询条件
	 * @return 统计数据
	 */
	List<CAPReportVO> queryModuleReportVO(ReportCondition reportCondition);
}
