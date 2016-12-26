/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.write;

import static com.comtop.cap.document.word.util.FolderUtil.urlToPath;
import static com.comtop.cap.document.word.util.MeasurementUnits.cmToTwip;
import static com.comtop.cap.document.word.write.DocxConstants.AUTO;
import static com.comtop.cap.document.word.write.DocxConstants.DEFAULT_TABLE_HEIGHT;
import static com.comtop.cap.document.word.write.DocxConstants.DEFAULT_TABLE_WIDTH;
import static com.comtop.cap.document.word.write.DocxConstants.LANG_EN_US;
import static com.comtop.cap.document.word.write.DocxConstants.LANG_ZH_CN;
import static com.comtop.cap.document.word.write.DocxConstants.STYLE_BODY_TEXT;
import static com.comtop.cap.document.word.write.DocxConstants.STYLE_COVER;
import static com.comtop.cap.document.word.write.DocxConstants.STYLE_COVER_RIGHT_4;
import static com.comtop.cap.document.word.write.DocxConstants.STYLE_COVER_SIMHEI_1;
import static com.comtop.cap.document.word.write.DocxConstants.STYLE_COVER_SIMHEI_2;
import static com.comtop.cap.document.word.write.DocxConstants.STYLE_COVER_SIMHEI_3;
import static com.comtop.cap.document.word.write.DocxConstants.STYLE_FOOTER;
import static com.comtop.cap.document.word.write.DocxConstants.STYLE_GRAPHIC_CENTER;
import static com.comtop.cap.document.word.write.DocxConstants.STYLE_HEADER;
import static com.comtop.cap.document.word.write.DocxConstants.STYLE_HYPERLINK;
import static com.comtop.cap.document.word.write.DocxConstants.STYLE_TABLE_CONTENT_LEFT;
import static com.comtop.cap.document.word.write.DocxConstants.STYLE_TABLE_TITLE;
import static org.apache.commons.lang.RandomStringUtils.random;
import static org.apache.commons.lang.RandomStringUtils.randomNumeric;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.lang.reflect.Field;
import java.math.BigInteger;
import java.net.URL;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.RandomStringUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.poi.POIXMLDocument;
import org.apache.poi.POIXMLProperties.CoreProperties;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.openxml4j.opc.PackagePartName;
import org.apache.poi.openxml4j.opc.PackageRelationship;
import org.apache.poi.openxml4j.opc.PackagingURIHelper;
import org.apache.poi.openxml4j.opc.TargetMode;
import org.apache.poi.xwpf.model.XWPFHeaderFooterPolicy;
import org.apache.poi.xwpf.usermodel.Document;
import org.apache.poi.xwpf.usermodel.IBody;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFFooter;
import org.apache.poi.xwpf.usermodel.XWPFHeader;
import org.apache.poi.xwpf.usermodel.XWPFHeaderFooter;
import org.apache.poi.xwpf.usermodel.XWPFNumbering;
import org.apache.poi.xwpf.usermodel.XWPFParagraph;
import org.apache.poi.xwpf.usermodel.XWPFRelation;
import org.apache.poi.xwpf.usermodel.XWPFRun;
import org.apache.poi.xwpf.usermodel.XWPFStyle;
import org.apache.poi.xwpf.usermodel.XWPFStyles;
import org.apache.poi.xwpf.usermodel.XWPFTable;
import org.apache.poi.xwpf.usermodel.XWPFTableCell;
import org.apache.poi.xwpf.usermodel.XWPFTableRow;
import org.apache.xmlbeans.XmlException;
import org.apache.xmlbeans.XmlObject;
import org.apache.xmlbeans.impl.xb.xmlschema.SpaceAttribute;
import org.openxmlformats.schemas.drawingml.x2006.main.CTGraphicalObject;
import org.openxmlformats.schemas.drawingml.x2006.main.CTNonVisualDrawingProps;
import org.openxmlformats.schemas.drawingml.x2006.main.CTPoint2D;
import org.openxmlformats.schemas.drawingml.x2006.main.CTPositiveSize2D;
import org.openxmlformats.schemas.drawingml.x2006.wordprocessingDrawing.CTAnchor;
import org.openxmlformats.schemas.drawingml.x2006.wordprocessingDrawing.CTEffectExtent;
import org.openxmlformats.schemas.drawingml.x2006.wordprocessingDrawing.CTInline;
import org.openxmlformats.schemas.drawingml.x2006.wordprocessingDrawing.CTPosH;
import org.openxmlformats.schemas.drawingml.x2006.wordprocessingDrawing.CTPosV;
import org.openxmlformats.schemas.drawingml.x2006.wordprocessingDrawing.STRelFromH;
import org.openxmlformats.schemas.drawingml.x2006.wordprocessingDrawing.STRelFromV;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTAbstractNum;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTBody;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTBorder;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTDecimalNumber;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTFonts;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTHMerge;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTHdrFtr;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTHdrFtrRef;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTHpsMeasure;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTHyperlink;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTJc;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTLanguage;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTLongHexNumber;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTNum;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTNumPr;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTNumbering;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTObject;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTOnOff;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTP;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTPPr;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTPageBorders;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTPageMar;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTPageNumber;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTPageSz;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTParaRPr;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTR;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTRPr;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTRow;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTSectPr;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTSectType;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTShd;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTString;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTStyle;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTTbl;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTTblBorders;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTTblGrid;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTTblGridCol;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTTblPr;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTTblWidth;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTTc;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTTcBorders;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTTcPr;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTText;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTTrPr;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTVMerge;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTVerticalAlignRun;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTVerticalJc;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.STFldCharType;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.STHdrFtr;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.STHint;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.STJc;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.STMerge;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.STOnOff;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.STShd;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.STTblWidth;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.STUnderline;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.document.word.docmodel.DocxProperties;
import com.comtop.cap.document.word.docmodel.SectionProperties;
import com.comtop.cap.document.word.docmodel.SectionProperties.Margin;
import com.comtop.cap.document.word.docmodel.SectionProperties.Orientation;
import com.comtop.cap.document.word.docmodel.SectionProperties.PageSize;
import com.comtop.cap.document.word.docmodel.SectionProperties.Type;
import com.comtop.cap.document.word.docmodel.data.EmbedObject;
import com.comtop.cap.document.word.docmodel.data.Graphic;
import com.comtop.cap.document.word.docmodel.datatype.GraphicType;
import com.comtop.cap.document.word.docmodel.style.Border;
import com.comtop.cap.document.word.docmodel.style.BorderLocation;
import com.comtop.cap.document.word.docmodel.style.CaptionType;
import com.comtop.cap.document.word.docmodel.style.Rectify;
import com.comtop.cap.document.word.docmodel.style.Style;
import com.comtop.cap.document.word.docmodel.style.Style.BulletStyle;
import com.comtop.cap.document.word.docmodel.style.Style.Font;
import com.comtop.cap.document.word.docmodel.style.Style.HAlign;
import com.comtop.cap.document.word.docmodel.style.Style.ItemCode;
import com.comtop.cap.document.word.docmodel.style.Style.ItemType;
import com.comtop.cap.document.word.docmodel.style.Style.NumberStyle;
import com.comtop.cap.document.word.docmodel.style.Style.TextStyle;
import com.comtop.cap.document.word.docmodel.style.Style.VAlign;
import com.comtop.cap.document.word.util.ColorHelper;

/**
 * MS Office Word 2007以上版本帮助类
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年10月14日 lizhongwen
 */
public class DocxHelper {
    
    /** 文档帮助类实例 */
    private final static DocxHelper helper = new DocxHelper();
    
    /** 项目序号ID_MAP */
    private final static Map<String, BigInteger> NUMBERID_MAP = new HashMap<String, BigInteger>();
    
    /** 项目序号ID_MAP */
    private final static Map<String, AtomicInteger> FILEID_MAP = new HashMap<String, AtomicInteger>();
    
    /** 十六进制字符组 */
    private final static char[] HEX_CHARS = new char[] { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B',
        'C', 'D', 'E', 'F' };
    
    /** 日志 */
    private final static Logger logger = LoggerFactory.getLogger(DocxHelper.class);
    
    /**
     * 构造函数
     */
    private DocxHelper() {
    }
    
    /**
     * 获取文档帮助类实例
     * 
     * @return 文档帮助类
     */
    public static DocxHelper getInstance() {
        return helper;
    }
    
    // #region_start Docx 基本操作--------------------------------------------------
    
    /**
     * 创建新文档
     * 
     * @return XWPFDocument对象
     */
    public XWPFDocument createDocument() {
        XWPFDocument docx = new ExtXWPFDocument();
        NUMBERID_MAP.clear();
        FILEID_MAP.clear();
        return docx;
    }
    
    /**
     * 打开Word 文档
     * 
     * @param path 文档所在路径
     * @return XWPFDocument对象
     * @throws IOException 当所在路径无法找到该文档，或者文档格式错误则抛出该异常
     */
    public XWPFDocument openDocument(final String path) throws IOException {
        XWPFDocument docx = new XWPFDocument(POIXMLDocument.openPackage(path));
        return docx;
    }
    
    /**
     * 
     * 保存Word文档
     * 
     * @param docx XWPFDocument文档对象
     * @param path 文档保存路径
     * @throws IOException 如果保存目录不存在，则抛出该异常
     */
    public void saveDocument(final XWPFDocument docx, final String path) throws IOException {
        File file = new File(path);
        if (!file.getParentFile().exists()) {
            file.getParentFile().mkdirs();
        }
        OutputStream fos = new FileOutputStream(file);
        docx.write(fos);
        fos.close();
    }
    
    /** 样式前缀 */
    private static final String STYLE_SET_PREFIX = "styles-";
    
    /**
     * 加载样式集
     * 
     * @param docx XWPFDocument文档
     * @param styleSetName 样式集名称
     * @return 返回文档帮助类对象，可用于方法链调用
     * @throws XmlException XML格式错误
     * @throws IOException IO异常
     */
    public DocxHelper loadStyles(final XWPFDocument docx, final String styleSetName) throws XmlException, IOException {
        // TODO 后期可以增加灵活性处理
        String suffix = styleSetName;
        if (StringUtils.isNotBlank(styleSetName)) {
            
            ClassLoader loader = Thread.currentThread().getContextClassLoader();
            InputStream input = null;
            String prefix = STYLE_SET_PREFIX + suffix;
            try {
                input = loader.getResourceAsStream(prefix + "/numbering.xml");
                CTNumbering ctnumbering = CTNumbering.Factory.parse(input);
                XWPFNumbering numbering = docx.createNumbering();
                numbering.setNumbering(ctnumbering);
            } finally {
                IOUtils.closeQuietly(input);
            }
            XWPFStyles styles = docx.createStyles();
            InputStream in = null;
            try {
                in = loader.getResourceAsStream(prefix + "/normal.xml");
                CTStyle normal = CTStyle.Factory.parse(in);
                styles.addStyle(new XWPFStyle(normal, styles));
            } finally {
                IOUtils.closeQuietly(in);
            }
            InputStream inputStream = null;
            try {
                inputStream = loader.getResourceAsStream(prefix + "/heading.xml");
                CTStyle heading = CTStyle.Factory.parse(inputStream);
                styles.addStyle(new XWPFStyle(heading, styles));
            } finally {
                IOUtils.closeQuietly(inputStream);
            }
            InputStream menuInput = null;
            try {
                menuInput = loader.getResourceAsStream(prefix + "/catalogue.xml");
                CTStyle heading = CTStyle.Factory.parse(menuInput);
                styles.addStyle(new XWPFStyle(heading, styles));
            } finally {
                IOUtils.closeQuietly(menuInput);
            }
        }
        return this;
    }
    
    /**
     * 加载样式
     * 
     * @param docx XWPFDocument文档
     * @param stylePath 样式文件路径
     * @return 返回文档帮助类对象，可用于方法链调用
     * @throws XmlException XML格式错误
     * @throws IOException IO异常
     */
    public DocxHelper loadStyle(final XWPFDocument docx, final String stylePath) throws XmlException, IOException {
        InputStream input = null;
        try {
            input = new FileInputStream(stylePath);
            CTNumbering ctnumbering = CTNumbering.Factory.parse(input);
            XWPFNumbering numbering = docx.createNumbering();
            numbering.setNumbering(ctnumbering);
        } finally {
            IOUtils.closeQuietly(input);
        }
        return this;
    }
    
    /**
     * 
     * 设置文档属性
     * 
     * @param docx XWPFDocument 文档对象
     * @param properties 文档属性对象
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper setDocumentProperties(final XWPFDocument docx, final DocxProperties properties) {
        if (properties == null) {
            return this;
        }
        CoreProperties coreProperties = docx.getProperties().getCoreProperties();
        if (StringUtils.isNotBlank(properties.getCreator())) {
            coreProperties.setCreator(properties.getCreator());
        }
        if (StringUtils.isNotBlank(properties.getTitle())) {
            coreProperties.setTitle(properties.getTitle());
        }
        if (StringUtils.isNotBlank(properties.getSubject())) {
            coreProperties.setSubjectProperty(properties.getSubject());
        }
        if (StringUtils.isNotBlank(properties.getKeywords())) {
            coreProperties.setKeywords(properties.getKeywords());
        }
        if (StringUtils.isNotBlank(properties.getDescription())) {
            coreProperties.setDescription(properties.getDescription());
        }
        if (StringUtils.isNotBlank(properties.getCategory())) {
            coreProperties.setCategory(properties.getCategory());
        }
        if (StringUtils.isNotBlank(properties.getContentStatus())) {
            coreProperties.setContentStatus(properties.getContentStatus());
        }
        if (StringUtils.isNotBlank(properties.getCompany())) {
            docx.getProperties().getExtendedProperties().getUnderlyingProperties().setCompany(properties.getCompany());
        }
        return this;
    }
    
    /**
     * 设置整个文档的章节属性
     *
     * @param docx XWPFDocument文档对象
     * @param properties 章节属性
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper setDocumentSectionProperties(final XWPFDocument docx, final SectionProperties properties) {
        if (properties.getMargin() != null) {
            this.setDocumentMargin(docx, properties.getMargin());
        }
        if (properties.getSize() != null || properties.getOrient() != null) {
            this.setDocumentSize(docx, properties.getSize(), properties.getOrient());
        }
        if (properties.getType() != null) {
            this.setDocumentType(docx, properties.getType());
        }
        if (properties.getBorders() != null) {
            this.setDocumentBorders(docx, properties.getBorders());
        }
        return this;
    }
    
    /**
     * 设置页边距
     * 
     * @param docx XWPFDocument 文档对象
     * @param margin 页边距对象
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper setDocumentMargin(final XWPFDocument docx, final Margin margin) {
        CTSectPr sectPr = getOrCreateSectPr(docx);
        setSectionMargin(sectPr, margin);
        return this;
    }
    
    /**
     * 设置章节页边距
     *
     * @param sectPr 章节属性设置对象
     * @param margin 页边距对象
     */
    private void setSectionMargin(CTSectPr sectPr, final Margin margin) {
        CTPageMar ctpagemar = getOrCreatePageMar(sectPr);
        if (margin.getLeftAsTwip() != null) {
            ctpagemar.setLeft(margin.getLeftAsTwip());
        }
        if (margin.getTopAsTwip() != null) {
            ctpagemar.setTop(margin.getTopAsTwip());
        }
        if (margin.getRightAsTwip() != null) {
            ctpagemar.setRight(margin.getRightAsTwip());
        }
        if (margin.getBottomAsTwip() != null) {
            ctpagemar.setBottom(margin.getBottomAsTwip());
        }
        if (margin.getGutterAsTwip() != null) {
            ctpagemar.setGutter(margin.getGutterAsTwip());
        }
        if (margin.getFooterAsTwip() != null) {
            ctpagemar.setFooter(margin.getFooterAsTwip());
        }
        if (margin.getHeaderAsTwip() != null) {
            ctpagemar.setHeader(margin.getHeaderAsTwip());
        }
    }
    
