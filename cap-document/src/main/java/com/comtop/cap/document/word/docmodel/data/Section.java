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

import com.comtop.cap.document.word.docconfig.datatype.OutlineLevel;

/**
 * 分节对象
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年10月20日 lizhiyong
 */
public class Section extends Container {
    
    /** 类序列号 */
    private static final long serialVersionUID = 1L;
    
    /** 章节集 */
    private List<Chapter> chapters = new ArrayList<Chapter>(10);
    
    /** 类型 */
    private String type;
    
    /** 是否正文分节 */
    private boolean isMainSection = false;
    
    /** 前一个分节 */
    private Section preSection;
    
    /** 下一个分节 */
    private Section nextSection;
    
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
    
    /**
     * @return 获取 chapters属性值
     */
    public List<Chapter> getChapters() {
        return chapters;
    }
    
    /**
     * 
     * 添加章节
     *
     * @param chapter 章节
     */
    public void addChapter(Chapter chapter) {
        this.isMainSection = true;
        this.chapters.add(chapter);
    }
    
    @Override
    protected void addElementToChildType(WordElement wordElement) {
        super.addElementToChildType(wordElement);
        if (wordElement instanceof Chapter) {
            Chapter chapter = (Chapter) wordElement;
            chapter.setSection(this);
            chapter.setParent(this);
            int size = chapters.size();
            if (size > 0) {
                Chapter tempChapter = chapters.get(size - 1);
                chapter.setPreChapter(tempChapter);
                tempChapter.setNextChapter(chapter);
            }
            this.chapters.add(chapter);
            chapter.setSortNo(size + 1);
            this.isMainSection = true;
        }
    }
    
    /**
     * 获得已有章节中的最后一个章节
     *
     * @return 最后一个章节 没找到返回null
     */
    public Chapter getLastChapter() {
        return super.getLastChapter(chapters);
    }
    
    /**
     * 
     * 获得指定大纲等级的最后一个章节
     *
     * @param outlineLevel 大纲等级
     * @return 符合条件的最后一个章节 没有返回null
     */
    public Chapter getLastChapter(int outlineLevel) {
        return getLastChapter(this.chapters, outlineLevel);
    }
    
    /**
     * 
     * 获得指定大纲等级的最后一个上级章节
     *
     * @param outlineLevel 大纲等级
     * @return 符合条件的最后一个上级章节 没有返回null
     */
    public Chapter getLastParentChapter(OutlineLevel outlineLevel) {
        return getLastParentChapter(this.chapters, outlineLevel);
    }
    
    @Override
    public String toString() {
        StringBuffer sb = new StringBuffer();
        sb.append(super.toString());
        for (Chapter chapter : chapters) {
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
    
    @Override
    public String getUriName() {
        String uriName = super.getUriName();
        return StringUtils.isBlank(uriName) ? super.getUri() : uriName;
    }
    
    /**
     * @return 获取 preSection属性值
     */
    public Section getPreSection() {
        return preSection;
    }
    
    /**
     * @param preSection 设置 preSection 属性值为参数值 preSection
     */
    public void setPreSection(Section preSection) {
        this.preSection = preSection;
    }
    
    /**
     * @return 获取 nextSection属性值
     */
    public Section getNextSection() {
        return nextSection;
    }
    
    /**
     * @param nextSection 设置 nextSection 属性值为参数值 nextSection
     */
    public void setNextSection(Section nextSection) {
        this.nextSection = nextSection;
    }
    
    /**
     * @param document 设置 document 属性值为参数值 document
     */
    @Override
    public void setDocument(WordDocument document) {
        super.setDocument(document);
    }
    
    @Override
    public String getUriChain() {
        return getUri();
    }
}
