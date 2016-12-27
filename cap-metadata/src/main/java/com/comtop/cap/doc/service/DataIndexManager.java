/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.doc.DocServiceException;
import com.comtop.cap.doc.scan.ClassScanner;
import com.comtop.cap.document.word.docmodel.data.BaseDTO;
import com.comtop.cap.runtime.core.AppBeanUtil;

/**
 * 数据索引管理器
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2016年1月29日 lizhiyong
 */
public class DataIndexManager {
    
    /** 日志对象 */
    private static final Logger LOGGER = LoggerFactory.getLogger(DataIndexManager.class);
    
    /** DTO与服务的映射关系 */
    private static final Map<String, IIndexBuilder> TYPE_SERVICE_MAP = new HashMap<String, IIndexBuilder>(32);
    
    /** 数据索引集 */
    private final Map<String, Map<String, String>> dataIndexMapSet = new HashMap<String, Map<String, String>>();
    
    // static {
    // initIndexBuilders();
    // }
    
    /**
     * 初始化
     * 
     *
     */
    private static void initIndexBuilders() {
        String[] regexs = { "com.comtop.cap.doc.**" };
        List<Class<?>> indexBuilderClazzList = ClassScanner.scanClass(regexs);
        for (Class<?> clazz : indexBuilderClazzList) {
            try {
                if (IIndexBuilder.class.isAssignableFrom(clazz)) {
                    @SuppressWarnings("unchecked")
                    Class<? extends IIndexBuilder> clazzIndexBuilder = (Class<? extends IIndexBuilder>) clazz;
                    IndexBuilder builder = clazzIndexBuilder.getAnnotation(IndexBuilder.class);
                    if (builder == null) {
                        continue;
                    }
                    Class<? extends BaseDTO> clazzDTO = builder.dto();
                    IIndexBuilder objBuilder = AppBeanUtil.getBean(clazzIndexBuilder);
                    TYPE_SERVICE_MAP.put(clazzDTO.getName(), objBuilder);
                }
            } catch (Throwable e) {
                LOGGER.error("注册对象对应的索引构建器失败。当前对象" + clazz.getName() + "。原因：" + e.getMessage(), e);
            }
        }
    }
    
    /**
     * 获得持久化的id
     * @param <DTO> BaseDTO
     *
     * @param type 类型
     * @param dataUri 数据唯一标识
     * @param packageId 包id 在哪个范围内查询
     * @return 持久化的id，未找到返回null。
     */
    public <DTO extends BaseDTO> String getStoreId(Class<DTO> type, String dataUri, String packageId) {
        String typeKey = type.getName();
        Map<String, String> dataIndexMap = dataIndexMapSet.get(typeKey);
        
        // 如果不存在，说明当前类型的数据还未建立索引
        if (dataIndexMap == null) {
            // 初始化数据索引集
            if (TYPE_SERVICE_MAP.isEmpty()) {
                initIndexBuilders();
            }
            IIndexBuilder indexBuilder = TYPE_SERVICE_MAP.get(typeKey);
            
            if (indexBuilder == null) {
                throw new DocServiceException("还未注册类型为" + typeKey + "的数据的索引构建器");
            }
            dataIndexMap = indexBuilder.fixIndexMap(packageId);
            if (dataIndexMap == null) {
                dataIndexMap = new HashMap<String, String>();
            }
            dataIndexMapSet.put(typeKey, dataIndexMap);
        }
        return dataIndexMap.get(dataUri);
    }
    
    /**
     * 添加新的数据索引
     * @param <DTO> BaseDTO
     * @param type 类型
     * @param dataUri 非id的唯一标识
     * @param storeId 持久化的id
     */
    public <DTO extends BaseDTO> void addDataIndex(Class<DTO> type, String dataUri, String storeId) {
        String typeKey = type.getName();
        Map<String, String> dataIndexMap = dataIndexMapSet.get(typeKey);
        // 如果不存在，说明当前类型的数据还未建立索引
        if (dataIndexMap == null) {
            dataIndexMap = new HashMap<String, String>();
            dataIndexMapSet.put(typeKey, dataIndexMap);
        }
        dataIndexMap.put(dataUri, storeId);
    }
    
    /**
     * 注册索引构建器
     * @param <DTO> BaseDTO
     * @param clazz 对象类型
     * @param indexBuilder 索引构建器
     */
    public <DTO extends BaseDTO> void registerIndexBuilder(Class<DTO> clazz, IIndexBuilder indexBuilder) {
        String key = clazz.getName();
        if (TYPE_SERVICE_MAP.containsKey(key)) {
            LOGGER.warn(key + "索引构建器已经存在，重新注册将覆盖已经存在的构建器");
        }
        TYPE_SERVICE_MAP.put(key, indexBuilder);
    }
    
    /**
     * 清空索引集
     *
     */
    public void clearDataIndexMap() {
        for (Entry<String, Map<String, String>> entry : dataIndexMapSet.entrySet()) {
            entry.getValue().clear();
        }
        dataIndexMapSet.clear();
    }
    
    /**
     * 初始化
     *
     */
    public void init() {
        clearDataIndexMap();
    }
}
