/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.parse;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.net.URI;
import java.util.List;

import org.apache.commons.io.IOUtils;
import org.apache.poi.xwpf.usermodel.IBodyElement;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.document.word.WordOptions;
import com.comtop.cap.document.word.docconfig.DocConfigManager;
import com.comtop.cap.document.word.docconfig.model.DocConfig;
import com.comtop.cap.document.word.docmodel.data.WordDocument;
import com.comtop.cap.document.word.parse.parser.BodyParser;
import com.comtop.cap.document.word.util.IdGenerator;

/**
 * word解析器
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年10月14日 lizhiyong
 */
public class WordParser {
    
    /** 日志 */
    private static final Logger LOGGER = LoggerFactory.getLogger(WordParser.class);
    
    /**
     * 
     * 解析word文档
     *
     * @param wordFilePath word文件路径
     * @param wordTemplatePath 模板文件路径 xml格式 的模板文件
     * @param options 解析配置
     * @return WordDocument对象
     * @throws WordParseException 异常
     */
    public WordDocument parse(String wordFilePath, String wordTemplatePath, WordOptions options)
        throws WordParseException {
        File worFile = new File(wordFilePath);
        File worTempFile = new File(wordTemplatePath);
        return parse(worFile, worTempFile, options);
    }
    
    /**
     * 
     * 解析word文档
     *
     * @param worFile word文件
     * @param worTempFile 模板文件 xml格式的模板文件
     * @param options 解析配置
     * @return WordDocument对象
     * @throws WordParseException 异常
     */
    public WordDocument parse(File worFile, File worTempFile, WordOptions options) throws WordParseException {
        FileInputStream in = null;
        try {
            in = new FileInputStream(worFile);
            XWPFDocument document = new XWPFDocument(in);
            DocConfigManager templateParser = new DocConfigManager();
            DocConfig docConfig = templateParser.parseXml(worTempFile, options);
            WordDocument doc = new WordDocument(docConfig);
            doc.setName(worFile.getName());
            doc.setId(IdGenerator.getUUID());
            doc.setDomainId(doc.getId());
            doc.setOptions(options);
            BodyParser mapper = new BodyParser(document, doc);
            List<IBodyElement> bodyElements = document.getBodyElements();
            mapper.visitBodyElements(bodyElements, doc.getCurrentSection());
            
            // 如果有修改，则创建新的模板
            if (docConfig.getModifyTimes() > 0) {
                String wordName = getFileName(worFile.getName());
                docConfig.setName(docConfig.getName() + "-" + wordName);
                File newFile = new File(worTempFile.getParent() + "/" + getFileName(worTempFile.getName()) + "-"
                    + wordName + ".xml");
                docConfig.setConfigFile(newFile);
                // 持久化新模板
                templateParser.createNewDocConfig(docConfig);
            }
            return doc;
        } catch (Exception e) {
            LOGGER.error("解析word文件发生异常：" + worFile.getAbsolutePath(), e);
            throw new WordParseException("解析word文件发生异常：" + worFile.getAbsolutePath(), e);
        } finally {
            IOUtils.closeQuietly(in);
        }
    }
    
    /**
     * 获得文件名
     *
     * @param input 输入
     * @return 文件名
     */
    private String getFileName(String input) {
        return input.substring(0, input.lastIndexOf('.'));
    }
    
    /**
     * 
     * 解析word文档
     *
     * @param in word文件输入流
     * @param uri 文件路径
     * @param wordName word文件名
     * @param worTempFile 模板文件 xml格式的模板文件
     * @param options 解析配置
     * @return WordDocument对象
     * @throws WordParseException 异常
     */
    public WordDocument parse(InputStream in, URI uri, String wordName, File worTempFile, WordOptions options)
        throws WordParseException {
        try {
            XWPFDocument document = new XWPFDocument(in);
            DocConfigManager templateParser = new DocConfigManager();
            DocConfig docConfig = templateParser.parseXml(worTempFile, options);
            WordDocument doc = new WordDocument(docConfig);
            doc.setName(new File(uri).getName());
            doc.setId(IdGenerator.getUUID());
            doc.setDomainId(doc.getId());
            doc.setOptions(options);
            BodyParser mapper = new BodyParser(document, doc);
            List<IBodyElement> bodyElements = document.getBodyElements();
            mapper.visitBodyElements(bodyElements, doc.getCurrentSection());
            // 如果没有修改，则将新模板对象的uri置为与原来一样，保证共享引用
            if (docConfig.getModifyTimes() == 0) {
                docConfig.setName(docConfig.getName() + "-" + wordName);
                File newFile = new File(worTempFile.getParent() + "/" + getFileName(worTempFile.getName()) + "-"
                    + wordName + ".xml");
                docConfig.setConfigFile(newFile);
                // 持久化新模板
                templateParser.createNewDocConfig(docConfig);
            }
            return doc;
        } catch (Exception e) {
            LOGGER.error("解析word文件发生异常：" + uri, e);
            throw new WordParseException("解析word文件发生异常：" + uri, e);
        } finally {
            IOUtils.closeQuietly(in);
        }
    }
    
    /**
     * 
     * 解析word文档
     *
     * @param in word文件输入流
     * @param doc word文件名
     * @return WordDocument对象
     * @throws WordParseException 异常
     */
    public WordDocument parse(InputStream in, WordDocument doc) throws WordParseException {
        try {
            XWPFDocument document = new XWPFDocument(in);
            BodyParser parser = new BodyParser(document, doc);
            List<IBodyElement> bodyElements = document.getBodyElements();
            parser.visitBodyElements(bodyElements, doc.getCurrentSection());
            return doc;
        } catch (Exception e) {
            LOGGER.error("解析word文件发生异常：" + doc.getUri(), e);
            throw new WordParseException("解析word文件发生异常：" + doc.getUri(), e);
        } finally {
            IOUtils.closeQuietly(in);
        }
    }
}
