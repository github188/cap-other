/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.entity.model;

import java.util.List;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 方法里面调用存储过程、函数时使用
 *
 * @author 凌晨
 * @since jdk1.6
 * @version 2015年10月8日 凌晨
 */
@DataTransferObject
public class DBObject extends BaseMetadata {
    
    /** 序列化版本号 */
    private static final long serialVersionUID = 1L;
    
    /** 数据库对象的Id */
    private String objectId;
    
    /** 数据库对象的名称 */
    private String objectName;
    
    /** 数据库对象参数 */
    private List<DBObjectParam> lstParameters;
    
    /**
     * @return 获取 objectId属性值
     */
    public String getObjectId() {
        return objectId;
    }
    
    /**
     * @param objectId 设置 objectId 属性值为参数值 objectId
     */
    public void setObjectId(String objectId) {
        this.objectId = objectId;
    }
    
    /**
     * @return 获取 objectName属性值
     */
    public String getObjectName() {
        return objectName;
    }
    
    /**
     * @param objectName 设置 objectName 属性值为参数值 objectName
     */
    public void setObjectName(String objectName) {
        this.objectName = objectName;
    }
    
    /**
     * @return 获取 lstParameters属性值
     */
    public List<DBObjectParam> getLstParameters() {
        return lstParameters;
    }
    
    /**
     * @param lstParameters 设置 lstParameters 属性值为参数值 lstParameters
     */
    public void setLstParameters(List<DBObjectParam> lstParameters) {
        this.lstParameters = lstParameters;
    }
    
}
