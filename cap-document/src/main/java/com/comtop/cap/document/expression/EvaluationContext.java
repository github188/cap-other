/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression;

import static com.comtop.cap.document.util.Assert.notNull;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Stack;

import com.comtop.cap.document.expression.accessor.MethodResolver;
import com.comtop.cap.document.expression.accessor.PropertyAccessor;
import com.comtop.cap.document.expression.accessor.ReflectivePropertyAccessor;
import com.comtop.cap.document.expression.converter.ITypeConverter;
import com.comtop.cap.document.expression.converter.TypeConverter;
import com.comtop.cap.document.expression.support.FunctionCache;
import com.comtop.cap.document.expression.support.ServiceCache;
import com.comtop.cap.document.expression.support.StandardTypeLocator;
import com.comtop.cap.document.expression.support.TypeDescriptor;
import com.comtop.cap.document.expression.support.TypeLocator;
import com.comtop.cap.document.expression.support.TypedValue;
import com.comtop.cap.document.expression.support.ValueObjectCache;

/**
 * 执行上下文默认实现
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月10日 lizhongwen
 */
public class EvaluationContext {
    
    /** 根对象 */
    private TypedValue root;
    
    /** 属性访问器 */
    private List<PropertyAccessor> propertyAccessors;
    
    /** 类型加载器 */
    private TypeLocator typeLocator;
    
    /** 类型转换器 */
    private ITypeConverter converter;
    
    /** 变量 */
    private final Map<String, Object> variables = new HashMap<String, Object>();
    
    /** 服务 */
    private final ServiceCache services = new ServiceCache();
    
    /** VO */
    private final ValueObjectCache valueObjects = new ValueObjectCache();
    
    /** 函数 */
    private final FunctionCache functions = new FunctionCache();
    
    /** 参数栈 */
    private Stack<VariableScope> variableScopes;
    
    /** 上下文对象 */
    private Stack<TypedValue> objects;
    
    /**
     * 构造函数
     */
    public EvaluationContext() {
        setRootObject(null);
    }
    
    /**
     * 构造函数
     * 
     * @param root 根对象
     */
    public EvaluationContext(Object root) {
        this();
        setRootObject(root);
    }
    
    /**
     * @param root 设置根对象为参数root
     */
    public void setRootObject(Object root) {
        if (this.root == null) {
            this.root = TypedValue.NULL;
        } else {
            this.root = new TypedValue(root);// , TypeDescriptor.forObject(rootObject));
        }
    }
    
    /**
     * 设置根对象
     *
     * @param root 根对象
     * @param typeDescriptor 类型描述
     */
    public void setRootObject(Object root, TypeDescriptor typeDescriptor) {
        this.root = new TypedValue(root, typeDescriptor);
    }
    
    /**
     * @return 获取上下文中的跟对象
     */
    public TypedValue getRootObject() {
        return root;
    }
    
    /**
     * @param typeLocator 设置类型加载器
     */
    public void setTypeLocator(TypeLocator typeLocator) {
        notNull(typeLocator, "TypeLocator must not be null");
        this.typeLocator = typeLocator;
    }
    
    /**
     * @return 获取类型加载器
     */
    public TypeLocator getTypeLocator() {
        if (this.typeLocator == null) {
            this.typeLocator = new StandardTypeLocator();
        }
        return this.typeLocator;
    }
    
    /**
     * @param converter 设置类型转换器为converter
     */
    public void setTypeConverter(ITypeConverter converter) {
        notNull(converter, "TypeConverter must not be null");
        this.converter = converter;
    }
    
    /**
     * @return 获取类型转换器
     */
    public ITypeConverter getTypeConverter() {
        if (this.converter == null) {
            this.converter = new TypeConverter();
        }
        return this.converter;
    }
    
    /**
     * @param accessor 添加属性访问器
     */
    public void addPropertyAccessor(PropertyAccessor accessor) {
        ensurePropertyAccessorsInitialized();
        this.propertyAccessors.add(this.propertyAccessors.size() - 1, accessor);
    }
    
    /**
     * 移除属性访问器
     * 
     * @param accessor 访问器
     * @return 是否成功移除
     */
    public boolean removePropertyAccessor(PropertyAccessor accessor) {
        return this.propertyAccessors.remove(accessor);
    }
    
    /**
     * @return 获取属性访问器集合
     */
    public List<PropertyAccessor> getPropertyAccessors() {
        ensurePropertyAccessorsInitialized();
        return this.propertyAccessors;
    }
    
    /**
     * 确保属性访问器集合初始化
     */
    private void ensurePropertyAccessorsInitialized() {
        if (this.propertyAccessors == null) {
            initializePropertyAccessors();
        }
    }
    
    /**
     * 初始化属性访问器集合
     */
    private synchronized void initializePropertyAccessors() {
        if (this.propertyAccessors == null) {
            List<PropertyAccessor> defaultAccessors = new ArrayList<PropertyAccessor>();
            defaultAccessors.add(new ReflectivePropertyAccessor());
            this.propertyAccessors = defaultAccessors;
        }
    }
    
    /**
     * 设置变量
     *
     * @param variables 变量集合
     */
    public void setVariables(Map<String, Object> variables) {
        this.variables.putAll(variables);
    }
    
    /**
     * 设置变量
     *
     * @param name 变量名
     * @param value 变量值
     */
    public void setVariable(String name, Object value) {
        this.variables.put(name, value);
    }
    
    /**
     * 查找变量
     *
     * @param name 变量名
     * @return 变量
     */
    public TypedValue lookupVariable(String name) {
        Object value = this.variables.get(name);
        if (value == null) {
            return TypedValue.NULL;
        }
        return new TypedValue(value, TypeDescriptor.forObject(value));
    }
    
