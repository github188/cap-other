/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.design.generate;

import com.comtop.cap.test.definition.model.StepType;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 步骤处理器上下文
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年7月8日 lizhongwen
 */
@PetiteBean
public class StepHandlerContext {
    
    /** 基本步骤脚本处理器 */
    @PetiteInject
    private BasicStepScriptHandler basicHandler;
    
    /** 基本步骤脚本处理器 */
    @PetiteInject
    private CombineStepScriptHandler combineHandler;
    
    /**
     * @param type 步骤类型
     * @return 步骤脚本处理器
     */
    public StepScriptHandler stepScriptHandler(StepType type) {
        switch (type) {
            case BASIC:
                return basicHandler;
            case FIXED:
            case DYNAMIC:
                return combineHandler;
            default:
                break;
        }
        return null;
    }
}
