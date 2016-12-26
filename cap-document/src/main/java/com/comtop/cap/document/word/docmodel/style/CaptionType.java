/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docmodel.style;

/**
 * 题注类型
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年1月13日 lizhongwen
 */
public enum CaptionType {
    /** 表格 */
    TABLE("表"),
    /** 图片 */
    PICTURE("图"),
    /** 公式 */
    FORMULA("公式");
    
    /** 类型名称 */
    private String name;
    
    /**
     * 构造函数
     * 
     * @param name 类型名称
     */
    private CaptionType(String name) {
        this.name = name;
    }
    
    /**
     * @return 获取 name属性值
     */
    public String getName() {
        return name;
    }
    
}
