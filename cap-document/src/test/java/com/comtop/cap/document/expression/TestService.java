/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.document.expression.annotation.DocumentService;

/**
 * 测试服务
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月16日 lizhongwen
 */
@DocumentService(name = "Test", dataType = TestVO.class)
public class TestService {
    
    /** 数据 */
    private static List<TestVO> tests;
    
    static {
        tests = new ArrayList<TestVO>();
        tests.add(new TestVO("abc"));
        tests.add(new TestVO("dddd"));
        tests.add(new TestVO("bbbb"));
        tests.add(new TestVO("cccc"));
        tests.add(new TestVO("eeee"));
        tests.add(new TestVO("fff"));
        tests.add(new TestVO("abafac"));
    }
    
    /**
     * 根据条件加载VO
     *
     * @param test 条件
     * @return vo
     */
    public List<TestVO> loadTestList(TestVO test) {
        List<TestVO> result = new ArrayList<TestVO>();
        if (test != null && StringUtils.isNotBlank(test.getName())) {
            for (TestVO testVO : tests) {
                if (testVO.getName().contains(test.getName())) {
                    result.add(testVO);
                }
            }
            return result;
        }
        return tests;
    }
    
    /**
     * 根据条件加载VO
     *
     * @param vos 数据
     */
    public void saveTestList(List<TestVO> vos) {
        for (TestVO test : vos) {
            int index = getIndex(test);
            if (index == -1) {
                tests.add(test);
            } else {
                tests.add(index, test);
            }
        }
        System.out.println(Arrays.toString(tests.toArray()));
    }
    
    /**
     * @param test 数据
     * @return 索引
     */
    private int getIndex(TestVO test) {
        for (int index = 0; index < tests.size(); index++) {
            TestVO vo = tests.get(index);
            if (vo.getName().equals(test.getName())) {
                return index;
            }
        }
        return -1;
    }
}
