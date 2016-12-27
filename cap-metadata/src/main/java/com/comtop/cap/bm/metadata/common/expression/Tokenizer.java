/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.common.expression;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.comtop.cip.jodd.util.StringUtil;

/**
 * Lex some input data into a stream of tokens that can then be parsed.
 * 
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2015-6-2 李忠文
 */
public class Tokenizer {
    
    /** 匹配正则表达式 */
    private final static String REGEX = "#\\{(\\w+(\\.\\w+)*)\\}";
    
    /** 表达式 */
    private final String expression;
    
    /** 最大长度*/
    private final int max;
    
    /** tokens */
    List<Token> tokens = new ArrayList<Token>();
    
    /**
     * 构造函数
     * 
     * @param expression expression
     */
    public Tokenizer(String expression) {
        this.expression = clean(expression);
        this.max = this.expression.length();
        this.process();
    }
    
    /**
     * 清理表达式
     * 
     * 
     * @param expr 表达
     * @return 清理后的表达式
     */
    private String clean(String expr) {
        if (StringUtil.isBlank(expr)) {
            return null;
        }
        String strResult = expr;
        while (strResult.contains("\n")) {
            strResult = strResult.replace("\n", " ");
        }
        while (strResult.contains("\t")) {
            strResult = strResult.replace("\t", " ");
        }
        while (strResult.contains("\r")) {
            strResult = strResult.replace("\r", " ");
        }
        while (strResult.contains("  ")) {
            strResult = strResult.replace("  ", " ");
        }
        while (strResult.contains(">")) {
            strResult = strResult.replace(">", "&gt;");
        }
        while (strResult.contains("<")) {
            strResult = strResult.replace("<", "&lt;");
        }
        return strResult;
    }
    
    /**
     * 表达式解析
     * 
     */
    private void process() {
        if (StringUtil.isBlank(this.expression)) {
            return;
        }
        Pattern objPattern = Pattern.compile(REGEX);
        Matcher objMatcher = objPattern.matcher(this.expression);
        String strData;
        String objExpr;
        while (objMatcher.find()) {
            objExpr = objMatcher.group(0);
            int iStart = objMatcher.start(0);
            int iLen = objExpr.length();
            strData = objMatcher.group(1);
            TokenKind objKind = isInKind(iStart, iLen) ? TokenKind.IN : TokenKind.NORMAL;
            this.tokens.add(new Token(objKind, strData, objExpr,iStart,iStart + iLen));
        }
    }
    
    /**
     * 是否为IN操作
     * 
     * @param start 表达式的起始位置
     * @param length 表达式长度
     * @return true/false
     */
    private boolean isInKind(int start, int length) {
        if (start >= 0 && start + length <= max) {
            String[] strParts = this.expression.substring(0, start).split(" ");
            if (strParts != null && strParts.length > 0) {
                String strOpt = strParts[strParts.length - 1];
                if ("IN".equalsIgnoreCase(strOpt)) {
                    return true;
                }
            }
        }
        return false;
    }
    
    /**
     * @return 获取 expression属性值
     */
    public String getExpression() {
        return expression;
    }
    
    /**
     * @return 获取 tokens属性值
     */
    public List<Token> getTokens() {
        return tokens;
    }

    /**
     * @return 获取 max属性值
     */
    public int getMax() {
        return max;
    }
    
}
