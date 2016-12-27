/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.common.storage;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.apache.commons.jxpath.JXPathContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;

/**
 * 对象操作
 *
 * @author 郑重
 * @since 1.0
 * @version 2015-4-22 郑重
 */
public class ObjectOperator {
    
    /** 日志 */
    private final Logger logger = LoggerFactory.getLogger(ObjectOperator.class);
    
    /** 操作的对象 */
    private final Object object;
    
    /**
     * JxPath上下文
     */
    private final JXPathContext context;
    
    /**
     * 构造函数
     * 
     * @param object 对象
     */
    public ObjectOperator(Object object) {
        this.object = object;
        context = JXPathContext.newContext(this.object);
        // 使用Lenient访问模式,当表达式获取的属性不存在时返回null不会抛出异常
        context.setLenient(true);
    }
    
    /**
     * 读取属性
     *
     * @param expression 表达式
     * @return 查询结果集
     * @throws OperateException 对象操作异常
     */
    public Object read(final String expression) throws OperateException {
        Object objResult = null;
        try {
            objResult = context.getValue(expression);
        } catch (Exception e) {
            logger.error("对象查询失败！", e);
            throw new OperateException("对象查询失败!", e);
        }
        return objResult;
    }
    
    /**
     * 读取属性
     *
     * @param <T> 类型
     *
     * @param expression 表达式
     * @param c 返回结果类型
     * @return 查询结果集
     * @throws OperateException 对象操作异常
     */
    @SuppressWarnings("unchecked")
    public <T> T read(final String expression, Class<T> c) throws OperateException {
        T objResult = null;
        try {
            objResult = (T) context.getValue(expression, c);
        } catch (Exception e) {
            logger.error("对象查询失败！", e);
            throw new OperateException("对象查询失败!", e);
        }
        return objResult;
    }
    
    /**
     * 集合查询
     *
     * @param expression 表达式
     * @return 查询结果集
     * @throws OperateException 对象操作异常
     */
    @SuppressWarnings({ "unchecked", "rawtypes" })
    public List queryList(final String expression) throws OperateException {
        List lstResult = new ArrayList();
        try {
            Iterator objIterator = context.iterate(expression);
            while (objIterator.hasNext()) {
                lstResult.add(objIterator.next());
            }
        } catch (Exception e) {
            logger.error("对象查询失败！", e);
            throw new OperateException("对象查询失败!", e);
        }
        return lstResult;
    }
    
    /**
     * 集合查询
     * 
     * @param <T> Class
     * 
     * @param expression 表达式
     * @param c 返回结果类型
     * @return 查询结果集
     * @throws OperateException 对象操作异常
     */
    @SuppressWarnings("unchecked")
    public <T> List<T> queryList(final String expression, Class<T> c) throws OperateException {
        List<T> lstResult = new ArrayList<T>();
        try {
            Iterator<T> objIterator = context.iterate(expression);
            while (objIterator.hasNext()) {
                lstResult.add(objIterator.next());
            }
        } catch (Exception e) {
            logger.error("对象查询失败！", e);
            throw new OperateException("对象查询失败!", e);
        }
        return lstResult;
    }
    
    /**
     * 集合查询
     *
     * @param expression 表达式
     * @param pageSize 1页记录数
     * @return 查询结果集
     * @throws OperateException 对象操作异常
     */
    @SuppressWarnings({ "unchecked", "rawtypes" })
    public List queryList(final String expression, int pageSize) throws OperateException {
        List lstResult = new ArrayList();
        try {
            Iterator objIterator = context.iterate(expression);
            for (int i = 0; objIterator.hasNext(); i++) {
                if (i < pageSize) {
                    lstResult.add(objIterator.next());
                } else {
                    break;
                }
            }
        } catch (Exception e) {
            logger.error("对象查询失败！", e);
            throw new OperateException("对象查询失败!", e);
        }
        return lstResult;
    }
    
