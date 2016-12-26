/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docmodel.data;

import java.math.BigInteger;
import java.text.MessageFormat;

import org.apache.commons.lang.StringUtils;

/**
 * 段落
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年12月30日 lizhiyong
 */
public class Paragraph extends ComplexSeg {
    
    /** 序列号 */
    private static final long serialVersionUID = 1L;
    
    /** 当前文本 */
    private Text curText;
    
    /** 是否列表段落 */
    private boolean isList;
    
    /** 是否是有序列表 */
    private boolean isOl;
    
    /** 列表层次 */
    private BigInteger listLevel;
    
    /** 列表的唯一标标志 */
    private BigInteger listKey;
    
    /**
     * 
     * 添加子元素。本方法将子元素添加到所有列表，分类列表及用户自定义的列表。用户自定义的列表需要用户实现 addElementToChildType方法
     *
     * @param contentSeg word元素
     */
    @Override
    public void addChildContentSeg(ContentSeg contentSeg) {
        if (contentSeg instanceof Text || contentSeg instanceof Graphic || contentSeg instanceof EmbedObject) {
            SimplexSeg simplexSeg = (SimplexSeg) contentSeg;
            contents.add(simplexSeg);
            simplexSeg.setSortNo(contents.size());
            simplexSeg.setContainer(getContainer());
            simplexSeg.setParagraphContainer(this);
            return;
        }
        throw new RuntimeException(MessageFormat.format("Paragraph不支持的内容片断类型{0},只支持{1}:", contentSeg.getClass()
            .getName(), "纯文本、图片、嵌入式对象"));
    }
    
    /**
     * @return 获取 listLevel属性值
     */
    public BigInteger getListLevel() {
        return listLevel;
    }
    
    /**
     * @param listLevel 设置 listLevel 属性值为参数值 listLevel
     */
    public void setListLevel(BigInteger listLevel) {
        this.listLevel = listLevel;
    }
    
    /**
     * 添加文本块到当前文本对象中
     *
     * @param block 文本块
     */
    public void addTextBlockToCurText(String block) {
        getCurText().addTextBlock(block);
    }
    
    /**
     * 结束当前文本对象
     *
     */
    public void endCurText() {
        this.curText = null;
    }
    
    /**
     * 添加一个新的文本
     *
     */
    private void addNewText() {
        this.curText = new Text();
        addChildContentSeg(this.curText);
    }
    
    /**
     * @return 获取 curText属性值
     */
    private Text getCurText() {
        if (curText == null) {
            addNewText();
        }
        return curText;
    }
    
    /**
     * @return 获取 isList属性值
     */
    public boolean isList() {
        return isList;
    }
    
    /**
     * @param isList 设置 isList 属性值为参数值 isList
     */
    public void setList(boolean isList) {
        this.isList = isList;
    }
    
    /**
     * @return 获取 isOl属性值
     */
    public boolean isOl() {
        return isOl;
    }
    
    /**
     * @param isOl 设置 isOl 属性值为参数值 isOl
     */
    public void setOl(boolean isOl) {
        this.isOl = isOl;
    }
    
    /**
     * @return 获取 listKey属性值
     */
    public BigInteger getListKey() {
        return listKey;
    }
    
    /**
     * @param listKey 设置 listKey 属性值为参数值 listKey
     */
    public void setListKey(BigInteger listKey) {
        this.listKey = listKey;
    }
    
    @Override
    public String getContent() {
        if (StringUtils.isNotBlank(content)) {
            return content;
        }
        StringBuffer sbBuffer = new StringBuffer();
        for (ContentSeg seg : contents) {
            if (StringUtils.isNotBlank(seg.getContent())) {
                sbBuffer.append(seg.getContent());
            }
        }
        String pContent = sbBuffer.toString();
        StringBuffer sbRet = new StringBuffer();
        if (StringUtils.isBlank(pContent)) {
            sbRet.append("<p/>");
        } else {
            sbRet.append("<p>");
            sbRet.append(pContent);
            sbRet.append("</p>");
        }
        content = sbRet.toString();
        return content;
    }
}
