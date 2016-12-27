/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.template;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.Set;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.common.dwr.CapMap;
import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.common.storage.ObjectOperator;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.common.storage.exception.ValidateException;
import com.comtop.cap.bm.metadata.inject.ParseConfig;
import com.comtop.cap.bm.metadata.inject.PropertiesParseConfig;
import com.comtop.cap.bm.metadata.inject.injecter.IMetaDataInjecter;
import com.comtop.cap.bm.metadata.page.desinger.model.DataStoreVO;
import com.comtop.cap.bm.metadata.page.desinger.model.LayoutVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.cap.bm.metadata.page.template.model.MetaComponentDefineVO;
import com.comtop.cap.bm.metadata.page.template.model.MetadataPageConfigVO;
import com.comtop.cap.bm.metadata.page.template.model.PageTempVO;
import com.comtop.cap.ptc.login.model.CapLoginVO;
import com.comtop.cap.ptc.login.utils.CapLoginUtil;
import com.comtop.cip.json.JSON;
import com.comtop.cip.json.JSONObject;
import com.comtop.corm.resource.util.CollectionUtils;
import com.comtop.top.core.util.StringUtil;

/**
 * 元数据生成器处理类。
 * 1、某一数据集绑定在可变区域上，则此数据集对应的实体是可变（尽管此数据集还可能绑定在了不可变的区域上）。
 * 2、只分析快速表单布局的table，以及普通table中的Grid和EditGrid。因为只允许可变区域帮在这三类控件上。其他的控件则忽略分析。
 * 3、具有相同的区域编码和区域ID的可变区域，如果绑定的实体不同则非法；所有可变区域均未绑定任何实体数据集，则非法。
 *
 * @author 凌晨
 * @since jdk1.6
 * @version 2015年12月15日 凌晨
 */
public class TemplateProvider {
    
    /** 日志对象 **/
    private static final Logger LOGGER = LoggerFactory.getLogger(TemplateProvider.class);
    
    /** 随机器 */
    private static final Random RANDOM = new Random();
    
    /** 区域code与name的映射 */
    private final static Map<String, String> areaCodeAndName;
    
    static {
        areaCodeAndName = AreaDefinedInfoReader.read();
    }
    
    /**
     * 验证页面的可变区域设置是否合法（具有相同的区域编码和区域ID的可变区域，如果绑定的实体不同(一个有绑定实体为空，一个没绑定实体也视为不同)则非法）
     *
     * @param lst 需要校验的页面集合
     * @return
     *         校验结果（
     *         <code>{"result":false,"illegalAreas":[{"areaName":xxx,"areaId":xxx,"entityId":["www","yyy"],"pageURL":["personList","personEdit"]}],"message":"xxx"}</code>
     *         ,areaName为区域的中文名称，非区域的code，areaId可能不存在（值为null，序列化成JSON串时，跳过了null属性的序列化），表示为设置区域Id
     *         ,entityId数组中的元素为null表示区域未绑定数据集）
     */
    public CapMap validatePagesAreas(List<PageVO> lst) {
        
        List<MetaComponentDefineVO> lstArea;
        try {
            lstArea = analysisPage(lst);
            
            if (CollectionUtils.isEmpty(lstArea)) {
                CapMap map = new CapMap();
                map.put("result", false);
                map.put("message", "可变区域校验不通过：该模块下的所有页面均未设置任何可变区域。");
                return map;
            }
            
            return validateArea(lstArea);
        } catch (OperateException e) {
            LOGGER.debug("error", e);
            CapMap map = new CapMap();
            map.put("result", false);
            map.put("message", "页面解析为模板时出错。");
            return map;
        }
    }
    
