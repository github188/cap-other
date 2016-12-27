/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.bm.biz.domain.appservice.BizDomainAppService;
import com.comtop.cap.bm.biz.domain.model.BizDomainVO;
import com.comtop.cap.bm.biz.form.appservice.BizFormAppService;
import com.comtop.cap.bm.biz.form.model.BizFormDataVO;
import com.comtop.cap.bm.biz.form.model.BizFormVO;
import com.comtop.cap.bm.biz.info.appservice.BizObjDataItemAppService;
import com.comtop.cap.bm.biz.info.appservice.BizObjInfoAppService;
import com.comtop.cap.bm.biz.info.model.BizObjDataItemVO;
import com.comtop.cap.bm.biz.info.model.BizObjInfoVO;
import com.comtop.cap.bm.biz.items.appservice.BizItemsAppService;
import com.comtop.cap.bm.biz.items.model.BizItemsVO;
import com.comtop.cap.bm.biz.role.appservice.BizRoleAppService;
import com.comtop.cap.bm.biz.role.model.BizRoleVO;
import com.comtop.cap.bm.common.BizLevel;
import com.comtop.cap.bm.req.func.appservice.ReqFunctionItemAppService;
import com.comtop.cap.bm.req.func.model.ReqFunctionItemVO;
import com.comtop.cap.bm.req.subfunc.appservice.ReqFunctionSubitemAppService;
import com.comtop.cap.bm.req.subfunc.appservice.ReqFunctionUsecaseAppService;
import com.comtop.cap.bm.req.subfunc.appservice.ReqSubitemDutyAppService;
import com.comtop.cap.bm.req.subfunc.model.ReqFunctionSubitemVO;
import com.comtop.cap.bm.req.subfunc.model.ReqFunctionUsecaseVO;
import com.comtop.cap.bm.req.subfunc.model.ReqSubitemDutyVO;
import com.comtop.cap.doc.biz.appservice.BizProcessNodeDocAppservice;
import com.comtop.cap.doc.biz.model.DataItemDTO;
import com.comtop.cap.document.word.docconfig.model.DocConfig;
import com.comtop.cap.document.word.docmodel.data.WordDocument;
import com.comtop.cap.runtime.core.AppBeanUtil;

/**
 * 公共数据管理器 ，用于缓存已经存在的都需要使用的公共数据，便于提高性能
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年12月12日 lizhiyong
 */
public class CommonDataManager {
    
    /** 分隔符 */
    private static final String SPLITER = "-";
    
    /** 业务对象集 */
    private static final Map<String, Map<String, BizObjInfoVO>> BIZ_OBJECT_MAP = new HashMap<String, Map<String, BizObjInfoVO>>();
    
    /** 业务对象集 */
    private static final Map<String, BizObjInfoVO> BIZ_OBJECT_SIMPLEMAP = new HashMap<String, BizObjInfoVO>();
    
    /** 业务域 */
    private static final Map<String, BizDomainVO> BIZ_DOMAIN_MAP = new HashMap<String, BizDomainVO>();
    
    /** 业务事项 */
    private static final Map<String, BizItemsVO> BIZ_ITEM_MAP = new HashMap<String, BizItemsVO>();
    
    /** 业务对象集 */
    private static final Map<String, Map<String, BizRoleVO>> BIZ_ROLE_MAP = new HashMap<String, Map<String, BizRoleVO>>();
    
    /** 节点组id映射关系 */
    private static final Map<String, String> ID_MAPPING = new HashMap<String, String>();
    
    /** 业务表单集 */
    private static final Map<String, Map<String, BizFormVO>> BIZ_FORM_MAP = new HashMap<String, Map<String, BizFormVO>>();
    
    /** 业务对象集 */
    private static final Map<String, BizFormVO> BIZ_FORM_SIMPLEMAP = new HashMap<String, BizFormVO>();
    
    /** 业务表单集 */
    private static final Map<String, Map<String, BizObjDataItemVO>> BIZ_OBJ_DATAITEM_MAP = new HashMap<String, Map<String, BizObjDataItemVO>>();
    
    /** 业务表单数据项集 */
    private static final Map<String, Map<String, BizFormDataVO>> BIZ_FORM_DATAITEM_MAP = new HashMap<String, Map<String, BizFormDataVO>>();
    
