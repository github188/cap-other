/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.parse.parser;

import java.util.List;

import org.apache.poi.openxml4j.opc.PackagePart;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFPictureData;
import org.apache.xmlbeans.XmlCursor;
import org.apache.xmlbeans.XmlObject;
import org.openxmlformats.schemas.drawingml.x2006.main.CTGraphicalObject;
import org.openxmlformats.schemas.drawingml.x2006.main.CTGraphicalObjectData;
import org.openxmlformats.schemas.drawingml.x2006.picture.CTPicture;
import org.openxmlformats.schemas.drawingml.x2006.wordprocessingDrawing.CTAnchor;
import org.openxmlformats.schemas.drawingml.x2006.wordprocessingDrawing.CTInline;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTDrawing;

import com.comtop.cap.component.loader.FileLocation;
import com.comtop.cap.component.loader.config.CapFileType;
import com.comtop.cap.document.word.docmodel.data.Graphic;
import com.comtop.cap.document.word.docmodel.data.Paragraph;
import com.comtop.cap.document.word.docmodel.data.WordDocument;

/**
 * 图形 转换器
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年10月16日 lizhiyong
 */
public class GraphicParser extends DefaultParser {
    
    /**
     * 
     * 构造函数
     * 
     * @param document poi 文档
     * @param doc word文档
     */
    public GraphicParser(XWPFDocument document, WordDocument doc) {
        super(document, doc);
    }
    
    /**
     * 解析drawing元素
     *
     * @param drawing 图形元素
     * @param container 容器
     */
    public void visitDrawing(CTDrawing drawing, Paragraph container) {
        List<CTInline> inlines = drawing.getInlineList();
        for (CTInline inline : inlines) {
            visitInline(inline, container);
        }
        List<CTAnchor> anchors = drawing.getAnchorList();
        for (CTAnchor anchor : anchors) {
            visitAnchor(anchor, container);
        }
    }
    
    /**
     * 解析anchor元素
     *
     * @param anchor 图形元素
     * @param container 容器
     */
    protected void visitAnchor(CTAnchor anchor, Paragraph container) {
        CTGraphicalObject graphic = anchor.getGraphic();
        
        // STRelFromH.Enum relativeFromH = null;
        // Float offsetX = null;
        // CTPosH positionH = anchor.getPositionH();
        // if (positionH != null) {
        // relativeFromH = positionH.getRelativeFrom();
        // offsetX = DxaUtil.emu2points(positionH.getPosOffset());
        // }
        //
        // STRelFromV.Enum relativeFromV = null;
        // Float offsetY = null;
        // CTPosV positionV = anchor.getPositionV();
        // if (positionV != null) {
        // relativeFromV = positionV.getRelativeFrom();
        // offsetY = DxaUtil.emu2points(positionV.getPosOffset());
        // }
        //
        // STWrapText.Enum wrapText = null;
        // CTWrapSquare wrapSquare = anchor.getWrapSquare();
        // if (wrapSquare != null) {
        // wrapText = wrapSquare.getWrapText();
        // }
        
        visitGraphicalObject(graphic, container);
    }
    
    /**
     * 解析inline元素
     *
     * @param inline 图形元素
     * @param container 容器
     */
    protected void visitInline(CTInline inline, Paragraph container) {
        CTGraphicalObject graphic = inline.getGraphic();
        visitGraphicalObject(graphic, container);
    }
    
    /**
     * 解析graphic元素
     *
     * @param graphic 图形元素
     * @param container 容器
     */
    private void visitGraphicalObject(CTGraphicalObject graphic, Paragraph container) {
        if (graphic != null) {
            CTGraphicalObjectData graphicData = graphic.getGraphicData();
            if (graphicData != null) {
                XmlCursor c = graphicData.newCursor();
                c.selectPath("./*");
                while (c.toNextSelection()) {
                    XmlObject o = c.getObject();
                    if (o instanceof CTPicture) {
                        CTPicture picture = (CTPicture) o;
                        // visit the picture.
                        visitPicture(picture, container);
                    }
                }
                c.dispose();
            }
        }
    }
    
    /**
     * 解析picture元素
     *
     * @param picture 图形元素
     * @param container 容器
     */
    protected void visitPicture(CTPicture picture, Paragraph container) {
        
        XWPFPictureData pictureData = getPictureData(picture);
        PackagePart part = null;
        if (pictureData != null) {
            long width = picture.getSpPr().getXfrm().getExt().getCx();
            long height = picture.getSpPr().getXfrm().getExt().getCy();
            part = pictureData.getPackagePart();
            // 将同级的上一个文本段落模型化
            Graphic graphic = new Graphic();
            String documentId = container.getContainer().getDocument().getId();
            FileLocation location = writeDocumentPartToDisk(part, CapFileType.DOC_EMBED, documentId, getPartName(part));
            graphic.setWebPath(location.toHttpUrlString());
            graphic.setType(part.getContentType());
            graphic.setHeightAsEMU(height);
            graphic.setWidthAsEMU(width);
            container.addChildContentSeg(graphic);
        } else {
            // TODO
            // String link = picture.getBlipFill().getBlip().getLink();
            // try {
            // URI uri = document.getPackagePart().getRelationships().getRelationshipByID(link).getTargetURI();
            // } catch (Exception e) {
            // throw new WordParseException("", e);
            // }
        }
    }
    
    /**
     * Returns the picture data of the given image id.
     * 
     * @param blipId blipId
     * @return XWPFPictureData
     */
    protected XWPFPictureData getPictureDataByID(String blipId) {
        if (currentHeader != null) {
            return currentHeader.getPictureDataByID(blipId);
        }
        if (currentFooter != null) {
            return currentFooter.getPictureDataByID(blipId);
        }
        return document.getPictureDataByID(blipId);
    }
    
    /**
     * Returns the picture data of the given picture.
     * 
     * @param picture picture
     * @return XWPFPictureData
     */
    private XWPFPictureData getPictureData(CTPicture picture) {
        String blipId = picture.getBlipFill().getBlip().getEmbed();
        return getPictureDataByID(blipId);
    }
    
}