    /**
     * 对可变区域的集合进行校验
     * 
     * @param lstArea 页面中的可变区域信息
     * @return 校验结果
     */
    private CapMap validateArea(List<MetaComponentDefineVO> lstArea) {
        // 校验的结果数据。key=areaCode+"_"+areaId,value=map:[key=entityId/pageURL,value=实体Id的set/页面名称的set]
        Map<String, Map<String, Set<String>>> validateResult = new HashMap<String, Map<String, Set<String>>>();
        for (MetaComponentDefineVO component : lstArea) {
            String cId = component.getId();
            String key = component.getUiType() + "_" + (cId == null ? "NULL" : cId);
            Map<String, Set<String>> entityPageURLMap = validateResult.get(key);
            if (CollectionUtils.isEmpty(entityPageURLMap)) {
                entityPageURLMap = new HashMap<String, Set<String>>();
            }
            
            // 整理实体set
            Set<String> entitySet = entityPageURLMap.get("entityId");
            if (CollectionUtils.isEmpty(entitySet)) {
                entitySet = new HashSet<String>();
            }
            entitySet.add((String) component.getUiConfig().get("entityId"));
            entityPageURLMap.put("entityId", entitySet);
            
            // 整理pageName的set
            Set<String> pageURLSet = entityPageURLMap.get("pageURL");
            if (CollectionUtils.isEmpty(pageURLSet)) {
                pageURLSet = new HashSet<String>();
            }
            pageURLSet.addAll((Set<String>) component.getUiConfig().get("pageURL"));
            entityPageURLMap.put("pageURL", pageURLSet);
            
            validateResult.put(key, entityPageURLMap);
        }
        
        // 分析校验的数据
        List<CapMap> illegalAreas = new ArrayList<CapMap>();
        // 初始化假设这些可变区域均为绑定实体
        boolean hasEntity = false;
        for (String key : validateResult.keySet()) {
            Map<String, Set<String>> entityPageURLMap = validateResult.get(key);
            Set<String> entitySet = entityPageURLMap.get("entityId");
            if (entitySet.size() > 1) {
                String[] areaCodeAndId = key.split("_");
                CapMap illegalArea = new CapMap();
                illegalArea.put("areaName", areaCodeAndName.get(areaCodeAndId[0]));
                if ("NULL".equals(areaCodeAndId[1])) {
                    areaCodeAndId[1] = null;
                }
                illegalArea.put("areaId", areaCodeAndId[1]);
                illegalArea.put("entityId", entitySet);
                illegalArea.put("pageURL", entityPageURLMap.get("pageURL"));
                illegalAreas.add(illegalArea);
            }
            if (entitySet.size() > 1) {
                hasEntity = true;
            } else if (entitySet.size() == 1) {
                Object[] objArray = entitySet.toArray();
                String entityId = (String) objArray[0];
                if (entityId != null) {
                    hasEntity = true;
                }
            }
        }
        
        CapMap map = new CapMap();
        
        if (!hasEntity) {
            map.put("result", false);
            map.put("message", "可变区域校验不通过：该模块下的所有页面上的所有可变区域，均未使用任何实体数据集。");
            return map;
        }
        
        if (CollectionUtils.isEmpty(illegalAreas)) {
            map.put("result", true);
        } else {
            map.put("result", false);
            map.put("illegalAreas", JSON.toJSONString(illegalAreas));
            String message = getValidateMsg(illegalAreas);
            map.put("message", message);
        }
        
        return map;
    }
    
    /**
     * 通过非法区域的数据封装提示信息
     *
     * @param illegalAreas 非法区域的数据
     * @return 提示信息
     */
    private String getValidateMsg(List<CapMap> illegalAreas) {
        String message = "可变区域校验不通过(数据模型关联的实体不一致)";
        for (int i = 0, leng = illegalAreas.size(); i < leng; i++) {
            CapMap capMap = illegalAreas.get(i);
            String areaName = (String) capMap.get("areaName");
            String areaId = (String) capMap.get("areaId");
            Set<String> pageURLs = (Set<String>) capMap.get("pageURL");
            if (leng > 1) {
                message += ("</br>区域" + (i + 1) + "：");
            }
            message += ("</br>&nbsp;&nbsp;&nbsp;&nbsp;区域名称：" + areaName);
            message += ("</br>&nbsp;&nbsp;&nbsp;&nbsp;区域Id：" + (areaId == null ? "空" : areaId));
            message += ("</br>&nbsp;&nbsp;&nbsp;&nbsp;所属页面：" + pageURLs);
        }
        return message;
    }
    
