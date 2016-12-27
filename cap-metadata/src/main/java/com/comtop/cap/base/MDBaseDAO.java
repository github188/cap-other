/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.base;

import java.lang.reflect.Type;
import java.sql.Connection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.comtop.cap.common.executor.PropertyReadExecutor;
import com.comtop.cap.common.executor.PropertyUpdateExecutor;
import com.comtop.cap.common.reflect.ReflectUtil;
import com.comtop.corm.session.SqlSession;
import com.comtop.top.core.base.dao.CoreDAO;
import com.comtop.top.core.base.model.CoreVO;
import com.comtop.top.core.jodd.executor.IBizExecutor;

/**
 * CAPBaseDAO
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年12月4日 lizhiyong
 * @param <T> 参数
 */
public class MDBaseDAO<T extends CoreVO> extends CoreDAO<T> {
    
    /**
     * 根据查询条件查询文档list
     * 
     * @param id 对象id
     * @param properties 属性集
     *
     * @return Map<String,Object> 属性集
     */
    public Map<String, Object> readPropertyById(final String id, List<String> properties) {
        Type[] clazzs = ReflectUtil.getParameterizedType(getClass());
        @SuppressWarnings("unchecked")
        Class<T> clazz = (Class<T>) clazzs[0];
        return readPropertyById(id, clazz, properties);
    }
    
    /**
     * 根据查询条件查询文档list
     * 
     * @param id 对象id
     * @param clazz 类型
     * @param properties 属性集
     *@param <E> CoreVO
     * @return Map<String,Object> 属性集
     */
    public <E extends CoreVO> Map<String, Object> readPropertyById(final String id, Class<E> clazz,
        List<String> properties) {
        final Map<String, Object> retMap = new HashMap<String, Object>(properties.size() + 1);
        retMap.put("id", id);
        this.execute(new PropertyReadExecutor(id, properties, clazz, retMap));
        return retMap;
    }
    
    /**
     * 根据查询条件查询文档list
     * 
     * @param id 对象id
     * @param properties 属性集
     */
    public void updatePropertyById(final String id, Map<String, Object> properties) {
        Type[] clazzs = ReflectUtil.getParameterizedType(getClass());
        @SuppressWarnings("unchecked")
        Class<T> clazz = ((Class<T>) clazzs[0]);
        updatePropertyById(id, clazz, properties);
    }
    
    /**
     * 根据查询条件查询文档list
     * 
     * @param id 对象id
     * @param clazz 类型
     * @param properties 属性集
     *  @param <E> CoreVO
     */
    public <E extends CoreVO> void updatePropertyById(final String id, Class<E> clazz, Map<String, Object> properties) {
        this.execute(new PropertyUpdateExecutor(id, properties, clazz));
    }
    
    /**
     * 保存对象。先根据对象查询，如果能够查询到，则执行更新操作，否则执行新增操作
     * 
     * @param model 对象
     * @param mappingTables 属性集
     */
    public void save(T model, String... mappingTables) {
        T obj = this.load(model, mappingTables);
        if (obj == null) {
            this.insert(model, mappingTables);
        } else {
            this.update(model, mappingTables);
        }
    }
    
    /**
     * 根据id加载数据
     *
     * @param model 模型
     * @param mappingTables 映射表
     * @param <E> CoreVO
     * @return 对象
     */
    @SuppressWarnings("unchecked")
    public <E extends CoreVO> E loadById(final E model, final String... mappingTables) {
        Object objResult = execute(new IBizExecutor() {
            
            @Override
            public Object execute(Connection connection) {
                SqlSession objSqlSession = factory.openSession(connection);
                Object objRet;
                if ((mappingTables == null) || (mappingTables.length == 0)) {
                    objRet = objSqlSession.selectOne(MDBaseDAO.this.getStatementId(model, "read", null), model);
                } else {
                    objRet = null;
                    for (String strMappingTable : mappingTables) {
                        objRet = objSqlSession.selectOne(MDBaseDAO.this.getStatementId(model, "read", strMappingTable),
                            model);
                    }
                }
                return objRet;
            }
        });
        return (E) objResult;
    }
    
    /**
     * 获得statementId
     *
     * @param model 模型
     * @param operation 操作
     * @param tableName 表名
     * @return statementId
     */
    private String getStatementId(Object model, String operation, String tableName) {
        String strSimpleName = model.getClass().getSimpleName();
        if (strSimpleName.endsWith("VO")) {
            strSimpleName = strSimpleName.substring(0, strSimpleName.length() - 2);
        }
        
        return model.getClass().getPackage().getName() + '.' + operation + strSimpleName
            + (tableName == null ? "" : new StringBuilder().append("_").append(tableName.toUpperCase()).toString());
    }
}
