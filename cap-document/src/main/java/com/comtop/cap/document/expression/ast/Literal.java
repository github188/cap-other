/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression.ast;

import java.text.MessageFormat;

import com.comtop.cap.document.expression.EvaluationContext;
import com.comtop.cap.document.expression.EvaluationException;
import com.comtop.cap.document.expression.ParseException;
import com.comtop.cap.document.expression.support.TypedValue;

/**
 * 按照表达式原文的节点如字符串等等
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月10日 lizhongwen
 */
public abstract class Literal extends ExprNodeImpl {
    
    /** 表达式原文 */
    protected String literalValue;
    
    /**
     * 构造函数
     * 
     * @param payload 表达式原文
     * @param pos 位置
     */
    public Literal(String payload, int pos) {
        super(pos);
        this.literalValue = payload;
    }
    
    /**
     * @return 获取值
     */
    public abstract TypedValue getLiteralValue();
    
    /**
     * 内置数据获取
     *
     * @param context 表达式执行上下文
     * @return 执行结果
     * @throws EvaluationException 表达式执行异常
     * @see com.comtop.cap.document.expression.ast.ExprNodeImpl#getValueInternal(com.comtop.cap.document.expression.EvaluationContext)
     */
    @Override
    public TypedValue getValueInternal(EvaluationContext context) throws EvaluationException {
        return getLiteralValue();
    }
    
    /**
     * @return 转换为字符串
     * 
     * @see java.lang.Object#toString()
     */
    @Override
    public String toString() {
        return getLiteralValue().getValue().toString();
    }
    
    /**
     * @return 抽象语法树中的字符串
     * @see com.comtop.cap.document.expression.ast.ExprNodeImpl#toStringAST()
     */
    @Override
    public String toStringAST() {
        return toString();
    }
    
    /**
     * 获得整形值
     *
     * @param numberToken 数字Token
     * @param pos 位置
     * @param radix 基数
     * @return 整形值
     */
    public static Literal getIntLiteral(String numberToken, int pos, int radix) {
        try {
            int value = Integer.parseInt(numberToken, radix);
            return new IntLiteral(numberToken, pos, value);
        } catch (NumberFormatException nfe) {
            throw new ParseException(pos >> 16, MessageFormat.format("值''{0}''不能转换为整形数字！", numberToken), nfe);
        }
    }
    
    /**
     * 获得长整形值
     *
     * @param numberToken 数字Token
     * @param pos 位置
     * @param radix 基数
     * @return 整形值
     */
    public static Literal getLongLiteral(String numberToken, int pos, int radix) {
        try {
            long value = Long.parseLong(numberToken, radix);
            return new LongLiteral(numberToken, pos, value);
        } catch (NumberFormatException nfe) {
            throw new ParseException(pos >> 16, MessageFormat.format("值''{0}''不能转换为长整形数字！", numberToken), nfe);
        }
    }
    
    /**
     * 获得实数值
     *
     * @param numberToken 数字Token
     * @param pos 位置
     * @param isFloat 是否为浮点数
     * @return 整形值
     */
    public static Literal getRealLiteral(String numberToken, int pos, boolean isFloat) {
        try {
            if (isFloat) {
                float value = Float.parseFloat(numberToken);
                return new RealLiteral(numberToken, pos, value);
            }
            double value = Double.parseDouble(numberToken);
            return new RealLiteral(numberToken, pos, value);
        } catch (NumberFormatException nfe) {
            throw new ParseException(pos >> 16, MessageFormat.format("值''{0}''不能转换为实数！", numberToken), nfe);
        }
    }
}
