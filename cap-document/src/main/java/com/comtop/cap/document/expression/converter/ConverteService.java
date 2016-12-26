/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression.converter;

import java.io.File;
import java.lang.reflect.Array;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.net.URL;
import java.sql.Timestamp;
import java.util.Calendar;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.eic.apache.commons.beanutils.Converter;
import com.comtop.eic.apache.commons.beanutils.converters.ArrayConverter;
import com.comtop.eic.apache.commons.beanutils.converters.BigDecimalConverter;
import com.comtop.eic.apache.commons.beanutils.converters.BigIntegerConverter;
import com.comtop.eic.apache.commons.beanutils.converters.BooleanConverter;
import com.comtop.eic.apache.commons.beanutils.converters.ByteConverter;
import com.comtop.eic.apache.commons.beanutils.converters.CalendarConverter;
import com.comtop.eic.apache.commons.beanutils.converters.CharacterConverter;
import com.comtop.eic.apache.commons.beanutils.converters.ClassConverter;
import com.comtop.eic.apache.commons.beanutils.converters.DateConverter;
import com.comtop.eic.apache.commons.beanutils.converters.DoubleConverter;
import com.comtop.eic.apache.commons.beanutils.converters.FileConverter;
import com.comtop.eic.apache.commons.beanutils.converters.FloatConverter;
import com.comtop.eic.apache.commons.beanutils.converters.IntegerConverter;
import com.comtop.eic.apache.commons.beanutils.converters.LongConverter;
import com.comtop.eic.apache.commons.beanutils.converters.ShortConverter;
import com.comtop.eic.apache.commons.beanutils.converters.SqlDateConverter;
import com.comtop.eic.apache.commons.beanutils.converters.SqlTimeConverter;
import com.comtop.eic.apache.commons.beanutils.converters.SqlTimestampConverter;
import com.comtop.eic.apache.commons.beanutils.converters.StringConverter;
import com.comtop.eic.apache.commons.beanutils.converters.URLConverter;

/**
 * 类型转换
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月17日 lizhongwen
 */
public class ConverteService {
    
    /**
     * 日志
     */
    private static final transient Logger LOGGER = LoggerFactory.getLogger(ConverteService.class);
    
    /**
     * 默认为True的字符串
     */
    private static final String[] TRUE_STRINGS = { "true", "yes", "y", "on", "1", "是" };
    
    /**
     * 默认为false的字符串
     */
    private static final String[] FLASE_STRINGS = { "false", "no", "n", "off", "0", "否" };
    
    /**
     * 转换器门面
     */
    private static ConverteService instance;
    
    /**
     * 转换器按Class的集合
     */
    private final Map<Class<?>, Class<?>> converters;
    
    /**
     * 转换器按名称的集合
     */
    private final Map<String, Class<?>> convertMap;
    
    /**
     * 构造函数
     */
    ConverteService() {
        converters = new HashMap<Class<?>, Class<?>>();
        convertMap = new HashMap<String, Class<?>>();
        reregister();
    }
    
    /**
     * @return 获取转换器门面实例
     */
    public static synchronized ConverteService getInstance() {
        if (null == instance) {
            instance = new ConverteService();
        }
        return instance;
    }
    
    /**
     * 删除所有的转换器，重新进行注册
     */
    public void reregister() {
        
        converters.clear();
        
        registerNames();
        
        registerPrimitives();
        registerStandard();
        registerOther();
        registerSpecify();
    }
    
