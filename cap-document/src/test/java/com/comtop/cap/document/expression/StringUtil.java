/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.document.expression.annotation.Function;

/**
 * 字符串工具
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月19日 lizhongwen
 */
public class StringUtil {
    
    /**
     * 字符串连接
     *
     * @param parts 需要拼接的部分
     * @return 拼接后的字符串
     */
    @Function(name = "join", description = "字符串连接")
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
}
