/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.design.generate;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.common.storage.exception.ValidateException;
import com.comtop.cap.runtime.base.util.BeanContextUtil;
import com.comtop.cap.test.definition.model.StepReference;
import com.comtop.cap.test.definition.model.StepType;
import com.comtop.cap.test.design.facade.VersionFacade;
import com.comtop.cap.test.design.model.Line;
import com.comtop.cap.test.design.model.Step;
import com.comtop.cap.test.design.model.TestCase;
import com.comtop.cap.test.design.model.Version;
import com.comtop.cap.test.preference.facade.TestmodelDicItemFacade;
import com.comtop.cap.test.preference.model.TestmodelDicItemVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;

/**
 * 测试代码生成器
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年7月8日 lizhongwen
 */
@PetiteBean
public final class ScriptGenerator {
    
    /** 日志 */
    private final static Logger logger = LoggerFactory.getLogger(ScriptGenerator.class);
    
    /** 设置 */
    private final static String SETTINGS = "*** Settings ***";
    
    /** 字符 */
    private final static String CODING = "# -*- coding: utf-8 -*-";
    
    /** 库前缀 */
    private final static String LIB_PREFIX = "Library";
    
    /** py库前缀 */
    private final static String LIB_SUFFIX_PY = ".py";
    
    /** 资源前缀 */
    private final static String RES_PREFIX = "Resource";
    
    /** 变量前缀 */
    private final static String VAR_PREFIX = "Variables";
    
    /** 用例 */
    private final static String CASES = "*** Test Cases ***";
    
    /** 间隔 */
    private final static String GAP = "   ";
    
    /** 版本管理 */
    protected VersionFacade versionFacade = BeanContextUtil.getBean(VersionFacade.class);
    
    /** 数据字典 */
    protected TestmodelDicItemFacade dicItemFacade = BeanContextUtil.getBean(TestmodelDicItemFacade.class);
    
    /** 步骤接口 */
    protected StepHandlerContext context = BeanContextUtil.getBean(StepHandlerContext.class);
    
    /**
     * 生成测试脚本
     *
     * @param testcase 测试用例
     * @throws ValidateException 验证错误
     */
    public void generate(TestCase testcase) throws ValidateException {
        List<Step> steps = reSortSteps(testcase);
        if (steps == null || steps.isEmpty()) {
            logger.error("测试用例中没有配置任何测试步骤，不能生成测试代码！");
            return;
        }
        String testcaseId = testcase.getModelId();
        Version version = versionFacade.loadVersion(testcaseId);
        long genTime = 0l;
        if (version == null) {
            version = versionFacade.updateVersion(testcaseId, testcase.getName());
        } else {
            genTime = version.getGenTime();
        }
        // 设置脚本序号
        version.setScriptName(testcase.getScriptName());
        File scriptFile = versionFacade.scriptFile(version);
        Script script = new Script(testcase.getName());
        String folder = version.getScriptFolder();
        int len = folder.split("/").length - 1;
        String resPrefix = "";
        for (int i = 0; i < len; i++) {
            resPrefix += "../";
        }
        StepScriptHandler handler;
        for (Step step : steps) {
            StepReference reference = step.getReference();
            if (reference == null) {
                continue;
            }
            StepType stepType = step.getType();
            reference.setDescription(step.getDescription());
            handler = context.stepScriptHandler(stepType);
            if (handler == null) {
                logger.error("找不到步骤类型为\"{}\"的处理类!", stepType.getDescription());
                continue;
            }
            script.merge(handler.handleStep(reference));
        }
        List<TestmodelDicItemVO> dicItmes = dicItemFacade.queryDicList();
        if (dicItmes != null && !dicItmes.isEmpty()) {
            TestmodelDicItemVO item = dicItmes.get(0);
            Timestamp stamp = item.getUpdateTime();
            if (stamp == null || stamp.getTime() > genTime) {
                this.updateVariables(dicItmes);
            }
        }
        script.addVariable(VersionFacade.VARIABLES_NAME);
        writeScript(resPrefix, scriptFile, script);
        versionFacade.updateScriptVersion(testcase.getModelId(), version.getCaseVersion());
    }
    
    /**
     * 更新变量脚本
     *
     * @param dicItmes 字典项
     */
    private void updateVariables(List<TestmodelDicItemVO> dicItmes) {
        File variablesFile = versionFacade.variablesFile();
        if (variablesFile.exists()) {
            variablesFile.delete();
        }
        TestmodelDicItemVO item = dicItmes.get(0);
        Timestamp stamp = item.getUpdateTime();
        long genTime = System.currentTimeMillis();
        if (stamp != null) {
            genTime = stamp.getTime();
        }
        variablesFile.setLastModified(genTime);
        Set<String> itemNames = new HashSet<String>();
        BufferedWriter writer = null;
        OutputStreamWriter osw = null;
        FileOutputStream fos = null;
        try {
            fos = new FileOutputStream(variablesFile);
            osw = new OutputStreamWriter(fos, "UTF-8");
            writer = new BufferedWriter(osw);
            // 写入设置信息
            writer.write(CODING);
            writer.newLine();
            writer.write("import random");
            writer.newLine();
            writer.write("import string");
            writer.newLine();
            writer.write("import os");
            writer.newLine();
            writer.write("os.environ['NLS_LANG'] = 'SIMPLIFIED CHINESE_CHINA.UTF8'");
            writer.newLine();
            writer.flush();
            
            // 写入用例信息
            String name;
            // String type;
            for (TestmodelDicItemVO dicItem : dicItmes) {
                name = dicItem.getDictionaryCode();
                // type = dicItem.getDictionaryType();
                itemNames.add(name);
                writer.write(name + " = u\"" + dicItem.getDictionaryValue() + "\"");
                writer.newLine();
            }
            writer.flush();
            StringBuffer buffer = new StringBuffer();
            for (String itemName : itemNames) {
                buffer.append(",");
                buffer.append("'");
                buffer.append(itemName);
                buffer.append("'");
            }
            writer.write("_all_ =[" + buffer.substring(1).toString() + "]");
            writer.newLine();
            writer.flush();
        } catch (IOException e) {
            logger.error("将脚本写入文件出错。", e);
        } finally {
            IOUtils.closeQuietly(fos);
            IOUtils.closeQuietly(osw);
            IOUtils.closeQuietly(writer);
        }
        
    }
    
