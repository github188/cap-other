/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.parse.parser;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.xwpf.usermodel.BodyElementType;
import org.apache.poi.xwpf.usermodel.BodyType;
import org.apache.poi.xwpf.usermodel.IBody;
import org.apache.poi.xwpf.usermodel.IBodyElement;
import org.apache.poi.xwpf.usermodel.XWPFAbstractNum;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFNum;
import org.apache.poi.xwpf.usermodel.XWPFParagraph;
import org.apache.poi.xwpf.usermodel.XWPFRun;
import org.apache.poi.xwpf.usermodel.XWPFTableCell;
import org.apache.poi.xwpf.usermodel.XWPFTableRow;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTDecimalNumber;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTHyperlink;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTLvl;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTNumPr;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTOnOff;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTPPr;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTSectPr;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTStyle;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.STMerge;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.STOnOff;

import com.comtop.cap.document.word.docconfig.datatype.ChapterType;
import com.comtop.cap.document.word.docconfig.datatype.OutlineLevel;
import com.comtop.cap.document.word.docconfig.model.DCChapter;
import com.comtop.cap.document.word.docconfig.model.DCSection;
import com.comtop.cap.document.word.docconfig.model.DocConfig;
import com.comtop.cap.document.word.docmodel.data.Chapter;
import com.comtop.cap.document.word.docmodel.data.Container;
import com.comtop.cap.document.word.docmodel.data.Paragraph;
import com.comtop.cap.document.word.docmodel.data.ParagraphSet;
import com.comtop.cap.document.word.docmodel.data.Section;
import com.comtop.cap.document.word.docmodel.data.WordDocument;
import com.comtop.cap.document.word.docmodel.data.WordElement;
import com.comtop.cap.document.word.parse.ListContext;
import com.comtop.cap.document.word.parse.ListItemContext;
import com.comtop.cap.document.word.parse.util.ExprUtil;
import com.comtop.cap.document.word.parse.util.ValueUtil;
import com.comtop.cap.document.word.parse.util.XWPFTableUtil;

/**
 * 段落转换器
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年10月16日 lizhiyong
 */
public class ParagraphParser extends DefaultParser {
    
    /** runs */
    private RunsParser runsParser;
    
    /** Map of w:numId and ListContext */
    private Map<Integer, ListContext> listContextMap;
    
    /** 目录章节标题样式 */
    private final Pattern DIR_PATTERN;
    
    /** 没有数据的文本 */
    private final Pattern NULL_VALUE_PATTERN;
    
    /** 标记文本样式正则 */
    private final Pattern MAKR_TEXT_PATTERN;
    
    /** 顺序列表的文本样式 */
    private static final Pattern OL_TEXT_PATTERN = Pattern.compile("[0-9一二三四五六七八九十百千万]");
    
    /**
     * 
     * 构造函数
     * 
     * @param document poi 文档
     * @param doc word文档
     */
    public ParagraphParser(XWPFDocument document, WordDocument doc) {
        super(document, doc);
        runsParser = new RunsParser(document, doc);
        MAKR_TEXT_PATTERN = this.doc.getDocConfig().getMarkTextPattern();
        NULL_VALUE_PATTERN = this.doc.getDocConfig().getNullValueTextPattern();
        DIR_PATTERN = this.doc.getDocConfig().getDirTextPattern();
    }
    
    /**
     * @return 获取 runsConverter属性值
     */
    public RunsParser getRunsConverter() {
        return runsParser;
    }
    
    /**
     * @param runsParser 设置 runsParser 属性值为参数值 runsParser
     */
    public void setRunsConverter(RunsParser runsParser) {
        this.runsParser = runsParser;
    }
    
