/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.write.writer;

import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.A_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.BIG_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.BODY_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.CENTER_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.CITE_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.CODE_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.DEL_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.DFN_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.EM_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.IMG_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.INS_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.KBD_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.OL_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.P_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.SAMP_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.SMALL_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.SPAN_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.STRIKE_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.STRONG_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.TABLE_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.TEXT_NODE;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.UL_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.VAR_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.WBR_ELEMENT;

import java.util.LinkedHashMap;
import java.util.Map;

import org.jsoup.nodes.Node;

import com.comtop.cap.document.word.docconfig.datatype.ChapterType;
import com.comtop.cap.document.word.docconfig.datatype.TableType;
import com.comtop.cap.document.word.docconfig.model.DCChapter;
import com.comtop.cap.document.word.docconfig.model.DCContentSeg;
import com.comtop.cap.document.word.docconfig.model.DCGraphic;
import com.comtop.cap.document.word.docconfig.model.DCSection;
import com.comtop.cap.document.word.docconfig.model.DCTable;
import com.comtop.cap.document.word.docmodel.data.ComplexSeg;
import com.comtop.cap.document.word.docmodel.data.Graphic;

/**
 * 文档片段写入工厂
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月23日 lizhongwen
 */
public class DocxFragmentWriterFactory {
    
    /** 片段写入器缓存 */
    private static final Map<String, IDocxFragmentWriter<?>> cache = new LinkedHashMap<String, IDocxFragmentWriter<?>>(
        20);
    
    /**
     * 构造函数
     */
    private DocxFragmentWriterFactory() {
    }
    
    static {
        String[] appendAbles = new String[] { STRONG_ELEMENT, BIG_ELEMENT, CENTER_ELEMENT, EM_ELEMENT, SAMP_ELEMENT,
            CITE_ELEMENT, KBD_ELEMENT, DFN_ELEMENT, CODE_ELEMENT, VAR_ELEMENT, DEL_ELEMENT, INS_ELEMENT, SMALL_ELEMENT,
            STRIKE_ELEMENT, WBR_ELEMENT };
        cache.put(DCSection.class.getSimpleName(), new SectionWriter());
        cache.put(DCTable.class.getSimpleName() + "_" + TableType.FIXED.name(), new FixedTableWriter());
        cache.put(DCTable.class.getSimpleName() + "_" + TableType.EXT_ROWS.name(), new ExpandRowTableWriter());
        cache.put(DCTable.class.getSimpleName() + "_" + TableType.EXT_COLS.name(), new ExpandColumnTableWriter());
        cache.put(DCTable.class.getSimpleName() + "_" + TableType.UNKNOWN.name(), new UnknownTableWriter());
        cache.put(DCChapter.class.getSimpleName() + "_" + ChapterType.FIXED.name(), new FixedChapterWriter());
        cache.put(DCChapter.class.getSimpleName() + "_" + ChapterType.DYNAMIC.name(), new DynamicChapterWriter());
        cache.put(DCContentSeg.class.getSimpleName(), new ContentSegmentWriter());
        cache.put(DCGraphic.class.getSimpleName(), new GraphicWriter());
        // cache.put(ComplexSeg.class.getSimpleName(), new ComplexSegmentWriter());
        // cache.put(DCText.class.getSimpleName(), new TextWriter());
        cache.put(String.class.getSimpleName(), new HTMLWriter());
        cache.put(TEXT_NODE, new NodeTextWriter());
        cache.put(BODY_ELEMENT, new TagBodyWriter());
        cache.put(P_ELEMENT, new TagPWriter());
        cache.put(A_ELEMENT, new TagAWriter());
        cache.put(SPAN_ELEMENT, new TagSpanWriter());
        cache.put(TABLE_ELEMENT, new TagTableWriter());
        cache.put(IMG_ELEMENT, new TagImageWriter());
        cache.put(OL_ELEMENT, new TagOLWriter());
        cache.put(UL_ELEMENT, new TagULWriter());
        TagAppendWriter appender = new TagAppendWriter();
        for (String tag : appendAbles) {
            cache.put(tag, appender);
        }
        cache.put(Graphic.class.getSimpleName(), new GraphicWriter());
    }
    
    /**
     * 文档片段写入器
     * @param <T> IDocxFragmentWriter
     * 
     * @param element 文档元素
     * @return 文档片段写入器
     */
    @SuppressWarnings("unchecked")
    public static <T> IDocxFragmentWriter<T> getFragementWriter(final T element) {
        String key;
        if (element instanceof DCTable) {
            DCTable table = (DCTable) element;
            key = table.getClass().getSimpleName() + "_" + table.getType().name();
        } else if (element instanceof DCChapter) {
            DCChapter chapter = (DCChapter) element;
            key = chapter.getClass().getSimpleName() + "_" + chapter.getChapterType().name();
        } else if (element instanceof ComplexSeg) {
            key = ComplexSeg.class.getSimpleName();
        } else {
            key = element.getClass().getSimpleName();
        }
        IDocxFragmentWriter<T> writer = (IDocxFragmentWriter<T>) cache.get(key);
        if (writer == null) {
            writer = new MockWriter<T>();
            cache.put(key, writer);
        }
        return writer;
    }
    
    /**
     * 文档片段写入器
     * @param <T> IDocxFragmentWriter
     * 
     * @param node html节点
     * @param tagName 标签名称
     * @return 文档片段写入器
     */
    @SuppressWarnings("unchecked")
    public static <T> IDocxFragmentWriter<T> getFragementWriter(final Node node, final String tagName) {
        IDocxFragmentWriter<T> writer = (IDocxFragmentWriter<T>) cache.get(tagName);
        if (writer == null) {
            writer = new MockWriter<T>();
            cache.put(tagName, writer);
        }
        return writer;
    }
}
