/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.parse;

/**
 * word解析异常基类
 * 
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年10月14日 lizhiyong
 */
public class WordParseException extends RuntimeException {
    
    /** 序列化号 */
    private static final long serialVersionUID = 1L;
    
    /**
     * 构造函数
     * 
     * 
     * @param message 消息
     */
    public WordParseException(String message) {
        super(message);
    }
    
    /**
     * 构造函数
     * 
     * @param message 消息
     * @param cause cause
     */
    public WordParseException(String message, Throwable cause) {
        super(message, cause);
    }
    
}
