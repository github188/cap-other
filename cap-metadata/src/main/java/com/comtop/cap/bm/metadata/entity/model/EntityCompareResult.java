/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.entity.model;

import java.util.ArrayList;
import java.util.List;

import com.comtop.cap.runtime.base.model.BaseVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 实体比较结果
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2014-4-25 李忠文
 */
@DataTransferObject
public class EntityCompareResult extends BaseVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /**
     * 实体比较结果:-1 表示实体不存在
     */
    public final static int ENTITY_NOT_EXISTS = -1;
    
    /**
     * 实体比较结果:0 表示相同
     */
    public final static int ENTITY_EQUAL = 0;
    
    /**
     * 实体比较结果:1 表示只有实体属性存在不同
     */
    public final static int ENTITY_ATTR_DIFF = 1;
    
    /**
     * 实体比较结果:2 表示只有实体描述存在不同
     */
    public final static int ENTITY_DESC_DIFF = 2;
    
    /**
     * 实体比较结果:3 表示只有实体类型存在不同
     */
    public final static int ENTITY_TYPE_DIFF = 3;
    
    /** ID */
    private String id;
    
    /** 比较结果：0表示相同，-1 表示实体不存在，需要新增，1 表示只有实体属性存在不同, 2 表示实体对应表存在不同 */
    private int result;
    
    /** 源实体 */
    private EntityVO srcEntity;
    
    /** 目标实体 */
    private EntityVO targetEntity;
    
    /** 实体属性比较结果 */
    private List<AttributeCompareResult> attrResults;
    
    /**
     * 构造函数
     * 
     * @param id ID
     */
    public EntityCompareResult(String id) {
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
     * @return 获取 srcEntity属性值
     */
    public EntityVO getSrcEntity() {
        return srcEntity;
    }
    
    /**
     * @param srcEntity 设置 srcEntity 属性值为参数值 srcEntity
     */
    public void setSrcEntity(EntityVO srcEntity) {
        this.srcEntity = srcEntity;
    }
    
    /**
     * @return 获取 targetEntity属性值
     */
    public EntityVO getTargetEntity() {
        return targetEntity;
    }
    
    /**
     * @param targetEntity 设置 targetEntity 属性值为参数值 targetEntity
     */
    public void setTargetEntity(EntityVO targetEntity) {
        this.targetEntity = targetEntity;
    }
    
    /**
     * @return 获取 attrResults属性值
     */
    public List<AttributeCompareResult> getAttrResults() {
        return attrResults;
    }
    
    /**
     * @param attrResults 设置 attrResults 属性值为参数值 attrResults
     */
    public void setAttrResults(List<AttributeCompareResult> attrResults) {
        this.attrResults = attrResults;
    }
    
    /**
     * 添加实体属性比较结果
     * 
     * @param attrResult 实体属性比较结果
     */
    public void addAtrrResult(AttributeCompareResult attrResult) {
        if (this.attrResults == null) {
            this.attrResults = new ArrayList<AttributeCompareResult>();
        }
        this.attrResults.add(attrResult);
        // 更新比较结果
        if (AttributeCompareResult.ATTR_EQUAL != attrResult.getResult()) {
            this.result = ENTITY_ATTR_DIFF;
        }
    }
    
}
