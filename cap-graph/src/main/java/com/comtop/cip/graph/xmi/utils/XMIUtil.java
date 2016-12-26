/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cip.graph.xmi.utils;

import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import java.util.concurrent.atomic.AtomicInteger;

import org.dom4j.Element;

/**
 * 
 * 生成XMI的工具类
 *
 * @author duqi
 * @since jdk1.6
 * @version 2015年10月20日 duqi
 */
public class XMIUtil {
    
    /** 自增长数 用于生成localID */
    private static AtomicInteger atomic = new AtomicInteger(1);
    
    /**
     * 获取UUID
     *
     * @return UUID
     */
    public static String getUUID() {
        UUID uuid = UUID.randomUUID();
        return uuid.toString().replace('-', '_').toUpperCase();
    }
    
    /**
     * 获取LocalID
     *
     * @return LocalID
     */
    public static int getLocalID() {
        return atomic.incrementAndGet();
    }
    
    /**
     * 获取GUID
     *
     * @return GUID
     */
    public static String getGUID() {
        UUID uuid = UUID.randomUUID();
        return "{" + uuid.toString() + "}".toUpperCase();
    }
    
    /**
     * 获取DUID
     *
     * @return GUID
     */
    public static String getDUID() {
        UUID uuid = UUID.randomUUID();
        return uuid.toString().substring(0, 8).toUpperCase();
    }
    
    /**
     * 添加元素属性
     *
     * @param element 父元素
     * @param name 属性名称
     * @param value 属性值
     */
    public static void addElementAttribute(Element element, String name, String value) {
        if (value != null && value.length() > 0) {
            element.addAttribute(name, value);
        }
    }
    
    /**
     * 添加标签元素
     *
     * @param element 标签元素
     * @param taggedValueMap taggedValueElement
     */
    public static void addTaggedValueElement(Element element, Map<String, String> taggedValueMap) {
        if (taggedValueMap == null || taggedValueMap.isEmpty()) {
            return;
        }
        Element modelElement = element.addElement("UML:ModelElement.taggedValue");
        Set<Map.Entry<String, String>> entrySet = taggedValueMap.entrySet();
        for (Iterator<Map.Entry<String, String>> entryIterator = entrySet.iterator(); entryIterator.hasNext();) {
            Map.Entry<String, String> next = entryIterator.next();
            Element taggedValueElement = modelElement.addElement("UML:TaggedValue");
            taggedValueElement.addAttribute("tag", next.getKey());
            taggedValueElement.addAttribute("value", next.getValue());
        }
    }
    
}
