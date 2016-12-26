/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cip.graph.uml.appservice;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.dom4j.DocumentException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeanUtils;

import com.comtop.cap.bm.metadata.common.storage.GraphMainObservable;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.entity.facade.EntityFacade;
import com.comtop.cap.bm.metadata.entity.model.EntityRelationshipVO;
import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cap.runtime.base.appservice.BaseAppService;
import com.comtop.cip.graph.entity.appservice.GraphAppService;
import com.comtop.cip.graph.entity.appservice.GraphModuleAppService;
import com.comtop.cip.graph.entity.dao.GraphModuleDAO;
import com.comtop.cip.graph.entity.model.GraphEntityRelaVO;
import com.comtop.cip.graph.entity.model.GraphEntityVO;
import com.comtop.cip.graph.entity.model.GraphModuleRelaVO;
import com.comtop.cip.graph.entity.model.GraphModuleVO;
import com.comtop.cip.graph.entity.util.GraphModuleUtils;
import com.comtop.cip.graph.uml.model.GraphEntityExtendVO;
import com.comtop.cip.graph.uml.utils.XMIFileHelper;
import com.comtop.cip.graph.xmi.bean.UMLDatatype;
import com.comtop.cip.graph.xmi.bean.UMLDiagram;
import com.comtop.cip.graph.xmi.bean.UMLModel;
import com.comtop.cip.graph.xmi.bean.UMLPackage;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.top.sys.module.appservice.ModuleAppService;
import com.comtop.top.sys.module.model.ModuleVO;

/**
 * 模型实体服务
 * 
 * @author 陈志伟
 * @since 1.0
 * @version 2015-7-17 陈志伟
 */
@PetiteBean
public class GraphUmlAppService extends BaseAppService {
    
    /** 日志 */
    private final static Logger LOG = LoggerFactory.getLogger(GraphUmlAppService.class);
    
    /** 实体属性DAO */
    @PetiteInject
    protected GraphModuleDAO graphModuleDAO;
    
    /** 模块服务类 */
    @PetiteInject
    protected ModuleAppService moduleAppService;
    
    /** 图形服务类 */
    @PetiteInject
    protected GraphAppService graphAppService;
    
    /** 实体服务类 */
    @PetiteInject
    protected EntityFacade entityFacade;
    
    /** 模块关系图服务 */
    @PetiteInject
    protected GraphModuleAppService graphModuleAppService;
    
    /** 观察者 */
    protected GraphMainObservable observable = GraphMainObservable.getInstance();
    
    /**
     * 通过包ID查询该包中所有实体
     * 
     * @param packageId
     *            包ID
     * @return 实体对象集合
     */
    public GraphModuleVO queryGraphUmlByPackageId(final String packageId) {
        // 查询模块信息
        ModuleVO objModuleVO = moduleAppService.readModuleVO(packageId);
        GraphModuleVO objGraphModuleVO = new GraphModuleVO();
        BeanUtils.copyProperties(objModuleVO, objGraphModuleVO);
        
        // 模块下实体的关联关系
        List<GraphEntityRelaVO> lstEntityRelaVO = new ArrayList<GraphEntityRelaVO>();
        
        try {
            // 查询模块下的实体
            List<EntityVO> lstEntityVO = entityFacade.queryEntityList(packageId);
            // 用于判断实体是否属于模块内
            List<String> lstEntityId = new ArrayList<String>();
            for (EntityVO objEntityVO : lstEntityVO) {
                lstEntityId.add(objEntityVO.getModelId());
            }
            
            // 模块下的实体
            List<GraphEntityVO> lstGraphEntityVO = new ArrayList<GraphEntityVO>();
            // 模块下实体的继承关系
            List<GraphEntityExtendVO> lstEntityExtendVO = new ArrayList<GraphEntityExtendVO>();
            
            for (EntityVO entityVO : lstEntityVO) {
                // 获取实体ID
                // String strEntityId = entityVO.getModelId();
                GraphEntityVO objGraphEntityVO = new GraphEntityVO();
                BeanUtils.copyProperties(entityVO, objGraphEntityVO);
                lstGraphEntityVO.add(objGraphEntityVO);
                
                for (EntityRelationshipVO entityRelationshipVO : entityVO.getLstRelation()) {
                    // 源实体Id
                    String strSourceEntityId = entityRelationshipVO.getSourceEntityId();
                    // 目标实体Id,由包Id.实体名组成
                    String strTargetEntityId = entityRelationshipVO.getTargetEntityId();
                    /*
                     * 获得模块内实体之间的关联关系
                     */
                    if (entityVO.getModelId().equals(strSourceEntityId) && lstEntityId.contains(strTargetEntityId)) {
                        GraphEntityRelaVO objGraphEntityRelaVO = new GraphEntityRelaVO();
                        BeanUtils.copyProperties(entityRelationshipVO, objGraphEntityRelaVO);
                        lstEntityRelaVO.add(objGraphEntityRelaVO);
                    }
                    
                    // 计算继承关系,只有当实体的父实体Id也在本模块，继承关系才成立
                    if (lstEntityId.contains(entityVO.getParentEntityId())) {
                        GraphEntityExtendVO objGraphEntityExtendVO = new GraphEntityExtendVO();
                        objGraphEntityExtendVO.setChildEntityId(entityVO.getModelId());
                        objGraphEntityExtendVO.setParentEntityId(entityVO.getParentEntityId());
                        lstEntityExtendVO.add(objGraphEntityExtendVO);
                    }
                }
            }
            // 在模块中设置实体
            objGraphModuleVO.setGraphEntityVOs(lstGraphEntityVO);
            // 在模块中设置实体关系
            objGraphModuleVO.setGraphEntityRelaVOs(lstEntityRelaVO);
            // 在模块中设置关联关系
            objGraphModuleVO.setGraphEntityExtendVOs(lstEntityExtendVO);
        } catch (OperateException e) {
            LOG.error("查询模块信息发错错误:" + e);
        }
        return objGraphModuleVO;
    }
    
