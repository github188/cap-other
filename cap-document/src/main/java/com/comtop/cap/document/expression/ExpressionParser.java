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
import java.util.List;
import java.util.Stack;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.document.expression.ast.Assign;
import com.comtop.cap.document.expression.ast.BooleanLiteral;
import com.comtop.cap.document.expression.ast.Compound;
import com.comtop.cap.document.expression.ast.ExprNodeImpl;
import com.comtop.cap.document.expression.ast.Function;
import com.comtop.cap.document.expression.ast.IterableVariable;
import com.comtop.cap.document.expression.ast.Literal;
import com.comtop.cap.document.expression.ast.MethodRef;
import com.comtop.cap.document.expression.ast.NullLiteral;
import com.comtop.cap.document.expression.ast.PropertyRef;
import com.comtop.cap.document.expression.ast.Reference;
import com.comtop.cap.document.expression.ast.Service;
import com.comtop.cap.document.expression.ast.StringLiteral;
import com.comtop.cap.document.expression.ast.Variable;

/**
 * 表达式解析实现类
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月12日 lizhongwen
 */
public class ExpressionParser implements IExpressionParser {
    
    /** 表达式 */
    private String expr;
    
    /** 词法分析后的表达式Token */
    private List<Token> tokenStream;
    
    /** 表达式Token的个数 */
    private int tokenStreamLength;
    
    /** 当前表达式Token位置 */
    private int tokenStreamPointer;
    
    /** 抽象语法树栈 */
    private Stack<ExprNodeImpl> constructedNodes = new Stack<ExprNodeImpl>();
    
    /**
     * 解析表达式
     *
     * @param expression 表达式字符串
     * @return 表达式对象
     * @throws ParseException 表达式解析异常
     * @see com.comtop.cap.document.expression.IExpressionParser#parse(java.lang.String)
     */
    @Override
    public IExpression parse(String expression) throws ParseException {
        return this.parse(expression, null);
    }
    
    /**
     * 解析表达式
     *
     * @param expression 表达式字符串
     * @param context 表达解析上下文
     * @return 表达式对象
     * @throws ParseException 表达式解析异常
     * @see com.comtop.cap.document.expression.IExpressionParser#parse(java.lang.String,
     *      com.comtop.cap.document.expression.IParseContext)
     */
    @Override
    public IExpression parse(String expression, IParseContext context) throws ParseException {
        IParseContext cxt;
        if (context == null) {
            cxt = IParseContext.NON_TEMPLATE_PARSER_CONTEXT;
        } else {
            cxt = context;
        }
        if (cxt.isTemplate()) {
            return parseTemplate(expression, context);
        }
        return doParse(expression);
    }
    
    /**
     * 解析带有模板的表达式
     *
     * @param expression 表达式
     * @param context 上下文
     * @return 表达式对象
     */
    private IExpression parseTemplate(String expression, IParseContext context) {
        if (StringUtils.isBlank(expression)) {
            return null;
        }
        Expression[] expressions = parseExpressions(expression, context);
        if (expressions.length == 1) {
            return expressions[0];
        }
        return new CompositeExpression(expression, expressions);
    }
    
    /**
     * 解析表达式
     *
     * @param expression 表达式
     * @param context 上下文
     * @return 表达式集合
     */
    private Expression[] parseExpressions(String expression, IParseContext context) {
        return null;
    }
    
    /**
     * 执行表达式解析
     *
     * @param expression 表达式
     * @return 表达式对象
     */
    private IExpression doParse(String expression) {
        this.expr = expression;
        Tokenizer tokenizer = new Tokenizer(expression);
        this.tokenStream = tokenizer.getTokens();
        this.tokenStreamLength = this.tokenStream.size();
        this.tokenStreamPointer = 0;
        this.constructedNodes.clear();
        ExprNodeImpl ast = eatExpression();
        if (moreTokens()) {
            throw new ParseException(peekToken().startpos, MessageFormat.format("表达式:''{0}''格式错误!",
                toString(nextToken())));
        }
        isTrue(constructedNodes.isEmpty());
        return new Expression(expression, ast);
    }
    
