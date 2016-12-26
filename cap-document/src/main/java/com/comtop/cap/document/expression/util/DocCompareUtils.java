/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression.util;

import com.comtop.cap.document.expression.annotation.Function;

/**
 * 文档比较函数
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年1月27日 lizhongwen
 */
public class DocCompareUtils {
    
    /**
     * 比较函数
     *
     * @param a a
     * @param b b
     * @return 是否equals
     */
    @Function(name = "equals", description = "是否equals")
    public static boolean equals(Object a, Object b) {
        if (a != null) {
            return a.equals(b);
        } else if (b != null) {
            return Boolean.FALSE;
        }
        return Boolean.TRUE;
    }
    
    /**
     * 比较函数
     *
     * @param a a
     * @param b b
     * @return 是否相同
     */
    @Function(name = "same", description = "是否相同")
    public static boolean same(Object a, Object b) {
        return a == b;
    }
}
