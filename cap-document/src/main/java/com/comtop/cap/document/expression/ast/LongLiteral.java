/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression.ast;

import com.comtop.cap.document.expression.support.TypedValue;

/**
 * 长整形节点
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月10日 lizhongwen
 */
public class LongLiteral extends Literal {
    
    /** 值 */
    private final TypedValue value;
    
    /**
     * 构造函数
     * 
     * @param payload 表达式原文
     * @param pos 位置
     * @param value 值
     */
    LongLiteral(String payload, int pos, long value) {
        super(payload, pos);
        this.value = new TypedValue(value);
    }
    
    /**
     * @return 解析后的值
     * 
     * @see com.comtop.cap.document.expression.ast.Literal#getLiteralValue()
     */
    @Override
    public TypedValue getLiteralValue() {
        return this.value;
    }
    
}
