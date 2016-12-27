/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.inject.injecter.page;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Random;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.junit.Ignore;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.common.dwr.CapMap;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.inject.injecter.IMetaDataInjecter;
import com.comtop.cap.bm.metadata.inject.injecter.util.MetadataInjectProvider;
import com.comtop.cap.bm.metadata.page.actionlibrary.facade.ActionDefineFacade;
import com.comtop.cap.bm.metadata.page.actionlibrary.model.ActionDefineVO;
import com.comtop.cap.bm.metadata.page.desinger.model.DataStoreVO;
import com.comtop.cap.bm.metadata.page.desinger.model.LayoutVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageActionVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.cap.bm.metadata.page.preference.model.IncludeFileVO;
import com.comtop.cap.bm.metadata.page.template.model.EditAreaComponentVO;
import com.comtop.cap.bm.metadata.page.template.model.GridAreaComponentVO;
import com.comtop.cap.bm.metadata.page.template.model.MetadataGenerateVO;
import com.comtop.cap.bm.metadata.page.template.model.MetadataValueVO;
import com.comtop.cap.bm.metadata.page.uilibrary.model.PropertyVO;
import com.comtop.cip.json.JSON;
import com.comtop.cip.json.JSONArray;
import com.comtop.cip.json.JSONObject;
import com.comtop.corm.resource.util.CollectionUtils;
import com.comtop.top.core.util.StringUtil;

/**
 * 列表区域以、编辑表格区域以及render行为的注入器
 *
 * @author 凌晨
 * @since jdk1.6
 * @version 2016年1月4日 凌晨
 */
public class GirdAndRenderActionInjecter implements IMetaDataInjecter {
    
    /** 日志 */
    protected final static Logger LOG = LoggerFactory.getLogger(GirdAndRenderActionInjecter.class);
    
    /** 随机器 */
    private final static Random RANDOM = new Random();
    
    @Override
    public void inject(Object obj, Object source) {
        MetadataGenerateVO genVO = (MetadataGenerateVO) obj;
        // 获取元数据录入页面生成的所有gird、editGird区域
        List<GridAreaComponentVO> allGirds = getAllGirds(genVO);
        
        // 遍历页面
        // for (Object o : source) {
        PageVO page = (PageVO) source;
        try {
            // 根据元数据录入界面的列表区域、编辑表格区域中列声明的渲染事件生成相应的渲染行为，并添加到行为集合中
            for (GridAreaComponentVO item : allGirds) {
                String areaCode = item.getArea();
                String areaId = item.getAreaId();
                String expression = "./layoutVO//children[options[@area='" + areaCode + "']]";
                
                // 通过JXPATH操作对象
                List<LayoutVO> lstLayout = MetadataInjectProvider.queryList(page, expression, LayoutVO.class);
                List<LayoutVO> tempList = new ArrayList<LayoutVO>();
                if (!CollectionUtils.isEmpty(lstLayout)) {
                    tempList.addAll(lstLayout);
                }
                // 对lstLayout进行过滤(比较areaId,不相同的areaId去掉，因为jxpath表达式里面条件不能写areaId=null)
                Iterator<LayoutVO> it = tempList.iterator();
                while (it.hasNext()) {
                    LayoutVO layoutItem = it.next();
                    String layAreaId = (String) layoutItem.getOptions().get("areaId");
                    if (StringUtil.isBlank(areaId)) {
                        if (StringUtil.isNotBlank(layAreaId)) {
                            it.remove();
                        }
                    } else {
                        if (!areaId.equals(layAreaId)) {
                            it.remove();
                        }
                    }
                }
                
                // 如果页面存在这样的区域
                if (!CollectionUtils.isEmpty(tempList)) {
                    injectGrid(item, tempList, page);
                }
            }
            
        } catch (OperateException e) {
            LOG.error("注入渲染行为异常", e);
        }
    }
    
