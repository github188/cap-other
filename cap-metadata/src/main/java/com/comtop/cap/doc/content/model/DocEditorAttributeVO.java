/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.content.model;

import com.comtop.top.core.base.model.CoreVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 章节内容结构。章节的所有内容均会在此表中存在。以类型字段区分具体的内容存储在什么地方。如果是文本、图片、嵌入式对象内容，则对应存储在文本内容表、图片内容表、嵌入式对象内容表。如果已定义的表格内容，
 * 则将表格内容对应的模型定义将其存储在已定义的模型存储结构中，比如业务事项表、业务对象表等。如果某段纯文本归属于一个已经定义的对象，则会将该文本存储在该对象自己的结构中。
 * 
 * @author 李小芬
 * @since 1.0
 * @version 2015-11-24 李小芬
 */
@DataTransferObject
public class DocEditorAttributeVO extends CoreVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 控件ID，也为contentStructId */
    private String id;
    
    /** 上级ID */
    private String html;
    
    /** 章节或分节ID */
    private String containerId;
    
    /** 文档ID */
    private String documentId;
    
    /** 排序号 */
    private Integer sortNo;
    
    /** 结构ID */
    private String structId;
    
    /**
     * @return id
     */
    public String getId() {
        return id;
    }
    
    /**
     * @param id id
     */
    public void setId(String id) {
        this.id = id;
    }
    
    /**
     * @return html
     */
    public String getHtml() {
        return html;
    }
    
    /**
     * @param html html
     */
    public void setHtml(String html) {
        this.html = html;
    }
    
    /**
     * @return containerId
     */
    public String getContainerId() {
        return containerId;
    }
    
    /**
     * @param containerId containerId
     */
    public void setContainerId(String containerId) {
        this.containerId = containerId;
    }
    
    /**
     * @return documentId
     */
    public String getDocumentId() {
        return documentId;
    }
    
    /**
     * @param documentId documentId
     */
    public void setDocumentId(String documentId) {
        this.documentId = documentId;
    }
    
    /**
     * @return sortNo
     */
    public Integer getSortNo() {
        return sortNo;
    }
    
    /**
     * @param sortNo sortNo
     */
    public void setSortNo(Integer sortNo) {
        this.sortNo = sortNo;
    }
    
    /**
     * @return structId
     */
    public String getStructId() {
        return structId;
    }
    
    /**
     * @param structId structId
     */
    public void setStructId(String structId) {
        this.structId = structId;
    }
    
}
