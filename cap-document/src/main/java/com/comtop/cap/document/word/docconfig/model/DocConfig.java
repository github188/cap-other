/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docconfig.model;

import java.io.File;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.regex.Pattern;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlElements;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlTransient;
import javax.xml.bind.annotation.XmlType;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.document.word.WordOptions;

/**
 * 模板定义
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年11月12日 lizhiyong
 */
@XmlRootElement(name = "WtDocConfig")
@XmlType(name = "DocConfigType")
@XmlAccessorType(XmlAccessType.FIELD)
public class DocConfig implements Serializable {
    
    /** 序列号 */
    private static final long serialVersionUID = 1L;
    
    /** 标记文本定义 */
    @XmlElement(name = "MarkText", type = String.class, required = false)
    private String markText;
    
    /** 空值文本定义 */
    @XmlElement(name = "NullValueText", type = String.class, required = false)
    private String nullValueText;
    
    /** 目录文本定义,指目录分节的 标题 */
    @XmlElement(name = "DirText", type = String.class, required = false)
    private String dirText;
    
    /** 分节集 */
    @XmlElements(@XmlElement(name = "WtSection", type = DCSection.class, required = true))
    private final List<DCSection> sections = new ArrayList<DCSection>(10);
    
    /** 模板名称，目前未用 */
    @XmlAttribute(name = "name", required = true)
    private String name;
    
    /** 模板版本，目前未用 */
    @XmlAttribute(name = "version", required = false)
    private String version;
    
    /*** 文档名称样式，目前未用，用于判断文档名称是否是标准名称 */
    @XmlAttribute(name = "docNamePattern", required = false)
    private String docNamePattern;
    
    /** 文档名称中的业务域样式，目前未用。用于识别业务域信息，便于导入时智能判断当前选择的文档与选择的节点是否匹配 */
    @XmlAttribute(name = "bizDomainPattern", required = false)
    private String bizDomainPattern;
    
    /** 模板名称中的识别关键字，目前未用 */
    @XmlAttribute(name = "diffKey", required = false)
    private String diffKey;
    
    /** 默认的分节 */
    @XmlTransient
    private DCSection currentSection;
    
    /** 模板文件对象 */
    @XmlTransient
    private File configFile;
    
    /** 标记文本样式 */
    @XmlTransient
    private Pattern markTextPattern;
    
    /** 空值文本样式 */
    @XmlTransient
    private Pattern nullValueTextPattern;
    
    /** 目录文本样式 */
    @XmlTransient
    private Pattern dirTextPattern;
    
    /** 模板对象修改次数 */
    @XmlTransient
    private AtomicInteger modifyTimes = new AtomicInteger(0);
    
    /** 验证级别，目前未用。计划用于模板校验不通过，直接停止操作 */
    @XmlTransient
    private int validateResultLevel;
    
    /** word选项 */
    @XmlTransient
    private WordOptions options;
    
    /**
     * 
     * 初始化
     * 
     * @param wordOptions 选项
     *
     */
    public void init(WordOptions wordOptions) {
        this.options = wordOptions;
        if (sections != null && sections.size() > 0) {
            currentSection = sections.get(0);
        }
        int i = -1;
        DCSection preSection = null;
        // 初始化分节
        for (DCSection section : sections) {
            i++;
            if (i >= 1) {
                preSection = sections.get(i - 1);
                preSection.setNextSection(section);
                section.setPreSection(preSection);
            }
            section.setDocConfig(this);
            section.setUri(section.getName());
            section.initConfig();
        }
        
        // 初始化各种需要特殊处理的文本样式
        if (StringUtils.isNotBlank(markText)) {
            markTextPattern = Pattern.compile(markText);
        } else {
            markTextPattern = Pattern.compile("^\\s*数据项信息.*[：:]|^\\s*数据项说明.*[：:]|.*关联信息.*[：:]");
        }
        if (StringUtils.isNotBlank(nullValueText)) {
            nullValueTextPattern = Pattern.compile(nullValueText);
        } else {
            nullValueTextPattern = Pattern.compile("^\\s*无$|^\\s*无\\s*。$");
        }
        if (StringUtils.isNotBlank(dirText)) {
            dirTextPattern = Pattern.compile(dirText);
        } else {
            dirTextPattern = Pattern.compile("^目.*录$");
        }
    }
    
    /**
     * @return 获取 options属性值
     */
    public WordOptions getOptions() {
        return options;
    }
    
    /**
     * @return 获取 defaultSection属性值
     */
    public DCSection getCurrentSection() {
        return currentSection;
    }
    