    /**
     * 创建操作页面集合的对象(JXPATH操作)
     * 
     * @param lst 页面集合
     * @return 操作对象
     */
    private ObjectOperator createPagesOperator(List<PageVO> lst) {
        Map<String, List<PageVO>> objTmepMap = new HashMap<String, List<PageVO>>();
        
        objTmepMap.put("page", lst);
        
        ObjectOperator lstOperator = new ObjectOperator(objTmepMap);
        return lstOperator;
    }
    
    /**
     * 收集所有页面的所有可变区域，并把每个可变区域封装成MetaComponentDefineVO对象
     * 
     * @param lst 页面集合
     * @return 页面中的区域信息
     * @throws OperateException 操作异常
     */
    private List<MetaComponentDefineVO> analysisPage(List<PageVO> lst) throws OperateException {
        
        // 把所有的layout封装成MetaComponentDefineVO
        List<MetaComponentDefineVO> lstComponent = new ArrayList<MetaComponentDefineVO>();
        
        String expression = "layoutVO//children[options/area !='']";
        
        List<LayoutVO> lstLayout;
        for (PageVO page : lst) {
            // 收集所有的可变区域的Layout
            lstLayout = page.queryList(expression, LayoutVO.class);
            
            if (!CollectionUtils.isEmpty(lstLayout)) {
                for (LayoutVO layoutVO : lstLayout) {
                    // 把layout封装成MetaComponentDefineVO
                    lstComponent.add(createMetaComponent(layoutVO, page));
                }
            }
        }
        
        return lstComponent;
    }
    
    /**
     * 
     * 批量clone源页面,并返回生成元数据录入界面配置文件需要的数据
     * 
     * @param lst 源页面集合（不能为null）
     * @param templateTypeCode 模板分类的code
     * @return 生成元数据录入界面配置文件需要的数据
     * @throws ValidateException 操作异常
     * @throws OperateException 保存页面时的异常
     */
    public MetadataPageConfigVO saveAsTemplates(List<PageVO> lst, String templateTypeCode) throws ValidateException,
        OperateException {
        // 为选择模板分类或模板分类为空时，直接返回null
        if (StringUtil.isBlank(templateTypeCode)) {
            return null;
        }
        
        // 获取所有可变区域的MetaComponentDefineVO对象
        List<MetaComponentDefineVO> xmlInfoList = analysisPage(lst);
        
        // 去掉重复的可变区域,对重复的可变区域，进行pageURL的合并
        xmlInfoList = removeRepeatedArea(xmlInfoList);
        
        // 创建模板的实体选择控件，并为每个区域控件设置实体别名
        Map<String, String> aliasMap = createEntityComponent(xmlInfoList);
        
        // 为页面的数据集设置别名
        if (aliasMap != null) {
            setDataStoreAlias(aliasMap, createPagesOperator(lst));
        }
        
        // 收录此模块中所有的页面Id信息
        List<CapMap> lstModelId = createPageModelIdComponent(lst, templateTypeCode);
        
        // 合并xmlInfoList里的查询区域与编辑区域
        mergeXmlInfoList(xmlInfoList);
        
        clonePages(lst, templateTypeCode);
        
        // 返回数据
        MetadataPageConfigVO configVO = new MetadataPageConfigVO();
        configVO.setMetaComponentDefineVOList(xmlInfoList);
        configVO.setPageTempList(lstModelId);
        
        return configVO;
    }
    
