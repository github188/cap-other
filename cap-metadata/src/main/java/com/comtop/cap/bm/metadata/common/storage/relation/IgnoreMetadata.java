/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.common.storage.relation;

import java.lang.reflect.Field;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import com.comtop.cap.bm.metadata.common.storage.annotation.IgnoreField;
import com.comtop.cip.jodd.bean.BeanUtil;

/**
 * 处理忽略元数据
 *
 * @author 郑重
 * @since jdk1.5
 * @version 2015-8-7 郑重
 */
public class IgnoreMetadata extends MetadataBeanVisitor {
    
    /** 日志 */
    private final static Logger LOG = LoggerFactory.getLogger(IgnoreMetadata.class);
    
    /**
     * 构造器
     * 
     * @param source 处理对象
     * @return IgnoreMetadata
     */
    public static IgnoreMetadata beans(Object source) {
        return new IgnoreMetadata(source);
    }
    
    /**
     * 构造器
     * 
     * @param source IgnoreMetadata
     */
    public IgnoreMetadata(Object source) {
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
    @SuppressWarnings({ "rawtypes" })
    public void marginBean(Object cursource) {
        if (cursource != null && cursource instanceof BaseMetadata) {
            String[] strPropertyNames = getAllBeanPropertyNames(cursource.getClass(), false);
            for (int i = 0; i < strPropertyNames.length; i++) {
                traversalBeanProperty(cursource, strPropertyNames, i);
            }
        }
    }
    
    /**
     * 变量bean属性
     * 
     * @param cursource 对象
     * @param strPropertyNames 属性名
     * @param i 属性序号
     */
    private void traversalBeanProperty(Object cursource, String[] strPropertyNames, int i) {
        Object objValue = BeanUtil.getDeclaredProperty(cursource, strPropertyNames[i]);
        try {
            Field objField = getField(cursource.getClass(), strPropertyNames[i]);
            if(objField != null){//元数据(pageVO是没定义url属性，但有get方法，url可以保存在元数据文件中)
                // 是否有聚合注解
                boolean bIgnoreField = objField.getAnnotation(IgnoreField.class) != null;
                if (bIgnoreField) {
                    BeanUtil.setDeclaredProperty(cursource, strPropertyNames[i], null);
                } else if (isObjectType(objValue)) {
                    // 如果是对象则进行深度遍历
                    if (objValue instanceof List) {
                        List lstValue = (List) objValue;
                        for (int j = 0; j < lstValue.size(); j++) {
                            if (isObjectType(lstValue.get(j))) {
                                marginBean(lstValue.get(j));
                            }
                        }
                    } else {
                        marginBean(objValue);
                    }
                }
            }
        } catch (Exception e) {
            LOG.error("置空忽略属性失败：" + strPropertyNames, e);
        }
    }
}
