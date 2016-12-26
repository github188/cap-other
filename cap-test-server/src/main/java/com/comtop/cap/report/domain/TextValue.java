/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.report.domain;

import javax.xml.bind.annotation.XmlType;
import javax.xml.bind.annotation.XmlValue;

/**
 * 文本值
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年9月7日 lizhongwen
 */
@XmlType(name = "text")
public class TextValue {
    
    /** 文本 */
    private String text;
    
    /**
     * @return 获取 text属性值
     */
    @XmlValue
    public String getText() {
        return text;
    }
    
    /**
     * @param text 设置 text 属性值为参数值 text
     */
    public void setText(String text) {
        this.text = text;
    }
    
}
