/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.write.writer;

import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.HEIGHT_ATTR;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.HREF_ATTR;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.IMG_ELEMENT;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.SRC_ATTR;
import static com.comtop.cap.document.word.parse.tohtml.HTMLConstants.WIDTH_ATTR;
import static com.comtop.cap.document.word.util.MeasurementUnits.px2cm;

import java.io.InputStream;
import java.text.MessageFormat;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.poi.xwpf.usermodel.XWPFParagraph;
import org.jsoup.nodes.Element;
import org.jsoup.nodes.Node;
import org.jsoup.select.Elements;

import com.comtop.cap.component.loader.FileLocation;
import com.comtop.cap.document.word.docmodel.data.EmbedObject;
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
public class TagAWriter extends TagWriter {
    
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
    public void append(DocxExportConfiguration config, XWPFParagraph paragraph, Node node, String uri) {
        DocxHelper helper = DocxHelper.getInstance();
        Element tag = (Element) node;
        String href = tag.attr(HREF_ATTR);
        Elements elements = tag.getElementsByTag(IMG_ELEMENT);
        if (elements.size() > 0) {
            Element img = elements.get(0);
            String src = img.attr(SRC_ATTR);
            FileLocation loacation = new FileLocation(src);
            String widthAttr = img.attr(WIDTH_ATTR);
            String heightAttr = img.attr(HEIGHT_ATTR);
            Float width = StringUtils.isBlank(widthAttr) ? null : px2cm(Float.parseFloat(widthAttr));
            Float height = StringUtils.isBlank(heightAttr) ? null : px2cm(Float.parseFloat(heightAttr));
            InputStream graphicInput = null;
            try {
                graphicInput = loacation.toInputStream();
            } catch (Throwable e) {
                getLogger().error(MessageFormat.format("下载缩略图''{0}''出错，请检查文件服务器.", src), e);
            }
            if (graphicInput == null) {
                getLogger().error(MessageFormat.format("找不到缩略图''{0}''，请检查文件服务器.", src));
                IOUtils.closeQuietly(graphicInput);
                return;
            }
            Graphic graphic = new Graphic(graphicInput, width, height);
            graphic.setPath(src);
            FileLocation loc = new FileLocation(href);
            InputStream fileInput = null;
            try {
                fileInput = loc.toInputStream();
            } catch (Exception e) {
                getLogger().error(MessageFormat.format("下载文件''{0}''出错，请检查文件服务器.", href), e);
            }
            if (fileInput == null) {
                getLogger().error(MessageFormat.format("找不到文件''{0}''，请检查文件服务器.", href));
                IOUtils.closeQuietly(graphicInput);
                IOUtils.closeQuietly(fileInput);
                return;
            }
            EmbedObject file = new EmbedObject(fileInput, null, graphic);
            file.setPath(href);
            try {
                helper.createFileObject(paragraph, file);
            } catch (Exception e) {
                getLogger().error(e.getMessage(), e);
            } finally {
                IOUtils.closeQuietly(graphicInput);
                IOUtils.closeQuietly(fileInput);
            }
        }
        
    }
}
