/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.design.practice.api;

import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cap.test.definition.model.Practice;
import com.comtop.cap.test.design.model.TestCase;

/**
 * API测试用例生成器接口
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年7月12日 lizhongwen
 */
public interface APITestcaseGenerater {
    
    /**
     * 生成测试用例
     * 
     * @param practice 最佳实践
     * @param tc 测试用例
     * @param entity 实体
     */
    void genTestcase(Practice practice, TestCase tc, EntityVO entity);
}