    /**
     * 设置纸张大小 以及页面方向
     * 
     * @param docx XWPFDocument 文档对象
     * @param orient 页面方向
     * @param size 纸张大小
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper setDocumentSize(final XWPFDocument docx, final PageSize size, final Orientation orient) {
        CTSectPr sectPr = getOrCreateSectPr(docx);
        setSectionSize(sectPr, size, orient);
        return this;
    }
    
    /**
     * 设置文档章节类型
     *
     * @param docx XWPFDocument 文档对象
     * @param type 章节类型
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper setDocumentType(final XWPFDocument docx, final Type type) {
        CTSectPr sectPr = getOrCreateSectPr(docx);
        setSectionType(sectPr, type);
        return this;
    }
    
    /**
     * 设置文档页面边线
     *
     * @param docx XWPFDocument 文档对象
     * @param borders 章节边线,注意：在设置章节边线时，一定要指定边线的位置
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper setDocumentBorders(final XWPFDocument docx, final Border... borders) {
        CTSectPr sectPr = getOrCreateSectPr(docx);
        setSectionBorders(sectPr, borders);
        return this;
    }
    
    /**
     * 重置章节的页码
     *
     * @param docx XWPFDocument 文档对象
     * @param start 重置后页码的起始值
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper resetSectionPageNum(final XWPFDocument docx, final int start) {
        XWPFParagraph paragraph = docx.createParagraph();
        resetSectionPageNum(paragraph, start);
        return this;
    }
    
    /**
     * 重置章节的页码
     *
     * @param paragraph XWPFDocument 文档段落对象
     * @param start 重置后页码的起始值
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper resetSectionPageNum(final XWPFParagraph paragraph, final int start) {
        CTP ctp = paragraph.getCTP();
        CTSectPr sectPr;
        XWPFDocument docx = paragraph.getDocument();
        if (ctp.isSetPPr() && ctp.getPPr().isSetSectPr()) {
            sectPr = ctp.getPPr().getSectPr();
        } else {
            CTSectPr docSectPr = docx.getDocument().getBody().getSectPr();
            sectPr = this.getOrCreateSectPr(paragraph);
            if (docSectPr != null) {
                sectPr.set(docSectPr);
            }
        }
        this.removeSectionHeader(sectPr);
        createSectionFooterByDefault(docx, sectPr);
        CTPageNumber pgNum = sectPr.isSetPgNumType() ? sectPr.getPgNumType() : sectPr.addNewPgNumType();
        pgNum.setStart(BigInteger.valueOf(start));
        return this;
    }
    
    /**
     * 通过默认页脚创建章节页脚
     * 
     * @param docx XWPFDocument 文档对象
     * @param sectPr 章节属性设置
     */
    private void createSectionFooterByDefault(final XWPFDocument docx, final CTSectPr sectPr) {
        try {
            XWPFHeaderFooterPolicy policy = new XWPFHeaderFooterPolicy(docx, sectPr);
            XWPFFooter footer = policy.getDefaultFooter();
            if (footer != null) {
                Field headerFooterField = XWPFHeaderFooter.class.getDeclaredField("headerFooter");
                headerFooterField.setAccessible(true);
                CTHdrFtr hdrFtr = (CTHdrFtr) headerFooterField.get(footer);
                List<CTP> ctps = hdrFtr.getPList();
                XWPFParagraph[] paragraphs = new XWPFParagraph[ctps.size()];
                for (int i = 0; i < ctps.size(); i++) {
                    paragraphs[i] = new XWPFParagraph(ctps.get(i), docx);
                }
                XWPFFooter newFooter = policy.createFooter(STHdrFtr.DEFAULT, paragraphs);
                String rsId = docx.getRelationId(newFooter);
                removeSectionFooter(docx.getDocument().getBody().getSectPr(), rsId);
                sectPr.getFooterReferenceArray(0).setId(rsId);
            }
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
        }
    }
    
    /**
     * 移除章节中的页眉和页脚
     *
     * @param docx XWPFDocument 文档对象
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper removeSectionHeaderFooter(final XWPFDocument docx) {
        XWPFParagraph paragraph = docx.createParagraph();
        removeSectionHeader(paragraph);
        removeSectionFooter(paragraph);
        return this;
    }
    
    /**
     * 移除章节中的页眉和页脚
     *
     * @param paragraph XWPFDocument 文档段落对象
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper removeSectionHeaderFooter(final XWPFParagraph paragraph) {
        removeSectionHeader(paragraph);
        removeSectionFooter(paragraph);
        return this;
    }
    
    /**
     * 移除章节中的页眉
     *
     * @param docx XWPFDocument 文档对象
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper removeSectionHeader(final XWPFDocument docx) {
        XWPFParagraph paragraph = docx.createParagraph();
        removeSectionHeader(paragraph);
        return this;
    }
    
    /**
     * 移除章节中的页眉
     *
     * @param paragraph XWPFDocument 文档段落对象
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper removeSectionHeader(final XWPFParagraph paragraph) {
        CTP ctp = paragraph.getCTP();
        CTSectPr sectPr;
        if (ctp.isSetPPr() && ctp.getPPr().isSetSectPr()) {
            sectPr = ctp.getPPr().getSectPr();
        } else {
            XWPFDocument docx = paragraph.getDocument();
            CTSectPr docSectPr = docx.getDocument().getBody().getSectPr();
            sectPr = this.getOrCreateSectPr(paragraph);
            if (docSectPr != null) {
                sectPr.set(docSectPr);
            }
        }
        removeSectionHeader(sectPr);
        return this;
    }
    
    /**
     * 移除章节中的页眉
     *
     * @param sectPr 章节属性设置
     */
    private void removeSectionHeader(final CTSectPr sectPr) {
        List<CTHdrFtrRef> hdrRefs = sectPr.getHeaderReferenceList();
        if (hdrRefs != null && hdrRefs.size() > 0) {
            for (int i = hdrRefs.size() - 1; i >= 0; i--) {
                sectPr.removeHeaderReference(i);
            }
        }
    }
    
    /**
     * 移除指定ID章节中的页眉
     *
     * @param sectPr 章节属性设置
     * @param rsId 关系ID
     */
    public void removeSectionHeader(final CTSectPr sectPr, final String rsId) {
        List<CTHdrFtrRef> hdrRefs = sectPr.getHeaderReferenceList();
        if (hdrRefs != null && hdrRefs.size() > 0) {
            for (int i = hdrRefs.size() - 1; i >= 0; i--) {
                if (rsId.equals(hdrRefs.get(i).getId())) {
                    sectPr.removeHeaderReference(i);
                    break;
                }
            }
        }
    }
    
    /**
     * 移除章节中的页脚
     *
     * @param docx XWPFDocument 文档对象
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper removeSectionFooter(final XWPFDocument docx) {
        XWPFParagraph paragraph = docx.createParagraph();
        removeSectionFooter(paragraph);
        return this;
    }
    
    /**
     * 移除章节中的页脚
     *
     * @param paragraph XWPFDocument 文档段落对象
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper removeSectionFooter(final XWPFParagraph paragraph) {
        CTP ctp = paragraph.getCTP();
        CTSectPr sectPr;
        if (ctp.isSetPPr() && ctp.getPPr().isSetSectPr()) {
            sectPr = ctp.getPPr().getSectPr();
        } else {
            XWPFDocument docx = paragraph.getDocument();
            CTSectPr docSectPr = docx.getDocument().getBody().getSectPr();
            sectPr = this.getOrCreateSectPr(paragraph);
            if (docSectPr != null) {
                sectPr.set(docSectPr);
            }
        }
        removeSectionFooter(sectPr);
        return this;
    }
    
    /**
     * 移除章节中的页脚
     *
     * @param sectPr 章节属性设置
     */
    private void removeSectionFooter(final CTSectPr sectPr) {
        List<CTHdrFtrRef> hdrRefs = sectPr.getFooterReferenceList();
        if (hdrRefs != null && hdrRefs.size() > 0) {
            for (int i = hdrRefs.size() - 1; i >= 0; i--) {
                sectPr.removeFooterReference(i);
            }
        }
    }
    
    /**
     * 移除章节中指定ID的页脚
     *
     * @param sectPr 章节属性设置
     * @param rsId 关系ID
     */
    public void removeSectionFooter(final CTSectPr sectPr, final String rsId) {
        List<CTHdrFtrRef> hdrRefs = sectPr.getFooterReferenceList();
        if (hdrRefs != null && hdrRefs.size() > 0) {
            for (int i = hdrRefs.size() - 1; i >= 0; i--) {
                if (rsId.equals(hdrRefs.get(i).getId())) {
                    sectPr.removeFooterReference(i);
                    break;
                }
            }
        }
    }
    
    /**
     * 设置纸张大小 以及页面方向
     *
     * @param sectPr 章节属性对象
     * @param size 页面方向
     * @param orient 纸张大小
     */
    private void setSectionSize(final CTSectPr sectPr, final PageSize size, final Orientation orient) {
        CTPageSz pgsz = getOrCreateCTPageSz(sectPr);
        if (size.getHeightAsTwip() != null) {
            pgsz.setH(size.getHeightAsTwip());
        }
        if (size.getWidthAsTwip() != null) {
            pgsz.setW(size.getWidthAsTwip());
        }
        if (orient != null) {
            pgsz.setOrient(orient.getSTOrient());
        }
    }
    
    // TODO 其他页面的设置待补充（参考Word中的页面布局、设计菜单）
    
    /**
     * 页面属性对象
     *
     * @param docx XWPFDocument 文档对象
     * @return 页面属性对象
     */
    private CTSectPr getOrCreateSectPr(final XWPFDocument docx) {
        CTBody body = docx.getDocument().getBody();
        CTSectPr sectPr = body.isSetSectPr() ? body.getSectPr() : body.addNewSectPr();
        return sectPr;
    }
    
    /**
     * 获取或者创建页边距对象CTPageMar
     *
     * @param sectPr 章节属性设置对象
     * @return 页边距对象CTPageMar
     */
    private CTPageMar getOrCreatePageMar(final CTSectPr sectPr) {
        return sectPr.isSetPgMar() ? sectPr.getPgMar() : sectPr.addNewPgMar();
    }
    
    /**
     * 获取或者创建页面大小对象CTPageSz
     *
     * @param sectPr 章节属性设置对象
     * @return 页面大小对象CTPageSz
     */
    private CTPageSz getOrCreateCTPageSz(final CTSectPr sectPr) {
        return sectPr.isSetPgSz() ? sectPr.getPgSz() : sectPr.addNewPgSz();
    }
    
    // #region_end Docx 基本操作--------------------------------------------------
    
    // #region_start Docx添加或者删除内容--------------------------------------------------
    
    /**
     * 向文档中添加段落
     *
     * @param docx XWPFDocument文档对象
     * @return 段落对象
     */
    public XWPFParagraph createParagraph(final XWPFDocument docx) {
        return docx.createParagraph();
    }
    
    /**
     * 向文档中添加正文段落
     *
     * @param docx XWPFDocument文档对象
     * @return 段落对象
     */
    public XWPFParagraph createBodyParagraph(final XWPFDocument docx) {
        XWPFParagraph paragraph = docx.createParagraph();
        paragraph.setStyle(STYLE_BODY_TEXT);
        return paragraph;
    }
    
    /**
     * 向文档中添加相同格式的段落
     *
     * @param paragraph 需要找到样式的对象
     * @return 段落对象
     */
    public XWPFParagraph createSameStyleParagraph(final XWPFParagraph paragraph) {
        String styleId = paragraph.getStyleID();
        IBody body = paragraph.getBody();
        XWPFParagraph para = null;
        if (body instanceof XWPFDocument) {
            XWPFDocument docx = (XWPFDocument) body;
            para = docx.createParagraph();
            para.setStyle(styleId);
        } else if (body instanceof XWPFTableCell) {
            XWPFTableCell cell = (XWPFTableCell) body;
            para = cell.addParagraph();
            para.setStyle(styleId);
        }
        return para;
    }
    