    /**
     * 注册转换器的名称
     */
    private void registerNames() {
        // 基本数据类型
        convertMap.put("boolean", Boolean.TYPE);
        convertMap.put("byte", Byte.TYPE);
        convertMap.put("char", Character.TYPE);
        convertMap.put("double", Double.TYPE);
        convertMap.put("float", Float.TYPE);
        convertMap.put("int", Integer.TYPE);
        convertMap.put("long", Long.TYPE);
        convertMap.put("short", Short.TYPE);
        
        // 包装数据类型
        convertMap.put("Boolean", Boolean.class);
        convertMap.put("Byte", Byte.class);
        convertMap.put("Character", Character.class);
        convertMap.put("Double", Double.class);
        convertMap.put("Float", Float.class);
        convertMap.put("Integer", Integer.class);
        convertMap.put("Long", Long.class);
        convertMap.put("Short", Short.class);
        convertMap.put("BigDecimal", BigDecimal.class);
        convertMap.put("BigInteger", BigInteger.class);
        
        // 常用数据类型
        convertMap.put("String", String.class);
        convertMap.put("Class", Class.class);
        convertMap.put("URL", URL.class);
        convertMap.put("Date", java.util.Date.class);
        convertMap.put("File", File.class);
        convertMap.put("sqlDate", java.sql.Date.class);
        convertMap.put("sqlTime", java.sql.Time.class);
        convertMap.put("sqlTimestamp", java.sql.Timestamp.class);
        
        // 基本数据类型 数组
        convertMap.put("booleans", boolean[].class);
        convertMap.put("bytes", byte[].class);
        convertMap.put("chars", char[].class);
        convertMap.put("doubles", double[].class);
        convertMap.put("floats", float[].class);
        convertMap.put("ints", int[].class);
        convertMap.put("longs", long[].class);
        
        // 包装数据类型 数组
        convertMap.put("BigDecimals", BigDecimal[].class);
        convertMap.put("BigIntegers", BigInteger[].class);
        convertMap.put("Bytes", Byte[].class);
        convertMap.put("Characters", Character[].class);
        convertMap.put("Doubles", Double[].class);
        convertMap.put("Floats", Float[].class);
        convertMap.put("Integers", Integer[].class);
        convertMap.put("Longs", Long[].class);
        convertMap.put("Shorts", Short[].class);
        convertMap.put("Strings", String[].class);
        
        // 常用数据类型 数组
        convertMap.put("Classes", Class[].class);
        convertMap.put("URLs", URL[].class);
        convertMap.put("Dates", java.util.Date[].class);
        convertMap.put("Files", File[].class);
        convertMap.put("sqlDates", java.sql.Date[].class);
        convertMap.put("sqlTimes", java.sql.Time[].class);
        convertMap.put("sqlTimestamps", java.sql.Timestamp[].class);
        
    }
    
    /**
     * 注册基本数据类型的转换器<br/>
     * 这个方法将注册一下数据类型的转换器
     * <ul>
     * <li><code>Boolean.TYPE</code> - {@link BooleanConverter}</li>
     * <li><code>Byte.TYPE</code> - {@link ByteConverter}</li>
     * <li><code>Character.TYPE</code> - {@link CharacterConverter}</li>
     * <li><code>Double.TYPE</code> - {@link DoubleConverter}</li>
     * <li><code>Float.TYPE</code> - {@link FloatConverter}</li>
     * <li><code>Integer.TYPE</code> - {@link IntegerConverter}</li>
     * <li><code>Long.TYPE</code> - {@link LongConverter}</li>
     * <li><code>Short.TYPE</code> - {@link ShortConverter}</li>
     * </ul>
     */
    private void registerPrimitives() {
        register(Boolean.TYPE, BooleanConverter.class);
        register(Byte.TYPE, ByteConverter.class);
        register(Character.TYPE, CharacterConverter.class);
        register(Double.TYPE, DoubleConverter.class);
        register(Float.TYPE, FloatConverter.class);
        register(Integer.TYPE, IntegerConverter.class);
        register(Long.TYPE, LongConverter.class);
        register(Short.TYPE, ShortConverter.class);
    }
    
    /**
     * 注册标准数据类型的转换器. <br/>
     * 这个方法将注册一下数据类型的转换器
     * <ul>
     * <li><code>BigDecimal.class</code> - {@link BigDecimalConverter}</li>
     * <li><code>BigInteger.class</code> - {@link BigIntegerConverter}</li>
     * <li><code>Boolean.class</code> - {@link BooleanConverter}</li>
     * <li><code>Byte.class</code> - {@link ByteConverter}</li>
     * <li><code>Character.class</code> - {@link CharacterConverter}</li>
     * <li><code>Double.class</code> - {@link DoubleConverter}</li>
     * <li><code>Float.class</code> - {@link FloatConverter}</li>
     * <li><code>Integer.class</code> - {@link IntegerConverter}</li>
     * <li><code>Long.class</code> - {@link LongConverter}</li>
     * <li><code>Short.class</code> - {@link ShortConverter}</li>
     * <li><code>String.class</code> - {@link StringConverter}</li>
     * </ul>
     */
    private void registerStandard() {
        
        register(BigDecimal.class, BigDecimalConverter.class);
        register(BigInteger.class, BigIntegerConverter.class);
        register(Boolean.class, BooleanConverter.class);
        register(Byte.class, ByteConverter.class);
        register(Character.class, CharacterConverter.class);
        register(Double.class, DoubleConverter.class);
        register(Float.class, FloatConverter.class);
        register(Integer.class, IntegerConverter.class);
        register(Long.class, LongConverter.class);
        register(Short.class, ShortConverter.class);
        register(String.class, StringConverter.class);
        
    }
    