    /**
     * 创建实体选择控件信息，把实体选择控件添加到控件集合中；并为每个区域控件设置实体别名
     * 
     * @param xmlInfoList 区域控件集合
     * @return 所有实体的别名集合Map
     */
    private Map<String, String> createEntityComponent(List<MetaComponentDefineVO> xmlInfoList) {
        final Map<String, String> aliasMap = new HashMap<String, String>();
        
        for (MetaComponentDefineVO defineVO : xmlInfoList) {
            String strEntityId = (String) defineVO.getUiConfig().get("entityId");
            // 获取可变区域的关联的实体
            if (StringUtil.isNotBlank(strEntityId)) {
                boolean isExist = aliasMap.containsKey(strEntityId);
                // 如果别名map中不存在，则添加
                if (!isExist) {
                    String[] entityPart = strEntityId.split("[.]");
                    String alias = "alias_" + entityPart[entityPart.length - 3] + "_"
                        + entityPart[entityPart.length - 1];
                    aliasMap.put(strEntityId, alias); // "alias_" + getGuid()
                }
            }
            
            // 为区域控件添加实体的别名
            defineVO.getUiConfig().put("alias", aliasMap.get(strEntityId));
            
            // 删除控件vo中的实体键值对
            defineVO.getUiConfig().remove("entityId");
        }
        
        if (aliasMap.isEmpty()) {
            return null;
        }
        
        MetaComponentDefineVO entityComponent = new MetaComponentDefineVO();
        entityComponent.setId("entityId");
        entityComponent.setUiType("entitySelection");
        entityComponent.setLabel("记录集-实体ID");
        CapMap suffixMap = new CapMap();
        suffixMap.put("suffix", aliasMap.values());
        entityComponent.setUiConfig(suffixMap);
        
        xmlInfoList.add(entityComponent);
        return aliasMap;
    }
    
    /**
     * 根据区域layout 构建区域表单定义VO
     * 
     * @param layoutVO 区域信息
     * @param page layout所属页面
     * @return 区域表单定义VO
     */
    private MetaComponentDefineVO createMetaComponent(LayoutVO layoutVO, final PageVO page) {
        // 获取可变区域绑定的实体Id
        String entityId = getLayoutEntityId(layoutVO, page);
        
        CapMap optMap = layoutVO.getOptions();
        
        // 取得区域code
        String areaCode = (String) optMap.get("area");
        // 取得区域id
        String areaId = (String) optMap.get("areaId");
        
        if (StringUtil.isBlank(areaId)) {
            areaId = null;
        }
        // 创建对象
        MetaComponentDefineVO areaVo = new MetaComponentDefineVO();
        areaVo.setId(areaId);
        areaVo.setUiType(areaCode);
        CapMap map = new CapMap();
        map.put("entityId", entityId);
        Set set =  new HashSet();
        set.add(page.getModelName());
        map.put("pageURL", set);
        areaVo.setUiConfig(map);
        areaVo.setLabel(areaCodeAndName.get(areaCode));
        
        return areaVo;
    }
    
    /**
     * 获取可变区域关联的实体Id
     * 
     * @param layoutVO 可变区域的layout
     * @param page layout所属页面
     * @return 实体Id
     */
    private String getLayoutEntityId(LayoutVO layoutVO, PageVO page) {
        String entityId = null;
        if ("Grid".equals(layoutVO.getUiType())) {
            String extras = (String) layoutVO.getOptions().get("extras");
            if (StringUtil.isNotBlank(extras)) {
                JSONObject objJSON = JSON.parseObject(extras);
                entityId = objJSON.getString("entityId");
            }
        } else if ("EditableGrid".equals(layoutVO.getUiType())) {
            String extras = (String) layoutVO.getOptions().get("extras");
            if (StringUtil.isNotBlank(extras)) {
                JSONObject objJSON = JSON.parseObject(extras);
                String dataStoreEname = objJSON.getString("dataStoreEname");
                entityId = getEntityIdByDataStoreName(dataStoreEname, page);
            }
        } else {
            entityId = (String) layoutVO.getOptions().get("objectId");
        }
        return entityId;
    }
    
    /**
     * 去掉相同的可变区域
     * 
     * @param xmlInfoList 区域集合
     * @return 去重之后的可变区域集合
     */
    private List<MetaComponentDefineVO> removeRepeatedArea(List<MetaComponentDefineVO> xmlInfoList) {
        List<MetaComponentDefineVO> lstResult = new ArrayList<MetaComponentDefineVO>();
        for (MetaComponentDefineVO defineVO : xmlInfoList) {
            if (!isExistsArea(lstResult, defineVO)) {
                lstResult.add(defineVO);
            }
        }
        return lstResult;
    }
    
