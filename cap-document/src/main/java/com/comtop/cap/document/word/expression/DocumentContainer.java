/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.expression;

import static com.comtop.cap.document.util.Assert.notNull;
import static java.text.MessageFormat.format;

import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.IllegalClassException;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.document.expression.annotation.DocumentService;
import com.comtop.cap.document.expression.annotation.DocumentServices;
import com.comtop.cap.document.expression.annotation.Function;
import com.comtop.cap.document.expression.support.ServiceCache;
import com.comtop.cap.document.util.ReflectionHelper;
import com.comtop.cap.document.word.docmodel.datatype.EmbedType;

/**
 * 文档容器，该容器不允许外部使用，因为该容器的初始化时通过Configuration对象完成，获取的实例可能并未完成初始化操作
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月18日 lizhongwen
 */
class DocumentContainer implements IDocumentRegister {
	/**
     * logger
     */
    protected static final Logger LOGGER = LoggerFactory.getLogger(EmbedType.class);
    
    /** 函数 */
    private final Map<String, Method> functions = new HashMap<String, Method>();
    
    /** 服务 */
    private final Map<String, Object> services = new HashMap<String, Object>();
    
    /** VO */
    private final Map<String, Class<?>> valueObjects = new HashMap<String, Class<?>>();
    
    /** 容器 */
    private static final DocumentContainer CONTAINER = new DocumentContainer();
    
    /** 是否初始化完成 */
    private boolean initialize;
    
    /**
     * 构造函数
     */
    private DocumentContainer() {
        
    }
    
    /**
     * @return 获取容器实例,不要直接获取容器实例，如果需要一定要从Configuration中获取
     */
    public static final DocumentContainer getInstance() {
        return CONTAINER;
    }
    
    /**
     * 设置默认服务
     *
     * @param defautService 默认服务对象
     */
    @Override
    public void setDefaultService(final Object defautService) {
        notNull(defautService);
        this.registService(ServiceCache.DEFAULT_SERVICE, defautService.getClass(), Object.class, defautService);
    }
    
    /**
     * 注册服务
     * 
     * @param type 服务类型
     * @see com.comtop.cap.document.word.expression.IDocumentRegister#registerService(java.lang.Class)
     */
    @Override
    public void registerService(final Class<?> type) {
        notNull(type);
        this.registerService(type, ReflectionHelper.instance(type));
    }
    
    /**
     * 注册服务
     * 
     * @param service 服务对象
     * @see com.comtop.cap.document.word.expression.IDocumentRegister#registerService(java.lang.Object)
     */
    @Override
    public void registerService(final Object service) {
        notNull(service);
        this.registerService(service.getClass(), service);
    }
    
    /**
     * 注册服务
     * 
     * @param type 服务类型
     * @param service 服务对象
     * @see com.comtop.cap.document.word.expression.IDocumentRegister#registerService(java.lang.Class, java.lang.Object)
     */
    @Override
    public void registerService(final Class<?> type, final Object service) {
        notNull(type);
        DocumentService anno = type.getAnnotation(DocumentService.class);
        if (anno != null) {
            registerService(type, service, anno, false);
        } else {
            DocumentServices annotation = type.getAnnotation(DocumentServices.class);
            if (annotation == null) {
                throw new IllegalClassException(format("类''{0}''上找不到@DocumentService或者@DocumentServics注解！",
                    type.getSimpleName()));
            }
            DocumentService[] value = annotation.value();
            if (services == null || value.length == 0) {
                throw new IllegalClassException(format("类''{0}''上注解@DocumentServics使用错误！", type.getSimpleName()));
            }
            for (DocumentService documentService : value) {
                registerService(type, service, documentService, true);
            }
        }
    }
    
    /**
     * 注册服务
     *
     * @param type 服务类型
     * @param service 服务对象
     * @param anno 服务注解
     * @param useValueName 是否使用数据类型作为缺省名称
     */
    private void registerService(final Class<?> type, final Object service, final DocumentService anno,
        final boolean useValueName) {
        String name = anno.name();
        if (StringUtils.isBlank(name) && !useValueName) {
            name = StringUtils.capitalize(type.getSimpleName());
        }
        Class<?> dataType = anno.dataType();
        if (Object.class.equals(dataType)) {
            if (service != null && !type.equals(service.getClass())) {
                throw new IllegalClassException(format("类''{0}''与指定的服务对象''{1}''的类型不匹配！", type.getSimpleName(),
                    service.getClass()));
            } else if (service == null) {
                this.setDefaultService(ReflectionHelper.instance(type));
            } else if (service != null) {
                this.setDefaultService(service);
            }
        } else {
            if (StringUtils.isBlank(name) && useValueName) {
                name = StringUtils.capitalize(dataType.getSimpleName());
            }
            this.valueObjects.put(name, dataType);
        }
        registService(name, type, dataType, service);
    }
    