    /**
     * 向文档中添加标题,注意在向文档中添加标题时，需要确保已经将样式集全部加载到了文档中，并且指定的级别在样式集中均已存在。
     *
     * @param docx XWPFDocument文档对象
     * @param title 标题内容
     * @param level 标题级别，默认从1开始
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper createParagraphTitle(final XWPFDocument docx, final String title, final int level) {
        XWPFParagraph paragraph = this.createParagraph(docx);
        XWPFRun run = paragraph.createRun();
        run.setText(title);
        paragraph.setStyle(String.valueOf(level));
        return this;
    }
    
    /**
     * 在文档中创建空段落，相当于回车的作用
     *
     * @param docx XWPFDocument文档对象
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper createEmptyParagraph(final XWPFDocument docx) {
        this.createParagraph(docx);
        return this;
    }
    
    /**
     * 在文档中创建带样式的空段落，相当于回车的作用
     *
     * @param docx XWPFDocument文档对象
     * @param styleId 样式ID
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper createEmptyParagraph(final XWPFDocument docx, final String styleId) {
        this.createParagraph(docx).setStyle(styleId);
        return this;
    }
    
    /**
     * 向文档中文本段落，多个段落使用\r\n进行分割。
     *
     * @param docx XWPFDocument文档对象
     * @param text 文本段落
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper createTextParagraph(final XWPFDocument docx, final String text) {
        XWPFParagraph paragraph;
        String[] pstrs = text.split("\r\n");
        for (String pstr : pstrs) {
            paragraph = this.createBodyParagraph(docx);
            this.appendTextInParagraph(paragraph, pstr);
        }
        return this;
    }
    
    /**
     * 向文档中添加题注
     * 
     * @param docx 文档
     * @param type 题注类型
     * @param text 题注内容
     * @return 返回文档帮助类对象，可用于方法链调用
     * @throws IOException IO异常
     * @throws XmlException XML异常
     */
    public DocxHelper createCaption(final XWPFDocument docx, final CaptionType type, final String text)
        throws XmlException, IOException {
        if (text == null) {
            return this;
        }
        XWPFParagraph paragraph = this.createParagraph(docx);
        CTP ctp = null;
        ClassLoader loader = Thread.currentThread().getContextClassLoader();
        InputStream input = null;
        try {
            input = loader.getResourceAsStream("fragments/caption.xml");
            String xml = IOUtils.toString(input);
            xml = xml.replace("${typeName}", type.getName()).replace("${content}", text);
            ctp = CTP.Factory.parse(xml);
            paragraph.getCTP().set(ctp);
        } finally {
            IOUtils.closeQuietly(input);
        }
        return this;
    }
    
    /**
     * 向文档中添加带有项目编号/符号的段落，注意：需要确保文档已加载了全部样式
     *
     * @param docx XWPFDocument文档对象
     * @param code 带有项目编号、符号的段落
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper createParagraphWithItemCode(final XWPFDocument docx, final ItemCode code) {
        return this.createParagraphWithItemCode(docx, code, false);
    }
    
    /**
     * 向文档中添加带有项目编号/符号的段落，注意：需要确保文档已加载了全部样式
     *
     * @param docx XWPFDocument文档对象
     * @param code 带有项目编号、符号的段落
     * @param isNew 是否重新开始的序号列，仅当类型为项目编号时有效
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper createParagraphWithItemCode(final XWPFDocument docx, final ItemCode code, final boolean isNew) {
        return this.createParagraphWithItemCode(docx, code.getType(), code.getLevel(), code.getStyle(),
            code.getContent(), isNew);
    }
    
    /**
     * 向文档中添加带有项目编号/符号的段落，注意：需要确保文档已加载了全部样式
     *
     * @param docx XWPFDocument文档对象
     * @param level 项目符号级别
     * @param content 项目符号内容
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper createParagraphWithNumberingItemCode(final XWPFDocument docx, final int level,
        final String content) {
        return this.createParagraphWithNumberingItemCode(docx, level, content, false);
    }
    
    /**
     * 向文档中添加带有项目编号/符号的段落，注意：需要确保文档已加载了全部样式
     *
     * @param docx XWPFDocument文档对象
     * @param level 项目符号级别
     * @param content 项目符号内容
     * @param isNew 是否重新开始的序号列，仅当类型为项目编号时有效
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper createParagraphWithNumberingItemCode(final XWPFDocument docx, final int level,
        final String content, final boolean isNew) {
        return this.createParagraphWithItemCode(docx, ItemType.NUMBERING, level, NumberStyle.DECIMAL, content, isNew);
    }
    
    /**
     * 向文档中添加带有项目编号/符号的段落，注意：需要确保文档已加载了全部样式
     *
     * @param docx XWPFDocument文档对象
     * @param level 项目符号级别
     * @param content 项目符号内容
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper createParagraphWithBulletItemCode(final XWPFDocument docx, final int level, final String content) {
        return this.createParagraphWithBulletItemCode(docx, level, content, false);
    }
    
    /**
     * 向文档中添加带有项目编号/符号的段落，注意：需要确保文档已加载了全部样式
     *
     * @param docx XWPFDocument文档对象
     * @param level 项目符号级别
     * @param content 项目符号内容
     * @param isNew 是否重新开始的序号列，仅当类型为项目编号时有效
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper createParagraphWithBulletItemCode(final XWPFDocument docx, final int level, final String content,
        final boolean isNew) {
        return this.createParagraphWithItemCode(docx, ItemType.BULLET, level, BulletStyle.BLACK_CIRCLE_DOT, content,
            isNew);
    }
    
    /**
     * 向文档中添加带有项目编号/符号的段落，注意：需要确保文档已加载了全部样式
     *
     * @param docx XWPFDocument文档对象
     * @param type 项目符号类型
     * @param level 项目符号级别
     * @param style 项目符号样式
     * @param content 项目符号内容
     * @param isNew 是否重新开始的序号列，仅当类型为项目编号时有效
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper createParagraphWithItemCode(final XWPFDocument docx, final ItemType type, final int level,
        final int style, final String content, final boolean isNew) {
        XWPFParagraph paragraph = docx.createParagraph();
        if (type != null) {
            CTNumPr numPr = getOrCreateCTNumPr(paragraph.getCTP());
            CTDecimalNumber ilvl = numPr.isSetIlvl() ? numPr.getIlvl() : numPr.addNewIlvl();
            switch (type) {
                case NUMBERING:
                    BigInteger numId = getOrCreateNumberId(docx, style, isNew);
                    ilvl.setVal(BigInteger.valueOf(level));
                    paragraph.setNumID(numId);
                    break;
                case BULLET:
                    paragraph.setNumID(BigInteger.valueOf(style));
                    ilvl.setVal(BigInteger.valueOf(level));
                    break;
                default:
                    break;
            }
        }
        XWPFRun run = paragraph.createRun();
        run.setText(content);
        return this;
    }
    
    /**
     * 获取或者创建序号ID
     * 
     * @param docx XWPFDocument文档对象
     * @param style 序号样式
     * @param isNew 是否创建新的序号ID
     * @return 序号ID
     */
    private BigInteger getOrCreateNumberId(final XWPFDocument docx, final int style, final boolean isNew) {
        final String prefix = "number_style_";
        BigInteger exsits = NUMBERID_MAP.get(prefix + style);
        if (isNew || exsits == null) {
            exsits = BigInteger.valueOf(style);
            CTNumbering numbering = getCTNumbering(docx);
            CTAbstractNum absNum = getCTAbstractNum(numbering, style);
            if (isNew && absNum != null) {
                XmlObject obj = absNum.copy();
                BigInteger newAbsNumId = createNewAbstractNumId(numbering);
                CTAbstractNum ctAbsNum = numbering.addNewAbstractNum();
                ctAbsNum.set(obj);
                ctAbsNum.setAbstractNumId(newAbsNumId);
                ctAbsNum.setNsid(genCTLongHexNumber(8, "01"));
                ctAbsNum.setTmpl(genCTLongHexNumber(8, "F1"));
                exsits = createNewNumId(numbering);
                CTNum ctNum = numbering.addNewNum();
                ctNum.addNewAbstractNumId().setVal(newAbsNumId);
                ctNum.setNumId(exsits);
            }
            NUMBERID_MAP.put(prefix + style, exsits);
        }
        return exsits;
    }
    
    /**
     * 随机生成十六进制数字
     *
     * @param prefix 高位占位字符
     * @param length 字符长度
     * @return 十六进制数字
     */
    private CTLongHexNumber genCTLongHexNumber(final int length, final String prefix) {
        String str;
        if (StringUtils.isNotBlank(prefix)) {
            str = prefix + random(length - prefix.length(), HEX_CHARS);
        } else {
            str = RandomStringUtils.random(length, HEX_CHARS);
        }
        CTLongHexNumber number = CTLongHexNumber.Factory.newInstance();
        number.setVal(ColorHelper.decodeHex(str));
        return number;
    }
    
    /**
     * 获取CTNumbering
     *
     * @param docx XWPFDocument文档对象
     * @return CTNumbering
     */
    private CTNumbering getCTNumbering(final XWPFDocument docx) {
        XWPFNumbering numbering = docx.getNumbering();
        CTNumbering ct = null;
        try {
            Field filed = XWPFNumbering.class.getDeclaredField("ctNumbering");
            filed.setAccessible(true);
            ct = (CTNumbering) filed.get(numbering);
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
        }
        return ct;
    }
    
    /**
     * 获取抽象序号对象 CTNumbering
     *
     * @param docx XWPFDocument文档对象
     * @param style 样式值
     * @return 抽象需要对象 CTNumbering
     */
    public CTAbstractNum getCTAbstractNum(final XWPFDocument docx, final int style) {
        CTNumbering ctNumbering = this.getCTNumbering(docx);
        return getCTAbstractNum(ctNumbering, style);
    }
    
    /**
     * 获取抽象的项目编号对象 CTAbstractNum
     *
     * @param numbering Word项目编号对象
     * @param style 样式值
     * @return 抽象的项目编号对象 CTAbstractNum
     */
    private CTAbstractNum getCTAbstractNum(final CTNumbering numbering, final int style) {
        BigInteger numId = BigInteger.valueOf(style);
        List<CTNum> ctNums = numbering.getNumList();
        BigInteger absNumId = null;
        for (CTNum ctNum : ctNums) {
            if (numId.equals(ctNum.getNumId())) {
                absNumId = ctNum.getAbstractNumId().getVal();
                break;
            }
        }
        if (absNumId != null) {
            List<CTAbstractNum> ctAbsNums = numbering.getAbstractNumList();
            for (CTAbstractNum ctAbstractNum : ctAbsNums) {
                if (absNumId.equals(ctAbstractNum.getAbstractNumId())) {
                    return ctAbstractNum;
                }
            }
        }
        return null;
    }
    
    /**
     * 创建新的抽象项目编号ID
     *
     * @param numbering Word项目编号对象
     * @return 新的抽象项目编号ID
     */
    private BigInteger createNewAbstractNumId(final CTNumbering numbering) {
        BigInteger max = null;
        List<CTAbstractNum> ctAbsNums = numbering.getAbstractNumList();
        for (CTAbstractNum abs : ctAbsNums) {
            if (max == null) {
                max = abs.getAbstractNumId();
            } else {
                max = max.max(abs.getAbstractNumId());
            }
        }
        if (max != null) {
            return max.add(BigInteger.ONE);
        }
        return null;
    }
    
    /**
     * 创建新的项目编号ID
     *
     * @param numbering Word项目编号对象
     * @return 新的项目编号ID
     */
    private BigInteger createNewNumId(CTNumbering numbering) {
        BigInteger max = null;
        List<CTNum> ctNums = numbering.getNumList();
        for (CTNum num : ctNums) {
            if (max == null) {
                max = num.getNumId();
            } else {
                max = max.max(num.getNumId());
            }
        }
        if (max != null) {
            return max.add(BigInteger.ONE);
        }
        return null;
    }
    
    /**
     * 批量向文档中添加带有项目编号/符号的段落，注意：需要确保文档已加载了全部样式
     *
     * @param docx XWPFDocument文档对象
     * @param codes 带有项目编号、符号的段落集合
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper createParagraphWithItemCodes(final XWPFDocument docx, final List<ItemCode> codes) {
        for (ItemCode code : codes) {
            this.createParagraphWithItemCode(docx, code);
        }
        return this;
    }
    
    /**
     * 批量向文档中添加带有项目编号/符号的段落，注意：需要确保文档已加载了全部样式
     *
     * @param docx XWPFDocument文档对象
     * @param codes 带有项目编号、符号的段落集合
     * @param isNew 是否重新开始的序号列，仅当类型为项目编号时有效,注意：如果同时创建多个带有项目编号的段落时，第一条数据必须是带有项目编号数据
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper createParagraphWithItemCodes(final XWPFDocument docx, final List<ItemCode> codes,
        final boolean isNew) {
        for (int i = 0; i < codes.size(); i++) {
            ItemCode code = codes.get(i);
            if (isNew && ItemType.NUMBERING.equals(code.getType()) && i == 0) {
                getOrCreateNumberId(docx, code.getStyle(), isNew);
            }
            this.createParagraphWithItemCode(docx, code);
        }
        return this;
    }
    
    /**
     * 获取或者创建CTNumPr项目编号（符号）属性对象
     * 
     * @param ctp 段落
     * @return CTNumPr项目编号（符号）属性对象
     */
    private CTNumPr getOrCreateCTNumPr(final CTP ctp) {
        CTPPr ppr = getOrCreatePPr(ctp);
        return ppr.isSetNumPr() ? ppr.getNumPr() : ppr.addNewNumPr();
    }
    
    /**
     * 向文档中添加超链接
     *
     * @param paragraph Word文档段落对象
     * @param content 显示文本
     * @param link 连接地址
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper createHyperlink(final XWPFParagraph paragraph, final String content, final String link) {
        XWPFDocument docx = paragraph.getDocument();
        String resId = docx.getPackagePart().addExternalRelationship(link, XWPFRelation.HYPERLINK.getRelation())
            .getId();
        CTHyperlink cLink = paragraph.getCTP().addNewHyperlink();
        cLink.setId(resId);
        // Create the linked text
        CTText ctText = CTText.Factory.newInstance();
        ctText.setStringValue(content);
        CTR ctr = CTR.Factory.newInstance();
        ctr.addNewRPr().addNewRStyle().setVal(STYLE_HYPERLINK);
        ctr.setTArray(new CTText[] { ctText });
        cLink.setRArray(new CTR[] { ctr });
        return this;
    }
    
    /**
     * 向文档中文本段落，多个段落使用\r\n进行分割。
     *
     * @param paragraph XWPFParagraph文档对象
     * @param text 文本段落
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper appendTextInParagraph(final XWPFParagraph paragraph, final String text) {
        XWPFRun run = paragraph.createRun();
        run.setText(text);
        return this;
    }
    
    /**
     * 向文档中添加表格，创建后的表格至少有1行1列，默认行高按照Word中的默认值0.56厘米，表格宽度按照A4的大小（注意：不含左右边距，即14.65）计算
     * 
     * @param docx XWPFDocument文档对象
     * @param rowNum 行数
     * @param colNum 列数
     * @return 表格对象
     */
    public XWPFTable createTable(final XWPFDocument docx, final int rowNum, final int colNum) {
        float colWidth = DEFAULT_TABLE_WIDTH / colNum;
        return this.createTable(docx, rowNum, colNum, colWidth, DEFAULT_TABLE_HEIGHT);
    }
    