    /**
     * 根据连线关系确定步骤的先后顺序
     *
     * @param testcase 测试用例
     * @return 步骤集合
     */
    private List<Step> reSortSteps(TestCase testcase) {
        List<Step> steps = testcase.getSteps();
        if (steps == null || steps.isEmpty()) {
            return null;
        }
        List<Line> lines = testcase.getLines();
        if (lines == null || lines.isEmpty()) {
            return steps;
        }
        String fromId;
        Map<String, Step> stepMap = new HashMap<String, Step>();
        for (Step step : steps) {
            stepMap.put(step.getId(), step);
        }
        Map<String, Line> lineMap = new HashMap<String, Line>();
        for (Line line : lines) {
            lineMap.put(line.getForm(), line);
        }
        Set<String> toIds = new HashSet<String>();
        Set<String> fromIds = new HashSet<String>();
        for (Line line : lines) {
            toIds.add(line.getTo());
            fromIds.add(line.getForm());
        }
        String startId = null;
        for (Line line : lines) {
            fromId = line.getForm();
            if (toIds.contains(fromId)) {
                continue;
            }
            startId = fromId;
            break;
        }
        String endId = null;
        String toId;
        for (Line line : lines) {
            toId = line.getTo();
            if (fromIds.contains(toId)) {
                continue;
            }
            endId = toId;
            break;
        }
        if (startId == null || endId == null) {
            logger.error("步骤节点顺序错误，该测试用例【{}】的步骤形成了闭环!", testcase.getName());
            return null;
        }
        Line line;
        LinkedList<Step> ordered = new LinkedList<Step>();
        while ((line = lineMap.get(startId)) != null) {
            ordered.addLast(stepMap.get(startId));
            startId = line.getTo();
            if (endId.equals(startId)) {
                ordered.addLast(stepMap.get(startId));
            }
        }
        return ordered;
    }
    
    /**
     * 写入脚本
     * 
     * @param prefix 资源前缀
     * @param scriptFile 脚本文件
     * @param script 脚本
     */
    public void writeScript(String prefix, File scriptFile, Script script) {
        BufferedWriter writer = null;
        OutputStreamWriter osw = null;
        FileOutputStream fos = null;
        File bak = null;
        try {
            if (!scriptFile.getParentFile().exists()) {
                scriptFile.getParentFile().mkdirs();
            }
            // 备份
            if (scriptFile.exists()) {
                bak = new File(scriptFile.getAbsolutePath() + ".bak");
                scriptFile.renameTo(bak);
            }
            fos = new FileOutputStream(scriptFile);
            osw = new OutputStreamWriter(fos, "UTF-8");
            writer = new BufferedWriter(osw);
            // 写入设置信息
            writer.write(SETTINGS);
            writer.newLine();
            if (script.getLibs() != null) {
                for (String lib : script.getLibs()) {
                    writer.append(LIB_PREFIX + GAP + GAP);
                    if (lib.endsWith(LIB_SUFFIX_PY)) { // 处理自定义库的引用。
                        writer.append(prefix);
                    }
                    writer.append(lib);
                    writer.newLine();
                }
            }
            if (script.getResources() != null) {
                for (String res : script.getResources()) {
                    writer.append(RES_PREFIX + GAP + GAP + prefix + res);
                    writer.newLine();
                }
            }
            if (script.getVariables() != null) {
                for (String var : script.getVariables()) {
                    writer.append(VAR_PREFIX + GAP + GAP + prefix + var);
                    writer.newLine();
                }
            }
            writer.newLine();
            writer.flush();
            
            // 写入用例信息
            writer.append(CASES);
            writer.newLine();
            writer.append(script.getName()); // TODO 处理用例说明
            writer.newLine();
            if (script.getSegments() != null) {
                for (String segment : script.getSegments()) {
                    writer.append(segment);
                    writer.newLine();
                }
            }
            writer.flush();
            // 删除备份
            if (bak != null && bak.exists()) {
                bak.delete();
            }
        } catch (IOException e) {
            logger.error("将脚本写入文件出错。", e);
            // 恢复备份文件
            if (bak != null && bak.exists()) {
                bak.renameTo(scriptFile);
            }
            // TODO 抛出异常
        } finally {
            IOUtils.closeQuietly(fos);
            IOUtils.closeQuietly(osw);
            IOUtils.closeQuietly(writer);
        }
    }
}
