/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression;

import static com.comtop.cap.document.util.Assert.isTrue;

import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * 词法分析
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月9日 lizhongwen
 */
public class Tokenizer {
    
    /** 表达式字符串 */
    String expression;
    
    /** 待解析字符数组 */
    char[] toProcess;
    
    /** 当前位置 */
    int pos;
    
    /** 最大位置 */
    int max;
    
    /** 令牌集合 */
    List<Token> tokens = new ArrayList<Token>();
    
    /**
     * 构造函数
     * 
     * @param expression 输入数据
     */
    public Tokenizer(String expression) {
        this.expression = expression;
        this.toProcess = (expression + "\0").toCharArray();
        this.max = toProcess.length;
        this.pos = 0;
        process();
    }
    
    /**
     * 表达式处理
     */
    public void process() {
        while (pos < max) {
            char ch = toProcess[pos];
            if (isAlphabetic(ch)) {
                lexIdentifier();
            } else {
                switch (ch) {
                    case '_': // the other way to start an identifier
                        lexIdentifier();
                        break;
                    case ':':
                        pushCharToken(TokenKind.COLON);
                        break;
                    case '.':
                        pushCharToken(TokenKind.DOT);
                        break;
                    case ',':
                        pushCharToken(TokenKind.COMMA);
                        break;
                    case '(':
                        pushCharToken(TokenKind.LPAREN);
                        break;
                    case ')':
                        pushCharToken(TokenKind.RPAREN);
                        break;
                    case '[':
                        if (isTwoCharToken(TokenKind.ITERABLE)) {
                            pushPairToken(TokenKind.ITERABLE);
                        } else {
                            pushCharToken(TokenKind.LSQUARE);
                        }
                        break;
                    case '#':
                        pushCharToken(TokenKind.HASH);
                        break;
                    case ']':
                        pushCharToken(TokenKind.RSQUARE);
                        break;
                    case '{':
                        pushCharToken(TokenKind.LCURLY);
                        break;
                    case '}':
                        pushCharToken(TokenKind.RCURLY);
                        break;
                    case '=':
                        pushCharToken(TokenKind.ASSIGN);
                        break;
                    case '?':
                        pushCharToken(TokenKind.QMARK);
                        break;
                    case '$':
                        pushCharToken(TokenKind.DOLLAR);
                        break;
                    case '0':
                    case '1':
                    case '2':
                    case '3':
                    case '4':
                    case '5':
                    case '6':
                    case '7':
                    case '8':
                    case '9':
                        lexNumericLiteral(ch == '0');
                        break;
                    case ' ':
                    case '\t':
                    case '\r':
                    case '\n':
                        // drift over white space
                        pos++;
                        break;
                    case '\'':
                        lexQuotedStringLiteral();
                        break;
                    case '"':
                        lexDoubleQuotedStringLiteral();
                        break;
                    case 0:
                        // hit sentinel at end of value
                        pos++; // will take us to the end
                        break;
                    default:
                        throw new IllegalStateException("Cannot handle (" + Integer.valueOf(ch) + ") '" + ch + "'");
                }
            }
        }
    }
    
    /**
     * @return 获取令牌集合
     */
    public List<Token> getTokens() {
        return tokens;
    }
    
    /**
     * 逐字符分析单引号字符串
     * STRING_LITERAL: '\''! (APOS|~'\'')* '\''!;
     */
    private void lexQuotedStringLiteral() {
        int start = pos;
        boolean terminated = false;
        while (!terminated) {
            pos++;
            char ch = toProcess[pos];
            if (ch == '\'') {
                // may not be the end if the char after is also a '
                if (toProcess[pos + 1] == '\'') {
                    pos++; // skip over that too, and continue
                } else {
                    terminated = true;
                }
            }
            if (ch == 0) {
                throw new ParseException(expression, start, "找不到结束的'.");
            }
        }
        pos++;
        tokens.add(new Token(TokenKind.LITERAL_STRING, subarray(start, pos), start, pos));
    }
    