    /**
     * 向文档中添加表格,并指定表头行数，创建后的表格至少有1行1列，默认行高按照Word中的默认值0.56厘米，表格宽度按照A4的大小（注意：不含左右边距，即14.65）计算
     * 
     * @param docx XWPFDocument文档对象
     * @param rowNum 行数
     * @param colNum 列数
     * @param headRowNum 表头行数，注意，如果设置了表头行数，必须是行为表头，并且表头从第一行开始，表头行数必须小于表格行数。如果设置了表头行数，如果该表格内容跨越多页，那么将会在每页都显示表头
     * @return 表格对象
     */
    public XWPFTable createTable(final XWPFDocument docx, final int rowNum, final int colNum, final int headRowNum) {
        float colWidth = DEFAULT_TABLE_WIDTH / colNum;
        return this.createTable(docx, rowNum, colNum, colWidth, DEFAULT_TABLE_HEIGHT, headRowNum);
    }
    
    /**
     * 向文档中添加表格，创建后的表格至少有1行1列，并设置表格宽度
     * 
     * @param docx XWPFDocument文档对象
     * @param rowNum 行数
     * @param colNum 列数
     * @param tableWidth 表格宽度(单位：厘米)，那么将会自动根据列数计算平均列宽，行高则按照Word中的默认行高0.56厘米计算
     * @return 表格对象
     */
    public XWPFTable createTable(final XWPFDocument docx, final int rowNum, final int colNum, final Float tableWidth) {
        float colWidth = tableWidth / colNum;
        return this.createTable(docx, rowNum, colNum, colWidth, DEFAULT_TABLE_HEIGHT);
    }
    
    /**
     * 向文档中添加表格,并指定表头行数，创建后的表格至少有1行1列，并设置表格宽度
     * 
     * @param docx XWPFDocument文档对象
     * @param rowNum 行数
     * @param colNum 列数
     * @param tableWidth 表格宽度(单位：厘米)，那么将会自动根据列数计算平均列宽，行高则按照Word中的默认行高0.56厘米计算
     * @param headRowNum 表头行数，注意，如果设置了表头行数，必须是行为表头，并且表头从第一行开始，表头行数必须小于表格行数。如果设置了表头行数，如果该表格内容跨越多页，那么将会在每页都显示表头
     * @return 表格对象
     */
    public XWPFTable createTable(final XWPFDocument docx, final int rowNum, final int colNum, final Float tableWidth,
        final int headRowNum) {
        float colWidth = tableWidth / colNum;
        return this.createTable(docx, rowNum, colNum, colWidth, DEFAULT_TABLE_HEIGHT, headRowNum);
    }
    
    /**
     * 向文档中添加表格，创建后的表格至少有1行1列，并设置列宽及行高
     * 
     * @param docx XWPFDocument文档对象
     * @param rowNum 行数
     * @param colNum 列数
     * @param colWidth 列宽(单位：厘米)
     * @param rowHeight 行高(单位：厘米)
     * @return 表格对象
     */
    public XWPFTable createTable(final XWPFDocument docx, final int rowNum, final int colNum, final Float colWidth,
        final Float rowHeight) {
        return this.createTable(docx, rowNum, colNum, colWidth, rowHeight, 0);
    }
    
    /**
     * 向文档中添加表格，创建后的表格至少有1行1列，并设置列宽及行高
     * 
     * @param docx XWPFDocument文档对象
     * @param rowNum 行数
     * @param colNum 列数
     * @param colWidth 列宽(单位：厘米)
     * @param rowHeight 行高(单位：厘米)
     * @param headRowNum 表头行数，注意，如果设置了表头行数，必须是行为表头，并且表头从第一行开始，表头行数必须小于表格行数。如果设置了表头行数，如果该表格内容跨越多页，那么将会在每页都显示表头
     * @return 表格对象
     */
    public XWPFTable createTable(final XWPFDocument docx, final int rowNum, final int colNum, final Float colWidth,
        final Float rowHeight, final int headRowNum) {
        XWPFTable table = docx.createTable(rowNum, colNum);
        this.setTableStyle(table, STYLE_TABLE_CONTENT_LEFT);
        this.setTableCellsAlign(table, VAlign.CENTER, null);
        this.setTableHeader(table, headRowNum);
        if (colWidth == null && rowHeight == null) {
            return table;
        }
        if (colWidth != null) {
            BigInteger width = BigInteger.valueOf(cmToTwip(colWidth));
            CTTbl ttbl = table.getCTTbl();
            CTTblGrid tblGrid = ttbl.addNewTblGrid();
            for (int i = 0; i < colNum; i++) {
                CTTblGridCol gridCol = tblGrid.addNewGridCol();
                gridCol.setW(width);
            }
        }
        List<XWPFTableRow> rows = table.getRows();
        for (XWPFTableRow row : rows) {
            List<XWPFTableCell> cells = row.getTableCells();
            if (rowHeight != null) {
                int height = cmToTwip(rowHeight);
                row.setHeight(height);
            }
            if (colWidth != null) {
                BigInteger width = BigInteger.valueOf(cmToTwip(colWidth));
                for (XWPFTableCell cell : cells) {
                    CTTcPr tcpr = getOrCreateCellCTTcPr(cell);
                    CTTblWidth cttblWidth = tcpr.addNewTcW();
                    cttblWidth.setW(width);
                    cttblWidth.setType(STTblWidth.DXA);
                }
            }
        }
        
        return table;
    }
    
    /**
     * 向文档中添加图片
     * 
     * @param docx XWPFDocument文档对象
     * @param graphic 图片对象
     * @return 返回文档帮助类对象，可用于方法链调用
     * @throws InvalidFormatException 非法格式异常
     * @throws IOException IO异常
     * @throws XmlException Graphic文档模板错误
     * 
     */
    public DocxHelper createPricture(final XWPFDocument docx, final Graphic graphic) throws InvalidFormatException,
        IOException, XmlException {
        XWPFParagraph paragraph = docx.createParagraph();
        paragraph.setStyle(STYLE_GRAPHIC_CENTER);
        this.createPricture(paragraph, graphic);
        return this;
    }
    
    /**
     * 向段落中插入图片
     *
     * @param paragraph 文档段落
     * @param graphic 图片
     * @return 返回文档帮助类对象，可用于方法链调用
     * @throws FileNotFoundException 找不到图片
     * @throws InvalidFormatException 非法格式异常
     * @throws IOException IO异常
     * @throws XmlException Graphic文档模板错误
     */
    public DocxHelper createPricture(final XWPFParagraph paragraph, final Graphic graphic)
        throws FileNotFoundException, InvalidFormatException, IOException, XmlException {
        InputStream input = null;
        String blipId;
        try {
            input = graphic.toInputStream();
            blipId = paragraph.getDocument().addPictureData(input, graphic.getGraphicType().getType());
        } finally {
            IOUtils.closeQuietly(input);
        }
        int picId = paragraph.getDocument().getNextPicNameNumber(graphic.getGraphicType().getType());
        createCTInline(paragraph.createRun().getCTR(), graphic, blipId, picId);
        return this;
    }
    
    /**
     * 创建图片对象
     *
     * @param ctr 段落
     * @param graphic 图片
     * @param blipId 图片资源ID
     * @param picId 图片ID
     * @return 图片对象
     * @throws IOException IO异常
     * @throws XmlException XML异常
     */
    private CTInline createCTInline(final CTR ctr, final Graphic graphic, final String blipId, final int picId)
        throws IOException, XmlException {
        CTInline inline = ctr.addNewDrawing().addNewInline();
        CTGraphicalObject graphical = createGraphicalObject(graphic, blipId, picId);
        inline.setGraphic(graphical);
        inline.setDistT(0);
        inline.setDistB(0);
        inline.setDistL(0);
        inline.setDistR(0);
        CTPositiveSize2D extent = inline.addNewExtent();
        extent.setCx(graphic.getWidthAsEMU());
        extent.setCy(graphic.getHeightAsEMU());
        CTNonVisualDrawingProps docPr = inline.addNewDocPr();
        docPr.setId(picId);
        docPr.setName(graphic.getName());
        if (StringUtils.isNotBlank(graphic.getDescription())) {
            docPr.setDescr(graphic.getDescription());
        }
        return inline;
    }
    
    /**
     * 创建图片对象
     *
     * @param graphic 图片
     * @param blipId 图片资源ID
     * @param picId 图片ID
     * @return 图片对象
     * @throws IOException IO异常
     * @throws XmlException XML异常
     */
    private CTGraphicalObject createGraphicalObject(final Graphic graphic, final String blipId, final int picId)
        throws IOException, XmlException {
        String picTemplate;
        InputStream in = null;
        ClassLoader loader = Thread.currentThread().getContextClassLoader();
        try {
            in = loader.getResourceAsStream("fragments/graphic.xml");
            picTemplate = IOUtils.toString(in);
        } finally {
            IOUtils.closeQuietly(in);
        }
        // TODO 需要完善直接通过图片获取到它的高度和宽度
        String graphicXml = picTemplate.replace("${blipId}", blipId).replace("${name}", graphic.getName())
            .replace("${id}", String.valueOf(picId)).replace("${width}", String.valueOf(graphic.getWidthAsEMU()))
            .replace("${height}", String.valueOf(graphic.getHeightAsEMU()))
            .replace("${srcrect}", graphic.getRectifyString());
        CTGraphicalObject graphical = CTGraphicalObject.Factory.parse(graphicXml);
        return graphical;
    }
    
    /**
     * 向文档中插入文件
     * 
     * @param docx XWPFDocument文档对象
     * @param file 嵌入式文件对象
     * @return 返回文档帮助类对象，可用于方法链调用
     * @throws InvalidFormatException 非法格式异常
     * @throws IOException IO异常
     */
    public DocxHelper createFileObject(final XWPFDocument docx, final EmbedObject file) throws InvalidFormatException,
        IOException {
        XWPFParagraph paragraph = docx.createParagraph();
        return this.createFileObject(paragraph, file);
    }
    
    /**
     * 向文档中插入文件
     * 
     * @param paragraph XWPFParagraph文档对象
     * @param file 嵌入式文件对象
     * @return 返回文档帮助类对象，可用于方法链调用
     * @throws InvalidFormatException 非法格式异常
     * @throws IOException IO异常
     */
    public DocxHelper createFileObject(final XWPFParagraph paragraph, final EmbedObject file)
        throws InvalidFormatException, IOException {
        XWPFDocument docx = paragraph.getDocument();
        String fileName = genEmbeddedFileName(file);
        PackagePartName partName = PackagingURIHelper.createPartName("/word/embeddings/" + fileName);
        InputStream is = file.toInputStream();
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        IOUtils.copy(is, bos);
        docx.getPackage().createPart(partName, file.getEmbedType().getContentType(), bos);
        PackageRelationship relationship = docx.getPackagePart().addRelationship(partName, TargetMode.INTERNAL,
            file.getEmbedType().getPackageType());
        String rsId = relationship.getId();
        IOUtils.closeQuietly(is);
        IOUtils.closeQuietly(bos);
        // TODO 在没有设置预览图时，怎么自动生成预览图,需要完善如何设置<w:object w:dxaOrig="20761" w:dyaOrig="12137">的值
        is = file.getPicture().toInputStream();
        String rePreId = docx.addPictureData(is, Document.PICTURE_TYPE_EMF);
        IOUtils.closeQuietly(is);
        ClassLoader loader = Thread.currentThread().getContextClassLoader();
        is = loader.getResourceAsStream("fragments/embed.xml");
        String template = IOUtils.toString(is);
        IOUtils.closeQuietly(is);
        String shapeId = genAlphanumeric(12, "_x0000_i");
        String objectId = genAlphanumeric(11, "_");
        String xml = template.replace("${rsId}", rsId).replace("${rsPreId}", rePreId).replace("${shapeId}", shapeId)
            .replace("${objectId}", objectId).replace("${width}", String.valueOf(file.getPicture().getWidthAsPt()))
            .replace("${height}", String.valueOf(file.getPicture().getHeightAsPt()))
            .replace("${dxaOrig}", String.valueOf(file.getPicture().getWidthAsTwip()))
            .replace("${dyaOrig}", String.valueOf(file.getPicture().getHeightAsTwip()))
            .replace("${progId}", file.getEmbedType().getProgId());
        
        paragraph.setStyle(STYLE_GRAPHIC_CENTER);
        XWPFRun r = paragraph.createRun();
        CTObject object = null;
        try {
            object = CTObject.Factory.parse(xml);
        } catch (XmlException xe) {
            logger.error(xe.getMessage(), xe);
        }
        r.getCTR().addNewObject().set(object);
        return this;
    }
    
    /**
     * 生成插入的文件对象的名称
     *
     * @param file 插入文件对象
     * @return 文件对象的名称
     */
    private String genEmbeddedFileName(final EmbedObject file) {
        String nameTemplate = file.getEmbedType().getNameTemplate();
        AtomicInteger atomicIndex = FILEID_MAP.get(file.getEmbedType().getSubfix());
        if (atomicIndex == null) {
            atomicIndex = new AtomicInteger(1);
            FILEID_MAP.put(file.getEmbedType().getSubfix(), atomicIndex);
        }
        int index = atomicIndex.getAndIncrement();
        return nameTemplate.replace("${index}", String.valueOf(index));
    }
    
    /**
     * 随机生成数字
     *
     * @param prefix 高位占位字符
     * @param length 字符长度
     * @return 随机生成数字
     */
    private String genAlphanumeric(final int length, final String prefix) {
        String str;
        if (StringUtils.isNotBlank(prefix)) {
            str = prefix + randomNumeric(length - prefix.length());
        } else {
            str = randomNumeric(length);
        }
        return str;
    }
    
