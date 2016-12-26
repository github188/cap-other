/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression;

/**
 * 表达式解析上下文
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月9日 lizhongwen
 */
public interface IParseContext {
    
    /**
     * 是否为模板
     * 
     * @return true if the expression is a template, false otherwise
     */
    boolean isTemplate();
    
    /**
     * 表达式前缀
     *
     * @return 前缀
     */
    String getExpressionPrefix();
    
    /**
     * 表达式后缀
     *
     * @return 后缀
     */
    String getExpressionSuffix();
    
    /**
     * The default ParserContext implementation that enables template expression parsing mode.
     * The expression prefix is ${ and the expression suffix is }.
     * 
     * @see #isTemplate()
     */
    public static final IParseContext TEMPLATE_EXPRESSION = new IParseContext() {
        
        /**
         * 表达式前缀
         *
         * @return 前缀
         * @see com.comtop.cap.document.expression.IParseContext#getExpressionPrefix()
         */
        @Override
        public String getExpressionPrefix() {
            return "${";
        }
        
        /**
         * 表达式后缀
         *
         * @return 后缀
         * @see com.comtop.cap.document.expression.IParseContext#getExpressionSuffix()
         */
        @Override
        public String getExpressionSuffix() {
            return "}";
        }
        
        /**
         * 是否为模板
         * 
         * @return true if the expression is a template, false otherwise
         * @see com.comtop.cap.document.expression.IParseContext#isTemplate()
         */
        @Override
        public boolean isTemplate() {
            return true;
        }
        
    };
    
    /**
     * 无模板表达式解析
     */
    public static final IParseContext NON_TEMPLATE_PARSER_CONTEXT = new IParseContext() {
        
        /**
         * 表达式前缀
         *
         * @return 前缀
         * @see com.comtop.cap.document.expression.IParseContext#getExpressionPrefix()
         */
        @Override
        public String getExpressionPrefix() {
            return null;
        }
        
        /**
         * 表达式后缀
         *
         * @return 后缀
         * @see com.comtop.cap.document.expression.IParseContext#getExpressionSuffix()
         */
        @Override
        public String getExpressionSuffix() {
            return null;
        }
        
        /**
         * 是否为模板
         * 
         * @return true if the expression is a template, false otherwise
         * @see com.comtop.cap.document.expression.IParseContext#isTemplate()
         */
        @Override
        public boolean isTemplate() {
            return false;
        }
    };
}
