/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docconfig;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;

import javax.xml.bind.JAXB;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.Unmarshaller;

import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.document.word.WordOptions;
import com.comtop.cap.document.word.docconfig.model.DocConfig;
import com.comtop.cap.document.word.parse.check.DocConfigChecker;

/**
 * Word模板解析器
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年10月19日 lizhiyong
 */
public class DocConfigManager {
    
    /** 日志对象 */
    private final Logger logger = LoggerFactory.getLogger(DocConfigManager.class);
    
    /**
     * 解析word模板
     *
     * @param filePath Pathword模板路径
     * @param options 选项
     * @return WtDocTemplate对象
     */
    public DocConfig parseXml(String filePath, WordOptions options) {
        File inputXMLFile = new File(filePath);
        return parseXml(inputXMLFile, options);
    }
    
    /**
     * 解析word模板
     *
     * @param file 模板文件
     * @param options 选项
     * @return WtDocTemplate对象
     */
    public DocConfig parseXml(File file, WordOptions options) {
        JAXBContext context;
        FileInputStream fileInputStream = null;
        try {
            fileInputStream = new FileInputStream(file);
            context = JAXBContext.newInstance(DocConfig.class);
            Unmarshaller unmarshaller = context.createUnmarshaller();
            DocConfig docConfig = (DocConfig) unmarshaller.unmarshal(fileInputStream);
            docConfig.init(options);
            docConfig.setConfigFile(file);
            DocConfigChecker checker = new DocConfigChecker(docConfig);
            checker.check();
            return docConfig;
        } catch (Throwable e) {
            logger.error("解析word模板出错", e);
            throw new RuntimeException("解析word模板出错", e);
        } finally {
            IOUtils.closeQuietly(fileInputStream);
        }
    }
    
    /**
     * 更新文档配置
     *
     * @param docConfig 配置对象
     */
    public void updateDocConfig(DocConfig docConfig) {
        createNewDocConfig(docConfig);
    }
    
    /**
     * 更新文档配置
     *
     * @param docConfig 配置对象
     */
    public void createNewDocConfig(DocConfig docConfig) {
        File file = docConfig.getConfigFile();
        if (!file.getParentFile().exists()) {
            file.mkdirs();
        }
        if (!file.exists()) {
            try {
                file.createNewFile();
            } catch (IOException e) {
                logger.error("创建word模板模板出错。路径：" + file.getAbsolutePath(), e);
                throw new RuntimeException("创建word模板模板出错.路径：" + file.getAbsolutePath(), e);
            }
        }
        OutputStream outputStream = null;
        try {
            outputStream = new FileOutputStream(file);
            JAXB.marshal(docConfig, outputStream);
        } catch (FileNotFoundException e) {
            logger.error("创建word模板模板出错。路径：" + file.getAbsolutePath(), e);
            throw new RuntimeException("创建word模板模板出错.路径：" + file.getAbsolutePath(), e);
        } finally {
            IOUtils.closeQuietly(outputStream);
        }
    }
    
}