    /**
     * 解析表达式
     *
     * @return 表达式抽象语法树节点
     */
    private ExprNodeImpl eatExpression() {
        ExprNodeImpl node = eatPrimaryExpression();
        if (moreTokens()) {
            Token t = peekToken();
            if (TokenKind.ASSIGN == t.kind) { // 赋值表达式 如 a= b
                if (node == null) {
                    node = new NullLiteral(toPos(t.startpos - 1, t.endpos - 1));
                }
                nextToken();
                ExprNodeImpl assignedValue = eatPrimaryExpression();
                return new Assign(toPos(t), node, assignedValue);
            }
        }
        return node;
    }
    
    /**
     * @return 解析主要节点
     */
    private ExprNodeImpl eatPrimaryExpression() {
        List<ExprNodeImpl> nodes = new ArrayList<ExprNodeImpl>();
        ExprNodeImpl start = eatStartNode(); // always a start node
        nodes.add(start);
        while (maybeEatNode()) {
            nodes.add(pop());
        }
        if (nodes.size() == 1) {
            return nodes.get(0);
        }
        return new Compound(toPos(start.getStartPosition(), nodes.get(nodes.size() - 1).getEndPosition()),
            nodes.toArray(new ExprNodeImpl[nodes.size()]));
    }
    
    /**
     * 解析开始节点
     * 
     * @return 表达式抽象语法树节点
     */
    private ExprNodeImpl eatStartNode() {
        if (maybeEatLiteral()) {
            return pop();
        } else if (maybeEatParenExpression()) {
            return pop();
        } else if (maybeEatNullReference() || maybeEatFunctionOrVar()) {
            return pop();
        } else if (maybeEatServiceReference()) {
            return pop();
        } else if (maybeEatReference()) {
            return pop();
        }
        return null;
    }
    
    /**
     * @return 是否读取的只是普通的原文节点
     */
    private boolean maybeEatLiteral() {
        Token t = peekToken();
        if (t == null) {
            return false;
        }
        if (TokenKind.LITERAL_INT == t.kind) {
            push(Literal.getIntLiteral(t.data, toPos(t), 10));
        } else if (TokenKind.LITERAL_LONG == t.kind) {
            push(Literal.getLongLiteral(t.data, toPos(t), 10));
        } else if (TokenKind.LITERAL_HEXINT == t.kind) {
            push(Literal.getIntLiteral(t.data, toPos(t), 16));
        } else if (TokenKind.LITERAL_HEXLONG == t.kind) {
            push(Literal.getLongLiteral(t.data, toPos(t), 16));
        } else if (TokenKind.LITERAL_REAL == t.kind) {
            push(Literal.getRealLiteral(t.data, toPos(t), false));
        } else if (TokenKind.LITERAL_REAL_FLOAT == t.kind) {
            push(Literal.getRealLiteral(t.data, toPos(t), true));
        } else if (peekIdentifierToken("true")) {
            push(new BooleanLiteral(t.data, toPos(t), true));
        } else if (peekIdentifierToken("false")) {
            push(new BooleanLiteral(t.data, toPos(t), false));
        } else if (TokenKind.LITERAL_STRING == t.kind) {
            push(new StringLiteral(t.data, toPos(t), t.data));
        } else {
            return false;
        }
        nextToken();
        return true;
    }
    
    /**
     * @return 解析左圆括号节点
     */
    private boolean maybeEatParenExpression() {
        if (peekToken(TokenKind.LPAREN)) {
            nextToken();
            ExprNodeImpl node = eatExpression();
            eatToken(TokenKind.RPAREN);
            push(node);
            return true;
        }
        return false;
    }
    
    /**
     * @return 解析Null节点
     */
    private boolean maybeEatNullReference() {
        if (peekToken(TokenKind.IDENTIFIER)) {
            Token nullToken = peekToken();
            if (!nullToken.stringValue().equals("null")) {
                return false;
            }
            nextToken();
            constructedNodes.push(new NullLiteral(toPos(nullToken)));
            return true;
        }
        return false;
    }
    
    /**
     * 是否方法或者属性
     *
     * @return 是否处理方法或者属性
     */
    private boolean maybeEatMethodOrProperty() {
        if (peekToken(TokenKind.IDENTIFIER)) {
            Token methodOrPropertyName = nextToken();
            ExprNodeImpl[] args = maybeEatMethodArgs();
            if (args == null) {
                // property
                push(new PropertyRef(methodOrPropertyName.data, toPos(methodOrPropertyName)));
                return true;
            }
            // methodreference
            push(new MethodRef(methodOrPropertyName.data, toPos(methodOrPropertyName), args));
            return true;
        }
        return false;
        
    }
    