    /** 业务能项集 */
    private static final Map<String, Map<String, ReqFunctionItemVO>> BIZ_REQ_FUNITEM_MAP = new HashMap<String, Map<String, ReqFunctionItemVO>>();
    
    /** 业务能子项集 */
    private static final Map<String, Map<String, ReqFunctionSubitemVO>> BIZ_REQ_FUNSUBITEM_MAP = new HashMap<String, Map<String, ReqFunctionSubitemVO>>();
    
    /** 业务能子项集和业务对象映射的临时数据集 */
    private static final Map<String, ReqFunctionSubitemVO> BIZ_REQ_FUNSUBITEM_TEMP = new HashMap<String, ReqFunctionSubitemVO>();
    
    /** 业务能子项集id映射 */
    private static final Map<String, ReqFunctionUsecaseVO> BIZ_REQ_USECASE_MAP = new HashMap<String, ReqFunctionUsecaseVO>();
    
    /** 业务能子和角色关系映射 */
    private static final Map<String, ReqSubitemDutyVO> BIZ_REQ_SUBITEMDUTY_MAP = new HashMap<String, ReqSubitemDutyVO>();
    
    /** 当前处理的文档 */
    private static final ThreadLocal<WordDocument> WORD_DOCUMENT_THREAD_LOCAL = new ThreadLocal<WordDocument>();
    
    /** 当前使用的数据索引管理器 */
    private static final ThreadLocal<DataIndexManager> DATA_INDEX_MANAGER_THREAD_LOCAL = new ThreadLocal<DataIndexManager>();
    
    /** 当前处理的模板 */
    private static final ThreadLocal<DocConfig> DOC_CONFIG_THREAD_LOCAL = new ThreadLocal<DocConfig>();
    
    /** 业务级别缓存 */
    private static final List<String> BIZ_LEVELS = new ArrayList<String>();
    
    /** 流程节点组缓存 */
    private static final Map<String, String> PROCESS_NODE_GROUP_MAP = new HashMap<String, String>();
    
    /**
     * 构造函数
     */
    private CommonDataManager() {
        //
    }
    
    /**
     * 根据节点id获得组id
     *
     * @param nodeId 节点 id
     * @return groupId 未找到返回null
     */
    public static String getGroupIdByNodeId(String nodeId) {
        if (PROCESS_NODE_GROUP_MAP.containsKey("InitFinished")) {
            return PROCESS_NODE_GROUP_MAP.get(nodeId);
        }
        String packageId = getCurrentWordDocument().getDomainId();
        Map<String, String> groupMap = AppBeanUtil.getBean(BizProcessNodeDocAppservice.class).queryNodeGroupMap(
            packageId);
        PROCESS_NODE_GROUP_MAP.put("InitFinished", "InitFinished");
        PROCESS_NODE_GROUP_MAP.putAll(groupMap);
        return PROCESS_NODE_GROUP_MAP.get(nodeId);
    }
    
    /**
     * 添加一个新的节点id与组id的映射
     *
     * @param nodeId 节点id
     * @param groupId groupid
     */
    public static void addGroupMapping(String nodeId, String groupId) {
        PROCESS_NODE_GROUP_MAP.put(nodeId, groupId);
    }
    
    /**
     * 获得缓存中的业务域
     *
     * @param itemId 业务域id
     * @return 业务域对象
     */
    public static BizItemsVO getBizItemsVO(String itemId) {
        BizItemsVO bizItemsVO = BIZ_ITEM_MAP.get(itemId);
        if (bizItemsVO != null) {
            return bizItemsVO;
        }
        BizItemsAppService service = AppBeanUtil.getBean(BizItemsAppService.class);
        
        bizItemsVO = service.queryBizItemsById(itemId);
        if (bizItemsVO != null) {
            BIZ_ITEM_MAP.put(itemId, bizItemsVO);
        }
        return bizItemsVO;
    }
    
