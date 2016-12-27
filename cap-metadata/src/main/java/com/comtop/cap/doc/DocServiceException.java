/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc;

/**
 * 文档服务异常
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2016年2月22日 lizhiyong
 */
public class DocServiceException extends RuntimeException {
    
    /** 序列号化 */
    private static final long serialVersionUID = 1L;
    
    /**
     * 构造函数
     * 
     * @param message 消息
     */
    public DocServiceException(String message) {
        super(message);
    }
    
    /**
     * 构造函数
     * 
     * @param message 消息
     * @param e 异常
     */
    public DocServiceException(String message, Throwable e) {
        super(message, e);
    }
}