    /**
     * 
     * List（<code>areaRecordList</code>）中是否已存在该区域。
     *
     * @param sourceAreaList 区域集合
     * @param area 区域
     * @return true表示存在，false表示不存在
     */
    private boolean isExistsArea(List<MetaComponentDefineVO> sourceAreaList, MetaComponentDefineVO area) {
        if (CollectionUtils.isEmpty(sourceAreaList)) {
            return false;
        }
        for (MetaComponentDefineVO item : sourceAreaList) {
            if (area.getUiType().equals(item.getUiType())) {
                if (StringUtil.isBlank(area.getId())) {
                    if (StringUtil.isBlank(item.getId())) {
                        // 合并URL
                        mergePageURL(area, item);
                        return true;
                    }
                } else {
                    if (area.getId().equals(item.getId())) {
                        // 合并URL
                        mergePageURL(area, item);
                        return true;
                    }
                }
            }
        }
        return false;
    }
    
    /**
     * 合并MetaComponentDefineVO中的pageURL
     *
     * @param souce 合并的来源对象
     * @param target 合并的目标对象
     */
    private void mergePageURL(MetaComponentDefineVO souce, MetaComponentDefineVO target) {
        Set<String> sourcePageURLSet = (Set<String>) souce.getUiConfig().get("pageURL");
        Set<String> targetPageURLSet = (Set<String>) target.getUiConfig().get("pageURL");
        if (!CollectionUtils.isEmpty(sourcePageURLSet)) {
            targetPageURLSet.addAll(sourcePageURLSet);
        }
    }
    
    /**
     * 
     * 为页面的数据集设置别名
     * 
     * @param aliasMap 实体别名集合
     * @param lstOperator 操作对象
     * @throws OperateException 异常
     */
    private void setDataStoreAlias(Map<String, String> aliasMap, ObjectOperator lstOperator) throws OperateException {
        // 获取所有页面的
        List<DataStoreVO> dataStoreVo = lstOperator.queryList("page/dataStoreVOList[entityId!='']", DataStoreVO.class);
        if (!CollectionUtils.isEmpty(dataStoreVo)) {
            for (DataStoreVO item : dataStoreVo) {
                // 为数据集设置别名
                item.setAlias(aliasMap.get(item.getEntityId()));
            }
        }
    }
    
    /**
     * 把页面持久化为模板JSON文件。
     * 
     * @param pages 需要持久化的页面集合
     * @param templateTypeCode 模板分类的code
     * @return 持久化的结果。
     * @throws ValidateException 持久化页面时的异常
     */
    private boolean clonePages(List<PageVO> pages, String templateTypeCode) throws ValidateException {
        // 获取当前CAP用户信息
        CapLoginVO currentVO = CapLoginUtil.getCapCurrentUserSession();
        
        boolean result = true;
        for (PageVO pageVo : pages) {
            String pageModelId = pageVo.getModelId();
            String pageModelType = pageVo.getModelType();
            String pageModelPackage = pageVo.getModelPackage();
            String pageModelName = pageVo.getModelName();
            
            // 另存为模板需要对部分属性进行设置。
            // 持久化到指定的目录下面。如：pageTemplate/fwms1/pageTemp/xxx.pageTemp.json
            pageVo.setModelPackage("pageTemplate." + templateTypeCode);
            pageVo.setModelType("pageTemp");
            pageVo.setModelId(pageVo.getModelPackage() + "." + pageVo.getModelType() + "." + pageVo.getModelName());
            pageVo.setCreaterId(currentVO.getBmEmployeeId());
            pageVo.setCreaterName(currentVO.getBmEmployeeName());
            pageVo.setCreateTime(System.currentTimeMillis());
            
            // clone,并保留原页面的以下信息
            PageTempVO pageTempVO = clone(pageVo);
            pageTempVO.setPageModelId(pageModelId);
            pageTempVO.setPageModelName(pageModelName);
            pageTempVO.setPageModelPackage(pageModelPackage);
            pageTempVO.setPageModelType(pageModelType);
            
            // 把pageVo对象持久化为JSON文件
            boolean _result = pageTempVO.saveModel();
            if (!_result) {
                result = _result;
                break;
            }
        }
        
        return result;
    }
    
