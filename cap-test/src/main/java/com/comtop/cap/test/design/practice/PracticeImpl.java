/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.design.practice;

import java.util.Map;

import com.comtop.cap.test.design.model.TestCase;

/**
 * 最佳实践实现接口
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年7月7日 lizhongwen
 */
public interface PracticeImpl {
    
    /**
     * 实现最佳实践，并转换为测试用例
     * 
     * @param practiceId 最佳实践Id
     * @param testcase 测试用例
     * @param args 参数
     * @return 测试用例
     */
    TestCase impl(String practiceId, TestCase testcase, Map<String, String> args);
}