    /**
     * 获得缓存中的业务域
     *
     * @param domainId 业务域id
     * @return 业务域对象
     */
    public static BizDomainVO getBizDomainVO(String domainId) {
        BizDomainVO bizDomainVO = BIZ_DOMAIN_MAP.get(domainId);
        if (bizDomainVO != null) {
            return bizDomainVO;
        }
        BizDomainAppService bizDomainAppService = AppBeanUtil.getBean(BizDomainAppService.class);
        if (BIZ_DOMAIN_MAP.size() == 0) {
            List<BizDomainVO> alBizDomain = bizDomainAppService.queryDomainList(null);
            for (BizDomainVO bizDomainVO2 : alBizDomain) {
                BIZ_DOMAIN_MAP.put(bizDomainVO2.getId(), bizDomainVO2);
            }
            return BIZ_DOMAIN_MAP.get(domainId);
        }
        bizDomainVO = bizDomainAppService.queryDomainById(domainId);
        if (bizDomainVO != null) {
            BIZ_DOMAIN_MAP.put(domainId, bizDomainVO);
        }
        return bizDomainVO;
    }
    
    /**
     * 添加映射关系
     *
     * @param dataIndexManager 数据索引管理器
     */
    public static void setCurrentDataIndexManager(DataIndexManager dataIndexManager) {
        DATA_INDEX_MANAGER_THREAD_LOCAL.set(dataIndexManager);
    }
    
    /**
     * 移除数据索引管理器
     *
     */
    public static void removeCurrentDataIndexManager() {
        DATA_INDEX_MANAGER_THREAD_LOCAL.remove();
    }
    
    /**
     * 获得数据索引管理器
     *
     * @return 数据索引管理器
     */
    public static DataIndexManager getCurrentDataIndexManager() {
        return DATA_INDEX_MANAGER_THREAD_LOCAL.get();
    }
    
    /**
     * 添加映射关系
     *
     * @param wordDocument 文档对象
     */
    public static void setCurrentWordDocument(WordDocument wordDocument) {
        WORD_DOCUMENT_THREAD_LOCAL.set(wordDocument);
    }
    
    /**
     * 移除文档对象
     *
     */
    public static void removeCurrentWordDocument() {
        WORD_DOCUMENT_THREAD_LOCAL.remove();
    }
    
    /**
     * 获得文档对象
     *
     * @return 文档对象
     */
    public static WordDocument getCurrentWordDocument() {
        return WORD_DOCUMENT_THREAD_LOCAL.get();
    }
    
    /**
     * 添加映射关系
     *
     * @param docConfig 文档对象
     */
    public static void setDocConfig(DocConfig docConfig) {
        DOC_CONFIG_THREAD_LOCAL.set(docConfig);
    }
    
    /**
     * 移除文档对象
     *
     */
    public static void removeDocConfig() {
        DOC_CONFIG_THREAD_LOCAL.remove();
    }
    
    /**
     * 获得文档对象
     *
     * @return 文档对象
     */
    public static DocConfig getCurrentDocConfig() {
        return DOC_CONFIG_THREAD_LOCAL.get();
    }
    
    /**
     * 添加映射关系
     *
     * @param sourceId 内存中创建的id值
     * @param mappingId 持久化的Id值
     */
    public static void addIdMapping(String sourceId, String mappingId) {
        ID_MAPPING.put(sourceId, mappingId);
    }
    
    /**
     * 获得内存中的sourceGroupId对应的持久化的groupId
     *
     * @param sourceId 源group 内存中创建的id值
     * @return 对应id 持久化的id值
     */
    public static String getMappingId(String sourceId) {
        return ID_MAPPING.get(sourceId);
    }
    
    //
    /**
     * 获得业务对象
     *
     * @param dataItem 数据项DTO
     * @return 没有找到返回空
     */
    public static BizObjDataItemVO getBizObjDataItem(DataItemDTO dataItem) {
        return getBizObjDataItem(dataItem.getDomainId(), dataItem.getObjectId(), StringUtils.trim(dataItem.getName()));
    }
    
    /**
     * 获得业务对象
     *
     * @param domainId 业务域id
     * @param objectId 对象id
     * @param name 业务对象名称
     * @return 没有找到返回空
     */
    public static BizObjDataItemVO getBizObjDataItem(String domainId, String objectId, String name) {
        Map<String, BizObjDataItemVO> map = BIZ_OBJ_DATAITEM_MAP.get(domainId);
        String key = domainId + SPLITER + objectId + SPLITER + StringUtils.trim(name);
        if (map != null && !map.isEmpty()) {
            return map.get(key);
        }
        BizObjDataItemAppService querySerivce = AppBeanUtil.getBean(BizObjDataItemAppService.class);
        BizObjDataItemVO condition = new BizObjDataItemVO();
        condition.setDomainId(domainId);
        List<BizObjDataItemVO> dataList = querySerivce.loadList(condition);
        Map<String, BizObjDataItemVO> dataMap = new HashMap<String, BizObjDataItemVO>();
        BIZ_OBJ_DATAITEM_MAP.put(domainId, dataMap);
        for (BizObjDataItemVO data : dataList) {
            dataMap.put(getBizObjDataItemKey(data), data);
        }
        return dataMap.get(key);
    }
    
