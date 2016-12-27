/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.inject;

import java.io.File;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

import com.comtop.cap.bm.metadata.inject.injecter.IMetaDataInjecter;
import com.comtop.corm.resource.util.CollectionUtils;
import com.comtop.top.core.util.StringUtil;

/**
 * 元数据注入配置的基类
 *
 *
 * @author 凌晨
 * @since jdk1.6
 * @version 2016年1月4日 凌晨
 */
public abstract class ParseConfig {
    
    /** 元数据注入的全局配置 */
    protected static final Map<String, Map<String, IMetaDataInjecter>> config = new HashMap<String, Map<String, IMetaDataInjecter>>();
    
    /** 存储文件最后修改时间 */
    private static final Map<String, Long> fileLastModified = new HashMap<String, Long>();
    
    /** 该解析器解析的默认文件 */
    protected String url;
    
    /**
     * 从全局配置中获取具体类别的元数据注入配置，比如获取页面的注入配置、获取实体的注入配置。
     * （若缓存中不存在，则解析配置文件返回；若缓存中存在，则对比配置文件的最后修改时间判断文件是否被修改：如果文件未被修改，直接从缓存中返回；若配置文件被修改，则解析配置文件返回;当配置文件打在jar里面，则不再重新解析配置文件）
     * 
     * @return 配置的map
     */
    public Map<String, IMetaDataInjecter> getConfig() {
        // 配置文件的路径如果为空
        if (StringUtil.isBlank(this.url)) {
            return null;
        }
        
        // 获得配置文件的最后修改时间
        Long newlastModified = getFileLastModified();
        
        Map<String, IMetaDataInjecter> targetMap = config.get(this.url);
        if (null == targetMap) { // 缓存中不存在，则解析p配置文件。
            targetMap = exeParseConfig(newlastModified);
            
            return cloneMap(targetMap);
        }
        // 如果能够获取文件的修改时间
        if (null != newlastModified) {
            // 取出上一次的解析保存的最后修改时间
            Long oldLastModified = fileLastModified.get(this.url);
            // 如果缓存中不存在、缓存中未记录最后修改时间、文件的最新修改时间和之前保存的最新修改时间不一致，则重新解析配置文件
            if (oldLastModified == null || oldLastModified.longValue() != newlastModified.longValue()) {
                
                targetMap = exeParseConfig(newlastModified);
                
                return cloneMap(targetMap);
            }
        }
        return cloneMap(targetMap);
    }
    
    /**
     * 
     * 解析配置文件
     *
     * @param modifiedTime 配置文件最新修改时间
     * @return 配置池
     */
    private Map<String, IMetaDataInjecter> exeParseConfig(Long modifiedTime) {
        // 解析配置文件文件
        Map<String, IMetaDataInjecter> targetMap = parse4Config();
        // 把解析的结果放到全局config对象中
        if (!CollectionUtils.isEmpty(targetMap)) {
            config.put(this.url, targetMap);
        }
        // 最后修改时间存储在fileLastModified中
        if (null != modifiedTime) {
            fileLastModified.put(this.url, modifiedTime);
        }
        return targetMap;
    }
    
    /**
     * 
     * 获得配置文件的最后修改时间
     * 
     * @return 最后修改时间的毫秒数<code>Long</code>对象
     */
    private Long getFileLastModified() {
        URL classPath = Thread.currentThread().getContextClassLoader().getResource("");
        File file = new File(classPath.getPath() + this.url);
        if (file.isFile()) {
            return Long.valueOf(file.lastModified());
        }
        return null;
    }
    
    /**
     * 克隆Map
     *
     * @param source 需要clone的map
     * @return clone后的map
     */
    protected Map<String, IMetaDataInjecter> cloneMap(Map<String, IMetaDataInjecter> source) {
        if (CollectionUtils.isEmpty(source)) {
            return null;
        }
        Map<String, IMetaDataInjecter> cloneMap = new HashMap<String, IMetaDataInjecter>();
        cloneMap.putAll(source);
        return cloneMap;
    }
    
    /**
     * @return 获取 url属性值
     */
    public String getUrl() {
        return url;
    }
    
    /**
     * @param url 设置该解析器解析的文件路径（classPath下的路径）
     */
    public void setUrl(String url) {
        this.url = url;
    }
    
    /**
     * 解析配置文件获得元数据注入配置
     * 
     * @return 元数据注入配置
     */
    abstract Map<String, IMetaDataInjecter> parse4Config();
    
}
