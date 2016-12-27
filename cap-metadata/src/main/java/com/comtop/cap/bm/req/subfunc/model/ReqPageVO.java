/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.req.subfunc.model;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

import com.comtop.top.core.base.model.CoreVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 界面原型
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-11-25 CAP
 */
@DataTransferObject
@Table(name = "CAP_REQ_PAGE")
public class ReqPageVO extends CoreVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 界面原型ID */
    @Id
    @Column(name = "ID", length = 40)
    private String id;
    
    /** 子项ID */
    @Column(name = "SUBITEM_ID", length = 40)
    private String subitemId;
    
    /** 名称 */
    @Column(name = "NAME", length = 40)
    private String name;
    
    /** 中文名称 */
    @Column(name = "CN_NAME", length = 80)
    private String cnName;
    
    /** 关联界面ID */
    @Column(name = "PAGE_ID", length = 40)
    private String pageId;
    
    /** 文件存储ID */
    @Column(name = "IMG_ID", length = 200)
    private String imgId;
    
    /** 排序号 */
    @Column(name = "SORT_NO", precision = 10)
    private Integer sortNo;
    
    /** 备注 */
    @Column(name = "REMARK", length = 500)
    private String remark;
    
    /** 数据来源，1：导入；0：系统创建； */
    @Column(name = "DATA_FROM", precision = 1)
    private Integer dataFrom;
    
    /** 文档ID */
    @Column(name = "DOCUMENT_ID", length = 40)
    private String documentId;
    
    /** 图片高度 px */
    @Column(name = "HEIGHT", length = 5)
    private int height;
    
    /** 图片宽度 px */
    @Column(name = "WIDTH", length = 5)
    private int width;
    
    /** uploadId */
    private String uploadId;
    
    /** uploadKey */
    private String uploadKey;
    
    /** uploadKey */
    private String pageName;
    
    /**
     * @return 获取 界面原型ID属性值
     */
    
    public String getId() {
        return id;
    }
    
    /**
     * @param id 设置 界面原型ID属性值为参数值 id
     */
    
    public void setId(String id) {
        this.id = id;
    }
    
    /**
     * @return 获取 子项ID属性值
     */
    
    public String getSubitemId() {
        return subitemId;
    }
    
    /**
     * @param subitemId 设置 子项ID属性值为参数值 subitemId
     */
    
    public void setSubitemId(String subitemId) {
        this.subitemId = subitemId;
    }
    
    /**
     * @return 获取 名称属性值
     */
    
    public String getName() {
        return name;
    }
    
    /**
     * @param name 设置 名称属性值为参数值 name
     */
    
    public void setName(String name) {
        this.name = name;
    }
    
    /**
     * @return 获取 中文名称属性值
     */
    
    public String getCnName() {
        return cnName;
    }
    
    /**
     * @param cnName 设置 中文名称属性值为参数值 cnName
     */
    
    public void setCnName(String cnName) {
        this.cnName = cnName;
    }
    
    /**
     * @return 获取 关联界面ID属性值
     */
    
    public String getPageId() {
        return pageId;
    }
    
    /**
     * @param pageId 设置 关联界面ID属性值为参数值 pageId
     */
    
    public void setPageId(String pageId) {
        this.pageId = pageId;
    }
    
    /**
     * @return 获取 文件存储ID属性值
     */
    
    public String getImgId() {
        return imgId;
    }
    
    /**
     * @param imgId 设置 文件存储ID属性值为参数值 imgId
     */
    
    public void setImgId(String imgId) {
        this.imgId = imgId;
    }
    
    /**
     * @return 获取 排序号属性值
     */
    
    public Integer getSortNo() {
        return sortNo;
    }
    
    /**
     * @param sortNo 设置 排序号属性值为参数值 sortNo
     */
    
    public void setSortNo(Integer sortNo) {
        this.sortNo = sortNo;
    }
    
    /**
     * @return 获取 备注属性值
     */
    
    public String getRemark() {
        return remark;
    }
    
    /**
     * @param remark 设置 备注属性值为参数值 remark
     */
    
    public void setRemark(String remark) {
        this.remark = remark;
    }
    
    /**
     * @return 获取 数据来源，1：导入；0：系统创建；属性值
     */
    
    public Integer getDataFrom() {
        return dataFrom;
    }
    
    /**
     * @param dataFrom 设置 数据来源，1：导入；0：系统创建；属性值为参数值 dataFrom
     */
    
    public void setDataFrom(Integer dataFrom) {
        this.dataFrom = dataFrom;
    }
    
    /**
     * @return 获取 文档ID属性值
     */
    
    public String getDocumentId() {
        return documentId;
    }
    
    /**
     * @param documentId 设置 文档ID属性值为参数值 documentId
     */
    
    public void setDocumentId(String documentId) {
        this.documentId = documentId;
    }
    
    /**
     * @return 获取 height属性值
     */
    public int getHeight() {
        return height;
    }
    
    /**
     * @param height 设置 height 属性值为参数值 height
     */
    public void setHeight(int height) {
        this.height = height;
    }
    
    /**
     * @return 获取 width属性值
     */
    public int getWidth() {
        return width;
    }
    
    /**
     * @param width 设置 width 属性值为参数值 width
     */
    public void setWidth(int width) {
        this.width = width;
    }
    
    /**
     * @return 获取 uploadId属性值
     */
    public String getUploadId() {
        return uploadId;
    }
    
    /**
     * @param uploadId 设置 uploadId 属性值为参数值 uploadId
     */
    public void setUploadId(String uploadId) {
        this.uploadId = uploadId;
    }
    
    /**
     * @return 获取 uploadKey属性值
     */
    public String getUploadKey() {
        return uploadKey;
    }
    
    /**
     * @param uploadKey 设置 uploadKey 属性值为参数值 uploadKey
     */
    public void setUploadKey(String uploadKey) {
        this.uploadKey = uploadKey;
    }
    
    /**
     * @return 获取 pageName属性值
     */
    public String getPageName() {
        return pageName;
    }
    
    /**
     * @param pageName 设置 pageName 属性值为参数值 pageName
     */
    public void setPageName(String pageName) {
        this.pageName = pageName;
    }
    
    @Override
    public String toString() {
        return "ReqPageVO [id=" + id + ", subitemId=" + subitemId + ", name=" + name + ", cnName=" + cnName
            + ", pageId=" + pageId + ", imgId=" + imgId + ", sortNo=" + sortNo + ", remark=" + remark + ", dataFrom="
            + dataFrom + ", documentId=" + documentId + ", height=" + height + ", width=" + width + ", uploadId="
            + uploadId + ", uploadKey=" + uploadKey + "]";
    }
    
}
