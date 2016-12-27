/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.base;

import java.lang.reflect.Field;
import java.lang.reflect.Type;
import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.common.reflect.FieldDescription;
import com.comtop.cap.common.reflect.ReflectUtil;
import com.comtop.cap.common.reflect.TypeDescription;
import com.comtop.cap.runtime.base.appservice.BaseAppService;
import com.comtop.top.core.base.model.CoreVO;

/**
 * appservice基类
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年12月4日 lizhiyong
 * @param <T> 业务对象
 */
abstract public class MDBaseAppservice<T extends CoreVO> extends BaseAppService {
    
    /** 日志对象 */
    protected final Logger logger = LoggerFactory.getLogger(getClass());
    
    /** 按条件加载 */
    protected final String LOAD_LIST_NAME = "{0}.load{1}List";
    
    /** 分页加载 */
    protected final String LOAD_LIST_BY_PAGE_NAME = "{0}.load{1}ListByPage";
    
    /**
     * 新增
     *
     * @param VO VO
     * @return 主键
     */
    public String insert(T VO) {
        return this.insert(VO, new String[0]);
    }
    
    /**
     * 新增
     *
     * @param VO VO
     * @param mappingTables vv
     * @return 主键
     */
    public String insert(T VO, String... mappingTables) {
        return getDAO().insert(VO, new String[0]).toString();
    }
    
    /**
     * 新增
     *
     * @param VO VO
     * @return 主键
     */
    public boolean delete(T VO) {
        return this.delete(VO, new String[0]);
    }
    
    /**
     * 新增
     *
     * @param VO VO
     * @param mappingTables vv
     * @return 主键
     */
    public boolean delete(T VO, String... mappingTables) {
        return getDAO().delete(VO, new String[0]);
    }
    
    /**
     * 更新
     *
     * @param VO VO
     * @return true 成功 false 失败
     */
    public boolean update(T VO) {
        return this.update(VO, new String[0]);
    }
    
    /**
     * 更新
     *
     * @param VO VO
     * @param mappingTables vv
     * @return true 成功 false 失败
     */
    public boolean update(T VO, String... mappingTables) {
        return getDAO().update(VO, mappingTables);
    }
    
    /**
     * 根据id读取数据
     * 
     * @param id 主键
     *
     * @return 对象 未找到返回null
     */
    public T readById(String id) {
        return readById(id, new String[0]);
    }
    
    /**
     * 根据id读取数据
     * 
     * @param id 主键
     * @param mappingTables vv
     *
     * @return 对象 未找到返回null
     */
    public T readById(String id, String... mappingTables) {
        Type[] clazzes = ReflectUtil.getParameterizedType(getClass());
        @SuppressWarnings("unchecked")
        Class<T> clazz = (Class<T>) clazzes[0];
        return readById(id, clazz, mappingTables);
    }
    
    /**
     * 根据主键读取数据
     * @param <E> Class
     *
     * @param id 主键
     * @param clazz 类型
     * @param mappingTables mappingTables
     * @return 对象
     * @throws RuntimeException 异常
     */
    public <E extends CoreVO> E readById(String id, Class<E> clazz, String... mappingTables) throws RuntimeException {
        TypeDescription description = ReflectUtil.getTypeDescription(clazz);
        FieldDescription fieldDescription = description.getIdFieldDescription();
        try {
            E model = clazz.newInstance();
            if (fieldDescription != null) {
                Field field = fieldDescription.getField();
                ReflectUtil.setField(field, model, id);
            }
            return getDAO().loadById(model, mappingTables);
        } catch (IllegalAccessException e) {
            logger.error("设置对象id值时发生异常。当前类" + clazz.getName(), e);
            throw new RuntimeException("保存对象时发生异常。当前类" + clazz.getName(), e);
        } catch (InstantiationException e) {
            logger.error("实例化对象的发生异常" + clazz.getName(), e);
            throw new RuntimeException("实例化对象的发生异常" + clazz.getName(), e);
        }
    }
    
    /**
     * 更新
     * 
     * @param id 主键
     * @param properties 属性集
     *
     * @return 属性集 如果某个属性没有值，map 的value为空 。如果某个属性没有定义列映射，则该属性值不会在结果集中出现
     */
    public Map<String, Object> readPropertiesById(String id, List<String> properties) {
        return getDAO().readPropertyById(id, properties);
    }
    
    /**
     * 更新
     * 
     * @param id 主键
     * @param property 属性
     *
     * @return 属性集 如果该属性没有值，map 的value为空 。如果该属性没有定义列映射，则该属性值不会在结果集中出现
     */
    public Object readPropertyById(String id, String property) {
        List<String> list = new ArrayList<String>(1);
        list.add(property);
        Map<String, Object> values = getDAO().readPropertyById(id, list);
        return values.get(property);
    }
    
