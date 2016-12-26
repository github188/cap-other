/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression.ast;

import com.comtop.cap.document.expression.support.TypedValue;

/**
 * 字符串节点
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月12日 lizhongwen
 */
public class StringLiteral extends Literal {
    
    /** 值 */
    private final TypedValue value;
    
    /**
     * 构造函数
     * 
     * @param payload 表达式原文
     * @param pos 表达式位置
     * @param value 字符串的值
     */
    public StringLiteral(String payload, int pos, String value) {
        super(payload, pos);
        String temp = value.substring(1, value.length() - 1);
        this.value = new TypedValue(temp.replaceAll("''", "'"));
    }
    
    /**
     * @return 获取值
     * @see com.comtop.cap.document.expression.ast.Literal#getLiteralValue()
     */
    @Override
    public TypedValue getLiteralValue() {
        return this.value;
    }
    
    /**
     * @return 转换为字符串
     * @see com.comtop.cap.document.expression.ast.Literal#toString()
     */
    @Override
    public String toString() {
        return "'" + getLiteralValue().getValue() + "'";
    }
    
}
