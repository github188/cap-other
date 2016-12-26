/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.design.generate;

import java.util.List;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import com.comtop.cap.test.design.model.TestCase;

/**
 * 测试用例生成器
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年7月13日 lizhongwen
 * @param <T> 元数据类型
 */
public interface TestcaseGenerator<T extends BaseMetadata> {
    
    /**
     * 生成用例
     *
     * @param metadata 元数据
     * @return 用例集合
     */
    List<TestCase> gen(T metadata);
    
}
