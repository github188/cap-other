/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.lld.model;

import com.comtop.cap.document.word.docmodel.data.BaseDTO;

/**
 * 页面元素服务
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年12月30日 lizhiyong
 */
public class PageElementServiceDTO extends BaseDTO {
    
    /** 序列号 */
    private static final long serialVersionUID = 1L;
    
    /** 元素名 */
    private String elementName;
    
    /** 元素中文名 */
    private String cnElementName;
    
    /** 服务中文名 */
    private String cnName;
    
    /**
     * @return 获取 elementName属性值
     */
    public String getElementName() {
        return elementName;
    }
    
    /**
     * @param elementName 设置 elementName 属性值为参数值 elementName
     */
    public void setElementName(String elementName) {
        this.elementName = elementName;
    }
    
    /**
     * @return 获取 cnElementName属性值
     */
    public String getCnElementName() {
        return cnElementName;
    }
    
    /**
     * @param cnElementName 设置 cnElementName 属性值为参数值 cnElementName
     */
    public void setCnElementName(String cnElementName) {
        this.cnElementName = cnElementName;
    }
    
    /**
     * @return 获取 cnName属性值
     */
    public String getCnName() {
        return cnName;
    }
    
    /**
     * @param cnName 设置 cnName 属性值为参数值 cnName
     */
    public void setCnName(String cnName) {
        this.cnName = cnName;
    }
    
}
