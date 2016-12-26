/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.write;

import static com.comtop.cap.document.word.util.FolderUtil.projectOutputPath;

import java.io.IOException;
import java.util.Iterator;

import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFParagraph;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.junit.Test;

/**
 * 文档帮助类测试
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年10月28日 lizhongwen
 */
public class DocxHelperTest {
    
    /**
     * 测试创建超链接
     * 
     * @throws IOException IO异常
     */
    @Test
    public void testCreateHyperlink() throws IOException {
        DocxHelper helper = DocxHelper.getInstance();
        XWPFDocument docx = helper.createDocument();
        XWPFParagraph paragraph = docx.createParagraph();
        helper.createHyperlink(paragraph, "这是一个超链接", "http://www.baidu.com");
        helper.saveDocument(docx, projectOutputPath() + "/hyperlink.docx");
    }
    
    /**
     * 测试创建默认的页眉页脚
     * 
     * @throws Exception IO异常
     */
    @Test
    public void testCreateDefaultHeaderFooter() throws Exception {
        DocxHelper helper = DocxHelper.getInstance();
        XWPFDocument docx = helper.createDocument();
        helper.createDefaultFooter(docx);
        helper.createDefaultHeader(docx, "业务模型说明书");
        StringBuilder builder = new StringBuilder();
        String text;
        for (int i = 0; i < 500 * 100; i++) {
            builder.append((char) i);
            if (i % 100 == 0) {
                text = builder.toString();
                builder = new StringBuilder();
                docx.createParagraph().createRun().setText(text);
            }
        }
        helper.saveDocument(docx, projectOutputPath() + "/HeaderFooter.docx");
    }
    
    /**
     * 测试创建默认的封面页
     * 
     * @throws Exception 异常
     */
    @Test
    public void testCreateDefaultConver() throws Exception {
        DocxHelper helper = DocxHelper.getInstance();
        XWPFDocument docx = helper.createDocument();
        // helper.createDefaultFooter(docx);
        // helper.createDefaultHeader(docx, "业务模型说明书");
        helper.createFrontCover(docx, "业务模型说明书");
        // StringBuilder builder = new StringBuilder();
        // String text;
        // for (int i = 0; i < 500 * 100; i++) {
        // builder.append((char) i);
        // if (i % 100 == 0) {
        // text = builder.toString();
        // builder = new StringBuilder();
        // docx.createParagraph().createRun().setText(text);
        // }
        // }
        helper.saveDocument(docx, projectOutputPath() + "/DefautCover.docx");
    }
    
    /**
     * 测试创建默认的封面页
     */
    @Test
    public void testHTML() {
        String html = "abc叮叮当当";
        Document document = Jsoup.parseBodyFragment(html);
        printTag(document);
    }
    
    /**
     * FIXME 方法注释信息
     *
     * @param element xxx
     */
    private void printTag(Element element) {
        System.out.println(element.nodeName() + "::" + element);
        Elements elements = element.children();
        if (elements == null) {
            return;
        }
        Iterator<Element> it = elements.iterator();
        while (it.hasNext()) {
            printTag(it.next());
        }
    }
}