    /**
     * 定位到下一个Section
     *
     * @return 被定位的section
     */
    public DCSection locateNextSection() {
        int index = sections.indexOf(currentSection);
        if (sections.size() <= index + 1) {
            return null;
        }
        currentSection = sections.get(index + 1);
        return currentSection;
    }
    
    /**
     * 添加一个新的分节
     * 
     * @param sectionName 分节名称
     *
     * @return 新创建的分节
     */
    public DCSection createNewSection(String sectionName) {
        DCSection section = new DCSection();
        String sectionUri = sectionName;
        if (StringUtils.isBlank(sectionUri)) {
            sectionUri = "第" + sections.size() + "节";
        }
        section.setUri(sectionUri);
        section.setName(sectionUri);
        section.setPreSection(sections.get(sections.size() - 1));
        section.setDocConfig(this);
        section.initConfig();
        sections.add(section);
        currentSection = section;
        incrementModifyTimes();
        return section;
    }
    
    /**
     * @return 获取 sections属性值
     */
    public List<DCSection> getSections() {
        return sections;
    }
    
    /**
     * @return 获取 diffKey属性值
     */
    public String getDiffKey() {
        return diffKey;
    }
    
    /**
     * @param diffKey 设置 diffKey 属性值为参数值 diffKey
     */
    public void setDiffKey(String diffKey) {
        this.diffKey = diffKey;
    }
    
    /**
     * @return 获取 name属性值
     */
    public String getName() {
        return name;
    }
    
    /**
     * @param name 设置 name 属性值为参数值 name
     */
    public void setName(String name) {
        this.name = name;
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
    
    /**
     * @return 获取 docNamePattern属性值
     */
    public String getDocNamePattern() {
        return docNamePattern;
    }
    
    /**
     * @param docNamePattern 设置 docNamePattern 属性值为参数值 docNamePattern
     */
    public void setDocNamePattern(String docNamePattern) {
        this.docNamePattern = docNamePattern;
    }
    
    /**
     * @return 获取 bizDomainPattern属性值
     */
    public String getBizDomainPattern() {
        return bizDomainPattern;
    }
    
    /**
     * @param bizDomainPattern 设置 bizDomainPattern 属性值为参数值 bizDomainPattern
     */
    public void setBizDomainPattern(String bizDomainPattern) {
        this.bizDomainPattern = bizDomainPattern;
    }
    
    /**
     * @return 获取 markText属性值
     */
    public String getMarkText() {
        return markText;
    }
    
    /**
     * @param markText 设置 markText 属性值为参数值 markText
     */
    public void setMarkText(String markText) {
        this.markText = markText;
    }
    
    /**
     * @return 获取 markTextPattern属性值
     */
    public Pattern getMarkTextPattern() {
        return markTextPattern;
    }
    
    /**
     * @return 获取 nullValueText属性值
     */
    public String getNullValueText() {
        return nullValueText;
    }
    
    /**
     * @param nullValueText 设置 nullValueText 属性值为参数值 nullValueText
     */
    public void setNullValueText(String nullValueText) {
        this.nullValueText = nullValueText;
    }
    
    /**
     * @return 获取 dirText属性值
     */
    public String getDirText() {
        return dirText;
    }
    
    /**
     * @param dirText 设置 dirText 属性值为参数值 dirText
     */
    public void setDirText(String dirText) {
        this.dirText = dirText;
    }
    
    /**
     * @return 获取 nullValueTextPattern属性值
     */
    public Pattern getNullValueTextPattern() {
        return nullValueTextPattern;
    }
    
    /**
     * @return 获取 dirTextPattern属性值
     */
    public Pattern getDirTextPattern() {
        return dirTextPattern;
    }
    
    /**
     * @return 获取 modifyTimes属性值
     */
    public int getModifyTimes() {
        return modifyTimes.get();
    }
    
    /**
     * 修改次数加1
     */
    public void incrementModifyTimes() {
        modifyTimes.incrementAndGet();
    }
    
    /**
     * @return 获取 validateLevel属性值
     */
    public int getValidateResultLevel() {
        return validateResultLevel;
    }
    
    /**
     * @param validateLevel 设置 validateLevel 属性值为参数值 validateLevel
     */
    public void setvalidateResultLevel(int validateLevel) {
        this.validateResultLevel = validateLevel;
    }
    
    /**
     * @return 获取 configFile属性值
     */
    public File getConfigFile() {
        return configFile;
    }
    
    /**
     * @param configFile 设置 configFile 属性值为参数值 configFile
     */
    public void setConfigFile(File configFile) {
        this.configFile = configFile;
    }
    
}
