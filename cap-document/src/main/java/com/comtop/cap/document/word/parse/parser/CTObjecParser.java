/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.parse.parser;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.xml.namespace.QName;

import org.apache.poi.POIXMLDocumentPart;
import org.apache.poi.openxml4j.opc.PackagePart;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.xmlbeans.SimpleValue;
import org.apache.xmlbeans.XmlCursor;
import org.apache.xmlbeans.XmlObject;
import org.apache.xmlbeans.impl.values.TypeStoreUser;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTObject;

import com.comtop.cap.component.loader.FileLocation;
import com.comtop.cap.component.loader.config.CapFileType;
import com.comtop.cap.document.word.docmodel.data.EmbedObject;
import com.comtop.cap.document.word.docmodel.data.Graphic;
import com.comtop.cap.document.word.docmodel.data.Paragraph;
import com.comtop.cap.document.word.docmodel.data.WordDocument;
import com.comtop.cap.document.word.docmodel.datatype.EmbedType;

/**
 * 嵌入式对象转换器
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年10月16日 lizhiyong
 */
public class CTObjecParser extends DefaultParser {
    
    /** 名字空间v */
    public static String namespaceV = "urn:schemas-microsoft-com:vml";
    
    /** 名字空间o */
    public static String namespaceO = "urn:schemas-microsoft-com:office:office";
    
    /** 名字空间r */
    public static String namespaceR = "http://schemas.openxmlformats.org/officeDocument/2006/relationships";
    
    /** qname id */
    private static final QName rid = new QName(namespaceR, "id");
    
    /** 图形样式 */
    private static final QName shapeStyle = new QName(null, "style");
    
    /** 程序 */
    private static final QName ProgID = new QName(null, "ProgID");
    
    /** 图片样式串 */
    private static final Pattern STYLE_PATTERN = Pattern.compile(
        "(width:(\\d{1,}(\\.\\d{1,}){0,1})pt).*(height:(\\d{1,}(\\.\\d{1,}){0,1})pt)", Pattern.CASE_INSENSITIVE);
    
    /*
     * <v:shapetype id="_x0000_t75" coordsize="21600,21600" o:spt="75" o:preferrelative="t"
     * path="m@4@5l@4@11@9@11@9@5xe" filled="f" stroked="f">
     * <v:stroke joinstyle="miter" />
     * - <v:formulas>
     * <v:f eqn="if lineDrawn pixelLineWidth 0" />
     * <v:f eqn="sum @0 1 0" />
     * <v:f eqn="sum 0 0 @1" />
     * <v:f eqn="prod @2 1 2" />
     * <v:f eqn="prod @3 21600 pixelWidth" />
     * <v:f eqn="prod @3 21600 pixelHeight" />
     * <v:f eqn="sum @0 0 1" />
     * <v:f eqn="prod @6 1 2" />
     * <v:f eqn="prod @7 21600 pixelWidth" />
     * <v:f eqn="sum @8 21600 0" />
     * <v:f eqn="prod @7 21600 pixelHeight" />
     * <v:f eqn="sum @10 21600 0" />
     * </v:formulas>
     * <v:path o:extrusionok="f" gradientshapeok="t" o:connecttype="rect" />
     * <o:lock v:ext="edit" aspectratio="t" />
     * </v:shapetype>
     * - <v:shape id="_x0000_i1030" type="#_x0000_t75" style="width:76.5pt;height:48pt" o:ole="">
     * <v:imagedata r:id="rId13" o:title="" />
     * </v:shape>
     * - <o:OLEObject Type="Embed" ProgID="Word.Document.8" ShapeID="_x0000_i1030" DrawAspect="Icon"
     * ObjectID="_1506440083" r:id="rId14">
     * <o:FieldCodes>\s</o:FieldCodes>
     * </o:OLEObject>
     * </w:object>
     */
    /**
     * 
     * 构造函数
     * 
     * @param document 文档
     * @param doc 文档模型
     */
    public CTObjecParser(XWPFDocument document, WordDocument doc) {
        super(document, doc);
    }
    
