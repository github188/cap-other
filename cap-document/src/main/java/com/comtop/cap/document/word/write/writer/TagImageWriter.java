/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.write.writer;

import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.HEIGHT_ATTR;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.SRC_ATTR;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.WIDTH_ATTR;
import static com.comtop.cap.document.word.util.MeasurementUnits.px2cm;

import java.io.InputStream;
import java.text.MessageFormat;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.poi.xwpf.usermodel.XWPFParagraph;
import org.jsoup.nodes.Node;

import com.comtop.cap.component.loader.FileLocation;
import com.comtop.cap.document.word.docmodel.data.Graphic;
import com.comtop.cap.document.word.write.DocxExportConfiguration;
import com.comtop.cap.document.word.write.DocxHelper;

/**
 * HTML A标签写入
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月26日 lizhongwen
 */
public class TagImageWriter extends TagWriter {
    
    /**
     * 添加到指定段落
     *
     * @param config 文档导出配置
     * @param paragraph 文档段落对象
     * @param node 配置元素
     * @param uri 文档URI
     * @see com.comtop.cap.document.word.write.writer.ParagraphAppendWriter#append(com.comtop.cap.document.word.write.DocxExportConfiguration,
     *      org.apache.poi.xwpf.usermodel.XWPFParagraph, java.lang.Object, java.lang.String)
     */
    @Override
    public void append(final DocxExportConfiguration config, final XWPFParagraph paragraph, final Node node,
        final String uri) {
        DocxHelper helper = DocxHelper.getInstance();
        String src = node.attr(SRC_ATTR);
        String widthAttr = node.attr(WIDTH_ATTR);
        String heightAttr = node.attr(HEIGHT_ATTR);
        Float width = StringUtils.isBlank(widthAttr) ? null : px2cm(Float.parseFloat(widthAttr));
        Float height = StringUtils.isBlank(heightAttr) ? null : px2cm(Float.parseFloat(heightAttr));
        FileLocation loacation = new FileLocation(src);
        InputStream input = null;
        try {
            input = loacation.toInputStream();
        } catch (Exception e) {
            getLogger().error(MessageFormat.format("下载图片''{0}''出错，请检查文件服务器.", src), e);
        }
        if (input == null) {
            getLogger().error(MessageFormat.format("找不到图片''{0}''，请检查文件服务器.", src));
            IOUtils.closeQuietly(input);
            return;
        }
        Graphic graphic = new Graphic(input, width, height);
        graphic.setPath(src);
        try {
            helper.createPricture(paragraph, graphic);
        } catch (Exception e) {
            getLogger().error(e.getMessage(), e);
        } finally {
            IOUtils.closeQuietly(input);
        }
    }
}
