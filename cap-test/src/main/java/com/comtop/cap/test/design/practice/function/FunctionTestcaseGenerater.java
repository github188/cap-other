/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.design.practice.function;

import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.cap.test.definition.model.Practice;
import com.comtop.cap.test.design.model.TestCase;

/**
 * FUNCTION测试用例生成器接口
 *
 * @author zhangzunzhi
 * @since jdk1.6
 * @version 2016年8月2日 zhangzunzhi
 */
public interface FunctionTestcaseGenerater {
    
    /**
     * 生成测试用例
     * 
     * @param practice 最佳实践
     * @param tc 测试用例
     * @param pageVO 页面元数据
     * @param strLayoutId 控件ID
     */
    void genTestcase(Practice practice, TestCase tc, PageVO pageVO, String strLayoutId);
}
