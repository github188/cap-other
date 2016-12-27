/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.template;

import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Properties;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 可变区域定义信息的读取器
 *
 *
 * @author 凌晨
 * @since jdk1.6
 * @version 2016年1月18日 凌晨
 */
public final class AreaDefinedInfoReader {
    
    /** 日志 */
    protected final static Logger LOG = LoggerFactory.getLogger(AreaDefinedInfoReader.class);
    
    /**
     * 读取可变区域定义信息
     *
     * @return 可变区域定义信息
     */
    public final static Map<String, String> read() {
        InputStream in = AreaDefinedInfoReader.class
            .getResourceAsStream("/com/comtop/cap/bm/metadata/page/template/AreaDefined.properties");
        Properties properties = new Properties();
        if (in != null) {
            try {
                properties.load(in);
                
                Map<String, String> areaMap = new HashMap<String, String>();
                Iterator<Entry<Object, Object>> it = properties.entrySet().iterator();
                while (it.hasNext()) {
                    // 取得键值对
                    Entry<Object, Object> ent = it.next();
                    String key = ent.getKey().toString();
                    String value = ent.getValue().toString();
                    areaMap.put(key, value);
                }
                
                return areaMap;
                
            } catch (IOException e) {
                LOG.error("读取可变区域定义信息失败", e);
            } finally {
                try {
                    in.close();
                } catch (IOException e) {
                    LOG.error("读取可变区域定义信息时关闭文件流失败", e);
                }
            }
        }
        RuntimeException rt = new RuntimeException();
        LOG.error("获取可变区域定义信息失败", rt);
        throw rt;
    }
}
