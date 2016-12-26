/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cip.graph.entity.util;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import com.comtop.cap.bm.metadata.base.model.BaseModel;
import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.entity.model.DataTypeVO;
import com.comtop.cap.bm.metadata.entity.model.EntityRelationshipVO;
import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cap.bm.metadata.page.desinger.model.DataStoreVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageActionVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageConstantVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.cip.graph.entity.facade.GraphModuleFacadeImpl;
import com.comtop.cip.graph.entity.model.GraphModuleVO;

/**
 * 模块关系工具类
 *
 * @author 刘城
 * @since jdk1.6
 * @version 2016年12月1日 刘城
 */
public class GraphModuleUtils {
    
    /** 实体关联关系查询表达式 */
    public static final String ENTITY_REALATION = "./lstRelation";
    
    /** 实体属性关联其他实体类型查询表达式 */
    public static final String ENTITY_ATTRTYPE = "./attributes/attributeType[source='otherEntityAttibute']";
    
    /** 实体属性泛型关联其他实体类型查询表达式 */
    public static final String ENTITY_ATTR_GENERICTYPE = "./attributes/attributeType//generic[source='entity']";
    
    /** 实体方法返回类型查询表达式 */
    public static final String ENTITY_RETURNTYPE = "./methods/returnType[source='entity']";
    
    /** 实体方法返回类型泛型查询表达式 */
    public static final String ENTITY_RETURN_GENERICTYPE = "./methods/returnType//generic[source='entity']";
    
    /** 实体方法参数类型查询表达式 */
    public static final String ENTITY_METHOD_PARAMTYPE = "./methods/parameters[source='entity']";
    
    /** 实体方法参数泛型类型查询表达式 */
    public static final String ENTITY_METHOD_PARAM_GENERICTYPE = "./methods/parameters//generic[source='entity']";
    
    /** 页面行为关联实体查询表达式 */
    public static final String PAGE_ACTION_ENTITYTYPE = "./pageActionVOList[methodOption[entityId!=null or entityId!='']]";
    
    /** 页面数据集关联实体查询表达式 */
    public static final String PAGE_DATASTORE_ENTITYTYPE = "./dataStoreVOList[entityId!='']";
    
    /** 页面URL关联其他页面查询表达式 */
    public static final String PAGE_URL2PAGETYPE = "./dataStoreVOList[ename='pageConstantList']/pageConstantList[constantType='url']";
    
    /** 日志 */
    private final static Logger LOGGER = LoggerFactory.getLogger(GraphModuleFacadeImpl.class);
    
    /**
     * 返回页面--》页面元素URL建立的实体映射关系
     * 
     * @param <T> xxx
     * 
     * @param obj 元数据对象
     * @param expression 查询表达式
     * @param lstEntityRelationshipVO4Others 关联关系
     * @throws OperateException 元数据查询异常
     */
    public static <T extends BaseMetadata> void getEntityRelationship2(BaseModel obj, final String expression,
        List<EntityRelationshipVO> lstEntityRelationshipVO4Others) throws OperateException {
        List<T> lstReturnDataTypeVOs = obj.queryList(expression);
        for (T objVO : lstReturnDataTypeVOs) {
            EntityRelationshipVO objRelationshipVO = new EntityRelationshipVO();
            objRelationshipVO.setSourceEntityId(obj.getModelId());
            String pageModelId = ((DataTypeVO) objVO).getValue();
            objRelationshipVO.setTargetEntityId(pageModelId);
            lstEntityRelationshipVO4Others.add(objRelationshipVO);
        }
        
    }
    
