/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cip.graph.entity.facade;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeanUtils;

import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.entity.facade.EntityFacade;
import com.comtop.cap.bm.metadata.entity.model.EntityRelationshipVO;
import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cap.bm.metadata.page.desinger.facade.PageFacade;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.cap.runtime.base.facade.BaseFacade;
import com.comtop.cip.graph.entity.appservice.GraphAppService;
import com.comtop.cip.graph.entity.model.GraphEntityRelaVO;
import com.comtop.cip.graph.entity.model.GraphEntityVO;
import com.comtop.cip.graph.entity.model.GraphModuleVO;
import com.comtop.cip.graph.entity.model.GraphPageVO;
import com.comtop.cip.graph.uml.model.GraphEntityExtendVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.top.sys.module.appservice.ModuleAppService;
import com.comtop.top.sys.module.model.ModuleVO;

/**
 * 模型门面
 * 
 * @author 陈志伟
 * @since 1.0
 * @version 2015-7-17 陈志伟
 */
@PetiteBean
public class GraphFacadeImpl extends BaseFacade implements IGraphFacade {
    
    /** 模块服务类 */
    @PetiteInject
    protected ModuleAppService moduleAppService;
    
    /** 模块服务类 */
    @PetiteInject
    protected GraphAppService graphAppService;
    
    /** 实体服务代理类 */
    @PetiteInject
    protected EntityFacade entityFacade;
    
    /** 页面服务代理类 */
    @PetiteInject
    protected PageFacade pageFacade;
    
    /** 日志 */
    private final static Logger LOG = LoggerFactory.getLogger(GraphFacadeImpl.class);
    
    /**
     * 获得与模块平级的兄弟模块,包括模块本身
     * 
     * @param objModuleVO
     *            模块
     * @return 所有兄弟模块Map
     */
    private Map<String, GraphModuleVO> getSiblingGraphModuleVOMap(ModuleVO objModuleVO) {
        List<ModuleVO> lstSiblingModuleVO = moduleAppService.getSubChildModuleByModuleId(objModuleVO
            .getParentModuleId());
        Map<String, GraphModuleVO> siblingGraphModuleVOMap = new HashMap<String, GraphModuleVO>();
        for (ModuleVO objSiblingModuleVo : lstSiblingModuleVO) {
            String packageFullPath = objSiblingModuleVo.getFullPath();
            if (packageFullPath != null) {
                GraphModuleVO objSiblingGraphModuleVO = new GraphModuleVO();
                BeanUtils.copyProperties(objSiblingModuleVo, objSiblingGraphModuleVO);
                objSiblingGraphModuleVO.setPackageFullPath(packageFullPath);
                siblingGraphModuleVOMap.put(packageFullPath, objSiblingGraphModuleVO);
            }
        }
        return siblingGraphModuleVOMap;
    }
    
    /**
     * 获得实体关联的页面
     * 
     * @param entityVO
     *            实体
     * @throws OperateException 操作异常
     * @return 实体关联的页面
     */
    private List<GraphPageVO> getRelaPages(EntityVO entityVO) throws OperateException {
        List<GraphPageVO> lstGraphPageVO = new ArrayList<GraphPageVO>();
        // 查询数据集引用了当前实体的page
        List<PageVO> lstPageVO = pageFacade.queryPageListByEntityId(entityVO.getModelId());
        for (PageVO pageVO : lstPageVO) {
            GraphPageVO objGraphPageVO = new GraphPageVO();
            objGraphPageVO.setId(pageVO.getModelId());
            objGraphPageVO.setEntityId(entityVO.getModelId());
            objGraphPageVO.setPath(pageVO.getUrl());
            objGraphPageVO.setChineseName(pageVO.getCname());
            objGraphPageVO.setEnglishName(pageVO.getModelName() + ".jsp");
            objGraphPageVO.setTitle(pageVO.getCname());
            objGraphPageVO.setPackageId(entityVO.getPackageId());
            lstGraphPageVO.add(objGraphPageVO);
        }
        return lstGraphPageVO;
    }
    
