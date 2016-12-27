/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.content.model;

import java.util.Map;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

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
@Table(name = "CAP_DOC_CHAPTER_CONTENT_STRUCT")
public class DocChapterContentStructVO extends CoreVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 流水号 */
    @Id
    @Column(name = "ID", length = 40)
    private String id;
    
    /**
     * 数据唯一标识，章节全路径，上下级之间用/分隔，如：AAA/BBB/CCC,其中AAA、BBB、CCC为章节名称（标题）
     */
    @Column(name = "CONTAINER_URI", length = 40)
    private String containerUri;
    
    /** chapter 章节 Section 分节 */
    @Column(name = "CONTAINER_TYPE", length = 20)
    private String containerType;
    
    /** 类型，未定义表格类型、未定义纯文本类型、已定义文本类型、图片类型、嵌入式对象类型；数据统一存储在章节内容表中 */
    @Column(name = "CONTENT_TYPE", length = 10)
    private String contentType;
    
    /** 序号 */
    @Column(name = "SORT_NO", precision = 10)
    private Integer sortNo;
    
    /** 关联的内容的Id。若要获得具体的内容，则根据类型字段来查找到对应的表。CAP_DOC_CHAPTER_CONTENT表ID关联 */
    @Column(name = "CONTENT_ID", length = 40)
    private String contentId;
    
    /** 数据来源，1：导入；0：系统创建； */
    @Column(name = "DATA_FROM", precision = 1)
    private Integer dataFrom;
    
    /** 文档ID */
    @Column(name = "DOCUMENT_ID", length = 40)
    private String documentId;
    
    /** 章节名称 */
    private String chapterName;
    
    /** 可选 */
    private Boolean optional;
    
    /** 上级ID */
    private String parentUri;
    
    /** 章节Word编号 */
    private String chapterWordNumber;
    
    /** 章节里面内容 */
    private String xmlContent;
    
    /** 文档内容 */
    private DocChapterContentVO docChapterContentVO;
    
    /** 表格数据VO */
    private DocGridDataVO gridDataVO;
    
    /** 富文本编辑器的html值 */
    private String editorHtml;
    
    /** mappingto的表达式，可以映射编辑页面 */
    private String mappingTo;
    
    /** xml的全路径，方便查找 */
    private String xmlfullPath;
    
    /** 业务域ID */
    private String domainId;
    
    /** 表达式参数 */
    private Map<String, String> expParamsMap;
    
    // /** ID的mapping值，隐藏字段，方便业务文本编辑保存。 */
    // private Map<String, String> mappingToForId;
    
    /** 章节自顶向下的服务集合： */
    private Map<String, String> serviceMap;
    
    /** 章节从上至下的集合：bizItem.id:xxxx */
    private Map<String, String> objectIdMap;
    
    /** 转化为树时设置的ID值，不能重复 */
    private String treeId;
    
    /** 转化为树时设置的ID值，不能重复 */
    private String parentTreeId;
    
    /** 转化为树需要的值：子章节数目 */
    private boolean hasChild;
    
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
     * @return 数据唯一标识，章节全路径，上下级之间用/分隔，如：AAA/BBB/CCC,其中AAA、BBB、CCC为章节名称（标题）
     */
    
    public String getContainerUri() {
        return containerUri;
    }
    
    /**
     * @param containerUri 数据唯一标识，章节全路径，上下级之间用/分隔，如：AAA/BBB/CCC,其中AAA、BBB、CCC为章节名称（标题）
     */
    
    public void setContainerUri(String containerUri) {
        this.containerUri = containerUri;
    }
    
    /**
     * @return 获取 chapter 章节 Section 分节属性值
     */
    
    public String getContainerType() {
        return containerType;
    }
    
    /**
     * @param containerType 设置 chapter 章节 Section 分节属性值为参数值 containerType
     */
    
    public void setContainerType(String containerType) {
        this.containerType = containerType;
    }
    
    /**
     * @return 获取 类型，未定义表格类型、未定义纯文本类型、已定义文本类型、图片类型、嵌入式对象类型；数据统一存储在章节内容表中属性值
     */
    
    public String getContentType() {
        return contentType;
    }
    
    /**
     * @param contentType 设置 类型，未定义表格类型、未定义纯文本类型、已定义文本类型、图片类型、嵌入式对象类型；数据统一存储在章节内容表中属性值为参数值 contentType
     */
    
    public void setContentType(String contentType) {
        this.contentType = contentType;
    }
    
    /**
     * @return 获取 序号属性值
     */
    
    public Integer getSortNo() {
        return sortNo;
    }
    
    /**
     * @param sortNo 设置 序号属性值为参数值 sortNo
     */
    
    public void setSortNo(Integer sortNo) {
        this.sortNo = sortNo;
    }
    
    /**
     * @return 获取 关联的内容的Id。若要获得具体的内容，则根据类型字段来查找到对应的表。CAP_DOC_CHAPTER_CONTENT表ID关联属性值
     */
    
    public String getContentId() {
        return contentId;
    }
    
    /**
     * @param contentId 设置 关联的内容的Id。若要获得具体的内容，则根据类型字段来查找到对应的表。CAP_DOC_CHAPTER_CONTENT表ID关联属性值为参数值 contentId
     */
    
    public void setContentId(String contentId) {
        this.contentId = contentId;
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
     * @return chapterName
     */
    public String getChapterName() {
        return chapterName;
    }
    
    /**
     * @param chapterName chapterName
     */
    public void setChapterName(String chapterName) {
        this.chapterName = chapterName;
    }
    
    /**
     * @return optional
     */
    public Boolean getOptional() {
        return optional;
    }
    
    /**
     * @param optional optional
     */
    public void setOptional(Boolean optional) {
        this.optional = optional;
    }
    
    /**
     * @return parentUri
     */
    public String getParentUri() {
        return parentUri;
    }
    
    /**
     * @param parentUri parentUri
     */
    public void setParentUri(String parentUri) {
        this.parentUri = parentUri;
    }
    
    /**
     * @return chapterWordNumber
     */
    public String getChapterWordNumber() {
        return chapterWordNumber;
    }
    
    /**
     * @param chapterWordNumber chapterWordNumber
     */
    public void setChapterWordNumber(String chapterWordNumber) {
        this.chapterWordNumber = chapterWordNumber;
    }
    
    /**
     * @return xmlContent
     */
    public String getXmlContent() {
        return xmlContent;
    }
    
    /**
     * @param xmlContent xmlContent
     */
    public void setXmlContent(String xmlContent) {
        this.xmlContent = xmlContent;
    }
    
    /**
     * @return docChapterContentVO
     */
    public DocChapterContentVO getDocChapterContentVO() {
        return docChapterContentVO;
    }
    
    /**
     * @param docChapterContentVO docChapterContentVO
     */
    public void setDocChapterContentVO(DocChapterContentVO docChapterContentVO) {
        this.docChapterContentVO = docChapterContentVO;
    }
    
    /**
     * @return gridDataVO
     */
    public DocGridDataVO getGridDataVO() {
        return gridDataVO;
    }
    
    /**
     * @param gridDataVO gridDataVO
     */
    public void setGridDataVO(DocGridDataVO gridDataVO) {
        this.gridDataVO = gridDataVO;
    }
    
    /**
     * @return editorHtml
     */
    public String getEditorHtml() {
        return editorHtml;
    }
    
    /**
     * @param editorHtml editorHtml
     */
    public void setEditorHtml(String editorHtml) {
        this.editorHtml = editorHtml;
    }
    
    /**
     * @return mappingTo
     */
    public String getMappingTo() {
        return mappingTo;
    }
    
    /**
     * @param mappingTo mappingTo
     */
    public void setMappingTo(String mappingTo) {
        this.mappingTo = mappingTo;
    }
    
    /**
     * @return xmlfullPath
     */
    public String getXmlfullPath() {
        return xmlfullPath;
    }
    
    /**
     * @param xmlfullPath xmlfullPath
     */
    public void setXmlfullPath(String xmlfullPath) {
        this.xmlfullPath = xmlfullPath;
    }
    
    /**
     * @return domainId
     */
    public String getDomainId() {
        return domainId;
    }
    
    /**
     * @param domainId domainId
     */
    public void setDomainId(String domainId) {
        this.domainId = domainId;
    }
    
    /**
     * @return expParamsMap
     */
    public Map<String, String> getExpParamsMap() {
        return expParamsMap;
    }
    
    /**
     * @param expParamsMap expParamsMap
     */
    public void setExpParamsMap(Map<String, String> expParamsMap) {
        this.expParamsMap = expParamsMap;
    }
    
    // /**
    // * @return mappingToForId
    // */
    // public Map<String, String> getMappingToForId() {
    // return mappingToForId;
    // }
    //
    // /**
    // * @param mappingToForId mappingToForId
    // */
    // public void setMappingToForId(Map<String, String> mappingToForId) {
    // this.mappingToForId = mappingToForId;
    // }
    
    /**
     * @return serviceMap
     */
    public Map<String, String> getServiceMap() {
        return serviceMap;
    }
    
    /**
     * @param serviceMap serviceMap
     */
    public void setServiceMap(Map<String, String> serviceMap) {
        this.serviceMap = serviceMap;
    }
    
    /**
     * @return objectIdMap
     */
    public Map<String, String> getObjectIdMap() {
        return objectIdMap;
    }
    
    /**
     * @param objectIdMap objectIdMap
     */
    public void setObjectIdMap(Map<String, String> objectIdMap) {
        this.objectIdMap = objectIdMap;
    }
    
    /**
     * @return treeId
     */
    public String getTreeId() {
        return treeId;
    }
    
    /**
     * @param treeId treeId
     */
    public void setTreeId(String treeId) {
        this.treeId = treeId;
    }
    
    /**
     * @return parentTreeId
     */
    public String getParentTreeId() {
        return parentTreeId;
    }
    
    /**
     * @param parentTreeId parentTreeId
     */
    public void setParentTreeId(String parentTreeId) {
        this.parentTreeId = parentTreeId;
    }
    
    /**
     * @return hasChild
     */
    public boolean isHasChild() {
        return hasChild;
    }
    
    /**
     * @param hasChild hasChild
     */
    public void setHasChild(boolean hasChild) {
        this.hasChild = hasChild;
    }
    
}
