/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.dao;

import java.util.HashMap;
import java.util.Map;

/**
 * 数据访问器工厂
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年11月10日 lizhiyong
 */
public class DataAccessorFactory {
    
    /** 数据访问器集合 */
    private static final Map<String, IWordDataAccessor<?>> DAO_MAP = new HashMap<String, IWordDataAccessor<?>>(10);
    
    /** 通用数据访问器识别码 */
    private static final String COMMON_DATA_ACCESSOR_KEY = "Common";
    
    /** 缺省数据访问器识别码后缀 */
    private static final String COMMON_DATA_ACCESSOR_KEY_SUFFIX = "Facade";
    
    static {
        init();
    }
    
    /**
     * 初始化
     *
     */
    public static void init() {
        DAO_MAP.put(COMMON_DATA_ACCESSOR_KEY, new CommonExtDataAccessor());
    }
    
    /**
     * 注册
     *
     * @param key 识别器
     * @param dataAccessor 数据访问器
     */
    public static void register(String key, IWordDataAccessor<?> dataAccessor) {
        DAO_MAP.put(key, dataAccessor);
    }
    
    /**
     * 获得数据访问器
     *
     * @param key 数据访问器识别码。
     * @return IWordDataAccessor
     */
    public static IWordDataAccessor<?> getDataAccessor(String key) {
        IWordDataAccessor<?> ret = DAO_MAP.get(key);
        return ret == null ? DAO_MAP.get(COMMON_DATA_ACCESSOR_KEY) : ret;
    }
    
    /**
     * 获得数据访问器
     *
     * @param classUri 数据访问器识别码。
     * @return IWordDataAccessor
     */
    public static IWordDataAccessor<?> getDefaultDataAccessor(String classUri) {
        IWordDataAccessor<?> ret = getDataAccessor(classUri);
        if (ret instanceof CommonExtDataAccessor) {
            String defaultKey = classUri + COMMON_DATA_ACCESSOR_KEY_SUFFIX;
            return getDataAccessor(defaultKey);
        }
        return ret;
    }
}
