/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.expression;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

/**
 * 表达式类型
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年11月19日 lizhiyong
 */
public enum ExprType {
    
    /** 查询表达式 */
    QUERY(Pattern.compile("([A-Za-z_][A-Za-z0-9_\\[\\]]*)\\s*=\\s*#([A-Za-z_][A-Za-z0-9_]*)\\((.*)\\)")),
    
    /** 函数表达式 */
    FUNCTION(Pattern.compile("\\$[A-Za-z_][A-Za-z0-9_]*\\(.*\\)")),
    
    /** 全局表达式 */
    GLOBAL(Pattern.compile("\\$[A-Za-z_][A-Za-z0-9_]*")),
    
    /** 属性变量表达式 */
    VAR_ATTRIBUTE(Pattern
        .compile("([A-Za-z_][A-Za-z0-9_\\[\\]]*)\\s*=\\s*([A-Za-z_][A-Za-z0-9_]*)\\.([A-Za-z_][A-Za-z0-9_]*)")),
    
    /** 属性表达式 */
    ATTRIBUTE(Pattern.compile("([A-Za-z_][A-Za-z0-9_]*)\\.([A-Za-z][A-Za-z0-9_]*)")),
    
    /** 未知表达式 **/
    UNKNOWN(Pattern.compile(".*")),
    
    /** 空表达式 */
    NULL(null);
    
    /** 排序后的类型集 */
    private static List<ExprType> sortedList = new ArrayList<ExprType>();
    
    static {
        sortedList.add(QUERY);
        sortedList.add(FUNCTION);
        sortedList.add(GLOBAL);
        sortedList.add(VAR_ATTRIBUTE);
        sortedList.add(ATTRIBUTE);
    }
    
    /** 样式 */
    private Pattern pattern;
    
    /**
     * 构造函数
     * 
     * @param pattern 表达式样式
     */
    private ExprType(Pattern pattern) {
        this.pattern = pattern;
    }
    
    /**
     * @return 获取 pattern属性值
     */
    public Pattern getPattern() {
        return pattern;
    }
    
    /**
     * @param pattern 设置 pattern 属性值为参数值 pattern
     */
    public void setPattern(Pattern pattern) {
        this.pattern = pattern;
    }
    
    /**
     * 获得排序后的表达式类型
     *
     * @return 表达式类型集，不包括UNkNOWN和NULL
     */
    public static List<ExprType> getSortedExprTypes() {
        return sortedList;
    }
    
}
