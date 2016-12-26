
package com.comtop.cap.document.word.dao;

/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.document.expression.annotation.DocumentService;
import com.comtop.cap.document.word.docmodel.data.DefaultContentSeg;
import com.comtop.cap.document.word.util.DocUtil;
import com.comtop.cap.document.word.util.FolderUtil;
import com.comtop.cip.json.JSON;
import com.comtop.cip.json.JSONArray;
import com.comtop.cip.json.serializer.SerializerFeature;

/**
 * 默认的内容片段处理器
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年11月10日 lizhiyong
 */
@DocumentService(name = "DefaultContentSeg", dataType = DefaultContentSeg.class)
public class DefaultContentSegDataAccessor implements IWordDataAccessor<DefaultContentSeg> {
    
    /** 日志对象 */
    private final Logger LOGGER = LoggerFactory.getLogger(DefaultContentSegDataAccessor.class);
    
    /** 输出文件 */
    private static final String STORE_FILE = "{0}/DefaultContentSeg.json";
    
    /** 内存缓存 */
    private volatile Map<String, DefaultContentSeg> cache = new HashMap<String, DefaultContentSeg>();
    
    /** 文件的上次更新时间 */
    private volatile long lastModifyTime = 0;
    
    /** 输出文件 */
    private File storeFile;
    
    @Override
    public void saveData(List<DefaultContentSeg> wordData) {
        if (wordData == null || wordData.size() == 0) {
            return;
        }
        File pStoreFile = getStoreFile();
        initCache(pStoreFile);
        for (DefaultContentSeg defaultContentSegDTO : wordData) {
            cache.put(defaultContentSegDTO.getKey(), defaultContentSegDTO);
        }
        String json = JSON.toJSONString(cache.values(), new SerializerFeature[] { SerializerFeature.PrettyFormat,
            SerializerFeature.DisableCheckSpecialChar, SerializerFeature.UseSingleQuotes });
        FileOutputStream fileOutputStream = null;
        try {
            fileOutputStream = new FileOutputStream(pStoreFile, false);
            fileOutputStream.write(json.getBytes());
            fileOutputStream.flush();
        } catch (FileNotFoundException e) {
            LOGGER.error("持久化数据时发生异常", e);
        } catch (IOException e) {
            LOGGER.error("持久化数据时发生异常", e);
        } finally {
            IOUtils.closeQuietly(fileOutputStream);
        }
    }
    
    @Override
    public List<DefaultContentSeg> loadData(DefaultContentSeg condition) {
        String key = condition.getKey();
        File pStoreFile = getStoreFile();
        initCache(pStoreFile);
        DefaultContentSeg value = cache.get(key);
        if (value == null) {
            return null;
        }
        List<DefaultContentSeg> alRet = new ArrayList<DefaultContentSeg>(1);
        alRet.add(value);
        return alRet;
    }
    
    /**
     * 初始化缓存
     * 
     * @param pStoreFile 数据文件
     *
     */
    private synchronized void initCache(File pStoreFile) {
        if (cache == null || pStoreFile.lastModified() != lastModifyTime) {
            cache.clear();
            lastModifyTime = pStoreFile.lastModified();
            byte[] b = new byte[1024 * 1024];
            StringBuffer sb = new StringBuffer();
            FileInputStream fileInputStream = null;
            try {
                fileInputStream = new FileInputStream(pStoreFile);
                int length = 0;
                while ((length = fileInputStream.read(b)) > 0) {
                    sb.append(new String(b, 0, length));
                }
            } catch (IOException e) {
                LOGGER.error("加载文件发生异常", e);
            } finally {
                IOUtils.closeQuietly(fileInputStream);
            }
            Collection<DefaultContentSeg> wordData = JSONArray.parseArray(sb.toString(), DefaultContentSeg.class);
            for (DefaultContentSeg defaultContentSegDTO : wordData) {
                cache.put(defaultContentSegDTO.getKey(), defaultContentSegDTO);
            }
        }
    }
    
    /**
     * 获得输出文件
     *
     * @return 输出文件
     */
    private File getStoreFile() {
        if (storeFile != null) {
            return storeFile;
        }
        File rootDir = new File(FolderUtil.projectOutputPath());
        String output = DocUtil.getDocConfigFileDir(rootDir);
        storeFile = new File(MessageFormat.format(STORE_FILE, output));
        if (!storeFile.getParentFile().exists()) {
            storeFile.getParentFile().mkdirs();
        }
        if (!storeFile.exists()) {
            try {
                storeFile.createNewFile();
            } catch (IOException e) {
                LOGGER.error("创建存储文件发生异常", e);
            }
        }
        return storeFile;
    }
    
    @Override
    public void updatePropertyByID(String id, String propertyName, Object value) {
        throw new RuntimeException("不支持对默认内容片段进行更新操作");
    }
}