    /**
     * Visit the given paragraph.
     * 
     * @param preElement 前一个元素
     * @param paragraph 段落
     * @param index 索引
     * @return WordElement
     * 
     */
    public WordElement visitParagraph(XWPFParagraph paragraph, int index, WordElement preElement) {
        if (pageBreakOnNextParagraph) {
            pageBreak();
        }
        this.pageBreakOnNextParagraph = false;
        
        // 判断当前段落是否是个分节
        CTPPr ctpPr = paragraph.getCTP().getPPr();
        if (ctpPr != null) {
            CTSectPr ctSectPr = ctpPr.getSectPr();
            if (ctSectPr != null) {
                // 结束前一个Section。
                ExprUtil.endSectionContent(expExecuter, this.doc.getCurrentSection());
                Section section = new Section();
                this.doc.addChildElement(section);
                this.doc.locateNextSection();
                DCSection definition = this.doc.getDocConfig().locateNextSection();
                if (definition == null) {
                    definition = this.doc.getDocConfig().createNewSection(null);
                }
                section.setDocument(this.doc);
                section.setDefinition(definition);
                section.setUri(definition.getUri());
                section.setName(definition.getName());
                return section;
            }
        }
        String pText = paragraph.getText();
        // 不为null 或“” ， 如果是目录标题，如果是标记文本 如果是 空值 直接返回
        if (StringUtils.isNotBlank(pText)
            && (NULL_VALUE_PATTERN.matcher(pText).find() || MAKR_TEXT_PATTERN.matcher(pText).find() || DIR_PATTERN
                .matcher(pText).find())) {
            return null;
        }
        
        // 如果有超链接，表示当前段落元素为目录
        List<CTHyperlink> lstHyperlink = paragraph.getCTP().getHyperlinkList();
        if (lstHyperlink != null && lstHyperlink.size() > 0) {
            return null;
        }
        CTNumPr numPr = getNumPr(paragraph);
        ListItemContext itemContext = getListItemContext(numPr, paragraph);
        if (StringUtils.isNotBlank(pText)) {
            Chapter chapter = visitChapter(paragraph, itemContext);
            if (chapter != null) {
                return chapter;
            }
        }
        
        ParagraphSet paragraphSet = null;
        if (preElement instanceof ParagraphSet) {
            paragraphSet = (ParagraphSet) preElement;
        } else {
            paragraphSet = new ParagraphSet();
            Chapter lastChapter = this.doc.getCurrentSection().getLastChapter();
            if (lastChapter != null) {
                lastChapter.addChildElement(paragraphSet);
            } else {
                this.doc.getCurrentSection().addChildElement(paragraphSet);
            }
        }
        
        Paragraph pContainer = new Paragraph();
        if (numPr != null && itemContext != null) {
            // numPr.getIlvl() 为空，表明可能是图或表的编号 ，不处理
            if (numPr.getIlvl() != null) {
                pContainer.setList(true);
                pContainer.setListLevel(numPr.getIlvl().getVal());
                pContainer.setListKey(numPr.getNumId().getVal());
                pContainer.setOl(OL_TEXT_PATTERN.matcher(itemContext.getLvl().getLvlText().getVal()).find());
            }
        }
        
        pContainer.setContainer(paragraphSet.getContainer());
        visitParagraphBody(paragraph, pContainer, index);
        if (pContainer.getContents().size() > 0) {
            paragraphSet.addChildContentSeg(pContainer);
        }
        return paragraphSet;
    }
    
