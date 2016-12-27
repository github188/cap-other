/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.common.storage.relation;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.common.storage.annotation.AggregationField;
import com.comtop.cip.jodd.bean.BeanUtil;

/**
 * 聚合元数据
 *
 * @author 郑重
 * @since jdk1.5
 * @version 2015-8-6 郑重
 */
public class AggregationMetadata extends MetadataBeanVisitor {
    
    /** 日志 */
    private final static Logger LOG = LoggerFactory.getLogger(AggregationMetadata.class);
    
    /**
     * 构造器
     * 
     * @param source 处理对象
     * @return AggregationMetadata
     */
    public static AggregationMetadata beans(Object source) {
        return new AggregationMetadata(source);
    }
    
    /**
     * 构造器
     * 
     * @param source AggregationMetadata
     */
    public AggregationMetadata(Object source) {
        this.source = source;
    }
    
    /**
     * 合并
     */
    public void margin() {
        marginBean(this.source);
    }
    
    /**
     * 合并对象
     * 
     * @param cursource source
     */
    @SuppressWarnings(value = {})
    public void marginBean(Object cursource) {
        if (cursource != null && cursource instanceof BaseMetadata) {
            String[] strPropertyNames = getAllBeanPropertyNames(cursource.getClass(), false);
            for (int i = 0; i < strPropertyNames.length; i++) {
                Object objValue = BeanUtil.getDeclaredProperty(cursource, strPropertyNames[i]);
                try {
                    Field objField = getField(cursource.getClass(), strPropertyNames[i]);
                    if(objField == null){
                    	continue;
                    }
                    // 是否有聚合注解
                    AggregationField objAggregationField = objField.getAnnotation(AggregationField.class);
                    if (objAggregationField != null && objValue == null) {
                        aggregateProperty(cursource, strPropertyNames, i, objField, objAggregationField);
                    } else if (isObjectType(objValue)) {
                        depthTraversalObj(objValue);
                    }
                } catch (Exception e) {
                    LOG.error("聚合属性失败：" + strPropertyNames[i], e);
                }
            }
        }
    }
    
    /**
     * 深度变量对象
     * 
     * @param value 对象
     */
    private void depthTraversalObj(Object value) {
        // 如果是对象则进行深度遍历
        if (value instanceof List) {
            List lstValue = (List) value;
            for (int j = 0; j < lstValue.size(); j++) {
                if (isObjectType(lstValue.get(j))) {
                    marginBean(lstValue.get(j));
                }
            }
        } else {
            marginBean(value);
        }
    }
    
    /**
     * 聚合属性
     * 
     * @param cursource 对象
     * @param strPropertyNames 属性名
     * @param i 属性序号
     * @param objField 属性对象
     * @param objAggregationField 聚合属性
     */
    private void aggregateProperty(Object cursource, String[] strPropertyNames, int i, Field objField,
        AggregationField objAggregationField) {
        String strKey = objAggregationField.value();
        Object objKeyValue = BeanUtil.getDeclaredProperty(cursource, strKey);
        if (objKeyValue != null) {
            Object objValue = null;
            if (objField.getType() == List.class) {
                List<String> lstMapKey = (List<String>) objKeyValue;
                List<Object> lstValue = new ArrayList<Object>();
                for (int j = 0; j < lstMapKey.size(); j++) {
                    lstValue.add(CacheOperator.readById(lstMapKey.get(j)));
                }
                objValue = lstValue;
            } else {
                String strMapKey = (String) objKeyValue;
                objValue = CacheOperator.readById(strMapKey);
            }
            BeanUtil.setDeclaredProperty(cursource, strPropertyNames[i], objValue);
        }
    }
}
