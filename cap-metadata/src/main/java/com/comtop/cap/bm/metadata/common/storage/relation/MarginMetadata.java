/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.common.storage.relation;

import java.util.List;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cip.jodd.bean.BeanUtil;

/**
 * 合并元数据，用于元数据继承
 *
 * @author 郑重
 * @since jdk1.5
 * @version 2015-8-5 郑重
 */
public class MarginMetadata extends MetadataBeanVisitor {
    
    /**
     * 目标对象
     */
    protected Object destination;
    
    /**
     * 构造函数
     * 
     * @param source source
     * @return MarginMetadata
     */
    public static MarginMetadata beans(Object source) {
        return new MarginMetadata(source);
    }
    
    /**
     * 构造函数
     * 
     * @param source source
     */
    public MarginMetadata(Object source) {
        this.source = source;
    }
    
    /**
     * 合并
     * 
     * @return Object
     */
    public Object margin() {
        if (this.source != null) {
            if (BeanUtil.getDeclaredProperty(this.source, "extend") != null) {
                this.destination = CacheOperator.readById((String) BeanUtil.getDeclaredProperty(this.source, "extend"));
                marginBean(this.destination, this.source);
            } else {
                this.destination = this.source;
            }
        }
        return this.destination;
    }
    
    /**
     * 合并对象
     * 
     * @param curdestination destination
     * @param cursource source
     */
    @SuppressWarnings("rawtypes")
    public void marginBean(Object curdestination, Object cursource) {
        if (curdestination instanceof BaseMetadata && cursource instanceof BaseMetadata) {
            String[] strPropertyNames = getAllBeanPropertyNames(cursource.getClass(), false);
            for (int i = 0; i < strPropertyNames.length; i++) {
                Object objValue = BeanUtil.getDeclaredProperty(cursource, strPropertyNames[i]);
                if (isObjectType(objValue)) {
                    if (BeanUtil.getDeclaredProperty(curdestination, strPropertyNames[i]) == null) {
                        BeanUtil.setDeclaredProperty(curdestination, strPropertyNames[i], objValue);
                    } else {
                        if (objValue instanceof List) {
                            marginList((List) BeanUtil.getDeclaredProperty(curdestination, strPropertyNames[i]),
                                (List) objValue);
                        } else {
                            marginBean(BeanUtil.getDeclaredProperty(curdestination, strPropertyNames[i]), objValue);
                        }
                    }
                } else if (objValue != null) {
                    BeanUtil.setDeclaredProperty(curdestination, strPropertyNames[i], objValue);
                }
            }
        }
    }
    
    /**
     * 合并子对象
     * 
     * @param curdestination curdestination
     * @param cursource cursource
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
    private void marginList(List curdestination, List cursource) {
        boolean bObjectType = false;
        // 判断是否对象集合
        if (curdestination.size() > 0) {
            if (isObjectType(curdestination.get(0).getClass())) {
                bObjectType = true;
            }
        } else if (cursource.size() > 0) {
            if (isObjectType(cursource.get(0).getClass())) {
                bObjectType = true;
            }
        }
        
        // 如果是对象集合则进行深度合并
        if (bObjectType) {
            for (Object objSrcValue : cursource) {
                boolean bAdd = true;
                if (objSrcValue != null) {
                    depthMargin(curdestination, objSrcValue, bAdd);
                }
            }
        } else {
            // 基础数据集合则直接合并
            curdestination.addAll(cursource);
        }
    }
    
    /**
     * 深度合并
     * 
     * @param curdestination 集合
     * @param srcValue 对象
     * @param bAdd 是否添加
     */
    private void depthMargin(List curdestination, Object srcValue, boolean bAdd) {
        for (Object objDescValue : curdestination) {
            if (srcValue != null && objDescValue != null) {
                if (isEquals(objDescValue, srcValue)) {
                    bAdd = false;
                    marginBean(objDescValue, srcValue);
                }
            } else {
                bAdd = false;
            }
        }
        if (bAdd) {
            curdestination.add(srcValue);
        }
    }
}
