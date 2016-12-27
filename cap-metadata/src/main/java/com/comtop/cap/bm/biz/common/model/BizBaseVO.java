/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.biz.common.model;

import javax.persistence.Column;

import com.comtop.top.core.base.model.CoreVO;

/**
 * 业务模型父VO
 * 
 * @author 李小强
 * @since 1.0
 * @version 2015-11-23 李小强
 */
public class BizBaseVO extends CoreVO {
    
    /**
     * 序号
     */
    private static final long serialVersionUID = 5593470705864278182L;
    
    /** 数据来源，1：导入；0：系统创建；默认值为0'; */
    @Column(name = "DATA_FROM", precision = 1)
    protected Integer dataFrom = Integer.valueOf(0);
    
    /** 文档ID */
    @Column(name = "DOCUMENT_ID", length = 40)
    protected String documentId;
    
    /** 业务域id */
    @Column(name = "DOMAIN_ID", length = 40)
    protected String domainId;
    

    
    /** 序号 */
    @Column(name = "SORT_NO", precision = 10)
    protected Integer sortNo;
    
    /**
     * 数据来源，1：导入；0：系统创建；默认值为0'
     * 
     * @return 数据来源，1：导入；0：系统创建；默认值为0'
     */
    public Integer getDataFrom() {
        return dataFrom;
    }
    
    /**
     * @param dataFrom
     *            数据来源，1：导入；0：系统创建；默认值为0'
     */
    public void setDataFrom(Integer dataFrom) {
        this.dataFrom = dataFrom;
    }
    
    /**
     * 文档ID
     * 
     * @return 文档ID
     */
    public String getDocumentId() {
        return documentId;
    }
    
    /**
     * @param documentId
     *            文档ID
     */
    public void setDocumentId(String documentId) {
        this.documentId = documentId;
    }
  
    
    @Override
    public String toString() {
        return "BizBaseVO [dataFrom=" + dataFrom + ", documentId=" + documentId + "]";
    }
    
    /**
     * @return 获取 domainId属性值
     */
    public String getDomainId() {
        return domainId;
    }
    
    /**
     * @param domainId 设置 domainId 属性值为参数值 domainId
     */
    public void setDomainId(String domainId) {
        this.domainId = domainId;
    }
    
    /**
     * @return 获取 sortNo属性值
     */
    public Integer getSortNo() {
        return sortNo;
    }
    
    /**
     * @param sortNo 设置 sortNo 属性值为参数值 sortNo
     */
    public void setSortNo(Integer sortNo) {
        this.sortNo = sortNo;
    }
    
}