    /**
     * Visit the given paragraph.
     * 
     * @param paragraphSet 前一个元素
     * @param paragraph 段落
     * @param index 索引
     * 
     */
    public void visitParagraphInTableCell(XWPFParagraph paragraph, int index, ParagraphSet paragraphSet) {
        String pText = ValueUtil.getValue(paragraph.getText());
        // 如果空值 直接返回
        if (StringUtils.isNotBlank(pText) && (NULL_VALUE_PATTERN.matcher(pText).find())) {
            return;
        }
        CTNumPr numPr = getNumPr(paragraph);
        ListItemContext itemContext = getListItemContext(numPr, paragraph);
        
        Paragraph pContainer = new Paragraph();
        if (numPr != null && itemContext != null) {
            // numPr.getIlvl() 为空，表明可能是图或表的编号 ，不处理
            if (numPr.getIlvl() != null) {
                pContainer.setList(true);
                pContainer.setListLevel(numPr.getIlvl().getVal());
                pContainer.setListKey(numPr.getNumId().getVal());
                pContainer.setOl(OL_TEXT_PATTERN.matcher(itemContext.getLvl().getLvlText().getVal()).find());
            }
        }
        
        pContainer.setContainer(paragraphSet.getContainer());
        visitParagraphBody(paragraph, pContainer, index);
        if (pContainer.getContents().size() > 0) {
            paragraphSet.addChildContentSeg(pContainer);
        }
    }
    
    /**
     * 解析段落
     *
     * @param paragraph 段落
     * @param itemContext 列表上下文
     * @return 当前段落容器
     */
    private Chapter visitChapter(XWPFParagraph paragraph, ListItemContext itemContext) {
        Section cursection = this.doc.getCurrentSection();
        String pText = ValueUtil.getValue(paragraph.getText());
        String numText = null;
        if (itemContext != null) {
            numText = itemContext.getText();
        }
        OutlineLevel outlineLevel = getOutlineLevel(paragraph);
        // 有些非标题的段落，大纲级别为0.如果按后续查找上级章节的逻辑，会将其直接挂到根目录下。
        if (StringUtils.isBlank(numText) && outlineLevel == OutlineLevel.LEVEL0) {
            // outlineLevel = OutlineLevel.LEVEL8;
            checkLogger.errorText(pText, "文本大纲级别错误，无法识别其层次结构");
        }
        boolean isChapterTitle = (outlineLevel != OutlineLevel.LEVEL10 && outlineLevel != OutlineLevel.LEVEL9);
        // 如果当前段落是一个标题
        if (!isChapterTitle) {
            return null;
        }
        Chapter chapter = new Chapter();
        chapter.setTitle(pText);
        chapter.setChapterNo(numText);
        chapter.setDocument(this.doc);
        chapter.setOutlineLevel(outlineLevel);
        Chapter parentChapter = cursection.getLastParentChapter(outlineLevel);
        if (parentChapter != null) {
            // chapter.setUri(parentChapter.getUri() + "/" + chapter.getTitle());
            chapter.setParentChapter(parentChapter);
            parentChapter.addChildElement(chapter);
        } else {
            // 如果当前分节的章节为0，将第一个章节前面的属于分节的内容进行保存。
            if (cursection.getChapters().size() == 0) {
                ExprUtil.endSectionContent(expExecuter, cursection);
            }
            cursection.addChildElement(chapter);
        }
        calculateChapterDef(chapter);
        // 开始当前章节
        ExprUtil.startChapter(expExecuter, chapter);
        return chapter;
    }
    
    /**
     * 获得列表 上下文
     *
     * @param numId id
     * @return 列表上下文集
     */
    private ListContext getListContext(int numId) {
        if (listContextMap == null) {
            listContextMap = new HashMap<Integer, ListContext>();
        }
        ListContext listContext = listContextMap.get(numId);
        if (listContext == null) {
            listContext = new ListContext();
            listContextMap.put(numId, listContext);
        }
        return listContext;
    }
    
