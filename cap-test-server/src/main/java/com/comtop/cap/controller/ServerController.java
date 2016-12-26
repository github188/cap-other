/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.FileSystems;
import java.nio.file.Path;
import java.util.List;

import org.apache.commons.io.FileUtils;
import org.apache.ftpserver.FtpServer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.comtop.cap.actuator.CommondActuator;
import com.comtop.cap.domain.AppServerInfo;
import com.comtop.cap.domain.ExecStatus;
import com.comtop.cap.domain.ServerStatus;
import com.comtop.cap.report.domain.Robot;
import com.comtop.cap.report.domain.Statistics;
import com.comtop.cap.report.domain.TestResult;
import com.comtop.cap.report.service.ReportService;
import com.comtop.cap.utils.ZipUtils;

/**
 * 服务器API
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年8月19日 lizhongwen
 */
@CrossOrigin
@RestController
public class ServerController {
    
    /** FTP服务器 */
    @Autowired
    private FtpServer ftpServer;
    
    /** 名利执行器 */
    @Autowired
    private CommondActuator actuator;
    
    /** 测试报告服务 */
    @Autowired
    private ReportService reportService;
    
    /** 测试用例根目录 */
    @Value("${ftp.home}")
    private String home;
    
    /**
     * @param condition 查询条件
     * @return 按周获取测试结果统计
     */
    @RequestMapping(path = "/testcase/testResultByWeek", method = { RequestMethod.POST, RequestMethod.GET })
    public List<TestResult> queryTestResultStatisticsByWeek(TestResult condition) {
        return reportService.queryTestResultStatisticsByWeek(condition);
    }
    
    /**
     * @param condition 查询条件
     * @return 按月获取测试结果统计
     */
    @RequestMapping(path = "/testcase/testResultByMonth", method = { RequestMethod.POST, RequestMethod.GET })
    public List<TestResult> queryTestResultStatisticsByMonth(TestResult condition) {
        return reportService.queryTestResultStatisticsByMonth(condition);
    }
    
    /**
     * @param condition 查询条件
     * @return 查询最好或者最差的排名
     */
    @RequestMapping(path = "/testcase/topTestResult", method = { RequestMethod.POST, RequestMethod.GET })
    public List<TestResult> queryTopTestResultStatistics(TestResult condition) {
        return reportService.queryTopTestResultStatistics(condition);
    }
    
    /**
     * @param condition 查询条件
     * @return 按模块获取测试结果统计
     */
    @RequestMapping(path = "/testcase/testResultByModule", method = { RequestMethod.POST, RequestMethod.GET })
    public List<TestResult> queryTestResultStatisticsByModule(TestResult condition) {
        return reportService.queryTestResultStatisticsByModule(condition);
    }
    
    /**
     * @param lstTestCaseName 查询条件
     * @param packageId 应用Id
     * @return 按测试用例名称获取测试结果统计
     */
    @RequestMapping(path = "/testcase/testResultByCaseName", method = { RequestMethod.POST, RequestMethod.GET })
    public List<TestResult> queryTestResultByTestCaseName(String[] lstTestCaseName, String packageId) {
        return reportService.queryTestResultByTestCaseName(lstTestCaseName, packageId);
    }
    
    /**
     * 根据测试编号获取测试用例集合数据
     * 
     * @param testUuid 测试编号
     * @return 测试结果集
     */
    @RequestMapping(path = "/testcase/testResult/{testUuid}", method = { RequestMethod.POST, RequestMethod.GET })
    public List<TestResult> queryTestResultByTestUuid(@PathVariable String testUuid) {
        return reportService.queryTestResultByTestUuid(testUuid);
    }
    
    /***
     * 是否存在指定test-UUID的测试数据
     * 
     * @param testUuid 测试uuid。不可为空
     * @return 如果存在则返回true,否则返回false(uuid为空\null也返回false)
     */
    @RequestMapping(path = "/testcase/existTest/{testUuid}", method = { RequestMethod.POST, RequestMethod.GET })
    public boolean isExistTestuuidData(@PathVariable String testUuid) {
        return reportService.isExistTestuuidData(testUuid);
    }
    
    /***
     * 指定的testUuid是否存在测试失败的数据
     * 
     * @param testUuid testUuid 测试uuid。不可为空
     * @return 当且仅当有测试数据失败时返回true；否则返回false(没有指定uuid的测试数据、指定uuid的测试数据不存在失败、指定uuid为空\null也返回false)
     */
    @RequestMapping(path = "/testcase/existFailTest/{testUuid}", method = { RequestMethod.POST, RequestMethod.GET })
    public boolean isExistFailDataByTestUuid(@PathVariable String testUuid) {
        return reportService.isExistFailDataByTestUuid(testUuid);
    }
    
