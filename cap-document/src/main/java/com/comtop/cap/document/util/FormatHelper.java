/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.util;

import java.util.List;

import com.comtop.cap.document.expression.support.TypeDescriptor;

/**
 * 格式化工具类
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月12日 lizhongwen
 */
public final class FormatHelper {
    
    /**
     * 构造函数
     */
    private FormatHelper() {
    }
    
    /**
     * 将类名格式化为可读取较强的消息格式
     *
     * @param clazz 类
     * @return 消息
     */
    public static String formatClassNameForMessage(Class<?> clazz) {
        if (clazz == null) {
            return "null";
        }
        StringBuilder fmtd = new StringBuilder();
        if (clazz.isArray()) {
            int dims = 1;
            Class<?> baseClass = clazz.getComponentType();
            while (baseClass.isArray()) {
                baseClass = baseClass.getComponentType();
                dims++;
            }
            fmtd.append(baseClass.getName());
            for (int i = 0; i < dims; i++) {
                fmtd.append("[]");
            }
        } else {
            fmtd.append(clazz.getName());
        }
        return fmtd.toString();
    }
    
    /**
     * 将方法格式化为可读取较强的消息格式
     *
     * @param name 方法名称
     * @param types 参数类型
     * @return 消息
     */
    public static String formatMethodForMessage(String name, List<TypeDescriptor> types) {
        StringBuilder sb = new StringBuilder();
        sb.append(name);
        sb.append("(");
        for (int i = 0; i < types.size(); i++) {
            if (i > 0) {
                sb.append(",");
            }
            sb.append(formatClassNameForMessage(types.get(i).getType()));
        }
        sb.append(")");
        return sb.toString();
    }
    
}
