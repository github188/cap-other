/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docmodel.style;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.xml.sax.ContentHandler;

import com.comtop.cap.document.word.util.SAXHelper;

/**
 * CSS样式
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年11月3日 lizhiyong
 */
public class CSSStyle {
    
    /** 标签名 */
    private final String tagName;
    
    /** class名 */
    private final String className;
    
    /** 属性值 */
    private List<CSSProperty> properties;
    
    /**
     * 构造函数
     * 
     * @param tagName 标签名
     * @param className class名
     */
    public CSSStyle(String tagName, String className) {
        this.tagName = tagName;
        this.className = className;
        this.properties = null;
    }
    
    /**
     * 保存
     *
     * @param contentHandler 内容handler
     */
    public void save(ContentHandler contentHandler) {
        StringBuilder style = new StringBuilder(tagName);
        if (className != null) {
            style.append('.');
            style.append(className);
        }
        style.append('{');
        
        buildInlineStyles(style);
        
        style.append('}');
        
        SAXHelper.characters(contentHandler, style.toString());
    }
    
    /**
     * 获得内置样式
     *
     * @return 样式串
     */
    public String getInlineStyles() {
        if (properties == null) {
            return "";
        }
        StringBuilder styles = new StringBuilder();
        buildInlineStyles(styles);
        return styles.toString();
    }
    
    /**
     * 构建内置样式
     *
     * @param style 样式串
     */
    public void buildInlineStyles(StringBuilder style) {
        List<CSSProperty> properties1 = getProperties();
        for (CSSProperty property : properties1) {
            style.append(property.getName());
            style.append(':');
            style.append(property.getValue());
            style.append(';');
        }
        
    }
    
    /**
     * 添加属性
     *
     * @param name 属性名
     * @param value 属性值
     */
    public void addProperty(String name, String value) {
        if (properties == null) {
            properties = new ArrayList<CSSProperty>();
        }
        properties.add(new CSSProperty(name, value));
    }
    
    /**
     * 获得属性集
     *
     * @return 属性集
     */
    public List<CSSProperty> getProperties() {
        if (properties == null) {
            return Collections.emptyList();
        }
        return properties;
    }
}
