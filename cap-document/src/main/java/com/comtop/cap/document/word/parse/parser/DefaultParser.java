/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.parse.parser;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;

import org.apache.commons.io.IOUtils;
import org.apache.poi.openxml4j.opc.PackagePart;
import org.apache.poi.xwpf.usermodel.XWPFAbstractNum;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFFooter;
import org.apache.poi.xwpf.usermodel.XWPFHeader;
import org.apache.poi.xwpf.usermodel.XWPFNum;
import org.apache.poi.xwpf.usermodel.XWPFParagraph;
import org.apache.poi.xwpf.usermodel.XWPFStyle;
import org.apache.poi.xwpf.usermodel.XWPFStyles;
import org.apache.xmlbeans.XmlException;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTDecimalNumber;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTHdrFtr;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTHdrFtrRef;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTNumPr;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTPPr;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTSectPr;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTString;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTStyle;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.FtrDocument;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.HdrDocument;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.component.loader.FileLocation;
import com.comtop.cap.component.loader.util.LoaderUtil;
import com.comtop.cap.document.word.docmodel.data.Chapter;
import com.comtop.cap.document.word.docmodel.data.Container;
import com.comtop.cap.document.word.docmodel.data.WordDocument;
import com.comtop.cap.document.word.expression.IExpressionExecuter;
import com.comtop.cap.document.word.parse.WordParseException;
import com.comtop.cap.document.word.parse.check.DocCheckLogger;

/**
 * 基本转换器
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年10月16日 lizhiyong
 */
public class DefaultParser {
    
    /** 日志 */
    protected static final Logger LOGGER = LoggerFactory.getLogger(DefaultParser.class.getName());
    
    /** 校验日志记录 */
    protected final DocCheckLogger checkLogger;
    
    /** 处理汇总页计数字段 */
    protected boolean processingTotalPageCountField = false;
    
    /** 汇总页字段是否已经使用 */
    protected boolean totalPageFieldUsed = false;
    
    /** 下段新页 */
    protected boolean pageBreakOnNextParagraph;
    
    /** word文档对象 */
    protected final WordDocument doc;
    
    /** poi文档对象 */
    protected XWPFDocument document;
    
    /** poi样式文档对象 */
    protected XWPFStyles stylesDocument;
    
    /** word中的嵌入式对象的路径 */
    protected static final String WORD_MEDIA = "word/media/";
    
    /** poi 页眉 */
    protected XWPFHeader currentHeader;
    
    /** poi 页脚 */
    protected XWPFFooter currentFooter;
    
    /** 表达式执行器 */
    protected final IExpressionExecuter expExecuter;
    
    /**
     * 
     * 构造函数
     * 
     * @param document poi 文档
     * @param doc word文档
     */
    public DefaultParser(XWPFDocument document, WordDocument doc) {
        this.document = document;
        this.doc = doc;
        this.stylesDocument = document.getStyles();
        this.checkLogger = new DocCheckLogger(doc);
        this.expExecuter = doc.getOptions().getExpExecuter();
        if (doc.getOptions().isNeedStoreContentSeg()) {
            Class<?> classContentSeg = doc.getOptions().getConfiguration().getContext().lookupValueObject("ContentSeg");
            if (classContentSeg == null) {
                throw new WordParseException("未找到ContentSeg服务定义");
            }
        }
    }
    
    /**
     * 获得当前的内容容器
     *
     * @return 获得当前容器
     */
    protected Container getCurrentContainer() {
        Chapter lastChapter = doc.getCurrentSection().getLastChapter();
        return lastChapter == null ? doc.getCurrentSection() : lastChapter;
    }
    
    /**
     * @return 获取 doc属性值
     */
    public WordDocument getDoc() {
        return doc;
    }
    
    /**
     * 获得样式文档对象
     *
     * @return XWPFStyles
     */
    public XWPFStyles getStylesDocument() {
        return stylesDocument;
    }
    
    /**
     * 获得编号
     *
     * @param numPr numPr
     * @return XWPFNum
     */
    protected XWPFNum getXWPFNum(CTNumPr numPr) {
        CTDecimalNumber numID = numPr.getNumId();
        if (numID == null) {
            // numID can be null, ignore the numbering
            // see https://code.google.com/p/xdocreport/issues/detail?id=239
            return null;
        }
        XWPFNum num = document.getNumbering().getNum(numID.getVal());
        return num;
    }
    
