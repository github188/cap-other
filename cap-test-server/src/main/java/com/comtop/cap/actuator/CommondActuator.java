/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.actuator;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.LinkedList;
import java.util.List;

import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.event.Level;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import com.comtop.cap.domain.AppServerInfo;
import com.comtop.cap.domain.ExecStatus;

/**
 * 执行器
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年8月19日 lizhongwen
 */
@Component
public class CommondActuator {
    
    /** 日志 */
    private static final Logger logger = LoggerFactory.getLogger(CommondActuator.class);
    
    /** 执行状态 */
    private static final String EXEC_STATUS = "EXEC_STATUS";
    
    /** 测试用例执行脚本 */
    private static final String TESTCASE_EXE_SCRIPT = "pybot.bat  --outputdir %s %s";
    
    /**
     * 执行测试
     *
     * @param testcaseDirectory 用例目录
     * @param logDirectory 日志目录
     */
    public void executeTest(String testcaseDirectory, String logDirectory) {
        File tcDir = new File(testcaseDirectory);
        if (!tcDir.exists()) {
            logger.error("测试用例目录不存在！");
            throw new RuntimeException("测试用例目录【" + testcaseDirectory + "】不存在！");
        }
        File logDir = new File(logDirectory);
        if (!logDir.exists()) {
            logDir.mkdirs();
        }
        String command = String.format(TESTCASE_EXE_SCRIPT, formatPath(logDirectory), formatPath(testcaseDirectory));
        Runtime rt = Runtime.getRuntime();
        Process proc = null;
        try {
            proc = rt.exec(command);
            ResultHandler stdHandler = new ResultHandler(proc.getInputStream(), Level.INFO);
            ResultHandler errHandler = new ResultHandler(proc.getErrorStream(), Level.ERROR);
            stdHandler.start();
            errHandler.start();
            proc.waitFor();
        } catch (IOException | InterruptedException e) {
            throw new RuntimeException("测试用例执行出错！", e);
        } finally {
            if (proc != null) {
                proc.destroy();
            }
        }
    }
    
    /**
     * 更新参数脚本
     * 
     * @param varFile 参数脚本
     * @param info 更新参数脚本
     */
    public void updateVariables(File varFile, AppServerInfo info) {
        @SuppressWarnings("resource")
        FileWriter writer = null;
        try (FileReader reader = new FileReader(varFile); BufferedReader br = new BufferedReader(reader);) {
            String line = null;
            List<String> cache = new LinkedList<String>();
            while ((line = br.readLine()) != null) {
                if (StringUtils.hasText(line) && line.contains("=")) {
                    String[] parts = line.split("=");
                    String name = parts[0].trim();
                    if ("url".equals(name)) {
                        line = "url = u'" + info.getUrl() + "'";
                    } else if ("userName".equals(name)) {
                        line = "userName = u'" + info.getUsername() + "'";
                    } else if ("password".equals(name)) {
                        line = "password = u'" + info.getPassword() + "'";
                    }
                }
                cache.add(line);
            }
            IOUtils.closeQuietly(reader);
            IOUtils.closeQuietly(br);
            writer = new FileWriter(varFile);
            for (String l : cache) {
                writer.write(l);
                writer.write("\r\n");
            }
            writer.flush();
        } catch (IOException e) {
            throw new RuntimeException("更新用例参数脚本出错！", e);
        } finally {
            IOUtils.closeQuietly(writer);
        }
    }
    
    /**
     * 更新执行状态
     * 
     * @param root 文件目录
     * @param status 执行状态
     *
     */
    public void updateExecStatus(String root, ExecStatus status) {
        File file = new File(root + File.separator + EXEC_STATUS);
        if (!file.getParentFile().exists()) {
            file.getParentFile().mkdirs();
        }
        try (FileWriter writer = new FileWriter(file)) {
            writer.write(status.name());
            writer.flush();
        } catch (IOException e) {
            throw new RuntimeException("更新执行状态出错！", e);
        }
    }
    
    /**
     * 读取执行状态
     * 
     * @param root 文件目录
     * @return 执行状态
     */
    public ExecStatus readExecStatus(String root) {
        File file = new File(root + File.separator + EXEC_STATUS);
        if (!file.exists()) {
            return ExecStatus.WAIT;
        }
        try (FileReader reader = new FileReader(file); BufferedReader br = new BufferedReader(reader);) {
            String line = br.readLine();
            if (ExecStatus.WAIT.name().equals(line)) {
                return ExecStatus.WAIT;
            } else if (ExecStatus.EXECING.name().equals(line)) {
                return ExecStatus.EXECING;
            } else if (ExecStatus.EXECED.name().equals(line)) {
                return ExecStatus.EXECED;
            } else if (ExecStatus.FAILD.name().equals(line)) {
                return ExecStatus.FAILD;
            }
        } catch (IOException e) {
            throw new RuntimeException("更新执行状态出错！", e);
        }
        return ExecStatus.WAIT;
    }
    
    /**
     * 格式化路径
     *
     * @param path 路径
     * @return 格式化路径
     */
    private String formatPath(String path) {
        return path.replace("\\", "/");
    }
}
