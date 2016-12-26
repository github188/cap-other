/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.parse.util;

import java.util.regex.Pattern;

import org.apache.commons.lang.StringUtils;

/**
 * 取值帮助 类
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年11月16日 lizhiyong
 */
public class ValueUtil {
    
    /** 字符串无 */
    private static final Pattern WU = Pattern.compile("^　{0,}无　{0,}$");
    
    /**
     * 获得值 。如果有效文本只无无字，返回null 。
     *
     * @param input 输入的字符串
     * @return 值
     */
    public static String getValue(String input) {
        String inputs = StringUtils.trim(input);
        return (StringUtils.isBlank(inputs) || WU.matcher(inputs).find()) ? null : inputs;
    }
}
