/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cip.graph.entity.facade;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.common.storage.GraphMainObservable;
import com.comtop.cap.bm.metadata.entity.facade.EntityFacade;
import com.comtop.cap.bm.metadata.entity.model.EntityRelationshipVO;
import com.comtop.cap.runtime.base.facade.BaseFacade;
import com.comtop.cip.graph.entity.appservice.GraphModuleAppService;
import com.comtop.cip.graph.entity.model.GraphModuleRelaVO;
import com.comtop.cip.graph.entity.model.GraphModuleVO;
import com.comtop.cip.graph.entity.util.GraphModuleUtils;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.top.sys.module.appservice.ModuleAppService;

/**
 * 模块依赖图门面类
 *
 * @author 刘城
 * @since jdk1.6
 * @version 2016年11月1日 刘城
 */
@PetiteBean
public class GraphModuleFacadeImpl extends BaseFacade implements IGraphModuleFacade {
    
    /** 日志 */
    private final static Logger LOGGER = LoggerFactory.getLogger(GraphModuleFacadeImpl.class);
    
    /** 实体服务类 */
    @PetiteInject
    protected EntityFacade entityFacade;
    
    /** 模块关系app */
    @PetiteInject
    protected ModuleAppService moduleAppService;
    
    /** 模块关系图服务 */
    @PetiteInject
    protected GraphModuleAppService graphModuleAppService;
    
    /** 观察者 */
    protected GraphMainObservable observable = GraphMainObservable.getInstance();
    
    @Override
    public GraphModuleVO queryGraphModuleNameByModuleId(String packageId) {
        return graphModuleAppService.queryGraphModuleNameByModuleId(packageId);
    }
    
    /**
     * 获取被依赖的模块关系列表
     * 
     * @param graphModuleVO 模块VO
     * @return 模块依赖外部模块关系列表
     */
    private List<GraphModuleRelaVO> getDependedOutModuleRelaVOList(GraphModuleVO graphModuleVO) {
        List<GraphModuleRelaVO> lstDependedOutModuleRelaVOs = new ArrayList<GraphModuleRelaVO>();
        // 此方法为预留方法
        return lstDependedOutModuleRelaVOs;
    }
    
    /**
     * 根据实体/页面ID获取包路径
     * 
     * @param entityId 实体ID
     * @return 实体所在包路径
     */
    private String getSubPackageFullPath(String entityId) {
        if (entityId == null || "".equals(entityId)) {
            return "";
        }
        if (entityId.indexOf("entity") == -1 && entityId.indexOf("page") == -1) {
            return null;
        }
        String strRe = "";
        if (entityId.indexOf("entity") != -1) {
            strRe = entityId.substring(0, entityId.indexOf("entity") - 1);
        } else {
            strRe = entityId.substring(0, entityId.indexOf("page") - 1);
        }
        return strRe;
    }
    
    /**
     * 
     * 存储模块关系 将当前系统模块下的所有元数据（页面/实体）存在的关联关系保存起来
     * 
     */
    @Override
    public void saveGraphModuleVORelations() {
        long startTime = System.currentTimeMillis();
        Map<String, Object> graphMap = observable.getGraphMap();
        GraphModuleVO objGraphModuleVO = graphModuleAppService.readRootGraphModuleVO();
        List<GraphModuleVO> allGraphModuleVOs = graphModuleAppService.queryAllChildrenModuleVOList(objGraphModuleVO
            .getModuleId());
        graphMap.put("allGraph", allGraphModuleVOs);
        // 查询出当前模块的子模块列表
        Map<String, Object> objsubMap = getAllGraphRelaMap(objGraphModuleVO, null);
        List<EntityRelationshipVO> allEntityRelationshipVOList = (List<EntityRelationshipVO>) objsubMap
            .get("allEntityRelationshipVOList");
        GraphModuleUtils.removeDuplicate(allEntityRelationshipVOList);
        
        // 数据保存到内存中
        graphMap.put("allEntityRelationshipVOList", allEntityRelationshipVOList);
        
        LOGGER.debug("=================================================关系计算完成:共" + allEntityRelationshipVOList.size()
            + "条  花费时间：" + String.valueOf(System.currentTimeMillis() - startTime));
    }
    
