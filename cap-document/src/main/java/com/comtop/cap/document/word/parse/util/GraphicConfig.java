/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.parse.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 图标信息
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年11月25日 lizhiyong
 */
public class GraphicConfig {
    
    /** 日志 */
    private final Logger logger = LoggerFactory.getLogger(GraphicConfig.class);
    
    /** 属性配置 */
    private final Properties properties = new Properties();
    
    /** 图标映射集 */
    private final Map<String, String> iconMap = new HashMap<String, String>();
    
    /** 图标映射 */
    private final String KEY_ICON_MAPPING = "iconMapping";
    
    /** 图形配置文件路径 */
    private final String KEY_GRAPHIC_CONFIG_PATH = "/GraphicConfig.properties";
    
    /** 实例 */
    private static final GraphicConfig instance = new GraphicConfig();
    
    /**
     * 构造函数
     */
    private GraphicConfig() {
        InputStream inputStream = null;
        try {
            inputStream = GraphicConfig.class.getResourceAsStream(KEY_GRAPHIC_CONFIG_PATH);
            properties.load(inputStream);
            String iconMapping = properties.getProperty(KEY_ICON_MAPPING);
            if (StringUtils.isNotBlank(iconMapping)) {
                String[] mappings = iconMapping.split("[;]");
                for (int i = 0; i < mappings.length; i++) {
                    String[] mapping = mappings[i].split("[:]");
                    if (mapping.length == 2) {
                        iconMap.put(mapping[0], mapping[1]);
                    }
                }
            }
        } catch (IOException e) {
            String message = null;
            if (inputStream == null) {
                message = "加载配置文件出错。没有在classpath中找到GraphicConfig.properties配置文件";
            } else {
                message = "加载配置文件出错。";
            }
            logger.error(message, e);
        } finally {
            IOUtils.closeQuietly(inputStream);
        }
    }
    
    /**
     * 获得配置实例
     *
     * @return 配置实例
     */
    public static GraphicConfig getInstance() {
        return instance;
    }
    
    /**
     * 获得图标
     *
     * @param fileSuffix 文件后缀
     * @return 默认图标
     */
    public Object getIcon(String fileSuffix) {
        return this.iconMap.get(fileSuffix);
    }
}
