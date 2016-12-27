/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.hld.model;


/**
 * 实体参数
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年12月30日 lizhiyong
 */
public class EntityParamDTO extends EntityDTO {
    
    /** FIXME */
    private static final long serialVersionUID = 1L;
    
    /** 对象id 指定组件、服务等对象的id */
    private String objectId;
    
    /** 对象类型 指定 当前参数对应的对象的类型，是组件、服务还是其它的 */
    private String objectType;
    
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
     * @return 获取 objectType属性值
     */
    public String getObjectType() {
        return objectType;
    }
    
    /**
     * @param objectType 设置 objectType 属性值为参数值 objectType
     */
    public void setObjectType(String objectType) {
        this.objectType = objectType;
    }
}
