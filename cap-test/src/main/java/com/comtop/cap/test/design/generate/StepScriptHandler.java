/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.design.generate;

import com.comtop.cap.test.definition.model.StepReference;

/**
 * 步骤脚本处理器
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年7月8日 lizhongwen
 */
public interface StepScriptHandler {
    
    /** 间隔 */
    final static String GAP = "   ";
    
    /** 注释前缀 */
    final static String COMMENT_PREFIX = "#";
    
    /**
     * 处理基本步骤
     *
     * @param reference 步骤引用
     * @return 脚本
     */
    Script handleStep(StepReference reference);
}
