/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.base.consistency;

/**
 * 一致性校验异常
 * 
 * @author 罗珍明
 *
 */
public class ConsistencyException extends RuntimeException{
	
	/**
	 * 
	 * @param message 异常信息
	 */
	public ConsistencyException(String message){
		super(message);
	}
	
	/**
	 * 
	 * @param message 异常信息
	 * @param e 原始异常
	 */
	public ConsistencyException(String message,Throwable e){
		super(message, e);
	}
}
