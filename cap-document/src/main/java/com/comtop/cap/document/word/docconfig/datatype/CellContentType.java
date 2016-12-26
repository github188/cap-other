/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docconfig.datatype;

import javax.xml.bind.annotation.XmlEnum;

/**
 * 单元格内容类型
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2016年1月18日 lizhiyong
 */
@XmlEnum
public enum CellContentType {
    
    /**
     * 简单文本类型.对于简单文本类型，在从word文档提取数据时只会将其当作一个简单的文本字符串处理。
     * 对于单元格内容是简单文本时，比如序号、名称、编码等列，可以配置为此类型。此类型是默认值。
     */
    SIMPLEX,
    
    /**
     * 复合类型。对于复合类型，在从word文档中提取数据时会将其转换成一个html字符串。
     * 对于单元格内容是有序列的文本、图片、嵌入式对象、格式段落时，可以配置此类型。 不配置默认值为SIMPLEX
     */
    COMPLEX;
    
}
