/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.parse.parser;

import java.util.List;

import org.apache.poi.xwpf.usermodel.IBodyElement;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFParagraph;
import org.apache.poi.xwpf.usermodel.XWPFTable;

import com.comtop.cap.document.word.docmodel.data.WordDocument;
import com.comtop.cap.document.word.docmodel.data.WordElement;
import com.comtop.cap.document.word.parse.util.ExprUtil;

/**
 * body转换器
 * 
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年10月14日 lizhiyong
 */
public class BodyParser extends DefaultParser {
    
    /** Tab键对应的 字符串 */
    static final String TAB_CHAR_SEQUENCE = "&nbsp;&nbsp;&nbsp;&nbsp;";
    
    /** 表格转换器 */
    private final TableParser tableParser;
    
    /** 段落转换器 */
    private final ParagraphParser paragraphParser;
    
    /**
     * 构造函数
     * 
     * @param document 文档
     * @param doc 文档模型
     */
    public BodyParser(XWPFDocument document, WordDocument doc) {
        super(document, doc);
        paragraphParser = new ParagraphParser(document, doc);
        tableParser = new TableParser(document, doc, paragraphParser);
    }
    
    /**
     * 访问body元素
     *
     * @param bodyElements bo元素集
     * @param container 上级容器
     */
    public void visitBodyElements(List<IBodyElement> bodyElements, WordElement container) {
        WordElement preElement = null;
        if (getDoc().getOptions().isNeedStoreContentSeg()) {
            ExprUtil.createGlobalHtmlTextContent(expExecuter, getDoc().getId());
        }
        for (int i = 0; i < bodyElements.size(); i++) {
            IBodyElement bodyElement = bodyElements.get(i);
            switch (bodyElement.getElementType()) {
                case PARAGRAPH:
                    XWPFParagraph paragraph = (XWPFParagraph) bodyElement;
                    preElement = paragraphParser.visitParagraph(paragraph, i, preElement);
                    break;
                case TABLE:
                    tableParser.visitTable((XWPFTable) bodyElement);
                    break;
                default:
                    break;
            }
        }
        
        // 结束章节表达式
        ExprUtil.endDocChapter(expExecuter, doc);
        if (getDoc().getOptions().isNeedStoreContentSeg()) {
            ExprUtil.endGlobalHtmlTextContent(expExecuter);
        }
    }
}
