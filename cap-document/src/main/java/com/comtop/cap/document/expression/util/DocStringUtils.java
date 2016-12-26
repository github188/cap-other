/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression.util;

import java.util.UUID;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.document.expression.annotation.Function;
/**
 * CAP文档管理，表达式函数，字符串处理工具类
 *
 * @author 李小强
 * @since jdk1.6
 * @version 2015年11月19日 李小强
 */
public class DocStringUtils {
	 /**
     * 字符串连接
     *
     * @param parts 需要拼接的部分
     * @return 拼接后的字符串
     */
    @Function(name = "StringUtils_join", description = "字符串连接")
    public static String join(String... parts) {
        if (parts == null) {
            return null;
        }
        StringBuilder sb = new StringBuilder();
        for (String str : parts) {
            if (StringUtils.isNotBlank(str)) {
                sb.append(str);
            }
        }
        return sb.toString();
    }
    
    
    /**
     * 检查string是否是空白或者string为null.
     * @param string 需要检查的string, 可能为null
     * @return true,如果string为null或者string中数据为空白
     * @since 2.0
     */
    @Function(name = "StringUtils_isBlank", description = "检查string是否是空白或者string为null")
    public static boolean isBlank(String string) {
        int strLen;
        if (string == null || (strLen = string.length()) == 0) {
            return true;
        }
        for (int i = 0; i < strLen; i++) {
            if (!Character.isWhitespace(string.charAt(i))) {
                return false;
            }
        }
        return true;
    }
    
    
    /**
     * 查看字符串中是否只有unicode的数字. 小数点不认为是unicode的数字.
     * <code>null</code> 返回 <code>false</code>. 空的字符串("") 返回 <code>true</code>.
     * 
     * DocStringUtils.isNumeric(null)   = false
     * DocStringUtils.isNumeric(&quot;&quot;)     = true
     * DocStringUtils.isNumeric(&quot;  &quot;)   = false
     * DocStringUtils.isNumeric(&quot;123&quot;)  = true
     * DocStringUtils.isNumeric(&quot;12 3&quot;) = false
     * DocStringUtils.isNumeric(&quot;ab2c&quot;) = false
     * DocStringUtils.isNumeric(&quot;12-3&quot;) = false
     * DocStringUtils.isNumeric(&quot;12.3&quot;) = false
     * 
     * @param str 要检查的字符串, 可能为null
     * @return <code>true</code> 只有unicode的数字,而且输入不为null
     */
    @Function(name = "StringUtils_isBlank", description = "查看字符串中是否只有unicode的数字. 小数点不认为是unicode的数字")
    public static boolean isNumeric(String str) {
        if (str == null) {
            return false;
        }
        int iLength = str.length();
        for (int i = 0; i < iLength; i++) {
            if (!Character.isDigit(str.charAt(i))) {
                return false;
            }
        }
        return true;
    }
    
    
    /**
     * 获得一个UUID,去掉“-”符号
     * @return String UUID
     */
    @Function(name = "StringUtils_getUUID", description = "获得一个UUID,去掉“-”符号")
    public static String getUUID() {
        String s = UUID.randomUUID().toString();
        // 去掉“-”符号
        return s.substring(0, 8) + s.substring(9, 13) + s.substring(14, 18) + s.substring(19, 23) + s.substring(24);
    }
    /**
     * 
     * @description 字符串首字母小写
     * @param str 传入的字符串
     * @return 字符串首字母小写
     */
    @Function(name = "StringUtils_uncapitalize", description = "字符串首字母小写")
    public static String uncapitalize(String str) {
        if (isBlank(str)) {
            return str;
        }
        return str.toLowerCase().charAt(0) + str.substring(1);
    }
    /**
     * 
     * @description 字符串首字母大写
     * @param str 传入的字符串
     * @return 字符串首字母大写
     */
    @Function(name = "StringUtils_initials", description = "字符串首字母大写")
    public static String initials(String str) {
        if (isBlank(str)) {
            return str;
        }
        return str.toUpperCase().charAt(0) + str.substring(1);
    }
    
	/**获取格式 化标题:name【code】
	 * @param name 对象中文名
	 * @param code 对象英文名
	 * @return  取格式 化标题:对象中文名【对象英文名】
	 */
	@Function(name="StringUtils_getDBObjectTitle")
	public static String getDBObjectTitle(String name,String code){
		return name+"【"+code+"】";
	}
	
	/**
	 * 通过序列号获取指定集合中的text
	 * @param indexNo 序列号
	 * @param fieldTypeData 集合数据
	 * @return 序列号获取对应集合中的text
	 */
	@Function(name="StringUtils_getCollTextByIndexNo")
	public static String getTextByIndexNo(int indexNo,
			String[] fieldTypeData) {
		if(indexNo < fieldTypeData.length) {
			return fieldTypeData[indexNo];
		}
		return "";
	}
    
}
