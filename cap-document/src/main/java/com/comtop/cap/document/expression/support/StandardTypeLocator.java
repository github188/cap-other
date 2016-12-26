/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression.support;

import static com.comtop.cap.document.util.ClassUtils.getDefaultClassLoader;

import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.document.expression.EvaluationException;

/**
 * 默认实现的类型加载器
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月10日 lizhongwen
 */
public class StandardTypeLocator implements TypeLocator {
	/** 日志 */
    protected static final Logger LOGGER = LoggerFactory.getLogger(StandardTypeLocator.class);
	
    /** 类加载器 */
    private ClassLoader loader;
    
    /** 常用的包前缀 */
    private final List<String> knownPackagePrefixes = new ArrayList<String>();
    
    /**
     * 构造函数
     */
    public StandardTypeLocator() {
        this(getDefaultClassLoader());
    }
    
    /**
     * 构造函数
     * 
     * @param loader 类加载器
     */
    public StandardTypeLocator(ClassLoader loader) {
        this.loader = loader;
        // Similar to when writing Java, it only knows about java.lang by default
        registerImport("java.lang");
    }
    
    /**
     * 
     * @see com.comtop.cap.document.expression.support.TypeLocator#findType(java.lang.String)
     */
    @Override
    public Class<?> findType(String typeName) throws EvaluationException {
        String nameToLookup = typeName;
        try {
            return this.loader.loadClass(nameToLookup);
        } catch (ClassNotFoundException ey) {
            // try any registered prefixes before giving up
        	LOGGER.debug("class not found.", ey);
        }
        for (String prefix : this.knownPackagePrefixes) {
            try {
                nameToLookup = new StringBuilder().append(prefix).append(".").append(typeName).toString();
                return this.loader.loadClass(nameToLookup);
            } catch (ClassNotFoundException ex) {
                // might be a different prefix
            	LOGGER.debug("class not found.", ex);
            }
        }
        throw new EvaluationException(MessageFormat.format("找不到指定类型名称''{0}''的类", typeName));
    }
    
    /**
     * 注册包前缀
     *
     * @param prefix 前缀
     */
    public void registerImport(String prefix) {
        this.knownPackagePrefixes.add(prefix);
    }
    
    /**
     * @return 获取包前缀集合
     */
    public List<String> getImportPrefixes() {
        return Collections.unmodifiableList(this.knownPackagePrefixes);
    }
    
    /**
     * @param prefix 移除包前缀
     */
    public void removeImport(String prefix) {
        this.knownPackagePrefixes.remove(prefix);
    }
    
}
