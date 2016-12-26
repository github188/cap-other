/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.robot.action;

import java.util.List;

import com.comtop.cap.runtime.base.util.BeanContextUtil;
import com.comtop.cap.test.robot.facade.TestResultAnalyseFacade;
import com.comtop.cap.test.robot.model.Statistics;
import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;

/**
 * 测试结果分析Action
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年9月28日 lizhongwen
 */
@DwrProxy
public class TestResultAnalyseAction {
    
    /**
     * facade层 面向接口开发
     * 注入ModuleFacade
     */
    protected TestResultAnalyseFacade analyseFacade = BeanContextUtil.getBean(TestResultAnalyseFacade.class);
    
    /**
     * @param condition 查询条件
     * @return 按周获取测试结果统计
     */
    @RemoteMethod
    public List<Statistics> queryTestResultStatisticsByWeek(Statistics condition) {
        return analyseFacade.queryTestResultStatisticsByWeek(condition);
    }
    
    /**
     * @param condition 查询条件
     * @return 按月获取测试结果统计
     */
    @RemoteMethod
    public List<Statistics> queryTestResultStatisticsByMonth(Statistics condition) {
        return analyseFacade.queryTestResultStatisticsByMonth(condition);
    }
    
    /**
     * @param condition 查询条件
     * @return 查询最好或者最差的排名
     */
    @RemoteMethod
    public List<Statistics> queryTopTestResultStatistics(Statistics condition) {
        return analyseFacade.queryTopTestResultStatistics(condition);
    }
    
    /**
     * @param condition 查询条件
     * @return 按模块获取测试结果统计
     */
    @RemoteMethod
    public List<Statistics> queryTestResultStatisticsByModule(Statistics condition) {
        return analyseFacade.queryTestResultStatisticsByModule(condition);
    }
    
    /***
     * 是否存在指定test-UUID的测试数据
     * 
     * @param testUuid 测试uuid。不可为空
     * @return 如果存在则返回true,否则返回false(uuid为空\null也返回false)
     */
    @RemoteMethod
    public boolean isExistTestuuidData(String testUuid) {
        return analyseFacade.isExistTestuuidData(testUuid);
    }
    
    /***
     * 指定的testUuid是否存在测试失败的数据
     * 
     * @param testUuid testUuid 测试uuid。不可为空
     * @return 当且仅当有测试数据失败时返回true；否则返回false(没有指定uuid的测试数据、指定uuid的测试数据不存在失败、指定uuid为空\null也返回false)
     */
    @RemoteMethod
    public boolean isExistFailDataByTestUuid(String testUuid) {
        return analyseFacade.isExistFailDataByTestUuid(testUuid);
    }
    
    /***
     * 根据测试uuid获取完整的测试报告
     * 
     * @param testUuid 测试uuid。不可为空
     * @return 返回指定uuid的所有测试数据按app_id,meta_name 字段组合排序
     */
    @RemoteMethod
    public List<Statistics> queryTestResultByTestUuid(String testUuid) {
        return analyseFacade.queryTestResultByTestUuid(testUuid);
    }
}