    /**
     * 创建默认的页脚(该页脚主要只居中显示页码)
     *
     * @param docx XWPFDocument文档对象
     * @return 返回文档帮助类对象，可用于方法链调用
     * @throws XmlException XML异常
     * @throws IOException IO异常
     */
    public DocxHelper createDefaultFooter(final XWPFDocument docx) throws IOException, XmlException {
        // TODO 设置页码起始值
        CTP pageNo = CTP.Factory.newInstance();
        XWPFParagraph footer = new XWPFParagraph(pageNo, docx);
        CTPPr begin = pageNo.addNewPPr();
        begin.addNewPStyle().setVal(STYLE_FOOTER);
        begin.addNewJc().setVal(STJc.CENTER);
        pageNo.addNewR().addNewFldChar().setFldCharType(STFldCharType.BEGIN);
        pageNo.addNewR().addNewInstrText().setStringValue("PAGE   \\* MERGEFORMAT");
        pageNo.addNewR().addNewFldChar().setFldCharType(STFldCharType.SEPARATE);
        // CTR text = pageNo.addNewR();
        // CTRPr textRPr = text.addNewRPr();
        // textRPr.addNewNoProof();
        // textRPr.addNewLang().setVal(LANG_ZH_CN);
        // text.addNewT().setStringValue(String.valueOf(startValue));
        CTR end = pageNo.addNewR();
        CTRPr endRPr = end.addNewRPr();
        endRPr.addNewNoProof();
        endRPr.addNewLang().setVal(LANG_ZH_CN);
        end.addNewFldChar().setFldCharType(STFldCharType.END);
        CTSectPr sectPr = this.getOrCreateSectPr(docx);
        XWPFHeaderFooterPolicy policy = new XWPFHeaderFooterPolicy(docx, sectPr);
        policy.createFooter(STHdrFtr.DEFAULT, new XWPFParagraph[] { footer });
        return this;
    }
    
    /**
     * 创建默认页眉
     *
     * @param docx XWPFDocument文档对象
     * @param text 页眉文本
     * @return 返回文档帮助类对象，可用于方法链调用
     * @throws XmlException XML异常
     * @throws IOException IO异常
     * @throws InvalidFormatException 非法格式异常
     * @throws FileNotFoundException 找不到文件异常
     */
    public DocxHelper createDefaultHeader(final XWPFDocument docx, final String text) throws FileNotFoundException,
        InvalidFormatException, IOException, XmlException {
        ClassLoader loader = DocxHelper.class.getClassLoader();
        CTP ctp = CTP.Factory.newInstance();
        XWPFParagraph paragraph = new XWPFParagraph(ctp, docx);
        CTPPr ppr = ctp.addNewPPr();
        ppr.addNewPStyle().setVal(STYLE_HEADER);
        ppr.addNewInd().setFirstLine(BigInteger.ZERO);
        URL logoUrl = loader.getResource("images/cspg_logo.png");
        String path = urlToPath(logoUrl);
        Graphic logo = new Graphic(path, "中国南方电网", 4.84f, 0.87f);
        int picId = docx.getNextPicNameNumber(GraphicType.PICTURE_TYPE_PNG.getType());
        CTInline inline = this.createCTInline(paragraph.createRun().getCTR(), logo, "rId1", picId);
        CTEffectExtent extent = inline.addNewEffectExtent();
        extent.setL(0l);
        extent.setT(0l);
        extent.setR(9525l);
        extent.setB(9525l);
        inline.addNewCNvGraphicFramePr().addNewGraphicFrameLocks().setNoChangeAspect(true);
        // this.createPicture(header, logo);
        XWPFRun logoRun = paragraph.getRuns().get(0);
        CTRPr logoRPr = logoRun.getCTR().addNewRPr();
        logoRPr.addNewNoProof();
        CTLanguage ctl = logoRPr.addNewLang();
        ctl.setVal(LANG_EN_US);
        ctl.setEastAsia(LANG_ZH_CN);
        ctp.addNewR().addNewTab();
        ctp.addNewR().addNewTab();
        ctp.addNewR().addNewT().setStringValue(text);
        ctp.addNewR().addNewT().setSpace(SpaceAttribute.Space.PRESERVE);
        CTSectPr sectPr = this.getOrCreateSectPr(docx);
        XWPFHeaderFooterPolicy policy = new XWPFHeaderFooterPolicy(docx, sectPr);
        XWPFHeader header = policy.createHeader(STHdrFtr.DEFAULT, new XWPFParagraph[] { paragraph });
        header.setXWPFDocument(docx);
        InputStream is = null;
        try {
            is = loader.getResourceAsStream("images/cspg_logo.png");
            header.addPictureData(is, GraphicType.PICTURE_TYPE_PNG.getType());
        } finally {
            IOUtils.closeQuietly(is);
        }
        return this;
    }
    
    /**
     * 创建封面
     *
     * @param docx XWPFDocument文档对象
     * @param text 封面标题
     * @return 返回文档帮助类对象，可用于方法链调用
     * @throws InvalidFormatException 非法格式异常
     * @throws XmlException XML异常
     * @throws IOException IO异常
     */
    public DocxHelper createFrontCover(final XWPFDocument docx, final String text) throws InvalidFormatException,
        IOException, XmlException {
        XWPFParagraph picgraph = docx.createParagraph();
        createCoverPagePicture(picgraph);
        XWPFParagraph empty;
        for (int i = 0; i < 6; i++) { // 创建6个空行
            empty = docx.createParagraph();
            empty.setStyle(STYLE_COVER);
        }
        // 创建 内部资料 严格扩散段落
        XWPFParagraph p1 = docx.createParagraph();
        p1.setStyle(STYLE_COVER_RIGHT_4); // 封面 小四 居右
        p1.createRun().setText("内部资料 严格扩散");
        for (int i = 0; i < 5; i++) { // 创建5个空行
            empty = docx.createParagraph();
            empty.setStyle(STYLE_COVER);
        }
        // 创建标题行
        XWPFParagraph title = docx.createParagraph();
        title.setStyle(STYLE_COVER_SIMHEI_1); // 封面 黑体一号 居中
        title.createRun().setText(text);
        empty = docx.createParagraph();
        empty.setStyle(STYLE_COVER_SIMHEI_1);
        // 创建文档编号
        XWPFParagraph no = docx.createParagraph();
        no.setStyle(STYLE_COVER_SIMHEI_3); // 封面 黑体三号 居中
        no.createRun().setText("(文档编号：)");
        for (int i = 0; i < 12; i++) { // 创建5个空行
            empty = docx.createParagraph();
            empty.setStyle(STYLE_COVER);
        }
        // 创建公司名称
        XWPFParagraph company = docx.createParagraph();
        company.setStyle(STYLE_COVER_SIMHEI_2); // 封面 黑体二号 居中
        company.createRun().setText("中国南方电网有限责任公司");
        // 创建时间
        Calendar calendar = Calendar.getInstance();
        XWPFParagraph time = docx.createParagraph();
        time.setStyle(STYLE_COVER_SIMHEI_3); // 封面 黑体三号 居中
        time.createRun().setText(calendar.get(Calendar.YEAR) + "年" + (calendar.get(Calendar.MONTH) + 1) + "月");
        empty = docx.createParagraph();
        empty.setStyle(STYLE_COVER);
        docx.getDocument().getBody().addNewSectPr();
        // 创建分页符
        XWPFParagraph bk = docx.createParagraph();
        bk.setStyle(STYLE_COVER);
        this.removeSectionHeaderFooter(bk);
        return this;
    }
    
    /**
     * 创建分页
     *
     * @param docx XWPFDocument文档对象
     * @return 返回文档帮助类对象，可用于方法链调用
     * @throws IOException IO异常
     * @throws XmlException XML异常
     */
    public DocxHelper createCataloguePage(final XWPFDocument docx) throws XmlException, IOException {
        XWPFParagraph title = docx.createParagraph();
        title.setStyle(STYLE_COVER_SIMHEI_3);
        title.createRun().setText("目  录");
        XWPFParagraph catalogue = docx.createParagraph();
        CTP ctp = null;
        ClassLoader loader = Thread.currentThread().getContextClassLoader();
        InputStream input = null;
        try {
            input = loader.getResourceAsStream("fragments/catalogue.xml");
            ctp = CTP.Factory.parse(input);
            catalogue.getCTP().set(ctp);
        } finally {
            IOUtils.closeQuietly(input);
        }
        this.resetSectionPageNum(docx, 1);
        return this;
    }
    
    /**
     * 创建分页
     *
     * @param docx XWPFDocument文档对象
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper createPageBreak(final XWPFDocument docx) {
        XWPFParagraph bk = docx.createParagraph();
        bk.setPageBreak(true);
        return this;
    }
    
    /**
     * 创建封面图片
     *
     * @param paragraph 文档段落对象
     * @throws FileNotFoundException 找不到文件异常
     * @throws InvalidFormatException 非法格式异常
     * @throws XmlException XML异常
     * @throws IOException IO异常
     */
    private void createCoverPagePicture(final XWPFParagraph paragraph) throws FileNotFoundException,
        InvalidFormatException, IOException, XmlException {
        paragraph.setStyle(STYLE_COVER);
        CTR ctr = paragraph.createRun().getCTR();
        ctr.addNewRPr().addNewNoProof(); // Do Not Check Spelling or Grammar
        ClassLoader loader = Thread.currentThread().getContextClassLoader();
        URL coverUrl = loader.getResource("images/cspg_cover.png");
        String path = urlToPath(coverUrl);
        Rectify rectify = new Rectify(); // 图片裁剪
        rectify.setBottom(0.21106f);
        Graphic coverGraphic = new Graphic(path, "中国南方电网", 22.04f, 7.29f);
        coverGraphic.setRectify(rectify);
        InputStream input = null;
        String blipId;
        try {
            input = new FileInputStream(coverGraphic.getPath());
            blipId = paragraph.getDocument().addPictureData(input, coverGraphic.getGraphicType().getType());
        } finally {
            IOUtils.closeQuietly(input);
        }
        int picId = paragraph.getDocument().getNextPicNameNumber(coverGraphic.getGraphicType().getType());
        CTGraphicalObject graphical = this.createGraphicalObject(coverGraphic, blipId, picId);
        CTAnchor anchor = ctr.addNewDrawing().addNewAnchor();
        anchor.setDistT(0l);
        anchor.setDistB(0l);
        anchor.setDistL(11430l);
        anchor.setDistR(114300l);
        anchor.setRelativeHeight(251657728l);
        anchor.setBehindDoc(false);
        anchor.setLocked(false);
        anchor.setLayoutInCell(true);
        anchor.setAllowOverlap(true);
        CTPoint2D point = anchor.addNewSimplePos();
        point.setX(0);
        point.setY(0);
        anchor.setSimplePos2(false);
        CTPosH ph = anchor.addNewPositionH();
        ph.setRelativeFrom(STRelFromH.PAGE);
        ph.setPosOffset(-17780);
        CTPosV pv = anchor.addNewPositionV();
        pv.setRelativeFrom(STRelFromV.PAGE);
        pv.setPosOffset(-14605);
        anchor.addNewWrapNone(); // No Text Wrapping
        CTPositiveSize2D size = anchor.addNewExtent();
        size.setCx(coverGraphic.getWidthAsEMU());
        size.setCy(coverGraphic.getHeightAsEMU());
        CTNonVisualDrawingProps docPr = anchor.addNewDocPr();
        docPr.setId(picId);
        docPr.setName(coverGraphic.getName());
        if (StringUtils.isNotBlank(coverGraphic.getDescription())) {
            docPr.setDescr(coverGraphic.getDescription());
        }
        CTEffectExtent extent = anchor.addNewEffectExtent();
        extent.setL(0l);
        extent.setT(0l);
        extent.setR(0l);
        extent.setB(4445l);
        anchor.setGraphic(graphical);
    }
    
    /**
     * 设置章节属性，可以通过该方法覆盖掉对整个文档设置的属性
     *
     * @param docx XWPFDocument文档对象
     * @param properties 章节属性
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper setSectionProperties(final XWPFDocument docx, final SectionProperties properties) {
        XWPFParagraph paragraph = docx.createParagraph();
        paragraph.getCTP().addNewPPr();
        setSectionProperties(paragraph, properties);
        return this;
    }
    
    // #region_end Docx添加或者删除内容--------------------------------------------------
    
    /**
     * 设置章节属性，可以通过该方法覆盖掉对整个文档设置的属性
     *
     * @param paragraph XWPFDocument文档段落对象
     * @param properties 章节属性
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper setSectionProperties(final XWPFParagraph paragraph, final SectionProperties properties) {
        if (properties.getMargin() != null) {
            this.setSectionMargin(paragraph, properties.getMargin());
        }
        if (properties.getSize() != null || properties.getOrient() != null) {
            this.setSectionSize(paragraph, properties.getSize(), properties.getOrient());
        }
        if (properties.getType() != null) {
            this.setSectionType(paragraph, properties.getType());
        }
        if (properties.getBorders() != null) {
            this.setSectionBorders(paragraph, properties.getBorders());
        }
        return this;
    }
    
    /**
     * 设置章节页边距
     * 
     * @param paragraph XWPFDocument文档段落对象
     * @param margin 页边距对象
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper setSectionMargin(final XWPFParagraph paragraph, final Margin margin) {
        CTSectPr sectPr = getOrCreateSectPr(paragraph);
        setSectionMargin(sectPr, margin);
        return this;
    }
    
    /**
     * 设置章节纸张大小 以及页面方向
     * 
     * @param paragraph XWPFDocument文档段落对象
     * @param orient 页面方向
     * @param size 纸张大小
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper setSectionSize(final XWPFParagraph paragraph, final PageSize size, final Orientation orient) {
        CTSectPr sectPr = getOrCreateSectPr(paragraph);
        setSectionSize(sectPr, size, orient);
        return this;
    }
    
    /**
     * 设置章节类型
     *
     * @param paragraph XWPFDocument文档段落对象
     * @param type 章节类型
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper setSectionType(final XWPFParagraph paragraph, final Type type) {
        CTSectPr sectPr = getOrCreateSectPr(paragraph);
        setSectionType(sectPr, type);
        return this;
    }
    
    /**
     * 设置章节边线
     *
     * @param paragraph XWPFDocument文档段落对象
     * @param borders 章节边线,注意：在设置章节边线时，一定要指定边线的位置
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper setSectionBorders(final XWPFParagraph paragraph, final Border... borders) {
        CTSectPr sectPr = getOrCreateSectPr(paragraph);
        setSectionBorders(sectPr, borders);
        return this;
        
    }
    
    /**
     * 设置章节类型
     *
     * @param sectPr 章节属性设置对象
     * @param type 章节类型
     */
    private void setSectionType(final CTSectPr sectPr, final Type type) {
        CTSectType sectType = sectPr.isSetType() ? sectPr.getType() : sectPr.addNewType();
        sectType.setVal(type.getMark());
    }
    
