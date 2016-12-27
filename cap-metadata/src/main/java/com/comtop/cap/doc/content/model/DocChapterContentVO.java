/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.content.model;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

import com.comtop.top.core.base.model.CoreVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 指word中的纯文本内容、非结构化的表格内容。非结构化的表格内容以原始的表格结构字符串存储
 * 
 * @author 李小芬
 * @since 1.0
 * @version 2015-11-24 李小芬
 */
@DataTransferObject
@Table(name = "CAP_DOC_CHAPTER_CONTENT")
public class DocChapterContentVO extends CoreVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 流水号 */
    @Id
    @Column(name = "ID", length = 40)
    private String id;
    
    /** 内容，纯文本的HTML，图片、附件（excel、visio）、非结构化表格的HTML代码，其中附件如有缩略图采用<img src height width filePath等属性来记录> */
    @Column(name = "CONTENT", length = 4000)
    private String content;
    
    /**
     * @return 获取 流水号属性值
     */
    
    public String getId() {
        return id;
    }
    
    /**
     * @param id 设置 流水号属性值为参数值 id
     */
    
    public void setId(String id) {
        this.id = id;
    }
    
    /**
     * @return 获取 内容，纯文本的HTML，图片、附件（excel、visio）、非结构化表格的HTML代码，其中附件如有缩略图采用<img src height width filePath等属性来记录>属性值
     */
    
    public String getContent() {
        return content;
    }
    
    /**
     * @param content 设置 内容，纯文本的HTML，图片、附件（excel、visio）、非结构化表格的HTML代码，其中附件如有缩略图采用<img src height width
     *            filePath等属性来记录>属性值为参数值 content
     */
    
    public void setContent(String content) {
        this.content = content;
    }
    
}
