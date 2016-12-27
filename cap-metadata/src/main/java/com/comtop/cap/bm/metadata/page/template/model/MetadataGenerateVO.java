/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.template.model;

import com.comtop.cap.bm.metadata.base.model.BaseModel;
import com.comtop.cap.bm.metadata.common.storage.annotation.AggregationField;
import com.comtop.cap.bm.metadata.common.storage.annotation.IgnoreField;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 元数据生成VO
 * 
 * @author 诸焕辉
 * @version jdk1.6
 * @version 2015-9-22 诸焕辉
 */
@DataTransferObject
public class MetadataGenerateVO extends BaseModel {
    
    /** 标识 */
    private static final long serialVersionUID = 4555525274373654112L;
    
    /**
     * 元数据模板定义Id
     */
    private String metadataPageConfigModelId;
    
    /**
     * 界面配置元数据模板VO
     */
    @IgnoreField
    @AggregationField(value = "metadataPageConfigModelId")
    private MetadataPageConfigVO metadataPageConfigVO;
    
    /**
     * 元数据表单内容
     */
    private MetadataValueVO metadataValue;
    
    /**
     * 模型包对应的数据Id 系统模块现在存储在数据库中，模块的dbId暂时冗余在pageVO中，
     */
    private String modelPackageId;
    
    /**
     * 构造函数
     */
    public MetadataGenerateVO() {
        this.setModelType("metadataGenerate");
    }
    
    /**
     * @return 获取 metadataValue属性值
     */
    public MetadataValueVO getMetadataValue() {
        return metadataValue;
    }
    
    /**
     * @param metadataValue 设置 metadataValue 属性值为参数值 metadataValue
     */
    public void setMetadataValue(MetadataValueVO metadataValue) {
        this.metadataValue = metadataValue;
    }
    
    /**
     * @return 获取 metadataPageConfigVO属性值
     */
    public MetadataPageConfigVO getMetadataPageConfigVO() {
        return metadataPageConfigVO;
    }
    
    /**
     * @param metadataPageConfigVO 设置 metadataPageConfigVO 属性值为参数值 metadataPageConfigVO
     */
    public void setMetadataPageConfigVO(MetadataPageConfigVO metadataPageConfigVO) {
        this.metadataPageConfigVO = metadataPageConfigVO;
    }
    
    /**
     * @return 获取 metadataPageConfigModelId属性值
     */
    public String getMetadataPageConfigModelId() {
        return metadataPageConfigModelId;
    }
    
    /**
     * @param metadataPageConfigModelId 设置 metadataPageConfigModelId 属性值为参数值 metadataPageConfigModelId
     */
    public void setMetadataPageConfigModelId(String metadataPageConfigModelId) {
        this.metadataPageConfigModelId = metadataPageConfigModelId;
    }

	/**
	 * @return the modelPackageId
	 */
	public String getModelPackageId() {
		return modelPackageId;
	}

	/**
	 * @param modelPackageId the modelPackageId to set
	 */
	public void setModelPackageId(String modelPackageId) {
		this.modelPackageId = modelPackageId;
	}
}
