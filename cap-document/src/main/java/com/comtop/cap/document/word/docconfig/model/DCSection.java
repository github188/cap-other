/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docconfig.model;

import java.util.ArrayList;
import java.util.List;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlElements;
import javax.xml.bind.annotation.XmlTransient;
import javax.xml.bind.annotation.XmlType;

/**
 * 模板中的分节对象
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年10月20日 lizhiyong
 */
@XmlType(name = "SectionElementType")
@XmlAccessorType(XmlAccessType.FIELD)
public class DCSection extends DCContainer {
    
    /** 类序列号 */
    private static final long serialVersionUID = 1L;
    
    /** 章节集 */
    @XmlTransient
    private List<DCChapter> chapters = new ArrayList<DCChapter>(10);
    
    /** 分节类型 未启用 */
    @XmlAttribute
    private String type;
    
    /** 是否正文分节 */
    @XmlTransient
    private boolean isMainSection = false;
    
    /** 前一个分节 */
    @XmlTransient
    private DCSection preSection;
    
    /** 下一个分节 */
    @XmlTransient
    private DCSection nextSection;
    
    /**
     * @return 获取 type属性值
     */
    public String getType() {
        return type;
    }
    
    /**
     * @param type 设置 type 属性值为参数值 type
     */
    public void setType(String type) {
        this.type = type;
    }
    
    @XmlElements({ @XmlElement(name = "WtChapter", type = DCChapter.class, nillable = true),
        @XmlElement(name = "span", type = DCContentSeg.class, nillable = true),
        @XmlElement(name = "table", type = DCTable.class, nillable = true),
        @XmlElement(name = "WtEmbed", type = DCEmbedObject.class, nillable = true),
        @XmlElement(name = "WtGraphic", type = DCGraphic.class, nillable = true) })
    @Override
    public List<ConfigElement> getElements() {
        return super.getElements();
    }
    
    /**
     * @return 获取 chapters属性值
     */
    public List<DCChapter> getChapters() {
        return chapters;
    }
    
    /**
     * 
     * 添加章节
     *
     * @param chapter 章节
     */
    public void addChapter(DCChapter chapter) {
        this.isMainSection = true;
        this.chapters.add(chapter);
    }
    
    @Override
    public void initConfig() {
        // 调用父类容器的方法
        super.initConfig();
        // 初始化章节
        for (DCChapter chapater : chapters) {
            chapater.setDocConfig(getDocConfig());
            chapater.initConfig();
        }
        if (chapters.size() > 0) {
            this.isMainSection = true;
        }
    }
    
    @Override
    protected void addElementToChildType(ConfigElement wordElement) {
        super.addElementToChildType(wordElement);
        if (wordElement instanceof DCChapter) {
            DCChapter chapter = (DCChapter) wordElement;
            chapter.setSection(this);
            chapter.setParent(this);
            int size = chapters.size();
            if (size > 0) {
                DCChapter tempChapter = chapters.get(size - 1);
                chapter.setPreChapter(tempChapter);
                tempChapter.setNextChapter(chapter);
            }
            this.chapters.add(chapter);
            chapter.setSortNo(size + 1);
            this.isMainSection = true;
        }
    }
    
    @Override
    public String toString() {
        StringBuffer sb = new StringBuffer();
        sb.append(super.toString());
        for (DCChapter chapter : chapters) {
            sb.append(chapter.toString()).append("\r\n");
        }
        return sb.toString();
    }
    
    /**
     * @return 获取 isMainSection属性值
     */
    public boolean isMainSection() {
        return isMainSection;
    }
    
    /**
     * @param isMainSection 设置 isMainSection 属性值为参数值 isMainSection
     */
    public void setMainSection(boolean isMainSection) {
        this.isMainSection = isMainSection;
    }
    
    /**
     * @return 获取 preSection属性值
     */
    public DCSection getPreSection() {
        return preSection;
    }
    
    /**
     * @param preSection 设置 preSection 属性值为参数值 preSection
     */
    public void setPreSection(DCSection preSection) {
        this.preSection = preSection;
    }
    
    /**
     * @return 获取 nextSection属性值
     */
    public DCSection getNextSection() {
        return nextSection;
    }
    
    /**
     * @param nextSection 设置 nextSection 属性值为参数值 nextSection
     */
    public void setNextSection(DCSection nextSection) {
        this.nextSection = nextSection;
    }
    
}