    /**
     * 设置章节边线
     *
     * @param sectPr 章节属性设置对象
     * @param borders 章节边线
     */
    private void setSectionBorders(final CTSectPr sectPr, final Border[] borders) {
        CTPageBorders pageBorders = sectPr.isSetPgBorders() ? sectPr.getPgBorders() : sectPr.addNewPgBorders();
        CTBorder ctBorder;
        for (Border border : borders) {
            switch (border.getLoaction()) {
                case TOP:
                    ctBorder = pageBorders.isSetTop() ? pageBorders.getTop() : pageBorders.addNewTop();
                    break;
                case LEFT:
                    ctBorder = pageBorders.isSetLeft() ? pageBorders.getLeft() : pageBorders.addNewLeft();
                    break;
                case BOTTOM:
                    ctBorder = pageBorders.isSetBottom() ? pageBorders.getBottom() : pageBorders.addNewBottom();
                    break;
                case RIGHT:
                    ctBorder = pageBorders.isSetRight() ? pageBorders.getRight() : pageBorders.addNewRight();
                    break;
                default:
                    ctBorder = null;
                    break;
            }
            if (ctBorder != null) {
                this.setBorderVal(ctBorder, border);
            }
        }
    }
    
    /**
     * 设置边线的值
     * 
     * @param ctBorder 文档边线对象
     * @param border 边线
     */
    private void setBorderVal(final CTBorder ctBorder, final Border border) {
        ctBorder.setVal(border.getType().getValue());
        ctBorder.setSz(border.getThicknessValue());
        // TODO 设置表格边线颜色等等
    }
    
    // #region_start Docx中表格的设置 --------------------------------------------------
    /**
     * 合并单元格
     * 
     * @param table Word表格对象
     * @param fromRow 起始行
     * @param fromCol 起始列
     * @param toRow 结束行
     * @param toCol 结束列
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper mergeCells(final XWPFTable table, final int fromRow, final int fromCol, final int toRow,
        final int toCol) {
        // int gridSpan = toCol - fromCol + 1;
        for (int rowIndex = fromRow; rowIndex <= toRow; rowIndex++) {
            for (int colIndex = fromCol; colIndex <= toCol; colIndex++) {
                XWPFTableCell cell = table.getRow(rowIndex).getCell(colIndex);
                CTTcPr tcPr = this.getOrCreateCellCTTcPr(cell);
                if (colIndex == fromCol) {
                    getOrCreateCellCTHMerge(tcPr).setVal(STMerge.RESTART);
                } else {
                    getOrCreateCellCTHMerge(tcPr).setVal(STMerge.CONTINUE);
                }
                if (rowIndex == fromRow) {
                    getOrCreateCellCTVMerge(tcPr).setVal(STMerge.RESTART);
                } else {
                    getOrCreateCellCTVMerge(tcPr).setVal(STMerge.CONTINUE);
                }
            }
            
        }
        return this;
    }
    
    /**
     * 跨列合并
     *
     * @param table 需要合并的表格
     * @param rowIndex 需要合并的行
     * @param fromCol 起始列
     * @param toCol 结束列
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper mergeCellsHorizontal(final XWPFTable table, final int rowIndex, final int fromCol, final int toCol) {
        for (int colIndex = fromCol; colIndex <= toCol; colIndex++) {
            XWPFTableCell cell = table.getRow(rowIndex).getCell(colIndex);
            if (colIndex == fromCol) {
                // The first merged cell is set with RESTART merge value
                getOrCreateCellCTTcPr(cell).addNewHMerge().setVal(STMerge.RESTART);
            } else {
                // Cells which join (merge) the first one,are set with CONTINUE
                getOrCreateCellCTTcPr(cell).addNewHMerge().setVal(STMerge.CONTINUE);
            }
        }
        return this;
    }
    
    /**
     * 跨行合并
     * <p>
     * http://stackoverflow.com/questions/24907541/row-span-with-xwpftable
     * </p>
     * 
     * @param table 需要合并的表格
     * @param colIndex 需要合并的列
     * @param fromRow 起始行
     * @param toRow 结束行
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper mergeCellsVertically(final XWPFTable table, final int colIndex, final int fromRow, final int toRow) {
        for (int rowIndex = fromRow; rowIndex <= toRow; rowIndex++) {
            XWPFTableCell cell = table.getRow(rowIndex).getCell(colIndex);
            if (rowIndex == fromRow) {
                // The first merged cell is set with RESTART merge value
                getOrCreateCellCTTcPr(cell).addNewVMerge().setVal(STMerge.RESTART);
            } else {
                // Cells which join (merge) the first one,are set with CONTINUE
                getOrCreateCellCTTcPr(cell).addNewVMerge().setVal(STMerge.CONTINUE);
            }
        }
        return this;
    }
    
    /**
     * 合并指定列内容相同的行，如果相同列的相邻行数据完全相同，则对该列的这些行进行合并
     *
     * @param table 需要合并的表格
     * @param colIndex 指定的列索引
     * @param startRowIndex 起始行
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper mergeSameContentRowVertically(final XWPFTable table, final int colIndex, final int startRowIndex) {
        return this.mergeSameContentRowVertically(table, colIndex, startRowIndex, -1);
    }
    
    /**
     * 合并指定列内容相同的行，如果相同列的相邻行数据完全相同，则对该列的这些行进行合并
     *
     * @param table 需要合并的表格
     * @param colIndex 指定的列索引
     * @param startRowIndex 起始行
     * @param endRowIndex 结束行，endRowIndex为-1表示不指定结束行，即以一直处理到表格末端为止。
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper mergeSameContentRowVertically(final XWPFTable table, final int colIndex, final int startRowIndex,
        final int endRowIndex) {
        List<XWPFTableRow> rows = table.getRows();
        String before = "";
        int start = startRowIndex;
        int end = 0;
        int last = endRowIndex == -1 ? (table.getRows().size() - 1) : endRowIndex;
        String text;
        for (int i = startRowIndex; i <= last; i++) {
            text = readTableCellValue(rows.get(i).getCell(colIndex));
            if (i == startRowIndex) {
                before = text;
            } else if (before.equals(text)) {
                end = i;
                continue;
            } else {
                before = text == null ? "" : text;
                if (end > start) {
                    this.mergeCellsVertically(table, colIndex, start, end);
                    start = end + 1;
                }
            }
        }
        if (end > start) {
            this.mergeCellsVertically(table, colIndex, start, end);
        }
        return this;
    }
    
    /**
     * 读取表格中单元格的数据
     *
     * @param cell 单元格
     * @return 数据
     */
    private String readTableCellValue(final XWPFTableCell cell) {
        CTTc tc = cell.getCTTc();
        List<CTP> ctps = tc.getPList();
        CTP ctp;
        List<CTR> ctrs;
        CTR ctr;
        List<CTText> ctts;
        CTText ctt;
        StringBuilder builder = new StringBuilder();
        for (int i = 0; ctps != null && i < ctps.size(); i++) {
            ctp = ctps.get(i);
            ctrs = ctp.getRList();
            for (int j = 0; ctrs != null && j < ctrs.size(); j++) {
                ctr = ctrs.get(i);
                ctts = ctr.getTList();
                for (int k = 0; ctts != null && k < ctrs.size(); k++) {
                    ctt = ctts.get(k);
                    builder.append(ctt.getStringValue());
                }
            }
            builder.append("\r\n");
        }
        return builder.toString();
    }
    
    /**
     * 得到Cell的CTTcPr(表格单元格属性对象),不存在则新建
     *
     * @param cell 指定的单元格
     * @return 单元格属性对象
     */
    private CTTcPr getOrCreateCellCTTcPr(final XWPFTableCell cell) {
        CTTc cttc = cell.getCTTc();
        CTTcPr tcPr = cttc.isSetTcPr() ? cttc.getTcPr() : cttc.addNewTcPr();
        return tcPr;
    }
    
    /**
     * 得到Cell的CTHMerge(单元格垂直扩展对象),不存在则新建
     *
     * @param tcPr 单元格属性对象
     * @return 单元格垂直扩展对象
     */
    private CTHMerge getOrCreateCellCTHMerge(final CTTcPr tcPr) {
        return tcPr.isSetHMerge() ? tcPr.getHMerge() : tcPr.addNewHMerge();
    }
    
    /**
     * 得到Cell的CTVMerge(单元格垂直扩展对象),不存在则新建
     *
     * @param tcPr 单元格属性对象
     * @return 单元格垂直扩展对象
     */
    private CTVMerge getOrCreateCellCTVMerge(final CTTcPr tcPr) {
        return tcPr.isSetVMerge() ? tcPr.getVMerge() : tcPr.addNewVMerge();
    }
    
    /**
     * 设置表格各列的宽度
     * 
     * @param table 表格对象
     * @param widths 列宽（单位为厘米）数组，注意：数组中数据的个数要与表格实际的列数一致
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper setColsWidth(final XWPFTable table, final float[] widths) {
        CTTbl cttbl = table.getCTTbl();
        CTTblGrid tblgrid = cttbl.getTblGrid();
        if (tblgrid == null) {
            tblgrid = cttbl.addNewTblGrid();
        }
        List<CTTblGridCol> gridCols = tblgrid.getGridColList();
        CTTblGridCol gridCol;
        BigInteger width;
        if (gridCols == null) {
            for (float colWidth : widths) {
                width = BigInteger.valueOf(cmToTwip(colWidth));
                gridCol = tblgrid.addNewGridCol();
                gridCol.setW(width);
            }
        } else {
            for (int i = 0, len = Math.min(widths.length, gridCols.size()); i < len; i++) {
                width = BigInteger.valueOf(cmToTwip(widths[i]));
                gridCol = gridCols.get(i);
                gridCol.setW(width);
            }
        }
        List<XWPFTableRow> rows = table.getRows();
        for (XWPFTableRow row : rows) {
            XWPFTableCell cell;
            CTTblWidth cttblWidth;
            for (int i = 0, len = Math.min(widths.length, row.getTableCells().size()); i < len; i++) {
                width = BigInteger.valueOf(cmToTwip(widths[i]));
                cell = row.getCell(i);
                cttblWidth = getOrCreateCellCTTblWidth(cell);
                cttblWidth.setW(width);
            }
        }
        return this;
    }
    
    /**
     * 设置表格某一列的宽度
     * 
     * @param table 表格对象
     * @param colIndex 列索引
     * @param width 列宽（单位为:厘米）
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper setColWidth(final XWPFTable table, final int colIndex, final float width) {
        List<XWPFTableRow> rows = table.getRows();
        CTTbl cttbl = table.getCTTbl();
        CTTblGrid tblgrid = cttbl.getTblGrid();
        if (tblgrid == null) {
            tblgrid = cttbl.addNewTblGrid();
        }
        List<CTTblGridCol> gridCols = tblgrid.getGridColList();
        CTTblGridCol gridCol;
        BigInteger colWidth = BigInteger.valueOf(cmToTwip(width));
        if (gridCols == null) {
            for (int i = 0; i < rows.size(); i++) {
                gridCol = tblgrid.addNewGridCol();
            }
        }
        gridCol = tblgrid.getGridColArray(colIndex);
        gridCol.setW(colWidth);
        for (XWPFTableRow row : rows) {
            XWPFTableCell cell = row.getCell(colIndex);
            CTTblWidth cttblWidth = getOrCreateCellCTTblWidth(cell);
            cttblWidth.setW(colWidth);
        }
        return this;
    }
    
    /**
     * 设置表格中各行的行高
     *
     * @param table 表格对象
     * @param heights 行高（单位为:厘米）数组，注意：数组中数据的个数要与表格实际的行数一致
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper setRowsHeight(final XWPFTable table, final float[] heights) {
        XWPFTableRow row;
        int height;
        for (int i = 0, len = Math.min(heights.length, table.getRows().size()); i < len; i++) {
            height = cmToTwip(heights[i]);
            row = table.getRow(i);
            row.setHeight(height);
        }
        return this;
    }
    
    /**
     * 设置表格中某一行的行高
     *
     * @param table 表格对象
     * @param rowIndex 行索引
     * @param height 行高（单位为:厘米）
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper setRowHeight(final XWPFTable table, final int rowIndex, final float height) {
        XWPFTableRow row;
        int rowHeight = cmToTwip(height);
        row = table.getRow(rowIndex);
        row.setHeight(rowHeight);
        return this;
    }
    
    /**
     * 获取或者创建CTTblWidth单元格宽度属性
     * 
     * @param cell 单元格
     * @return 单元格宽度属性
     */
    private CTTblWidth getOrCreateCellCTTblWidth(XWPFTableCell cell) {
        CTTcPr tcpr = getOrCreateCellCTTcPr(cell);
        return tcpr.isSetTcW() ? tcpr.getTcW() : tcpr.addNewTcW();
    }
    
