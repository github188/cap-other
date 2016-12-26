/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression;

/**
 * 表达式令牌
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月9日 lizhongwen
 */
public class Token {
    
    /** 令牌类型 */
    TokenKind kind;
    
    /** 数据 */
    String data;
    
    /** 起始位置 */
    int startpos; // index of first character
    
    /** 结束位置 */
    int endpos; // index of char after the last character
    
    /**
     * 
     * 构造函数
     * Constructor for use when there is no particular data for the token (eg. TRUE or '+')
     * 
     * @param tokenKind token kind
     * @param startpos the exact start
     * @param endpos the index to the last character
     */
    Token(TokenKind tokenKind, int startpos, int endpos) {
        this.kind = tokenKind;
        this.startpos = startpos;
        this.endpos = endpos;
    }
    
    /**
     * 
     * 构造函数
     * 
     * @param tokenKind token kind
     * @param tokenData token data
     * @param pos the exact start
     * @param endpos the index to the last character
     */
    Token(TokenKind tokenKind, char[] tokenData, int pos, int endpos) {
        this(tokenKind, pos, endpos);
        this.data = new String(tokenData);
    }
    
    /**
     * 获取令牌类型
     *
     * @return 令牌类型
     */
    public TokenKind getKind() {
        return kind;
    }
    
    /**
     * 字符串
     * 
     * @see java.lang.Object#toString()
     */
    @Override
    public String toString() {
        StringBuilder s = new StringBuilder();
        s.append("[").append(kind.toString());
        if (kind.hasPayload()) {
            s.append(":").append(data);
        }
        s.append("]");
        s.append("(").append(startpos).append(",").append(endpos).append(")");
        return s.toString();
    }
    
    /**
     * 是否为标识符
     *
     * @return 标识符
     */
    public boolean isIdentifier() {
        return kind == TokenKind.IDENTIFIER;
    }
    
    /**
     * 字符串值
     *
     * @return 字符串值
     */
    public String stringValue() {
        return data;
    }
    
}
