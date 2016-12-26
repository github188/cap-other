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

import com.comtop.cap.test.definition.facade.StepFacade;
import com.comtop.cap.test.definition.model.StepDefinition;
import com.comtop.cap.test.definition.model.StepReference;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 基本步骤脚本处理器
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年7月8日 lizhongwen
 */
@PetiteBean
public class BasicStepScriptHandler extends AbstractStepScriptHandler {
    
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
        Map<String, String> args = this.argumentsToMap(reference.getArguments());
        args.put("desc", reference.getDescription());
        String macro = definition.getMacro();
        if (StringUtils.isNotBlank(macro)) {
            segs.addAll(handleScript(macro, args));
        }
        return segs;
    }
    
    /**
     * @see com.comtop.cap.test.design.generate.AbstractStepScriptHandler#getStepFacade()
     */
    @Override
    protected StepFacade getStepFacade() {
        return stepFacade;
    }
    
}