    /**
     * 进入变量域
     *
     * @param args 变量
     */
    public void enterScope(Map<String, Object> args) {
        ensureVariableScopesInitialized();
        this.variableScopes.peek().setVariable(args);
    }
    
    /**
     * 入变量域
     *
     * @param name 变量名
     * @param value 变量值
     */
    public void enterScope(String name, Object value) {
        ensureVariableScopesInitialized();
        this.variableScopes.peek().setVariable(name, value);
    }
    
    /**
     * 出变量域
     */
    public void exitScope() {
        ensureVariableScopesInitialized();
        this.variableScopes.pop();
    }
    
    /**
     * 根据类型名称查找类型
     *
     * @param type 类型名称
     * @return 类型
     * @throws EvaluationException 计算错误
     */
    public Class<?> findType(String type) throws EvaluationException {
        return this.getTypeLocator().findType(type);
    }
    
    /**
     * 转换数据
     *
     * @param value 数据
     * @param target 目标对象类型
     * @return 转换结果
     * @throws EvaluationException 计算错误
     */
    public Object convert(Object value, TypeDescriptor target) throws EvaluationException {
        return this.getTypeConverter().convert(value, TypeDescriptor.forObject(value), target);
    }
    
    /**
     * 转换数据
     *
     * @param value 数据
     * @param target 目标对象类型
     * @return 转换结果
     * @throws EvaluationException 计算错误
     */
    public Object convert(TypedValue value, TypeDescriptor target) throws EvaluationException {
        return this.getTypeConverter().convert(value.getValue(), TypeDescriptor.forObject(value.getValue()), target);
    }
    
    /**
     * 设置本地变量
     *
     * @param name 变量名
     * @param value 变量值
     */
    public void setLocalVariable(String name, Object value) {
        ensureVariableScopesInitialized();
        this.variableScopes.peek().setVariable(name, value);
    }
    
    /**
     * 查找本地变量
     *
     * @param name 变量名
     * @return 变量值
     */
    public Object lookupLocalVariable(String name) {
        ensureVariableScopesInitialized();
        int scopeNumber = this.variableScopes.size() - 1;
        for (int i = scopeNumber; i >= 0; i--) {
            if (this.variableScopes.get(i).definesVariable(name)) {
                return this.variableScopes.get(i).lookupVariable(name);
            }
        }
        return null;
    }
    
    /**
     * 初始化参数域
     */
    private void ensureVariableScopesInitialized() {
        if (this.variableScopes == null) {
            this.variableScopes = new Stack<VariableScope>();
            // top level empty variable scope
            this.variableScopes.add(new VariableScope());
        }
    }
    
    /**
     * 初始化子变量域
     */
    public void initChildVariableScope() {
        ensureVariableScopesInitialized();
        this.variableScopes.add(new VariableScope());
    }
    
    /**
     * 弹出变量域
     */
    public void popVariableScope() {
        ensureVariableScopesInitialized();
        this.variableScopes.pop();
    }
    
    /**
     * 将数据压入栈中
     *
     * @param obj 数据
     */
    public void pushActiveContextObject(TypedValue obj) {
        if (this.objects == null) {
            this.objects = new Stack<TypedValue>();
        }
        this.objects.push(obj);
    }
    
    /**
     * @return 获取当前活动上下文中的对象
     */
    public TypedValue getActiveContextObject() {
        if (this.objects == null || this.objects.isEmpty()) {
            return this.root;
        }
        
        return this.objects.peek();
    }
    
    /**
     * 数据出栈
     * 
     * @return 弹出的对象
     */
    public TypedValue popActiveContextObject() {
        if (this.objects == null) {
            this.objects = new Stack<TypedValue>();
        }
        return this.objects.pop();
    }
    
    /**
     * 注册服务
     * 
     * @param name 名称
     * @param service 服务
     */
    public void registerService(String name, Object service) {
        this.services.registerService(name, service);
    }
    
    /**
     * 设置服务
     *
     * @param services 服务集合
     */
    public void setServices(Map<String, Object> services) {
        this.services.setServices(services);
    }
    
    /**
     * 获取服务
     * 
     * @param name 名称
     * @return 服务
     */
    public Object lookupService(String name) {
        return this.services.lookupService(name);
    }
    
    /**
     * 注册VO
     * 
     * @param name 名称
     * @param voType VO类型
     */
    public void registerValueObject(String name, Class<?> voType) {
        this.valueObjects.registerValueObject(name, voType);
    }
    
    /**
     * 设置VO类型集合
     * 
     * @param valueObjects VO类型集合
     */
    public void setValueObjects(Map<String, Class<?>> valueObjects) {
        this.valueObjects.setValueObjects(valueObjects);
    }
    
    /**
     * 获取VO类型
     * 
     * @param name 名称
     * @return VO类型
     */
    public Class<?> lookupValueObject(String name) {
        return this.valueObjects.lookupValueObject(name);
    }
    
    /**
     * 设置函数
     *
     * @param functions 变量函数
     */
    public void setFunctions(Map<String, Method> functions) {
        this.functions.setFunctions(functions);
    }
    
    /**
     * 注册函数
     *
     * @param name 函数名
     * @param function 函数
     */
    public void registerFunction(String name, Method function) {
        this.functions.registerFunction(name, function);
    }
    
    /**
     * 查找变量
     *
     * @param name 变量名
     * @return 变量
     */
    public Method lookupFunction(String name) {
        return this.functions.lookupFunction(name);
    }
    
    /**
     * @return xxx
     */
    public List<MethodResolver> getMethodResolvers() {
        return null;
    }
    
}
