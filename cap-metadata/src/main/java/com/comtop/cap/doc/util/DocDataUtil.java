/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.util;

import java.lang.reflect.Field;
import java.lang.reflect.Modifier;
import java.text.MessageFormat;
import java.util.Collection;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.common.reflect.FieldDescription;
import com.comtop.cap.common.reflect.ReflectUtil;
import com.comtop.cap.common.reflect.TypeDescription;
import com.comtop.cap.doc.DocServiceException;
import com.comtop.cap.document.word.docmodel.data.BaseDTO;
import com.comtop.top.core.base.model.CoreVO;

/**
 * word文档数据操作工具类
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年12月1日 lizhiyong
 */
public class DocDataUtil {
	
	/** 日志对象 **/
    private static final Logger LOGGER = LoggerFactory.getLogger(DocDataUtil.class);
    
    /** sortNo表达式 */
    public static final String SORT_NO_EXPR = "$'{seq('''{0}''',10,1,1)'}";
    
    /** 带范围的sortNo表达式 */
    public static final String SORT_NO_EXPR_WITH_RANGE = "$'{seq('''{0}'-'{1}''',10,1,1)'}";
    
    /**
     * 构造函数
     */
    private DocDataUtil() {
        //
    }
    
    /**
     * 属性复制
     * 
     * 1、按 属性名复制，不是按setter和getter
     * 2、属性类型必须匹配才复制
     * 3、目标对象字段若为常量，不复制
     * 4、源的属性值若为空 不复制
     *
     * @param dest 复制到哪个对象 为空抛出异常
     * @param orig 从哪个对象复制 为空抛出异常
     */
    public static void copyProperties(Object dest, Object orig) {
        if (dest == null) {
            throw new IllegalArgumentException("No destination bean specified");
        }
        if (orig == null) {
            throw new IllegalArgumentException("No origin bean specified");
        }
        
        // 获得源和目标的类型描述
        TypeDescription sourceDescription = ReflectUtil.getTypeDescription(orig.getClass());
        TypeDescription destDescription = ReflectUtil.getTypeDescription(dest.getClass());
        Collection<FieldDescription> collection = sourceDescription.getFieldDescriptionMap().values();
        Map<String, FieldDescription> destFiledMap = destDescription.getFieldDescriptionMap();
        Field srcField = null;
        Field destField = null;
        
        for (FieldDescription fieldDescription : collection) {
            srcField = fieldDescription.getField();
            String name = srcField.getName();
            if ("class".equals(name)) {
                continue;
            }
            ReflectUtil.makeAccessible(srcField);
            FieldDescription description = destFiledMap.get(name);
            if (description != null) {
                Object value;
                try {
                    value = srcField.get(orig);
                    // 值为空，不复制
                    if (value != null) {
                        destField = description.getField();
                        
                        // 目标属性为常量，不复制
                        if (Modifier.isFinal(destField.getModifiers())) {
                            continue;
                        }
                        
                        // 目标属性与源属性类型不一致，不复制
                        if (!destField.getType().equals(srcField.getType())) {
                            continue;
                        }
                        
                        // 复制属性
                        ReflectUtil.makeAccessible(destField);
                        destField.set(dest, value);
                    }
                } catch (IllegalAccessException e1) {
                	LOGGER.debug("从对象复制属性时发生异常", e1);
                    // throw new WordParseException("从对象复制属性时发生异常", e1);
                }
            }
        }
    }
    
    /**
     * 更新保存已经存在的数据
     * 
     * @param <DTO> xx
     * @param <T> xx
     *
     * @param data 数据集
     * @param clazz 类型
     * @return VO
     */
    public static <DTO extends BaseDTO, T extends CoreVO> T dto2VO(DTO data, Class<T> clazz) {
        return convertBean(data, clazz);
    }
    
    /**
     * VO转换为DTO.
     * @param <DTO> BaseDTO
     * @param <T> CoreVO
     *
     * @param vo vo
     * @param clazz DTO类
     * @return DTO
     */
    public static <DTO extends BaseDTO, T extends CoreVO> DTO vo2DTO(T vo, Class<DTO> clazz) {
        return convertBean(vo, clazz);
    }
    
    /**
     * 转换Bean
     *
     * @param source 源
     * @param clazz 目标类
     * @param <E> Class
     * @param <T> CoreVO
     * @return 目标对象
     * @throws DocServiceException 异常
     */
    private static <T, E> E convertBean(T source, Class<E> clazz) throws DocServiceException {
        E dest;
        try {
            dest = clazz.newInstance();
            copyProperties(dest, source);
            return dest;
        } catch (InstantiationException e) {
            String message = MessageFormat.format("实例化对象时发生异常：当前类:{0}", clazz.getName());
            throw new DocServiceException(message, e);
        } catch (IllegalAccessException e) {
            String message = MessageFormat.format("实例化对象时发生异常：当前类:{0}", clazz.getName());
            throw new DocServiceException(message, e);
        }
    }
    
    /**
     * 获得sortNo 表达式
     *
     * @param key 关键字区分
     * @param rangId 范围id 指在某个范围内进行计算
     * @return 表达式
     */
    public static String getSortNoExpr(String key, String rangId) {
        if (StringUtils.isBlank(rangId)) {
            return MessageFormat.format(SORT_NO_EXPR, key);
        }
        return MessageFormat.format(SORT_NO_EXPR_WITH_RANGE, key, rangId);
    }
}