    /**
     * FTP服务器状态
     * 
     * @return FTP服务器状态
     */
    @RequestMapping(path = "/server/status", method = { RequestMethod.POST, RequestMethod.GET })
    public @ResponseBody ServerStatus serverStatus() {
        ServerStatus status = ServerStatus.STARTED;
        if (ftpServer.isStopped()) {
            status = ServerStatus.STOPPED;
        } else if (ftpServer.isSuspended()) {
            status = ServerStatus.SUSPENDED;
        }
        return status;
    }
    
    /**
     * 测试用例执行
     * 
     * @param info 服务器信息
     * @return 执行编号
     */
    @RequestMapping(path = "/testcase/exec", method = { RequestMethod.POST, RequestMethod.GET })
    public String execTestcase(AppServerInfo info) {
        File file = new File(home);
        if (!file.exists()) {
            return null;
        }
        Path varPath = FileSystems.getDefault().getPath(home, "variables.py");
        File varFile = varPath.toFile();
        if (info != null && varFile.exists()) {
            actuator.updateVariables(varFile, info);
        }
        String ret = System.currentTimeMillis() + "";
        String logPath = file.getParent() + File.separator + "testcase-logs" + File.separator + ret;
        actuator.updateExecStatus(logPath, ExecStatus.WAIT);
        Runnable run = new Runnable() {
            
            @Override
            public void run() {
                actuator.updateExecStatus(logPath, ExecStatus.EXECING);
                try {
                    actuator.executeTest(home, logPath);
                } catch (Exception e) {
                    e.printStackTrace();
                    actuator.updateExecStatus(logPath, ExecStatus.FAILD);
                }
                actuator.updateExecStatus(logPath, ExecStatus.EXECED);
                reportService.saveTestResult(ret);
            }
        };
        Thread t = new Thread(run);
        t.setDaemon(true);
        t.start();
        return ret;
    }
    
    /**
     * 测试用例执行状态
     * 
     * @param execNo 执行编号
     * @return 执行编号
     */
    @RequestMapping(path = "/testcase/status/{execNo}", method = { RequestMethod.POST, RequestMethod.GET })
    public ExecStatus execStatus(@PathVariable String execNo) {
        String logPath = new File(home).getParent() + File.separator + "testcase-logs" + File.separator + execNo;
        return actuator.readExecStatus(logPath);
    }
    
    /**
     * 测试用例执行
     *
     * @param execNo 执行编号
     * @return 文件
     * @throws IOException IO异常
     */
    @RequestMapping(path = "/testcase/download/{execNo}", method = { RequestMethod.POST, RequestMethod.GET })
    public ResponseEntity<byte[]> downloadTestcaseResult(@PathVariable String execNo) throws IOException {
        String logPath = new File(home).getParent() + File.separator + "testcase-logs" + File.separator + execNo;
        File file = new File(logPath);
        if (!file.exists()) {
            return null;
        }
        String zipPath = ZipUtils.zipFile(logPath);
        File zipFile = null;
        if (StringUtils.isEmpty(zipPath)) {
            return null;
        }
        zipFile = new File(zipPath);
        if (!zipFile.exists()) {
            return null;
        }
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
        headers.setContentDispositionFormData("attachment", zipFile.getName());
        return new ResponseEntity<byte[]>(FileUtils.readFileToByteArray(zipFile), headers, HttpStatus.CREATED);
    }
    
    /**
     * 
     * 加载测试结果
     *
     * @param execNo 测试执行编号
     * @return 测试统计结果
     */
    @RequestMapping(path = "/test/statistic/{execNo}", method = { RequestMethod.POST, RequestMethod.GET })
    public Statistics loadTestStatistics(@PathVariable String execNo) {
        Robot robot = reportService.readReport(execNo);
        return robot == null ? null : robot.getStatistics();
    }
    
    /**
     * 
     * 加载测试报告
     *
     * @param execNo 测试执行编号
     * @return 测试统计结果
     */
    @RequestMapping(path = "/test/report/{execNo}", method = { RequestMethod.POST, RequestMethod.GET })
    public Robot loadTestReport(@PathVariable String execNo) {
        return reportService.readReport(execNo);
    }
    
    /**
     * 
     * 加载测试报告
     *
     * @param execNo 测试执行编号
     */
    @RequestMapping(path = "/test/saveReport/{execNo}", method = { RequestMethod.POST, RequestMethod.GET })
    public void saveTestReport(@PathVariable String execNo) {
        reportService.saveTestResult(execNo);
    }
    
}
