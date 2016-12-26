/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docmodel.data;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.document.word.docconfig.datatype.OutlineLevel;
import com.comtop.cap.document.word.docconfig.datatype.TableType;
import com.comtop.cap.document.word.docconfig.model.DCContainer;
import com.comtop.cap.document.word.docconfig.model.DCContentSeg;
import com.comtop.cap.document.word.docconfig.model.DCTable;
import com.comtop.cap.document.word.docconfig.model.DocConfig;
import com.comtop.cap.document.word.docmodel.datatype.ContentType;
import com.comtop.cap.document.word.docmodel.datatype.DataFromType;
import com.comtop.cip.json.annotation.JSONField;

/**
 * 容器
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年11月11日 lizhiyong
 */
public class Container extends WordElement {
    
    /** 类序列号 */
    private static final long serialVersionUID = 1L;
    
    /**
     * logger
     */
    protected static final Logger LOGGER = LoggerFactory.getLogger(Container.class);
    
    /** 内容集 */
    private final List<ContentSeg> contents = new ArrayList<ContentSeg>(10);
    
    /** word文档 */
    private WordDocument document;
    
    /** 唯一标识 */
    private String uri;
    
    /** 唯一标识 */
    private String uriName;
    
    /** 文本内容计数器 */
    private AtomicInteger textCounter = new AtomicInteger(0);
    
    /** 所有内容块计数器 */
    private final AtomicInteger contentSegCounter = new AtomicInteger(0);
    
    /** 所有内容块计数器 */
    private final Map<Class<? extends ContentSeg>, AtomicInteger> classifyCounter = new HashMap<Class<? extends ContentSeg>, AtomicInteger>(
        10);
    
    /** 上级元素 */
    @JSONField(serialize = false)
    private Container parent;
    
    /** word文档模板 */
    private DocConfig docConfig;
    
    /**
     * @return 获取 docTemplate属性值
     */
    public DocConfig getDocConfig() {
        return docConfig;
    }
    
    /**
     * @param docConfig 设置 docConfig 属性值为参数值 docConfig
     */
    public void setDocConfig(DocConfig docConfig) {
        this.docConfig = docConfig;
    }
    
    /**
     * @return 获取 contentSegCounter属性值
     */
    public AtomicInteger getContentSegCounter() {
        return contentSegCounter;
    }
    
    /**
     * @return 获取 contents属性值
     */
    public List<ContentSeg> getContents() {
        return contents;
    }
    
    /**
     * 将指定元素添加到子类的集合中,便于在计算时快速分类
     *
     * @param wordElement word元素
     */
    protected void addElementToChildType(WordElement wordElement) {
        if (wordElement instanceof ContentSeg) {
            ContentSeg contentSeg = (ContentSeg) wordElement;
            contentSeg.setContainer(this);
            this.contents.add(contentSeg);
            contentSeg.setSortNo(contents.size());
            if (contentSeg instanceof Table) {
                Table table = (Table) wordElement;
                AtomicInteger atomicInteger = classifyCounter.get(Table.class);
                if (atomicInteger == null) {
                    atomicInteger = new AtomicInteger(0);
                    classifyCounter.put(Table.class, atomicInteger);
                }
                table.setTableIndex(atomicInteger.getAndIncrement());
            }
        }
    }
    
    /**
     * 
     * 添加子元素。本方法将子元素添加到所有列表，分类列表及用户自定义的列表。用户自定义的列表需要用户实现 addElementToChildType方法
     *
     * @param wordElement word元素
     */
    public final void addChildElement(WordElement wordElement) {
        addElementToChildType(wordElement);
    }
    
    /**
     * 获得上级元素
     * 
     *
     * @return 上级元素
     */
    public Container getParent() {
        return parent;
    }
    
    /**
     * @param parent 设置 parent 属性值为参数值 parent
     */
    public void setParent(Container parent) {
        this.parent = parent;
    }
    
    /**
     * @return 获取 uri属性值
     */
    public String getUri() {
        return uri;
    }
    
    /**
     * @return 获取 uri属性值
     */
    public String getUriDefinition() {
        return uri;
    }
    
    /**
     * @param uri 设置 uri 属性值为参数值 uri
     */
    public void setUri(String uri) {
        this.uri = uri;
    }
    
    /**
     * @return 获取 document属性值
     */
    public WordDocument getDocument() {
        return document;
    }
    
    /**
     * @param document 设置 document 属性值为参数值 document
     */
    public void setDocument(WordDocument document) {
        this.document = document;
    }
    
