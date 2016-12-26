/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.meeting.exception;

import com.comtop.cap.runtime.base.exception.CapBaseException;
import java.text.MessageFormat;

/**
 * 测试异常信息
 * 
 * @author CAP
 * @since 1.0
 * @version 2016-3-21 CIP
 */
public class RtException extends CapBaseException {
    
    /**
     * 构造函数
     * 
     * @param message 消息
     * @param params 参数
     */
    public RtException(String message, Object... params) {
        this(message, null, params);
    }
    
    /**
     * 异常构造函数
     * 
     * @param message 异常错误消息
     * @param throwable 引发的异常类
     * @param params 异常信息参数
     */
    public RtException(String message, Throwable throwable, Object... params) {
        super(MessageFormat.format(message, params), throwable);
    }
}
