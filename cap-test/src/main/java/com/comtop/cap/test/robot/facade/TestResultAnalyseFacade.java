/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.robot.facade;

import java.util.ArrayList;
import java.util.List;

import com.comtop.cap.test.robot.appservice.TestResultAnalyseAppService;
import com.comtop.cap.test.robot.model.Statistics;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 测试结果分析接口
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年9月28日 lizhongwen
 */
@PetiteBean
public class TestResultAnalyseFacade {
    
    /**
     * facade层 面向接口开发
     * 注入ModuleFacade
     */
    @PetiteInject
    protected TestResultAnalyseAppService analyseAppService;
    
    /**
     * @param condition 查询条件
     * @return 按周获取测试结果统计
     */
    public List<Statistics> queryTestResultStatisticsByWeek(Statistics condition) {
        return analyseAppService.queryTestResultStatisticsByWeek(condition);
    }
    
    /**
     * @param condition 查询条件
     * @return 按月获取测试结果统计
     */
    public List<Statistics> queryTestResultStatisticsByMonth(Statistics condition) {
        return analyseAppService.queryTestResultStatisticsByMonth(condition);
    }
    
    /**
     * @param condition 查询条件
     * @return 查询最好或者最差的排名
     */
    public List<Statistics> queryTopTestResultStatistics(Statistics condition) {
        return analyseAppService.queryTopTestResultStatistics(condition);
    }
    
    /**
     * @param condition 查询条件
     * @return 按模块获取测试结果统计
     */
    public List<Statistics> queryTestResultStatisticsByModule(Statistics condition) {
        return analyseAppService.queryTestResultStatisticsByModule(condition);
    }
 
    /**
     * 根据测试用例名称获取测试结果
     * 
     * @param lstTestCaseName 测试用例名称集合
     * @param packageId 应用Id
     * @return 测试结果
     */
    public List<Statistics> queryTestResultByTestCaseName(List<String> lstTestCaseName, String packageId) {
        return analyseAppService.queryTestResultByTestCaseName(lstTestCaseName, packageId);
    }
    
    
    
    /***
     * 是否存在指定test-UUID的测试数据
     * @param testUuid 测试uuid。不可为空
     * @return 如果存在则返回true,否则返回false(uuid为空\null也返回false)
     */
    public boolean isExistTestuuidData(String testUuid){
    	if(null==testUuid||testUuid.trim().isEmpty()){
    		return false;
    	}
    	return analyseAppService.isExistTestuuidData(testUuid);
    }
    /***
     * 指定的testUuid是否存在测试失败的数据
     * @param testUuid testUuid 测试uuid。不可为空
     * @return 当且仅当有测试数据失败时返回true；否则返回false(没有指定uuid的测试数据、指定uuid的测试数据不存在失败、指定uuid为空\null也返回false)
     */
    public boolean isExistFailDataByTestUuid(String testUuid){
    	//存在指定uuid的测试数据时，再继续分析是否存在测试失败的数据
    	if(isExistTestuuidData(testUuid)){
    		return analyseAppService.isExistFailDataByTestUuid(testUuid);
    	}
    	return false;
    }
    
    /***
     * 根据测试uuid获取完整的测试报告
     * @param testUuid  测试uuid。不可为空
     * @return 返回指定uuid的所有测试数据按app_id,meta_name 字段组合排序
     */
    public List<Statistics> queryTestResultByTestUuid(String testUuid){
    	if(null==testUuid||testUuid.trim().isEmpty()){
    		return new ArrayList<Statistics>();
    	}
    	return analyseAppService.queryTestResultByTestUuid(testUuid);
    }
    
}