    /**
     * 把元数据录入界面生成的gird、editGrid区域替换到页面上
     *
     * 
     * @param gridAreaVO 元数据录入界面生成的gird、editGird区域对象
     * @param layout 页面上的Gird、editGird的layout
     * @param page 当前页面
     * @throws OperateException 操作异常
     */
    private void injectGrid(GridAreaComponentVO gridAreaVO, List<LayoutVO> layout, PageVO page) throws OperateException {
        String columns = (String) gridAreaVO.getOptions().get("columns");
        String extras = (String) gridAreaVO.getOptions().get("extras");
        String databind = (String) gridAreaVO.getOptions().get("databind");
        String edittype = (String) gridAreaVO.getOptions().get("edittype");
        String primarykey = (String) gridAreaVO.getOptions().get("primarykey");
        String selectrows = (String) gridAreaVO.getOptions().get("selectrows");
        
        // 替换grid、editGird的layout中的相关字段
        for (LayoutVO item : layout) {
            item.getOptions().put("columns", columns);
            
            String processDatabind = databind;
            // 先把layout中的dataStoreEname获取到
            JSONObject obj = JSON.parseObject(extras);
            String layoutExtras = (String) item.getOptions().get("extras");
            if (obj != null && StringUtil.isNotBlank(layoutExtras)) {
                String dataStoreEname = JSON.parseObject(layoutExtras).getString("dataStoreEname");
                // 把dataStoreEname设置到extras中
                obj.put("dataStoreEname", dataStoreEname);
                
                // 处理databind
                processDatabind = processEditGridDatabind(processDatabind, dataStoreEname);
                
            } else if (obj != null && StringUtil.isBlank(layoutExtras)) {
                // 处理数据集（GridAreaComponentVO中的对应的实体在当前页面是否存在集合的数据集，不存在则创建，存在，则直接使用）
                String entityId = obj.getString("entityId");
                // 搜索此实体在数据集集合中是否有建立集合类型的数据集
                DataStoreVO targetDataStore = findListTypeDataStoreByEntityId(entityId, page);
                if (targetDataStore == null) {
                    // 未搜索到则创建新的数据集,并把新的数据集设置到页面上
                    targetDataStore = createListTypeDataStoreByEntityId(entityId, page);
                }
                String dataStoreEname = targetDataStore.getEname();
                // 把dataStoreEname设置到extras中
                obj.put("dataStoreEname", dataStoreEname);
                
                // 处理databind
                processDatabind = dataStoreEname;
                
            }
            item.getOptions().put("extras", obj == null ? obj : obj.toJSONString());
            item.getOptions().put("databind", processDatabind);
            item.getOptions().put("edittype", edittype);
            item.getOptions().put("primarykey", primarykey);
            item.getOptions().put("selectrows", selectrows);
            
            // 处理render
            if (StringUtil.isNotBlank(columns)) {
                processColumnsRender(item, page);
            }
            // 处理includeFile
            this.processIncludeFile(page, gridAreaVO);
        }
    }
    
    /**
     * 在页面中搜索指定的实体是否有创建集合类型的数据集。
     * 该方法无法保证搜索结果的精确性，只是努力的做了尝试。因为搜索的结果依赖于本实现类和数据集注入的实现类(即：<code>EntityComponentInject.java</code>)的实例执行inject函数的先后顺序。
     *
     * @param entityId 指定的实体Id
     * @param page 页面
     * @return 搜索到的数据集，如果未搜索到则返回null
     */
    private DataStoreVO findListTypeDataStoreByEntityId(String entityId, PageVO page) {
        List<DataStoreVO> lstDataStore = page.getDataStoreVOList();
        for (DataStoreVO item : lstDataStore) {
            String dataStoteEntityId = item.getEntityId();
            if (entityId.equals(dataStoteEntityId) && "list".equals(item.getModelType())) {
                return item;
            }
        }
        return null;
    }
    