    /**
     * 获得最后一个文本内容
     *
     * @return 最后 一个文本内容
     */
    @JSONField(serialize = false)
    public ContentSeg getLastHtmlTextContent() {
        StringBuffer sbContent = new StringBuffer();
        Table table = null;
        DCTable tableDef = null;
        ContentSeg contentSeg = null;
        for (int i = contents.size() - 1; i >= 0; i--) {
            contentSeg = contents.get(i);
            if (contentSeg instanceof Table) {
                table = (Table) contentSeg;
                tableDef = (DCTable) table.getDefinition();
                if (tableDef != null && tableDef.getType() != TableType.UNKNOWN) {
                    contentSegCounter.incrementAndGet();
                    break;
                }
                // 如果当前表格不需要存储，则跳过。能到这一步，表明 是不需要存储的unknown表格
                if (tableDef != null && !tableDef.isNeedStore()) {
                    continue;
                }
            }
            if (contentSeg != null) {
                String text = sbContent.toString();
                sbContent.delete(0, sbContent.length());
                sbContent.append(contentSeg.getContent()).append(text);
            }
        }
        if ("".equals(sbContent.toString())) {
            return null;
        }
        
        ContentSeg retContentSeg = new ContentSeg();
        retContentSeg.setContent(sbContent.toString());
        retContentSeg.setSortNo(textCounter.getAndIncrement());
        retContentSeg.setContainerId(getUri());
        retContentSeg.setDataFrom(DataFromType.IMPORT);
        retContentSeg.setDocumentId(this.getDocument().getId());
        retContentSeg.setContainerType(getClass().getSimpleName());
        retContentSeg.setContainer(this);
        retContentSeg.setContentType(ContentType.UN_DEF_TXT.name());
        
        DCContainer containerDef = (DCContainer) getDefinition();
        DCContentSeg segDefinition = null;
        if (containerDef == null) {
            segDefinition = new DCContentSeg();
            segDefinition.setMappingTo("contentSeg = #ContentSeg(documentId=$documentId,containerId={0},sortNo=1)");
        } else {
            List<DCContentSeg> contentSegDefs = containerDef.getContents();
            int index = contentSegCounter.get();
            try {
                segDefinition = contentSegDefs.get(index);
            } catch (Exception e) {
            	LOGGER.debug("get seg definition error", e);
                segDefinition = new DCContentSeg();
                segDefinition.setMappingTo("contentSeg = #ContentSeg(documentId=$documentId,containerId={0},sortNo="
                    + index + ")");
            }
            contentSegCounter.incrementAndGet();
        }
        retContentSeg.setDefinition(segDefinition);
        
        return retContentSeg;
    }
    
    /**
     * 获得容器中的最后一个内容片段
     *
     * @return 获得最后一个内容
     */
    public ContentSeg getLastContent() {
        int size = contents.size();
        if (size == 0) {
            return null;
        }
        return contents.get(size - 1);
    }
    
    /**
     * 获得最后一个文本内容
     *
     * @return 最后 一个文本内容
     */
    public Table getLastTableContent() {
        ContentSeg content = getLastContent();
        return content == null ? null : ((content instanceof Table) ? (Table) content : null);
    }
    
    /**
     * 移除内容
     *
     * @param contentSeg 内容片段
     */
    public void remove(ContentSeg contentSeg) {
        this.contents.remove(contentSeg);
    }
    
    /**
     * 移除第一个内容
     *
     */
    public void removeFirst() {
        this.contents.remove(0);
    }
    
    /**
     * 移除第一个内容
     *
     */
    public void removeLast() {
        this.contents.remove(this.contents.size() - 1);
    }
    
    @Override
    public String toString() {
        StringBuffer sb = new StringBuffer();
        for (WordElement wordElement : contents) {
            sb.append(wordElement.toString()).append("\r\n");
        }
        return sb.toString();
    }
    
    /**
     * 获得已有章节中的最后一个章节
     * 
     * @param chapters 章节集
     *
     * @return 最后一个章节 没找到返回null
     */
    public Chapter getLastChapter(List<Chapter> chapters) {
        Chapter lastChapter = null;
        List<Chapter> childs = chapters;
        while (childs != null && childs.size() > 0) {
            lastChapter = childs.get(childs.size() - 1);
            childs = lastChapter.getChildChapters();
        }
        return lastChapter;
    }
    
    /**
     * 
     * 获得指定大纲等级的最后一个章节
     * 
     * @param chapters 章节集
     *
     * @param outlineLevel 大纲等级
     * @return 符合条件的最后一个章节 没有返回null
     */
    public Chapter getLastChapter(List<Chapter> chapters, int outlineLevel) {
        Chapter lastChapter = null;
        List<Chapter> childs = chapters;
        OutlineLevel tempOutlineLevel = OutlineLevel.getOutlineLevel(outlineLevel);
        while (childs != null && childs.size() > 0) {
            lastChapter = childs.get(childs.size() - 1);
            if (lastChapter.getOutlineLevel() == tempOutlineLevel) {
                break;
            }
            childs = lastChapter.getChildChapters();
        }
        return lastChapter;
    }
    
    /**
     * 
     * 获得指定大纲等级的最后一个上级章节
     * 
     * @param chapters 章节集
     *
     * @param outlineLevel 大纲等级
     * @return 符合条件的最后一个上级章节 没有返回null
     */
    public Chapter getLastParentChapter(List<Chapter> chapters, OutlineLevel outlineLevel) {
        Chapter lastChapter = getLastChapter(chapters);
        Chapter parentChapter = lastChapter;
        while (parentChapter != null) {
            if (parentChapter.getOutlineLevel().getValue() < outlineLevel.getValue()) {
                return parentChapter;
            }
            parentChapter = parentChapter.getParentChapter();
        }
        return null;
    }
    
    /**
     * 获得最后一段文本
     *
     * @return 最后一段文本 没有返回null.
     */
    public ParagraphSet getLastTextContent() {
        ContentSeg content = getLastContent();
        return content == null ? null : ((content instanceof ParagraphSet) ? (ParagraphSet) content : null);
    }
    
    /**
     * @return 获取 uriName属性值
     */
    public String getUriName() {
        return uriName;
    }
    
    /**
     * @param uriName 设置 uriName 属性值为参数值 uriName
     */
    public void setUriName(String uriName) {
        this.uriName = uriName;
    }
    
    /**
     * 获得全路径
     *
     * @return 全路径
     */
    public String getUriChain() {
        if (getParent() == null) {
            return this.getName();
        }
        return getParent().getUriChain() + "/" + this.getName();
    }
}
