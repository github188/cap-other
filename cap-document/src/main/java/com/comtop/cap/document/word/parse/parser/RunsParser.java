/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.parse.parser;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFHyperlink;
import org.apache.poi.xwpf.usermodel.XWPFHyperlinkRun;
import org.apache.poi.xwpf.usermodel.XWPFParagraph;
import org.apache.poi.xwpf.usermodel.XWPFRun;
import org.apache.xmlbeans.XmlCursor;
import org.apache.xmlbeans.XmlObject;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTBookmark;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTBr;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTDrawing;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTEmpty;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTHyperlink;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTObject;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTP;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTPTab;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTR;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTRPr;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTRunTrackChange;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTSdtContentRun;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTSdtRun;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTSimpleField;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTSmartTagRun;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTTabs;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTText;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.STBrType;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.STFldCharType;
import org.xml.sax.helpers.AttributesImpl;

import com.comtop.cap.document.word.docmodel.data.Paragraph;
import com.comtop.cap.document.word.docmodel.data.WordDocument;
import com.comtop.cap.document.word.parse.util.XWPFRunHelper;
import com.comtop.cap.document.word.util.SAXHelper;

/**
 * Run转换器
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年10月16日 lizhiyong
 */
public class RunsParser extends DefaultParser {
    
    /** 图形转换器 */
    private final GraphicParser graphicParser;
    
    /** 对象转换器 */
    private final CTObjecParser ctObjecParser;
    
    /**
     * 
     * 构造函数
     * 
     * @param document poi文档对象
     * @param doc word文档结构
     */
    public RunsParser(XWPFDocument document, WordDocument doc) {
        super(document, doc);
        graphicParser = new GraphicParser(document, doc);
        ctObjecParser = new CTObjecParser(document, doc);
    }
    
    /**
     * visitRuns 解析段落下的runs元素
     *
     * @param paragraph 段落
     * @param container 段落容器
     */
    @SuppressWarnings("deprecation")
    public void visitRuns(XWPFParagraph paragraph, Paragraph container) {
        boolean fldCharTypeParsing = false;
        boolean pageNumber = false;
        String url = null;
        List<XmlObject> rListAfterSeparate = null;
        // Paragraph container = new Paragraph();
        // 如果前一个元素是一段文本，则直接使用
        // 如果当前段落只是一段文本
        CTP ctp = paragraph.getCTP();
        XmlCursor c = ctp.newCursor();
        c.selectPath("child::*");
        while (c.toNextSelection()) {
            XmlObject o = c.getObject();
            if (o instanceof CTR) {
                /*
                 * Test if it's : <w:r> <w:rPr /> <w:fldChar w:fldCharType="begin" /> </w:r>
                 */
                CTR r = (CTR) o;
                STFldCharType.Enum fldCharType = XWPFRunHelper.getFldCharType(r);
                if (fldCharType != null) {
                    if (fldCharType.equals(STFldCharType.BEGIN)) {
                        process(paragraph, container, pageNumber, url, rListAfterSeparate);
                        fldCharTypeParsing = true;
                        rListAfterSeparate = new ArrayList<XmlObject>();
                        pageNumber = false;
                        url = null;
                    } else if (fldCharType.equals(STFldCharType.END)) {
                        process(paragraph, container, pageNumber, url, rListAfterSeparate);
                        fldCharTypeParsing = false;
                        rListAfterSeparate = null;
                        pageNumber = false;
                        processingTotalPageCountField = false;
                        url = null;
                    }
                } else {
                    if (fldCharTypeParsing) {
                        String instrText = XWPFRunHelper.getInstrText(r);
                        if (instrText != null) {
                            if (StringUtils.isNotEmpty(instrText)) {
                                // test if it's <w:r><w:instrText>PAGE</w:instrText></w:r>
                                boolean instrTextPage = XWPFRunHelper.isInstrTextPage(instrText);
                                if (!instrTextPage) {
                                    
                                    // test if it's <w:r><w:instrText>NUMPAGES</w:instrText></w:r>
                                    processingTotalPageCountField = XWPFRunHelper.isInstrTextNumpages(instrText);
                                    if (!totalPageFieldUsed) {
                                        totalPageFieldUsed = true;
                                    }
                                    
                                    // test if it's <w:instrText>HYPERLINK
                                    // "http://code.google.com/p/xdocrepor"</w:instrText>
                                    String instrTextHyperlink = XWPFRunHelper.getInstrTextHyperlink(instrText);
                                    if (instrTextHyperlink != null) {
                                        url = instrTextHyperlink;
                                    }
                                } else {
                                    pageNumber = true;
                                }
                            }
                        } else {
                            if (rListAfterSeparate != null) {
                                rListAfterSeparate.add(r);
                            }
                        }
                    } else {
                        XWPFRun run = new XWPFRun(r, paragraph);
                        visitRun(run, container, false, null);
                    }
                }
            } else {
                if (fldCharTypeParsing) {
                    if (rListAfterSeparate != null) {
                        rListAfterSeparate.add(o);
                    }
                } else {
                    visitRun(paragraph, container, o);
                }
            }
        }
        c.dispose();
        process(paragraph, container, pageNumber, url, rListAfterSeparate);
        fldCharTypeParsing = false;
        rListAfterSeparate = null;
        pageNumber = false;
        url = null;
    }
    
