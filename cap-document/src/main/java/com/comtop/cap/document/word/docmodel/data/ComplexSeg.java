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

import org.apache.commons.lang.StringUtils;

/**
 * 文本内容
 * 
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年10月15日 lizhiyong
 */
public class ComplexSeg extends ContentSeg {
    
    /** 类序列号 */
    private static final long serialVersionUID = 1L;
    
    /** 所有内容集 */
    protected List<ContentSeg> contents = new ArrayList<ContentSeg>(10);
    
    /** 分类内容集 */
    protected final Map<Class<? extends ContentSeg>, List<ContentSeg>> contentClassfiyMap = new HashMap<Class<? extends ContentSeg>, List<ContentSeg>>(
        16);
    
    /**
     * 
     * 根据类型获得分类列表中的数据
     *
     * @param key 类型，即定义的元素的class对象
     * @return 该 分类下的对象集合，没有返回null。
     */
    public List<? extends ContentSeg> getContents(Class<? extends ContentSeg> key) {
        return this.contentClassfiyMap.get(key);
    }
    
    /**
     * @return 获取 contents属性值
     */
    public List<ContentSeg> getContents() {
        return contents;
    }
    
    /**
     * 将元素添加到分类集合中
     *
     * @param contengSeg word元素
     */
    private void addClassifyContentSeg(ContentSeg contengSeg) {
        List<ContentSeg> elementList = contentClassfiyMap.get(contengSeg.getClass());
        if (elementList == null) {
            elementList = new ArrayList<ContentSeg>(10);
            contentClassfiyMap.put(contengSeg.getClass(), elementList);
        }
        elementList.add(contengSeg);
    }
    
    /**
     * 将指定元素添加到子类的集合中,便于在计算时快速分类
     *
     * @param contentSeg word元素
     */
    protected void addContentSegToChildType(ContentSeg contentSeg) {
        // if (contentSeg instanceof Table) {
        // Table table = (Table) contentSeg;
        // List<? extends WordElement> tables = getContents(Table.class);
        // table.setTableIndex(tables.size());
        // }
    }
    
    /**
     * 
     * 添加子元素。本方法将子元素添加到所有列表，分类列表及用户自定义的列表。用户自定义的列表需要用户实现 addElementToChildType方法
     *
     * @param contentSeg word元素
     */
    public void addChildContentSeg(ContentSeg contentSeg) {
        contents.add(contentSeg);
        contentSeg.setSortNo(contents.size());
        contentSeg.setContainer(getContainer());
        addClassifyContentSeg(contentSeg);
        addContentSegToChildType(contentSeg);
    }
    
    /**
     * 获得文本
     *
     * @return 文本
     */
    @Override
    public String getContent() {
        if (StringUtils.isNotBlank(content)) {
            return content;
        }
        StringBuffer sbBuffer = new StringBuffer();
        for (ContentSeg paragraph : contents) {
            sbBuffer.append(paragraph.getContent());
        }
        content = sbBuffer.toString();
        return content;
    }
}
