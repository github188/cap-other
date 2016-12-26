/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression;

/**
 * 括弧
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月13日 lizhongwen
 */
public class Bracket {
    
    /** 括弧 */
    char bracket;
    
    /** 位置 */
    int pos;
    
    /**
     * 构造函数
     * 
     * @param bracket 括弧
     * @param pos 位置
     */
    Bracket(char bracket, int pos) {
        this.bracket = bracket;
        this.pos = pos;
    }
    
    /**
     * 结束括弧是否正确
     *
     * @param closeBracket 结束符
     * @return true表示能够找到正确的结束符
     */
    boolean compatibleWithCloseBracket(char closeBracket) {
        if (bracket == '{') {
            return closeBracket == '}';
        } else if (bracket == '[') {
            return closeBracket == ']';
        }
        return closeBracket == ')';
    }
    
    /**
     * 根据结束括弧查找开始括弧
     *
     * @param closeBracket 结束
     * @return 开始括弧
     */
    static char theOpenBracketFor(char closeBracket) {
        if (closeBracket == '}') {
            return '{';
        } else if (closeBracket == ']') {
            return '[';
        }
        return '(';
    }
    
    /**
     * 根据开始的括弧，查找结束括弧
     *
     * @param openBracket 开始括弧
     * @return 返回对应的结束符
     */
    static char theCloseBracketFor(char openBracket) {
        if (openBracket == '{') {
            return '}';
        } else if (openBracket == '[') {
            return ']';
        }
        return ')';
    }
}