    /**
     * 注册其他常用数据类型的转换器 <br/>
     * 这个方法将注册一下数据类型的转换器:
     * <ul>
     * <li><code>Class.class</code> - {@link ClassConverter}</li>
     * <li><code>java.util.Date.class</code> - {@link DateConverter}</li>
     * <li><code>java.util.Calendar.class</code> - {@link CalendarConverter}</li>
     * <li><code>File.class</code> - {@link FileConverter}</li>
     * <li><code>java.sql.Date.class</code> - {@link SqlDateConverter}</li>
     * <li><code>java.sql.Time.class</code> - {@link SqlTimeConverter}</li>
     * <li><code>java.sql.Timestamp.class</code> - {@link SqlTimestampConverter}</li>
     * <li><code>URL.class</code> - {@link URLConverter}</li>
     * </ul>
     */
    private void registerOther() {
        register(Class.class, ClassConverter.class);
        register(java.util.Date.class, DateConverter.class);
        register(Calendar.class, CalendarConverter.class);
        register(File.class, FileConverter.class);
        register(java.sql.Date.class, SqlDateConverter.class);
        register(java.sql.Time.class, SqlTimeConverter.class);
        register(Timestamp.class, SqlTimestampConverter.class);
        register(URL.class, URLConverter.class);
    }
    
    /**
     * 通过数组转换器，包装普通转换器，然后进行注册
     * 
     * @param componentType 数组元素数据类型
     * @param componentConverter 数组元素的转换器
     * @return 转换器
     */
    private Converter initArrayConverter(final Class<?> componentType, final Converter componentConverter) {
        Class<?> objArrayType = Array.newInstance(componentType, 0).getClass();
        if (null == componentConverter) {
            return null;
        }
        Converter objArrayConverter = null;
        objArrayConverter = new ArrayConverter(objArrayType, componentConverter);
        return objArrayConverter;
    }
    
    /**
     * 注册特定的转换器 <br/>
     * 这个方法将注册一下数据类型的转换器:
     * 
     * <pre>
     * <ul>
     * <li><code>java.lang.Class.class</code> - {@link Class}</li>
     * <li><code>com.comtop.eic.core.excelimport.model.CellVO.class</code></li>
     * </ul>
     * </pre>
     */
    private void registerSpecify() {
        register(Class.class, ClassConverter.class);
    }
    
    /**
     * 按照目标数据类型注册相应的转换器
     * 
     * @param clazz 目标数据类型
     * @param converterClass 转换器类
     */
    public void register(final Class<?> clazz, final Class<?> converterClass) {
        converters.put(clazz, converterClass);
    }
    
    /**
     * 根据目标数据类型和源数据类型查找对相应的转换器
     * 
     * @param sourceType 源数据类型
     * @param targetType 目标数据类型
     * @return 转换器
     */
    public Converter lookup(final Class<?> sourceType, final Class<?> targetType) {
        
        if (null == targetType) {
            throw new IllegalArgumentException("Target type is missing");
        }
        if (null == sourceType) {
            return lookup(targetType);
        }
        
        Converter objConverter = null;
        // Convert --> String
        if (targetType == String.class) {
            objConverter = lookup(sourceType);
            if (null == objConverter && (sourceType.isArray() || Collection.class.isAssignableFrom(sourceType))) {
                objConverter = lookup(String[].class);
            }
            if (null == objConverter) {
                objConverter = lookup(String.class);
            }
            return objConverter;
        }
        
        // Convert --> String array
        if (targetType == String[].class) {
            if (sourceType.isArray() || Collection.class.isAssignableFrom(sourceType)) {
                objConverter = lookup(sourceType);
            }
            if (null == objConverter) {
                objConverter = lookup(String[].class);
            }
            return objConverter;
        }
        
        return lookup(targetType);
        
    }
    
    /**
     * 根据名称查找转换器
     * 
     * @param name 转换器名称
     * @return 查找到的已注册的转换器，如果没有则返回null
     */
    public Converter lookup(final String name) {
        Class<?> objClazz = convertMap.get(name);
        if (null == objClazz) {
            return null;
        }
        return lookup(objClazz);
        
    }
    
