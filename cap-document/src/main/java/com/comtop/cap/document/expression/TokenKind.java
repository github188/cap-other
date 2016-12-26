/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression;

/**
 * 令牌类型
 * 
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月9日 lizhongwen
 */
public enum TokenKind {
    /** int */
    LITERAL_INT,
    /** long */
    LITERAL_LONG,
    /** 16进制int */
    LITERAL_HEXINT,
    /** 16进制long */
    LITERAL_HEXLONG,
    /** 字符串 */
    LITERAL_STRING,
    /** 实数 */
    LITERAL_REAL,
    /** 浮点数 */
    LITERAL_REAL_FLOAT,
    /** ( */
    LPAREN("("),
    /** ) */
    RPAREN(")"),
    /** , */
    COMMA(","),
    /** id */
    IDENTIFIER,
    /** : */
    COLON(":"),
    /** # */
    HASH("#"),
    /** $ */
    DOLLAR("$"),
    /** ] */
    RSQUARE("]"),
    /** [ */
    LSQUARE("["),
    /** [] */
    ITERABLE("[]"),
    /** { */
    LCURLY("{"),
    /** } */
    RCURLY("}"),
    /** . */
    DOT("."),
    /** ? */
    QMARK("?"),
    /** = */
    ASSIGN("=");
    
    /** 令牌字符串 */
    char[] tokenChars;
    
    /** hasPayload */
    private boolean hasPayload; // is there more to this token than simply the kind
    
    /**
     * 构造函数
     * 
     * @param tokenString 令牌字符串
     */
    private TokenKind(String tokenString) {
        tokenChars = tokenString.toCharArray();
        hasPayload = tokenChars.length == 0;
    }
    
    /**
     * 构造函数
     */
    private TokenKind() {
        this("");
    }
    
    /**
     * 转换为字符串
     * 
     * @see java.lang.Enum#toString()
     */
    @Override
    public String toString() {
        return this.name() + (tokenChars.length != 0 ? "(" + new String(tokenChars) + ")" : "");
    }
    
    /**
     * 是否有效
     *
     * @return 是否有效
     */
    public boolean hasPayload() {
        return hasPayload;
    }
    
    /**
     * 获取长度
     *
     * @return 长度
     */
    public int getLength() {
        return tokenChars.length;
    }
}
