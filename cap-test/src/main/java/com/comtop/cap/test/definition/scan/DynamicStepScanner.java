/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.definition.scan;

import java.util.Map;

import com.comtop.cap.test.definition.model.DynamicStep;

/**
 * 动态步骤扫描器
 * 注意:实现类需要加上@PetiteBean注释，这样才能将实现类注入到Jodd容器中。
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年7月7日 lizhongwen
 */
public interface DynamicStepScanner {
    
    /**
     * 扫描并生成动态步骤
     * 
     * @param stepId 步骤Id
     * @param args 参数
     * @return 组装完成后的动态步骤
     */
    DynamicStep scan(String stepId, Map<String, String> args);
}