    /**
     * 导出ea文件
     *
     * @param file 文件
     * @param moduldId 模块ID
     */
    public void exportXMIFile(File file, String moduldId) {
        try {
            UMLModel umlModel = XMIFileHelper.outputDocument(file);
            
            // UMLDatatype的Name, UMLDatatype
            Map<String, UMLDatatype> umlDatatypeMap = new HashMap<String, UMLDatatype>();
            // moduleId, UMLPackage
            Map<String, UMLPackage> umlPackageMap = new HashMap<String, UMLPackage>(64);
            // moduleId, GraphModuleVO
            Map<String, GraphModuleVO> graphModuleVOMap = new HashMap<String, GraphModuleVO>(64);
            
            GraphModuleVO graphModuleVO = getGraphModuleVO(moduldId);// 读取根模块
            if (graphModuleVO == null) {
                return;
            }
            graphModuleVOMap.put(graphModuleVO.getModuleId(), graphModuleVO);
            UMLPackage parentUMLPackage = umlModel.getRootPackage().getClassModelPackage();
            umlPackageMap.put("ROOT", parentUMLPackage);// 添加父包 也是根包
            UMLPackage currentUMLPackage = new UMLPackage(umlModel, parentUMLPackage, graphModuleVO.getModuleName(),
                graphModuleVO.getPackageFullPath(), false);
            umlPackageMap.put(graphModuleVO.getModuleId(), currentUMLPackage);
            // 读取根模块
            exportModuleToXMIFile(file, umlDatatypeMap, umlPackageMap, graphModuleVOMap, umlModel,
                graphModuleVO.getModuleId(), "ROOT");
        } catch (DocumentException e) {
            LOG.error("导出XMI文件时出现文档异常。", e);
        } catch (IOException e) {
            LOG.error("导出XMI文件时出现IO异常。", e);
        } catch (OperateException e) {
            LOG.error("导出XMI文件时读取元数据异常。", e);
        }
    }
    
