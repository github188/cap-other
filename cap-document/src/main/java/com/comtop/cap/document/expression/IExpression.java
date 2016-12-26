/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression;

import com.comtop.cap.document.expression.ast.ExprNode;

/**
 * 表达式接口
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月9日 lizhongwen
 */
public interface IExpression {
    
    /**
     * 执行
     *
     * @param root 根对象
     * @param value 参数
     * @return 表达式计算结果
     */
    Object execute(Object root, Object value);
    
    /**
     * 执行
     * 
     * @param context 上下文
     * @param value 参数，如果参数为null，表示取值，否则则表示设置值，如果是设置为空中的话，则要使用TypeValue.NULL常量
     * @return 表达式计算结果
     */
    Object execute(EvaluationContext context, Object value);
    
    /**
     * @return 是否为服务表达式
     */
    boolean isService();
    
    /**
     * 获取表达式抽象语法树
     *
     * @return 表达式抽象语法书
     */
    ExprNode getAst();
    
}
