/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.template.model;

import java.util.ArrayList;
import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlElementWrapper;
import javax.xml.bind.annotation.XmlRootElement;

import com.comtop.cap.bm.metadata.base.model.BaseModel;
import com.comtop.cap.bm.metadata.common.dwr.CapMap;
import com.comtop.cap.bm.metadata.common.storage.annotation.IgnoreField;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 元数据模板定义
 * 
 * @author 诸焕辉
 * @version jdk1.6
 * @version 2015-9-22 诸焕辉
 */
@XmlRootElement(name = "metadataTmpDefine")
@DataTransferObject
public class MetadataTmpDefineVO extends BaseModel {
    
    /** 标识 */
    private static final long serialVersionUID = -7901843958805869680L;
    
    /**
     * 中文名称
     */
    private String cname;
    
    /**
     * 类型编码
     */
    private String typeCode;
    
    /**
     * 界面配置modelId
     */
    private String metadataPageConfigModelId;
    
    /**
     * 界面配置VO
     */
    @IgnoreField
    private MetadataPageConfigVO metadataPageConfigVO;
    
    /**
     * 模板文件集合
     */
    private List<CapMap> metadataTmpVOList = new ArrayList<CapMap>();
    
    /**
     * 构造函数
     */
    public MetadataTmpDefineVO() {
        this.setModelType("metadataTmpDefine");
    }
    
    /**
     * @return 获取 cname属性值
     */
    public String getCname() {
        return cname;
    }
    
    /**
     * @param cname 设置 cname 属性值为参数值 cname
     */
    public void setCname(String cname) {
        this.cname = cname;
    }
    
    /**
     * @return 获取 typeCode属性值
     */
    public String getTypeCode() {
        return typeCode;
    }
    
    /**
     * @param typeCode 设置 typeCode 属性值为参数值 typeCode
     */
    public void setTypeCode(String typeCode) {
        this.typeCode = typeCode;
    }
    
    /**
     * @return 获取 id属性值
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
     * @return 获取 MetadataPageConfigVO属性值
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
     * @return 获取 metadataTmpVOList属性值
     */
    @XmlElementWrapper(name = "metadataTmpVOList")
    @XmlElement(name = "list")
    public List<CapMap> getMetadataTmpVOList() {
        return metadataTmpVOList;
    }
    
    /**
     * @param metadataTmpVOList 设置 metadataTmpVOList 属性值为参数值 metadataTmpVOList
     */
    public void setMetadataTmpVOList(List<CapMap> metadataTmpVOList) {
        this.metadataTmpVOList = metadataTmpVOList;
    }
}
