/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.util;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * id生成器
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年10月23日 lizhiyong
 */
public class IdGenerator {
    
    /** id生成器集合 */
    private static final Map<String, AtomicInteger> idKeyMap = new HashMap<String, AtomicInteger>();
    
    /**
     * 获得下一上排序号
     *
     * @param group 组号
     * @return 下一个id值
     */
    public static int getNextSortNo(String group) {
        return getNextSortNo(group, 1, 1);
    }
    
    /**
     * 获得下一次排序号
     *
     * @param group 组号
     * @param initValue 初始值
     * @param step 步长
     * @return 下一个id值
     */
    public static int getNextSortNo(String group, int initValue, int step) {
        AtomicInteger atomicInteger = idKeyMap.get(group);
        if (atomicInteger == null) {
            atomicInteger = new AtomicInteger(initValue);
            idKeyMap.put(group, atomicInteger);
        }
        return atomicInteger.getAndAdd(step);
    }
    
    /**
     * 获得对象的id
     *
     * @param clazz 对象类型
     * @return id字符串
     */
    public static String getObjectId(Class<?> clazz) {
        String uuid = getUUID();
        return clazz == null ? uuid : clazz.getSimpleName() + "-" + uuid;
    }
    
    /**
     * 获得UUID
     *
     * @return UUID值
     */
    public static String getUUID() {
        return UUID.randomUUID().toString().toUpperCase().replaceAll("-", "");
    }
}
