/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.write.writer;

import static com.comtop.cap.document.util.ObjectUtils.clean;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.xwpf.usermodel.XWPFParagraph;
import org.jsoup.nodes.Element;
import org.jsoup.nodes.Node;

import com.comtop.cap.document.word.write.DocxExportConfiguration;
import com.comtop.cap.document.word.write.DocxHelper;

/**
 * HTML span标签写入
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月26日 lizhongwen
 */
public class TagSpanWriter extends TagWriter {
    
    /**
     * 添加到指定段落
     * 
     * @param config 文档导出配置
     * @param paragraph 文档段落对象
     * @param node HTML节点
     * @param uri 文档URI
     * @see com.comtop.cap.document.word.write.writer.TagWriter#append(com.comtop.cap.document.word.write.DocxExportConfiguration,
     *      org.apache.poi.xwpf.usermodel.XWPFParagraph, org.jsoup.nodes.Node, java.lang.String)
     */
    @Override
    public void append(final DocxExportConfiguration config, final XWPFParagraph paragraph, final Node node,
        final String uri) {
        Element span = (Element) node;
        DocxHelper helper = DocxHelper.getInstance();
        String str = clean(span.text());
        if (StringUtils.isBlank(str)) {
            return;
        }
        helper.appendTextInParagraph(paragraph, str);
    }
    
}
