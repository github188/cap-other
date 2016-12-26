/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docconfig.model;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlTransient;
import javax.xml.bind.annotation.XmlType;

/**
 * 模板中的章节内容对象
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年10月15日 lizhiyong
 */
@XmlType(name = "ContentSegElementType")
@XmlAccessorType(XmlAccessType.FIELD)
public class DCContentSeg extends ConfigElement {
    
    /** 类序列号 */
    private static final long serialVersionUID = 1L;
    
    /** 所属章节 */
    private transient DCContainer container;
    
    /** 内容是否需要持久化 */
    @XmlTransient
    private boolean needStore = false;
    
    /**
     * @return 获取 container属性值
     */
    public DCContainer getContainer() {
        return container;
    }
    
    /**
     * @param container 设置 container 属性值为参数值 container
     */
    public void setContainer(DCContainer container) {
        this.container = container;
    }
    
    /**
     * @return 获取 needStore属性值
     */
    public boolean isNeedStore() {
        return needStore;
    }
    
    /**
     * @param needStore 设置 needStore 属性值为参数值 needStore
     */
    public void setNeedStore(boolean needStore) {
        this.needStore = needStore;
    }
}
