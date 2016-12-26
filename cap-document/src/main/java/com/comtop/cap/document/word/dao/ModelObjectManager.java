/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.dao;

import java.util.HashMap;
import java.util.Map;

import com.comtop.cap.document.word.bizmodel.ModelObject;

/**
 * 模型对象管理器，负责模型对象的创建和查找
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年10月23日 lizhiyong
 */
public class ModelObjectManager {
    
    /**
     * 模型对象结构：
     * 第一层Map，key为对象的类型 value为该类对象的集合。
     * 第二层Map，key为对象的唯一标识，value为对象本身索引 。
     * 在导入过程中，key一般为对象的名称
     */
    private final Map<String, Map<String, ModelObject>> classifyMap = new HashMap<String, Map<String, ModelObject>>();
    
    /**
     * 添加一个模型对象
     * 
     *
     * @param data 模型数据 其中classUri属性为必填
     */
    public void addModelObject(ModelObject data) {
        String classUri = data.getClassUri();
        Map<String, ModelObject> objMap = classifyMap.get(classUri);
        if (objMap == null) {
            objMap = new HashMap<String, ModelObject>();
            classifyMap.put(classUri, objMap);
        }
        objMap.put(data.getUri(), data);
    }
    
    /**
     * 
     * 获得一个已经存在的模型对象
     *
     * @param classUri 类别URI
     * @param uri 对象uri
     * @return ModelObject对象。未找到返回空
     */
    public ModelObject getModelObjectIfExsit(String classUri, String uri) {
        Map<String, ModelObject> objMap = classifyMap.get(classUri);
        if (objMap == null) {
            return null;
        }
        return objMap.get(uri);
    }
    
    /**
     * 获得模型对象。如果不存在，则创建一个返回
     *
     * @param classUri 类别Uri 必填
     * @param uri 对象uri 必填
     * @return ModelObject对象。未找到创建一个返回
     */
    public ModelObject getModelObject(String classUri, String uri) {
        Map<String, ModelObject> objMap = classifyMap.get(classUri);
        if (objMap == null) {
            objMap = new HashMap<String, ModelObject>();
            classifyMap.put(classUri, objMap);
        }
        ModelObject modelObject = objMap.get(uri);
        if (modelObject == null) {
            modelObject = new ModelObject();
            modelObject.setClassUri(classUri);
            objMap.put(uri, modelObject);
        }
        return modelObject;
    }
    
    /**
     * @return 获取 classifyMap属性值
     */
    public Map<String, Map<String, ModelObject>> getClassifyMap() {
        return classifyMap;
    }
}
