/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.write;

import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Field;

import org.apache.commons.io.IOUtils;
import org.apache.poi.POIXMLProperties;
import org.apache.poi.openxml4j.opc.OPCPackage;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFFactory;
import org.apache.poi.xwpf.usermodel.XWPFRelation;
import org.apache.poi.xwpf.usermodel.XWPFSettings;
import org.apache.poi.xwpf.usermodel.XWPFStyle;
import org.apache.poi.xwpf.usermodel.XWPFStyles;
import org.apache.xmlbeans.XmlOptions;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTDocument1;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTNumbering;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTSettings;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTStyle;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 扩展的XWPFDocument，增加一些自定义的设置，并解决命名空间的问题
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年10月23日 lizhongwen
 */
public class ExtXWPFDocument extends XWPFDocument {
	
	/**
     * logger
     */
    protected static final Logger LOGGER = LoggerFactory.getLogger(ExtXWPFDocument.class);
    
    /**
     * 构造函数
     */
    public ExtXWPFDocument() {
        super();
    }
    
    /**
     * 构造函数
     * 
     * @param is 文档输入流
     * @throws IOException IO异常
     */
    public ExtXWPFDocument(InputStream is) throws IOException {
        super(is);
    }
    
    /**
     * 构造函数
     * 
     * @param pkg OpenXML格式的数据包
     * @throws IOException IO异常
     */
    public ExtXWPFDocument(OPCPackage pkg) throws IOException {
        super(pkg);
    }
    
    /**
     * 文件创建时，进行初始化
     * 
     * @see org.apache.poi.xwpf.usermodel.XWPFDocument#onDocumentCreate()
     */
    @Override
    protected void onDocumentCreate() {
        InputStream input = null;
        XmlOptions options = new XmlOptions();
        options.setSavePrettyPrint();
        options.setUseDefaultNamespace();
        try {
            ClassLoader loader = Thread.currentThread().getContextClassLoader();
            input = loader.getResourceAsStream("fragments/document.xml"); // 增加了默认的命名空间
            Field ctDocumentField = this.getClass().getSuperclass().getDeclaredField("ctDocument");
            ctDocumentField.setAccessible(true);
            CTDocument1 ctDocument = CTDocument1.Factory.parse(input, options);
            ctDocumentField.set(this, ctDocument);
            
            Field settingsField = this.getClass().getSuperclass().getDeclaredField("settings");
            settingsField.setAccessible(true);
            XWPFSettings settings = (XWPFSettings) createRelationship(XWPFRelation.SETTINGS, XWPFFactory.getInstance());
            initDefaultSettings(settings);
            
            settings.setZoomPercent(100);
            settingsField.set(this, settings);
            
            POIXMLProperties.ExtendedProperties expProps = getProperties().getExtendedProperties();
            expProps.getUnderlyingProperties().setApplication(DOCUMENT_CREATOR);
            
            loadDefaultStyles();
            
            createDefaultProperties();
        } catch (Exception e) {
        	LOGGER.debug("error", e);
            super.onDocumentCreate();
        } finally {
            IOUtils.closeQuietly(input);
        }
    }
    
    /**
     * 创建默认的属性
     */
    private void createDefaultProperties() {
        this.getProperties().getCoreProperties().setCreator("Comtop Application Platform");
        this.getProperties().getExtendedProperties().getUnderlyingProperties().setCompany("深圳康拓普科技有限公司");
    }
    
    /**
     * 加载默认样式
     */
    private void loadDefaultStyles() {
        ClassLoader loader = Thread.currentThread().getContextClassLoader();
        InputStream input = null;
        try {
            input = loader.getResourceAsStream("styles-default/numbering.xml");
            CTNumbering ctnumbering = CTNumbering.Factory.parse(input);
            this.createNumbering().setNumbering(ctnumbering);
        } catch (Exception e) {
        	LOGGER.debug("error", e);
            // do nothing
        } finally {
            IOUtils.closeQuietly(input);
        }
        XWPFStyles xwpfStyles = this.createStyles();
        
        InputStream in = null;
        try {
            in = loader.getResourceAsStream("styles-default/normal.xml");
            CTStyle normal = CTStyle.Factory.parse(in);
            xwpfStyles.addStyle(new XWPFStyle(normal, xwpfStyles));
        } catch (Exception e) {
        	LOGGER.debug("error", e);
            // do noting...
        } finally {
            IOUtils.closeQuietly(in);
        }
        
        InputStream inputStream = null;
        try {
            inputStream = loader.getResourceAsStream("styles-default/heading.xml");
            CTStyle heading = CTStyle.Factory.parse(inputStream);
            xwpfStyles.addStyle(new XWPFStyle(heading, xwpfStyles));
        } catch (Exception e) {
        	LOGGER.debug("error", e);
            // do noting...
        } finally {
            IOUtils.closeQuietly(inputStream);
        }
        
        InputStream menuInput = null;
        try {
            menuInput = loader.getResourceAsStream("styles-default/catalogue.xml");
            CTStyle heading = CTStyle.Factory.parse(menuInput);
            styles.addStyle(new XWPFStyle(heading, styles));
        } catch (Exception e) {
        	LOGGER.debug("error", e);
            // do noting...
        } finally {
            IOUtils.closeQuietly(menuInput);
        }
    }
    
    /**
     * 初始化默认的设置
     *
     * @param settings XWPF设置
     */
    private void initDefaultSettings(XWPFSettings settings) {
        ClassLoader loader = Thread.currentThread().getContextClassLoader();
        Field ctSettingsField;
        InputStream input = null;
        try {
            input = loader.getResourceAsStream("fragments/settings.xml"); // 增加了默认的设置
            ctSettingsField = XWPFSettings.class.getDeclaredField("ctSettings");
            ctSettingsField.setAccessible(true);
            CTSettings ctSettings = CTSettings.Factory.parse(input);
            ctSettingsField.set(settings, ctSettings);
        } catch (Exception e) {
        	LOGGER.debug("error", e);
            // do nothing...
        } finally {
            IOUtils.closeQuietly(input);
        }
    }
    
}