    /**
     * 获得抽象 的编号
     *
     * @param num num
     * @return XWPFAbstractNum
     */
    protected XWPFAbstractNum getXWPFAbstractNum(XWPFNum num) {
        CTDecimalNumber abstractNumID = num.getCTNum().getAbstractNumId();
        XWPFAbstractNum abstractNum = document.getNumbering().getAbstractNum(abstractNumID.getVal());
        return abstractNum;
    }
    
    /**
     * 获得编号序列
     *
     * @param paragraph 当前段落
     * @return 编号对象
     */
    protected CTNumPr getNumPr(XWPFParagraph paragraph) {
        CTNumPr originalNumPr = null;
        // 先用styleid来查找样式，根据样式来找number
        XWPFStyle xwpfStyle = stylesDocument.getStyle(paragraph.getStyleID());
        if (xwpfStyle != null && xwpfStyle.getCTStyle() != null && xwpfStyle.getCTStyle().getPPr() != null) {
            originalNumPr = xwpfStyle.getCTStyle().getPPr().getNumPr();
        }
        
        // 如果用styleid没有找到编号，根据段落自己的编号定义来找。此设计的主要目的是：
        // 文档中存在看起来编号 是1、2、3、4连续的样式，但如果先找段落自己的编号定义时，
        // 会与样式定义的不一致,这样生成的编号与word文档中的编号就会不一致 。这样处理可提高对文档的容错性。
        if (originalNumPr == null) {
            if (paragraph.getCTP() != null && paragraph.getCTP().getPPr() != null) {
                originalNumPr = paragraph.getCTP().getPPr().getNumPr();
            }
        }
        return originalNumPr;
    }
    
    /**
     * 获得NumPr
     *
     * @param numPr numPr
     * @return CTNumPr
     */
    protected CTNumPr getNumPr(CTNumPr numPr) {
        if (numPr != null) {
            XWPFNum num = getXWPFNum(numPr);
            if (num != null) {
                // get the abstractNum by usisng abstractNumId
                /**
                 * <w:abstractNum w:abstractNumId="1"> <w:nsid w:val="3CBA6E67" /> <w:multiLevelType
                 * w:val="hybridMultilevel" /> <w:tmpl w:val="7416D4FA" /> - <w:lvl w:ilvl="0" w:tplc="040C0001">
                 * <w:start w:val="1" /> <w:numFmt w:val="bullet" /> <w:lvlText w:val="o" /> <w:lvlJc w:val="left" /> -
                 * <w:pPr> <w:ind w:left="720" w:hanging="360" /> </w:pPr> - <w:rPr> <w:rFonts w:ascii="Symbol"
                 * w:hAnsi="Symbol" w:hint="default" /> </w:rPr> </w:lvl>
                 */
                XWPFAbstractNum abstractNum = getXWPFAbstractNum(num);
                
                CTString numStyleLink = abstractNum.getAbstractNum().getNumStyleLink();
                String styleId = numStyleLink != null ? numStyleLink.getVal() : null;
                if (styleId != null) {
                    
                    // has w:numStyleLink which reference other style
                    /*
                     * <w:abstractNum w:abstractNumId="0"> <w:nsid w:val="03916EF0"/> <w:multiLevelType
                     * w:val="multilevel"/> <w:tmpl w:val="0409001D"/> <w:numStyleLink w:val="EricsListStyle"/>
                     * </w:abstractNum>
                     */
                    CTStyle style = stylesDocument.getStyle(styleId).getCTStyle();
                    CTPPr ppr = style.getPPr();
                    if (ppr == null) {
                        return null;
                    }
                    return getNumPr(ppr.getNumPr());
                }
            }
        }
        return numPr;
    }
    
    /**
     * Returns the {@link XWPFFooter} of the given footer reference.
     * 
     * @param footerRef the footer reference.
     * @return XWPFFooter
     * @throws IOException IOException
     * @throws XmlException XmlException
     */
    private XWPFFooter getXWPFFooter(CTHdrFtrRef footerRef) throws XmlException, IOException {
        PackagePart hdrPart = document.getPartById(footerRef.getId());
        List<XWPFFooter> footers = document.getFooterList();
        for (XWPFFooter footer : footers) {
            if (footer.getPackagePart().equals(hdrPart)) {
                // footer is aleady loaded, return it.
                return footer;
            }
        }
        // should never come, but load the footer if needed.
        FtrDocument hdrDoc = FtrDocument.Factory.parse(hdrPart.getInputStream());
        CTHdrFtr hdrFtr = hdrDoc.getFtr();
        XWPFFooter ftr = new XWPFFooter(document, hdrFtr);
        return ftr;
    }
    
