/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.design.generate;

import java.io.StringWriter;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.test.definition.facade.StepFacade;
import com.comtop.cap.test.definition.model.Argument;
import com.comtop.cap.test.definition.model.BasicStep;
import com.comtop.cap.test.definition.model.StepDefinition;
import com.comtop.cap.test.definition.model.StepReference;
import com.comtop.top.core.util.IOUtil;

import freemarker.template.Configuration;
import freemarker.template.Template;

/**
 * 抽象步骤脚本处理器
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年7月8日 lizhongwen
 */
public abstract class AbstractStepScriptHandler implements StepScriptHandler {
    
    /** 日志 */
    private final static Logger logger = LoggerFactory.getLogger(AbstractStepScriptHandler.class);
    
    /**
     * @see com.comtop.cap.test.design.generate.StepScriptHandler#handleStep(com.comtop.cap.test.definition.model.StepReference)
     */
    @Override
    public Script handleStep(StepReference reference) {
        String type = reference.getType();
        StepDefinition definition = getStepFacade().loadStepDefinitionById(type);
        if (definition == null) {
            logger.error("步骤【{}】找不到定义元数据，请检查步骤是否配置正确。", type);
            return null;
        }
        
        Script script = createScript(definition);
        
        List<String> segs = genStepScripts(reference, definition);
        script.addSegments(segs);
        return script;
    }
    
    /**
     * @return 获取步骤接口
     */
    protected abstract StepFacade getStepFacade();
    
    /**
     * 根据步骤定义创建脚本对象
     *
     * @param definition 定义
     * @return 脚本
     */
    protected Script createScript(StepDefinition definition) {
        Script script = new Script();
        if (definition.getLibraries() != null) {
            script.addLibs(definition.getLibraries());
        }
        if (definition.getResources() != null) {
            script.addResources(definition.getResources());
        }
        if (definition instanceof BasicStep) {
            BasicStep bs = (BasicStep) definition;
            if (StringUtils.isNotBlank(bs.getSrc())) {
                script.addResource(bs.getSrc());
            }
        }
        return script;
    }
    
    /**
     * 生成步骤脚本
     *
     * @param reference 步骤引用
     * @param definition 步骤定义
     * @return 脚本集合
     */
    protected abstract List<String> genStepScripts(StepReference reference, StepDefinition definition);
    
    /**
     * 将参数转换为Map结构
     *
     * @param arguments 参数集合
     * @return map结构的参数
     */
    protected Map<String, String> argumentsToMap(List<Argument> arguments) {
        Map<String, String> args = new HashMap<String, String>();
        if (arguments != null) {
            for (Argument argument : arguments) {
                args.put(argument.getName(), argument.getValue());
            }
        }
        return args;
    }
    
    /**
     * 处理脚本
     *
     * @param macro 脚本模板
     * @param args 脚本参数
     * @return 脚本集合
     */
    protected List<String> handleScript(String macro, Map<String, String> args) {
        String ret = genScript(macro, args);
        List<String> temp = new LinkedList<String>();
        if (StringUtils.isBlank(ret)) {
            logger.error("步骤脚本错误【{}】，请检查步骤脚本是否配置正确。", macro);
        }
        String[] parts = ret.split("\n");
        if (parts != null && parts.length > 0) {
            for (String part : parts) {
                if (StringUtils.isNotBlank(part)) {
                    temp.add(GAP + part.trim());
                }
            }
        }
        return temp;
    }
    
    /**
     * 生成脚本
     *
     * @param macro 脚本模板
     * @param args 参数
     * @return 脚本
     */
    private String genScript(String macro, Map<String, String> args) {
        Configuration config = new Configuration();
        Template template;
        StringWriter writer = null;
        String str = null;
        try {
            writer = new StringWriter();
            template = new Template("gen_script", macro, config);
            template.process(args, writer);
            str = writer.getBuffer().toString();
            str = str.replace("\r", "\n").replace("\n\n", "\n");
        } catch (Exception e) {
            logger.error("根据规则生成编码出错:" + e);
        } finally {
            IOUtil.closeQuietly(writer);
        }
        return str;
    }
    
}
