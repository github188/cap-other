/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.common.storage;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.sql.Timestamp;
import java.util.Date;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cip.json.JSON;
import com.comtop.cip.json.serializer.SerializeConfig;
import com.comtop.cip.json.serializer.SerializerFeature;
import com.comtop.cip.json.serializer.SimpleDateFormatSerializer;

/**
 * JSON操作者
 *
 * @author 郑重
 * @since 1.0
 * @version 2015-4-24 郑重
 */
public class JsonOperator implements IFileOperator {
    
    /** 日志 */
    private final static Logger LOG = LoggerFactory.getLogger(JsonOperator.class);
    
    /**
     * 类型转换器
     */
    private static SerializeConfig mapping = new SerializeConfig();
    static {
        mapping.put(Date.class, new SimpleDateFormatSerializer("yyyy-MM-dd HH:mm:ss"));
        mapping.put(Timestamp.class, new SimpleDateFormatSerializer("yyyy-MM-dd HH:mm:ss"));
    }
    
    /**
     * 系列化特性
     */
    private static SerializerFeature[] feature = new SerializerFeature[] { SerializerFeature.PrettyFormat };
    
    /**
     * 返回临时文件路径
     * 
     * @param file 正式文件
     * @return 临时文件
     */
    @Override
    public File getTempFile(final File file) {
        final String strPath = file.getAbsolutePath();
        final int iIndex = strPath.lastIndexOf('.');
        final String strTempPath = strPath.substring(0, iIndex) + ".jsontmp";
        final File objTempFile = new File(strTempPath);
        return objTempFile;
    }
    
    /**
     * 读取文件到字符串
     * 
     * @param file 文件
     * @return 文件内容
     */
    public String readFile(File file) {
        StringBuilder objFile = new StringBuilder(1000);
        // 读取系统换行符
        String strCrlf = System.getProperty("line.separator");
        BufferedReader objReader = null;
        try {
            objReader = new BufferedReader(new InputStreamReader(new FileInputStream(file), "utf-8"));
            String strLine = objReader.readLine();
            while (strLine != null) {
                objFile.append(strLine).append(strCrlf);
                strLine = objReader.readLine();
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (objReader != null) {
                try {
                    objReader.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return objFile.toString();
    }
    
    /**
     * 将字符串写入文件
     * 
     * @param dest 写入文件
     * @param file 写入文件内容
     */
    public void writeFile(File dest, String file) {
        try {
			if (!dest.canWrite()) {
                dest.setWritable(true);
            }
            BufferedWriter objWriter = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(dest), "utf-8"));
            objWriter.write(file);
            objWriter.flush();
            objWriter.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    
    /**
     * 保存XML
     *
     * @param vo 对象
     * @param file 文件
     * @param isTemp 是否存储为临时文件
     * @return 是否保存成功
     */
    public boolean saveJson(final Object vo, final File file, boolean isTemp) {
        boolean bResult = true;
        try {
            // 如果当前目录不存在则创建
            if (!file.getParentFile().exists()) {
                file.getParentFile().mkdirs();
            }
            String strJson = JSON.toJSONString(vo, mapping, feature);
            // 保存为临时文件
            File objTempFile = getTempFile(file);
            if (isTemp) {
                try {
                    writeFile(objTempFile, strJson);
                } catch (Exception e) {
                    bResult = false;
                    LOG.error("存储临时文件出错！", e);
                }
            } else {
                bResult = saveFormalJsonFile(file, bResult, strJson, objTempFile);
            }
        } catch (Exception e) {
            LOG.error("存储正式文件出错。", e);
            bResult = false;
        }
        return bResult;
    }
    
    /**
     * 保存正式文件
     * 
     * @param file 待保存文件
     * @param bResult 操作是否成功
     * @param strJson json串
     * @param objTempFile 临时文件
     * @return 操作是否成功
     */
    private boolean saveFormalJsonFile(final File file, boolean bResult, String strJson, File objTempFile) {
        // 保存正式文件
        try {
            writeFile(file, strJson);
            // 保存成功删除临时文件
            if (objTempFile.exists()) {
                objTempFile.delete();
            }
        } catch (Exception e) {
            // 正式文件保存失败则存入临时文件
            try {
                writeFile(objTempFile, strJson);
            } catch (Exception ex) {
                LOG.error("存储临时文件出错！", ex);
            }
            bResult = false;
            LOG.error("存储正式文件出错！", e);
        }
        return bResult;
    }
    
    /**
     * 读取XML
     * 
     * @param file XML文件
     * @param type 模型类型
     * @param isTemp 是否为临时文件
     * @param <T> 数据类型
     * @return 数据对象
     */
    public <T> T readJson(File file, Class<T> type, boolean isTemp) {
        T objResult = null;
        try {
            File objTempFile = getTempFile(file);
            String strJson = "";
            if (isTemp && objTempFile.exists()) {
                strJson = readFile(objTempFile);
            } else {
                strJson = readFile(file);
            }
            objResult = JSON.parseObject(strJson, type);
        } catch (Exception e) {
            LOG.error("读取文件数据出错！file:" + file.getPath() + " type:" + type, e);
        }
        return objResult;
    }
    
    /**
     * 删除
     *
     *
     * @param file 文件
     * @return 删除数据
     */
    public boolean deleteJson(final File file) {
        boolean bResult = true;
        try {
            // 删除临时文件
            File objTempFile = getTempFile(file);
            if (objTempFile.exists()) {
                objTempFile.delete();
            }
            // 删除正式文件
            if (file.exists()) {
                file.delete();
            }
        } catch (Exception e) {
            bResult = false;
            LOG.error("删除文件出错！file:" + file.getPath(), e);
        }
        return bResult;
    }
    
    /*
     * (non-Javadoc)
     * 
     * @see
     * com.comtop.cap.common.storage.IFileOperator#saveFile(java.lang.Object,
     * java.io.File, boolean)
     */
    @Override
    public boolean saveFile(Object vo, File file, boolean isTemp) {
        return this.saveJson(vo, file, isTemp);
    }
    
    /*
     * (non-Javadoc)
     * 
     * @see com.comtop.cap.common.storage.IFileOperator#readJson(java.io.File,
     * java.lang.Class, boolean)
     */
    @Override
    public <T> T readFile(File file, Class<T> type, boolean isTemp) {
        return this.readJson(file, type, isTemp);
    }
    
    /*
     * (non-Javadoc)
     * 
     * @see com.comtop.cap.common.storage.IFileOperator#deleteJson(java.io.File)
     */
    @Override
    public boolean deleteFile(File file) {
        return this.deleteJson(file);
    }
    
    /*
     * (non-Javadoc)
     * 
     * @see com.comtop.cap.common.storage.IFileOperator#getFileExtName()
     */
    @Override
    public String getFileExtName() {
        return "json";
    }
}