    /**
     * 根据目标数据类型查找指定的转换器
     * 
     * @param clazz 目标数据类型
     * @return 查找到的已注册的转换器，如果没有则返回null
     */
    public Converter lookup(final Class<?> clazz) {
        String strClassName = clazz.getSimpleName();
        if ("[]".equals(strClassName)) { // 数组
            Class<?> objComponentType = clazz.getComponentType();
            return initArrayConverter(objComponentType, lookup(objComponentType));
        }
        
        Class<?> objConverterClass = converters.get(clazz);
        if (null == objConverterClass) {
            return null;
        }
        Converter objConverter;
        try {
            objConverter = (Converter) objConverterClass.newInstance();
        } catch (InstantiationException e) {
        	LOGGER.debug("lookup error",e);
            return null;
        } catch (IllegalAccessException e) {
        	LOGGER.debug("lookup error",e);
            return null;
        }
        // 设置
        if (objConverter instanceof BooleanConverter) {
            return new BooleanConverter(TRUE_STRINGS, FLASE_STRINGS);
        }
        return objConverter;
        
    }
    
    /**
     * <p>
     * 根据目标数据类型，移除相关转换器
     * 
     * @param clazz 需要移除的数据类型的转换器
     * @see com.comtop.eic.apache.commons.beanutils.ConvertUtilsBean#deregister(Class)
     */
    public void deregister(final Class<?> clazz) {
        converters.remove(clazz);
    }
    
    /**
     * 将特定数据类型转换为一个字符串，如果数据位一个数组的话，则只转换第一个元素
     * 
     * @param value 需要转换的数据
     * @return String结果
     */
    public String convert(final Object value) {
        
        if (null == value) {
            return null;
        } else if (value.getClass().isArray()) {
            if (Array.getLength(value) < 1) {
                return null;
            }
            Object objValue = Array.get(value, 0);
            if (null == objValue) {
                return null;
            }
            Converter objConverter = lookup(String.class);
            return (String) objConverter.convert(String.class, objValue);
        }
        Converter objConverter = lookup(String.class);
        return (String) objConverter.convert(String.class, value);
        
    }
    
    /**
     * 将数据转换为特定数据类型<br/>
     * 如果找不到对应的转换器的话，则默认转换为String
     * 
     * @param value 需要转换的数据
     * @param clazz 目标数据类型的class
     * @return 转换后的结果
     */
    public Object convert(final String value, final Class<?> clazz) {
        
        LOGGER.debug("Convert string '" + value + "' to class '" + clazz.getName() + "'");
        Converter objConverter = lookup(clazz);
        if (null == objConverter) {
            objConverter = lookup(String.class);
        }
        LOGGER.trace("  Using converter " + objConverter);
        return objConverter.convert(clazz, value);
    }
    
    /**
     * 将字符串数组转换为特定的数据类型数组<br/>
     * 如果找不到对应的转换器的话，则默认转换为String数组
     * 
     * @param values 需要转换的数据数组
     * @param clazz 目标数组元素类型的Class
     * @return 转换后的结果
     */
    public Object convert(final String[] values, final Class<?> clazz) {
        
        Class<?> objType;
        if (clazz.isArray()) {
            objType = clazz.getComponentType();
        } else {
            objType = clazz;
        }
        LOGGER.debug("Convert String[" + values.length + "] to class '" + objType.getName() + "[]'");
        Converter objConverter = lookup(objType);
        if (null == objConverter) {
            objConverter = lookup(String.class);
        }
        LOGGER.trace("  Using converter " + objConverter);
        Object objArray = Array.newInstance(objType, values.length);
        for (int i = 0; i < values.length; i++) {
            Array.set(objArray, i, objConverter.convert(objType, values[i]));
        }
        return objArray;
        
    }
    
    /**
     * 将数据转换为特定的数据类型
     * 
     * @param value 需要转换的数据
     * @param targetType 目标数据类型Class
     * @return 转换后的结果
     */
    public Object convert(final Object value, final Class<?> targetType) {
        
        if (null == value) {
            LOGGER.debug("Convert null value to type '" + targetType.getName() + "'");
        } else {
            LOGGER.debug("Convert type '" + (value == null ? null : value.getClass()).getName() + "' value '" + value
                + "' to type '" + targetType.getName() + "'");
        }
        
        Object objConverted = value;
        Converter objConverter = lookup(value == null ? null : value.getClass(), targetType);
        if (null != objConverter) {
            LOGGER.trace("  Using converter " + objConverter);
            objConverted = objConverter.convert(targetType, value);
        }
        if (targetType == String.class && null != objConverted && !(objConverted instanceof String)) {
            
            // NOTE: For backwards compatibility, if the Converter
            // doesn't handle conversion-->String then
            // use the registered String Converter
            objConverter = lookup(String.class);
            if (null != objConverter) {
                LOGGER.trace("  Using converter " + objConverter);
                objConverted = objConverter.convert(String.class, objConverted);
            }
            
            // If the object still isn't a String, use toString() method
            if (null != objConverted && !(objConverted instanceof String)) {
                objConverted = objConverted.toString();
            }
            
        }
        return objConverted;
    }
    
}