    /**
     * 导出模块到XMI文件
     *
     * @param file xmifile
     * @param moduleId 模块ID
     * @param umlDatatypeMap 数据类型集合
     * @param umlPackageMap UMLPackageMap集合
     * @param graphModuleVOMap 图形模块映射集合
     * @param umlModel uml模型
     * @param parentModuleId 父包ID
     * @throws IOException IO异常
     * @throws DocumentException 文档异常
     * @throws OperateException 操作异常
     */
    private void exportModuleToXMIFile(File file, Map<String, UMLDatatype> umlDatatypeMap,
        Map<String, UMLPackage> umlPackageMap, Map<String, GraphModuleVO> graphModuleVOMap, UMLModel umlModel,
        String moduleId, String parentModuleId) throws DocumentException, IOException, OperateException {
        // 1. 初始化当前模块
        GraphModuleVO graphModuleVO = graphModuleVOMap.get(moduleId);
        graphModuleVOMap.remove(moduleId);
        initGraphModuleVO(graphModuleVO);
        
        // 2. 生成并输出UMLDatatype
        List<UMLDatatype> umlDatatypeList = XMIFileHelper.extractUMLDatatype(graphModuleVO, umlModel);
        for (Iterator<UMLDatatype> iterator = umlDatatypeList.iterator(); iterator.hasNext();) {
            UMLDatatype umlDatatype = iterator.next();
            UMLDatatype tmpDatatype = umlDatatypeMap.get(umlDatatype.getName());
            if (tmpDatatype == null) {
                umlDatatypeMap.put(umlDatatype.getName(), umlDatatype);
            } else {
                iterator.remove();// 如果数据类型在umlDatatypeMap中存在 说明之前有输出过该类型 从list集合中删除
            }
        }
        XMIFileHelper.outputUMLDataType(file, umlDatatypeList, umlModel);
        umlDatatypeList = null;
        
        // 3. 生成并输出UMLPackage
        UMLPackage parentUMLPackage = umlPackageMap.get(parentModuleId);
        UMLPackage currentUMLPackage = umlPackageMap.get(moduleId);
        if (currentUMLPackage == null) {
            currentUMLPackage = new UMLPackage(umlModel, parentUMLPackage, graphModuleVO.getModuleName(),
                graphModuleVO.getPackageFullPath(), false);
            umlPackageMap.put(moduleId, currentUMLPackage);
        }
        XMIFileHelper.initUMLPackage(graphModuleVO, umlModel, parentUMLPackage, umlDatatypeMap, umlPackageMap);
        
        if ("ROOT".equals(parentModuleId)) {
            XMIFileHelper.outputUMLPackage(file, currentUMLPackage, parentUMLPackage);
        }
        XMIFileHelper.outputUMLPackageSubElement(file, currentUMLPackage);
        
        umlPackageMap.remove(parentModuleId);
        parentUMLPackage = null;
        
        // 4. 生成并输出UMLDiagram
        UMLDiagram umlDiagram = XMIFileHelper.getUMLDiagram(currentUMLPackage);
        XMIFileHelper.outputUMLDiagram(file, umlDiagram);
        umlDiagram = null;
        currentUMLPackage = null;
        // 5. 递归每个子模块
        List<GraphModuleVO> subGraphModuleVOList = graphModuleVO.getInnerModuleVOList();
        graphModuleVO = null;// 必须在递归调用下一函数前先释放对象引用
        for (Iterator<GraphModuleVO> iterator = subGraphModuleVOList.iterator(); iterator.hasNext();) {
            GraphModuleVO subGraphModuleVO = iterator.next();
            String subModuleId = subGraphModuleVO.getModuleId();
            graphModuleVOMap.put(subModuleId, subGraphModuleVO);
            iterator.remove();//
            subGraphModuleVO = null;
            exportModuleToXMIFile(file, umlDatatypeMap, umlPackageMap, graphModuleVOMap, umlModel, subModuleId,
                moduleId);
        }
    }
    
    /**
     * 
     * 读取模块信息
     * 
     * @param moduleId 当前模块ID
     *
     * @return 图形模块实体
     */
    private GraphModuleVO getGraphModuleVO(String moduleId) {
        GraphModuleVO graphModuleVO = null;
        if (moduleId == null) {
            graphModuleVO = graphAppService.readRootGraphModuleVO();
        } else {
            graphModuleVO = graphModuleDAO.readGraphModuleVO(moduleId);
        }
        return graphModuleVO;
    }
    