    /**
     * 克隆页面（从PageVO到PageTempVO）
     *
     * 
     * @param page 需要clone的页面
     * @return clone出来的新页面
     */
    private PageTempVO clone(PageVO page) {
        return cloneObject(page, PageTempVO.class);
    }
    
    /**
     * 
     * 收集此模块所有页面的<code>ModelId</code>记录
     * 
     * @param lst 页面
     * @param templateTypeCode 模板分类
     * @return 页面配置信息
     *
     */
    private List<CapMap> createPageModelIdComponent(List<PageVO> lst, final String templateTypeCode) {
        
        final List<CapMap> lstModelId = new ArrayList<CapMap>();
        for (final PageVO pageVO : lst) {
            CapMap modelIdMap = new CapMap();
            modelIdMap.put("modelId", "pageTemplate." + templateTypeCode + ".pageTemp." + pageVO.getModelName());
            lstModelId.add(modelIdMap);
        }
        return lstModelId;
    }
    
    /**
     * 
     * 合并<code>xmlInfoList</code>里的查询区域与编辑区域
     * 
     * @param xmlInfoList 所有区域
     *
     */
    private void mergeXmlInfoList(List<MetaComponentDefineVO> xmlInfoList) {
        if (CollectionUtils.isEmpty(xmlInfoList)) {
            return;
        }
        // 把查询区域的组件全部放到queryArea中，把编辑区域的组件全部放到edityArea中
        List<MetaComponentDefineVO> queryArea = new ArrayList<MetaComponentDefineVO>();
        List<MetaComponentDefineVO> edityArea = new ArrayList<MetaComponentDefineVO>();
        Iterator<MetaComponentDefineVO> it = xmlInfoList.iterator();
        while (it.hasNext()) {
            MetaComponentDefineVO componentVo = it.next();
            if (componentVo.getUiType().startsWith("query")) {
                queryArea.add(componentVo);
                it.remove();
            } else if (componentVo.getUiType().startsWith("edit")) {
                edityArea.add(componentVo);
                it.remove();
            } else if (componentVo.getUiType().startsWith("list")) { // 处理列表区域
                // 获取区域所属URL，并进行去重
                final Set<String> urls = (Set<String>) componentVo.getUiConfig().get("pageURL");
                // final Set<String> urls = removeRepeatedPageURL(url);
                
                // 组装{"listCodeArea":[{"areaId":"personList","pageURL":["PersonListListPag"]}]}
                final String areaId = componentVo.getId();
                List<CapMap> areaInfo = new ArrayList<CapMap>();
                CapMap areaUrlMap = new CapMap();
                areaUrlMap.put("areaId", areaId);
                areaUrlMap.put("pageURL", urls);
                areaInfo.add(areaUrlMap);
                String areaCode = componentVo.getUiType();
                CapMap map = new CapMap();
                map.put(areaCode, areaInfo);
                
                // 把组装好的区域信息，置于uiConfig属性中
                componentVo.getUiConfig().put("componentInfo", map);
                
                // 去掉之前uiConfig中的pageURL键值对
                componentVo.getUiConfig().remove("pageURL");
                
                // 重置控件的Id
                componentVo.setId(areaCode + "_" + getGuid()); // 使用GUID来保证多个查询区域和编辑区域的ID唯一
            }
        }
        
        List<MetaComponentDefineVO> queryAreaComponents = merge(queryArea, "queryCodeArea");
        List<MetaComponentDefineVO> editAreaComponents = merge(edityArea, "editCodeArea");
        
        // 把合并的结果添加到xmlInfoList中
        if (!CollectionUtils.isEmpty(queryAreaComponents)) {
            xmlInfoList.addAll(queryAreaComponents);
        }
        if (!CollectionUtils.isEmpty(editAreaComponents)) {
            xmlInfoList.addAll(editAreaComponents);
        }
    }
    