    /**
     * 根据指定的实体Id创建一个新的集合类型的数据集.并把新创建的数据集设置到页面中
     *
     * @param entityId 指定的实体Id
     * @param page 页面
     * @return 创建的集合类型的数据集
     */
    private DataStoreVO createListTypeDataStoreByEntityId(String entityId, PageVO page) {
        DataStoreVO instance = new DataStoreVO();
        String[] entitySplit = entityId.split("[.]");
        String entityName = entitySplit[entitySplit.length - 1];
        
        instance.setCname(entityName + "集合");
        instance.setEname(entityName.substring(0, 1).toLowerCase() + entityName.substring(1) + "List");
        instance.setEntityId(entityId);
        instance.setModelType("list");
        
        // 设置到数据集的集合中
        page.getDataStoreVOList().add(instance);
        
        return instance;
    }
    
    /**
     * 处理editGrid的<code>databind</code>属性
     *
     * @param databind 元数据录入界面生成提供的<code>databind</code>
     * @param dataStoreEname 原editGrid区域上<code>extras</code>属性中的数据集的英文名称
     * @return 处理后的<code>databind</code>
     */
    private String processEditGridDatabind(String databind, String dataStoreEname) {
        // 处理databind
        String pDatabind = null;
        if (StringUtil.isNotBlank(databind)) { // gird没有databind
            String[] databindSplit = databind.split("[.]");
            if (databindSplit.length > 1) { // 表示editGrid选择了子实体
                pDatabind = dataStoreEname + "." + databindSplit[databindSplit.length - 1];
            } else { // 表示editGrid选择了父实体
                pDatabind = dataStoreEname;
            }
        }
        return pDatabind;
    }
    
    /**
     * 处理引入文件
     * 
     * @param page 待处理页面VO
     * @param gridAreaVO 引入文件信息所在GridAreaVO
     */
    private void processIncludeFile(PageVO page, GridAreaComponentVO gridAreaVO) {
        List<IncludeFileVO> lstIncludeFiles = gridAreaVO.getIncludeFileList();
        List<IncludeFileVO> lstPageIncludeFile = page.getIncludeFileList();
        if (!CollectionUtils.isEmpty(lstIncludeFiles)) {
            List<IncludeFileVO> lstAddIncludeFiles = new ArrayList<IncludeFileVO>();
            for (Iterator<IncludeFileVO> iterator = lstIncludeFiles.iterator(); iterator.hasNext();) {
                IncludeFileVO includeFileVO = iterator.next();
                String strFilePath = includeFileVO.getFilePath();
                for (Iterator<IncludeFileVO> iterator2 = lstPageIncludeFile.iterator(); iterator2.hasNext();) {
                    IncludeFileVO includeFile = iterator2.next();
                    String filePath = includeFile.getFilePath();
                    if (StringUtil.equals(strFilePath, filePath)) {
                        break;
                    }
                    if (!StringUtil.equals(strFilePath, filePath) && !iterator2.hasNext()) {
                        lstAddIncludeFiles.add(includeFile);
                    }
                }
            }
            lstPageIncludeFile.addAll(lstAddIncludeFiles);
        }
    }
    