    /**
     * 解析run
     *
     * @param paragraph 段落
     * @param container 容器
     * @param o 解析的xml对象
     */
    @SuppressWarnings("deprecation")
    private void visitRun(XWPFParagraph paragraph, Paragraph container, XmlObject o) {
        if (o instanceof CTHyperlink) {
            CTHyperlink link = (CTHyperlink) o;
            String anchor = link.getAnchor();
            String href = null;
            // Test if the is an id for hyperlink
            String hyperlinkId = link.getId();
            if (StringUtils.isNotEmpty(hyperlinkId)) {
                XWPFHyperlink hyperlink = document.getHyperlinkByID(hyperlinkId);
                href = hyperlink != null ? hyperlink.getURL() : null;
            }
            for (CTR r : link.getRList()) {
                XWPFRun run = new XWPFHyperlinkRun(link, r, paragraph);
                visitRun(run, container, false, href != null ? href : "#" + anchor);
            }
        } else if (o instanceof CTSdtRun) {
            CTSdtContentRun run = ((CTSdtRun) o).getSdtContent();
            for (CTR r : run.getRList()) {
                XWPFRun ru = new XWPFRun(r, paragraph);
                visitRun(ru, container, false, null);
            }
        } else if (o instanceof CTRunTrackChange) {
            for (CTR r : ((CTRunTrackChange) o).getRList()) {
                XWPFRun run = new XWPFRun(r, paragraph);
                visitRun(run, container, false, null);
            }
        } else if (o instanceof CTSimpleField) {
            CTSimpleField simpleField = (CTSimpleField) o;
            String instr = simpleField.getInstr();
            // 1) test if it's page number
            // <w:fldSimple w:instr=" PAGE \* MERGEFORMAT "> <w:r> <w:rPr> <w:noProof/>
            // </w:rPr> <w:t>- 1 -</w:t> </w:r> </w:fldSimple>
            boolean fieldPageNumber = XWPFRunHelper.isInstrTextPage(instr);
            String fieldHref = null;
            if (!fieldPageNumber) {
                // not page number, test if it's hyperlink :
                // <w:instrText>HYPERLINK "http://code.google.com/p/xdocrepor"</w:instrText>
                fieldHref = XWPFRunHelper.getInstrTextHyperlink(instr);
            }
            for (CTR r : simpleField.getRList()) {
                XWPFRun run = new XWPFRun(r, paragraph);
                visitRun(run, container, fieldPageNumber, fieldHref);
            }
        } else if (o instanceof CTSmartTagRun) {
            // Smart Tags can be nested many times.
            // This implementation does not preserve the tagging information
            // buildRunsInOrderFromXml(o);
        } else if (o instanceof CTBookmark) {
            CTBookmark bookmark = (CTBookmark) o;
            visitBookmark(bookmark, paragraph);
        }
    }
    