    /**
     * 设置目标模块
     * 
     * @param entityRelationshipVO
     *            实体关联关系
     * @param strTargetPackageId
     *            目标包id
     * @param siblingGraphModuleVOMap
     *            存放兄弟模块的map
     * @param mapFromModuleVO
     *            存放目标模块的map
     */
    private void setEntityFromModule(EntityRelationshipVO entityRelationshipVO, String strTargetPackageId,
        Map<String, GraphModuleVO> siblingGraphModuleVOMap, Map<String, GraphModuleVO> mapFromModuleVO) {
        GraphModuleVO objTargetGraphModuleVO = siblingGraphModuleVOMap.get(strTargetPackageId);
        if (objTargetGraphModuleVO == null) {
            return;
        }
        // 获得模块内实体依赖于外部模块的实体
        EntityVO objTargetEntityVO = entityFacade.loadEntity(entityRelationshipVO.getTargetEntityId(),
            strTargetPackageId);
        GraphEntityVO objTargetGraphEntityVO = new GraphEntityVO();
        BeanUtils.copyProperties(objTargetEntityVO, objTargetGraphEntityVO);
        
        // 外部模块下实体的集合
        List<GraphEntityVO> lstFromGraphEntityVO;
        // 如果map中包含了模块
        if (mapFromModuleVO.containsKey(strTargetPackageId)) {
            lstFromGraphEntityVO = mapFromModuleVO.get(strTargetPackageId).getGraphEntityVOs();
            lstFromGraphEntityVO.add(objTargetGraphEntityVO);
        } else {
            lstFromGraphEntityVO = new ArrayList<GraphEntityVO>();
            lstFromGraphEntityVO.add(objTargetGraphEntityVO);
        }
        objTargetGraphModuleVO.setGraphEntityVOs(lstFromGraphEntityVO);
        // 将实体集合重新存入到外部模块中
        mapFromModuleVO.put(strTargetPackageId, objTargetGraphModuleVO);
    }
    
    /**
     * 设置源模块
     * 
     * @param entityVO
     *            实体
     * @param lstEntityId
     *            存放本模块所有实体Id的list
     * @param siblingGraphModuleVOMap
     *            存放兄弟模块的map
     * @param mapToModuleVO
     *            存放源模块的map
     * @throws OperateException 操作异常
     */
    private void setEntityToModule(EntityVO entityVO, List<String> lstEntityId,
        Map<String, GraphModuleVO> siblingGraphModuleVOMap, Map<String, GraphModuleVO> mapToModuleVO)
        throws OperateException {
        // 以实体为目标的关联关系,过滤掉本模块的
        List<EntityVO> lstSourceEntityVO = entityFacade.queryRelationEntityById(entityVO.getModelId());
        for (EntityVO objSourceEntityVO : lstSourceEntityVO) {
            if (!lstEntityId.contains(objSourceEntityVO.getModelId())) {
                String strSourcePackageId = objSourceEntityVO.getModelId().substring(0,
                    objSourceEntityVO.getModelId().lastIndexOf(".entity"));
                GraphModuleVO objSourceGraphModuleVO = siblingGraphModuleVOMap.get(strSourcePackageId);
                if (objSourceGraphModuleVO == null) {
                    continue;
                }
                GraphEntityVO objSourceGraphEntityVO = new GraphEntityVO();
                BeanUtils.copyProperties(objSourceEntityVO, objSourceGraphEntityVO);
                // 外部模块下实体的集合
                List<GraphEntityVO> lstToGraphEntityVO;
                // 如果map中包含了模块
                if (mapToModuleVO.containsKey(strSourcePackageId)) {
                    lstToGraphEntityVO = mapToModuleVO.get(strSourcePackageId).getGraphEntityVOs();
                    lstToGraphEntityVO.add(objSourceGraphEntityVO);
                } else {
                    lstToGraphEntityVO = new ArrayList<GraphEntityVO>();
                    lstToGraphEntityVO.add(objSourceGraphEntityVO);
                }
                objSourceGraphModuleVO.setGraphEntityVOs(lstToGraphEntityVO);
                // 将实体集合重新存入到外部模块中
                mapToModuleVO.put(strSourcePackageId, objSourceGraphModuleVO);
            }
        }
    }
    
