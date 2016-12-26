/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.write.writer;

import java.text.MessageFormat;

import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.document.word.write.DocxExportConfiguration;

/**
 * 片段写入器
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月23日 lizhongwen
 * @param <T> 文档元素类型
 */
public abstract class FragmentWriter<T> implements IDocxFragmentWriter<T> {
    
    /** 日志 */
    private final Logger logger;
    
    /**
     * 构造函数
     */
    public FragmentWriter() {
        logger = LoggerFactory.getLogger(this.getClass());
    }
    
    /**
     * 根据文档配置写入文档片段
     *
     * @param config 文档导出配置
     * @param docx 文档对象
     * @param element 配置元素
     * @param uri 文档URI
     * @see com.comtop.cap.document.word.write.writer.IDocxFragmentWriter#write(com.comtop.cap.document.word.write.DocxExportConfiguration,org.apache.poi.xwpf.usermodel.XWPFDocument,
     *      java.lang.Object, java.lang.String)
     */
    @Override
    public void write(final DocxExportConfiguration config, final XWPFDocument docx, final T element, final String uri) {
        getLogger().debug(MessageFormat.format("正在写入：{0}。", element.getClass().getSimpleName()));
        internalWrite(config, docx, element, uri);
        getLogger().debug(MessageFormat.format("写入：{0}完成。", element.getClass().getSimpleName()));
    }
    
    /**
     * 根据文档配置写入文档片段
     *
     * @param config 文档导出配置
     * @param docx 文档对象
     * @param element 配置元素
     * @param uri 文档URI
     */
    protected abstract void internalWrite(final DocxExportConfiguration config, final XWPFDocument docx,
        final T element, final String uri);
    
    /**
     * @return 获取 logger属性值
     */
    public Logger getLogger() {
        return logger;
    }
}