    /**
     * 设置单元格边框
     * 
     * @param table 表格对象
     * @param colIndex 列索引
     * @param rowIndex 行索引
     * @param border 边线
     * @param location 边线位置
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper setCellBorder(final XWPFTable table, final int colIndex, final int rowIndex, final Border border,
        final BorderLocation location) {
        XWPFTableCell cell = table.getRow(rowIndex).getCell(colIndex);
        CTTcBorders borders = getOrCreateCellCTTcBorders(cell);
        CTBorder ctborder = getOrCreateCellBorder(borders, location);
        ctborder.setVal(border.getType().getValue());
        ctborder.setSz(border.getThicknessValue());
        return this;
    }
    
    /**
     * 获取或创建单元格边框对象
     *
     * @param borders 单元格边线集合
     * @param location 边线位置
     * @return 单元格边框对象
     */
    private CTBorder getOrCreateCellBorder(final CTTcBorders borders, final BorderLocation location) {
        CTBorder border;
        switch (location) {
            case TOP:
                border = borders.isSetTop() ? borders.getTop() : borders.addNewTop();
                break;
            case LEFT:
                border = borders.isSetLeft() ? borders.getLeft() : borders.addNewLeft();
                break;
            case BOTTOM:
                border = borders.isSetBottom() ? borders.getBottom() : borders.addNewBottom();
                break;
            case RIGHT:
                border = borders.isSetRight() ? borders.getRight() : borders.addNewRight();
                break;
            case INSIDEH:
                border = borders.isSetInsideH() ? borders.getInsideH() : borders.addNewInsideH();
                break;
            case INSIDEV:
                border = borders.isSetInsideV() ? borders.getInsideV() : borders.addNewInsideV();
                break;
            case TL2BR:
                border = borders.isSetTl2Br() ? borders.getTl2Br() : borders.addNewTl2Br();
                break;
            case TR2BL:
                border = borders.isSetTr2Bl() ? borders.getTr2Bl() : borders.addNewTr2Bl();
                break;
            default:
                border = borders.isSetTop() ? borders.getTop() : borders.addNewTop();
                break;
        }
        return border;
    }
    
    /**
     * 获取或者创建单元格边框集合对象
     * 
     * @param cell 单元格
     * @return 单元格边框集合对象
     */
    private CTTcBorders getOrCreateCellCTTcBorders(final XWPFTableCell cell) {
        CTTcPr tcpr = getOrCreateCellCTTcPr(cell);
        CTTcBorders borders = tcpr.isSetTcBorders() ? tcpr.getTcBorders() : tcpr.addNewTcBorders();
        return borders;
    }
    
    /**
     * 设置表格边框
     *
     * @param table Word表格对象
     * @param border 边线对象
     * @param location 边线位置
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper setTableBorder(final XWPFTable table, final Border border, final BorderLocation location) {
        CTTblBorders tblBorders = getTableBorders(table);
        CTBorder ctborder = getOrCreateTableBorder(tblBorders, location);
        this.setBorderVal(ctborder, border);
        return this;
    }
    
    /**
     * 设置表头
     *
     * @param table Word表格对象
     * @param headRowNum 表头行数,注意，如果设置了表头行数，必须是行为表头，并且表头从第一行开始，表头行数必须小于表格行数。如果设置了表头行数，如果该表格内容跨越多页，那么将会在每页都显示表头
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper setTableHeader(final XWPFTable table, final int headRowNum) {
        List<XWPFTableRow> rows = table.getRows();
        final int count = Math.min(rows.size(), headRowNum);
        XWPFTableRow row;
        CTOnOff tblHeader;
        for (int i = 0; i < count; i++) {
            row = rows.get(i);
            this.setRowStyle(table, i, STYLE_TABLE_TITLE);
            tblHeader = getOrCreateTblHeader(row);
            tblHeader.setVal(STOnOff.ON);
        }
        return this;
    }
    
    /**
     * 获取或创建表格行表头属性设置
     *
     * @param row Word表格行对象
     * @return 表格行表头属性设置
     */
    private CTOnOff getOrCreateTblHeader(final XWPFTableRow row) {
        CTTrPr trpr = getOrCreateCTTrPr(row);
        return trpr.getTblHeaderList() == null || trpr.getTblHeaderList().size() == 0 ? trpr.addNewTblHeader() : trpr
            .getTblHeaderArray(0);
    }
    
    /**
     * 获取或创建表格行对象属性配置
     *
     * @param row Word表格行对象
     * @return 表格行对象属性配置
     */
    private CTTrPr getOrCreateCTTrPr(final XWPFTableRow row) {
        CTRow ctr = row.getCtRow();
        return ctr.isSetTrPr() ? ctr.getTrPr() : ctr.addNewTrPr();
    }
    
    /**
     * 获取或创建单元格边框对象
     *
     * @param borders 单元格集合
     * @param location 边线位置
     * @return 单元格边框对象
     */
    private CTBorder getOrCreateTableBorder(final CTTblBorders borders, final BorderLocation location) {
        CTBorder border;
        switch (location) {
            case TOP:
                border = borders.isSetTop() ? borders.getTop() : borders.addNewTop();
                break;
            case LEFT:
                border = borders.isSetLeft() ? borders.getLeft() : borders.addNewLeft();
                break;
            case BOTTOM:
                border = borders.isSetBottom() ? borders.getBottom() : borders.addNewBottom();
                break;
            case RIGHT:
                border = borders.isSetRight() ? borders.getRight() : borders.addNewRight();
                break;
            case INSIDEH:
                border = borders.isSetInsideH() ? borders.getInsideH() : borders.addNewInsideH();
                break;
            case INSIDEV:
                border = borders.isSetInsideV() ? borders.getInsideV() : borders.addNewInsideV();
                break;
            case TL2BR:
                // TODO throw exception.
            case TR2BL:
                // TODO throw exception.
            default:
                border = borders.isSetTop() ? borders.getTop() : borders.addNewTop();
                break;
        }
        return border;
    }
    
    /**
     * 得到Table的CTTblBorders（表格边框集合）,不存在则新建
     *
     * @param table Word表格对象
     * @return 表格边框集合
     */
    private CTTblBorders getTableBorders(final XWPFTable table) {
        CTTblPr tblPr = getTableCTTblPr(table);
        CTTblBorders tblBorders = tblPr.isSetTblBorders() ? tblPr.getTblBorders() : tblPr.addNewTblBorders();
        return tblBorders;
    }
    
    /**
     * 得到Table的CTTblPr（表格属性）,不存在则新建
     *
     * @param table Word表格对象
     * @return 表格属性
     */
    private CTTblPr getTableCTTblPr(final XWPFTable table) {
        CTTbl ttbl = table.getCTTbl();
        CTTblPr tblPr = ttbl.getTblPr() == null ? ttbl.addNewTblPr() : ttbl.getTblPr();
        return tblPr;
    }
    
    /**
     * 设置表格对齐方式
     * 
     * @param table Word表格对象
     * @param halign 水平对齐方式
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper setTableAlign(final XWPFTable table, final Style.HAlign halign) {
        CTTblPr tblPr = this.getTableCTTblPr(table);
        CTJc jc = tblPr.isSetJc() ? tblPr.getJc() : tblPr.addNewJc();
        jc.setVal(halign.getValue());
        return this;
    }
    
    /**
     * 设置表格所有单元格对齐方式
     * 
     * @param table Word表格对象
     * @param valign 垂直对齐方式
     * @param halign 水平对齐方式
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper setTableCellsAlign(final XWPFTable table, final Style.VAlign valign, final Style.HAlign halign) {
        List<XWPFTableRow> rows = table.getRows();
        for (XWPFTableRow row : rows) {
            List<XWPFTableCell> cells = row.getTableCells();
            for (XWPFTableCell cell : cells) {
                if (valign != null) {
                    CTVerticalJc jc = getOrCreateVAlign(cell);
                    jc.setVal(valign.getValue());
                }
                if (halign != null) {
                    List<CTP> ctps = getOrCreateCellPList(cell);
                    for (CTP ctp : ctps) {
                        setParagraphAlign(ctp, halign);
                    }
                }
            }
        }
        return this;
    }
    
    /**
     * 设置表格某一行单元格对齐方式
     * 
     * @param table Word表格对象
     * @param rowIndex 行索引
     * @param valign 垂直对齐方式
     * @param halign 水平对齐方式
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper setRowAlign(final XWPFTable table, final int rowIndex, final Style.VAlign valign,
        final Style.HAlign halign) {
        XWPFTableRow row = table.getRow(rowIndex);
        List<XWPFTableCell> cells = row.getTableCells();
        for (XWPFTableCell cell : cells) {
            if (valign != null) {
                CTVerticalJc jc = getOrCreateVAlign(cell);
                jc.setVal(valign.getValue());
            }
            if (halign != null) {
                List<CTP> ctps = getOrCreateCellPList(cell);
                for (CTP ctp : ctps) {
                    setParagraphAlign(ctp, halign);
                }
            }
        }
        return this;
    }
    
    /**
     * 设置表格某一列单元格对齐方式
     * 
     * @param table Word表格对象
     * @param colIndex 列索引
     * @param valign 垂直对齐方式
     * @param halign 水平对齐方式
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper setColAlign(final XWPFTable table, final int colIndex, final Style.VAlign valign,
        final Style.HAlign halign) {
        List<XWPFTableRow> rows = table.getRows();
        for (XWPFTableRow row : rows) {
            XWPFTableCell cell = row.getCell(colIndex);
            if (valign != null) {
                CTVerticalJc jc = getOrCreateVAlign(cell);
                jc.setVal(valign.getValue());
            }
            if (halign != null) {
                List<CTP> ctps = getOrCreateCellPList(cell);
                for (CTP ctp : ctps) {
                    setParagraphAlign(ctp, halign);
                }
            }
        }
        return this;
    }
    
    /**
     * 设置表格单元格对齐方式
     * 
     * @param table Word表格对象
     * @param rowIndex 行索引
     * @param colIndex 列索引
     * @param valign 垂直对齐方式
     * @param halign 水平对齐方式
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper setCellAlign(final XWPFTable table, final int rowIndex, final int colIndex,
        final Style.VAlign valign, final Style.HAlign halign) {
        XWPFTableCell cell = table.getRow(rowIndex).getCell(colIndex);
        if (valign != null) {
            CTVerticalJc jc = getOrCreateVAlign(cell);
            jc.setVal(valign.getValue());
        }
        if (halign != null) {
            List<CTP> ctps = getOrCreateCellPList(cell);
            for (CTP ctp : ctps) {
                setParagraphAlign(ctp, halign);
            }
        }
        return this;
    }
    
    /**
     * 获取或者创建单元格中的段落集合对象
     * 
     * @param cell 单元格
     * @return 单元格中的段落集合
     */
    private List<CTP> getOrCreateCellPList(final XWPFTableCell cell) {
        CTTc cttc = cell.getCTTc();
        List<CTP> ctps = cttc.getPList();
        if (ctps == null) {
            cttc.addNewP();
        }
        return cttc.getPList();
    }
    
    /**
     * 获取或者创建单元格中的段落集合对象
     * 
     * @param cell 单元格
     * @param count 段落数量
     * @return 单元格中的段落集合
     */
    private List<CTP> getOrCreateCellPList(final XWPFTableCell cell, int count) {
        CTTc cttc = cell.getCTTc();
        List<CTP> ctps = cttc.getPList();
        if (ctps == null) {
            for (int i = 0; i < count; i++) {
                cttc.addNewP();
            }
        } else {
            CTP p = ctps.get(0);
            XmlObject ppr = null;
            if (p.getPPr() != null) {
                ppr = p.getPPr().copy();
            }
            int newSize = count - ctps.size();
            for (int i = 0; i < newSize; i++) {
                CTP newP = cttc.addNewP();
                if (ppr != null) {
                    newP.addNewPPr().set(ppr);
                }
            }
        }
        return cttc.getPList();
    }
    
    /**
     * 获取或者创建单元格垂直对齐方式
     * 
     * @param cell 单元格对象
     * @return 单元格垂直对齐方式
     */
    private CTVerticalJc getOrCreateVAlign(final XWPFTableCell cell) {
        CTTcPr tcpr = this.getOrCreateCellCTTcPr(cell);
        CTVerticalJc jc = tcpr.isSetVAlign() ? tcpr.getVAlign() : tcpr.addNewVAlign();
        return jc;
    }
    
    /**
     * 设置单元格背景色
     * 
     * @param table 表格
     * @param rowIndex 行索引
     * @param colIndex 列索引
     * @param rgbHex 十六进制的颜色字符串
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper setCellBackground(final XWPFTable table, final int rowIndex, final int colIndex,
        final String rgbHex) {
        XWPFTableCell cell = table.getRow(rowIndex).getCell(colIndex);
        CTShd shd = getOrCreateCTShd(cell);
        shd.setVal(STShd.CLEAR);
        shd.setColor(AUTO);
        shd.setFill(rgbHex);
        return this;
    }
    
    /**
     * 设置整行背景色
     * 
     * @param table 表格对象
     * @param rowIndex 行索引
     * @param rgbHex 十六进制颜色字符串
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper setRowBackground(final XWPFTable table, final int rowIndex, final String rgbHex) {
        XWPFTableRow row = table.getRow(rowIndex);
        List<XWPFTableCell> cells = row.getTableCells();
        for (XWPFTableCell cell : cells) {
            CTShd shd = getOrCreateCTShd(cell);
            shd.setVal(STShd.CLEAR);
            shd.setColor(AUTO);
            shd.setFill(rgbHex);
        }
        return this;
    }
    
    /**
     * 设置整列背景色
     * 
     * @param table 表格对象
     * @param colIndex 行索引
     * @param rgbHex 十六进制颜色字符串
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper setColBackground(final XWPFTable table, final int colIndex, final String rgbHex) {
        List<XWPFTableRow> rows = table.getRows();
        for (XWPFTableRow row : rows) {
            XWPFTableCell cell = row.getCell(colIndex);
            CTShd shd = getOrCreateCTShd(cell);
            shd.setVal(STShd.CLEAR);
            shd.setColor(AUTO);
            shd.setFill(rgbHex);
        }
        return this;
    }
    
    /**
     * 获取或者创建CTShd（）
     * 
     * @param cell 单元格对象
     * @return CTShd对象
     */
    private CTShd getOrCreateCTShd(XWPFTableCell cell) {
        CTTcPr tcpr = getOrCreateCellCTTcPr(cell);
        CTShd shd = tcpr.isSetShd() ? tcpr.getShd() : tcpr.addNewShd();
        return shd;
    }
    
