/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.entity.model;

import com.comtop.cap.runtime.base.model.BaseVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 实体属性比较结果
 * 
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2014-3-31 李忠文
 */
@DataTransferObject
public class AttributeCompareResult extends BaseVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /**
     * -2 表示删除该实体属性
     */
    public final static int ATTR_DEL = -2;
    
    /**
     * -1 表示实体属性不存在
     */
    public final static int ATTR_NOT_EXISTS = -1;
    
    /**
     * 0 表示相同
     */
    public final static int ATTR_EQUAL = 0;
    
    /**
     * 1 表示实体属性存在不同
     */
    public final static int ATTR_DIFF = 1;
    
    /**
     * 2 表示实体属性描述不同
     */
    public final static int ATTR_DESC_DIFF = 2;
    
    /** 实体属性ID */
    private String id;
    
    /** 实体ID */
    private String entityId;
    
    /** 比较结果：0 表示相同,-1 表示实体属性不存在，需要新增，1 表示实体属性存在不同, 2 表示实体属性描述不同 */
    private int result;
    
    /** 源实体属性 */
    private EntityAttributeVO srcAttribute;
    
    /** 目标实体属性 */
    private EntityAttributeVO targetAttribute;
    
    /**
     * 构造函数
     * 
     * @param id id
     */
    public AttributeCompareResult(String id) {
        super();
        this.id = id;
    }
    
    /**
     * @return 获取 id属性值
     */
    @Override
    public String getId() {
        return id;
    }
    
    /**
     * @param id 设置 id 属性值为参数值 id
     */
    @Override
    public void setId(String id) {
        this.id = id;
    }
    
    /**
     * @return 获取 entityId属性值
     */
    public String getEntityId() {
        return entityId;
    }
    
    /**
     * @param entityId 设置 entityId 属性值为参数值 entityId
     */
    public void setEntityId(String entityId) {
        this.entityId = entityId;
    }
    
    /**
     * @return 获取 result属性值
     */
    public int getResult() {
        return result;
    }
    
    /**
     * @param result 设置 result 属性值为参数值 result
     */
    public void setResult(int result) {
        this.result = result;
    }
    
    /**
     * @return 获取 srcAttribute属性值
     */
    public EntityAttributeVO getSrcAttribute() {
        return srcAttribute;
    }
    
    /**
     * @param srcAttribute 设置 srcAttribute 属性值为参数值 srcAttribute
     */
    public void setSrcAttribute(EntityAttributeVO srcAttribute) {
        this.srcAttribute = srcAttribute;
    }
    
    /**
     * @return 获取 targetAttribute属性值
     */
    public EntityAttributeVO getTargetAttribute() {
        return targetAttribute;
    }
    
    /**
     * @param targetAttribute 设置 targetAttribute 属性值为参数值 targetAttribute
     */
    public void setTargetAttribute(EntityAttributeVO targetAttribute) {
        this.targetAttribute = targetAttribute;
    }
}
