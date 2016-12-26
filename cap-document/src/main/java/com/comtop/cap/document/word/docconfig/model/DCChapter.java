/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docconfig.model;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;
import java.util.regex.PatternSyntaxException;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlElements;
import javax.xml.bind.annotation.XmlTransient;
import javax.xml.bind.annotation.XmlType;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.document.word.docconfig.datatype.ChapterType;
import com.comtop.cap.document.word.docconfig.datatype.OutlineLevel;
import com.comtop.cap.document.word.parse.util.ExprUtil;

/**
 * 模板中的章节对象
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年10月15日 lizhiyong
 */
@XmlType(name = "ChapterElementType")
@XmlAccessorType(XmlAccessType.FIELD)
public class DCChapter extends DCContainer {
    
    /** 类序列化号 */
    private static final long serialVersionUID = 1L;
    
    /**
     * logger
     */
    protected static final Logger LOGGER = LoggerFactory.getLogger(DCChapter.class);
    
    /** 章节类型 */
    @XmlAttribute(name = "type", required = true)
    private ChapterType chapterType;
    
    /** 章节编号，目前未用 */
    @XmlTransient
    private String chapterNo;
    
    /** 标题 可以是具体标题名称、正则表达式或表达式 */
    @XmlAttribute(required = true)
    private String title;
    
    /** 大纲级别 根据层次自动计算出来，无须用户配置 */
    @XmlTransient
    private OutlineLevel outlineLevel;
    
    /** 当前章节的前一章节,初始化时自动计算 */
    @XmlTransient
    private DCChapter preChapter;
    
    /** 当前章节的后一章节,初始化时自动计算 */
    @XmlTransient
    private DCChapter nextChapter;
    
    /** 当前章节的子章节集，初始化时根据章节下的元素集自动计算出来 */
    @XmlTransient
    private List<DCChapter> childChapters = new ArrayList<DCChapter>(10);
    
    /** 当前章节的描述， 用于在模板中描述章节信息。目前未启用 */
    @XmlAttribute
    private String description;
    
    /** 当前章节的填写说明，用于在模板中描述章节的填写说明，在系统中 展示时用户可以知道当前章节该怎么填写。目前未启用 */
    @XmlAttribute
    private String fillDescription;
    
    /** 当前章节的上级章节,初始化时根据章节的层次自动计算出来 */
    @XmlTransient
    private DCChapter parentChapter;
    
    /** 当前章节所属分节 */
    @XmlTransient
    private DCSection section;
    
    /***
     * 标题文本样式，用于在导入word文档时，匹配章节名称。此参数是为了支持模糊匹配，使得一个配置可以支持更多的类似章节名称。
     * 比如章节名称为 “与可研架构差异”、“架构差异表”等章节名称可以使用同一个正则表达式来匹配。这样操作主要原因是文档是人工写的，
     * 对章节标题而言，总会出现多字或少字的情况，但其实其含义是一样的。支持正则表达式的匹配，可以更智能的匹配。
     * */
    @XmlTransient
    private Pattern titlePattern;
    
    /** 固定章节的标准标题。模板中配置的某些章节是标题是正则表达式形式的，但对于章节展示或导出而言，需要明确的具体的标题，此值即是根据正则表达式求出的来标准标题 */
    @XmlTransient
    private String fixedTitle;
    
    /** 标题是否作为选择器，非必填 。默认情况下，动态章节的title表达式会作为选择条件。一个标题如果作为选择器，可以进行前端过滤。 */
    @XmlAttribute
    private Boolean titleAsSelector;
    
    /** 是否启用。一般用函数表达式来处理。如果不填，默认为启用。如果填写了，以表达式的值来判断是否启用。如果章节未启用，导出时不会导出。 */
    @XmlAttribute
    private String enable;
    
    /**
     * @return 获取 section属性值
     */
    public DCSection getSection() {
        return section;
    }
    
    /**
     * @param section 设置 section 属性值为参数值 section
     */
    public void setSection(DCSection section) {
        this.section = section;
    }
    
    /**
     * @return 获取 chapterType属性值
     */
    public ChapterType getChapterType() {
        return chapterType;
    }
    
    /**
     * @param chapterType 设置 chapterType 属性值为参数值 chapterType
     */
    public void setChapterType(ChapterType chapterType) {
        this.chapterType = chapterType;
    }
    
    /**
     * @return 获取 childChapters属性值
     */
    public List<DCChapter> getChildChapters() {
        return childChapters;
    }
    
    /**
     * @return 获取 parent属性值
     */
    public DCChapter getParentChapter() {
        return parentChapter;
    }
    
    /**
     * @param parent 设置 parent 属性值为参数值 parent
     */
    public void setParentChapter(DCChapter parent) {
        this.parentChapter = parent;
    }
    
