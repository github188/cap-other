/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.pdm.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URL;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.SAXReader;
import org.dom4j.io.XMLWriter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 
 * 导出EA的XMI文件的控制类
 *
 * @author duqi
 * @since jdk1.6
 * @version 2015年10月20日 duqi
 */
public class PdmHandler {
    
    /** 日志 */
    private final static Logger LOG = LoggerFactory.getLogger(PdmHandler.class);
    
    /** DOM4J document */
    private Document document;
    
    /** DOM4J 根元素 */
    private Element rootElement;
    
    /** 文件 */
    private File file;
    
    /**
     * 构造函数
     * 
     * @throws DocumentException DOM4J的DocumentException
     */
    public PdmHandler() throws DocumentException {
        SAXReader reader = new SAXReader();
        URL url = getResourcePath("Pdm.xml");
        document = reader.read(url);
        rootElement = document.getRootElement();
    }
    
    /**
     * 构造函数
     * 
     * @param file xml文件
     * 
     * @throws DocumentException DOM4J的DocumentException
     */
    public PdmHandler(File file) throws DocumentException {
        this.file = file;
        String copyFileName = "UML_EA.DTD";
        String sourceFilePath = getResourcePath(copyFileName).getFile();
        String destFilePath = file.getParent() + File.separator + copyFileName;
        copyFile(sourceFilePath, destFilePath);
        SAXReader reader = new SAXReader();
        document = reader.read(file);
    }
    
    /**
     * 拷贝文件
     *
     * @param src 源文件
     * @param dest 目标文件
     */
    public void copyFile(String src, String dest) {
        FileInputStream in = null;
        FileOutputStream out = null;
        try {
            File destFile = new File(dest);
            if (destFile.exists()) {
                return;
            }
            destFile.createNewFile();
            in = new FileInputStream(src);
            out = new FileOutputStream(destFile);
            int c;
            byte buffer[] = new byte[1024];
            while ((c = in.read(buffer)) != -1) {
                out.write(buffer, 0, c);
            }
            out.flush();
        } catch (Exception e) {
            LOG.error("拷贝文件时出现异常", e);
        } finally {
            if (in != null) {
                try {
                    in.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            if (out != null) {
                try {
                    out.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }
    
    /**
     * 获取根元素
     *
     * @return 根元素
     */
    public Element getRootElement() {
        return this.rootElement;
    }
    
    /**
     * @return 获取 document属性值
     */
    public Document getDocument() {
        return document;
    }
    
    /**
     * 获取模板资源路径
     * 
     * @param fileName 文件名称
     *
     * @return 模板资源路径
     */
    private URL getResourcePath(String fileName) {// XMITemplate.xml
        return Thread.currentThread().getContextClassLoader().getResource("com/comtop/cap/bm/metadata/pdm/" + fileName);
    }
    
    /**
     * 导出XMI 文件
     * 
     * @param targetFile 目标文件
     *
     */
    public void write(File targetFile) {
        FileOutputStream fileOutputStream = null;
        XMLWriter output = null;
        try {
            OutputFormat format = OutputFormat.createPrettyPrint();// 格式化
            fileOutputStream = new FileOutputStream(targetFile);
            output = new XMLWriter(fileOutputStream, format); //
            output.write(document);
            output.flush();
        } catch (IOException e) {
            LOG.error("写文件时出现IO异常", e);
        } finally {
            if (fileOutputStream != null) {
                try {
                    fileOutputStream.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            if (output != null) {
                try {
                    output.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }
    
    /**
     * 导出XMI 文件
     *
     */
    public void write() {
        FileOutputStream fileOutputStream = null;
        XMLWriter output = null;
        try {
            OutputFormat format = OutputFormat.createPrettyPrint();// 格式化
            fileOutputStream = new FileOutputStream(file);
            output = new XMLWriter(fileOutputStream, format); //
            output.write(document);
            output.flush();
        } catch (IOException e) {
            LOG.error("写文件时出现IO异常", e);
        } finally {
            if (fileOutputStream != null) {
                try {
                    fileOutputStream.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            if (output != null) {
                try {
                    output.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }
    
}