    /**
     * 合并同一类（查询或编辑）的区域
     *
     * @param lst 同一类区域的集合
     * @param areaCode 同一类区域的CODE
     * @return 合并后的组件集合（每个实体别名对应一个组件）
     */
    private List<MetaComponentDefineVO> merge(List<MetaComponentDefineVO> lst, String areaCode) {
        if (CollectionUtils.isEmpty(lst)) {
            return null;
        }
        // 通过组件绑定的实体的别名进行分组，组里再根据区域类型再分组
        // 分组key=实体别名，value：key=区域编码（固定查询区域/更多查询区域或编辑表单区域/编辑表格区域），value=区域集合
        Map<String, Map<String, List<MetaComponentDefineVO>>> aliasGroupMap = new HashMap<String, Map<String, List<MetaComponentDefineVO>>>();
        
        for (MetaComponentDefineVO item : lst) {
            // 获取组件的绑定的实体的别名
            String alias = (String) item.getUiConfig().get("alias");
            
            // 获取别名组
            Map<String, List<MetaComponentDefineVO>> areaTypeGroupMap = aliasGroupMap.get(alias);
            if (CollectionUtils.isEmpty(areaTypeGroupMap)) {
                areaTypeGroupMap = new HashMap<String, List<MetaComponentDefineVO>>();
            }
            
            String realAreaCode = item.getUiType();
            // 获取区域类型组的集合，如固定查询区域组
            List<MetaComponentDefineVO> sameAreaTypeComponents = areaTypeGroupMap.get(realAreaCode);
            if (CollectionUtils.isEmpty(sameAreaTypeComponents)) {
                sameAreaTypeComponents = new ArrayList<MetaComponentDefineVO>();
            }
            // 把组件添加到区域类型组的集合中
            sameAreaTypeComponents.add(item);
            
            // 添加到区域类型组中
            areaTypeGroupMap.put(realAreaCode, sameAreaTypeComponents);
            
            // 添加到实体别名组中
            aliasGroupMap.put(alias, areaTypeGroupMap);
            
        }
        
        if (CollectionUtils.isEmpty(aliasGroupMap)) {
            return null;
        }
        
        // 声明方法返回值的list
        List<MetaComponentDefineVO> returnList = new ArrayList<MetaComponentDefineVO>();
        
        // 遍历别名组
        for (String alias : aliasGroupMap.keySet()) {
            Map<String, List<CapMap>> sameAreaTypeComponentIdsMap = new HashMap<String, List<CapMap>>();
            
            Map<String, List<MetaComponentDefineVO>> areaTypeGroupMap = aliasGroupMap.get(alias);
            for (String areaType : areaTypeGroupMap.keySet()) {
                List<CapMap> componentInfo = new ArrayList<CapMap>();
                
                List<MetaComponentDefineVO> sameAreaTypeComponents = areaTypeGroupMap.get(areaType);
                for (MetaComponentDefineVO component : sameAreaTypeComponents) {
                    CapMap infoMap = new CapMap();
                    String areaId = component.getId();
                    Set<String> setUrl = (Set<String>) component.getUiConfig().get("pageURL");
                    infoMap.put("areaId", areaId);
                    infoMap.put("pageURL", setUrl);
                    componentInfo.add(infoMap);
                }
                sameAreaTypeComponentIdsMap.put(areaType, componentInfo);
            }
            // 别名组中，每个别名都对应创建一个组件
            MetaComponentDefineVO mergeVo = new MetaComponentDefineVO();
            mergeVo.setUiType(areaCode);
            mergeVo.setId(areaCode + "_" + getGuid()); // 使用GUID来保证多个查询区域和编辑区域的ID唯一
            mergeVo.setLabel(areaCodeAndName.get(areaCode));
            
            CapMap map = new CapMap();
            map.put("componentInfo", sameAreaTypeComponentIdsMap); // 设置查询区域或编辑区域对应的子区域信息（区域编码及区域的Id集合）componentIds
            map.put("alias", alias); // 设置查询区域或编辑区域的实体对应的别名
            
            mergeVo.setUiConfig(map);
            
            returnList.add(mergeVo);
        }
        
        return returnList;
    }
    