    /**
     * 查询实体关系
     * 
     * @see com.comtop.cip.graph.entity.facade.IGraphFacade#queryGraphEntityByPackageId(java.lang.String)
     */
    @Override
    public GraphModuleVO queryGraphEntityByPackageId(String packageId) {
        ModuleVO objModuleVO = moduleAppService.readModuleVO(packageId);
        GraphModuleVO objGraphModuleVO = new GraphModuleVO();
        BeanUtils.copyProperties(objModuleVO, objGraphModuleVO);
        
        Map<String, GraphModuleVO> siblingGraphModuleVOMap = getSiblingGraphModuleVOMap(objModuleVO);
        
        // 模块下的实体
        List<GraphEntityVO> lstGraphEntityVO = new ArrayList<GraphEntityVO>();
        // 模块下实体的关联关系
        List<GraphEntityRelaVO> lstEntityRelaVO = new ArrayList<GraphEntityRelaVO>();
        // 模块下实体的继承关系
        List<GraphEntityExtendVO> lstEntityExtendVO = new ArrayList<GraphEntityExtendVO>();
        
        // 查询模块下的实体
        try {
            List<EntityVO> lstEntityVO = entityFacade.queryEntityList(packageId);
            if (lstEntityVO != null && lstEntityVO.size() > 0) {
                // 用于判断实体是否属于模块内
                List<String> lstEntityId = new ArrayList<String>();
                for (EntityVO objEntityVO : lstEntityVO) {
                    lstEntityId.add(objEntityVO.getModelId());
                }
                
                for (EntityVO entityVO : lstEntityVO) {
                    GraphEntityVO objGraphEntityVO = new GraphEntityVO();
                    BeanUtils.copyProperties(entityVO, objGraphEntityVO);
                    lstGraphEntityVO.add(objGraphEntityVO);
                    // 查询实体关联的页面
                    List<GraphPageVO> lstGraphPageVO = getRelaPages(entityVO);
                    objGraphEntityVO.setGraphPages(lstGraphPageVO);
                    // 本实体依赖的外部模块集合
                    Map<String, GraphModuleVO> mapToModuleVO = new HashMap<String, GraphModuleVO>();
                    // 依赖于本实体的外部模块集合
                    Map<String, GraphModuleVO> mapFromModuleVO = new HashMap<String, GraphModuleVO>();
                    // 计算继承关系,只有当实体的父实体Id也在本模块，继承关系才成立
                    if (lstEntityId.contains(entityVO.getParentEntityId())) {
                        GraphEntityExtendVO objGraphEntityExtendVO = new GraphEntityExtendVO();
                        objGraphEntityExtendVO.setChildEntityId(entityVO.getModelId());
                        objGraphEntityExtendVO.setParentEntityId(entityVO.getParentEntityId());
                        lstEntityExtendVO.add(objGraphEntityExtendVO);
                    }
                    if (entityVO.getLstRelation() != null) {
                        // 实体内只存放实体出发的关联关系
                        for (EntityRelationshipVO entityRelationshipVO : entityVO.getLstRelation()) {
                            // 源实体Id
                            String strSourceEntityId = entityRelationshipVO.getSourceEntityId();
                            // 目标实体Id,由包Id.实体名组成
                            String strTargetEntityId = entityRelationshipVO.getTargetEntityId();
                            // 根据目标实体Id,获得目标实体所在模块包Id
                            String strTargetPackageId = strTargetEntityId.substring(0,
                                strTargetEntityId.lastIndexOf(".entity"));
                            /*
                             * 获得模块内实体之间的关联关系
                             */
                            if (entityVO.getModelId().equals(strSourceEntityId)
                                && lstEntityId.contains(strTargetEntityId)) {
                                GraphEntityRelaVO objGraphEntityRelaVO = new GraphEntityRelaVO();
                                BeanUtils.copyProperties(entityRelationshipVO, objGraphEntityRelaVO);
                                lstEntityRelaVO.add(objGraphEntityRelaVO);
                            } else if (entityVO.getModelId().equals(strSourceEntityId)
                                && !lstEntityId.contains(strTargetEntityId)) {
                                
                                setEntityFromModule(entityRelationshipVO, strTargetPackageId, siblingGraphModuleVOMap,
                                    mapFromModuleVO);
                            }
                        }
                    }
                    
                    setEntityToModule(objGraphEntityVO, lstEntityId, siblingGraphModuleVOMap, mapToModuleVO);
                    
                    if (mapToModuleVO != null && mapToModuleVO.size() > 0) {
                        List<GraphModuleVO> lstToGraphModuleVO = new ArrayList<GraphModuleVO>(mapToModuleVO.values());
                        objGraphEntityVO.setGraphToModules(lstToGraphModuleVO);
                    }
                    if (mapFromModuleVO != null && mapFromModuleVO.size() > 0) {
                        List<GraphModuleVO> lstFromGraphModuleVO = new ArrayList<GraphModuleVO>(
                            mapFromModuleVO.values());
                        objGraphEntityVO.setGraphFromModules(lstFromGraphModuleVO);
                    }
                }
            }
            // 在模块中设置实体
            objGraphModuleVO.setGraphEntityVOs(lstGraphEntityVO);
            // 在模块中设置实体关系
            objGraphModuleVO.setGraphEntityRelaVOs(lstEntityRelaVO);
            // 在模块中设置实体继承关系
            objGraphModuleVO.setGraphEntityExtendVOs(lstEntityExtendVO);
        } catch (OperateException e) {
            LOG.error("查询实体发生错误", e);
        }
        
        return objGraphModuleVO;
    }
    
    /**
     * 
     * 查询第三层子模块列表
     *
     * @param moduleId 图形模块实体id
     * @return 图形模块实体
     */
    @Override
    public GraphModuleVO queryThreeChildrenModuleVOList(final String moduleId) {
        return graphAppService.queryThreeChildrenModuleVOList(moduleId);
    }
}