    /**
     * 更新
     * 
     * @param id 主键
     * @param property 属性名
     * @param value 属性值
     *
     */
    public void updatePropertyById(String id, String property, Object value) {
        Map<String, Object> map = new HashMap<String, Object>(1);
        map.put(property, value);
        getDAO().updatePropertyById(id, map);
    }
    
    /**
     * 更新
     * 
     * @param id 主键
     * @param properties 属性集
     *
     */
    public void updatePropertiesById(String id, Map<String, Object> properties) {
        getDAO().updatePropertyById(id, properties);
    }
    
    /**
     * 更新
     *  @param <E> Class
     * @param id 主键
     * @param clazz 类型
     * @param properties 属性集
     *
     * @return 属性集 如果某个属性没有值，map 的value为空 。如果某个属性没有定义列映射，则该属性值不会在结果集中出现
     */
    public <E extends CoreVO> Map<String, Object> readPropertiesById(String id, Class<E> clazz, List<String> properties) {
        return getDAO().readPropertyById(id, clazz, properties);
    }
    
    /**
     * 更新
     * 
     * @param id 主键
     * @param clazz 类型
     * @param property 属性
     * @param <E> Class
     * @return 属性集 如果该属性没有值，map 的value为空 。如果该属性没有定义列映射，则该属性值不会在结果集中出现
     */
    public <E extends CoreVO> Object readPropertyById(String id, Class<E> clazz, String property) {
        List<String> list = new ArrayList<String>(1);
        list.add(property);
        Map<String, Object> values = getDAO().readPropertyById(id, clazz, list);
        return values.get(property);
    }
    
    /**
     * 更新
     *  @param <E> Class
     * @param id 主键
     * @param clazz 类型
     * @param property 属性名
     * @param value 属性值
     */
    public <E extends CoreVO> void updatePropertyById(String id, Class<E> clazz, String property, Object value) {
        Map<String, Object> map = new HashMap<String, Object>(1);
        map.put(property, value);
        getDAO().updatePropertyById(id, clazz, map);
    }
    
    /**
     * 更新
     * 
     * @param id 主键
     * @param clazz 类型
     * @param properties 属性集
     * @param <E> Class
     */
    public <E extends CoreVO> void updatePropertiesById(String id, Class<E> clazz, Map<String, Object> properties) {
        getDAO().updatePropertyById(id, clazz, properties);
    }
    
    /**
     * 保存对象。先根据对象查询，如果能够查询到，则执行更新操作，否则执行新增操作
     *
     * @param VO vo
     * @return 对象主键
     */
    public String save(T VO) {
        return this.save(VO, new String[0]);
    }
    
    /**
     * 保存对象。先根据对象查询，如果能够查询到，则执行更新操作，否则执行新增操作
     *
     * @param VO vo
     * @param mappingTables vv
     * @return 对象主键
     */
    public String save(T VO, String... mappingTables) {
        if (VO == null) {
            return null;
        }
        T obj = getDAO().load(VO, mappingTables);
        if (obj == null) {
            return this.insert(VO, mappingTables);
        }
        
        this.update(VO, mappingTables);
        TypeDescription description = ReflectUtil.getTypeDescription(VO.getClass());
        FieldDescription fieldDescription = description.getIdFieldDescription();
        if (fieldDescription != null) {
            Field field = fieldDescription.getField();
            return ReflectUtil.getField(field, VO).toString();
        }
        return null;
    }
    
    /**
     * 加载集合
     *
     * @param condition 条件
     * @return 数据集
     */
    public List<T> loadList(T condition) {
        String statementId = MessageFormat.format(LOAD_LIST_NAME, condition.getClass().getPackage().getName(),
            condition.getClass().getSimpleName());
        return getDAO().queryList(statementId, condition);
    }
    
    /**
     * 分页加载集合
     *
     * @param condition 条件
     * @return 数据集
     */
    // public List<T> loadListByPage(T condition) {
    // String statementId = MessageFormat.format(LOAD_LIST_BY_PAGE_NAME, condition.getClass().getPackage().getName(),
    // condition.getClass().getSimpleName());
    // return getDAO().queryList(statementId, condition, condition.getPageNo(), condition.getPageSize());
    // }
    
    /**
     * 根据条件读取一条数据
     *
     * @param condition 条件
     * @return 对象 没找到返回 null
     */
    // public T read(T condition) {
    // List<T> list = this.loadList(condition);
    // return (list == null || list.size() == 0) ? null : list.get(0);
    // }
    
    /**
     * 获得DAO
     *
     * @return BaseDao
     */
    abstract protected MDBaseDAO<T> getDAO();
}