    /**
     * 集合查询
     * 
     * @param <T> Class
     * 
     * @param expression 表达式
     * @param c 返回结果类型
     * @param pageNo 页码
     * @param pageSize 1页记录数
     * @return 查询结果集
     * @throws OperateException 对象操作异常
     */
    @SuppressWarnings("unchecked")
    public <T> List<T> queryList(final String expression, Class<T> c, int pageNo, int pageSize) throws OperateException {
        List<T> lstResult = new ArrayList<T>();
        try {
            Iterator<T> objIterator = context.iterate(expression);
            int iStart = (pageNo - 1) * pageSize;
            int iEnd = pageNo * pageSize;
            for (int i = 0; objIterator.hasNext(); i++) {
                if (i >= iStart && i < iEnd) {
                    lstResult.add(objIterator.next());
                } else {
                    objIterator.next();
                }
                if (i >= iEnd) {
                    break;
                }
            }
        } catch (Exception e) {
            logger.error("对象查询失败！", e);
            throw new OperateException("对象查询失败!", e);
        }
        return lstResult;
    }
    
    /**
     * 集合查询
     * 
     * @param <T> Class
     * 
     * @param expression 表达式
     * @param c 返回结果类型
     * @param pageSize 1页记录数
     * @return 查询结果集
     * @throws OperateException 对象操作异常
     */
    @SuppressWarnings("unchecked")
    public <T> List<T> queryList(final String expression, Class<T> c, int pageSize) throws OperateException {
        List<T> lstResult = new ArrayList<T>();
        try {
            Iterator<T> objIterator = context.iterate(expression);
            for (int i = 0; objIterator.hasNext(); i++) {
                if (i < pageSize) {
                    lstResult.add(objIterator.next());
                } else {
                    break;
                }
            }
        } catch (Exception e) {
            logger.error("对象查询失败！", e);
            throw new OperateException("对象查询失败!", e);
        }
        return lstResult;
    }
    
    /**
     * 向集合中添加对象
     *
     * @param expression 表达式
     * @param value 值
     * @return 是否保存成功
     * @throws OperateException 对象操作异常
     */
    @SuppressWarnings("unchecked")
    public boolean add(final String expression, final Object value) throws OperateException {
        boolean bResult = true;
        try {
            List<Object> lstObject = (List<Object>) context.getValue(expression);
            if (lstObject == null) {
                System.out.println("expression:" + expression + "  value:" + value);
                throw new OperateException("对象更新失败!");
            }
            if (value instanceof List<?>) {
                lstObject.addAll((List<Object>) value);
            } else {
                lstObject.add(value);
            }
        } catch (Exception e) {
            bResult = false;
            logger.error("对象更新失败！", e);
            throw new OperateException("对象更新失败!", e);
        }
        return bResult;
    }
    
    /**
     * 更新
     *
     * @param expression 表达式
     * @param value 值
     * @return 是否保存成功
     * @throws OperateException 对象操作异常
     */
    public boolean update(final String expression, final Object value) throws OperateException {
        boolean bResult = true;
        try {
            context.setValue(expression, value);
        } catch (Exception e) {
            bResult = false;
            logger.error("对象更新失败！", e);
            throw new OperateException("对象更新失败!", e);
        }
        return bResult;
    }
    
    /**
     * 创建并保存对象
     *
     * @param expression 表达式
     * @param value 值
     * @return 是否保存成功
     * @throws OperateException 对象操作异常
     */
    public boolean createAndSave(final String expression, final Object value) throws OperateException {
        boolean bResult = true;
        try {
            context.createPathAndSetValue(expression, value);
        } catch (Exception e) {
            bResult = false;
            logger.error("对象更新失败！", e);
            throw new OperateException("对象更新失败!", e);
        }
        return bResult;
    }
    
    /**
     * 删除
     *
     * @param expression 表达式
     * @return 删除数据成功
     * @throws OperateException 对象操作异常
     */
    public boolean delete(String expression) throws OperateException {
        boolean bResult = true;
        try {
            context.removeAll(expression);
        } catch (Exception e) {
            bResult = false;
            logger.error("对象删除失败！", e);
            throw new OperateException("对象删除失败!", e);
        }
        return bResult;
    }
}
