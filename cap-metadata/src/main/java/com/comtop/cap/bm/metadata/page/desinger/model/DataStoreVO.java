/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.desinger.model;

import java.util.ArrayList;
import java.util.List;

import com.comtop.cap.bm.metadata.base.consistency.annotation.ConsistencyDependOnField;
import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import com.comtop.cap.bm.metadata.common.storage.annotation.IgnoreField;
import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 页面模型
 * 
 * @author 诸焕辉
 * @version jdk1.6
 * @version 2015-4-28 诸焕辉
 */
@DataTransferObject
public class DataStoreVO extends BaseMetadata {
    
    /** serialVersionUID */
    private static final long serialVersionUID = -1130326396798697765L;
    
    /** 数据模型英文名称 */
    private String ename;
    
    /** 数据模型中文名称 */
    private String cname;
    
    /** 数据模型类型 */
    private String modelType;
    
    /** 模型关联实体ID */
    @ConsistencyDependOnField(checkScope=ConsistencyDependOnField.CHECK_SCOPE_GLOBAL,expression="entity[modelId=\"{0}\"]")
    private String entityId;
    
    /** 是否把数据集保存到session */
    private boolean saveToSession = false;
    
    /**
     * @return 获取 saveToSession属性值
     */
    public boolean isSaveToSession() {
        return saveToSession;
    }
    
    /**
     * @param saveToSession 设置 saveToSession 属性值为参数值 saveToSession
     */
    public void setSaveToSession(boolean saveToSession) {
        this.saveToSession = saveToSession;
    }
    
    /** 权限ID集合 */
    public List<RightVO> verifyIdList = new ArrayList<RightVO>();
    
    /**
     * 实体对象
     */
    @IgnoreField
    private EntityVO entityVO = new EntityVO();
    
    /**
     * 当前数据集实体的关联实体
     */
    @IgnoreField
    private List<EntityVO> subEntity = new ArrayList<EntityVO>();
    
    /**
     * 页面常量集合
     */
    @ConsistencyDependOnField
    List<PageConstantVO> pageConstantList = new ArrayList<PageConstantVO>();
    
    /** 别名，用于元数据生成器的数据集替换 */
    private String alias;
    
    /**
     * @return 获取 ename属性值
     */
    public String getEname() {
        return ename;
    }
    
    /**
     * @param ename 设置 ename 属性值为参数值 ename
     */
    public void setEname(String ename) {
        this.ename = ename;
    }
    
    /**
     * @return 获取 cname属性值
     */
    public String getCname() {
        return cname;
    }
    
    /**
     * @param cname 设置 cname 属性值为参数值 cname
     */
    public void setCname(String cname) {
        this.cname = cname;
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
     * @return 获取 verifyIdList属性值
     */
    public List<RightVO> getVerifyIdList() {
        return verifyIdList;
    }
    
    /**
     * @param verifyIdList 设置 verifyIdList 属性值为参数值 verifyIdList
     */
    public void setVerifyIdList(List<RightVO> verifyIdList) {
        this.verifyIdList = verifyIdList;
    }
    
    /**
     * @return 获取 modelType属性值
     */
    public String getModelType() {
        return modelType;
    }
    
    /**
     * @param modelType 设置 modelType 属性值为参数值 modelType
     */
    public void setModelType(String modelType) {
        this.modelType = modelType;
    }
    
    /**
     * @return the entityVO
     */
    public EntityVO getEntityVO() {
        return entityVO;
    }
    
    /**
     * @param entityVO the entityVO to set
     */
    public void setEntityVO(EntityVO entityVO) {
        this.entityVO = entityVO;
    }
    
    /**
     * @return 获取 subEntity属性值
     */
    public List<EntityVO> getSubEntity() {
        return subEntity;
    }
    
    /**
     * @param subEntity 设置 subEntity 属性值为参数值 subEntity
     */
    public void setSubEntity(List<EntityVO> subEntity) {
        this.subEntity = subEntity;
    }
    
    /**
     * @return the pageConstantList
     */
    public List<PageConstantVO> getPageConstantList() {
        return pageConstantList;
    }
    
    /**
     * @param pageConstantList the pageConstantList to set
     */
    public void setPageConstantList(List<PageConstantVO> pageConstantList) {
        this.pageConstantList = pageConstantList;
    }
    
    /**
     * @return the alias
     */
    public String getAlias() {
        return alias;
    }
    
    /**
     * @param alias the alias to set
     */
    public void setAlias(String alias) {
        this.alias = alias;
    }
}
