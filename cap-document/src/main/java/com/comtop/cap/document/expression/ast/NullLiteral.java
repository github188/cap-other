/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression.ast;

import com.comtop.cap.document.expression.support.TypedValue;

/**
 * 空值
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月10日 lizhongwen
 */
public class NullLiteral extends Literal {
    
    /**
     * 构造函数
     * 
     * @param pos 位置
     */
    public NullLiteral(int pos) {
        super(null, pos);
    }
    
    /**
     * @return 空值
     * 
     * @see com.comtop.cap.document.expression.ast.Literal#getLiteralValue()
     */
    @Override
    public TypedValue getLiteralValue() {
        return TypedValue.NULL;
    }
    
    /**
     * @return 空值字符串
     * 
     * @see com.comtop.cap.document.expression.ast.Literal#toString()
     */
    @Override
    public String toString() {
        return "null";
    }
}
