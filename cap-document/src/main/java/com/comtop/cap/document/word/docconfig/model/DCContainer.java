/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docconfig.model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.concurrent.atomic.AtomicInteger;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlTransient;
import javax.xml.bind.annotation.XmlType;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.document.word.WordOptions;
import com.comtop.cap.document.word.parse.util.ExprUtil;
import com.comtop.cip.json.annotation.JSONField;

/**
 * 容器
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年11月11日 lizhiyong
 */
@XmlType(name = "ContainerElementType")
@XmlAccessorType(XmlAccessType.FIELD)
public class DCContainer extends ConfigElement {
    
    /** 类序列号 */
    private static final long serialVersionUID = 1L;
    
    /** 容器下的所有元素集包括表格、子章节、内容片段等 */
    @XmlTransient
    protected List<ConfigElement> elements = new ArrayList<ConfigElement>(10);
    
    /** 容器下的元素分类集合 transient 不生成xsd元素 */
    @XmlTransient
    protected final Map<Class<? extends ConfigElement>, List<ConfigElement>> elementClassfiyMap = new HashMap<Class<? extends ConfigElement>, List<ConfigElement>>(
        16);
    
    /** 容器的内容片段定义集 */
    @XmlTransient
    private final List<DCContentSeg> contents = new ArrayList<DCContentSeg>(10);
    
    /** 容器唯一标识 */
    @XmlTransient
    private String uri;
    
    /** 容器本身映射到的DTO类型 比如有些章节映射到业务事项（BizItemDTO），有些章节映射到业务流程(BizProcessDTO),该值是根据mappingTo的值计算出来的 */
    @XmlTransient
    protected Class<?> mappingToClass;
    
    /** 所有内容块计数器 */
    @XmlTransient
    private final AtomicInteger contentSegCounter = new AtomicInteger(0);
    
    /** 上级容器 */
    @XmlTransient
    @JSONField(serialize = false)
    private DCContainer parent;
    
    /** 查询参数表达式集 包含该容器本身查询表达式的参数值表达式 */
    @XmlTransient
    private final Map<String, String> selfQueryParamExprs = new HashMap<String, String>(10);
    
    /** 查询参数表达式集 包含该容器下所有内容涉及的查询表达式的参数值表达式 */
    @XmlTransient
    private final Map<String, String> queryParamExprs = new HashMap<String, String>(10);
    
    /** word文档模板 */
    @XmlTransient
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
     * @return 获取 mapptingToClassName属性值
     */
    public String getMappingToClassName() {
        return mappingToClass == null ? null : mappingToClass.getName();
    }
    
    @Override
    public void initConfig() {
        // 调用父类的初始化方法
        super.initConfig();
        // 将从xml中读取的元素进行分类放置到不同的数据集合中
        for (ConfigElement element : elements) {
            addClassifyElement(element);
            addElementToChildType(element);
        }
        // 对容器中的内容元素进行初始化
        for (DCContentSeg element : contents) {
            element.setContainer(this);
            element.initConfig();
        }
        
        // 初始化容器内容占位符
        initContentSegPlaceholder();
    }
    