    /**
     * 添加一个业务对象
     *
     * @param bizObjDataItemVO 业务对象
     * @return 新对象的id
     */
    public static String addBizObjDataItem(BizObjDataItemVO bizObjDataItemVO) {
        Map<String, BizObjDataItemVO> map = BIZ_OBJ_DATAITEM_MAP.get(bizObjDataItemVO.getDomainId());
        if (map == null) {
            map = new HashMap<String, BizObjDataItemVO>();
        }
        String key = getBizObjDataItemKey(bizObjDataItemVO);
        map.put(key, bizObjDataItemVO);
        return bizObjDataItemVO.getId();
    }
    
    /**
     * 添加一个业务对象
     *
     * @param bizObjInfoVO 业务对象
     * @return 对象id
     */
    public static String addBizObjInfo(BizObjInfoVO bizObjInfoVO) {
        String simpleKey = bizObjInfoVO.getDomainId() + SPLITER + StringUtils.trim(bizObjInfoVO.getName());
        BIZ_OBJECT_SIMPLEMAP.put(simpleKey, bizObjInfoVO);
        return bizObjInfoVO.getId();
    }
    
    /**
     * 获得业务对象
     *
     * @param domainId 业务域id
     * @param bizLevel 业务层级
     * @param name 业务对象名称
     * @return 没有找到返回空
     */
    public static BizRoleVO getBizRole(String domainId, String bizLevel, String name) {
        Map<String, BizRoleVO> map = BIZ_ROLE_MAP.get(domainId);
        String key = domainId + SPLITER + bizLevel + SPLITER + StringUtils.trim(name);
        if (map != null && !map.isEmpty()) {
            return map.get(key);
        }
        
        BizRoleAppService bizRoleAppService = AppBeanUtil.getBean(BizRoleAppService.class);
        BizRoleVO condition = new BizRoleVO();
        condition.setDomainId(domainId);
        List<BizRoleVO> dataList = bizRoleAppService.loadList(condition);
        Map<String, BizRoleVO> dataMap = new HashMap<String, BizRoleVO>();
        BIZ_ROLE_MAP.put(domainId, dataMap);
        for (BizRoleVO bizRoleVO : dataList) {
            dataMap.put(getBizRoleKey(bizRoleVO), bizRoleVO);
        }
        return dataMap.get(key);
    }
    
    /**
     * 添加一个业务对象
     *
     * @param bizRoleVO 业务角色
     * @return 角色id
     */
    public static String addBizRole(BizRoleVO bizRoleVO) {
        Map<String, BizRoleVO> map = BIZ_ROLE_MAP.get(bizRoleVO.getDomainId());
        if (map == null) {
            map = new HashMap<String, BizRoleVO>();
        }
        String key = getBizRoleKey(bizRoleVO);
        map.put(key, bizRoleVO);
        return bizRoleVO.getId();
    }
    
    /**
     * 获得业务表单
     *
     * @param domainId 业务域id
     * @param name 业务对象名称
     * @return 没有找到返回空
     */
    public static BizFormVO getBizForm(String domainId, String name) {
        String key = domainId + SPLITER + StringUtils.trim(name);
        BizFormVO form = BIZ_FORM_SIMPLEMAP.get(key);
        if (form == null) {
            BizFormAppService bizFormAppService = AppBeanUtil.getBean(BizFormAppService.class);
            BizFormVO condition = new BizFormVO();
            condition.setDomainId(domainId);
            List<BizFormVO> datas = bizFormAppService.loadList(condition);
            for (BizFormVO bizForm : datas) {
                BIZ_FORM_SIMPLEMAP.put(domainId + SPLITER + StringUtils.trim(bizForm.getName()), bizForm);
            }
        }
        return BIZ_FORM_SIMPLEMAP.get(key);
    }
    