    /**
     * 
     * 初始化根模块信息：实体、实体关系、子模块及子模块依赖关系列表
     * 并返回根模块
     * 
     * @param graphModuleVO 图形模块实体
     *
     * @throws OperateException 操作异常
     */
    private void initGraphModuleVO(GraphModuleVO graphModuleVO) throws OperateException {
        // 全部子孙节点
        List<GraphModuleVO> allGraphModuleVOs = (List<GraphModuleVO>) observable.getGraphMap().get("allGraph");
        if (allGraphModuleVOs == null) {
            allGraphModuleVOs = graphModuleAppService.queryAllChildrenModuleVOList(graphModuleVO.getModuleId());
            observable.getGraphMap().put("allGraph", allGraphModuleVOs);
        }
        // 1. 设置子模块列表
        List<GraphModuleVO> graphModuleVOList = GraphModuleUtils.getsubChildGraphModuleVOs(allGraphModuleVOs,
            graphModuleVO);
        graphModuleVO.setInnerModuleVOList(graphModuleVOList);
        
        // 2. 计算子模块依赖关系并设置
        
        List<GraphModuleVO> allChildGraphModuleVOs = GraphModuleUtils.getAllChildGraphModuleVOs(allGraphModuleVOs,
            graphModuleVO);
        // graphModuleAppService.queryAllChildrenModuleVOList(graphModuleVO.getModuleId());
        Map<String, GraphModuleVO> subGraphModuleVOMap = new HashMap<String, GraphModuleVO>();
        for (GraphModuleVO childGraphModuleVO : allChildGraphModuleVOs) {
            // 将子孙节点全部映射到一级子节点上
            for (GraphModuleVO subGraphModuleVO : graphModuleVOList) {
                if (checkIsAncestor(childGraphModuleVO, subGraphModuleVO)) {
                    subGraphModuleVOMap.put(childGraphModuleVO.getModuleId(), subGraphModuleVO);
                    if (!StringUtils.isBlank(childGraphModuleVO.getPackageFullPath())) {
                        subGraphModuleVOMap.put(childGraphModuleVO.getPackageFullPath(), subGraphModuleVO);
                    }
                }
            }
        }
        graphModuleVO.setInnerModuleRelaVOList(getInnerModuleRelaList(graphModuleVO, subGraphModuleVOMap));
        // 3. 获取实体列表
        List<EntityVO> entityVOList;
        if (graphModuleVO.getModuleType() == 2) {// 应用下才有可能存在实体
            entityVOList = entityFacade.queryEntityList(graphModuleVO.getModuleId());
        } else {
            entityVOList = Collections.emptyList();
        }
        graphModuleVO.setEntityVOList(entityVOList);
        
        // 4. 实体关联关系列表
        graphModuleVO.setEntityRelationshipVOList(getEntityRelationshipVOList(entityVOList));
        
    }
    
    /**
     * 实体关系集合
     *
     * @param entityVOList 实体VO集合
     * @return 实体关系集合
     */
    private List<EntityRelationshipVO> getEntityRelationshipVOList(List<EntityVO> entityVOList) {
        List<EntityRelationshipVO> result = new ArrayList<EntityRelationshipVO>();
        Map<String, EntityVO> entityVOMap = new HashMap<String, EntityVO>();
        for (Iterator<EntityVO> iterator = entityVOList.iterator(); iterator.hasNext();) {
            EntityVO entityVO = iterator.next();
            entityVOMap.put(entityVO.getModelId(), entityVO);
        }
        
        for (Iterator<EntityVO> iterator = entityVOList.iterator(); iterator.hasNext();) {
            EntityVO entityVO = iterator.next();
            List<EntityRelationshipVO> entityRelationshipVOList = entityVO.getLstRelation();
            if (entityRelationshipVOList == null) {
                continue;
            }
            for (Iterator<EntityRelationshipVO> iterator2 = entityRelationshipVOList.iterator(); iterator2.hasNext();) {
                EntityRelationshipVO entityRelationshipVO = iterator2.next();
                if (entityVOMap.get(entityRelationshipVO.getSourceEntityId()) != null
                    && entityVOMap.get(entityRelationshipVO.getTargetEntityId()) != null) {
                    result.add(entityRelationshipVO);
                }
            }
        }
        return result;
    }
    
    /**
     * 获取内部模块依赖关系列表
     *
     * @param graphModuleVO 模块VO
     * @param subGraphModuleVOMap 所有子节点集合
     * @return 模块依赖关系列表
     */
    private List<GraphModuleRelaVO> getInnerModuleRelaList(GraphModuleVO graphModuleVO,
        Map<String, GraphModuleVO> subGraphModuleVOMap) {
        List<GraphModuleRelaVO> lstInnerGraphModuleRelaVOs = new ArrayList<GraphModuleRelaVO>();
        List<EntityRelationshipVO> allEntityRelationshipVOList = (List<EntityRelationshipVO>) observable.getGraphMap()
            .get("allEntityRelationshipVOList");
        
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
            // targetGraphModuleVO找不到目标说明类在外部
            // sourceGraphModuleVO找不到 当前应用为根节点
            if (sourceGraphModuleVO == null || targetGraphModuleVO == null) {
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
        GraphModuleUtils.removeDuplicate(lstInnerGraphModuleRelaVOs);
        return lstInnerGraphModuleRelaVOs;
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
