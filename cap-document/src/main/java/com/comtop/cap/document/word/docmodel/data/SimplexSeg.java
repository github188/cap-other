/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docmodel.data;


/**
 * 文本内容
 * 
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年10月15日 lizhiyong
 */
public class SimplexSeg extends ContentSeg {
    
    /** 段落 */
    private Paragraph paragraphContainer;
    
    /** 类序列号 */
    private static final long serialVersionUID = 1L;
    
    /**
     * @return 获取 paragraphContainer属性值
     */
    public Paragraph getParagraphContainer() {
        return paragraphContainer;
    }
    
    /**
     * @param paragraphContainer 设置 paragraphContainer 属性值为参数值 paragraphContainer
     */
    public void setParagraphContainer(Paragraph paragraphContainer) {
        this.paragraphContainer = paragraphContainer;
    }
}
