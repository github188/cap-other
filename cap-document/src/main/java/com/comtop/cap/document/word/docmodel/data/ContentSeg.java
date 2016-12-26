/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docmodel.data;


/**
 * 内容父类
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年10月15日 lizhiyong
 */
public class ContentSeg extends WordElement {
    
    /** 类序列号 */
    private static final long serialVersionUID = 1L;
    
    /** 所属章节 */
    private transient Container container;
    
    /**
     * 章节或分节ID。CONTAINER_TYPE为0，填章节id。CONTAINER_TYPE为1 ，填写分节id。
     * 此值表示当前内容所属的章节或分节。如果有些word文档没有章节，则内容会直接挂在分节下。
     * 一个文档至少有一个默认分节
     */
    private String containerId;
    
    /** 容器唯一标识 */
    private String containerUri;
    
    /** 容器唯一标识 */
    private String containerUriName;
    
    /** chapter 章节 Section 分节 */
    private String containerType;
    
    /** 类型。已定义表格类型、未定义表格类型、未定义纯文本类型、已定义文本类型、图片类型、嵌入式对象类型 */
    private String contentType;
    
    /** 模板元素ID */
    private String tmplElmId;
    
    /** 关联的内容的Id。若要获得具体的内容，则根据类型字段来查找到对应的表。 */
    private String contentId;
    
    /** 业务域id */
    private String domainId;
    
    /** 数据来源 */
    private int dataFrom;
    
    /** 文档Id */
    private String documentId;
    
    /** html文本 */
    // @JSONField(serialize = false)
    protected String content;
    
    /** 内容是否需要持久化 */
    private boolean needStore = false;
    
    /** 是否是新的数据对象 */
    private boolean newData = true;
    
    /**
     * @return 获取 newData属性值
     */
    public boolean isNewData() {
        return newData;
    }
    
    /**
     * @param newData 设置 newData 属性值为参数值 newData
     */
    public void setNewData(boolean newData) {
        this.newData = newData;
    }
    
    /**
     * @return 获取 contentType属性值
     */
    public String getContentType() {
        return contentType;
    }
    
    /**
     * @return 获取 containerId属性值
     */
    public String getContainerId() {
        return containerId == null ? (container == null ? null : container.getId()) : containerId;
    }
    
    /**
     * @param containerId 设置 containerId 属性值为参数值 containerId
     */
    public void setContainerId(String containerId) {
        this.containerId = containerId;
    }
    
    /**
     * @return 获取 containerType属性值
     */
    public String getContainerType() {
        return containerType;
    }
    
    /**
     * @param containerType 设置 containerType 属性值为参数值 containerType
     */
    public void setContainerType(String containerType) {
        this.containerType = containerType;
    }
    
    /**
     * @return 获取 tmplElmId属性值
     */
    public String getTmplElmId() {
        return tmplElmId;
    }
    
    /**
     * @param tmplElmId 设置 tmplElmId 属性值为参数值 tmplElmId
     */
    public void setTmplElmId(String tmplElmId) {
        this.tmplElmId = tmplElmId;
    }
    
    /**
     * @return 获取 contentId属性值
     */
    public String getContentId() {
        return contentId;
    }
    
    /**
     * @return 获取 container属性值
     */
    public Container getContainer() {
        return container;
    }
    
    /**
     * @param container 设置 container 属性值为参数值 container
     */
    public void setContainer(Container container) {
        this.container = container;
        if (container != null) {
            this.containerId = container.getId();
            this.containerUri = container.getUri();
        }
    }
    
    /**
     * @return 获取 containerUri属性值
     */
    public String getContainerUri() {
        return containerUri == null ? (container == null ? null : container.getUri()) : containerUri;
    }
    
    /**
     * @param contentType 设置 contentType 属性值为参数值 contentType
     */
    public void setContentType(String contentType) {
        this.contentType = contentType;
    }
    
    /**
     * @return 获取 dataFrom属性值
     */
    public int getDataFrom() {
        return dataFrom;
    }
    
    /**
     * @param dataFrom 设置 dataFrom 属性值为参数值 dataFrom
     */
    public void setDataFrom(int dataFrom) {
        this.dataFrom = dataFrom;
    }
    
    /**
     * @return 获取 documentId属性值
     */
    public String getDocumentId() {
        return documentId;
    }
    
    /**
     * @param documentId 设置 documentId 属性值为参数值 documentId
     */
    public void setDocumentId(String documentId) {
        this.documentId = documentId;
    }
    
    /**
     * 获得Html文本
     *
     * @return content文本
     */
    public String getContent() {
        return content;
    }
    
    /**
     * @param content 设置 content 属性值为参数值 htmlText
     */
    public void setContent(String content) {
        this.content = content;
    }
    
    /**
     * @return 获取 needStore属性值
     */
    public boolean isNeedStore() {
        return needStore;
    }
    
    /**
     * @param needStore 设置 needStore 属性值为参数值 needStore
     */
    public void setNeedStore(boolean needStore) {
        this.needStore = needStore;
    }
    
    /**
     * @return 获取 containerUriName属性值
     */
    public String getContainerUriName() {
        return containerUriName == null ? (this.container == null ? null : container.getUriName()) : containerUriName;
    }
    
    /**
     * @param containerUri 设置 containerUri 属性值为参数值 containerUri
     */
    public void setContainerUri(String containerUri) {
        this.containerUri = containerUri;
    }
    
    /**
     * @param containerUriName 设置 containerUriName 属性值为参数值 containerUriName
     */
    public void setContainerUriName(String containerUriName) {
        this.containerUriName = containerUriName;
    }
    
    /**
     * @param contentId 设置 contentId 属性值为参数值 contentId
     */
    public void setContentId(String contentId) {
        this.contentId = contentId;
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
}
