/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.write;

import org.apache.poi.POIXMLRelation;

/**
 * 扩展的
 *
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年10月16日 lizhongwen
 */
public class ExtXWPFRelation extends POIXMLRelation {
    
    /**
     * Instantiates a POIXMLRelation.
     *
     * @param type content type
     * @param rel relationship
     * @param defaultName default item name
     */
    public ExtXWPFRelation(String type, String rel, String defaultName) {
        super(type, rel, defaultName);
    }
}