    /**
     * 获取内部模块依赖关系列表（递归）
     *
     * @param graphModuleVO 模块VO
     * @param allEntityRelationshipVOList 实体映射关系
     * @return 模块依赖关系列表
     */
    private Map<String, Object> getAllGraphRelaMap(GraphModuleVO graphModuleVO,
        List<EntityRelationshipVO> allEntityRelationshipVOList) {
        Map<String, Object> objReMap = new HashMap<String, Object>();
        if (allEntityRelationshipVOList == null) {
            allEntityRelationshipVOList = new ArrayList<EntityRelationshipVO>();
        }
        // 1.查询出当前模块的子模块列表
        List<GraphModuleVO> lstGraphModuleVOs = graphModuleAppService.queryChildrenModuleVOList(graphModuleVO
            .getModuleId());
        // 2.查询指定包下所有实体关联关系 应用下才有可能存在实体和页面
        if (graphModuleVO.getModuleType() == 2) {
            // 查询实体映射关系 同时将其他关系转化为实体映射关系
            allEntityRelationshipVOList.addAll(GraphModuleUtils.getEntityRelationshipVO4Others(graphModuleVO));
        }
        // 3.递归到每个子模块
        for (Iterator iterator = lstGraphModuleVOs.iterator(); iterator.hasNext();) {
            GraphModuleVO objGraphModuleVO = (GraphModuleVO) iterator.next();
            getAllGraphRelaMap(objGraphModuleVO, allEntityRelationshipVOList);
        }
        
        // 最后返回所有的实体关系(实体-实体 实体-页面 页面-页面)
        objReMap.put("allEntityRelationshipVOList", allEntityRelationshipVOList);
        return objReMap;
    }
    
    /**
     * 通过模块ID获取模块图形关系数据
     * 
     * @param packageId 包ID
     * @return 模块图形关系数据
     */
    @Override
    public GraphModuleVO queryGraphModuleByModuleId(final String packageId) {
        String strModuleId = StringUtils.isBlank(packageId) ? moduleAppService.getRootModule().getModuleId()
            : packageId;
        // 根据moduleId读取GraphModuleVO
        GraphModuleVO objGraphModuleVO = graphModuleAppService.readGraphModuleVO(strModuleId);
        // 查询出当前模块的子模块列表
        List<GraphModuleVO> lstInnerModules = graphModuleAppService.queryChildrenModuleVOList(strModuleId);
        objGraphModuleVO.setInnerModuleVOList(lstInnerModules);
        Map<String, Object> objRelaMap = getInnerAndOutModuleRelaMap(objGraphModuleVO);
        // 查询内部模块的依赖关系列表
        List<GraphModuleRelaVO> lstInnerModuleRelaVO = (List<GraphModuleRelaVO>) objRelaMap
            .get("lstInnerGraphModuleRelaVOs");
        // 查询依赖的模块关系列表
        List<GraphModuleRelaVO> lstDependOutModuleRelaVO = (List<GraphModuleRelaVO>) objRelaMap
            .get("lstOuterGraphModuleRelaVOs");
        // 查询被依赖的模块关系列表
        List<GraphModuleRelaVO> lstDependedOutModuleRelaVO = getDependedOutModuleRelaVOList(objGraphModuleVO);
        objGraphModuleVO.setInnerModuleRelaVOList(lstInnerModuleRelaVO);
        objGraphModuleVO.setDependOutModuleRelaVOList(lstDependOutModuleRelaVO);
        objGraphModuleVO.setDependedOutModuleRelaVOList(lstDependedOutModuleRelaVO);
        
        List<GraphModuleVO> listDependOutModuleVO = new ArrayList<GraphModuleVO>();
        if (lstDependOutModuleRelaVO != null && !lstDependOutModuleRelaVO.isEmpty()) {
            for (Iterator<GraphModuleRelaVO> iterator = lstDependOutModuleRelaVO.iterator(); iterator.hasNext();) {
                GraphModuleRelaVO objGraphModuleRelaVO = iterator.next();
                String targetModuleId = objGraphModuleRelaVO.getTargetModuleId();
                GraphModuleVO tmpGraphModuleVO = graphModuleAppService.readGraphModuleVO(targetModuleId);
                listDependOutModuleVO.add(tmpGraphModuleVO);
                // LOGGER.debug("找到依赖关系:");
            }
        }
        
        List<GraphModuleVO> lstDependedOutModuleVO = new ArrayList<GraphModuleVO>();
        if (lstDependedOutModuleRelaVO != null && !lstDependedOutModuleRelaVO.isEmpty()) {
            for (Iterator<GraphModuleRelaVO> iterator = lstDependedOutModuleRelaVO.iterator(); iterator.hasNext();) {
                GraphModuleRelaVO objGraphModuleRelaVO = iterator.next();
                String targetModuleId = objGraphModuleRelaVO.getTargetModuleId();
                GraphModuleVO tmpGraphModuleVO = graphModuleAppService.readGraphModuleVO(targetModuleId);
                lstDependedOutModuleVO.add(tmpGraphModuleVO);
            }
        }
        
        objGraphModuleVO.setDependedOutModuleVOList(lstDependedOutModuleVO);
        objGraphModuleVO.setDependOutModuleVOList(listDependOutModuleVO);
        return objGraphModuleVO;
    }
    
