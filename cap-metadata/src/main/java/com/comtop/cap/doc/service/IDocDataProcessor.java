/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.service;

import com.comtop.cap.doc.DocProcessParams;

/**
 * 数据导入之后的操作
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年12月23日 lizhiyong
 */
public interface IDocDataProcessor {
    
    /**
     * 处理
     * 
     * @param params 参数集
     *
     */
    void process(DocProcessParams params);
    
}
