/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.common.expression;

/**
 * Holder for a kind of token
 * 
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2015-6-2 李忠文
 */
public class Token {
    
    /** kind */
    private final TokenKind kind;
    
    /** data */
    private final String data;
    
    /** expr */
    private final String expr;
    
    /** 起始位置 */
    private final int start;
    
    /** 结束位置 */
    private final int end;
    
    /**
     * Constructor for use when there is no particular data for the token (eg. TRUE or
     * '+')
     * 
     * @param tokenKind tokenKind
     * @param data the data
     * @param expr the expr
     * @param start the start
     * @param end  the end
     */
    Token(TokenKind tokenKind, String data, String expr,int start,int end) {
        this.kind = tokenKind;
        this.data = data;
        this.expr = expr;
        this.start = start;
        this.end = end;
    }
    
    /**
     * @return tokenKind
     */
    public TokenKind getKind() {
        return this.kind;
    }
    
    /**
     * @return 获取 data属性值
     */
    public String getData() {
        return data;
    }
    
    /**
     * @return 获取 expr属性值
     */
    public String getExpr() {
        return expr;
    }
    
    
    /**
     * @return 获取 start属性值
     */
    public int getStart() {
        return start;
    }

    
    /**
     * @return 获取 end属性值
     */
    public int getEnd() {
        return end;
    }

    /**
     * 
     * @see java.lang.Object#toString()
     */
    @Override
    public String toString() {
        return "Token [kind=" + kind + ", expr=" + expr + "]";
    }
}
