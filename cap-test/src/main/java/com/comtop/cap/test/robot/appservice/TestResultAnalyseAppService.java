/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.robot.appservice;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.util.StringUtils;

import com.comtop.cap.test.robot.model.Statistics;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.top.core.base.dao.CoreDAO;

/**
 * 测试结果分析
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年9月28日 lizhongwen
 */
@PetiteBean
public class TestResultAnalyseAppService {
    
    /** 时间格式化 */
    private static final SimpleDateFormat FORMATTER = new SimpleDateFormat("yyyyMMdd");
    
    /**
     * 注入 commonDAO
     */
    @SuppressWarnings("rawtypes")
    @PetiteInject
    protected CoreDAO coreDAO;
    
    /**
     * @param condition 查询条件
     * @return 按周获取测试结果统计
     */
    @SuppressWarnings("unchecked")
    public List<Statistics> queryTestResultStatisticsByWeek(Statistics condition) {
        Map<String, Object> param = wrapTimeParam(condition);
        List<Statistics> ret = coreDAO.queryList("com.comtop.cap.test.robot.queryTestResultStatisticsByWeek", param);
        return ret;
    }
    
    /**
     * @param condition 查询条件
     * @return 按月获取测试结果统计
     */
    @SuppressWarnings("unchecked")
    public List<Statistics> queryTestResultStatisticsByMonth(Statistics condition) {
        Map<String, Object> param = wrapTimeParam(condition);
        List<Statistics> ret = coreDAO.queryList("com.comtop.cap.test.robot.queryTestResultStatisticsByMonth", param);
        return ret;
    }
    
    /**
     * @param condition 查询条件
     * @return 查询最好或者最差的排名
     */
    @SuppressWarnings("unchecked")
    public List<Statistics> queryTopTestResultStatistics(Statistics condition) {
        Map<String, Object> param = wrapTimeParam(condition);
        if (condition.getTop() == null) {
            condition.setTop(10);
        }
        List<Statistics> ret = null;
        if (condition.getExcellent() == null || !condition.getExcellent()) {// 最差
            ret = coreDAO.queryList("com.comtop.cap.test.robot.queryTopWorstTestResultStatistics", param, 1,
                condition.getTop());
        } else {
            ret = coreDAO.queryList("com.comtop.cap.test.robot.queryTopExcellentTestResultStatistics", param, 1,
                condition.getTop());
        }
        return ret;
    }
    
    /**
     * @param condition 查询条件
     * @return 按模块获取测试结果统计
     */
    @SuppressWarnings("unchecked")
    public List<Statistics> queryTestResultStatisticsByModule(Statistics condition) {
        Map<String, Object> param = wrapTimeParam(condition);
        if (StringUtils.hasText(condition.getAppId())) {
            param.put("appId", condition.getAppId());
        }
        if (StringUtils.hasText(condition.getAppFullName())) {
            String appFullName = condition.getAppFullName();
            if (!appFullName.endsWith("/")) {
                appFullName = appFullName + "/%";
            }
            param.put("appFullName", appFullName);
        }
        List<Statistics> ret = coreDAO.queryList("com.comtop.cap.test.robot.queryTestResultStatisticsByModule", param);
        return ret;
    }
    
    /**
     * @param lstTestCaseName 查询条件
     * @param packageId 应用Id
     * @return 测试结果
     */
    @SuppressWarnings("unchecked")
    public List<Statistics> queryTestResultByTestCaseName(List<String> lstTestCaseName, String packageId) {
        Map<String, Object> param = new HashMap<String, Object>();
        param.put("appId", packageId);
        param.put("lstTestCaseName", lstTestCaseName);
        List<Statistics> ret = coreDAO.queryList("com.comtop.cap.test.robot.queryTestResultByTestCaseName", param);
        return ret;
    }
    
    
	/***
	 * 是否存在指定test-UUID的测试数据
	 * 
	 * @param testUuid
	 *            测试uuid。不可为空
	 * @return 如果存在则返回true,否则返回false(uuid为空\null也返回false)
	 */
	public boolean isExistTestuuidData(String testUuid) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("testUuid", testUuid);
		Integer countNum = (Integer) coreDAO.selectOne("com.comtop.cap.test.robot.isExistTestuuidData", param);
		if (countNum.intValue() > 0) {
			return true;
		}
		return false;
	}
    /***
     * 指定的testUuid是否存在测试失败的数据
     * @param testUuid testUuid 测试uuid。不可为空
     * @return 当且仅当有测试数据失败时返回true；否则返回false(没有指定uuid的测试数据、指定uuid的测试数据不存在失败、指定uuid为空\null也返回false)
     */
    public boolean isExistFailDataByTestUuid(String testUuid){
    	Map<String, Object> param = new HashMap<String, Object>();
		param.put("testUuid", testUuid);
		Integer countNum = (Integer) coreDAO.selectOne("com.comtop.cap.test.robot.isExistFailDataByTestUuid", param);
		if (countNum.intValue() > 0) {
			return true;
		}
		return false;
    }
    
    /***
     * 根据测试uuid获取完整的测试报告
     * @param testUuid  测试uuid。不可为空
     * @return 返回指定uuid的所有测试数据按app_id,meta_name 字段组合排序
     */
    public List<Statistics> queryTestResultByTestUuid(String testUuid){
    	Map<String, Object> param = new HashMap<String, Object>();
		param.put("testUuid", testUuid);
		List<Statistics> ret = coreDAO.queryList("com.comtop.cap.test.robot.queryTestResultByTestUuid", param);
        return ret;
    }
    /**
     * @param condition 条件
     * @return 时间条件参数
     */
    public Map<String, Object> wrapTimeParam(Statistics condition) {
        Map<String, Object> param = new HashMap<String, Object>();
        Date startTime = trim(condition.getStartTime());
        Date endTime = end(condition.getEndTime());
        param.put("startDateStr", FORMATTER.format(startTime));
        param.put("endDateStr", FORMATTER.format(endTime));
        param.put("startTime", startTime);
        param.put("endTime", endTime);
        return param;
    }
    
    /**
     * @param date 日期
     * @return 将时、分、秒置为0
     */
    public static Date trim(Date date) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.set(Calendar.HOUR_OF_DAY, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.MILLISECOND, 0);
        return calendar.getTime();
    }
    
    /**
     * @param date 日期
     * @return 将时、分、秒置为0
     */
    public static Date end(Date date) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.set(Calendar.HOUR_OF_DAY, 24);
        calendar.set(Calendar.MINUTE, 59);
        calendar.set(Calendar.SECOND, 59);
        calendar.set(Calendar.MILLISECOND, 999);
        return calendar.getTime();
    }
}