    /**
     * 获得当前段落的列表上下文
     * 
     * @param originalNumPr Number属性
     *
     * @param paragraph 段落
     * @return 列表上下文
     */
    private ListItemContext getListItemContext(CTNumPr originalNumPr, XWPFParagraph paragraph) {
        ListItemContext itemContext = null;
        // CTNumPr originalNumPr = getNumPr(paragraph);
        CTNumPr numPr = getNumPr(originalNumPr);
        if (numPr != null && originalNumPr != null) {
            /**
             * <w:num w:numId="2"> <w:abstractNumId w:val="1" /> </w:num>
             */
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
                
                // get the <w:lvl by using abstractNum and numPr level
                /**
                 * <w:num w:numId="2"> <w:abstractNumId w:val="1" /> </w:num>
                 */
                CTDecimalNumber ilvl = numPr.getIlvl();
                int level = ilvl != null ? ilvl.getVal().intValue() : 0;
                
                CTLvl lvl = abstractNum.getAbstractNum().getLvlArray(level);
                if (lvl != null) {
                    ListContext listContext = getListContext(originalNumPr.getNumId().getVal().intValue());
                    itemContext = listContext.addItem(lvl);
                }
            }
            
        }
        return itemContext;
    }
    
    /**
     * 获得段落的大纲级别
     *
     * @param paragraph 段落
     * @return 大纲级别 值10表示为正文
     */
    private OutlineLevel getOutlineLevel(XWPFParagraph paragraph) {
        if (paragraph.getStyleID() != null && !"".equals(paragraph.getStyleID().trim())) {
            CTStyle ctStyle = stylesDocument.getStyle(paragraph.getStyleID()).getCTStyle();
            if (ctStyle != null && ctStyle.getPPr() != null) {
                CTDecimalNumber outlineLevelNumber = ctStyle.getPPr().getOutlineLvl();
                if (outlineLevelNumber != null) {
                    return OutlineLevel.getOutlineLevel(outlineLevelNumber.getVal().intValue());
                }
                // 对于某些段落，样式中没有定义大约级别，段落本身的属性上会定义大纲级别
                outlineLevelNumber = paragraph.getCTP().getPPr().getOutlineLvl();
                if (outlineLevelNumber != null) {
                    return OutlineLevel.getOutlineLevel(outlineLevelNumber.getVal().intValue());
                }
            }
        }
        return OutlineLevel.LEVEL10;
    }
    
    /**
     * 
     * 计算章节定义
     *
     * @param chapter 当前章节
     * @return 章节定义
     */
    private DCChapter calculateChapterDef(Chapter chapter) {
        DCChapter chapterDef = null;
        DCChapter parentChapterDef = null;
        DocConfig docConfig = this.doc.getDocConfig();
        DCSection parentDef = docConfig.getCurrentSection();
        if (chapter.getParentChapter() == null) {
            chapterDef = getChapterDef(chapter, parentDef.getChapters());
        } else {
            parentChapterDef = (DCChapter) chapter.getParentChapter().getDefinition();
            // if (parentChapterDefinition == null) {
            // return;
            // }
            chapterDef = getChapterDef(chapter, parentChapterDef.getChildChapters());
        }
        
        if (chapterDef == null) {
            chapterDef = new DCChapter();
            chapterDef.setChapterType(ChapterType.FIXED);
            chapterDef.setTitle(chapter.getTitle());
            if (parentChapterDef != null) {
                parentChapterDef.addChildElement(chapterDef);
            } else {
                parentDef.addChildElement(chapterDef);
            }
            // chapterDef.setParent(parentDef);
            chapterDef.setDocConfig(docConfig);
            chapterDef.initConfig();
            docConfig.incrementModifyTimes();
            checkLogger.warnChapter(chapter, "文档未找到章节定义");
        }
        chapter.setDefinition(chapterDef);
        if (ChapterType.FIXED == chapterDef.getChapterType()) {
            setFixedChapterUri(chapter);
        }
        return chapterDef;
    }
    
    /**
     * 获得章节的Uri
     *
     * @param chapter 章节对象
     */
    private static void setFixedChapterUri(Chapter chapter) {
        DCChapter definition = (DCChapter) chapter.getDefinition();
        Container container = chapter.getParent();
        String uri = chapter.getParent() == null ? definition.getFixedTitle() : container.getUri() + "/"
            + definition.getFixedTitle();
        chapter.setUri(uri);
        chapter.setUriName(uri);
        return;
    }
    
    /**
     * 获得章节的定义信息
     * 对模板定义有要求：1）一个章节下中只有一个动态章节 2）动态章节一定在最后。
     * 
     * @param chapter 当前章节
     * @param chapterDefs 章节定义集
     * @return 章节定义
     */
    private DCChapter getChapterDef(Chapter chapter, List<DCChapter> chapterDefs) {
        for (DCChapter chapterDef : chapterDefs) {
            if (chapterDef.getChapterType() == ChapterType.FIXED) {
                boolean match = StringUtils.equals(chapter.getTitle(), chapterDef.getTitle());
                if (match) {
                    return chapterDef;
                }
            }
        }
        
        for (DCChapter chapterDef : chapterDefs) {
            if (chapterDef.getChapterType() == ChapterType.FIXED) {
                // 如果标题、编号、level均相等，表明是固定章节，且能够匹配上。
                if (matchString(chapterDef.getTitlePattern(), chapter.getTitle())) {
                    // 是否需要判断level相等？？
                    return chapterDef;
                }
            }
            
            // 不能够匹配上，如果当前章节是动态章节
            if (chapterDef.getChapterType() == ChapterType.DYNAMIC) {
                return chapterDef;
                // 按照规则，一个章节下的同级子章节中，只有一个动态章节，并且动态章节一定是在最后。因此当扫描到动态章节时，直接对应。
                // 后续需要仔细识别规则，尽可能做得完善。本段后面注释的代码暂时不要删除，后面完善时需要用到。
                // Chapter preWtChapter = getPreChapterDef(chapter);
                // 如果没有前一个章节，表示当前章节为第一个章节（假设动态章节一定存在）
                // if (preWtChapter == null) {
                // return chapterDef;
                // }
                
                // 如果前一个章节是固定章节,表明当前 章节刚好对应到动态章节上（假设动态章节一定存在）。
                // if (preWtChapter.getChapterType() == ChapterType.FIXED) {
                // return chapterDef;
                // }
            }
        }
        return null;
    }
    
    /**
     * 章节是否匹配章节定义
     *
     * @param chapter 当前章节
     * @param chapterDef 章节定义
     * @return true 匹配 false 不匹配
     */
    protected boolean matchChapter(Chapter chapter, DCChapter chapterDef) {
        boolean match = StringUtils.equals(chapter.getTitle(), chapterDef.getTitle());
        // 是否需要判断编号 、大纲级别，后续确定
        // StringUtils.equals(chapterDef.getChapterNo(), chapter.getChapterNo()
        // StringUtils.equals(chapterDef.getChapterNo(), chapter.getChapterNo()
        return match ? true : matchString(chapterDef.getTitlePattern(), chapter.getTitle());
    }
    
    /**
     * 匹配字符串
     *
     * @param regex 模式字符串
     * @param input 待匹配字符串
     * @return true 表示能够匹配 false不能够匹配
     */
    private boolean matchString(Pattern regex, String input) {
        if (regex == null || StringUtils.isEmpty(input)) {
            return false;
        }
        boolean match = regex.matcher(input).find();
        // 反向匹配，很多情况可能不必要，先注释
        // if (!match) {
        // pattern = Pattern.compile(input2);
        // match = pattern.matcher(input1).find();
        // }
        return match;
    }
    
    /**
     * 获得前一章节的定义
     *
     * @param chapter 当前章节
     * @return Chapter 前一章节的定义。如果不存在前一章节，返回null。
     */
    protected DCChapter getPreChapterDef(Chapter chapter) {
        if (chapter.getParent() == null) {
            return null;
        }
        List<Chapter> chapters = chapter.getParentChapter().getChildChapters();
        int size = chapters.size();
        return size == 0 ? null : (DCChapter) chapters.get(size - 1).getDefinition();
    }
    
    /**
     * 访问段落体
     *
     * @param paragraph 段落
     * @param container 容器
     * @param index 索引
     */
    private void visitParagraphBody(XWPFParagraph paragraph, Paragraph container, int index) {
        List<XWPFRun> runs = paragraph.getRuns();
        // fixParagraphText(paragraph, preElement, pText);
        if (runs.isEmpty()) {
            // a new line must be generated if :
            // - there is next paragraph/table
            // - if the body is a cell (with none vMerge) and contains just this paragraph
            if (isAddNewLine(paragraph, index)) {
                runsParser.visitEmptyRun();
            }
            
            // sometimes, POI tells that run is empty
            // but it can be have w:r in the w:pPr
            // <w:p><w:pPr .. <w:r> => See the header1.xml of DocxBig.docx ,
            // => test if it exist w:r
            // CTP p = paragraph.getCTP();
            // CTPPr pPr = p.getPPr();
            // if (pPr != null) {
            // XmlObject[] wRuns =
            // pPr.selectPath("declare namespace w='http://schemas.openxmlformats.org/wordprocessingml/2006/main' .//w:r");
            // if (wRuns != null) {
            // for ( int i = 0; i < wRuns.length; i++ )
            // {
            // XmlObject o = wRuns[i];
            // o.getDomNode().getParentNode()
            // if (o instanceof CTR) {
            // System.err.println(wRuns[i]);
            // }
            //
            // }
            // }
            // }
            // //XmlObject[]WordElement =
            // o.selectPath("declare namespace w='http://schemas.openxmlformats.org/wordprocessingml/2006/main' .//w:t");
            // //paragraph.getCTP().get
        } else {
            // Loop for each element of <w:r, w:fldSimple
            // to keep the order of those elements.
            runsParser.visitRuns(paragraph, container);
        }
        
        // Page Break
        // Cannot use paragraph.isPageBreak() because it throws NPE because
        // pageBreak.getVal() can be null.
        CTPPr ppr = paragraph.getCTP().getPPr();
        if (ppr != null) {
            if (ppr.isSetPageBreakBefore()) {
                CTOnOff pageBreak = ppr.getPageBreakBefore();
                if (pageBreak != null
                    && (pageBreak.getVal() == null || pageBreak.getVal().intValue() == STOnOff.INT_TRUE)) {
                    pageBreak();
                }
            }
        }
    }
    
    /**
     * Returns true if the given paragraph which is empty (none <w:r> run) must generate new line and false otherwise.
     * 
     * @param paragraph paragraph
     * @param index index
     * @return boolean
     */
    protected boolean isAddNewLine(XWPFParagraph paragraph, int index) {
        // a new line must be generated if :
        // - there is next paragraph/table
        // - if the body is a cell (with none vMerge) and contains just this paragraph
        IBody body = paragraph.getBody();
        List<IBodyElement> bodyElements = body.getBodyElements();
        if (body.getPartType() == BodyType.TABLECELL && bodyElements.size() == 1) {
            XWPFTableCell cell = (XWPFTableCell) body;
            STMerge.Enum vMerge = XWPFTableUtil.getTableCellVMerge(cell.getCTTc());
            if (vMerge != null && vMerge.equals(STMerge.CONTINUE)) {
                // here a new line must not be generated because the body is a cell (with none vMerge) and contains just
                // this paragraph
                return false;
            }
            // Loop for each cell of the row : if all cells are empty, new line must be generated otherwise none empty
            // line must be generated.
            XWPFTableRow row = cell.getTableRow();
            List<XWPFTableCell> cells = row.getTableCells();
            for (XWPFTableCell c : cells) {
                if (c.getBodyElements().size() != 1) {
                    return false;
                }
                IBodyElement element = c.getBodyElements().get(0);
                if (element.getElementType() != BodyElementType.PARAGRAPH) {
                    return false;
                }
                return ((XWPFParagraph) element).getRuns().size() == 0;
            }
            return true;
            
        }
        // here a new line must be generated if there is next paragraph/table
        return bodyElements.size() > index + 1;
    }
    
    /**
     * 分页处理
     *
     */
    protected void pageBreak() {
        // 暂不处理
    }
}