    /**
     * 逐字符分析双引号字符串
     * DQ_STRING_LITERAL: '"'! (~'"')* '"'!;
     */
    private void lexDoubleQuotedStringLiteral() {
        int start = pos;
        boolean terminated = false;
        while (!terminated) {
            pos++;
            char ch = toProcess[pos];
            if (ch == '"') {
                terminated = true;
            }
            if (ch == 0) {
                throw new ParseException(expression, start, "找不到结束的\".");
            }
        }
        pos++;
        tokens.add(new Token(TokenKind.LITERAL_STRING, subarray(start, pos), start, pos));
    }
    
    /**
     * 逐字符分析数字
     * REAL_LITERAL :
     * ('.' (DECIMAL_DIGIT)+ (EXPONENT_PART)? (REAL_TYPE_SUFFIX)?) |
     * ((DECIMAL_DIGIT)+ '.' (DECIMAL_DIGIT)+ (EXPONENT_PART)? (REAL_TYPE_SUFFIX)?) |
     * ((DECIMAL_DIGIT)+ (EXPONENT_PART) (REAL_TYPE_SUFFIX)?) |
     * ((DECIMAL_DIGIT)+ (REAL_TYPE_SUFFIX));
     * fragment INTEGER_TYPE_SUFFIX : ( 'L' | 'l' );
     * fragment HEX_DIGIT : '0'|'1'|'2'|'3'|'4'|'5'|'6'|'7'|'8'|'9'|'A'|'B'|'C'|'D'|'E'|'F'|'a'|'b'|'c'|'d'|'e'|'f';
     * 
     * fragment EXPONENT_PART : 'e' (SIGN)* (DECIMAL_DIGIT)+ | 'E' (SIGN)* (DECIMAL_DIGIT)+ ;
     * fragment SIGN : '+' | '-' ;
     * fragment REAL_TYPE_SUFFIX : 'F' | 'f' | 'D' | 'd';
     * INTEGER_LITERAL
     * : (DECIMAL_DIGIT)+ (INTEGER_TYPE_SUFFIX)?;
     *
     * @param firstCharIsZero 首字符是否为0
     */
    private void lexNumericLiteral(boolean firstCharIsZero) {
        boolean isReal = false;
        int start = pos;
        char ch = toProcess[pos + 1];
        boolean isHex = ch == 'x' || ch == 'X';
        
        // deal with hexadecimal
        if (firstCharIsZero && isHex) {
            pos = pos + 1;
            do {
                pos++;
            } while (isHexadecimalDigit(toProcess[pos]));
            if (isChar('L', 'l')) {
                pushHexIntToken(subarray(start + 2, pos), true, start, pos);
                pos++;
            } else {
                pushHexIntToken(subarray(start + 2, pos), false, start, pos);
            }
            return;
        }
        
        // real numbers must have leading digits
        
        // Consume first part of number
        do {
            pos++;
        } while (isDigit(toProcess[pos]));
        
        // a '.' indicates this number is a real
        ch = toProcess[pos];
        if (ch == '.') {
            isReal = true;
            // carry on consuming digits
            do {
                pos++;
            } while (isDigit(toProcess[pos]));
        }
        
        int endOfNumber = pos;
        
        // Now there may or may not be an exponent
        
        // is it a long ?
        if (isChar('L', 'l')) {
            if (isReal) { // 3.4L - not allowed
                throw new ParseException(expression, start, "浮点数不能以L或者l结尾.");
            }
            pushIntToken(subarray(start, endOfNumber), true, start, endOfNumber);
            pos++;
        } else if (isExponentChar(toProcess[pos])) {
            isReal = true; // if it wasnt before, it is now
            pos++;
            char possibleSign = toProcess[pos];
            if (isSign(possibleSign)) {
                pos++;
            }
            
            // exponent digits
            do {
                pos++;
            } while (isDigit(toProcess[pos]));
            boolean isFloat = false;
            if (isFloatSuffix(toProcess[pos])) {
                isFloat = true;
                endOfNumber = ++pos;
            } else if (isDoubleSuffix(toProcess[pos])) {
                endOfNumber = ++pos;
            }
            pushRealToken(subarray(start, pos), isFloat, start, pos);
        } else {
            ch = toProcess[pos];
            boolean isFloat = false;
            if (isFloatSuffix(ch)) {
                isReal = true;
                isFloat = true;
                endOfNumber = ++pos;
            } else if (isDoubleSuffix(ch)) {
                isReal = true;
                endOfNumber = ++pos;
            }
            if (isReal) {
                pushRealToken(subarray(start, endOfNumber), isFloat, start, endOfNumber);
            } else {
                pushIntToken(subarray(start, endOfNumber), false, start, endOfNumber);
            }
        }
    }
    
