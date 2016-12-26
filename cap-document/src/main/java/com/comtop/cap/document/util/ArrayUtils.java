/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.util;

import java.util.Arrays;

/**
 * 数组工具类
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年1月12日 lizhongwen
 */
public class ArrayUtils {
    
    /**
     * 确保容器容量
     *
     * @param length 长度
     * @param arrays 容器
     * @return 容器
     */
    public static Object[] ensureCapacity(int length, Object[] arrays) {
        int oldLength = arrays.length;
        if (length >= arrays.length) { // 行数大于初始化行
            Object[] old = arrays;
            int newLength = (oldLength * 3) / 2 + 1;
            if (newLength < length) {
                newLength = length;
            }
            return Arrays.copyOf(old, newLength);
        }
        return arrays;
    }
    
    /**
     * 确保容器容量
     *
     * @param arrays 容器
     * @return 容器
     */
    public static Object[] reduceCapacity(Object[] arrays) {
        if (arrays == null) {
            return null;
        }
        int lastIndex = arrays.length - 1;
        int length = arrays.length;
        for (int i = lastIndex; i >= 0; i--) {
            if (arrays[i] == null) {
                length--;
            } else {
                break;
            }
        }
        if (length <= 0) {
            return null;
        }
        return Arrays.copyOf(arrays, length);
    }
}