    /**
     * 处理gird、editGird的layout中列的render行为
     *
     * 
     * @param layout 被处理的layout
     * @param page layout所属页面
     * @throws OperateException 操作异常
     */
    private void processColumnsRender(LayoutVO layout, PageVO page) throws OperateException {
        String columns = (String) layout.getOptions().get("columns");
        String extras = (String) layout.getOptions().get("extras");
        JSONObject extrasObj = JSON.parseObject(extras);
        List<PageActionVO> actions = null;
        // 把列的信息转换成JSON数组
        JSONArray columnsArray = JSON.parseArray(columns);
        // 遍历JSON数组中的每一列的数据
        for (Object o : columnsArray) {
            JSONObject columnObj = (JSONObject) o;
            Object render = columnObj.get("render");
            // 如果存在render行为
            if (render != null) {
                // 获取页面的所有行为
                if (actions == null) {
                    actions = MetadataInjectProvider.queryList(page, "./pageActionVOList", PageActionVO.class);
                }
                // 从行为集合中找
                String actionName = findActionByModelId(actions, (String) render);
                if (actionName == null) {
                    // 创建行为实例
                    // PageActionVO pageActionInstance = createPageActionInstance((String) columnObj.get("name"),
                    // (String) columnObj.get("bindName"));
                    PageActionVO pageActionInstance = getPageAction((String) columnObj.get("name"),
                        (String) columnObj.get("bindName"), (String) columnObj.get("render"));
                    actionName = pageActionInstance.getEname();
                    // 把创建的行为实例添加到页面的行为集合中
                    MetadataInjectProvider.add(page, "./pageActionVOList", pageActionInstance);
                }
                columnObj.put("render", actionName);
                // 从extras找到该列
                processExtrasRender(extrasObj, (String) columnObj.get("bindName"), actionName);
            }
        }
        // 把字符串设置回去
        layout.getOptions().put("columns", columnsArray.toJSONString());
        layout.getOptions().put("extras", extrasObj.toJSONString());
    }
    
    /**
     * 从extras中找到指定的列（按bindName寻找），并把列的render属性值替换成行为的英文名称
     *
     * @param extrasObj 查找的数据源的JSON对象
     * @param bindName 指定的列的bindName
     * @param actionName 行为的英文名称
     */
    private void processExtrasRender(JSONObject extrasObj, String bindName, String actionName) {
        String extras = (String) extrasObj.get("tableHeader");
        if (StringUtil.isBlank(extras)) {
            return;
        }
        JSONArray columnsArray = JSON.parseArray(extras);
        for (Object item : columnsArray) {
            JSONObject o = (JSONObject) item;
            String bName = (String) o.get("bindName");
            if (bName.equals(bindName)) {
                o.put("render", actionName);
                break;
            }
        }
        // 把字符串设置回去
        extrasObj.put("tableHeader", columnsArray.toJSONString());
    }
    
    /**
     * 从给定的行为集合中找到指定的行为。如果找到，返回行为的英文名称；如果没找到，返回null
     *
     * 
     * @param actions 给定的行为集合
     * @param modelId 指定的行为的modelId
     * @return 返回的结果
     */
    private String findActionByModelId(List<PageActionVO> actions, String modelId) {
        for (PageActionVO item : actions) {
            // 获取行为Id
            String templateId = item.getMethodTemplate();
            // 对比行为Id
            if (modelId.equals(templateId)) {
                return item.getEname();
            }
        }
        return null;
    }
    
    /**
     * 为列创建一个render行为实例
     *
     * @param columnCname 列中文名
     * @param columnEname 列英文名（bindName）
     * @return 新创新的行为实例
     */
    @Ignore
    private PageActionVO createPageActionInstance(String columnCname, String columnEname) {
        PageActionVO pageActionVO = new PageActionVO();
        pageActionVO.setCname(columnCname + "渲染");
        // 列的bindname+"_render"组成行为的英文名称（可能会重复）
        pageActionVO.setEname(columnEname + "_render");
        pageActionVO.setDescription(columnCname + "渲染行为");
        pageActionVO.setMethodBody("");
        pageActionVO.setMethodOption(new CapMap());
        pageActionVO.setMethodBodyExtend(new CapMap());
        pageActionVO.setMethodTemplate("");
        pageActionVO.setPageActionId(getGUID());
        return pageActionVO;
    }
    
    /**
     * 获取唯一标识UUID
     * 
     * @return UUID
     */
    private String getGUID() {
        return new BigInteger(165, RANDOM).toString(36).toUpperCase();
    }
    