    /**
     * 返回页面--》行为建立的映射关系
     * 
     * @param objPageVO 实体
     * @param lstEntityRelationshipVO4Others 关联关系
     * @throws OperateException 元数据查询异常
     */
    public static void getEntityRelationshipByPage2Actions(PageVO objPageVO,
        List<EntityRelationshipVO> lstEntityRelationshipVO4Others) throws OperateException {
        // 页面--》实体
        List<PageActionVO> lstPageActionVOVOs = objPageVO.queryList(PAGE_ACTION_ENTITYTYPE);
        for (PageActionVO objPageActionVO : lstPageActionVOVOs) {
            EntityRelationshipVO objRelationshipVO = new EntityRelationshipVO();
            objRelationshipVO.setSourceEntityId(objPageVO.getModelId());
            objRelationshipVO.setTargetEntityId((String) objPageActionVO.getMethodOption().get("entityId"));
            lstEntityRelationshipVO4Others.add(objRelationshipVO);
            LOGGER.debug("找到页面--》数据集关联Source：" + objPageVO.getModelId() + "  2  "
                + (String) objPageActionVO.getMethodOption().get("entityId"));
        }
        //
    }
    
    /**
     * 返回页面--》数据集建立的映射关系
     * 
     * @param objPageVO 实体
     * @param lstEntityRelationshipVO4Others 关联关系
     * @throws OperateException 元数据查询异常
     */
    public static void getEntityRelationshipByPage2Entitys(PageVO objPageVO,
        List<EntityRelationshipVO> lstEntityRelationshipVO4Others) throws OperateException {
        List<DataStoreVO> lstDataStoreVOs = objPageVO.queryList(PAGE_DATASTORE_ENTITYTYPE);
        for (DataStoreVO objPageDataStoreVO : lstDataStoreVOs) {
            EntityRelationshipVO objRelationshipVO = new EntityRelationshipVO();
            objRelationshipVO.setSourceEntityId(objPageVO.getModelId());
            objRelationshipVO.setTargetEntityId(objPageDataStoreVO.getEntityId());
            lstEntityRelationshipVO4Others.add(objRelationshipVO);
            LOGGER.debug("找到页面-->数据集关联Source：" + objPageVO.getModelId() + "  2  " + objPageDataStoreVO.getEntityId());
        }
    }
    
    /**
     * 返回页面--》页面元素URL建立的实体映射关系
     * 
     * @param objPageVO 实体
     * @param lstEntityRelationshipVO4Others 关联关系
     * @throws OperateException 元数据查询异常
     */
    public static void getEntityRelationshipByPageUrls(PageVO objPageVO,
        List<EntityRelationshipVO> lstEntityRelationshipVO4Others) throws OperateException {
        List<PageConstantVO> lstReturnDataTypeVOs = objPageVO.queryList(PAGE_URL2PAGETYPE);
        for (PageConstantVO objPageConstantVO : lstReturnDataTypeVOs) {
            EntityRelationshipVO objRelationshipVO = new EntityRelationshipVO();
            objRelationshipVO.setSourceEntityId(objPageVO.getModelId());
            String pageModelId = (String) objPageConstantVO.getConstantOption().get("pageModelId");
            // pageModelId com.comtop.storemsg.page.ReceiptNoticeEditPageForWorkFlow
            // 这里直接将pageModelId设入 后面统一处理
            objRelationshipVO.setTargetEntityId(pageModelId);
            lstEntityRelationshipVO4Others.add(objRelationshipVO);
            LOGGER.debug("找到页面--》页面元素URL关联Source：" + objPageVO.getModelId() + "  2  " + pageModelId);
        }
    }
    
