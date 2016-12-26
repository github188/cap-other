/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression.support;

import com.comtop.cap.document.expression.EvaluationException;

/**
 * 类型比较器
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月10日 lizhongwen
 */
public interface TypeComparator {
    
    /**
     * 比较两个对象
     *
     * @param left 第一个对象
     * @param right 第二个对象
     * @return 0表示相等，<0表示第一个对象小于第二个，>0表示第一个对象大于第二个。
     * @throws EvaluationException 对象比较时出现的异常
     */
    int compare(Object left, Object right) throws EvaluationException;
    
    /**
     * 指定的两个对象是否可以进行比较
     *
     * @param left 第一个对象
     * @param right 第二个对象
     * @return true表示这两个对象可以进行比较
     */
    boolean canCompare(Object left, Object right);
}