    /**
     * 为容器的内容片段添加占位元素。
     * 对于一个容器而言，如果定义时未定义其下的内容结构，会默认创建一个内容片段占用符。
     * 如果其中有已定义的结构化表格，则表格前和表格后均会设计一个内容片段占位符，用于在表格前和表格后描述表格相关的信息。
     * 如果表格前或后已经定义，则只在未添加定义的位置添加占位符。
     * 占位符通过容器的Uri（uri）、文档id（documentId）、占位符排序号（sortNo）三个属性来唯一定位。
     * 如： <br/>
     * 占位符1（documentId='0',containerUri='1',sortNo=0）<br/>
     * 表格1<br/>
     * 占位符2（documentId='0',containerUri='1',sortNo=1）<br/>
     * 表格2<br/>
     * 占位符3（documentId='0',containerUri='1',sortNo=2）
     * 
     * <br/>
     * 上述例子中，如果实际文档中表格1前面没有内容，而后面有内容，那么存储在数据库中的数据，会使用占位符2，
     * 即存储的数据有一条documentId='0',containerUri='1',sortNo=1的数据，而不会有documentId='0',containerUri='1',sortNo=0的数据。
     * 这样的设计是为了保证内容片段结构的稳定。因此无论是在页面上修改内容值还是在导入时更新内容，均可以通过documentId='0',containerUri='1',
     * sortNo=1这三个属性来唯一确定一段内容的位置。
     */
    private void initContentSegPlaceholder() {
        // 没有定义内容，则添加默认的占位符
        if (contents.size() == 0) {
            addContengSeg(0, 0);
            return;
        }
        // 已定义内容结构，则根据已经定义的结构来确定需要在哪些位置添加占位符
        DCContentSeg contentSeg = null;
        DCContentSeg preContentSeg = null;
        int contentSegSortNo = 0;
        for (int i = 0; i < contents.size();) {
            contentSeg = contents.get(i);
            
            // 如果已经定义的内容片段的类型是一个表格，则按需添加占位符
            if (contentSeg instanceof DCTable) {
                // 取得当前元素的前一个元素
                if (i > 0) {
                    preContentSeg = contents.get(i - 1);
                }
                // 如果前一个元素没有或者前一个元素是表格，则添加占位符
                if (preContentSeg == null || preContentSeg instanceof DCTable) {
                    // 添加的位置在当前元素之前，其位置为i的值。
                    addContengSeg(i, contentSegSortNo);
                    // 添加完成后，当前表格的位置变成了i+1，下一个要处理的元素为i+2
                    i = i + 2;
                    // 序号+1
                    contentSegSortNo++;
                    continue;
                }
                // 如果前一个元素存在且不是表格，则处理下一个要处理的元素。
                i++;
            } else {
                // 如果不是表格，计数器加1，处理下一个元素。
                i++;
                contentSeg.setSortNo(contentSegSortNo);
                // 序号+1
                contentSegSortNo++;
            }
        }
        
        // 如果最后一个元素是表格，则其其后添加一个内容片段占位符
        int iSize = contents.size();
        DCContentSeg lastContentSeg = contents.get(iSize - 1);
        if (lastContentSeg instanceof DCTable) {
            addContengSeg(iSize, contentSegSortNo);
        }
    }
    
    /**
     * 添加内容片段
     * 
     * @param index 索引号
     *
     * @param sortNo 序号
     */
    private void addContengSeg(int index, int sortNo) {
        DCContentSeg addContentSeg;
        addContentSeg = new DCContentSeg();
        WordOptions options = getDocConfig().getOptions();
        if (options != null) {
            addContentSeg.setNeedStore(options.isNeedStoreContentSeg());
        }
        addContentSeg.setMappingTo("contentSeg = #ContentSeg(documentId=$documentId,containerUri={0},sortNo=" + sortNo
            + ")");
        addContentSeg.setContainer(this);
        addContentSeg.setSortNo(sortNo);
        contents.add(index, addContentSeg);
    }
    
    /**
     * 
     * 根据类型获得分类列表中的数据
     *
     * @param key 类型，即定义的元素的class对象
     * @return 该 分类下的对象集合，没有返回null。
     */
    public List<? extends ConfigElement> getElements(Class<? extends ConfigElement> key) {
        return this.elementClassfiyMap.get(key);
    }
    
    /**
     * 
     * 获得所有的元素
     *
     * @return 所有元素集
     */
    public List<ConfigElement> getElements() {
        return this.elements;
    }
    
    /**
     * @return 获取 contents属性值
     */
    public List<DCContentSeg> getContents() {
        return contents;
    }
    
    /**
     * 将元素添加到分类集合中
     *
     * @param element word元素
     */
    private void addClassifyElement(ConfigElement element) {
        List<ConfigElement> elementList = elementClassfiyMap.get(element.getClass());
        if (elementList == null) {
            elementList = new ArrayList<ConfigElement>(10);
            elementClassfiyMap.put(element.getClass(), elementList);
        }
        elementList.add(element);
    }
    
