/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cip.graph.entity.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cip.graph.entity.model.GraphModuleVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.runtime.base.dao.BaseDAO;

/**
 * 模型实体DAO
 * 
 * @author 陈志伟
 * @since 1.0
 * @version 2015-7-7 陈志伟
 */
@PetiteBean
public class GraphDAO extends BaseDAO<EntityVO> {
    
    /**
     * 根据包ID查询页面
     * 
     * @param packageId
     *            包ID
     * @return 页面集合
     */
    // public List<PageVO> queryGraphPageListByPackageId(final String packageId) {
    // Map<String, String> objParam = new HashMap<String, String>();
    // objParam.put("packageId", packageId);
    // return this.queryList("com.comtop.cip.graph.entity.model.queryGraphPageListByPackageId", objParam);
    // }
    
    /**
     * 通过包ID查询所有实体关系
     * 
     * @param packageId
     *            包ID
     * @return 实体关系对象集合
     */
    // public List<EntityRelationshipVO> queryInnerEntityRelationByPackageId(final String packageId) {
    // Map<String, Object> objParam = new HashMap<String, Object>();
    // objParam.put("packageId", packageId);
    //
    // List<EntityRelationshipVO> lstRelation = this.queryList(
    // "com.comtop.cip.graph.entity.model.queryInnerEntityRelationByPackageId", objParam);
    // return lstRelation;
    // }
    
    /**
     * 通过包ID查询所有实体关系
     * 
     * @param packageId
     *            包ID
     * @return 实体关系对象集合
     */
    // public List<EntityRelationshipVO> queryFromEntityRelationByPackageId(final String packageId) {
    // Map<String, Object> objParam = new HashMap<String, Object>();
    // objParam.put("packageId", packageId);
    //
    // List<EntityRelationshipVO> lstRelation = this.queryList(
    // "com.comtop.cip.graph.entity.model.queryFromEntityRelationByPackageId", objParam);
    // return lstRelation;
    // }
    
    /**
     * 通过包ID查询所有实体关系
     * 
     * @param packageId
     *            包ID
     * @return 实体关系对象集合
     */
    // public List<EntityRelationshipVO> queryToEntityRelationByPackageId(final String packageId) {
    // Map<String, Object> objParam = new HashMap<String, Object>();
    // objParam.put("packageId", packageId);
    //
    // List<EntityRelationshipVO> lstRelation = this.queryList(
    // "com.comtop.cip.graph.entity.model.queryToEntityRelationByPackageId", objParam);
    // return lstRelation;
    // }
    
    /**
     * 查询该包中满足关键字的所有实体
     * 
     * @param packageId 包ID
     * @return 实体对象集合
     */
    // public List<GraphEntityVO> queryEntityByPackageId(final String packageId) {
    // Map<String, String> objParam = new HashMap<String, String>();
    // objParam.put("packageId", packageId);
    // return this.queryList("com.comtop.cip.graph.entity.model.queryEntityByPackageId", objParam);
    // }
    
    /**
     * 通过包ID查询其所有属性
     * 
     * @param packageId
     *            包ID
     * @return 实体属性对象集合
     */
    // public List<EntityAttributeVO> queryEntityAttributeByPackageId(final String packageId) {
    // Map<String, Object> objParam = new HashMap<String, Object>();
    // objParam.put("packageId", packageId);
    // return queryList("com.comtop.cip.graph.entity.model.queryEntityAttributeByPackageId", objParam);
    // }
    
    /**
     * 通过包ID查询其所有方法
     * 
     * @param packageId
     *            包ID
     * @return 实体属性对象集合
     */
    // public List<MethodVO> queryMethodByPackageId(final String packageId) {
    // Map<String, Object> objParam = new HashMap<String, Object>();
    // objParam.put("packageId", packageId);
    // return queryList("com.comtop.cip.graph.entity.model.queryMethodByPackageId", objParam);
    // }
    
    /**
     * 
     * 读取根模块
     *
     * @return 图形模块实体
     */
    public GraphModuleVO readRootGraphModuleVO() {
        return (GraphModuleVO) this.selectOne("com.comtop.cip.graph.entity.model.readRootGraphModuleVO", null);
    }
    
    /**
     * 
     * 读取图形模块实体
     *
     * @param moduleId 模块ID
     * @return 图形模块实体
     */
    public GraphModuleVO readGraphModuleVO(final String moduleId) {
        return (GraphModuleVO) this.selectOne("com.comtop.cip.graph.entity.model.readGraphModuleVO", moduleId);
    }
    
    /**
     * 
     * 查询子模块列表
     *
     * @param graphModuleVO 图形模块实体
     * @return 图形模块实体
     */
    // public List<GraphModuleVO> queryChildrenModuleVOList(final GraphModuleVO graphModuleVO) {
    // Map<String, String> params = new HashMap<String, String>();
    // params.put("moduleIdFullPath", graphModuleVO.getModuleIdFullPath());
    // params.put("packageFullPath", graphModuleVO.getPackageFullPath());
    // List<GraphModuleVO> lstGraphModuleVO = this.queryList(
    // "com.comtop.cip.graph.entity.model.queryChildrenModuleVOList", params);
    // return lstGraphModuleVO;
    // }
    
    /**
     * 
     * 查询第三层子模块列表
     *
     * @param moduleId 图形模块实体id
     * @return 图形模块实体
     */
    public List<GraphModuleVO> queryThreeChildrenModuleVOList(final String moduleId) {
        Map<String, String> params = new HashMap<String, String>();
        params.put("moduleIdFullPath", moduleId);
        List<GraphModuleVO> lstGraphModuleVO = this.queryList(
            "com.comtop.cip.graph.entity.model.queryThreeChildrenModuleVOList", params);
        return lstGraphModuleVO;
    }
}
