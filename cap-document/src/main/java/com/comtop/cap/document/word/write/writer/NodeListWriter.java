/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.write.writer;

import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.LI_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.OL_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.START_ATTR;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.UL_ELEMENT;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.jsoup.nodes.Element;
import org.jsoup.nodes.Node;

import com.comtop.cap.document.word.write.DocxExportConfiguration;

/**
 * 列表节点写入器
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年1月14日 lizhongwen
 */
public abstract class NodeListWriter extends TagWriter {
    
    /**
     * 根据文档配置写入HTML文档标签片段
     *
     * @param config 文档导出配置
     * @param docx 文档对象
     * @param node HTML文档标签配置元素
     * @param uri 文档URI
     * @see com.comtop.cap.document.word.write.writer.TagWriter#internalWrite(DocxExportConfiguration, XWPFDocument,
     *      org.jsoup.nodes.Node, java.lang.String)
     * @see com.comtop.cap.document.word.write.writer.TagWriter#internalWrite(com.comtop.cap.document.word.write.DocxExportConfiguration,
     *      org.apache.poi.xwpf.usermodel.XWPFDocument, org.jsoup.nodes.Node, java.lang.String)
     */
    @Override
    protected void internalWrite(final DocxExportConfiguration config, final XWPFDocument docx, final Node node,
        final String uri) {
        this.writeList(config, docx, node, uri, 0);
    }
    
    /**
     * 写入项目列表
     *
     * @param config 文档导出配置
     * @param docx 文档对象
     * @param node HTML文档标签配置元素
     * @param uri 文档URI
     * @param level 项目级别
     */
    protected void writeList(final DocxExportConfiguration config, final XWPFDocument docx, final Node node,
        final String uri, final int level) {
        String tag;
        int tagStart = this.readStartNumber(node);
        int liCount = 0;
        IDocxFragmentWriter<Node> writer;
        for (int index = 0; index < node.childNodeSize(); index++) {
            Node child = node.childNode(index);
            tag = child.nodeName().toLowerCase();
            if (LI_ELEMENT.equals(tag)) { //
                String text = ((Element) child).text();
                this.writeListItem(docx, level, text, tagStart == 1 && liCount == 0);
                liCount++;
            } else if (OL_ELEMENT.equals(tag) || UL_ELEMENT.equals(tag)) {
                int start = readStartNumber(child);
                int lvl = start == 1 ? level + 1 : level;
                writer = DocxFragmentWriterFactory.getFragementWriter(child, tag);
                if (writer instanceof NodeListWriter) {
                    ((NodeListWriter) writer).writeList(config, docx, child, uri, lvl);
                }
            } else if (TEXT_SET.contains(tag)) {
                if (isBlankNode(child)) {
                    continue;
                }
                writer = DocxFragmentWriterFactory.getFragementWriter(child, tag);
                writer.write(config, docx, child, uri);
            }
        }
    }
    
    /**
     * 读取start属性的值
     *
     * @param node 节点
     * @return start 属性
     */
    private int readStartNumber(Node node) {
        String startAttr = node.attr(START_ATTR);
        int start = 1;
        if (StringUtils.isNotBlank(startAttr)) {
            try {
                start = Integer.parseInt(startAttr);
            } catch (NumberFormatException e) {
                getLogger().error(e.getMessage(), e);
            }
        }
        return start;
    }
    
    /**
     * 是否为空白的数据
     *
     * @param node 节点
     * @return 是否为空白节点
     */
    private boolean isBlankNode(final Node node) {
        String str = node.toString().replace("\r", "").replace("\n", "").trim();
        return StringUtils.isBlank(str);
    }
    
    /**
     * 写入列表项目
     *
     * @param docx 文档对象
     * @param level 项目级别
     * @param content 项目内容
     * @param isNew 是否重新开始
     */
    protected abstract void writeListItem(final XWPFDocument docx, final int level, final String content,
        final boolean isNew);
}
