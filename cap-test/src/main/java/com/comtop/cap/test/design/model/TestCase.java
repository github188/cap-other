/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.design.model;

import java.util.LinkedList;
import java.util.List;

import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlTransient;
import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.bm.metadata.base.model.BaseModel;
import com.comtop.cap.bm.metadata.common.storage.annotation.IgnoreField;
import com.comtop.cap.common.xml.CDataAdaptor;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 测试用例
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年6月23日 lizhongwen
 */
@XmlRootElement(name = "testcase")
@DataTransferObject
public class TestCase extends BaseModel {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 用例名称 */
    private String name;
    
    /** 用例序号 */
    private String sortNo;
    
    /** 用例类型 */
    private TestCaseType type;
    
    /** 关联元数据 */
    private String metadata;
    
    /** 关联最佳实践 */
    private String practice;
    
    /** 场景 */
    private String scene;
    
    /** 描述 */
    private String description;
    
    /** 步骤集 */
    private List<Step> steps;
    
    /** 连线集 */
    private List<Line> lines;
    
    /** 是否包含自定义步骤 */
    private Boolean containCustomizedStep = Boolean.FALSE;
    
    /** 界面显示的元数据值 */
    @IgnoreField
    private String showMetadata;
    
    /** 当前页面号 */
    private int pageNo;
    
    /** 当前页面大小 */
    private int pageSize;
    
    /** 元数据名称 */
    private String metadataName;
    
    /** 最后一次是否通过测试 */
    private int pass;
    
    /**
     * @return 获取 pass属性值
     */
    public int getPass() {
        return pass;
    }
    
    /**
     * @param pass 设置 pass 属性值为参数值 pass
     */
    public void setPass(int pass) {
        this.pass = pass;
    }
    
    /**
     * @return 获取 metadataName属性值
     */
    public String getMetadataName() {
        return metadataName;
    }
    
    /**
     * @param metadataName 设置 metadataName 属性值为参数值 metadataName
     */
    public void setMetadataName(String metadataName) {
        this.metadataName = metadataName;
    }
    
    /**
     * @return 获取 name属性值
     */
    @XmlAttribute(name = "name")
    public String getName() {
        return name;
    }
    
    /**
     * @return 获取 pageNo属性值
     */
    public int getPageNo() {
        return pageNo;
    }
    
    /**
     * @param pageNo 设置 pageNo 属性值为参数值 pageNo
     */
    public void setPageNo(int pageNo) {
        this.pageNo = pageNo;
    }
    
    /**
     * @return 获取 pageSize属性值
     */
    public int getPageSize() {
        return pageSize;
    }
    
    /**
     * @param pageSize 设置 pageSize 属性值为参数值 pageSize
     */
    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }
    
    /**
     * @param name 设置 name 属性值为参数值 name
     */
    public void setName(String name) {
        this.name = name;
    }
    
    /**
     * @return 获取 type属性值
     */
    @XmlAttribute(name = "type")
    public TestCaseType getType() {
        return type;
    }
    
    /**
     * @param type 设置 type 属性值为参数值 type
     */
    public void setType(TestCaseType type) {
        this.type = type;
    }
    
    /**
     * @return 获取 metadata属性值
     */
    @XmlAttribute(name = "metadata")
    public String getMetadata() {
        return metadata;
    }
    
    /**
     * @param metadata 设置 metadata 属性值为参数值 metadata
     */
    public void setMetadata(String metadata) {
        this.metadata = metadata;
    }
    
    /**
     * @return 获取 practice属性值
     */
    @XmlAttribute(name = "practice")
    public String getPractice() {
        return practice;
    }
    
    /**
     * @param practice 设置 practice 属性值为参数值 practice
     */
    public void setPractice(String practice) {
        this.practice = practice;
    }
    
    /**
     * @return 获取 scene属性值
     */
    @XmlElement(name = "scene")
    @XmlJavaTypeAdapter(value = CDataAdaptor.class)
    public String getScene() {
        return scene;
    }
    
    /**
     * @param scene 设置 scene 属性值为参数值 scene
     */
    public void setScene(String scene) {
        this.scene = scene;
    }
    
    /**
     * @return 获取 description属性值
     */
    @XmlElement(name = "desc")
    @XmlJavaTypeAdapter(value = CDataAdaptor.class)
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
     * @return 获取 steps属性值
     */
    @XmlElement(name = "step")
    public List<Step> getSteps() {
        return steps;
    }
    
    /**
     * @param steps 设置 steps 属性值为参数值 steps
     */
    public void setSteps(List<Step> steps) {
        this.steps = steps;
        if (this.steps != null) {
            for (Step step : steps) {
                if (step != null && step.getContainCustomizedStep()) {
                    containCustomizedStep = Boolean.TRUE;
                }
            }
        }
    }
    
    /**
     * @param step 添加步骤
     */
    public void addStep(Step step) {
        if (this.steps == null) {
            this.steps = new LinkedList<Step>();
        }
        if (step != null) {
            this.steps.add(step);
            if (step != null && step.getContainCustomizedStep()) {
                containCustomizedStep = Boolean.TRUE;
            }
        }
    }
    
    /**
     * @return 获取 containCustomizeStep属性值
     */
    @XmlTransient
    public Boolean getContainCustomizedStep() {
        if (this.steps != null) {
            for (Step step : steps) {
                if (step != null && step.getContainCustomizedStep()) {
                    containCustomizedStep = Boolean.TRUE;
                }
            }
        }
        return containCustomizedStep;
    }
    
    /**
     * @return 获取 lines属性值
     */
    @XmlElement(name = "line")
    public List<Line> getLines() {
        return lines;
    }
    
    /**
     * @param lines 设置 lines 属性值为参数值 lines
     */
    public void setLines(List<Line> lines) {
        this.lines = lines;
    }
    
    /**
     * @param line 添加连线
     */
    public void addLine(Line line) {
        if (this.lines == null) {
            this.lines = new LinkedList<Line>();
        }
        this.lines.add(line);
    }
    
    /**
     * @return 获取 showMetadata属性值
     */
    public String getShowMetadata() {
        return showMetadata;
    }
    
    /**
     * @param showMetadata 添加连线
     */
    public void setShowMetadata(String showMetadata) {
        this.showMetadata = showMetadata;
    }
    
    /**
     * @see com.comtop.cap.bm.metadata.base.model.BaseModel#getModelType()
     */
    @Override
    public String getModelType() {
        return "testcase";
    }
    
    /**
     * @see com.comtop.cap.bm.metadata.base.model.BaseModel#getModelId()
     */
    @Override
    public String getModelId() {
        if (StringUtils.isEmpty(this.getModelPackage())) {
            return "";
        }
        return this.getModelPackage() + "." + this.getModelType() + "." + this.getModelName();
    }
    
    /**
     * 
     * @see com.comtop.cap.bm.metadata.base.model.BaseModel#getCreateTime()
     */
    @Override
    public long getCreateTime() {
        return super.getCreateTime() == 0 ? System.currentTimeMillis() : super.getCreateTime();
    }
    
    /**
     * @return 获取 sortNo属性值
     */
    @XmlAttribute(name = "sortNo")
    public String getSortNo() {
        return sortNo;
    }
    
    /**
     * @param sortNo 设置 sortNo 属性值为参数值 sortNo
     */
    public void setSortNo(String sortNo) {
        this.sortNo = sortNo;
    }
    
    /**
     * @return 获取脚本名称
     */
    public String getScriptName() {
        return sortNo == null ? "" : sortNo.concat(name);
    }
}
