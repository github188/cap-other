/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.design.model;

import java.util.LinkedList;
import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

import com.comtop.cap.bm.metadata.base.model.BaseModel;

/**
 * 版本集合
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年7月7日 lizhongwen
 */
@XmlRootElement(name = "versions")
public class Versions extends BaseModel {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 版本类型 */
    private static final String VERSIONS_TYPE = "version";
    
    /** 版本名称 */
    private static final String VERSIONS_NAME = "versions";
    
    /** 版本集合 */
    private List<Version> versions;
    
    /**
     * @return 获取 versions属性值
     */
    @XmlElement(name = "version")
    public List<Version> getVersions() {
        return versions;
    }
    
    /**
     * @param versions 设置 versions 属性值为参数值 versions
     */
    public void setVersions(List<Version> versions) {
        this.versions = versions;
    }
    
    /**
     * @param version 添加版本
     */
    public void addVersion(Version version) {
        if (this.versions == null) {
            this.versions = new LinkedList<Version>();
        }
        Version exsited = this.findVersions(version.getTestcaseId());
        if (exsited == null) {
            this.versions.add(version);
        } else {
            int index = this.versions.indexOf(exsited);
            this.versions.set(index, version);
        }
    }
    
    /**
     * @param testcaseId 根据用例Id删除版本
     */
    public void removeVersion(String testcaseId) {
        Version exsited = this.findVersions(testcaseId);
        if (exsited != null) {
            this.versions.remove(exsited);
        }
    }
    
    /**
     * @param testcaseId 根据用例Id查找版本
     * @return 版本
     */
    public Version findVersions(String testcaseId) {
        if (versions == null) {
            return null;
        }
        for (Version version : versions) {
            if (version.getTestcaseId().equals(testcaseId)) {
                return version;
            }
        }
        return null;
    }
    
    /**
     * 
     * @see com.comtop.cap.bm.metadata.base.model.BaseModel#getModelName()
     */
    @Override
    public String getModelName() {
        return VERSIONS_NAME;
    }
    
    /**
     * 
     * @see com.comtop.cap.bm.metadata.base.model.BaseModel#getModelType()
     */
    @Override
    public String getModelType() {
        return VERSIONS_TYPE;
    }
    
    /**
     * @see com.comtop.cap.bm.metadata.base.model.BaseModel#getModelId()
     */
    @Override
    public String getModelId() {
        return this.getModelPackage() + "." + VERSIONS_TYPE + "." + VERSIONS_NAME;
    }
}