    /**
     * 获取内部模块依赖和依赖外部模块关系列表
     *
     * @param graphModuleVO 模块VO
     * @return 模块依赖关系列表
     */
    private Map<String, Object> getInnerAndOutModuleRelaMap(GraphModuleVO graphModuleVO) {
        List<GraphModuleRelaVO> lstInnerGraphModuleRelaVOs = new ArrayList<GraphModuleRelaVO>();
        List<GraphModuleRelaVO> lstOuterGraphModuleRelaVOs = new ArrayList<GraphModuleRelaVO>();
        Map<String, Object> objReMap = new HashMap<String, Object>();
        // 所有子节点
        List<GraphModuleVO> subGraphModuleVOs = graphModuleVO.getInnerModuleVOList();
        // 全部子孙节点
        List<GraphModuleVO> allChildGraphModuleVOs = graphModuleAppService.queryAllChildrenModuleVOList(graphModuleVO
            .getModuleId());
        Map<String, GraphModuleVO> subGraphModuleVOMap = new HashMap<String, GraphModuleVO>();
        for (GraphModuleVO childGraphModuleVO : allChildGraphModuleVOs) {
            // 将子孙节点全部映射到一级子节点上
            for (GraphModuleVO subGraphModuleVO : subGraphModuleVOs) {
                if (checkIsAncestor(childGraphModuleVO, subGraphModuleVO)) {
                    subGraphModuleVOMap.put(childGraphModuleVO.getModuleId(), subGraphModuleVO);
                    if (!StringUtils.isBlank(childGraphModuleVO.getPackageFullPath())) {
                        subGraphModuleVOMap.put(childGraphModuleVO.getPackageFullPath(), subGraphModuleVO);
                    }
                }
            }
        }
        
        List<EntityRelationshipVO> allEntityRelationshipVOList = (List<EntityRelationshipVO>) observable.getGraphMap()
            .get("allEntityRelationshipVOList");
        if (allEntityRelationshipVOList == null) {
            allEntityRelationshipVOList = new ArrayList<EntityRelationshipVO>();
        }
        
        List<EntityRelationshipVO> lstOutEntityRelationshipVO = new ArrayList<EntityRelationshipVO>();
        List<String> lstOutPackagePath = new ArrayList<String>();
        for (Iterator<EntityRelationshipVO> iterator = allEntityRelationshipVOList.iterator(); iterator.hasNext();) {
            EntityRelationshipVO entityRelationshipVO = iterator.next();
            String sourceEntityId = entityRelationshipVO.getSourceEntityId();
            String targetEntityId = entityRelationshipVO.getTargetEntityId();
            String sourcePackageId = getSubPackageFullPath(sourceEntityId);
            String targetPackageId = getSubPackageFullPath(targetEntityId);
            if (sourcePackageId == null || targetPackageId == null) {
                continue;
            }
            GraphModuleVO sourceGraphModuleVO = subGraphModuleVOMap.get(sourcePackageId);
            GraphModuleVO targetGraphModuleVO = subGraphModuleVOMap.get(targetPackageId);
            // 当根节点为应用时就找不到sourceGraphModuleVO
            if (sourceGraphModuleVO == null) {
                continue;
            }
            // 找不到目标说明类在外部
            if (targetGraphModuleVO == null) {
                lstOutEntityRelationshipVO.add(entityRelationshipVO);
                lstOutPackagePath.add(targetPackageId);
                continue;
            }
            if (sourceGraphModuleVO.getModuleId().equals(targetGraphModuleVO.getModuleId())) {
                continue;
            }
            GraphModuleRelaVO objGraphModuleRelaVO = new GraphModuleRelaVO();
            objGraphModuleRelaVO.setSourceModuleId(sourceGraphModuleVO.getModuleId());
            objGraphModuleRelaVO.setTargetModuleId(targetGraphModuleVO.getModuleId());
            lstInnerGraphModuleRelaVOs.add(objGraphModuleRelaVO);
            
        }
        
        // 处理外部依赖列表
        if (!lstOutPackagePath.isEmpty()) {
            for (Iterator iterator = lstOutEntityRelationshipVO.iterator(); iterator.hasNext();) {
                EntityRelationshipVO objEntityRelationshipVO = (EntityRelationshipVO) iterator.next();
                String sourceEntityId = objEntityRelationshipVO.getSourceEntityId();
                String targetEntityId = objEntityRelationshipVO.getTargetEntityId();
                String sourcePackageId = getSubPackageFullPath(sourceEntityId);
                String targetPackageId = getSubPackageFullPath(targetEntityId);
                if (sourcePackageId == null || targetPackageId == null) {
                    continue;
                }
                GraphModuleVO sourceGraphModuleVO = subGraphModuleVOMap.get(sourcePackageId);
                GraphModuleVO targetGraphModuleVO = graphModuleAppService.readGraphModuleVOByFullPath(targetPackageId);
                // 找不到目标说明类在外部
                if (sourceGraphModuleVO == null || targetGraphModuleVO == null) {
                    continue;
                }
                if (sourceGraphModuleVO.getModuleId().equals(targetGraphModuleVO.getModuleId())) {
                    continue;
                }
                GraphModuleRelaVO objGraphModuleRelaVO = new GraphModuleRelaVO();
                objGraphModuleRelaVO.setSourceModuleId(sourceGraphModuleVO.getModuleId());
                objGraphModuleRelaVO.setTargetModuleId(targetGraphModuleVO.getModuleId());
                lstOuterGraphModuleRelaVOs.add(objGraphModuleRelaVO);
                LOGGER.debug("找到依赖外部关系：" + objGraphModuleRelaVO.getSourceModuleId() + "  22222 "
                    + objGraphModuleRelaVO.getTargetModuleId());
            }
        }
        // 去重
        GraphModuleUtils.removeDuplicate(lstInnerGraphModuleRelaVOs);
        GraphModuleUtils.removeDuplicate(lstOuterGraphModuleRelaVOs);
        objReMap.put("lstInnerGraphModuleRelaVOs", lstInnerGraphModuleRelaVOs);
        objReMap.put("lstOuterGraphModuleRelaVOs", lstOuterGraphModuleRelaVOs);
        return objReMap;
    }
    
    /**
     * 判断childGraphModuleVO是否是一级子节点的子孙节点
     * 
     * @param childGraphModuleVO 子孙节点
     * @param subGraphModuleVO 一级子节点
     * 
     * @return list
     */
    private boolean checkIsAncestor(GraphModuleVO childGraphModuleVO, GraphModuleVO subGraphModuleVO) {
        String strChildIdFullPath = childGraphModuleVO.getModuleIdFullPath();
        String strSubIdFullPath = subGraphModuleVO.getModuleIdFullPath();
        return strChildIdFullPath.contains(strSubIdFullPath);
    }
}
