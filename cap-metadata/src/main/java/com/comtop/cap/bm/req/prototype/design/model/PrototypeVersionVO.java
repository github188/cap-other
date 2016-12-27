/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.req.prototype.design.model;

import javax.persistence.Id;
import javax.xml.bind.annotation.XmlAttribute;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import com.comtop.cip.validator.javax.xml.bind.annotation.XmlType;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 版本
 *
 * @author zhuhuanhui
 * @since jdk1.6
 * @version 2016年11月28日 zhuhuanhui
 */
@XmlType(name = "version")
@DataTransferObject
public class PrototypeVersionVO extends BaseMetadata {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 用例Id */
    @Id
    private String modelId;
    
    /** 元数据版本 */
    private int metaDataVersion;
    
    /** 脚本版本 */
    private int codeVersion;
    
    /** 图片版本 */
    private int imageVersion;
    
    /** 生成代码时间 */
    private long genCodeTime;
    
    /** 生成代码时间 */
    private long genImageTime;
    
    /**
     * @return 获取 modelId属性值
     */
    @XmlAttribute(name = "modelId")
    public String getModelId() {
        return modelId;
    }
    
    /**
     * @param modelId 设置 modelId 属性值为参数值 modelId
     */
    public void setModelId(String modelId) {
        this.modelId = modelId;
    }
    
    /**
     * @return 获取 metaDataVersion属性值
     */
    @XmlAttribute(name = "metaDataVersion")
    public int getMetaDataVersion() {
        return metaDataVersion;
    }
    
    /**
     * @param metaDataVersion 设置 metaDataVersion 属性值为参数值 metaDataVersion
     */
    public void setMetaDataVersion(int metaDataVersion) {
        this.metaDataVersion = metaDataVersion;
    }
    
    /**
     * @return 获取 codeVersion属性值
     */
    @XmlAttribute(name = "codeVersion")
    public int getCodeVersion() {
        return codeVersion;
    }
    
    /**
     * @param codeVersion 设置 codeVersion 属性值为参数值 codeVersion
     */
    public void setCodeVersion(int codeVersion) {
        this.codeVersion = codeVersion;
    }
    
    /**
     * @return 获取 imageVersion属性值
     */
    @XmlAttribute(name = "imageVersion")
    public int getImageVersion() {
        return imageVersion;
    }
    
    /**
     * @param imageVersion 设置 imageVersion 属性值为参数值 imageVersion
     */
    public void setImageVersion(int imageVersion) {
        this.imageVersion = imageVersion;
    }
    
    /**
     * @return 获取 genCodeTime属性值
     */
    @XmlAttribute(name = "genCodeTime")
    public long getGenCodeTime() {
        return genCodeTime;
    }
    
    /**
     * @param genCodeTime 设置 genCodeTime 属性值为参数值 genCodeTime
     */
    public void setGenCodeTime(long genCodeTime) {
        this.genCodeTime = genCodeTime;
    }
    
    /**
     * @return 获取 genImageTime属性值
     */
    @XmlAttribute(name = "genImageTime")
    public long getGenImageTime() {
        return genImageTime;
    }
    
    /**
     * @param genImageTime 设置 genImageTime 属性值为参数值 genImageTime
     */
    public void setGenImageTime(long genImageTime) {
        this.genImageTime = genImageTime;
    }
}
