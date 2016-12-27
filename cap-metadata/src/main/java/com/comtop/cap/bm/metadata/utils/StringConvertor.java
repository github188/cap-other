/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.utils;

import org.apache.commons.lang.StringUtils;

import com.comtop.cip.jodd.util.StringUtil;

/**
 * 名称转换工具类
 * 
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2014-4-25 李忠文
 */
public class StringConvertor {
    
    /**
     * 构造函数
     */
    private StringConvertor() {
        super();
    }
    
    /**
     * 将驼峰风格字符串转为下划线风格
     * 
     * 
     * @param camel 驼峰风格字符串
     * @return 下划线风格
     */
    public static String toUnderScore(final String camel) {
        // String strRegx = "(?<!^)(?=([A-Z]|[0-9]))";
        String[] strParts = StringUtils.splitByCharacterTypeCamelCase(camel);
        StringBuilder objBuilder = new StringBuilder();
        for (int iIndex = 0; iIndex < strParts.length; iIndex++) {
            String strPart = strParts[iIndex];
            if (iIndex > 0) {
                objBuilder.append("_");
            }
            objBuilder.append(strPart);
        }
        return objBuilder.toString().toUpperCase();
    }
    
    /**
     * 将下划线风格字符串转为驼峰风格
     * 
     * 
     * @param underScore 下划线风格字符串
     * @param ingoreFirst 是否忽略第1节，如CIP_USER如果为TRUE，则返回user，当为false则返回cipUser;
     * @return 驼峰风格字符串
     */
    public static String toCamelCase(final String underScore, final boolean ingoreFirst) {
        return toCamelCase(underScore, 1);
    }
    
    /**
     * 将下划线风格字符串转为驼峰风格
     * 
     * 
     * @param underScore 下划线风格字符串
     * @param ingore 忽略节数;
     * @return 驼峰风格字符串
     */
    public static String toCamelCase(final String underScore, final int ingore) {
        String[] strNameParts = underScore.toLowerCase().split("_");
        StringBuilder objStrBuilder = new StringBuilder();
        String strNamePart;
        int iStartIndex = strNameParts.length > ingore ? ingore : 0;
        for (int i = iStartIndex; i < strNameParts.length; i++) {
            strNamePart = strNameParts[i];
            if (StringUtil.isNotBlank(strNamePart) && strNamePart.length() > 0) {
                objStrBuilder.append(strNamePart.substring(0, 1).toUpperCase());
                objStrBuilder.append(strNamePart.substring(1));
            } else {
                objStrBuilder.append(strNamePart.toUpperCase());
            }
        }
        return objStrBuilder.toString();
    }
    
}