    /**
     * 返回实体方法返回参数、泛型建立的实体映射关系
     * 
     * @param objEntityVO 实体
     * @param lstEntityRelationshipVO4Others 关联关系
     * @throws OperateException 元数据查询异常
     */
    public static void getEntityRelationshipByEntityMethods(EntityVO objEntityVO,
        List<EntityRelationshipVO> lstEntityRelationshipVO4Others) throws OperateException {
        // 查询返回值参数类型
        List<DataTypeVO> lstReturnDataTypeVOs = objEntityVO.queryList(ENTITY_RETURNTYPE);
        for (DataTypeVO objReturnDataTypeVO : lstReturnDataTypeVOs) {
            EntityRelationshipVO objRelationshipVO = new EntityRelationshipVO();
            objRelationshipVO.setSourceEntityId(objEntityVO.getModelId());
            objRelationshipVO.setTargetEntityId(objReturnDataTypeVO.getValue());
            lstEntityRelationshipVO4Others.add(objRelationshipVO);
            LOGGER.debug("找到返回值参数关联Source：" + objEntityVO.getModelId() + "  2  " + objReturnDataTypeVO.getValue());
        }
        // 查询返回值参数反省
        List<DataTypeVO> lstReturnGenericDataTypeVOs = objEntityVO.queryList(ENTITY_RETURN_GENERICTYPE);
        for (DataTypeVO objReturnGenericDataTypeVO : lstReturnGenericDataTypeVOs) {
            EntityRelationshipVO objRelationshipVO = new EntityRelationshipVO();
            objRelationshipVO.setSourceEntityId(objEntityVO.getModelId());
            objRelationshipVO.setTargetEntityId(objReturnGenericDataTypeVO.getValue());
            lstEntityRelationshipVO4Others.add(objRelationshipVO);
            LOGGER.debug("找到返回值参数泛型关联Source：" + objEntityVO.getModelId() + "  2  "
                + objReturnGenericDataTypeVO.getValue());
        }
        // 查询参数类型
        List<DataTypeVO> lstMethodDataTypeVOs = objEntityVO.queryList(ENTITY_METHOD_PARAMTYPE);
        for (DataTypeVO objMethodeDataTypeVO : lstMethodDataTypeVOs) {
            EntityRelationshipVO objRelationshipVO = new EntityRelationshipVO();
            objRelationshipVO.setSourceEntityId(objEntityVO.getModelId());
            objRelationshipVO.setTargetEntityId(objMethodeDataTypeVO.getValue());
            lstEntityRelationshipVO4Others.add(objRelationshipVO);
            LOGGER.debug("找到参数关联Source：" + objEntityVO.getModelId() + "  2  " + objMethodeDataTypeVO.getValue());
        }
        // 查询参数泛型类型
        List<DataTypeVO> lstMethodGenericDataTypeVOs = objEntityVO.queryList(ENTITY_METHOD_PARAM_GENERICTYPE);
        for (DataTypeVO objMethodeGenericDataTypeVO : lstMethodGenericDataTypeVOs) {
            EntityRelationshipVO objRelationshipVO = new EntityRelationshipVO();
            objRelationshipVO.setSourceEntityId(objEntityVO.getModelId());
            objRelationshipVO.setTargetEntityId(objMethodeGenericDataTypeVO.getValue());
            lstEntityRelationshipVO4Others.add(objRelationshipVO);
            LOGGER.debug("找到参数泛型关联Source：" + objEntityVO.getModelId() + "  2  "
                + objMethodeGenericDataTypeVO.getValue());
        }
    }
    
    /**
     * 返回实体映射关系
     * 
     * @param objEntityVO 实体
     * @param lstEntityRelationshipVO4Others 关联关系
     * @throws OperateException 元数据查询异常
     */
    public static void getEntityRelationship(EntityVO objEntityVO,
        List<EntityRelationshipVO> lstEntityRelationshipVO4Others) throws OperateException {
        // 查询实体属性关联其他实体类型
        List<EntityRelationshipVO> lstDataTypeVOs = objEntityVO.queryList(ENTITY_REALATION);
        lstEntityRelationshipVO4Others.addAll(lstDataTypeVOs);
    }
    