    /**
     * 将指定元素添加到子类的集合中,便于在计算时快速分类
     *
     * @param wordElement word元素
     */
    protected void addElementToChildType(ConfigElement wordElement) {
        if (wordElement instanceof DCContentSeg) {
            DCContentSeg contentSeg = (DCContentSeg) wordElement;
            contentSeg.setContainer(this);
            this.contents.add(contentSeg);
            contentSeg.setSortNo(contents.size());
            if (contentSeg instanceof DCTable) {
                DCTable table = (DCTable) wordElement;
                List<? extends ConfigElement> tables = getElements(DCTable.class);
                table.setTableIndex(tables.size());
            }
        }
    }
    
    /**
     * 
     * 添加子元素。本方法将子元素添加到所有列表，分类列表及用户自定义的列表。用户自定义的列表需要用户实现 addElementToChildType方法
     *
     * @param wordElement word元素
     */
    public final void addChildElement(ConfigElement wordElement) {
        elements.add(wordElement);
        addClassifyElement(wordElement);
        addElementToChildType(wordElement);
    }
    
    /**
     * 获得上级元素
     * 
     *
     * @return 上级元素
     */
    public DCContainer getParent() {
        return parent;
    }
    
    /**
     * @param parent 设置 parent 属性值为参数值 parent
     */
    public void setParent(DCContainer parent) {
        this.parent = parent;
    }
    
    /**
     * @return 获取 mapptingToClass属性值
     */
    public Class<?> getMappingToClass() {
        return mappingToClass;
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
     * 移除内容
     *
     * @param contentSeg 内容片段
     */
    public void remove(DCContentSeg contentSeg) {
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
        for (ConfigElement wordElement : contents) {
            sb.append(wordElement.toString()).append("\r\n");
        }
        return sb.toString();
    }
    
    /**
     * @return 获取 queryExprParams属性值
     */
    public Map<String, String> getQueryParamExprs() {
        return queryParamExprs;
    }
    
    /**
     * @param queryExprParamSet 设置 queryExprParams 属性值为参数值 queryExprParams
     */
    public void addQueryParamExprs(Map<String, String> queryExprParamSet) {
        if (queryExprParamSet != null && queryExprParamSet.size() > 0) {
            for (Entry<String, String> entry : queryExprParamSet.entrySet()) {
                addQueryParamExpr(entry.getKey(), entry.getValue());
            }
        }
    }
    
    /**
     * @param attributeExpr 属性的表达式
     * @param valueExpr valueExpr 值的表达式
     */
    public void addQueryParamExpr(String attributeExpr, String valueExpr) {
        if (valueExpr.indexOf('$') >= 0) {
            this.queryParamExprs.put(attributeExpr, valueExpr);
        } else {
            String varName = ExprUtil.getVarNameFromAttribute(valueExpr);
            String containerVar = ExprUtil.getVarNameFromExpr(getMappingTo());
            if (StringUtils.isNotBlank(varName) && StringUtils.equals(varName, containerVar)) {
                this.queryParamExprs.put(attributeExpr, valueExpr);
            }
        }
        // 递归调用上级的添加方法
        if (this.getParent() != null) {
            this.getParent().addQueryParamExpr(attributeExpr, valueExpr);
        }
    }
    
    /**
     * @return 获取 queryExprParams属性值
     */
    public Map<String, String> getSelfQueryParamExprs() {
        return this.selfQueryParamExprs;
    }
    
    /**
     * @param queryExprParamSet 设置 queryExprParams 属性值为参数值 queryExprParams
     */
    public void addSelfQueryParamExprs(Map<String, String> queryExprParamSet) {
        this.selfQueryParamExprs.putAll(queryExprParamSet);
        this.addQueryParamExprs(queryExprParamSet);
    }
    
    /**
     * @param attributeExpr 属性的表达式
     * @param valueExpr valueExpr 值的表达式
     */
    public void addSelfQueryParamExpr(String attributeExpr, String valueExpr) {
        this.selfQueryParamExprs.put(attributeExpr, valueExpr);
        addQueryParamExpr(attributeExpr, valueExpr);
    }
    
}
