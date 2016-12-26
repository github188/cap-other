/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docmodel.data;

import java.text.MessageFormat;
import java.util.HashMap;
import java.util.Map;
import java.util.Stack;
import java.util.concurrent.atomic.AtomicInteger;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.document.word.docmodel.datatype.ContentType;

/**
 * 文本内容
 * 
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年10月15日 lizhiyong
 */
public class ParagraphSet extends ComplexSeg {
    
    /** 类序列号 */
    private static final long serialVersionUID = 1L;
    
    @Override
    public void addChildContentSeg(ContentSeg contentSeg) {
        if (contentSeg instanceof Paragraph) {
            contents.add(contentSeg);
            contentSeg.setContainer(getContainer());
            return;
        }
        throw new RuntimeException(MessageFormat.format("ParagraphSet不支持的内容片断类型{0},只支持{1}:", contentSeg.getClass()
            .getName(), Paragraph.class.getName()));
    }
    
    @Override
    public String getContentType() {
        return ContentType.TEXT.name();
    }
    
    /**
     * 获得ListLevel
     *
     * @param paragraph ListLevel
     * @return -1 如果层次不存在 值，如果存在
     */
    private long getListLevel(Paragraph paragraph) {
        return paragraph == null ? -1 : paragraph.getListLevel().longValue();
    }
    
    /**
     * 获得栈顶元素
     *
     * @param paragraphStack 栈
     * @return 未找到 返回 null 否则 rclk 栈顶元素 栈不变化。
     */
    private Paragraph getStackTop(Stack<Paragraph> paragraphStack) {
        if (paragraphStack == null || paragraphStack.size() == 0) {
            return null;
        }
        return paragraphStack.peek();
    }
    
    @Override
    public String getContent() {
        if (StringUtils.isNotBlank(content)) {
            return content;
        }
        StringBuffer sbOut = new StringBuffer();
        String preListKey = null;
        String curListKey = null;
        Paragraph stackTop = null;
        Map<String, AtomicInteger> listStartIndexMap = new HashMap<String, AtomicInteger>();
        Stack<Paragraph> paragraphStack = new Stack<Paragraph>();
        long stackTopLevel = -1;
        long curLevel = -1;
        for (ContentSeg seg : contents) {
            Paragraph paragraph = (Paragraph) seg;
            if (paragraph.isList()) {
                curListKey = paragraph.getListKey().toString() + "-" + paragraph.getListLevel().toString();
                if (!StringUtils.equals(preListKey, curListKey)) {
                    stackTop = getStackTop(paragraphStack);
                    stackTopLevel = getListLevel(stackTop);
                    curLevel = getListLevel(paragraph);
                    while (curLevel <= stackTopLevel) {
                        sbOut.append(endList(paragraphStack));
                        curLevel++;
                    }
                    curLevel = getListLevel(paragraph);
                    sbOut.append(startList(paragraphStack, paragraph, listStartIndexMap, curListKey));
                }
                sbOut.append("<li>").append(paragraph.getContent()).append("</li>");
                preListKey = curListKey;
            } else {
                // if (StringUtils.isNotBlank(paragraph.getContent())) {
                sbOut.append(paragraph.getContent());
                // }
                preListKey = null;
            }
        }
        sbOut.append(endList(paragraphStack));
        
        // 输出
        content = sbOut.toString();
        return content;
    }
    
    /**
     * 获得指定List的计数器
     *
     * @param curListKey 当前ListKey
     * @param listStartIndexMap List索引
     * @return 计数器
     */
    private AtomicInteger getIndexCounter(String curListKey, Map<String, AtomicInteger> listStartIndexMap) {
        AtomicInteger atomicInteger = listStartIndexMap.get(curListKey);
        if (atomicInteger == null) {
            atomicInteger = new AtomicInteger(1);
            listStartIndexMap.put(curListKey, atomicInteger);
        }
        return atomicInteger;
    }
    
    /**
     * 开始List
     *
     * @param paragraphStack 栈
     * @param paragraph 当前段落
     * @param listStartIndexMap List 计数器集合
     * @param curListKey 当前 ListKey
     * @return 开始字符串
     */
    private String startList(Stack<Paragraph> paragraphStack, Paragraph paragraph,
        Map<String, AtomicInteger> listStartIndexMap, String curListKey) {
        AtomicInteger atomicInteger = getIndexCounter(curListKey, listStartIndexMap);
        StringBuffer sbOut = new StringBuffer();
        if (paragraph.isOl()) {
            sbOut.append("<ol start='").append(atomicInteger.getAndIncrement()).append("'>");
            paragraphStack.push(paragraph);
        } else {
            sbOut.append("<ul start='").append(atomicInteger.getAndIncrement()).append("'>");
            paragraphStack.push(paragraph);
        }
        return sbOut.toString();
    }
    
    /**
     * 结束List
     *
     * @param paragraphStack 栈
     * @return 结束List
     */
    private String endList(Stack<Paragraph> paragraphStack) {
        Paragraph stackTop;
        stackTop = getStackTop(paragraphStack);
        StringBuffer sbOut = new StringBuffer();
        if (stackTop != null) {
            if (stackTop.isOl()) {
                sbOut.append("</ol>");
            } else {
                sbOut.append("</ul>");
            }
            paragraphStack.pop();
        }
        return sbOut.toString();
    }
}
