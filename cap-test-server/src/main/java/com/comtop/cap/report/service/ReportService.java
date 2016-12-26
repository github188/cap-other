/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.report.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.comtop.cap.report.dao.ReportDAO;
import com.comtop.cap.report.domain.Robot;
import com.comtop.cap.report.domain.TestResult;

/**
 * 测试报告服务
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年9月12日 lizhongwen
 */
@Service
public class ReportService {
    
    /** 测试用例根目录 */
    @Value("${ftp.home}")
    private String home;
    
    /** 测试报告服务 */
    @Autowired
    private ReportDAO reportDAO;
    
    /**
     * @param condition 查询条件
     * @return 按周获取测试结果统计
     */
    public List<TestResult> queryTestResultStatisticsByWeek(TestResult condition) {
        return reportDAO.queryTestResultStatisticsByWeek(condition);
    }
    
    /**
     * @param condition 查询条件
     * @return 按月获取测试结果统计
     */
    public List<TestResult> queryTestResultStatisticsByMonth(TestResult condition) {
        return reportDAO.queryTestResultStatisticsByMonth(condition);
    }
    
    /**
     * @param condition 查询条件
     * @return 查询最好或者最差的排名
     */
    public List<TestResult> queryTopTestResultStatistics(TestResult condition) {
        return reportDAO.queryTopTestResultStatistics(condition);
    }
    
    /**
     * @param condition 查询条件
     * @return 按模块获取测试结果统计
     */
    public List<TestResult> queryTestResultStatisticsByModule(TestResult condition) {
        return reportDAO.queryTestResultStatisticsByModule(condition);
    }
    
    /**
     * @param lstTestCaseName 查询条件
     * @param packageId 应用Id
     * @return 测试结果
     */
    public List<TestResult> queryTestResultByTestCaseName(String[] lstTestCaseName, String packageId) {
        return reportDAO.queryTestResultByTestCaseName(lstTestCaseName, packageId);
    }
    
    /**
     * 读取测试报告
     *
     * @param uuid 测试Id
     * @return 测试报告
     */
    public Robot readReport(String uuid) {
        return reportDAO.readReport(uuid);
    }
    
    /**
     * 根据测试ID获取测试数据
     *
     * @param testUuid 测试Id
     * @return 测试报告
     */
    public List<TestResult> queryTestResultByTestUuid(String testUuid) {
        return reportDAO.queryTestResultByTestUuid(testUuid);
    }
    
    /***
     * 是否存在指定test-UUID的测试数据
     * 
     * @param testUuid 测试uuid。不可为空
     * @return 如果存在则返回true,否则返回false(uuid为空\null也返回false)
     */
    public boolean isExistTestuuidData(String testUuid) {
        return reportDAO.isExistTestuuidData(testUuid);
    }
    
    /***
     * 指定的testUuid是否存在测试失败的数据
     * 
     * @param testUuid testUuid 测试uuid。不可为空
     * @return 当且仅当有测试数据失败时返回true；否则返回false(没有指定uuid的测试数据、指定uuid的测试数据不存在失败、指定uuid为空\null也返回false)
     */
    public boolean isExistFailDataByTestUuid(String testUuid) {
        return reportDAO.isExistFailDataByTestUuid(testUuid);
    }
    
    /**
     * 保存测试结果
     *
     * @param uuid 测试Id
     */
    public void saveTestResult(final String uuid) {
        reportDAO.saveTestResult(uuid);
    }
    
}