    /**
     * 
     * 访问对象元素
     *
     * @param ctObject 对象元素本身
     * @param container 容器
     */
    protected void visitObject(CTObject ctObject, Paragraph container) {
        // 将同级的上一个文本段落模型化
        EmbedObject embedObject = new EmbedObject();
        container.addChildContentSeg(embedObject);
        XmlCursor c = ctObject.newCursor();
        c.selectPath("child::*");
        while (c.toNextSelection()) {
            XmlObject o = c.getObject();
            if ("o:OLEObject".equals(o.getDomNode().getNodeName())) {
                visitOLEObject(o, embedObject);
            } else if ("v:shapetype".equals(o.getDomNode().getNodeName())) {
                visitShapetype(o, embedObject);
            } else if ("v:shape".equals(o.getDomNode().getNodeName())) {
                visitShape(o, embedObject);
            }
        }
    }
    
    /**
     * 
     * 访问形状元素
     * 
     * @param o 形状元素
     * @param embedObject 二进制内容模型
     */
    private void visitShape(XmlObject o, EmbedObject embedObject) {
        XmlCursor c = o.newCursor();
        Graphic graphic = new Graphic();
        embedObject.setPicture(graphic);
        TypeStoreUser store = (TypeStoreUser) o;
        SimpleValue localSimpleValue = (SimpleValue) store.get_store().find_attribute_user(shapeStyle);
        if (localSimpleValue != null) {
            Matcher matcher = STYLE_PATTERN.matcher(localSimpleValue.getStringValue());
            if (matcher.find()) {
                String width = matcher.group(2);
                String height = matcher.group(5);
                graphic.setWidthPt(Float.valueOf(width));
                graphic.setHeightPt(Float.valueOf(height));
            }
        }
        c.selectPath("child::*");
        while (c.toNextSelection()) {
            XmlObject o1 = c.getObject();
            if ("v:imagedata".equals(o1.getDomNode().getNodeName())) {
                visitImagedata(o1, embedObject, graphic);
            }
        }
        
    }
    
    /**
     * 访问图片元素数据
     * 
     * @param o 元素对象
     * @param embedObject 嵌入式对象
     * @param graphic 预览图
     */
    private void visitImagedata(XmlObject o, EmbedObject embedObject, Graphic graphic) {
        TypeStoreUser store = (TypeStoreUser) o;
        SimpleValue localSimpleValue = (SimpleValue) store.get_store().find_attribute_user(rid);
        POIXMLDocumentPart part = document.getRelationById(localSimpleValue.getStringValue());
        graphic.setType(part.getPackagePart().getContentType());
        PackagePart ppart = part.getPackagePart();
        String fileName = getPartName(ppart);
        String documentId = embedObject.getParagraphContainer().getContainer().getDocument().getId();
        FileLocation file = writeDocumentPartToDisk(ppart, CapFileType.DOC_EMBED, documentId, fileName);
        graphic.setWebPath(file.toHttpUrlString());
    }
    
    /**
     * 处理形状类型
     *
     * @param o 元素对象
     * @param embedObject 二进制内容元素
     */
    private void visitShapetype(XmlObject o, EmbedObject embedObject) {
        // 暂时无须处理
    }
    
    /**
     * 访问OleObject元素数据
     * 
     * @param o 元素对象
     * @param embedObject 二进制内容元素
     */
    private void visitOLEObject(XmlObject o, EmbedObject embedObject) {
        TypeStoreUser store = (TypeStoreUser) o;
        SimpleValue localSimpleValue = (SimpleValue) store.get_store().find_attribute_user(rid);
        POIXMLDocumentPart part = document.getRelationById(localSimpleValue.getStringValue());
        String fileName = getPartName(part.getPackagePart());
        
        localSimpleValue = (SimpleValue) store.get_store().find_attribute_user(ProgID);
        if (localSimpleValue != null) {
            embedObject.setProgId(localSimpleValue.getStringValue());
        } else {
            embedObject.setProgId("");
        }
        embedObject.setSubfix(EmbedType.byProgId(embedObject.getProgId()).getSubfix());
        fileName = fileName.substring(0, fileName.lastIndexOf(".")) + embedObject.getSubfix();
        String documentId = embedObject.getContainer().getDocument().getId();
        FileLocation location = writeDocumentPartToDisk(part.getPackagePart(), CapFileType.DOC_EMBED, documentId,
            fileName);
        embedObject.setWebPath(location.toHttpUrlString());
        embedObject.setType(part.getPackagePart().getContentType());
    }
}
