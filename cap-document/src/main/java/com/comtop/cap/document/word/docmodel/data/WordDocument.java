/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docmodel.data;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;

import com.comtop.cap.document.word.WordOptions;
import com.comtop.cap.document.word.docconfig.model.DocConfig;

/**
 * Word文档
 * 
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年10月15日 lizhiyong
 */
public class WordDocument extends Container {
    
    /** 类序列号 */
    private static final long serialVersionUID = 1L;
    
    /*** 分节集 */
    private final List<Section> sections = new ArrayList<Section>(10);
    
    /**
     * 默认分节 对于一个有分节的word文档来说，默认分节内容分节（正文节。一般情况下，该分节中有章节划分）。
     * 如果一个文档从头到尾都没有设置分节，则整个文档是一个分节。
     * 做此设计的主要目标是便于后续以分节为基础进行页眉页脚等功能的处理。
     */
    private Section currentSection;
    
    /** 文档模板 */
    private DocConfig docConfig;
    
    /** 文档版本 */
    private String version;
    
    /** 业务域id */
    private String domainId;
    
    /** word选项 */
    private WordOptions options;
    
    /** 章节表达式执行计数器 */
    private final AtomicInteger CHAPTER_COUNTER = new AtomicInteger(0);
    
    /**
     * @return 获取 cHAPTER_COUNTER属性值
     */
    public AtomicInteger getChapterCounter() {
        return CHAPTER_COUNTER;
    }
    
    /**
     * 
     * 构造函数
     * 
     * @param docConfig word模板对象
     */
    public WordDocument(DocConfig docConfig) {
        this.docConfig = docConfig;
        this.currentSection = new Section();
        currentSection.setUri(docConfig.getCurrentSection().getName());
        currentSection.setDocument(this);
        currentSection.setDefinition(this.getDocConfig().getCurrentSection());
        this.sections.add(this.currentSection);
        // this.elements.add(this.currentSection);
    }
    
    /**
     * 
     * 定位到下一个节上
     *
     * @return 定位的节。没找到抛出异常
     */
    public Section locateNextSection() {
        int index = sections.indexOf(currentSection);
        // if (sections.size() <= index + 1) {
        // throw new WordParseException("Word模板中定义的节数已达到最大值。引起此问题的可能原因是模板中定义的节数据 与文档中的节数不一致");
        // }
        currentSection = sections.get(index + 1);
        return currentSection;
    }
    
    /**
     * 
     * 获得默认分节
     *
     * @return 分节 对象
     */
    public Section getCurrentSection() {
        return currentSection;
    }
    
    /**
     * 获得正文分节
     *
     * @return 正文分节。如果没有，返回null。
     */
    public Section getMainSection() {
        if (sections.size() == 1) {
            return sections.get(0);
        }
        for (Section section : sections) {
            if (section.isMainSection()) {
                return section;
            }
        }
        return null;
    }
    
    /**
     * @param currentSection 设置 currentSection 属性值为参数值 currentSection
     */
    public void setCurrentSection(Section currentSection) {
        this.currentSection = currentSection;
    }
    
    /**
     * @return 获取 docTemplate属性值
     */
    @Override
    public DocConfig getDocConfig() {
        return docConfig;
    }
    
    /**
     * @return 获取 version属性值
     */
    public String getVersion() {
        return version;
    }
    
    /**
     * @param version 设置 version 属性值为参数值 version
     */
    public void setVersion(String version) {
        this.version = version;
    }
    
    @Override
    protected void addElementToChildType(WordElement wordElement) {
        if (wordElement instanceof Section) {
            Section section = (Section) wordElement;
            section.setDocConfig(this.getDocConfig());
            section.setDocument(this);
            int size = this.sections.size();
            if (size > 0) {
                Section preSection = sections.get(size - 1);
                preSection.setNextSection(section);
                section.setPreSection(preSection);
            }
            this.sections.add(section);
        }
    }
    
    /**
     * @return 获取 sections属性值
     */
    public List<Section> getSections() {
        return sections;
    }
    
    /**
     * @return 获取 domainId属性值
     */
    public String getDomainId() {
        return domainId;
    }
    
    /**
     * @param domainId 设置 domainId 属性值为参数值 domainId
     */
    public void setDomainId(String domainId) {
        this.domainId = domainId;
    }
    
    /**
     * @return 获取 options属性值
     */
    public WordOptions getOptions() {
        return options;
    }
    
    /**
     * @param options 设置 options 属性值为参数值 options
     */
    public void setOptions(WordOptions options) {
        this.options = options;
    }
    
}
