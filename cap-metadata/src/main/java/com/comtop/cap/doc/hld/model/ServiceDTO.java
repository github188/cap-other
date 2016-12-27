/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.hld.model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.comtop.cap.document.word.docmodel.data.BaseDTO;

/**
 * 服务
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年12月30日 lizhiyong
 */
public class ServiceDTO extends BaseDTO {
    
    /** 序列化号 */
    private static final long serialVersionUID = 1L;
    
    /** 服务中文名 */
    private String cnName;
    
    /** 服务特点 */
    private String features;
    
    /** 预期性能 */
    private String expPerformance;
    
    /** 约束设计 */
    private String constraint;
    
    /** 是否私有服务 */
    private boolean privateService = true;
    
    /** 对内，对外 */
    private String publicOrPrivate = "对内";
    
    /** 相关联的实体名称集 */
    private String relationEntityNames;
    
    /** 关联的实体集 */
    private final List<EntityDTO> relationEntities = new ArrayList<EntityDTO>();
    
    /** 关联的实体集 */
    private final List<EntityItemDTO> entityInputParamItems = new ArrayList<EntityItemDTO>();
    
    /** 关联的实体集 */
    private final List<EntityItemDTO> entityOutputParamItems = new ArrayList<EntityItemDTO>();
    
    /** 输入的实体参数参数集 */
    private List<EntityDTO> entityInputParams;
    
    /** 输出的实体参数 */
    private List<EntityDTO> entityOutputParams;
    
    /** 输出的实体参数 */
    private Map<String, String> relationEntitiesMap = new HashMap<String, String>();
    
    /**
     * @return 获取 publicOrPrivate属性值
     */
    public String getPublicOrPrivate() {
        return publicOrPrivate;
    }
    
    /**
     * @return 获取 privateService属性值
     */
    public boolean isPrivateService() {
        return privateService;
    }
    
    /**
     * @param privateService 设置 privateService 属性值为参数值 privateService
     */
    public void setPrivateService(boolean privateService) {
        this.privateService = privateService;
        if (privateService) {
            this.publicOrPrivate = "对内";
        } else {
            this.publicOrPrivate = "对外";
        }
        
    }
    
    /**
     * @return 获取 entityInputParamItems属性值
     */
    public List<EntityItemDTO> getEntityInputParamItems() {
        return entityInputParamItems;
    }
    
    /**
     * @return 获取 entityOutputParamItems属性值
     */
    public List<EntityItemDTO> getEntityOutputParamItems() {
        return entityOutputParamItems;
    }
    
    /**
     * @return 获取 relationEntityNames属性值
     */
    public String getRelationEntityNames() {
        return relationEntityNames;
    }
    
    /**
     * @param relationEntityNames 设置 relationEntityNames 属性值为参数值 relationEntityNames
     */
    public void setRelationEntityNames(String relationEntityNames) {
        this.relationEntityNames = relationEntityNames;
    }
    
    /**
     * @return 获取 cnName属性值
     */
    public String getCnName() {
        return cnName;
    }
    
    /**
     * @return 获取 relationEntities属性值
     */
    public List<EntityDTO> getRelationEntities() {
        return relationEntities;
    }
    
    /**
     * @param cnName 设置 cnName 属性值为参数值 cnName
     */
    public void setCnName(String cnName) {
        this.cnName = cnName;
    }
    
    /**
     * @return 获取 features属性值
     */
    public String getFeatures() {
        return features;
    }
    
    /**
     * @param features 设置 features 属性值为参数值 features
     */
    public void setFeatures(String features) {
        this.features = features;
    }
    
    /**
     * @return 获取 expPerformance属性值
     */
    public String getExpPerformance() {
        return expPerformance;
    }
    
    /**
     * @param expPerformance 设置 expPerformance 属性值为参数值 expPerformance
     */
    public void setExpPerformance(String expPerformance) {
        this.expPerformance = expPerformance;
    }
    
    /**
     * @return 获取 constraint属性值
     */
    public String getConstraint() {
        return constraint;
    }
    
    /**
     * @param constraint 设置 constraint 属性值为参数值 constraint
     */
    public void setConstraint(String constraint) {
        this.constraint = constraint;
    }
    
    /**
     * 添加参数
     *
     * @param param 参数
     */
    public void addEntityInputParam(EntityDTO param) {
        if (this.entityInputParams == null) {
            entityInputParams = new ArrayList<EntityDTO>();
        }
        entityInputParams.add(param);
        entityInputParamItems.addAll(param.getItems());
        addRelationEntity(param);
    }
    
    /**
     * @return 获取 entityInputParams属性值
     */
    public List<EntityDTO> getEntityInputParams() {
        return entityInputParams;
    }
    
    /**
     * @param entityInputParams 设置 entityInputParams 属性值为参数值 entityInputParams
     */
    public void setEntityInputParams(List<EntityDTO> entityInputParams) {
        this.entityInputParams = entityInputParams;
        if (entityInputParams != null && entityInputParams.size() > 0) {
            for (EntityDTO entityDTO : entityInputParams) {
                addRelationEntity(entityDTO);
                entityInputParamItems.addAll(entityDTO.getItems());
            }
        }
    }
    
    /**
     * @return 获取 entityOutputParam属性值
     */
    public List<EntityDTO> getEntityOutputParams() {
        return entityOutputParams;
    }
    
    /**
     * @param entityOutputParams 设置 entityOutputParam 属性值为参数值 entityOutputParam
     */
    public void setEntityOutputParams(List<EntityDTO> entityOutputParams) {
        this.entityOutputParams = entityOutputParams;
        if (entityOutputParams != null && entityOutputParams.size() > 0) {
            for (EntityDTO entityDTO : entityOutputParams) {
                addRelationEntity(entityDTO);
                entityOutputParamItems.addAll(entityDTO.getItems());
            }
        }
    }
    
    /**
     * 添加关联实体
     *
     * @param param 实体
     */
    private void addRelationEntity(EntityDTO param) {
        if (relationEntitiesMap.get(param.getId()) == null) {
            this.relationEntities.add(param);
            if (this.relationEntityNames == null) {
                this.relationEntityNames = param.getCnName();
            } else {
                this.relationEntityNames += ";" + param.getCnName();
            }
            relationEntitiesMap.put(param.getId(), param.getId());
        }
    }
    
    /**
     * 添加参数
     *
     * @param param 参数
     */
    public void addEntityOutputParam(EntityDTO param) {
        if (this.entityOutputParams == null) {
            entityOutputParams = new ArrayList<EntityDTO>();
        }
        entityOutputParams.add(param);
        entityOutputParamItems.addAll(param.getItems());
        addRelationEntity(param);
    }
}