    /**
     * 获得业务对象数据项的Key
     *
     * @param bizObjDataItemVO 对象
     * @return key
     */
    public static String getBizObjDataItemKey(BizObjDataItemVO bizObjDataItemVO) {
        return bizObjDataItemVO.getDomainId() + SPLITER + bizObjDataItemVO.getBizObjId() + SPLITER
            + StringUtils.trim(bizObjDataItemVO.getName());
    }
    
    /**
     * 获得业务对象在的Key
     *
     * @param bizRoleVO 对象
     * @return key
     */
    public static String getBizRoleKey(BizRoleVO bizRoleVO) {
        return bizRoleVO.getDomainId() + SPLITER + bizRoleVO.getBizLevel() + SPLITER
            + StringUtils.trim(bizRoleVO.getRoleName());
    }
    
    /**
     * 初始化
     *
     */
    public static void init() {
        PROCESS_NODE_GROUP_MAP.clear();
        ID_MAPPING.clear();
        for (Entry<String, Map<String, BizObjInfoVO>> entry : BIZ_OBJECT_MAP.entrySet()) {
            entry.getValue().clear();
        }
        BIZ_OBJECT_MAP.clear();
        for (Entry<String, Map<String, BizObjDataItemVO>> entry : BIZ_OBJ_DATAITEM_MAP.entrySet()) {
            entry.getValue().clear();
        }
        BIZ_OBJ_DATAITEM_MAP.clear();
        for (Entry<String, Map<String, BizFormVO>> entry : BIZ_FORM_MAP.entrySet()) {
            entry.getValue().clear();
        }
        BIZ_FORM_MAP.clear();
        for (Entry<String, Map<String, BizFormDataVO>> entry : BIZ_FORM_DATAITEM_MAP.entrySet()) {
            entry.getValue().clear();
        }
        BIZ_FORM_DATAITEM_MAP.clear();
        for (Entry<String, Map<String, BizRoleVO>> entry : BIZ_ROLE_MAP.entrySet()) {
            entry.getValue().clear();
        }
        BIZ_ROLE_MAP.clear();
        
        BIZ_REQ_FUNITEM_MAP.clear();
        for (Entry<String, Map<String, ReqFunctionItemVO>> entry : BIZ_REQ_FUNITEM_MAP.entrySet()) {
            entry.getValue().clear();
        }
        
        BIZ_REQ_FUNSUBITEM_MAP.clear();
        for (Entry<String, Map<String, ReqFunctionSubitemVO>> entry : BIZ_REQ_FUNSUBITEM_MAP.entrySet()) {
            entry.getValue().clear();
        }
        BIZ_REQ_FUNSUBITEM_TEMP.clear();
        BIZ_FORM_SIMPLEMAP.clear();
        BIZ_OBJECT_SIMPLEMAP.clear();
        
        BIZ_REQ_USECASE_MAP.clear();
        
        BIZ_LEVELS.clear();
    }
    
    /**
     * 获得业务功能项数据
     *
     * @param domainId 业务域id
     * @param name 业务功能项名称
     * @return 没有找到返回空
     */
    public static ReqFunctionItemVO getReqFunctionItem(String domainId, String name) {
        Map<String, ReqFunctionItemVO> map = BIZ_REQ_FUNITEM_MAP.get(domainId);
        String key = domainId + SPLITER + StringUtils.trim(name);
        if (map != null && !map.isEmpty()) {
            return map.get(key);
        }
        
        ReqFunctionItemAppService service = AppBeanUtil.getBean(ReqFunctionItemAppService.class);
        ReqFunctionItemVO condition = new ReqFunctionItemVO();
        condition.setBizDomainId(domainId);
        List<ReqFunctionItemVO> data = service.loadList(condition);
        Map<String, ReqFunctionItemVO> dataMap = new HashMap<String, ReqFunctionItemVO>();
        BIZ_REQ_FUNITEM_MAP.put(domainId, dataMap);
        for (ReqFunctionItemVO obj : data) {
            dataMap.put(obj.getBizDomainId() + SPLITER + StringUtils.trim(obj.getCnName()), obj);
        }
        return dataMap.get(key);
    }
    