    /**
     * 注册服务
     *
     * @param name 服务名称
     * @param type 服务类型
     * @param voType 值对象类型
     * @param service 服务对象，如果该服务与其他应用进行共享的话，可以直接将其他应用的服务对象直接注入进来。
     */
    public void registService(String name, final Class<?> type, final Class<?> voType, final Object service) {
        notNull(voType);
        if (type == null && service == null) {
            throw new IllegalArgumentException("参数服务类型（type）和服务对象（service）不能同时为空！");
        }
        this.valueObjects.put(name, voType);
        Class<?> clazz = type;
        Object serviceObj = service;
        if (clazz == null) {
            clazz = service.getClass();
        } else if (serviceObj == null) {
            serviceObj = ReflectionHelper.instance(type);
        }
        String loadName = format("load{0}List", name);
        String saveName = format("save{0}List", name);
        try {
            Method load = clazz.getMethod(loadName, voType);
            this.functions.put(format("{0}#load", name), load);
        } catch (NoSuchMethodException e) {
        	LOGGER.debug("No such method.", e);
            try {
                Method load = clazz.getMethod("loadData", Object.class);
                this.functions.put(format("{0}#load", name), load);
            } catch (NoSuchMethodException ex) {
            	LOGGER.debug("No such method.", ex);
                throw new IllegalClassException(format("类''{0}''上找不到''{1}''或者'loadData'方法！", clazz.getSimpleName(),
                    loadName));
            }
        }
        try {
            Method save = clazz.getMethod(saveName, List.class);
            this.functions.put(format("{0}#save", name), save);
        } catch (Exception e) {
        	LOGGER.debug("error", e);
            try {
                Method save = clazz.getMethod("saveData", List.class);
                this.functions.put(format("{0}#save", name), save);
            } catch (Exception ex) {
            	LOGGER.debug("error", ex);
                throw new IllegalClassException(format("类''{0}''上找不到''{1}''或者'saveData'方法！！", clazz.getSimpleName(),
                    saveName));
            }
        }
        this.services.put(name, serviceObj);
    }
    
    /**
     * 注册函数
     *
     * @param type 函数所在的类
     * @see com.comtop.cap.document.word.expression.IDocumentRegister#registerFunction(java.lang.Class)
     */
    @Override
    public void registerFunction(Class<?> type) {
        notNull(type);
        Method[] methods = type.getMethods();
        for (Method method : methods) {
            if (method.isAnnotationPresent(Function.class)) {
                Function function = method.getAnnotation(Function.class);
                if (Modifier.isPublic(method.getModifiers()) && Modifier.isStatic(method.getModifiers())) {
                    this.functions.put(function.name(), method);
                }
            }
        }
    }
    
    /**
     * @return 获取 functions属性值
     */
    public Map<String, Method> getFunctions() {
        return functions;
    }
    
    /**
     * @return 获取 services属性值
     */
    public Map<String, Object> getServices() {
        return services;
    }
    
    /**
     * @return 获取 valueObjects属性值
     */
    public Map<String, Class<?>> getValueObjects() {
        return valueObjects;
    }
    
    /**
     * @return 获取 initialize属性值
     */
    public boolean isInitialize() {
        return initialize;
    }
    
    /**
     * 重置为空容器
     */
    public void reset() {
        this.initialize = false;
        this.functions.clear();
        this.services.clear();
        this.valueObjects.clear();
    }
    
    /**
     * 初始化完成
     */
    void initialized() {
        this.initialize = true;
    }
    
    /**
     * 获得值对象
     *
     * @param name 名称
     * @return 值对象类型
     */
    public Class<?> getValueObject(String name) {
        return this.valueObjects.get(name);
    }
    
    /**
     * 注册结束
     * 
     * @see com.comtop.cap.document.word.expression.IDocumentRegister#registed()
     */
    @Override
    public void registed() {
        this.initialized();
    }
    
}