    /**
     * 解析页脚引用元素
     *
     * @param footerRef footerRef
     * @param sectPr 分节
     * @throws IOException IOException
     * @throws XmlException XmlException
     */
    protected void visitFooterRef(CTHdrFtrRef footerRef, CTSectPr sectPr) throws XmlException, IOException {
        this.currentFooter = getXWPFFooter(footerRef);
        visitFooter(currentFooter, footerRef, sectPr);
        this.currentFooter = null;
    }
    
    /**
     * 解析页眉引用元素
     *
     * @param headerRef footerRef
     * @param sectPr 分节
     * @throws IOException IOException
     * @throws XmlException XmlException
     */
    protected void visitHeaderRef(CTHdrFtrRef headerRef, CTSectPr sectPr) throws XmlException, IOException {
        this.currentHeader = getXWPFHeader(headerRef);
        visitHeader(currentHeader, headerRef, sectPr);
        this.currentHeader = null;
    }
    
    /**
     * Returns the {@link XWPFHeader} of the given header reference.
     * 
     * @param headerRef the header reference.
     * @return XWPFHeader
     * @throws IOException IOException
     * @throws XmlException XmlException
     */
    protected XWPFHeader getXWPFHeader(CTHdrFtrRef headerRef) throws XmlException, IOException {
        PackagePart hdrPart = document.getPartById(headerRef.getId());
        List<XWPFHeader> headers = document.getHeaderList();
        for (XWPFHeader header : headers) {
            if (header.getPackagePart().equals(hdrPart)) {
                // header is aleady loaded, return it.
                return header;
            }
        }
        // should never come, but load the header if needed.
        HdrDocument hdrDoc = HdrDocument.Factory.parse(hdrPart.getInputStream());
        CTHdrFtr hdrFtr = hdrDoc.getHdr();
        XWPFHeader hdr = new XWPFHeader(document, hdrFtr);
        return hdr;
    }
    
    /**
     * Returns true if word/document.xml is parsing and false otherwise.
     * 
     * @return true if word/document.xml is parsing and false otherwise.
     */
    protected boolean isWordDocumentPartParsing() {
        return currentHeader == null && currentFooter == null;
    }
    
    /**
     * 访问页眉
     *
     * @param header header
     * @param headerRef headerRef
     * @param sectPr sectPr
     */
    protected void visitHeader(XWPFHeader header, CTHdrFtrRef headerRef, CTSectPr sectPr) {
        // 暂不处理
    }
    
    /**
     * 访问页脚
     *
     * @param footer header
     * @param footerRef headerRef
     * @param sectPr sectPr
     */
    protected void visitFooter(XWPFFooter footer, CTHdrFtrRef footerRef, CTSectPr sectPr) {
        // 暂不处理
    }
    
    /**
     * 将某个包的内容写到磁盘上
     *
     * @param packagePart 待写入的包。
     * @param uploadKey uploadKey
     * @param uploadId uploadId
     * @param fileName 文件名
     * @return 返回写完的文件的位置
     */
    protected FileLocation writeDocumentPartToDisk(PackagePart packagePart, String uploadKey, String uploadId,
        String fileName) {
        InputStream in = null;
        try {
            in = packagePart.getInputStream();
            return LoaderUtil.upLoad(in, uploadKey, uploadId, fileName);
        } catch (IOException e) {
            LOGGER.error("解析word中的嵌入对象时发生异常", e);
            throw new WordParseException("解析word中的嵌入对象时发生异常", e);
        } finally {
            IOUtils.closeQuietly(in);
        }
    }
    
    /**
     * 获得word part去掉路径中的名称
     *
     * @param part 包
     * @return 名字
     */
    protected String getPartName(PackagePart part) {
        String name = part.getPartName().getName();
        return name.substring(name.lastIndexOf('/') + 1);
    }
    
}
