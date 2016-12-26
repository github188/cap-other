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

import com.comtop.cap.document.word.docmodel.data.Graphic;

/**
 * 测试插入图片
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年10月23日 lizhongwen
 */
public class EmbedPictureTest {
    
    /**
     * 测试插入图片
     * 
     * @throws Exception 异常
     */
    @Test
    public void testCreatePricture() throws Exception {
        DocxHelper helper = DocxHelper.getInstance();
        ClassLoader loader = Thread.currentThread().getContextClassLoader();
        XWPFDocument document = helper.createDocument();
        String path = urlToPath(loader.getResource("images/excel-alt-1.png"));
        Graphic graphic = new Graphic(path);
        graphic.setHeight(5f);
        graphic.setWidth(5f);
        helper.createPricture(document, graphic);
        helper.saveDocument(document, projectOutputPath() + "/EmbedPictureFile.docx");
    }
}