    /**
     * 返回实体属性依赖建立的实体映射关系
     * 
     * @param objEntityVO 实体
     * @param lstEntityRelationshipVO4Others 关联关系
     * @throws OperateException 元数据查询异常
     */
    public static void getEntityRelationshipByEntityAttr(EntityVO objEntityVO,
        List<EntityRelationshipVO> lstEntityRelationshipVO4Others) throws OperateException {
        // 查询实体属性关联其他实体类型
        List<DataTypeVO> lstDataTypeVOs = objEntityVO.queryList(ENTITY_ATTRTYPE);
        for (DataTypeVO objDataTypeVO : lstDataTypeVOs) {
            EntityRelationshipVO objEntityRelationshipVO = new EntityRelationshipVO();
            objEntityRelationshipVO.setSourceEntityId(objEntityVO.getModelId());
            objEntityRelationshipVO.setTargetEntityId(objDataTypeVO.getValue());
            lstEntityRelationshipVO4Others.add(objEntityRelationshipVO);
            LOGGER.debug("找到实体属性关联Source：" + objEntityVO.getModelId() + "  2  " + objDataTypeVO.getValue());
        }
        // 查询实体属性泛型
        List<DataTypeVO> lstGenericDataTypeVOs = objEntityVO.queryList(ENTITY_ATTR_GENERICTYPE);
        for (DataTypeVO objGenericDataTypeVO : lstGenericDataTypeVOs) {
            EntityRelationshipVO objGenericEntityRelationshipVO = new EntityRelationshipVO();
            objGenericEntityRelationshipVO.setSourceEntityId(objEntityVO.getModelId());
            objGenericEntityRelationshipVO.setTargetEntityId(objGenericDataTypeVO.getValue());
            lstEntityRelationshipVO4Others.add(objGenericEntityRelationshipVO);
            LOGGER.debug("找到实体属性泛型关联Source：" + objEntityVO.getModelId() + "  2  " + objGenericDataTypeVO.getValue());
        }
    }
    
    /**
     * 把其他的映射关系 也封装成实体映射关系 到最后一起处理
     * 获取被依赖的模块关系列表 此方法必须放在递归里执行
     * 
     * @param graphModuleVO 模块VO
     * @return 模块依赖外部模块关系列表
     */
    public static List<EntityRelationshipVO> getEntityRelationshipVO4Others(GraphModuleVO graphModuleVO) {
        List<EntityRelationshipVO> lstEntityRelationshipVO4Others = new ArrayList<EntityRelationshipVO>();
        try {
            String packagePath = graphModuleVO.getPackageFullPath();
            if (packagePath == null || "".equals(packagePath)) {
                return lstEntityRelationshipVO4Others;
            }
            List<EntityVO> lstEntityVOs = CacheOperator.queryList("entity[@modelPackage='" + packagePath + "']",
                EntityVO.class);
            for (EntityVO objEntityVO : lstEntityVOs) {
                // 处理继承关系
                String strSourceEntityId = objEntityVO.getModelId();
                String strParentEntityId = objEntityVO.getParentEntityId();
                if (!StringUtils.isBlank(strParentEntityId)) {
                    lstEntityRelationshipVO4Others.add(getEntityRelationshipVO(strSourceEntityId, strParentEntityId));
                    LOGGER
                        .debug("找到继承关联Source：" + objEntityVO.getModelId() + "  2  " + objEntityVO.getParentEntityId());
                }
                // 处理实体属性依赖
                GraphModuleUtils.getEntityRelationship(objEntityVO, lstEntityRelationshipVO4Others);
                
                GraphModuleUtils.getEntityRelationshipByEntityAttr(objEntityVO, lstEntityRelationshipVO4Others);
                
                GraphModuleUtils.getEntityRelationshipByEntityMethods(objEntityVO, lstEntityRelationshipVO4Others);
                
            }
            
            List<PageVO> lstPageVOs = CacheOperator
                .queryList("page[@modelPackage='" + packagePath + "']", PageVO.class);
            for (PageVO objPageVO : lstPageVOs) {
                // 处理页面-->页面元素url
                GraphModuleUtils.getEntityRelationshipByPageUrls(objPageVO, lstEntityRelationshipVO4Others);
                
                // 页面-->实体
                GraphModuleUtils.getEntityRelationshipByPage2Entitys(objPageVO, lstEntityRelationshipVO4Others);
                
                // 页面-->行为
                GraphModuleUtils.getEntityRelationshipByPage2Actions(objPageVO, lstEntityRelationshipVO4Others);
                
            }
            
        } catch (OperateException e) {
            LOGGER.error("元数据查询异常", e);
        }
        return lstEntityRelationshipVO4Others;
    }
    
