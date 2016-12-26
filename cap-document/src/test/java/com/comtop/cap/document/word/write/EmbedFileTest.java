/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.write;

import static com.comtop.cap.document.word.util.FolderUtil.projectOutputPath;
import static com.comtop.cap.document.word.util.FolderUtil.urlToPath;

import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.junit.Test;

import com.comtop.cap.document.word.docmodel.data.EmbedObject;
import com.comtop.cap.document.word.docmodel.data.Graphic;

/**
 * 向Word中插入文件测试
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年10月23日 lizhongwen
 */
public class EmbedFileTest {
    
    /**
     * 测试插入Excel 2003文档
     * 
     * @throws Exception 异常
     */
    @Test
    public void testEmbedXlsFile() throws Exception {
        DocxHelper helper = DocxHelper.getInstance();
        ClassLoader loader = Thread.currentThread().getContextClassLoader();
        XWPFDocument document = helper.createDocument();
        String path = urlToPath(loader.getResource("embed.xls"));
        EmbedObject file = new EmbedObject(path);
        Graphic picture = new Graphic();
        path = urlToPath(loader.getResource("images/excel.emf"));
        picture.setPath(path);
        file.setPicture(picture);
        picture.setWidth(11.46f);
        picture.setHeight(9.08f);
        helper.createFileObject(document, file);
        helper.saveDocument(document, projectOutputPath() + "/EmbedXlsFile.docx");
    }
    
    /**
     * 测试插入Excel 2007文档
     * 
     * @throws Exception 异常
     */
    @Test
    public void testEmbedXlsxFile() throws Exception {
        DocxHelper helper = DocxHelper.getInstance();
        ClassLoader loader = Thread.currentThread().getContextClassLoader();
        XWPFDocument document = helper.createDocument();
        String path = urlToPath(loader.getResource("embed.xlsx"));
        EmbedObject file = new EmbedObject(path);
        Graphic picture = new Graphic();
        path = urlToPath(loader.getResource("images/excel.emf"));
        picture.setPath(path);
        picture.setWidth(11.46f);
        picture.setHeight(9.08f);
        file.setPicture(picture);
        helper.createFileObject(document, file);
        helper.saveDocument(document, projectOutputPath() + "/EmbedXlsxFile.docx");
    }
    
    /**
     * 测试插入Visio 2007文档
     * 
     * @throws Exception 异常
     */
    @Test
    public void testEmbedVsdFile() throws Exception {
        DocxHelper helper = DocxHelper.getInstance();
        ClassLoader loader = Thread.currentThread().getContextClassLoader();
        XWPFDocument document = helper.createDocument();
        String path = urlToPath(loader.getResource("visio1.vsd"));
        EmbedObject file = new EmbedObject(path);
        Graphic picture = new Graphic();
        path = urlToPath(loader.getResource("images/visio.emf"));
        picture.setPath(path);
        picture.setWidth(545f);
        picture.setHeight(557f);
        file.setPicture(picture);
        helper.createFileObject(document, file);
        helper.saveDocument(document, projectOutputPath() + "/EmbedVsdFile.docx");
    }
    
    /**
     * 测试插入Visio 2013文档
     * 
     * @throws Exception 异常
     */
    @Test
    public void testEmbedVsdxFile() throws Exception {
        DocxHelper helper = DocxHelper.getInstance();
        ClassLoader loader = Thread.currentThread().getContextClassLoader();
        XWPFDocument document = helper.createDocument();
        String path = urlToPath(loader.getResource("visio1.vsdx"));
        EmbedObject file = new EmbedObject(path);
        Graphic picture = new Graphic();
        path = urlToPath(loader.getResource("images/visio.emf"));
        picture.setPath(path);
        picture.setWidth(545f);
        picture.setHeight(557f);
        file.setPicture(picture);
        helper.createFileObject(document, file);
        helper.saveDocument(document, projectOutputPath() + "/EmbedVsdxFile.docx");
    }
}
