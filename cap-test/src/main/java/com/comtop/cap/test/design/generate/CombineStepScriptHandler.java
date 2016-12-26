/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.design.generate;

import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.test.definition.facade.StepFacade;
import com.comtop.cap.test.definition.model.Argument;
import com.comtop.cap.test.definition.model.StepDefinition;
import com.comtop.cap.test.definition.model.StepReference;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 组合步骤处理器
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年7月8日 lizhongwen
 */
@PetiteBean
public class CombineStepScriptHandler extends AbstractStepScriptHandler {
    
    /** 日志 */
    private final static Logger logger = LoggerFactory.getLogger(CombineStepScriptHandler.class);
    
    /** 步骤接口 */
    @PetiteInject
    protected StepFacade stepFacade;
    
    /**
     * 
     * @see com.comtop.cap.test.design.generate.AbstractStepScriptHandler#genStepScripts(com.comtop.cap.test.definition.model.StepReference,
     *      com.comtop.cap.test.definition.model.StepDefinition)
     */
    @Override
    protected List<String> genStepScripts(StepReference reference, StepDefinition definition) {
        List<String> segs = new LinkedList<String>();
        segs.add(GAP + COMMENT_PREFIX + reference.getDescription());
        Map<String, String> globals = argumentsToMap(reference.getArguments());
        List<StepReference> children = reference.getSteps();
        if (children == null || children.isEmpty()) {
            return segs;
        }
        StepDefinition def;
        Map<String, String> childArgs;
        for (StepReference child : children) {
            def = getStepFacade().loadStepDefinitionById(child.getType());
            if (def == null) {
                logger.error("找不到步骤定义【{0}】，请检查组合步骤【{1}】的配置！", child.getType(), definition.getName());
                continue;
            }
            childArgs = argumentsToMap(child.getArguments());
            childArgs.put("desc", child.getDescription());
            List<Argument> childArguments = def.getArguments();
            if (childArguments != null) {
                for (Argument argument : childArguments) {
                    String key = argument.getName();
                    if (childArgs.containsKey(key)) {
                        continue;
                    }
                    Argument a = child.findAugumentByName(key);
                    String ref = a.getReference();
                    if (StringUtils.isNotBlank(ref) && globals.containsKey(ref)) {
                        childArgs.put(key, globals.get(ref));
                        continue;
                    }
                    if (globals.containsKey(key)) {
                        childArgs.put(key, globals.get(key));
                        continue;
                    }
                    logger.error("步骤【{0}】，缺少参数【{1}】的配置！", def.getDefinition(), key);
                }
            }
            String macro = def.getMacro();
            if (StringUtils.isNotBlank(macro)) {
                segs.addAll(handleScript(macro, childArgs));
            }
        }
        
        return segs;
    }
    
    /**
     * 
     * @see com.comtop.cap.test.design.generate.AbstractStepScriptHandler#getStepFacade()
     */
    @Override
    protected StepFacade getStepFacade() {
        return stepFacade;
    }
    
}
