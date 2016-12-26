/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression.ast;

import com.comtop.cap.document.expression.support.BooleanTypedValue;

/**
 * 布尔值节点
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月12日 lizhongwen
 */
public class BooleanLiteral extends Literal {
    
    /** Boolean值 */
    private final BooleanTypedValue value;
    
    /**
     * 构造函数
     * 
     * @param payload 表达式原文
     * @param pos 表达式位置
     * @param value boolean值
     */
    public BooleanLiteral(String payload, int pos, boolean value) {
        super(payload, pos);
        this.value = BooleanTypedValue.forValue(value);
    }
    
    /**
     * @return 获取值
     * @see com.comtop.cap.document.expression.ast.Literal#getLiteralValue()
     */
    @Override
    public BooleanTypedValue getLiteralValue() {
        return this.value;
    }
    
}