    /**
     * @return 解析方法参数
     */
    private ExprNodeImpl[] maybeEatMethodArgs() {
        if (!peekToken(TokenKind.LPAREN)) {
            return null;
        }
        List<ExprNodeImpl> args = new ArrayList<ExprNodeImpl>();
        consumeArguments(args);
        eatToken(TokenKind.RPAREN);
        return args.toArray(new ExprNodeImpl[args.size()]);
    }
    
    /**
     * 解析函数或者变量
     * 
     * @return 表达式抽象语法树节点
     */
    private boolean maybeEatFunctionOrVar() {
        if (!peekToken(TokenKind.DOLLAR)) {
            return false;
        }
        Token t = nextToken();
        Token name = eatToken(TokenKind.IDENTIFIER);
        ExprNodeImpl[] args = maybeEatMethodArgs();
        if (args == null) {
            if (peekToken(TokenKind.ITERABLE, true)) {
                push(new IterableVariable(name.data, toPos(t.startpos, name.endpos)));
            } else {
                push(new Variable(name.data, toPos(t.startpos, name.endpos)));
            }
            return true;
        }
        push(new Function(name.data, toPos(t.startpos, name.endpos), args));
        return true;
    }
    
    /**
     * 解析服务
     * 
     * @return 表达式抽象语法树节点
     */
    private boolean maybeEatServiceReference() {
        if (!peekToken(TokenKind.HASH)) {
            return false;
        }
        Token t = nextToken();
        Token name = eatToken(TokenKind.IDENTIFIER);
        ExprNodeImpl[] args = maybeEatConditions();
        push(new Service(name.data, toPos(t.startpos, name.endpos), args));
        return true;
    }
    
    /**
     * 解析引用
     *
     * @return 表达式抽象语法树节点
     */
    private boolean maybeEatReference() {
        if (peekToken(TokenKind.IDENTIFIER)) {
            Token ref = nextToken();
            if (peekToken(TokenKind.ITERABLE, true)) {
                push(new IterableVariable(ref.data, toPos(ref.startpos, ref.endpos)));
            } else {
                push(new Reference(ref.data, toPos(ref)));
            }
            return true;
        }
        return false;
    }
    
    /**
     * 解析条件表达式
     *
     * @return 表达式抽象语法树节点
     */
    private ExprNodeImpl[] maybeEatConditions() {
        if (!peekToken(TokenKind.LPAREN)) {
            return null;
        }
        List<ExprNodeImpl> condtions = new ArrayList<ExprNodeImpl>();
        consumeConditions(condtions);
        eatToken(TokenKind.RPAREN);
        return condtions.toArray(new ExprNodeImpl[condtions.size()]);
    }
    
    /**
     * @param condtions 条件参数集合
     */
    private void consumeConditions(List<ExprNodeImpl> condtions) {
        int pos = peekToken().startpos;
        Token next = null;
        do {
            nextToken();// consume ( (first time through) or comma (subsequent times)
            Token t = peekToken();
            if (t == null) {
                raiseParseException(pos, "条件配置错误");
            } else if (TokenKind.RPAREN != t.kind) {
                condtions.add(eatExpression());
            }
            next = peekToken();
        } while (next != null && TokenKind.COMMA == next.kind);
        if (next == null) {
            raiseParseException(pos, "条件配置错误");
        }
        
    }
    
    /**
     * @return 解析节点
     */
    private boolean maybeEatNode() {
        ExprNodeImpl node = null;
        if (peekToken(TokenKind.DOT)) {
            node = eatDottedNode();
            push(node);
            return true;
        }
        return false;
    }
    
    /**
     * @return 处理点操作符节点
     */
    private ExprNodeImpl eatDottedNode() {
        Token t = nextToken();
        if (maybeEatMethodOrProperty() || maybeEatFunctionOrVar()) {
            return pop();
        }
        if (peekToken() == null) {
            // unexpectedly ran out of data
            raiseParseException(expr.length(), "未知的输入输出错误！");
        } else {
            raiseParseException(t.startpos, "表达式格式错误，点操作符后的数据''{0}''不符合规则。", toString(peekToken()));
        }
        return null;
    }
    