    /**
     * 向缓存中添加业务功能项数据
     *
     * @param functionItem 业务需求功能项
     */
    public static void addReqFunctionItem(ReqFunctionItemVO functionItem) {
        if (functionItem == null) {
            return;
        }
        String domainId = functionItem.getBizDomainId();
        Map<String, ReqFunctionItemVO> map = BIZ_REQ_FUNITEM_MAP.get(domainId);
        String key = domainId + SPLITER + StringUtils.trim(functionItem.getCnName());
        if (map == null) {
            map = new HashMap<String, ReqFunctionItemVO>();
            BIZ_REQ_FUNITEM_MAP.put(domainId, map);
        }
        map.put(key, functionItem);
        
    }
    
    /**
     * 获得业务功能子项数据
     *
     * @param itemId 功能项id
     * @param name 业务功能子项名称
     * @return 没有找到返回空
     */
    public static ReqFunctionSubitemVO getReqFunctionSubitem(String itemId, String name) {
        Map<String, ReqFunctionSubitemVO> map = BIZ_REQ_FUNSUBITEM_MAP.get(itemId);
        String key = itemId + SPLITER + StringUtils.trim(name);
        if (map != null && !map.isEmpty()) {
            return map.get(key);
        }
        
        ReqFunctionSubitemAppService service = AppBeanUtil.getBean(ReqFunctionSubitemAppService.class);
        ReqFunctionSubitemVO condition = new ReqFunctionSubitemVO();
        condition.setItemId(itemId);
        List<ReqFunctionSubitemVO> data = service.queryReqFunctionSubitemList(condition);
        Map<String, ReqFunctionSubitemVO> dataMap = new HashMap<String, ReqFunctionSubitemVO>();
        BIZ_REQ_FUNSUBITEM_MAP.put(itemId, dataMap);
        for (ReqFunctionSubitemVO obj : data) {
            dataMap.put(obj.getItemId() + SPLITER + StringUtils.trim(obj.getCnName()), obj);
        }
        return dataMap.get(key);
    }
    
    /**
     * 获得业务功能子项数据
     *
     * @param subitemId 功能子项id
     * @return 没有找到返回空
     */
    public static ReqFunctionSubitemVO getTempReqFunctionSubitem(String subitemId) {
        return BIZ_REQ_FUNSUBITEM_TEMP.get(subitemId);
    }
    
    /**
     * 获得业务功能子项数据
     *
     * @param subitem 功能子项
     */
    public static void addTempReqFunctionSubitem(ReqFunctionSubitemVO subitem) {
        BIZ_REQ_FUNSUBITEM_TEMP.put(subitem.getId(), subitem);
    }
    
    /**
     * 移除业务功能子项数据
     *
     * @param subitemId 功能子项Id
     */
    public static void removeTempReqFunctionSubitem(String subitemId) {
        BIZ_REQ_FUNSUBITEM_TEMP.remove(subitemId);
    }
    
    /**
     * 向缓存中添加业务功能子项数据
     *
     * @param subitem 业务需求功能子项
     */
    public static void addReqFunctionSubitem(ReqFunctionSubitemVO subitem) {
        if (subitem == null) {
            return;
        }
        String itemId = subitem.getItemId();
        Map<String, ReqFunctionSubitemVO> map = BIZ_REQ_FUNSUBITEM_MAP.get(itemId);
        String key = itemId + SPLITER + StringUtils.trim(subitem.getCnName());
        if (map == null) {
            map = new HashMap<String, ReqFunctionSubitemVO>();
            BIZ_REQ_FUNSUBITEM_MAP.put(itemId, map);
        }
        map.put(key, subitem);
    }
    
    /**
     * 获得业务功能子项用例数据
     *
     * @param subitemId 功能子项id
     * @param usecaseName 用例名称
     * @return 没有找到返回空
     */
    public static ReqFunctionUsecaseVO getReqFunctionUsecase(String subitemId, String usecaseName) {
        String key = subitemId + SPLITER + StringUtils.trim(usecaseName);
        ReqFunctionUsecaseVO usecase = BIZ_REQ_USECASE_MAP.get(key);
        if (usecase == null) {
            ReqFunctionUsecaseAppService service = AppBeanUtil.getBean(ReqFunctionUsecaseAppService.class);
            ReqFunctionUsecaseVO condtion = new ReqFunctionUsecaseVO();
            condtion.setSubitemId(subitemId);
            List<ReqFunctionUsecaseVO> usecases = service.queryReqFunctionUsecaseList(condtion);
            if (usecases != null && usecases.size() > 0) {
                for (ReqFunctionUsecaseVO uc : usecases) {
                    addReqFunctionUsecase(uc);
                }
                usecase = BIZ_REQ_USECASE_MAP.get(key);
            }
        }
        return usecase;
    }
    
