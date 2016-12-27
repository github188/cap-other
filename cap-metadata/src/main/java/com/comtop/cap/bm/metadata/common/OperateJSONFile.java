/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.common;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.runtime.base.exception.CapMetaDataException;
import com.comtop.cip.json.JSON;

/**
 * JSON文件操作类
 * 
 * 
 * @author 沈康
 * @since 1.0
 * @version 2014-6-11 沈康
 */
public final class OperateJSONFile {
    
    /** 日志 */
    private static final Logger LOGGER = LoggerFactory.getLogger(OperateJSONFile.class);
    
    /**
     * 构造函数
     */
    private OperateJSONFile() {
        super();
    }
    
    /**
     * 从JSON文件获取内容，并封装到对应的对象中
     * 
     * @param path 文件路径
     * @return 带有数据的对象
     */
    public static Object jsonToObject(String path) {
        // 将JSON文件转化为字符串
        String strJSONContent = readJSONFile(path);
        
        // 根据路径获取JSON文件名称
        String strFileNameArr[] = path.split("/");
        String strFileName = strFileNameArr[strFileNameArr.length - 1];
        
        String strClassName = strFileName.split("_")[0].toString();
        
        Class<?> objJSONClass = null;
        try {
            objJSONClass = Class.forName(strClassName);
        } catch (ClassNotFoundException e) {
            LOGGER.error("将JSON元数据转化为业务对象出错！", e);
            throw new CapMetaDataException("将JSON元数据转化为业务对象出错！", e);
        }
        
        // 格式化成JSON对象
        return JSON.parseObject(strJSONContent, objJSONClass);
    }
    
    /**
     * 读取JSON文件
     * 
     * @param path 文件路径
     * @return 文件输出字符串类型数据
     */
    public static String readJSONFile(final String path) {
        File objFile = new File(path);
        BufferedReader objBufferedReader = null;
        String strLastContent = "";
        try {
            objBufferedReader = new BufferedReader(new FileReader(objFile));
            String strTempString = null;
            
            // 一次读入一行，直到读入null为文件结束
            while ((strTempString = objBufferedReader.readLine()) != null) {
                // 显示行号
                strLastContent = strLastContent + strTempString;
            }
        } catch (FileNotFoundException e) {
            LOGGER.error("读取JSON文件出错！", e);
            throw new CapMetaDataException("读取JSON文件出错！", e);
        } catch (IOException ioe) {
            LOGGER.error("读取JSON文件出错！", ioe);
            throw new CapMetaDataException("读取JSON文件出错！", ioe);
        } finally {
            if (objBufferedReader != null) {
                try {
                    objBufferedReader.close();
                } catch (IOException e) {
                    LOGGER.error("关闭读取JSON文件流出错！", e);
                    throw new CapMetaDataException("关闭读取JSON文件流出错！", e);
                }
            }
        }
        return strLastContent;
    }
}
