/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cip.graph.image.utils;

import java.io.UnsupportedEncodingException;

import org.apache.commons.codec.binary.Base64;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
/**
 * BASE64工具包
 * @author duqi
 *
 */
public class Base64Util {
	/** 日志 */
	private static final Logger LOGGER = LoggerFactory.getLogger(Base64Util.class);
	
	/**
	 * 编码
	 * @param str 未编码字符串
	 * @return 编码字符串
	 */
	public static String encode(String str){
		try {
			return new String(Base64.encodeBase64(str.getBytes("UTF-8")));
		} catch (UnsupportedEncodingException e) {
			LOGGER.error("不支持编码异常", e);
		}
		return str;  
	}
	
	/**
	 * 解码
	 * @param str 已编码字符串
	 * @return 解码字符串
	 */
	public static String decode(String str){
		try {
			return new String(Base64.decodeBase64(str.getBytes()), "UTF-8");
		} catch (UnsupportedEncodingException e) {
			LOGGER.error("不支持编码异常", e);
		}
		return str;
	}
}
