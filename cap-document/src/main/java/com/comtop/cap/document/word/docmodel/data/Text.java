/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docmodel.data;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.document.word.docmodel.datatype.ContentType;
import com.comtop.cap.document.word.docmodel.datatype.TextType;

/**
 * 文本内容
 * 
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年10月15日 lizhiyong
 */
public class Text extends SimplexSeg {
    
    /** 类序列号 */
    private static final long serialVersionUID = 1L;
    
    /** 文本块集 */
    private List<String> textBlocks = new ArrayList<String>();
    
    /** 文本类型： 分隔文本 内容文本 */
    private TextType textType;
    
    @Override
    public String getContentType() {
        return ContentType.TEXT.name();
    }
    
    /**
     * @return 获取 textType属性值
     */
    public TextType getTextType() {
        return textType;
    }
    
    /**
     * @param textType 设置 textType 属性值为参数值 textType
     */
    public void setTextType(TextType textType) {
        this.textType = textType;
    }
    
    /**
     * 添加文本块
     *
     * @param block 文本块
     */
    public void addTextBlock(String block) {
        textBlocks.add(block);
    }
    
    /**
     * 获得文本内容
     *
     * @return 文本内容
     */
    public String getText() {
        StringBuffer sbBuffer = new StringBuffer();
        for (String string : textBlocks) {
            sbBuffer.append(string);
        }
        return sbBuffer.toString();
    }
    
    @Override
    public String getContent() {
        if (StringUtils.isNotBlank(content)) {
            return content;
        }
        content = getText();
        return content;
    }
}
