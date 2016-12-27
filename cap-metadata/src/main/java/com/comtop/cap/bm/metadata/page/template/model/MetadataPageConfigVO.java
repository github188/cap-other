/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.template.model;

import java.util.ArrayList;
import java.util.List;

import com.comtop.cap.bm.metadata.base.model.BaseModel;
import com.comtop.cap.bm.metadata.common.dwr.CapMap;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 元数据页面配置
 * 
 * @author 诸焕辉
 * @version jdk1.6
 * @version 2015-9-22 诸焕辉
 */
@DataTransferObject
public class MetadataPageConfigVO extends BaseModel {
    
    /** 标识 */
    private static final long serialVersionUID = -796802569319828356L;
    
    /**
     * 中文名称
     */
    private String cname;
    
    /**
     * 类型编码
     */
    private String typeCode;
    
    /**
     * 是否是默认模版
     */
    private boolean defaultTemplate;
    
    /**
     * 界面控件集合
     */
    private List<MetaComponentDefineVO> metaComponentDefineVOList = new ArrayList<MetaComponentDefineVO>();
    
    /**
     * 关联页面集合
     */
    private List<CapMap> pageTempList = new ArrayList<CapMap>();
    
    /**
     * 构造函数
     */
    public MetadataPageConfigVO() {
        this.setModelType("pageConfig");
    }
    
    /**
     * @return 获取 metaComponentDefineVOList属性值
     */
    public List<MetaComponentDefineVO> getMetaComponentDefineVOList() {
        return metaComponentDefineVOList;
    }
    
    /**
     * @param metaComponentDefineVOList 设置 metaComponentDefineVOList 属性值为参数值 metaComponentDefineVOList
     */
    public void setMetaComponentDefineVOList(List<MetaComponentDefineVO> metaComponentDefineVOList) {
        this.metaComponentDefineVOList = metaComponentDefineVOList;
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
     * @return 获取 defaultTemplate属性值
     */
    public boolean isDefaultTemplate() {
        return defaultTemplate;
    }
    
    /**
     * @param defaultTemplate 设置 defaultTemplate 属性值为参数值 defaultTemplate
     */
    public void setDefaultTemplate(boolean defaultTemplate) {
        this.defaultTemplate = defaultTemplate;
    }
    
    /**
     * @return 获取 pageTempList属性值
     */
    public List<CapMap> getPageTempList() {
        return pageTempList;
    }
    
    /**
     * @param pageTempList 设置 pageTempList 属性值为参数值 pageTempList
     */
    public void setPageTempList(List<CapMap> pageTempList) {
        this.pageTempList = pageTempList;
    }
}
