/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.inject.injecter.util;

import java.util.List;

import com.comtop.cap.bm.metadata.common.storage.ObjectOperator;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;

/**
 *
 * 元数据注入服务提供者
 *
 * @author 凌晨
 * @since jdk1.6
 * @version 2015年12月31日 凌晨
 */
public class MetadataInjectProvider {
    
    /**
     * 修改源数据的属性值。(不支持批量修改，需要批量修改，建议先使用queryList把集合查询出来，再循环调用本方法)
     * 
     * @param source 数据源
     * @param expression 需要的表达式
     * @param value 修改的值
     * @return 修改结果
     * @throws OperateException 操作异常
     *
     */
    public static boolean update(Object source, String expression, Object value) throws OperateException {
        ObjectOperator objectOperator = new ObjectOperator(source);
        return objectOperator.update(expression, value);
    }
    
    /**
     * 返回值为集合的查询
     * @param <T> Class
     * @param source 数据源
     * @param expression 查询表达式
     * @param clazz 查询结果的类型
     * @return 查询的结果
     * @throws OperateException 操作异常
     */
    public static <T> List<T> queryList(Object source, String expression, Class<T> clazz) throws OperateException {
        ObjectOperator objectOperator = new ObjectOperator(source);
        return objectOperator.queryList(expression, clazz);
    }
    
    /**
     * 根据jxpath表达式进行删除.支持批量删除（即符合条件的全部删除）
     *
     * @param source 数据源
     * @param expression 删除表达式
     * @return 删除结果
     * @throws OperateException 操作异常
     */
    public static boolean delete(Object source, String expression) throws OperateException {
        ObjectOperator objectOperator = new ObjectOperator(source);
        return objectOperator.delete(expression);
    }
    
    /**
     * 向数据源中指定的集合中添加元素
     *
     * @param source 数据源
     * @param expression 指定集合的查询表达式
     * @param value 等待添加的元素
     * @return 添加的结果
     * @throws OperateException 操作异常
     */
    public static boolean add(Object source, String expression, Object value) throws OperateException {
        ObjectOperator objectOperator = new ObjectOperator(source);
        return objectOperator.add(expression, value);
    }
    
}
