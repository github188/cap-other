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
 * 章节类
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年10月15日 lizhiyong
 */
public class Chapter extends Container {
    
    /** 类序列号 */
    private static final long serialVersionUID = 1L;
    
    /** 编号 */
    private String chapterNo;
    
    /** 名称 */
    private String title;
    
    /** 大纲级别 */
    private OutlineLevel outlineLevel;
    
    /** 前一章节 */
    private Chapter preChapter;
    
    /** 后一章节 */
    private Chapter nextChapter;
    
    /** 子章节 */
    private List<Chapter> childChapters = new ArrayList<Chapter>(10);
    
    /** 上级章节 */
    private Chapter parentChapter;
    
    /** 所属节 */
    private Section section;
    
    /**
     * @return 获取 section属性值
     */
    public Section getSection() {
        return section;
    }
    
    /**
     * @param section 设置 section 属性值为参数值 section
     */
    public void setSection(Section section) {
        this.section = section;
    }
    
    /**
     * @return 获取 childChapters属性值
     */
    public List<Chapter> getChildChapters() {
        return childChapters;
    }
    
    /**
     * @return 获取 parent属性值
     */
    public Chapter getParentChapter() {
        return parentChapter;
    }
    
    /**
     * @param parent 设置 parent 属性值为参数值 parent
     */
    public void setParentChapter(Chapter parent) {
        this.parentChapter = parent;
    }
    
    @Override
    public Container getParent() {
        return parentChapter == null ? section : parentChapter;
    }
    
    /**
     * @return 获取 name属性值
     */
    public String getTitle() {
        return this.title;
    }
    
    /**
     * @param title 设置 name 属性值为参数值 title
     */
    public void setTitle(String title) {
        this.title = title;
    }
    
    /**
     * @return 获取 chapterNo属性值
     */
    public String getChapterNo() {
        return chapterNo;
    }
    
    /**
     * @param chapterNo 设置 chapterNo 属性值为参数值 chapterNo
     */
    public void setChapterNo(String chapterNo) {
        this.chapterNo = chapterNo;
    }
    
    @Override
    public String toString() {
        StringBuffer sb = new StringBuffer(256);
        sb.append("章节:").append(getChapterNo()).append(":").append(getTitle()).append("\r\n");
        sb.append(super.toString());
        for (Chapter chapter : childChapters) {
            sb.append(chapter.toString()).append("\r\n");
        }
        return sb.toString();
    }
    
    @Override
    protected void addElementToChildType(WordElement wordElement) {
        super.addElementToChildType(wordElement);
        if (wordElement instanceof Chapter) {
            Chapter chapter = (Chapter) wordElement;
            chapter.setParentChapter(this);
            chapter.setParent(this);
            int size = childChapters.size();
            if (size > 0) {
                Chapter tempChapter = childChapters.get(size - 1);
                chapter.setPreChapter(tempChapter);
                tempChapter.setNextChapter(chapter);
            }
            this.childChapters.add(chapter);
            chapter.setSortNo(size + 1);
        }
    }
    
    @Override
    public String getName() {
        if (StringUtils.isBlank(super.getName())) {
            return getTitle();
        }
        return super.getName();
    }
    
    /**
     * @return 获取 outlineLevel属性值
     */
    public OutlineLevel getOutlineLevel() {
        return outlineLevel;
    }
    
    /**
     * @param outlineLevel 设置 outlineLevel 属性值为参数值 outlineLevel
     */
    public void setOutlineLevel(OutlineLevel outlineLevel) {
        this.outlineLevel = outlineLevel;
    }
    
    /**
     * @return 获取 preChapter属性值
     */
    public Chapter getPreChapter() {
        return preChapter;
    }
    
    /**
     * @param preChapter 设置 preChapter 属性值为参数值 preChapter
     */
    public void setPreChapter(Chapter preChapter) {
        this.preChapter = preChapter;
    }
    
    /**
     * @return 获取 nextChapter属性值
     */
    public Chapter getNextChapter() {
        return nextChapter;
    }
    
    /**
     * @param nextChapter 设置 nextChapter 属性值为参数值 nextChapter
     */
    public void setNextChapter(Chapter nextChapter) {
        this.nextChapter = nextChapter;
    }
    
    /**
     * 获得已有章节中的最后一个章节
     *
     * @return 最后一个章节 没找到返回null
     */
    public Chapter getLastChapter() {
        return super.getLastChapter(childChapters);
    }
    
    /**
     * 
     * 获得指定大纲等级的最后一个章节
     *
     * @param linelevel 大纲等级
     * @return 符合条件的最后一个章节 没有返回null
     */
    public Chapter getLastChapter(int linelevel) {
        return getLastChapter(this.childChapters, linelevel);
    }
    
    /**
     * 
     * 获得指定大纲等级的最后一个上级章节
     *
     * @param lineLevel 大纲等级
     * @return 符合条件的最后一个上级章节 没有返回null
     */
    public Chapter getLastParentChapter(OutlineLevel lineLevel) {
        return getLastParentChapter(this.childChapters, lineLevel);
    }
    
    @Override
    public String getUriChain() {
        if (getParentChapter() == null) {
            return getChapterDes();
        }
        return getParentChapter().getUriChain() + "/" + getChapterDes();
    }
    
    /**
     * 获得章节描述
     *
     * @return 章节描述
     */
    private String getChapterDes() {
        if (StringUtils.isBlank(this.getChapterNo())) {
            return this.getTitle();
        }
        return '[' + this.getChapterNo() + ']' + this.getTitle();
    }
}