    @Override
    public DCContainer getParent() {
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
     * @return 获取 description属性值
     */
    public String getDescription() {
        return description;
    }
    
    /**
     * @param description 设置 description 属性值为参数值 description
     */
    public void setDescription(String description) {
        this.description = description;
    }
    
    /**
     * @return 获取 fillDescription属性值
     */
    public String getFillDescription() {
        return fillDescription;
    }
    
    /**
     * @param fillDescription 设置 fillDescription 属性值为参数值 fillDescription
     */
    public void setFillDescription(String fillDescription) {
        this.fillDescription = fillDescription;
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
        for (DCChapter chapter : childChapters) {
            sb.append(chapter.toString()).append("\r\n");
        }
        return sb.toString();
    }
    
    @XmlElements({ @XmlElement(name = "WtChapter", type = DCChapter.class),
        @XmlElement(name = "span", type = DCContentSeg.class), @XmlElement(name = "table", type = DCTable.class),
        @XmlElement(name = "WtEmbed", type = DCEmbedObject.class),
        @XmlElement(name = "WtGraphic", type = DCGraphic.class) })
    @Override
    public List<ConfigElement> getElements() {
        return super.getElements();
    }
    
    @Override
    protected void addElementToChildType(ConfigElement element) {
        super.addElementToChildType(element);
        if (element instanceof DCChapter) {
            DCChapter chapter = (DCChapter) element;
            chapter.setParentChapter(this);
            chapter.setParent(this);
            int size = childChapters.size();
            if (size > 0) {
                DCChapter tempChapter = childChapters.get(size - 1);
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
     * 获得固定章节的名称
     *
     * @return 固定章节的名称
     */
    public String getFixedTitle() {
        return this.fixedTitle;
    }
    
    @Override
    public void initConfig() {
        // 调用父类容器的初始化
        super.initConfig();
        
        // 设置当前章节的Uri和大约级别
        if (parentChapter != null) {
            setOutlineLevel(parentChapter.getOutlineLevel().getChild());
            setUri(parentChapter.getUri() + "/" + this.title);
        } else {
            setOutlineLevel(OutlineLevel.LEVEL1);
            setUri(this.title);
        }
        // 设置固定章节的标准名称
        if (chapterType == ChapterType.FIXED) {
            String[] titles = this.title.split("[\\|]");
            this.fixedTitle = titles[0].replaceAll("\\.\\*", "");
        }
        String mappingTo = super.getMappingTo();
        if (StringUtils.isNotBlank(mappingTo)) {
            // 计算当前章节对应的类
            mappingToClass = ExprUtil.getExprClass(this);
            // 计算当前章节对应的查询参数引用
            Map<String, String> queryParams = ExprUtil.getQueryParams(mappingTo);
            addSelfQueryParamExprs(queryParams);
        }
        
        // 初始化子章节
        for (DCChapter chapater : childChapters) {
            chapater.setParentChapter(this);
            chapater.setDocConfig(getDocConfig());
            chapater.initConfig();
        }
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
     * @return 获取 titlePattern属性值
     */
    public Pattern getTitlePattern() {
        if (titlePattern == null && getChapterType() == ChapterType.FIXED) {
            try {
                if (StringUtils.isBlank(title)) {
                    return null;
                }
                String titleRex = this.title;
                
                if (!this.title.startsWith("^")) {
                    titleRex = "^" + titleRex;
                }
                if (!this.title.endsWith("$")) {
                    titleRex = titleRex + "$";
                }
                titlePattern = Pattern.compile(titleRex);
            } catch (PatternSyntaxException e) {
            	LOGGER.debug("获取 titlePattern属性值 error", e
            			
            			
            			
            			
            			
            			
            			
            			
            			
            			
            			
            			
            			
            			
            			
            			
            			
            			
            			
            			
            			
            			
            			
            			
            			
            			
            			
            			 );
                return null;
            }
        }
        return titlePattern;
    }
    
    /**
     * @param titlePattern 设置 titlePattern 属性值为参数值 titlePattern
     */
    public void setTitlePattern(Pattern titlePattern) {
        this.titlePattern = titlePattern;
    }
    
    /**
     * @return 获取 preChapter属性值
     */
    public DCChapter getPreChapter() {
        return preChapter;
    }
    
    /**
     * @param preChapter 设置 preChapter 属性值为参数值 preChapter
     */
    public void setPreChapter(DCChapter preChapter) {
        this.preChapter = preChapter;
    }
    
    /**
     * @return 获取 nextChapter属性值
     */
    public DCChapter getNextChapter() {
        return nextChapter;
    }
    
    /**
     * @param nextChapter 设置 nextChapter 属性值为参数值 nextChapter
     */
    public void setNextChapter(DCChapter nextChapter) {
        this.nextChapter = nextChapter;
    }
    
    /**
     * @return 获取 titleSelector属性值
     */
    public Boolean getTitleAsSelector() {
        return titleAsSelector == null ? true : titleAsSelector;
    }
    
    /**
     * @param titleSelector 设置 titleSelector 属性值为参数值 titleSelector
     */
    public void setTitleAsSelector(Boolean titleSelector) {
        this.titleAsSelector = titleSelector;
    }
    
    /**
     * @return 获取 enable属性值
     */
    public String getEnable() {
        return enable;
    }
    
    /**
     * @param enable 设置 enable 属性值为参数值 enable
     */
    public void setEnable(String enable) {
        this.enable = enable;
    }
}
