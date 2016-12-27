/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.common.storage.exception;

import com.comtop.cip.common.validator.ValidateResult;

/**
 * 验证异常
 * 
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2015-3-31 李忠文
 */
public class ValidateException extends Exception {

	/** 序列化ID */
	private static final long serialVersionUID = 1L;

	/** 验证结果 */
	private ValidateResult<?> result;

	/**
	 * 构造函数
	 * 
	 * @param message 异常消息
	 */
	public ValidateException(final String message) {
		super(message);
	}

	/**
	 * 构造函数
	 * 
	 * @param message 异常消息
	 * @param result 验证结果
	 */
	public ValidateException(final String message, final ValidateResult<?> result) {
		super(message);
		this.result = result;
	}

	/**
	 * 构造函数
	 * 
	 * @param message 异常消息
	 * @param cause 异常原因
	 */
	public ValidateException(final String message, final Throwable cause) {
		super(message, cause);
	}

	/**
	 * 构造函数
	 * 
	 * @param message 异常消息
	 * @param result 验证结果
	 * @param cause 异常原因
	 */
	public ValidateException(final String message, final ValidateResult<?> result, final Throwable cause) {
		super(message, cause);
		this.result = result;
	}

	/**
	 * @return 获取 result属性值
	 */
	public ValidateResult<?> getResult() {
		return result;
	}
}