    /**
     * 获取所有引用了实体ID的页面行为元数据
     * 
     * @param entityId 实体ID
     * @return 页面VO集合
     * @throws OperateException 操作异常
     */
    public static List<PageVO> queryPageActionListByEntityId(String entityId) throws OperateException {
        List<PageVO> lstPageVO = CacheOperator.queryList("page[pageActionVOList[methodOption[entityId='" + entityId
            + "']]]", PageVO.class);
        return lstPageVO;
    }
    
    /**
     * 创建实体关联关系
     * 
     * @param sourceEntityId 源实体ID
     * @param targetEntityId 目标实体ID
     * @return 实体关联关系
     */
    private static EntityRelationshipVO getEntityRelationshipVO(String sourceEntityId, String targetEntityId) {
        EntityRelationshipVO objEntityRelationshipVO = new EntityRelationshipVO();
        objEntityRelationshipVO.setSourceEntityId(sourceEntityId);
        objEntityRelationshipVO.setTargetEntityId(targetEntityId);
        return objEntityRelationshipVO;
    }
    
    /**
     * list去重
     * 
     * @param list list
     */
    public static void removeDuplicate(List list) {
        HashSet h = new HashSet(list);
        list.clear();
        list.addAll(h);
    }
    
    /**
     * 根据当前节点moduleId获取所有其所有子孙节点
     * 
     * @param lstGraphModuleVOs graph树
     * @param graphModuleVO 当前节点的moduleId
     * @return 当前节点的所有子孙节点集合
     */
    public static List<GraphModuleVO> getAllChildGraphModuleVOs(List<GraphModuleVO> lstGraphModuleVOs,
        GraphModuleVO graphModuleVO) {
        List<GraphModuleVO> allChildGraphModuleVOs = new ArrayList<GraphModuleVO>();
        for (GraphModuleVO objGraphModuleVO : lstGraphModuleVOs) {
            if (checkIsAncestor(objGraphModuleVO, graphModuleVO)) {
                allChildGraphModuleVOs.add(objGraphModuleVO);
            }
        }
        return allChildGraphModuleVOs;
    }
    
    /**
     * 判断childGraphModuleVO是否是节点的子孙节点
     * 
     * @param childGraphModuleVO 子孙节点
     * @param subGraphModuleVO 节点
     * 
     * @return list
     */
    private static boolean checkIsAncestor(GraphModuleVO childGraphModuleVO, GraphModuleVO subGraphModuleVO) {
        String strChildIdFullPath = childGraphModuleVO.getModuleIdFullPath();
        String strSubIdFullPath = subGraphModuleVO.getModuleIdFullPath();
        return strChildIdFullPath.contains(strSubIdFullPath);
    }
    
    /**
     * 根据当前节点moduleId获取所有其子节点
     * 
     * @param lstGraphModuleVOs graph树
     * @param graphModuleVO 当前节点的moduleId
     * @return 当前节点的所有子孙节点集合
     */
    public static List<GraphModuleVO> getsubChildGraphModuleVOs(List<GraphModuleVO> lstGraphModuleVOs,
        GraphModuleVO graphModuleVO) {
        List<GraphModuleVO> childGraphModuleVOs = new ArrayList<GraphModuleVO>();
        for (GraphModuleVO objGraphModuleVO : lstGraphModuleVOs) {
            if (objGraphModuleVO.getParentModuleId().equals(graphModuleVO.getModuleId())) {
                childGraphModuleVOs.add(objGraphModuleVO);
            }
        }
        return childGraphModuleVOs;
    }
}
