/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.common.storage;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStreamWriter;
import java.io.Writer;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;
import javax.xml.bind.Unmarshaller;

import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.sun.xml.internal.bind.marshaller.CharacterEscapeHandler;

/**
 * XML操作者
 *
 * @author 李忠文
 * @since 1.0
 * @version 2015-3-31 李忠文
 */
public class XmlOperator implements IFileOperator {
    
    /** 日志 */
    private final static Logger LOG = LoggerFactory.getLogger(XmlOperator.class);
    
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
        final String strTempPath = strPath.substring(0, iIndex) + ".xmltmp";
        final File objTempFile = new File(strTempPath);
        return objTempFile;
    }
    
    /**
     * 保存XML
     *
     * @param vo 对象
     * @param file 文件
     * @param isTemp 是否存储为临时文件
     * @return 是否保存成功
     */
    public boolean saveXML(final Object vo, final File file, boolean isTemp) {
        boolean bResult = true;
        BufferedWriter writer = null;
        try {
            // 如果当前目录不存在则创建
            if (!file.getParentFile().exists()) {
                file.getParentFile().mkdirs();
            }
            final JAXBContext objContext = JAXBContext.newInstance(vo.getClass());
            final Marshaller objMarshaller = objContext.createMarshaller();
            objMarshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, Boolean.TRUE);
            objMarshaller.setProperty(Marshaller.JAXB_ENCODING, "UTF-8");
            objMarshaller.setProperty(Marshaller.JAXB_FRAGMENT, Boolean.TRUE);
            objMarshaller.setProperty("com.sun.xml.internal.bind.marshaller.CharacterEscapeHandler",
                new CharacterEscapeHandler() {
                    
                    @Override
                    public void escape(char[] ch, int start, int length, boolean isAttVal, Writer w) throws IOException {
                        w.write(ch, start, length);
                    }
                });
            // 保存为临时文件
            File objTempFile = getTempFile(file);
            if (isTemp) {
                try {
                    writer = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(objTempFile), "UTF-8"));
                    objMarshaller.marshal(vo, writer);
                } catch (Exception e) {
                    bResult = false;
                    LOG.error("存储临时文件出错！", e);
                } finally {
                    IOUtils.closeQuietly(writer);
                }
            } else {
                bResult = saveFormalXmlFile(vo, file, bResult, objMarshaller, objTempFile);
            }
        } catch (Exception e) {
            LOG.error("存储正式文件出错。", e);
            bResult = false;
        }
        return bResult;
    }
    
    /**
     * 报错正式XML文件
     * 
     * @param vo 对象
     * @param file 文件
     * @param bResult 操作结果
     * @param objMarshaller 序列化对象
     * @param objTempFile 临时文件
     * @return 保存是否成功
     */
    private boolean saveFormalXmlFile(final Object vo, final File file, boolean bResult,
        final Marshaller objMarshaller, File objTempFile) {
        // 保存正式文件
        BufferedWriter writer = null;
        try {
            if (!file.canWrite()) {
                file.setWritable(true);
            }
            writer = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file), "UTF-8"));
            objMarshaller.marshal(vo, writer);
            // 保存成功删除临时文件
            if (objTempFile.exists()) {
                objTempFile.delete();
            }
        } catch (Exception e) {
            // 正式文件保存失败则存入临时文件
            try {
                if (!objTempFile.canWrite()) {
                    objTempFile.setWritable(true);
                }
                writer = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(objTempFile), "UTF-8"));
                objMarshaller.marshal(vo, objTempFile);
            } catch (Exception ex) {
                LOG.error("存储临时文件出错！", ex);
            } finally {
                IOUtils.closeQuietly(writer);
                writer = null;
            }
            bResult = false;
            LOG.error("存储正式文件出错！", e);
        } finally {
            IOUtils.closeQuietly(writer);
        }
        return bResult;
    }
    
    /**
     * 读取XML
     * 
     * @param file XML文件
     * @param type 类型
     * @param isTemp 是否为临时文件
     * @param <T> 数据类型
     * @return 数据对象
     */
    @SuppressWarnings("unchecked")
    public <T> T readXml(File file, Class<T> type, boolean isTemp) {
        T objResult = null;
        try {
            final JAXBContext objContext = JAXBContext.newInstance(type);
            final Unmarshaller objUnmarshaller = objContext.createUnmarshaller();
            File objTempFile = getTempFile(file);
            if (isTemp && objTempFile.exists()) {
                objResult = (T) objUnmarshaller.unmarshal(objTempFile);
            } else {
                objResult = (T) objUnmarshaller.unmarshal(file);
            }
        } catch (JAXBException e) {
            LOG.error("读取文件数据出错！file:" + file.getPath() + " type:" + type, e);
            System.out.println(e.getCause());
        }
        return objResult;
    }
    
    /**
     * 读取XML
     * 
     * @param file XML文件
     * @param type 类型
     * @param <T> 数据类型
     * @return 数据对象
     */
    @SuppressWarnings("unchecked")
    public <T> T readXml(InputStream file, Class<T> type) {
        T objResult = null;
        try {
            final JAXBContext objContext = JAXBContext.newInstance(type);
            final Unmarshaller objUnmarshaller = objContext.createUnmarshaller();
            objResult = (T) objUnmarshaller.unmarshal(file);
        } catch (JAXBException e) {
            LOG.error("读取文件数据出错！", e);
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
    public boolean deleteXML(final File file) {
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
        return this.saveXML(vo, file, isTemp);
    }
    
    /*
     * (non-Javadoc)
     * 
     * @see com.comtop.cap.common.storage.IFileOperator#readFile(java.io.File,
     * java.lang.Class, boolean)
     */
    /*
     * (non-Javadoc)
     * 
     * @see com.comtop.cap.bm.metadata.common.storage.IFileOperator#readFile(java.io.File, java.lang.Class, boolean)
     */
    @Override
    public <T> T readFile(File file, Class<T> type, boolean isTemp) {
        return this.readXml(file, type, isTemp);
    }
    
    /*
     * (non-Javadoc)
     * 
     * @see com.comtop.cap.common.storage.IFileOperator#deleteFile(java.io.File)
     */
    @Override
    public boolean deleteFile(File file) {
        return this.deleteXML(file);
    }
    
    /*
     * (non-Javadoc)
     * 
     * @see com.comtop.cap.common.storage.IFileOperator#getFileExtName()
     */
    @Override
    public String getFileExtName() {
        return "xml";
    }
}
