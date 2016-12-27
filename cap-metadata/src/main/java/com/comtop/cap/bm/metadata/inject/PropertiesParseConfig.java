/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.inject;

import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Properties;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.inject.injecter.IMetaDataInjecter;
import comtop.org.directwebremoting.annotations.DwrProxy;

/**
 * 元数据注入配置
 *
 *
 * @author 凌晨
 * @since jdk1.6
 * @version 2016年1月4日 凌晨
 */
@DwrProxy
public class PropertiesParseConfig extends ParseConfig {
    
    /** 日志 */
    protected final static Logger LOG = LoggerFactory.getLogger(PropertiesParseConfig.class);
    
    /**
     * 构造函数
     */
    public PropertiesParseConfig() {
        // 该解析器解析的默认文件
        this.url = "/com/comtop/cap/bm/metadata/inject/config/MetadataInject.properties";
    }
    
    /**
     * 
     * 解析配置文件获得元数据注入配置。
     *
     * @return 元数据注入配置
     */
    @Override
    Map<String, IMetaDataInjecter> parse4Config() {
        // 获取配置文件的properties对象
        InputStream input = PropertiesParseConfig.class.getResourceAsStream(this.url);
        Properties properties = null;
        if (input != null) {
            properties = new Properties();
            try {
                properties.load(input);
            } catch (IOException e) {
                LOG.error("读取配置" + this.url + "配置文件失败", e);
            } finally {
                try {
                    input.close();
                } catch (IOException e) {
                    LOG.error("读取配置" + this.url + "配置文件后，关闭输入流失败", e);
                }
            }
            
            // 解析配置文件
            Map<String, IMetaDataInjecter> map = null;
            Iterator<Entry<Object, Object>> it = properties.entrySet().iterator();
            while (it.hasNext()) {
                // 取得键值对
                Entry<Object, Object> ent = it.next();
                String type = ent.getKey().toString();
                String classPath = ent.getValue().toString();
                
                try {
                    // 加载配置文件中的注入器，并创建注入器的实例。
                    Class<IMetaDataInjecter> clazz = (Class<IMetaDataInjecter>) Class.forName(classPath);
                    IMetaDataInjecter instance = clazz.newInstance();
                    
                    map = map != null ? map : new HashMap<String, IMetaDataInjecter>();
                    // 把注入器的实例放到map中
                    map.put(type, instance);
                } catch (ClassNotFoundException e) {
                    LOG.error("未找到" + classPath + "注入器", e);
                } catch (InstantiationException e) {
                    LOG.error("实例化" + classPath + "注入器失败", e);
                } catch (IllegalAccessException e) {
                    LOG.error("实例化" + classPath + "注入器失败", e);
                }
            }
            
            return map;
        }
        RuntimeException e = new RuntimeException("未找到" + this.url + "配置文件");
        LOG.error("未找到" + this.url + "配置文件", e);
        throw e;
    }
}
