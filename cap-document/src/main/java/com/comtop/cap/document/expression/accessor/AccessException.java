/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression.accessor;

/**
 * 访问异常
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月10日 lizhongwen
 */
public class AccessException extends Exception {
    
    /** 序列ID */
    private static final long serialVersionUID = 1L;
    
    /**
     * 构造函数
     * 
     * @param message 异常消息
     */
    public AccessException(String message) {
        super(message);
    }
    
    /**
     * 构造函数
     * 
     * @param message 异常消息
     * @param cause 错误原因
     */
    public AccessException(String message, Exception cause) {
        super(message, cause);
    }
    
}