    /**
     * 获取元数据录入界面生成的所有gird、editGird区域集合
     *
     * @param genVO 元数据录入界面生成的对象
     * @return 所有gird、editGird的区域集合
     */
    private List<GridAreaComponentVO> getAllGirds(MetadataGenerateVO genVO) {
        MetadataValueVO metadataValueVO = genVO.getMetadataValue();
        // 获取列表区域集合
        List<GridAreaComponentVO> lstListArea = metadataValueVO.getGridComponentList();
        // 获取编辑区域集合
        List<EditAreaComponentVO> lstEditArea = metadataValueVO.getEditComponentList();
        // 获取所有的编辑表格区以及列表区grid
        List<GridAreaComponentVO> allGirds = new ArrayList<GridAreaComponentVO>();
        for (EditAreaComponentVO editGirdArea : lstEditArea) {
            List<GridAreaComponentVO> lstEditGird = editGirdArea.getEditGridAreaList();
            if (!CollectionUtils.isEmpty(lstEditGird)) {
                allGirds.addAll(lstEditGird);
            }
        }
        // 添加列表区
        if (!CollectionUtils.isEmpty(lstListArea)) {
            allGirds.addAll(lstListArea);
        }
        return allGirds;
    }
    
    /**
     * 根据render中ActionModeId生成一个PageAction
     * 
     * @param actionModelId 行为模板Id
     * @param cloumnName 列名
     * @param bindName 绑定名称
     * @return PageActionVO 页面行为对象
     */
    private PageActionVO getPageAction(String cloumnName, String bindName, String actionModelId) {
        PageActionVO objPageActionVO = new PageActionVO();
        objPageActionVO.setPageActionId(getGUID());
        ActionDefineFacade actionDefineFacade = new ActionDefineFacade();
        ActionDefineVO objActionDefineVO = actionDefineFacade.loadModel(actionModelId);
        if (objActionDefineVO != null) {
            try {
                ActionDefineVO objNewActionDefineVO = (ActionDefineVO) objActionDefineVO.clone();
                objPageActionVO.setCname(cloumnName + objNewActionDefineVO.getCname());
                // 列的bindname+"_render"组成行为的英文名称（可能会重复）
                objPageActionVO.setEname(bindName + objNewActionDefineVO.getModelName() + "_render");
                objPageActionVO.setDescription(bindName + objNewActionDefineVO.getDescription());
                objPageActionVO.setInitPropertiesCount(objNewActionDefineVO.getProperties().size());
                objPageActionVO.setActionDefineVO(objNewActionDefineVO);
                String strMethodScript = objNewActionDefineVO.getScript();
                String regEx = "<script name=\\\"\\w+\\\"/>";
                String strMethod = strMethodScript.replaceAll(regEx, "");
                objPageActionVO.setMethodBody(strMethod);
                Pattern pat = Pattern.compile(regEx);
                Matcher mat = pat.matcher(strMethodScript);
                CapMap bodyExtendMap = new CapMap();
                for (int i = 1; i <= mat.groupCount(); i++) {
                    bodyExtendMap.put(mat.group(i), "");
                }
                objPageActionVO.setMethodBodyExtend(bodyExtendMap);
                List<PropertyVO> lstProperties = objNewActionDefineVO.getProperties();
                CapMap propertiesMap = new CapMap();
                for (Iterator iterator = lstProperties.iterator(); iterator.hasNext();) {
                    PropertyVO objProperty = (PropertyVO) iterator.next();
                    propertiesMap.put(objProperty.getEname(), objProperty.getDefaultValue());
                }
                objPageActionVO.setMethodOption(propertiesMap);// objNewActionDefineVO.getProperties();
                objPageActionVO.setMethodTemplate(objNewActionDefineVO.getModelId());
            } catch (Exception e) {
                LOG.error("设置行为ActionDefineVO失败", e);
            }
        }
        return objPageActionVO;
    }
}
