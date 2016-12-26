/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.write.writer;

import org.apache.poi.xwpf.usermodel.XWPFDocument;

import com.comtop.cap.document.word.write.DocxHelper;

/**
 * ul标签写入器
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年1月14日 lizhongwen
 */
public class TagULWriter extends NodeListWriter {
    
    /**
     * 写入列表项目
     *
     * @param docx 文档对象
     * @param level 项目级别
     * @param content 项目内容
     * @param isNew 是否重新开始
     * @see com.comtop.cap.document.word.write.writer.NodeListWriter#writeListItem(org.apache.poi.xwpf.usermodel.XWPFDocument,
     *      int, java.lang.String, boolean)
     */
    @Override
    protected void writeListItem(XWPFDocument docx, int level, String content, boolean isNew) {
        DocxHelper helper = DocxHelper.getInstance();
        helper.createParagraphWithBulletItemCode(docx, level, content, false);
    }
    
}
