/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.common.storage;

import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;

import javax.xml.bind.annotation.XmlRootElement;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 模型类型配置
 *
 * @author 郑重
 * @version jdk1.5
 * @version 2015-4-28 郑重
 */
@XmlRootElement
public class ModelClassConfig {
    
    /** 日志 */
    private final static Logger logger = LoggerFactory.getLogger(ModelClassConfig.class);
    
    /**
     * 模型类型映射配置，如果增加新的模型类则在此添加
     */
    private Map<String, TypeConfig> config = new HashMap<String, TypeConfig>();
    
    /**
     * @return the modelClassConfig
     */
    public Map<String, TypeConfig> getConfig() {
        return config;
    }
    
    /**
     * @param config 配置对象
     */
    public void setConfig(Map<String, TypeConfig> config) {
        this.config = config;
    }
    
    /**
     * 获取配置
     * 
     * @param key 元数据类型名
     * @return 配置
     */
    public TypeConfig get(String key) {
        return config.get(key);
    }
    
    /**
     * 获取配置
     * 
     * @param key 元数据类型名
     * @param typeConfig 配置对象
     */
    public void put(String key, TypeConfig typeConfig) {
        config.put(key, typeConfig);
    }
    
    /**
     * 加载配置
     * 
     * @return 配置对象
     */
    public static ModelClassConfig load() {
        ModelClassConfig objModelClassConfig = new ModelClassConfig();
        ClassConfigEnum[] items = ClassConfigEnum.class.getEnumConstants();
        for (ClassConfigEnum item : items) {
            ModelClassConfig config = load(item.getConfigName());
            objModelClassConfig.getConfig().putAll(config.getConfig());
        }
        return objModelClassConfig;
    }
    
    /**
     * 
     * 加载单个配置文件
     * 
     * @param xmlName xml配置文件路径
     * @return 加载解析的结果
     */
    private static ModelClassConfig load(String xmlName) {
        InputStream objInputStream = ModelClassConfig.class
            .getResourceAsStream("/com/comtop/cap/bm/metadata/common/storage/" + xmlName);
        XmlOperator objXmlOperator = new XmlOperator();
        ModelClassConfig objModelClassConfig = objXmlOperator.readXml(objInputStream, ModelClassConfig.class);
        try {
            objInputStream.close();
        } catch (IOException e) {
            logger.error("读取/com/comtop/cap/bm/metadata/common/storage/" + xmlName + "文件关闭流失败", e);
        }
        return objModelClassConfig;
    }
}
