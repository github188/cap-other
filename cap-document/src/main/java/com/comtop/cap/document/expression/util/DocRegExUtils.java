/******************************************************************************
 * Copyright (C) 2012 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression.util;

import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.regex.PatternSyntaxException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.document.expression.annotation.Function;

/**
 * CAP文档管理，表达式函数，正则表达式工具类
 * 
 * @author 李小强
 * @since 1.0
 * @version 2015年11月19日 李小强
 */
public class DocRegExUtils {
	  /** LOG */
    private static final Logger LOG = LoggerFactory.getLogger(DocRegExUtils.class);
	/**
	 * 要求大小写都匹配正则表达式
	 * 
	 * @param pattern
	 *            正则表达式模式
	 * @param str
	 *            要匹配的字串
	 * @return 匹配到则返回true,否则返回false
	 * @throws PatternSyntaxException 异常
	 */
	@Function(name = "RegExUtils_ereg", description = "要求大小写都匹配正则表达式")
	public static boolean ereg(String pattern, String str)
			throws PatternSyntaxException {
		try {
			Pattern p = Pattern.compile(pattern);
			Matcher m = p.matcher(str);
			return m.find();
		} catch (PatternSyntaxException e) {
			LOG.error("匹配正则表达式失败,错误:"+e.getMessage(),e);
			return false;
		}
	}

	/**
	 * 匹配并替换字串
	 * 
	 * @param pattern
	 *            正则表达式模式
	 * @param newstr
	 *            要替换匹配到的新字串
	 * @param str
	 *            原始字串
	 * @return 匹配后的字符串
	 * @throws PatternSyntaxException 异常
	 */
	@Function(name = "RegExUtils_eregReplace", description = "匹配并替换字串")
	public static String eregReplace(String pattern, String newstr,String str) throws PatternSyntaxException {
		try {
			Pattern p = Pattern.compile(pattern);
			Matcher m = p.matcher(str);
			return m.replaceAll(newstr);
		} catch (PatternSyntaxException e) {
			throw e;
		}
	}
}
