/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docconfig.datatype;

/**
 * 文档配置类型。目前 模板信息是初始化在数据库中的，初始化的模板信息都是公用模板。
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年12月24日 lizhiyong
 */
public enum DocConfigType {
    /** 公用：多个文档可以共享的文档配置 */
    PUBLIC,
    
    /** 专用：某个文档特有的配置。 专用配置一般是在导入文档时针对该文档动态创建的 */
    PRIVATE,
    
    /** 未知 */
    UNKNOWN;
    
    @Override
    public String toString() {
        return this.name();
    }
}
