/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.write;

import static com.comtop.cap.document.word.util.FolderUtil.projectOutputPath;
import static com.comtop.cap.document.word.util.FolderUtil.urlToPath;

import java.net.URL;

import org.junit.Test;

import com.comtop.cap.document.expression.ContainerInitializerImpl;
import com.comtop.cap.document.word.docmodel.DocxProperties;

/**
 * 文档写入测试
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月23日 lizhongwen
 */
public class DocxWriterTest {
    
    /**
     * 测试根据配置写
     */
    @Test
    public void testWrite() {
        DocxProperties properties = new DocxProperties();
        properties.setTitle("南方电网公司生产设备管理业务模型说明书总册");
        DocxExportConfiguration config = new DocxExportConfiguration(properties, null);
        ClassLoader loader = Thread.currentThread().getContextClassLoader();
        URL url = loader.getResource("docconfig-bizmodel.xml");
        config.setTemplatePath(urlToPath(url));
        config.setFilePath(projectOutputPath() + "/WriterTest.docx");
        DocxWriter writer = new DocxWriter();
        writer.write(config);
    }
    
    /**
     * 测试根据配置写表格
     */
    @Test
    public void testWriteTable() {
        DocxProperties properties = new DocxProperties();
        properties.setTitle("测试表格导出");
        DocxExportConfiguration config = new DocxExportConfiguration(properties, new ContainerInitializerImpl());
        ClassLoader loader = Thread.currentThread().getContextClassLoader();
        URL url = loader.getResource("table_config.xml");
        config.setTemplatePath(urlToPath(url));
        config.setFilePath(projectOutputPath() + "/TableTest.docx");
        config.setLogPath(projectOutputPath() + "/TableTest.log");
        DocxWriter writer = new DocxWriter();
        writer.write(config);
    }
    
    /**
     * 测试根据配置写列表
     */
    @Test
    public void testWriteList() {
        DocxProperties properties = new DocxProperties();
        properties.setTitle("测试项目列表");
        DocxExportConfiguration config = new DocxExportConfiguration(properties, new ContainerInitializerImpl());
        ClassLoader loader = Thread.currentThread().getContextClassLoader();
        URL url = loader.getResource("list_config.xml");
        config.setTemplatePath(urlToPath(url));
        config.setFilePath(projectOutputPath() + "/ListTest.docx");
        config.setLogPath(projectOutputPath() + "/ListTest.log");
        DocxWriter writer = new DocxWriter();
        writer.write(config);
    }
}