    /**
     * 设置表格所有单元格字体
     * 
     * @param table Word表格对象
     * @param font 字体对象
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper setTableFont(final XWPFTable table, final Font font) {
        List<XWPFTableRow> rows = table.getRows();
        for (XWPFTableRow row : rows) {
            List<XWPFTableCell> cells = row.getTableCells();
            for (XWPFTableCell cell : cells) {
                List<CTP> ctps = getOrCreateCellPList(cell);
                for (CTP ctp : ctps) {
                    this.setParagraphFont(ctp, font);
                }
            }
        }
        return this;
    }
    
    /**
     * 设置表格某一行单元格字体
     * 
     * @param table Word表格对象
     * @param rowIndex 行索引
     * @param font 字体对象
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper setRowFont(final XWPFTable table, final int rowIndex, final Font font) {
        XWPFTableRow row = table.getRow(rowIndex);
        List<XWPFTableCell> cells = row.getTableCells();
        for (XWPFTableCell cell : cells) {
            List<CTP> ctps = getOrCreateCellPList(cell);
            for (CTP ctp : ctps) {
                this.setParagraphFont(ctp, font);
            }
        }
        return this;
    }
    
    /**
     * 设置表格某一列单元格字体
     * 
     * @param table Word表格对象
     * @param colIndex 列索引
     * @param font 字体对象
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper setColFont(final XWPFTable table, final int colIndex, final Font font) {
        List<XWPFTableRow> rows = table.getRows();
        for (XWPFTableRow row : rows) {
            XWPFTableCell cell = row.getCell(colIndex);
            List<CTP> ctps = getOrCreateCellPList(cell);
            for (CTP ctp : ctps) {
                this.setParagraphFont(ctp, font);
            }
        }
        return this;
    }
    
    /**
     * 设置表格单元格对齐方式
     * 
     * @param table Word表格对象
     * @param rowIndex 行索引
     * @param colIndex 列索引
     * @param font 字体对象
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper setCellFont(final XWPFTable table, final int rowIndex, final int colIndex, final Font font) {
        XWPFTableCell cell = table.getRow(rowIndex).getCell(colIndex);
        List<CTP> ctps = getOrCreateCellPList(cell);
        for (CTP ctp : ctps) {
            this.setParagraphFont(ctp, font);
        }
        return this;
    }
    
    /**
     * 填充单元格文本内容
     *
     * @param table 表格对象
     * @param rowIndex 行索引
     * @param colIndex 列索引
     * @param text 文本，多行文本使用“\r\n”进行分割
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper setCellText(final XWPFTable table, final int rowIndex, final int colIndex, final String text) {
        String txt = text == null ? "" : text;
        XWPFTableCell cell = table.getRow(rowIndex).getCell(colIndex);
        String[] pstrs = txt.split("\r\n");
        List<CTP> ctps = getOrCreateCellPList(cell, pstrs.length);
        for (int i = 0; i < pstrs.length; i++) {
            CTP ctp = ctps.get(i);
            CTR ctr = getOrCreateR(ctp);
            if (ctp.getPPr() != null && ctp.getPPr().getRPr() != null) {
                XmlObject xml = ctp.getPPr().getRPr().copy();
                ctr.addNewRPr().set(xml);
            }
            ctr.addNewT().setStringValue(pstrs[i]);
        }
        return this;
    }
    
    /**
     * 设置表格的所有单元格样式
     * 
     * @param table Word表格对象
     * @param styleId 样式ID
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper setTableStyle(final XWPFTable table, final String styleId) {
        List<XWPFTableRow> rows = table.getRows();
        for (XWPFTableRow row : rows) {
            List<XWPFTableCell> cells = row.getTableCells();
            for (XWPFTableCell cell : cells) {
                List<CTP> ctps = getOrCreateCellPList(cell);
                for (CTP ctp : ctps) {
                    getOrCreatePStyle(ctp).setVal(styleId);
                }
            }
        }
        return this;
    }
    
    /**
     * 设置表格某一行单元格样式
     * 
     * @param table Word表格对象
     * @param rowIndex 行索引
     * @param styleId 样式ID
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper setRowStyle(final XWPFTable table, final int rowIndex, final String styleId) {
        XWPFTableRow row = table.getRow(rowIndex);
        List<XWPFTableCell> cells = row.getTableCells();
        for (XWPFTableCell cell : cells) {
            List<CTP> ctps = getOrCreateCellPList(cell);
            for (CTP ctp : ctps) {
                getOrCreatePStyle(ctp).setVal(styleId);
            }
        }
        return this;
    }
    
    /**
     * 设置表格某一列单元格样式
     * 
     * @param table Word表格对象
     * @param colIndex 列索引
     * @param styleId 样式ID
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper setColStyle(final XWPFTable table, final int colIndex, final String styleId) {
        List<XWPFTableRow> rows = table.getRows();
        for (XWPFTableRow row : rows) {
            XWPFTableCell cell = row.getCell(colIndex);
            List<CTP> ctps = getOrCreateCellPList(cell);
            for (CTP ctp : ctps) {
                getOrCreatePStyle(ctp).setVal(styleId);
            }
        }
        return this;
    }
    
    /**
     * 设置表格单元格样式
     * 
     * @param table Word表格对象
     * @param rowIndex 行索引
     * @param colIndex 列索引
     * @param styleId 样式ID
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper setCellStyle(final XWPFTable table, final int rowIndex, final int colIndex, final String styleId) {
        XWPFTableCell cell = table.getRow(rowIndex).getCell(colIndex);
        List<CTP> ctps = getOrCreateCellPList(cell);
        for (CTP ctp : ctps) {
            getOrCreatePStyle(ctp).setVal(styleId);
        }
        return this;
    }
    
    /**
     * 填充单元格文本内容
     *
     * @param table 表格对象
     * @param rowIndex 行索引
     * @param colIndex 列索引
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public XWPFParagraph getCellLastParagraph(final XWPFTable table, final int rowIndex, final int colIndex) {
        XWPFTableCell cell = table.getRow(rowIndex).getCell(colIndex);
        List<CTP> ctps = getOrCreateCellPList(cell, 1);
        int pos = ctps.size() - 1;
        return cell.getParagraphs().get(pos);
    }
    
    // #region_end Docx中表格的设置 --------------------------------------------------
    
    // #region_start Docx中段落的设置 --------------------------------------------------
    
    /**
     * 设置段落对齐方式
     * 
     * @param paragraph Word段落对象
     * @param halign 对齐方式
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper setParagraphAlign(final XWPFParagraph paragraph, final HAlign halign) {
        CTP ctp = paragraph.getCTP();
        CTJc jc = getOrCreateCTJc(ctp);
        jc.setVal(halign.getValue());
        return this;
    }
    
    /**
     * 设置段落字体
     * 
     * @param paragraph 段落
     * @param font 字体
     * @return 返回文档帮助类对象，可用于方法链调用
     */
    public DocxHelper setParagraphFont(final XWPFParagraph paragraph, final Font font) {
        CTP ctp = paragraph.getCTP();
        this.setParagraphFont(ctp, font);
        return this;
    }
    
    /**
     * 设置段落字体
     * 
     * @param ctp 段落
     * @param font 字体
     */
    private void setParagraphFont(final CTP ctp, final Font font) {
        String name = font.getName();
        if (StringUtils.isNotBlank(name)) { // 字体名称
            CTFonts fonts = getOrCreateFonts(ctp);
            fonts.setAscii(name);
            fonts.setEastAsia(name);
            fonts.setHAnsi(name);
            fonts.setHint(STHint.EAST_ASIA);
        }
        
        if (font.getFontSize() > 0) { // 字体大小
            CTHpsMeasure sz = getOrCreateSz(ctp);
            sz.setVal(BigInteger.valueOf(font.getFontSize()));
            CTHpsMeasure szcs = getOrCreateSzCs(ctp);
            szcs.setVal(BigInteger.valueOf(font.getFontSize()));
        }
        
        if (font.getVert() != null) {// 下标、上标
            CTVerticalAlignRun vertAlign = getOrCreateCTVerticalAlignRun(ctp);
            vertAlign.setVal(font.getVert().getValue());
        }
        
        if (font.getTextStyle() != null) { // 特殊文本样式。如加粗、倾斜、下划线等等
            for (TextStyle style : font.getTextStyle()) {
                setParagraphTextStyle(ctp, style);
            }
        }
    }
    
    /**
     * 设置段落文本样式
     *
     * @param ctp Word段落对象
     * @param style 文本样式
     */
    private void setParagraphTextStyle(final CTP ctp, final TextStyle style) {
        CTParaRPr ctrpr = getOrCreateCTRPr(ctp);
        switch (style) {
            case BOLD:
                if (!ctrpr.isSetB()) {
                    ctrpr.addNewB().setVal(STOnOff.ON);
                }
                break;
            case INC_LINE:
                if (!ctrpr.isSetI()) {
                    ctrpr.addNewI().setVal(STOnOff.ON);
                }
                break;
            case UNDER_LINE:
                if (!ctrpr.isSetU()) {
                    ctrpr.addNewU().setVal(STUnderline.SINGLE);
                }
                break;
            case STRIKE:
                if (!ctrpr.isSetStrike()) {
                    ctrpr.addNewStrike().setVal(STOnOff.ON);
                }
                break;
            case DSTRIKE:
                if (!ctrpr.isSetDstrike()) {
                    ctrpr.addNewDstrike().setVal(STOnOff.ON);
                }
                break;
            case VANISH:
                if (!ctrpr.isSetVanish()) {
                    ctrpr.addNewVanish().setVal(STOnOff.ON);
                }
                break;
            case SMALL_CAPS:
                if (!ctrpr.isSetStrike()) {
                    ctrpr.addNewSmallCaps().setVal(STOnOff.ON);
                }
                break;
            case CAPS:
                if (!ctrpr.isSetStrike()) {
                    ctrpr.addNewCaps().setVal(STOnOff.ON);
                }
                break;
            default:
                break;
        }
        
    }
    
    /**
     * 获取最后一个段落
     *
     * @param docx Word对象
     * @return 最后一个段落
     */
    public XWPFParagraph getLastParagraph(final XWPFDocument docx) {
        List<XWPFParagraph> paragraphs = docx.getParagraphs();
        if (paragraphs != null && paragraphs.size() > 0) {
            int lastIndex = paragraphs.size() - 1;
            return paragraphs.get(lastIndex);
        }
        return null;
    }
    
    /**
     * 获取或者创建R对象
     *
     * @param ctp Word段落对象
     * @return R对象
     */
    private CTR getOrCreateR(CTP ctp) {
        return ctp.getRList() == null || ctp.getRList().size() == 0 ? ctp.addNewR() : ctp.getRArray(0);
    }
    
    /**
     * 获取或者创建CTVerticalAlignRun(空间对齐)对象
     * 
     * @param ctp Word段落对象
     * @return CTVerticalAlignRun(空间对齐)对象
     */
    private CTVerticalAlignRun getOrCreateCTVerticalAlignRun(CTP ctp) {
        CTParaRPr ctrpr = getOrCreateCTRPr(ctp);
        return ctrpr.isSetVertAlign() ? ctrpr.getVertAlign() : ctrpr.addNewVertAlign();
    }
    
    /**
     * 获取或者创建复合文本字体大小对象
     *
     * @param ctp Word段落对象
     * @return 复合文本字体大小对象
     */
    private CTHpsMeasure getOrCreateSzCs(CTP ctp) {
        CTParaRPr ctrpr = getOrCreateCTRPr(ctp);
        return ctrpr.isSetSzCs() ? ctrpr.getSzCs() : ctrpr.addNewSzCs();
    }
    
    /**
     * 获取或者创建字体大小对象
     *
     * @param ctp Word段落对象
     * @return 字体大小对象
     */
    private CTHpsMeasure getOrCreateSz(final CTP ctp) {
        CTParaRPr ctrpr = getOrCreateCTRPr(ctp);
        return ctrpr.isSetSz() ? ctrpr.getSz() : ctrpr.addNewSz();
    }
    
    /**
     * 获取或者创建字体
     *
     * @param ctp Word段落对象
     * @return 段落字体
     */
    private CTFonts getOrCreateFonts(final CTP ctp) {
        CTParaRPr ctrpr = getOrCreateCTRPr(ctp);
        return ctrpr.isSetRFonts() ? ctrpr.getRFonts() : ctrpr.addNewRFonts();
    }
    
    /**
     * 获取或者创建CTRPr（Run 属性集合）
     *
     * @param ctp Word段落对象
     * @return CTRPr（Run 属性集合）
     */
    private CTParaRPr getOrCreateCTRPr(final CTP ctp) {
        CTPPr ctppr = getOrCreatePPr(ctp);
        return ctppr.isSetRPr() ? ctppr.getRPr() : ctppr.addNewRPr();
    }
    
    /**
     * 设置段落的水平对齐方式
     *
     * 
     * @param ctp Word段落对象
     * @param halign 水平对齐
     */
    private void setParagraphAlign(final CTP ctp, final HAlign halign) {
        CTJc jc = getOrCreateCTJc(ctp);
        jc.setVal(halign.getValue());
    }
    
    /**
     * 获取或者创建CTJc（段落对齐对象）
     *
     * @param ctp 段落
     * @return CTJc（段落对齐对象）
     */
    private CTJc getOrCreateCTJc(final CTP ctp) {
        CTPPr ppr = getOrCreatePPr(ctp);
        return ppr.isSetJc() ? ppr.getJc() : ppr.addNewJc();
    }
    
    /**
     * 获取或者创建CTPPr（段落属性配置）
     * 
     * @param ctp OpenXml段落对象
     * @return CTPPr（段落属性配置）
     */
    private CTPPr getOrCreatePPr(final CTP ctp) {
        return ctp.isSetPPr() ? ctp.getPPr() : ctp.addNewPPr();
    }
    
    /**
     * 获取或者创建CTSectPr（章节属性配置）
     *
     * @param paragraph XWPFDocument文档段落对象
     * @return CTSectPr(章节属性配置)
     */
    private CTSectPr getOrCreateSectPr(final XWPFParagraph paragraph) {
        CTPPr ppr = this.getOrCreatePPr(paragraph.getCTP());
        return ppr.isSetSectPr() ? ppr.addNewSectPr() : ppr.addNewSectPr();
    }
    
    /**
     * 获取或者创建CTString（段落样式配置）
     *
     * @param ctp OpenXml段落对象
     * @return CTString（段落样式配置）
     */
    private CTString getOrCreatePStyle(CTP ctp) {
        CTPPr ppr = getOrCreatePPr(ctp);
        return ppr.isSetPStyle() ? ppr.getPStyle() : ppr.addNewPStyle();
    }
    // #region_end Docx中段落的设置 --------------------------------------------------
}