    /**
     * 向缓存中添加业务功能子项数据
     *
     * @param usecase 业务需求功能子项
     */
    public static void addReqFunctionUsecase(ReqFunctionUsecaseVO usecase) {
        if (usecase == null) {
            return;
        }
        String subitemId = usecase.getSubitemId();
        String key = subitemId + SPLITER + StringUtils.trim(usecase.getName());
        BIZ_REQ_USECASE_MAP.put(key, usecase);
        
    }
    
    /**
     * 获取角色的业务级别
     *
     * @param name 名称
     * @return 业务级别
     */
    public static String findRoleBizLevel(String name) {
        if (StringUtils.isBlank(name)) {
            return BizLevel.BIZ_LEVEL_UNKNOWN.getCode();
        }
        BizLevel[] levels = BizLevel.values();
        for (BizLevel level : levels) {
            if (name.startsWith(level.getCnName())) {
                return level.getCode();
            }
        }
        return BizLevel.BIZ_LEVEL_UNKNOWN.getCode();
    }
    
    /**
     * 获取业务角色和功能子项关联
     *
     * @param subitemId 功能子项ID
     * @param bizLevel 业务级别
     * @param roleName 角色名称
     * @return 功能子项和业务角色的关联
     */
    public static ReqSubitemDutyVO getReqSubitemDuty(String subitemId, String bizLevel, String roleName) {
        String key = subitemId + SPLITER + StringUtils.trim(StringUtils.isBlank(bizLevel) ? "" : bizLevel) + SPLITER
            + StringUtils.trim(roleName);
        ReqSubitemDutyVO duty = BIZ_REQ_SUBITEMDUTY_MAP.get(key);
        if (duty == null) {
            ReqSubitemDutyAppService service = AppBeanUtil.getBean(ReqSubitemDutyAppService.class);
            ReqSubitemDutyVO condtion = new ReqSubitemDutyVO();
            condtion.setSubitemId(subitemId);
            List<ReqSubitemDutyVO> dutys = service.queryReqSubitemDutyList(condtion);
            if (dutys != null && dutys.size() > 0) {
                for (ReqSubitemDutyVO rsd : dutys) {
                    addReqSubitemDuty(rsd);
                }
                duty = BIZ_REQ_SUBITEMDUTY_MAP.get(key);
            }
        }
        return duty;
    }
    
    /**
     * 添加业务角色和功能子项关联
     *
     * @param duty 业务角色和功能子项关联
     */
    public static void addReqSubitemDuty(ReqSubitemDutyVO duty) {
        if (duty == null) {
            return;
        }
        String subitemId = duty.getSubitemId();
        String key = subitemId + SPLITER
            + StringUtils.trim(StringUtils.isBlank(duty.getBizLevel()) ? "" : duty.getBizLevel()) + SPLITER
            + StringUtils.trim(duty.getRoleName());
        BIZ_REQ_SUBITEMDUTY_MAP.put(key, duty);
    }
    
    /**
     * 根据业务域和业务对象名称获取业务对象
     *
     * @param domainId 业务域ID
     * @param objectName 业务对象名称
     * @return 业务对象
     */
    public static BizObjInfoVO getBizObjInfo(String domainId, String objectName) {
        String simpleKey = domainId + SPLITER + StringUtils.trim(objectName);
        BizObjInfoVO info = BIZ_OBJECT_SIMPLEMAP.get(simpleKey);
        if (info == null) {
            BizObjInfoAppService bizObjInfoAppService = AppBeanUtil.getBean(BizObjInfoAppService.class);
            BizObjInfoVO condition = new BizObjInfoVO();
            condition.setDomainId(domainId);
            List<BizObjInfoVO> dataList = bizObjInfoAppService.loadList(condition);
            for (BizObjInfoVO bizObjInfoVO : dataList) {
                addBizObjInfo(bizObjInfoVO);
            }
            info = BIZ_OBJECT_SIMPLEMAP.get(simpleKey);
        }
        return info;
    }
}