    /**
     * 检查下一个节点是否满足预期条件
     *
     * @param expectedKind 预期的Token类型
     * @return 下一个节点
     */
    private Token eatToken(TokenKind expectedKind) {
        Token t = nextToken();
        if (t == null) {
            raiseParseException(expr.length(), "未知的输入输出错误！");
        } else if (t.kind != expectedKind) {
            raiseParseException(t.startpos, "错误的Token，Token类型应该为''{0}'',而不是''{1}''!", expectedKind.toString()
                .toLowerCase(), t.getKind().toString().toLowerCase());
        }
        return t;
    }
    
    /**
     * 处理参数
     *
     * @param accumulatedArguments 参数
     */
    private void consumeArguments(List<ExprNodeImpl> accumulatedArguments) {
        int pos = peekToken().startpos;
        Token next = null;
        do {
            nextToken();// consume ( (first time through) or comma (subsequent times)
            Token t = peekToken();
            if (t == null) {
                raiseParseException(pos, "参数错误");
            } else if (TokenKind.RPAREN != t.kind) {
                accumulatedArguments.add(eatExpression());
            }
            next = peekToken();
        } while (next != null && TokenKind.COMMA == next.kind);
        if (next == null) {
            raiseParseException(pos, "参数错误");
        }
    }
    
    /**
     * @param node 将表达式节点压入栈中
     */
    private void push(ExprNodeImpl node) {
        constructedNodes.push(node);
    }
    
    /**
     * @return 弹出一个表达式
     */
    private ExprNodeImpl pop() {
        return constructedNodes.pop();
    }
    
    /**
     * @return 是否还有未解析的表达式Token
     */
    private boolean moreTokens() {
        return tokenStreamPointer < tokenStream.size();
    }
    
    /**
     * @return 获取一个表达式Token
     */
    private Token peekToken() {
        if (tokenStreamPointer >= tokenStreamLength) {
            return null;
        }
        return tokenStream.get(tokenStreamPointer);
    }
    
    /**
     * 检查是否能够获取到满足类型的Token
     *
     * @param desiredTokenKind 类型
     * @return 是否能够获取到满足类型的Token
     */
    private boolean peekToken(TokenKind desiredTokenKind) {
        return peekToken(desiredTokenKind, false);
    }
    
    /**
     * 检查是否能够获取到满足类型的Token
     *
     * @param desiredTokenKind 类型
     * @param consumeIfMatched true表示如果满足则进行消费，当前索引下一一位
     * @return 是否能够获取到满足类型的Token
     */
    private boolean peekToken(TokenKind desiredTokenKind, boolean consumeIfMatched) {
        if (!moreTokens()) {
            return false;
        }
        Token t = peekToken();
        if (desiredTokenKind == t.kind) {
            if (consumeIfMatched) {
                tokenStreamPointer++;
            }
            return true;
        }
        return false;
    }
    
    /**
     * 获取一个标识符Token
     *
     * @param identifier 标识符内容
     * @return 标识符Token
     */
    private boolean peekIdentifierToken(String identifier) {
        if (!moreTokens()) {
            return false;
        }
        Token t = peekToken();
        return t.kind == TokenKind.IDENTIFIER && t.stringValue().equalsIgnoreCase(identifier);
    }
    
    /**
     * @return 获取下一个表达式Token
     */
    private Token nextToken() {
        if (tokenStreamPointer >= tokenStreamLength) {
            return null;
        }
        return tokenStream.get(tokenStreamPointer++);
    }
    
    /**
     * 将Token中的起始值和结束值压缩到一个整数中
     * 
     * @param t token
     * @return 压缩后的的值
     */
    private int toPos(Token t) {
        return (t.startpos << 16) + t.endpos;
    }
    
    /**
     * 将Token中的起始值和结束值压缩到一个整数中
     * 
     * @param start 起始值
     * @param end 结束值
     * @return 压缩后的的值
     */
    private int toPos(int start, int end) {
        return (start << 16) + end;
    }
    
    /**
     * 将表达式Token转换为字符串格式
     *
     * @param t Token
     * @return 字符串
     */
    public String toString(Token t) {
        if (t.getKind().hasPayload()) {
            return t.stringValue();
        }
        return t.kind.toString().toLowerCase();
    }
    
    /**
     * 抛出解析异常
     *
     * @param pos 当前位置
     * @param pattern 错误消息格式化字符串
     * @param inserts 参数
     */
    private void raiseParseException(int pos, String pattern, Object... inserts) {
        throw new ParseException(expr, pos, MessageFormat.format(pattern, inserts));
    }
}
