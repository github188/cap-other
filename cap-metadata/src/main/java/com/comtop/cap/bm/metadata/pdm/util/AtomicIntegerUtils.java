/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.pdm.util;

import java.util.concurrent.atomic.AtomicInteger;

/**
 * PDM导入帮助类
 * 
 * 
 * @author 陈志伟
 * @since 1.0
 * @version 2015-10-12 陈志伟
 */
public class AtomicIntegerUtils {
    
    /** 自增长数 用于生成localID */
    private static AtomicInteger atomic = new AtomicInteger(10);
    
    /** 自增长数 用于生成关联关系的名称 */
    private static AtomicInteger atomicReference = new AtomicInteger(1);
    
    /**
     * 获取LocalID
     *
     * @return LocalID
     */
    public static String getLocalID() {
        return "o" + atomic.incrementAndGet();
    }
    
    /**
     * 获取关联关系的名称
     *
     * @return 关联关系的名称
     */
    public static String getReferenceName() {
        return "Reference_" + atomicReference.incrementAndGet();
    }
    
}