    /**
     * 
     * 通过数据集的名称获取数据集对应的实体Id
     * 
     * @param dataStoreName 数据集名称
     * @param pageVo 页面vo
     *
     * @return 数据集对应的实体Id
     */
    private String getEntityIdByDataStoreName(String dataStoreName, PageVO pageVo) {
        if (StringUtil.isBlank(dataStoreName) || pageVo == null) {
            return null;
        }
        
        // 取出页面的数据集集合
        List<DataStoreVO> lstDataStore = pageVo.getDataStoreVOList();
        // 遍历数据集集合
        if (!CollectionUtils.isEmpty(lstDataStore)) {
            for (DataStoreVO dataStoreVo : lstDataStore) {
                // 找到与需要找的数据集业务名称一样的数据集
                if (dataStoreName.equals(dataStoreVo.getEname())) {
                    // 取得数据集对应的实体Id并返回实体Id
                    return dataStoreVo.getEntityId();
                }
            }
        }
        
        return null;
    }
    
    /**
     * 
     * 获取Guid
     *
     * 
     * @return 随机的Guid
     */
    private String getGuid() {
        return new BigInteger(165, RANDOM).toString(36).toUpperCase();
    }
    
    /**
     * 
     * 通过页面的<code>ModelId</code>集合得到相应的页面集合（<code>List</code>）
     * 
     * @param lstModelId 页面的<code>modelId</code>集合
     * @return 页面的集合。如果参数为<code>null</code>或参数的长度为0或参数中的所有<code>modelId</code> 都找不到对应的实体，则返回<code>null</code>。
     */
    public List<PageTempVO> getTemplatePagesByModelId(List<String> lstModelId) {
        if (!CollectionUtils.isEmpty(lstModelId)) {
            List<PageTempVO> pageTemplates = null;
            for (String modelId : lstModelId) {
                if (StringUtil.isNotBlank(modelId)) {
                    PageTempVO pageTemplateVO = (PageTempVO) CacheOperator.readById(modelId);
                    if (pageTemplateVO != null) {
                        pageTemplates = pageTemplates != null ? pageTemplates : new ArrayList<PageTempVO>();
                        pageTemplates.add(pageTemplateVO);
                    }
                }
            }
            return pageTemplates;
        }
        return null;
    }
    
    /**
     * 元数据注入（替换）
     *
     * 
     * @param fillData 需要注入的数据
     * @param source 被注入的数据源
     */
    public void metaDataInject(Object fillData, List<Object> source) {
        if (fillData == null || CollectionUtils.isEmpty(source)) {
            throw new RuntimeException("元数据注入失败,原因：注入的数据或被注入的数据源为空");
        }
        // 获得对应的解析类
        ParseConfig parseConfig = new PropertiesParseConfig();
        Map<String, IMetaDataInjecter> objectInjecterMap = parseConfig.getConfig();
        IMetaDataInjecter templateObjectInjecter;
        if (!CollectionUtils.isEmpty(source)) {
            for (Object object : source) {
                for (String key : objectInjecterMap.keySet()) {
                    if (key.startsWith("page.")) {
                        templateObjectInjecter = objectInjecterMap.get(key);
                        templateObjectInjecter.inject(fillData, object);
                    }
                }
            }
        }
    }
    
    /**
     * 对象拷贝
     * 
     * @param <T> 泛型
     * @param sourceObj 源对象
     * @param targetType 目标对象类型
     * @return 目标对象
     */
    private <T> T cloneObject(Object sourceObj, Class<T> targetType) {
        if (sourceObj == null) {
            return null;
        }
        String strJson = JSON.toJSONString(sourceObj);
        return JSON.parseObject(strJson, targetType);
    }
    
}
