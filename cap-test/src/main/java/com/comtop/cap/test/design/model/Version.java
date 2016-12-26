/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.design.model;

import javax.persistence.Id;
import javax.xml.bind.annotation.XmlAttribute;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import com.comtop.cip.validator.javax.xml.bind.annotation.XmlType;

/**
 * 版本
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年7月7日 lizhongwen
 */
@XmlType(name = "version")
public class Version extends BaseMetadata {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 用例Id */
    @Id
    private String testcaseId;
    
    /** 脚本目录 */
    private String scriptFolder;
    
    /** 脚本名称 */
    private String scriptName;
    
    /** 用例版本 */
    private int caseVersion;
    
    /** 脚本版本 */
    private int scriptVersion;
    
    /** 脚本生成时间 */
    private long genTime;
    
    /**
     * @return 获取 testcaseId属性值
     */
    @XmlAttribute(name = "testcaseId")
    public String getTestcaseId() {
        return testcaseId;
    }
    
    /**
     * @param testcaseId 设置 testcaseId 属性值为参数值 testcaseId
     */
    public void setTestcaseId(String testcaseId) {
        this.testcaseId = testcaseId;
    }
    
    /**
     * @return 获取 scriptFolder属性值
     */
    @XmlAttribute(name = "scriptFolder")
    public String getScriptFolder() {
        return scriptFolder;
    }
    
    /**
     * @param scriptFolder 设置 scriptFolder 属性值为参数值 scriptFolder
     */
    public void setScriptFolder(String scriptFolder) {
        this.scriptFolder = scriptFolder;
    }
    
    /**
     * @return 获取 scriptName属性值
     */
    @XmlAttribute(name = "scriptName")
    public String getScriptName() {
        return scriptName;
    }
    
    /**
     * @param scriptName 设置 scriptName 属性值为参数值 scriptName
     */
    public void setScriptName(String scriptName) {
        this.scriptName = scriptName;
    }
    
    /**
     * @return 获取 caseVersion属性值
     */
    @XmlAttribute(name = "caseVersion")
    public int getCaseVersion() {
        return caseVersion;
    }
    
    /**
     * @param caseVersion 设置 caseVersion 属性值为参数值 caseVersion
     */
    public void setCaseVersion(int caseVersion) {
        this.caseVersion = caseVersion;
    }
    
    /**
     * @return 获取 scriptVersion属性值
     */
    @XmlAttribute(name = "scriptVersion")
    public int getScriptVersion() {
        return scriptVersion;
    }
    
    /**
     * @param scriptVersion 设置 scriptVersion 属性值为参数值 scriptVersion
     */
    public void setScriptVersion(int scriptVersion) {
        this.scriptVersion = scriptVersion;
    }
    
    /**
     * @return 获取 genTime属性值
     */
    @XmlAttribute(name = "genTime")
    public long getGenTime() {
        return genTime;
    }
    
    /**
     * @param genTime 设置 genTime 属性值为参数值 genTime
     */
    public void setGenTime(long genTime) {
        this.genTime = genTime;
    }
}
