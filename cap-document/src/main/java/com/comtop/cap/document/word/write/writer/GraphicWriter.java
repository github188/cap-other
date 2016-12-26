/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.write.writer;

import java.util.Collection;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.document.word.docconfig.model.DCGraphic;
import com.comtop.cap.document.word.docmodel.data.Graphic;
import com.comtop.cap.document.word.docmodel.style.CaptionType;
import com.comtop.cap.document.word.expression.ExpressionExecuteHelper;
import com.comtop.cap.document.word.write.DocxExportConfiguration;
import com.comtop.cap.document.word.write.DocxHelper;

/**
 * 图片写入器
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月24日 lizhongwen
 */
public class GraphicWriter extends FragmentWriter<DCGraphic> {
	
	/**
     * logger
     */
    protected static final Logger LOGGER = LoggerFactory.getLogger(GraphicWriter.class);
    
    /**
     * 根据文档配置写入文档图片片段
     *
     * @param config 文档导出配置
     * @param docx 文档对象
     * @param graphic 图片配置元素
     * @param uri 文档uri
     * @see com.comtop.cap.document.word.write.writer.FragmentWriter#internalWrite(com.comtop.cap.document.word.write.DocxExportConfiguration,org.apache.poi.xwpf.usermodel.XWPFDocument,
     *      java.lang.Object, java.lang.String)
     */
    @Override
    protected void internalWrite(final DocxExportConfiguration config, final XWPFDocument docx,
        final DCGraphic graphic, final String uri) {
        ExpressionExecuteHelper executer = config.getExecuter();
        executer.notifyStart();
        DocxHelper helper = DocxHelper.getInstance();
        String expression = graphic.getMappingTo();
        Object result = null;
        if (StringUtils.isNotEmpty(expression)) {
            result = executer.read(expression);
        }
        if (result == null) {
            helper.createEmptyParagraph(docx);
            executer.notifyEnd();
            return;
        }
        if (result instanceof Collection) {
            Collection<?> coll = (Collection<?>) result;
            for (Object obj : coll) {
                this.writeGrapic(config, docx, uri, obj);
            }
        } else {
            this.writeGrapic(config, docx, uri, result);
        }
        executer.notifyEnd();
    }
    
    /**
     * 向文档中写入图片
     *
     * @param config 文档导出配置
     * @param docx 文档对象
     * @param uri 文档uri
     * @param data 数据
     */
    private void writeGrapic(final DocxExportConfiguration config, final XWPFDocument docx, final String uri,
        final Object data) {
        if (data instanceof String) {
            String text = (String) data;
            IDocxFragmentWriter<String> writer = DocxFragmentWriterFactory.getFragementWriter(text);
            writer.write(config, docx, text, uri);
        } else if (data instanceof Graphic) {
            DocxHelper helper = DocxHelper.getInstance();
            Graphic graphic = (Graphic) data;
            try {
                helper.createPricture(docx, graphic);
                if (StringUtils.isNotBlank(graphic.getName())) {
                    try {
                        helper.createCaption(docx, CaptionType.PICTURE, graphic.getName());
                    } catch (Exception e) {
                    	LOGGER.debug("error.", e);
                        helper.createEmptyParagraph(docx);
                    }
                } else {
                    helper.createEmptyParagraph(docx);
                }
            } catch (Exception e) {
                getLogger().error(e.getMessage(), e);
            }
        }
    }
    
}