    /** if this is changed, it must remain sorted */
    private static final String[] alternativeOperatorNames = { "DIV", "EQ", "GE", "GT", "LE", "LT", "MOD", "NE", "NOT" };
    
    /**
     * 分析标识符
     */
    private void lexIdentifier() {
        int start = pos;
        do {
            pos++;
        } while (isIdentifier(toProcess[pos]));
        char[] subarray = subarray(start, pos);
        
        // Check if this is the alternative (textual) representation of an operator (see alternativeOperatorNames)
        if ((pos - start) == 2 || (pos - start) == 3) {
            String asString = new String(subarray).toUpperCase();
            int idx = Arrays.binarySearch(alternativeOperatorNames, asString);
            if (idx >= 0) {
                pushOneCharOrTwoCharToken(TokenKind.valueOf(asString), start);
                return;
            }
        }
        tokens.add(new Token(TokenKind.IDENTIFIER, subarray, start, pos));
    }
    
    /**
     * 
     * 添加int token
     *
     * @param data 数据
     * @param isLong 是否为long
     * @param start 开始位置
     * @param end 结束位置
     */
    private void pushIntToken(char[] data, boolean isLong, int start, int end) {
        if (isLong) {
            tokens.add(new Token(TokenKind.LITERAL_LONG, data, start, end));
        } else {
            tokens.add(new Token(TokenKind.LITERAL_INT, data, start, end));
        }
    }
    
    /**
     * 添加16进制 token
     *
     * @param data 数据
     * @param isLong 是否为长整型
     * @param start 开始位置
     * @param end 结束位置
     */
    private void pushHexIntToken(char[] data, boolean isLong, int start, int end) {
        if (data.length == 0) {
            if (isLong) {
                throw new ParseException(expression, start, MessageFormat.format("数据''{0}''不能被解析为long",
                    expression.substring(start, end + 1)));
            }
            throw new ParseException(expression, start, MessageFormat.format("数据''{0}''不能被解析为int",
                expression.substring(start, end + 1)));
        }
        if (isLong) {
            tokens.add(new Token(TokenKind.LITERAL_HEXLONG, data, start, end));
        } else {
            tokens.add(new Token(TokenKind.LITERAL_HEXINT, data, start, end));
        }
    }
    
    /**
     * 添加实数 token
     *
     * @param data 数据
     * @param isFloat 是否为长整型
     * @param start 开始位置
     * @param end 结束位置
     */
    private void pushRealToken(char[] data, boolean isFloat, int start, int end) {
        if (isFloat) {
            tokens.add(new Token(TokenKind.LITERAL_REAL_FLOAT, data, start, end));
        } else {
            tokens.add(new Token(TokenKind.LITERAL_REAL, data, start, end));
        }
    }
    
    /**
     * 子数组
     *
     * @param start 开始位置
     * @param end 结束位置
     * @return 字符串数组
     */
    private char[] subarray(int start, int end) {
        char[] result = new char[end - start];
        System.arraycopy(toProcess, start, result, 0, end - start);
        return result;
    }
    
    /**
     * 
     * Check if this might be a two character token.
     *
     * @param kind 令牌类型
     * @return 是否又双符号组成的Token
     */
    private boolean isTwoCharToken(TokenKind kind) {
        isTrue(kind.tokenChars.length == 2);
        isTrue(toProcess[pos] == kind.tokenChars[0]);
        return toProcess[pos + 1] == kind.tokenChars[1];
    }
    
