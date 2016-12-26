/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.util;

import org.xml.sax.Attributes;
import org.xml.sax.ContentHandler;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.AttributesImpl;

import com.comtop.cap.document.word.parse.tohtml.HTMLConstants;

/**
 * SAX帮助类
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年11月3日 lizhiyong
 */
public class SAXHelper {
    
    /**
     * 开始一个元素
     *
     * @param contentHandler 内容handler
     * @param name 元素名
     * @param attributes 属性集
     */
    public static void startElement(ContentHandler contentHandler, String name, Attributes attributes) {
        try {
            contentHandler.startElement("", name, name, attributes);
        } catch (SAXException e) {
            e.printStackTrace();
        }
    }
    
    /**
     * 结束一个元素
     *
     * @param contentHandler 内容handler
     * @param name 元素名
     */
    public static void endElement(ContentHandler contentHandler, String name) {
        try {
            contentHandler.endElement("", name, name);
        } catch (SAXException e) {
            e.printStackTrace();
        }
    }
    
    /**
     * 处理字符串
     *
     * @param contentHandler 内容handler
     * @param content 内容
     */
    public static void characters(ContentHandler contentHandler, String content) {
        char[] chars = content.toCharArray();
        try {
            contentHandler.characters(chars, 0, chars.length);
        } catch (SAXException e) {
            e.printStackTrace();
        }
    }
    
    /**
     * 添加属性值
     *
     * @param attributes attributes
     * @param name name
     * @param value value
     * @return AttributesImpl
     */
    public static AttributesImpl addAttrValue(AttributesImpl attributes, String name, int value) {
        return addAttrValue(attributes, name, String.valueOf(value));
    }
    
    /**
     * 添加属性
     *
     * @param attributes attributes
     * @param name name
     * @param value value
     * @return AttributesImpl
     */
    public static AttributesImpl addAttrValue(AttributesImpl attributes, String name, String value) {
        AttributesImpl objAttributes = attributes;
        if (objAttributes == null) {
            objAttributes = new AttributesImpl();
        }
        objAttributes.addAttribute("", name, name, HTMLConstants.CDATA_TYPE, value);
        return objAttributes;
    }
}
