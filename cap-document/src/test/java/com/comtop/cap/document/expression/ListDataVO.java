/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression;


/**
 * FIXME 类注释信息
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年1月14日 lizhongwen
 */
public class ListDataVO {
    
    /** 内容 */
    private String content;
    
    /**
     * 构造函数
     */
    public ListDataVO() {
        super();
    }
    
    /**
     * 构造函数
     * 
     * @param content xxx
     */
    public ListDataVO(String content) {
        super();
        this.content = content;
    }
    
    /**
     * @return 获取 content属性值
     */
    public String getContent() {
        return content;
    }
    
    /**
     * @param content 设置 content 属性值为参数值 content
     */
    public void setContent(String content) {
        this.content = content;
    }
    
}