    /**
     * 
     * Push a token of just one character in length.
     *
     * @param kind 令牌类型
     */
    private void pushCharToken(TokenKind kind) {
        tokens.add(new Token(kind, pos, pos + 1));
        pos++;
    }
    
    /**
     * 
     * Push a token of two characters in length.
     *
     * @param kind 令牌类型
     */
    private void pushPairToken(TokenKind kind) {
        tokens.add(new Token(kind, pos, pos + 2));
        pos += 2;
    }
    
    /**
     * Push a token of one or two characters in length.
     *
     * @param kind 令牌类型
     * @param start 起始位置
     */
    private void pushOneCharOrTwoCharToken(TokenKind kind, int start) {
        tokens.add(new Token(kind, start, start + kind.getLength()));
    }
    
    /**
     * ID: ('a'..'z'|'A'..'Z'|'_'|'$') ('a'..'z'|'A'..'Z'|'_'|'$'|'0'..'9'|DOT_ESCAPED)*;
     *
     * @param ch 字符
     * @return 是否标识符
     */
    private boolean isIdentifier(char ch) {
        return isAlphabetic(ch) || isDigit(ch) || ch == '_' || ch == '$' || ch == '@';
    }
    
    /**
     * 是否为字符
     *
     * @param a 字符a
     * @param b 字符b
     * @return 是否字符
     */
    private boolean isChar(char a, char b) {
        char ch = toProcess[pos];
        return ch == a || ch == b;
    }
    
    /**
     * 是否科学计数法
     *
     * @param ch 字符
     * @return 是否科学计数法
     */
    private boolean isExponentChar(char ch) {
        return ch == 'e' || ch == 'E';
    }
    
    /**
     * 是否浮点数结束符
     * 
     * @param ch 字符
     * @return 是否浮点数结束符
     */
    private boolean isFloatSuffix(char ch) {
        return ch == 'f' || ch == 'F';
    }
    
    /**
     * 是否双精度浮点数结束符
     * 
     * @param ch 字符
     * @return 是否双精度浮点数结束符
     */
    private boolean isDoubleSuffix(char ch) {
        return ch == 'd' || ch == 'D';
    }
    
    /**
     * 是否符号
     * 
     * @param ch 字符
     * @return 是否符号
     */
    private boolean isSign(char ch) {
        return ch == '+' || ch == '-';
    }
    
    /**
     * 是否为数字
     *
     * @param ch 字符
     * @return 是否数字
     */
    private boolean isDigit(char ch) {
        if (ch > 255) {
            return false;
        }
        return (flags[ch] & IS_DIGIT) != 0;
    }
    
    /**
     * 是否为字母
     *
     * @param ch 字符
     * @return 是否为字母
     */
    private boolean isAlphabetic(char ch) {
        if (ch > 255) {
            return false;
        }
        return (flags[ch] & IS_ALPHA) != 0;
    }
    
    /**
     * 
     * 是否为十六进制数字
     *
     * @param ch 字符
     * @return 是否为十六进制数字
     */
    private boolean isHexadecimalDigit(char ch) {
        if (ch > 255) {
            return false;
        }
        return (flags[ch] & IS_HEXDIGIT) != 0;
    }
    
    /** 标识数组 */
    private static final byte flags[] = new byte[256];
    
    /** 数字 */
    private static final byte IS_DIGIT = 0x01;
    
    /** 十六进制数字 */
    private static final byte IS_HEXDIGIT = 0x02;
    
    /** 字母 */
    private static final byte IS_ALPHA = 0x04;
    
    static {
        for (int ch = '0'; ch <= '9'; ch++) {
            flags[ch] |= IS_DIGIT | IS_HEXDIGIT;
        }
        for (int ch = 'A'; ch <= 'F'; ch++) {
            flags[ch] |= IS_HEXDIGIT;
        }
        for (int ch = 'a'; ch <= 'f'; ch++) {
            flags[ch] |= IS_HEXDIGIT;
        }
        for (int ch = 'A'; ch <= 'Z'; ch++) {
            flags[ch] |= IS_ALPHA;
        }
        for (int ch = 'a'; ch <= 'z'; ch++) {
            flags[ch] |= IS_ALPHA;
        }
    }
}
