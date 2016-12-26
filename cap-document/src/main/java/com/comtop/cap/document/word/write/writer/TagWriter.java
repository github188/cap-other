/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.write.writer;

import static com.comtop.cap.document.util.ObjectUtils.clean;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.A_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.TABLE_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.IMG_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.OL_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.P_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.SPAN_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.TEXT_NODE;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.UL_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.STRONG_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.BIG_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.CENTER_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.EM_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.SAMP_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.CITE_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.KBD_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.DFN_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.CODE_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.VAR_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.DEL_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.INS_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.SMALL_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.STRIKE_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.WBR_ELEMENT;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFParagraph;
import org.jsoup.nodes.Node;

import com.comtop.cap.document.word.write.DocxExportConfiguration;
import com.comtop.cap.document.word.write.DocxHelper;

/**
 * HTML标签写入器
 * 
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月26日 lizhongwen
 */
public abstract class TagWriter extends FragmentWriter<Node> implements
		ParagraphAppendWriter<Node> {

	/** 文本节点集合 */
	protected static final Set<String> TEXT_SET;

	/** 可写入节点集合 */
	protected static final Set<String> WRITABLE_SET;

	/** 可附加的节点集合 */
	protected static final Set<String> ADDITIVE_SET;

	static {
		TEXT_SET = new HashSet<String>();
		ADDITIVE_SET = new HashSet<String>();
		WRITABLE_SET = new HashSet<String>();
		TEXT_SET.add(SPAN_ELEMENT);
		TEXT_SET.add(TEXT_NODE);
		TEXT_SET.add(P_ELEMENT);

		ADDITIVE_SET.addAll(TEXT_SET);
		ADDITIVE_SET.add(IMG_ELEMENT);
		ADDITIVE_SET.add(A_ELEMENT);
		ADDITIVE_SET.add(STRONG_ELEMENT);
		ADDITIVE_SET.add(BIG_ELEMENT);
		ADDITIVE_SET.add(CENTER_ELEMENT);
		ADDITIVE_SET.add(EM_ELEMENT);
		ADDITIVE_SET.add(SAMP_ELEMENT);
		ADDITIVE_SET.add(CITE_ELEMENT);
		ADDITIVE_SET.add(KBD_ELEMENT);
		ADDITIVE_SET.add(DFN_ELEMENT);
		ADDITIVE_SET.add(CODE_ELEMENT);
		ADDITIVE_SET.add(VAR_ELEMENT);
		ADDITIVE_SET.add(DEL_ELEMENT);
		ADDITIVE_SET.add(INS_ELEMENT);
		ADDITIVE_SET.add(SMALL_ELEMENT);
		ADDITIVE_SET.add(STRIKE_ELEMENT);
		ADDITIVE_SET.add(WBR_ELEMENT);

		WRITABLE_SET.addAll(ADDITIVE_SET);
		WRITABLE_SET.add(TABLE_ELEMENT);
		WRITABLE_SET.add(OL_ELEMENT);
		WRITABLE_SET.add(UL_ELEMENT);
	}

	/**
	 * 根据文档配置写入HTML文档标签片段
	 * 
	 * @param config
	 *            文档导出配置
	 * @param docx
	 *            文档对象
	 * @param node
	 *            HTML文档标签配置元素
	 * @param uri
	 *            文档URI
	 * @see com.comtop.cap.document.word.write.writer.TagWriter#internalWrite(DocxExportConfiguration,
	 *      XWPFDocument, org.jsoup.nodes.Node, java.lang.String)
	 */
	@Override
	protected void internalWrite(final DocxExportConfiguration config,
			final XWPFDocument docx, final Node node, final String uri) {
		String nodeName = node.nodeName().toLowerCase();
		if (TEXT_SET.contains(nodeName)) {
			String cleaned = clean(node.toString());
			if (StringUtils.isBlank(cleaned)) {
				return;
			}
		}
		DocxHelper helper = DocxHelper.getInstance();
		XWPFParagraph paragraph = helper.createBodyParagraph(docx);
		this.append(config, paragraph, node, uri);
	}

	/**
	 * 根据文档配置写入文档HTML片段
	 * 
	 * @param config
	 *            文档导出配置
	 * @param docx
	 *            文档对象
	 * @param node
	 *            HTML元素
	 * @param uri
	 *            文档URI
	 */
	protected void writeNode(final DocxExportConfiguration config,
			final XWPFDocument docx, final Node node, final String uri) {
		String tag = node.nodeName().toLowerCase();
		List<Node> nodes = node.childNodes();
		IDocxFragmentWriter<Node> writer;
		if (WRITABLE_SET.contains(tag)) {
			writer = DocxFragmentWriterFactory.getFragementWriter(node, tag);
			writer.write(config, docx, node, uri);
		} else if (nodes != null && !nodes.isEmpty()) {
			for (Node n : nodes) {
				this.writeNode(config, docx, n, uri);
			}
		}
	}

	/**
	 * 添加到指定段落
	 * 
	 * @param config
	 *            文档导出配置
	 * @param paragraph
	 *            文档段落对象
	 * @param node
	 *            HTML节点
	 * @param uri
	 *            文档URI
	 * @see com.comtop.cap.document.word.write.writer.ParagraphAppendWriter#append(com.comtop.cap.document.word.write.DocxExportConfiguration,
	 *      org.apache.poi.xwpf.usermodel.XWPFParagraph, java.lang.Object,
	 *      java.lang.String)
	 */
	@Override
	public void append(final DocxExportConfiguration config,
			final XWPFParagraph paragraph, final Node node, final String uri) {
		String tag = node.nodeName().toLowerCase();
		List<Node> nodes = node.childNodes();
		if (ADDITIVE_SET.contains(tag)) {
			@SuppressWarnings("unchecked")
			ParagraphAppendWriter<Node> writer = (ParagraphAppendWriter<Node>) DocxFragmentWriterFactory
					.getFragementWriter(node, tag);
			writer.append(config, paragraph, node, uri);
		} else if (nodes != null && !nodes.isEmpty()) {
			for (Node n : nodes) {
				this.append(config, paragraph, n, uri);
			}
		}
	}

}