    /**
     * run 访问Run
     *
     * @param run run对象
     * @param container 容器
     * @param pageNumber 页号
     * @param url url
     */
    private void visitRun(XWPFRun run, Paragraph container, boolean pageNumber, String url) {
        CTR ctr = run.getCTR();
        CTRPr rPr = ctr.getRPr();
        boolean hasTexStyles = rPr != null
            && (rPr.getHighlight() != null || rPr.getStrike() != null || rPr.getDstrike() != null || rPr.getVertAlign() != null);
        // StringBuilder text = new StringBuilder();
        // Loop for each element of <w:run text, tab, image etc
        // to keep the order of thoses elements.
        XmlCursor c = ctr.newCursor();
        c.selectPath("./*");
        while (c.toNextSelection()) {
            XmlObject o = c.getObject();
            if (o instanceof CTText) {
                CTText ctText = (CTText) o;
                String tagName = o.getDomNode().getNodeName();
                // Field Codes (w:instrText, defined in spec sec. 17.16.23)
                // come up as instances of CTText, but we don't want them
                // in the normal text output
                
                if ("w:instrText".equals(tagName)) {
                    //
                } else {
                    if (hasTexStyles) {
                        container.addTextBlockToCurText(ctText.getStringValue());
                        // text.append(ctText.getStringValue());
                    } else {
                        container.addTextBlockToCurText(ctText.getStringValue());
                        // text.append(ctText.getStringValue());
                        // visitText(ctText, pageNumber);
                    }
                }
            } else if (o instanceof CTPTab) {
                visitTab((CTPTab) o);
            } else if (o instanceof CTBr) {
                visitBR((CTBr) o);
            } else if (o instanceof CTEmpty) {
                // Some inline text elements get returned not as
                // themselves, but as CTEmpty, owing to some odd
                // definitions around line 5642 of the XSDs
                // This bit works around it, and replicates the above
                // rules for that case
                String tagName = o.getDomNode().getNodeName();
                // if ("w:tab".equals(tagName)) {
                // CTTabs tabs = stylesDocument.getParagraphTabs(run.getParagraph());
                // visitTabs(tabs, paragraphContainer);
                // }
                if ("w:br".equals(tagName)) {
                    visitBR(null);
                }
                if ("w:cr".equals(tagName)) {
                    visitBR(null);
                }
            } else if (o instanceof CTDrawing) {
                container.endCurText();
                graphicParser.visitDrawing((CTDrawing) o, container);
            } else if (o instanceof CTObject) {
                container.endCurText();
                ctObjecParser.visitObject((CTObject) o, container);
            }
        }
        c.dispose();
    }
    
    /**
     * 访问空结构的run
     *
     */
    protected void visitEmptyRun() {
        //
    }
    
    /**
     * 解析Tab
     *
     * @param o poi tab对象
     */
    protected void visitTab(CTPTab o) {
        //
    }
    
    /**
     * 解析Tabs
     *
     * @param tabs poi tabs对象
     */
    protected void visitTabs(CTTabs tabs) {
        // 暂不处理
    }
    
    /**
     * 访问换行
     *
     * @param br br
     */
    protected void visitBR(CTBr br) {
        STBrType.Enum brType = XWPFRunHelper.getBrType(br);
        if (brType.equals(STBrType.PAGE)) {
            pageBreakOnNextParagraph = true;
        } else {
            addNewLine(br);
        }
    }
    
    /**
     * 访问书签
     *
     * @param bookmark bookmark
     * @param paragraph paragraph
     */
    protected void visitBookmark(CTBookmark bookmark, XWPFParagraph paragraph) {
        AttributesImpl attributes = new AttributesImpl();
        SAXHelper.addAttrValue(attributes, "id", bookmark.getName());
    }
    
    /**
     * 处理段落
     * 
     * @param paragraph x
     * @param container 容器
     * @param pageNumber x
     * @param url x
     * @param rListAfterSeparate x
     */
    @SuppressWarnings("deprecation")
    protected void process(XWPFParagraph paragraph, Paragraph container, boolean pageNumber, String url,
        List<XmlObject> rListAfterSeparate) {
        if (rListAfterSeparate != null) {
            for (XmlObject oAfterSeparate : rListAfterSeparate) {
                if (oAfterSeparate instanceof CTR) {
                    CTR ctr = (CTR) oAfterSeparate;
                    XWPFRun run = new XWPFRun(ctr, paragraph);
                    visitRun(run, container, pageNumber, url);
                } else {
                    visitRun(paragraph, container, oAfterSeparate);
                }
            }
        }
    }
    
    /**
     * 
     * 添加新行
     *
     * @param br 换行对象
     */
    protected void addNewLine(CTBr br) {
        // 暂不处理
    }
    
    /**
     * 
     * 解析文本
     *
     * @param ctText 文本对象
     * @param pageNumber 页面编号
     */
    protected void visitText(CTText ctText, boolean pageNumber) {
        // 暂不处理
    }
    
    /**
     * 解析样式文本
     * etc.
     * 
     * @param run poi run对象
     * @param text 文本
     */
    protected void visitStyleText(XWPFRun run, String text) {
        // 暂不处理
    }
}
