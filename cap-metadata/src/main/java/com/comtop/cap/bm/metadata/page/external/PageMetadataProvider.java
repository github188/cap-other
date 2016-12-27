/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.external;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.common.dwr.CapMap;
import com.comtop.cap.bm.metadata.common.storage.ObjectOperator;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.entity.facade.EntityFacade;
import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cap.bm.metadata.entity.model.MethodVO;
import com.comtop.cap.bm.metadata.page.desinger.facade.PageFacade;
import com.comtop.cap.bm.metadata.page.desinger.model.LayoutVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageActionVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageConstantVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.cap.bm.metadata.page.uilibrary.facade.ComponentFacade;
import com.comtop.cap.bm.metadata.page.uilibrary.model.ComponentVO;
import com.comtop.cap.bm.metadata.page.uilibrary.model.EventVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.json.JSON;
import com.comtop.cip.json.JSONArray;
import com.comtop.cip.json.JSONObject;
import com.comtop.corm.resource.util.CollectionUtils;
import com.comtop.top.core.jodd.AppContext;
import com.comtop.top.core.util.StringUtil;
import com.comtop.top.core.util.constant.NumberConstant;
import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;

/**
 * 页面元数据提供的相关接口（供文档生成使用）
 *
 *
 * @author 凌晨
 * @since jdk1.6
 * @version 2016年1月6日 凌晨
 */
@DwrProxy
@PetiteBean
public class PageMetadataProvider {
	/** 日志 */
    private final static Logger logger = LoggerFactory.getLogger(PageMetadataProvider.class);
    /** 页面Facade */
    private final PageFacade pageFacade = AppContext.getBean(PageFacade.class);
    
    /** 实体Facade */
    private final EntityFacade entityFacade = AppContext.getBean(EntityFacade.class);
    
    /** 控件Facade */
    private final ComponentFacade componentFacade = AppContext.getBean(ComponentFacade.class);
    
    /**
     * 通过模块Id查询此模块下的所有页面
     *
     * @param modelId 模块Id
     * @return 页面集合
     * @throws OperateException 查询异常
     */
    @RemoteMethod
    public List<PageVO> getPagesByModelId(String modelId) throws OperateException {
        return pageFacade.queryPageList(modelId);
    }
    
    /**
     * 根据页面modelID和行为ID获取行为对象
     *
     * @param modelId modelId
     * @param actionId actionId
     * @return 行为对象
     * @throws OperateException 查询异常
     */
    public PageActionVO getPageActionByPageModelIdAndActionId(String modelId, String actionId) throws OperateException {
        // 取得页面
        PageVO page = pageFacade.loadModel(modelId, null);
        if (page == null) {
            return null;
        }
        
        // 获取页面方法对象
        PageActionVO pageActionVO = page.query("pageActionVOList[pageActionId='" + actionId + "']", PageActionVO.class);
        return pageActionVO;
    }
    
    /**
     * 根据页面modelId获取页面对象
     *
     * @param modelId modelId
     * @return 页面对象
     * @throws OperateException 查询异常
     */
    @RemoteMethod
    public PageVO getPageByModelId(String modelId) throws OperateException {
        // 取得页面
        return pageFacade.loadModel(modelId, null);
    }
    
    /**
     * 通过页面的modelId找到该页面下所有的元素
     * 
     * @param pageId 页面modelId
     * @return 所有<code>PageMetadataDTO</code>(元素的封装对象)的集合
     * @throws OperateException 操作异常
     */
    public List<PageMetadataDTO> getAllElementsByPageModelId(String pageId) throws OperateException {
        // 取得页面
        PageVO page = pageFacade.loadModel(pageId, null);
        if (page == null) {
            return null;
        }
        
        ObjectOperator pageOperator = new ObjectOperator(page);
        // 查询页面中所有控件，不包括table\tr\td\代码块控件
        List<LayoutVO> lstLayout = pageOperator.queryList(
            "./layoutVO//children[uiType!='table' and uiType!='tr' and uiType!='td' and uiType!='CodeArea']",
            LayoutVO.class);
        
        List<PageMetadataDTO> lstPageMetadataDTO = new ArrayList<PageMetadataDTO>(lstLayout.size() + 1);
        // 创建“页面”元素的封装对象。
        PageMetadataDTO pagePageMetadataDTO = createPageSelfElement(pageOperator);
        lstPageMetadataDTO.add(pagePageMetadataDTO);
        
        // 遍历取到的所有layout，对每个layout进行封装成元素对象
        for (LayoutVO item : lstLayout) {
            PageMetadataDTO pageMetadataDTO = getPageMetadataDTO4Layout(item, pageOperator);
            lstPageMetadataDTO.add(pageMetadataDTO);
        }
        
        return lstPageMetadataDTO;
    }
    
    /**
     * 
     * 创建页面自身元素（把页面也当成一个元素）
     * 
     * @param pageOperator 页面操作者
     * @return 返回页面自身元素
     * @throws OperateException 操作异常
     */
    private PageMetadataDTO createPageSelfElement(ObjectOperator pageOperator) throws OperateException {
        // 创建PageMetadataDTO对象
        PageMetadataDTO pageMetadataDTO = new PageMetadataDTO();
        LayoutVO layout = new LayoutVO();
        CapMap objOptions = new CapMap();
        objOptions.put("label", "页面");
        objOptions.put("uiType", "Page");
        layout.setOptions(objOptions);
        layout.setUiType("Page");
        // 设置layout
        pageMetadataDTO.setLayout(layout);
        
        List<EventDTO> lstEventDTO = null;
        EventDTO eventDTO = null;
        // 查询页面中的行为列表，把指定的pageActionId的行为取出来
        List<PageActionVO> pageActions = pageOperator.queryList("pageActionVOList[ename='pageInitLoadData']",
            PageActionVO.class);
        // 正常情况下，pageActions最多只会有一个元素。（一个页面只会有一个名称为pageInitLoadData的行为）。如果出现多个，取第一个。
        if (pageActions.size() >= 1) {
            eventDTO = new EventDTO();
            // 设置行为
            PageActionVO actionVO = pageActions.get(0);
            eventDTO.setAction(actionVO);
            
            String entityId = (String) actionVO.getMethodOption().get("entityId");
            // 方法别名aliasName
            String aliasName = (String) actionVO.getMethodOption().get("actionMethodName");
            EntityVO entityVO = entityFacade.loadEntity(entityId, null);
            List<MethodVO> methods = getServices(entityVO, aliasName);
            // 目前实体方法建模不支持方法重载，所以方法名是唯一标识。取到的methods的长度不应该超过1，如果超过取第一个
            if (methods != null && methods.size() >= 1) {
                // 设置服务
                eventDTO.setService(methods.get(0));
                eventDTO.setEntity(entityVO);
            }
            // 创建事件定义对象
            EventVO eventDef = new EventVO();
            eventDef.setCname("初始化");
            eventDef.setEname("onload");
            eventDef.setDescription("页面加载初始化数据事件");
            eventDTO.setEventDef(eventDef);
        }
        
        if (eventDTO != null) {
            lstEventDTO = new ArrayList<EventDTO>();
            lstEventDTO.add(eventDTO);
        }
        // 设置元素事件
        pageMetadataDTO.setEvents(lstEventDTO);
        
        return pageMetadataDTO;
    }
    
    /**
     * 获取layout的元素封装数据
     *
     * @param layout 控件布局对象
     * @param pageOperator 当前页面操作者
     * @return 控件布局对应的元素对象
     * @throws OperateException 操作异常
     */
    private PageMetadataDTO getPageMetadataDTO4Layout(LayoutVO layout, ObjectOperator pageOperator)
        throws OperateException {
        if (layout == null) {
            return null;
        }
        
        List<EventDTO> lstEventDTO = new ArrayList<EventDTO>();
        // 通过layout中的componentModelId查询控件的componentVO
        ComponentVO componentVO = componentFacade.loadModel(layout.getComponentModelId());
        CapMap options = layout.getOptions();
        // 通过componentVO拿出控件本身所有的events
        List<EventVO> events = componentVO.getEvents();
        for (EventVO event : events) {
            // 如果选项中存在
            if (StringUtil.isNotBlank((String) options.get(event.getEname()))) {
                // 创建一个EventDTO
                EventDTO eventDTO = createEventDTO(event, (String) options.get(event.getEname() + "_id"), pageOperator);
                lstEventDTO.add(eventDTO);
            }
        }
        
        // 创建PageMetadataDTO
        PageMetadataDTO element = new PageMetadataDTO();
        element.setLayout(layout);
        element.setComponent(componentVO);
        element.setEvents(lstEventDTO);
        
        return element;
    }
    
    /**
     * 创建一个事件封装对象EventDTO
     *
     * @param eventdef 事件定义对象
     * @param pageActionId layout中的事件对应的行为Id
     * @param pageOperator 当前页面操作者
     * @return 事件封装对象
     * @throws OperateException 操作异常
     */
    private EventDTO createEventDTO(EventVO eventdef, String pageActionId, ObjectOperator pageOperator)
        throws OperateException {
        // 查询页面中的行为列表，把指定的pageActionId的行为取出来
        List<PageActionVO> pageActions = pageOperator.queryList(
            "pageActionVOList[pageActionId='" + pageActionId + "']", PageActionVO.class);
        
        EventDTO eventDTO = new EventDTO();
        // 设置事件定义对象
        eventDTO.setEventDef(eventdef);
        
        // 正常情况下，pageActions最多只会有一个元素。（一个pageActionId，只能找的到一个pageActionVO）。如果出现多个，取第一个。
        if (pageActions.size() >= 1) {
            PageActionVO pageAction = pageActions.get(0);
            // 设置行为
            eventDTO.setAction(pageAction);
            
            // 在行为里面找后台服务
            CapMap actionOption = pageAction.getMethodOption();
            // 从选项中找实体ID
            String entityId = (String) actionOption.get("entityId");
            // 方法别名
            String aliasName = (String) actionOption.get("actionMethodName");
            // 如果可以拿的到实体ID，则把对应实体中的方法拿到。
            if (StringUtil.isNotBlank(entityId) && StringUtil.isNotBlank(aliasName)) {
                EntityVO entityVO = entityFacade.loadEntity(entityId, null);
                List<MethodVO> methods = getServices(entityVO, aliasName);
                // 目前实体方法建模不支持方法重载，所以方法名是唯一标识。取到的methods的长度不应该超过1，如果超过取第一个
                if (methods != null && methods.size() >= 1) {
                    // 设置服务
                    eventDTO.setService(methods.get(0));
                    eventDTO.setEntity(entityVO);
                }
            }
        }
        
        return eventDTO;
    }
    
    /**
     * 在指定的实体中查找指定的方法
     *
     * @param entityVO 实体
     * @param methodName 方法名称
     * @return 方法的集合
     * @throws OperateException 操作异常
     */
    private List<MethodVO> getServices(EntityVO entityVO, String methodName) throws OperateException {
        if (entityVO == null) {
            return null;
        }
        ObjectOperator entityOperator = new ObjectOperator(entityVO);
        List<MethodVO> methods = entityOperator.queryList("methods[aliasName='" + methodName + "']", MethodVO.class);
        if (!CollectionUtils.isEmpty(methods) && !"queryExtend".equals(methods.get(0).getMethodType())) {
            return methods;
        }
        // 获取付实体
        EntityVO parentEntityVO = entityVO.getParentEntity();
        if (parentEntityVO == null) {
            return null;
        }
        ObjectOperator parentEntityOperator = new ObjectOperator(parentEntityVO);
        List<MethodVO> pMethods = parentEntityOperator.queryList("methods[aliasName='" + methodName + "']",
            MethodVO.class);
        if (!CollectionUtils.isEmpty(pMethods) && !"queryExtend".equals(pMethods.get(0).getMethodType())) {
            return methods;
        }
        return null;
    }
    
    /**
     * 获取正在使用给定行为的页面控件对象
     * 
     * @param pageModelId 页面model id <br/>
     *            如:com.comtop.cip.projectManage.page.ProjectWorkFlowListPageForWorkFlow
     * @param pageActionId 行为id
     * @return 控件列表，若对应行为未被任何控件对象使用则返回空集合。即：
     * 
     *         <pre>
     * new ArrayList&lt;LayoutVO&gt;(0)
     * </pre>
     * @throws OperateException XML操作异常
     */
    public List<LayoutVO> getLayoutVOListFromActionId(String pageModelId, String pageActionId) throws OperateException {
        if (StringUtil.isBlank(pageModelId) || StringUtil.isBlank(pageActionId)) {
            return new ArrayList<LayoutVO>(0);
        }
        
        // 取得页面
        PageVO page = pageFacade.loadModel(pageModelId, null);
        if (page == null) {
            return new ArrayList<LayoutVO>(0);
        }
        // 获取页面方法对象
        PageActionVO pageActionVO = page.query("pageActionVOList[pageActionId='" + pageActionId + "']",
            PageActionVO.class);
        if (pageActionVO == null) {
            return new ArrayList<LayoutVO>(0);
        }
        
        Map<String, LayoutVO> layoutVOMap = new HashMap<String, LayoutVO>();
        // 获取直接使用pageAction的layout，并存入layoutVOMap中。
        handleLayoutVOPage(layoutVOMap, pageActionVO, page);
        // 获取在pageAction的关联的layoutVO，并存放到layoutVOMap中 。典型使用场景：reloadGridData
        handleActionRelationGridId(layoutVOMap, pageActionVO, page);
        // 获取使用pageAction为列渲染函数(render属性)的grid、editableGrid，并存放到layoutVOMap中。
        handleGridRenderAction(layoutVOMap, pageActionVO, page);
        
        return layoutVOMap.isEmpty() ? new ArrayList<LayoutVO>(0) : new ArrayList<LayoutVO>(layoutVOMap.values());
    }
    
    /**
     * 获取使用pageAction为列渲染函数(render属性)的grid、editableGrid，并存放到layoutVOMap中
     * 
     * @param layoutVOMap layoutVOMap(key->id,value->LayoutVO)
     * @param pageActionVO 行为VO
     * @param page paveVO
     * @throws OperateException XML操作异常
     */
    private void handleGridRenderAction(Map<String, LayoutVO> layoutVOMap, PageActionVO pageActionVO, PageVO page)
        throws OperateException {
        assert layoutVOMap != null && pageActionVO != null && page != null
            && StringUtil.isNotBlank(pageActionVO.getEname());
        // 由于columns没有模型化，故获取页面所有的gird，然后遍历columns
        List<LayoutVO> layoutVOList = page.queryList("layoutVO//children[uiType='EditableGrid' or uiType='Grid']",
            LayoutVO.class);
        for (LayoutVO layoutVO : layoutVOList) {
            if (layoutVOMap.containsKey(layoutVO.getId())) {
                continue;
            }
            if (isUseActionOnLayout(layoutVO, pageActionVO)) {
                layoutVOMap.put(layoutVO.getId(), layoutVO);
            }
        }
    }
    
    /**
     * 获取在pageAction的关联的layoutVO(即relationGridId属性值)，并存入layoutVOMap中
     * <p>
     * 典型场景：reloadGridData行为中选择关联grid
     * </p>
     * 
     * @param layoutVOMap layoutVOMap(key->id,value->LayoutVO)
     * @param pageActionVO 行为VO
     * @param page paveVO
     * @throws OperateException XML操作异常
     */
    private void handleActionRelationGridId(Map<String, LayoutVO> layoutVOMap, PageActionVO pageActionVO, PageVO page)
        throws OperateException {
        assert layoutVOMap != null && pageActionVO != null && page != null
            && StringUtil.isNotBlank(pageActionVO.getEname());
        
        String relationGridId = (String) pageActionVO.getMethodOption().get("relationGridId");
        if (StringUtil.isBlank(relationGridId) || layoutVOMap.containsKey(relationGridId)) {
            return;
        }
        LayoutVO relationLayoutVO = page.query("layoutVO//children[options[id='" + relationGridId + "'] or id='" + relationGridId + "']", LayoutVO.class);
        if (relationLayoutVO != null) {
            layoutVOMap.put(relationLayoutVO.getId(), relationLayoutVO);
        }
    }
    
    /**
     * 获取直接使用pageAction的layout，并存入layoutVOMap中
     * 
     * @param layoutVOMap layoutVOMap(key->id,value->LayoutVO)
     * @param pageActionVO 行为VO
     * @param page paveVO
     * @throws OperateException XML操作异常
     */
    private void handleLayoutVOPage(Map<String, LayoutVO> layoutVOMap, PageActionVO pageActionVO, PageVO page)
        throws OperateException {
        assert layoutVOMap != null && pageActionVO != null && page != null
            && StringUtil.isNotBlank(pageActionVO.getEname());
        
        List<LayoutVO> layoutVOList = page.queryList("layoutVO//children[options/*='" + pageActionVO.getEname() + "']",
            LayoutVO.class);
        for (LayoutVO layoutVO : layoutVOList) {
            if (layoutVOMap.containsKey(layoutVO.getId())) {
                continue;
            }
            if (isUseActionOnLayout(layoutVO, pageActionVO)) {
                layoutVOMap.put(layoutVO.getId(), layoutVO);
            }
        }
        
    }
    
    /**
     * Layout是否有使用对应的pageActionVO
     * 
     * @param layoutVO layoutVO
     * @param pageActionVO pageActionVO
     * @return true 有 false 无
     */
    private boolean isUseActionOnLayout(LayoutVO layoutVO, PageActionVO pageActionVO) {
        assert layoutVO != null && pageActionVO != null && StringUtil.isNotBlank(pageActionVO.getEname());
        // 遍历option
        for (Object entryObject : layoutVO.getOptions().entrySet()) {
            @SuppressWarnings("unchecked")
            Map.Entry<Object, Object> entry = (Map.Entry<Object, Object>) entryObject;
            // 若value值与pageAction的eName一样表示有使用
            if (pageActionVO.getEname().equals(entry.getValue())) {
                return true;
            } else if ("columns".equals(entry.getKey()) && StringUtil.isNotBlank((String) entry.getKey())) {
                // 判断render值
                JSONArray jsonArray = (JSONArray) JSON.parse((String) entry.getValue());
                for (int i = 0; i < jsonArray.size(); i++) {
                    JSONObject jsonObject = jsonArray.getJSONObject(i);
                    if (pageActionVO.getEname().equals(jsonObject.get("render"))) {
                        return true;
                    }
                }
            }
        }
        return false;
    }
    
    /**
     * 按照指定的控件类型（或者集合）获取界面元数据中的所有控件
     * 
     * @param pageModelId 界面元数据模型Id
     * @param uitypes 控件类型集合
     * @return 返回查询结果
     */
    @RemoteMethod
    public Map<String, Object> queryCmpsByUItypes(String pageModelId, List<String> uitypes) {
        return this.getCmpsByUItypes(pageModelId, uitypes);
    }
    
    /**
     * 根据界面模型Id，获取该界面元数据中的所有录入型控件
     * 
     * @param pageModelId 界面元数据模型Id
     * @return 返回查询结果
     */
    @RemoteMethod
    public Map<String, Object> queryInputTypeCmpsByModelId(String pageModelId) {
        List<String> lstUItype = componentFacade.queryInputTypeUItypes(new String[]{"dev"});
        return this.getCmpsByUItypes(pageModelId, lstUItype);
    }
    
    /**
     * 根据界面模型Id，获取该界面元数据中的所有录入型控件
     * 
     * @param pageModelId 界面元数据模型Id
     * @param exclusionUItypes 不包含控件
     * @param required 是否必填
     * @return 返回查询结果
     */
    @SuppressWarnings("rawtypes")
    @RemoteMethod
    public Map<String, Object> queryInputTypeCmpsByModelId(String pageModelId, List exclusionUItypes, Boolean required) {
        Map<String, Object> objResult = new HashMap<String, Object>();
        if (StringUtil.isNotBlank(pageModelId)) {
            List<String> lstUItype = componentFacade.queryInputTypeUItypes(new String[]{"dev"});
            lstUItype.removeAll(exclusionUItypes);
            StringBuffer strExpression = new StringBuffer();
            strExpression.append("page[modelId='").append(pageModelId).append("']/layoutVO//children[options[(not(@readonly) or @readonly=false) and ");
            if(BooleanUtils.isTrue(required)){
                strExpression.append("@validate and contains(@validate,'\"type\":\"required\"') and ");
            }
            strExpression.append("(");
            for (int i = 0, len = lstUItype.size(), arrayLastIndex = len - 1; i < len; i++) {
                strExpression.append("@uitype='").append(lstUItype.get(i));
                strExpression.append(i < arrayLastIndex ? "' or " : "')]]");
            }
            try {
                List<LayoutVO> lstLayoutVO = pageFacade.queryList(strExpression.toString(), LayoutVO.class);
                objResult.put("result", NumberConstant.ONE);
                objResult.put("message", "查询成功！");
                objResult.put("dataList", lstLayoutVO != null ? lstLayoutVO : new ArrayList<LayoutVO>());
            } catch (OperateException e) {
                String strMsg = "根据控件类型获取界面元数据对应的控件时，报后台错误！";
                objResult.put("result", NumberConstant.MINUS_ONE);
                objResult.put("message", strMsg);
                logger.error(strMsg, e);
            }
        } else {
            objResult.put("result", NumberConstant.ZERO);
            objResult.put("message", "查询失败，传入参入值错误！");
        }
        return objResult;
    }
    
    /**
     * 按照指定的控件类型（或者集合）获取界面元数据中的所有控件
     * 
     * @param pageModelId 界面元数据模型Id
     * @param uitypes 控件类型集合
     * @return 返回查询结果
     */
    private Map<String, Object> getCmpsByUItypes(String pageModelId, List<String> uitypes) {
        Map<String, Object> objResult = new HashMap<String, Object>();
        if (StringUtil.isNotBlank(pageModelId) && uitypes != null && uitypes.size() > 0) {
            StringBuffer strExpression = new StringBuffer();
            strExpression.append("page[modelId='").append(pageModelId).append("']/layoutVO//children[options[");
            for (int i = 0, len = uitypes.size(), arrayLastIndex = len - 1; i < len; i++) {
                strExpression.append("@uitype='").append(uitypes.get(i));
                strExpression.append(i < arrayLastIndex ? "' or " : "']]");
            }
            try {
                List<LayoutVO> lstLayoutVO = pageFacade.queryList(strExpression.toString(), LayoutVO.class);
                objResult.put("result", NumberConstant.ONE);
                objResult.put("message", "查询成功！");
                objResult.put("dataList", lstLayoutVO != null ? lstLayoutVO : new ArrayList<LayoutVO>());
            } catch (OperateException e) {
                String strMsg = "根据控件类型获取界面元数据对应的控件时，报后台错误！";
                objResult.put("result", NumberConstant.MINUS_ONE);
                objResult.put("message", strMsg);
                logger.error(strMsg, e);
            }
        } else {
            objResult.put("result", NumberConstant.ZERO);
            objResult.put("message", "查询失败，传入参入值错误！");
        }
        return objResult;
    }
    
    /**
     * 获取页面跳转行为中带跳转URL页面常量类，若无页面跳转行为，则返回null。
     * <p>
     * 注意：
     * <li>本方法只适用于使用<b>cap有pageRUL属性的行为模板</b>所生成的行为，自定义行为方法是无法获取跳转URL。<br/>
     * 典型场景：grid编辑链接渲染、grid查看链接渲染等。</li>
     * <li>如上所述，本方法是返回行为模板中的用户选择的pageURL，一般情况下也是该行为跳转的页面，若用户在行为代码中调整跳转逻辑，返回的跳转URL与方法实际执行后跳转URL可能会不一致。</li>
     * </p>
     * 
     * @param pageActionId 行为id
     * @param pageModelId 页面model id <br/>
     *            如:com.comtop.cip.projectManage.page.ProjectWorkFlowListPageForWorkFlow
     * @return 带URL的页面常量类
     * @throws OperateException xml操作异常
     */
    public PageConstantVO getURLPageConstantFromActionId(String pageModelId, String pageActionId)
        throws OperateException {
        if (StringUtil.isBlank(pageModelId) || StringUtil.isBlank(pageActionId)) {
            return null;
        }
        // 行为中存放跳转页面的方法参数属性key
        final String pageURLParamName = "pageURL";
        // 取得页面
        PageVO page = pageFacade.loadModel(pageModelId, null);
        if (page == null) {
            return null;
        }
        
        // 获取页面连接
        String pageURLConstant = page.query("pageActionVOList[pageActionId='" + pageActionId + "']/methodOption/"
            + pageURLParamName, String.class);
        if (pageURLConstant == null || pageURLConstant == "") {
            return null;
        }
        return page.query("dataStoreVOList[ename='pageConstantList']/pageConstantList[constantName='" + pageURLConstant
            + "']", PageConstantVO.class);
    }
    
    /**
     * 根据布局控件Id，获取控件信息
     * 
     * @param pageModelId 界面元数据模型Id
     * @param LayoutId 布局控件Id
     * @return 返回查询结果
     */
    @RemoteMethod
    public Map<String, Object> queryCmpByLayoutId(String pageModelId, String LayoutId) {
        Map<String, Object> objResult = new HashMap<String, Object>();
        List<LayoutVO> lstLayoutVO = null;
        try {
            if (StringUtils.isBlank(pageModelId)) {
                List<PageVO> lstPage = pageFacade.queryList(
                    String.format("page[layoutVO//children[options[id='%s'] or id='%s']]", LayoutId, LayoutId), PageVO.class);
                if (lstPage != null && lstPage.size() > 0) {
                    pageModelId = lstPage.get(0).getModelId();
                    lstLayoutVO = lstPage.get(0).queryList(String.format("layoutVO//children[options[id='%s'] or id='%s']", LayoutId, LayoutId),
                        LayoutVO.class);
                }
            } else {
                lstLayoutVO = pageFacade.queryList(
                    String.format("page[modelId='%s']/layoutVO//children[options[id='%s'] or id='%s']", pageModelId, LayoutId, LayoutId),
                    LayoutVO.class);
            }
            objResult.put("result", NumberConstant.ONE);
            objResult.put("message", "查询成功！");
            objResult.put("pageModelId", pageModelId);
            objResult.put("data", lstLayoutVO != null && lstLayoutVO.size() > 0 ? lstLayoutVO.get(0) : null);
        } catch (OperateException e) {
            String strMsg = "根据控件Id获取界面元数据对应的控件时，报后台错误！";
            objResult.put("result", NumberConstant.MINUS_ONE);
            objResult.put("message", strMsg);
            logger.error(strMsg, e);
        }
        return objResult;
    }
    
    /**
     * 根据行为类型，获取页面对应的自定义行为对象，再根据该行为查找绑定了该行为的控件对象
     * 
     * @param pageModelId 界面元数据模型Id
     * @param actionType 行为类型
     * @return 返回查询结果
     */
    @SuppressWarnings("rawtypes")
    @RemoteMethod
    public Map<String, Object> queryCmpByActionType(String pageModelId, String actionType) {
        Map<String, Object> objResult = new HashMap<String, Object>();
        try {
            Map<String, LayoutVO> objLayoutMap = new HashMap<String, LayoutVO>();
            List<PageVO> lstPage = pageFacade.queryList(String.format("page[modelId='%s']", pageModelId), PageVO.class);
            if(lstPage != null && lstPage.size() > 0){
                PageVO objPage = lstPage.get(NumberConstant.ZERO);
                List<PageActionVO> lstPageAction = objPage.queryList(String.format("pageActionVOList[methodOption[actionType='%s']]", actionType), PageActionVO.class);
                for (PageActionVO objPageAction : lstPageAction) {
                    // 获取直接使用pageAction的layout，并存入layoutVOMap中。
                    this.handleLayoutVOPage(objLayoutMap, objPageAction, objPage);
                    // 获取在pageAction的关联的layoutVO，并存放到layoutVOMap中 。典型使用场景：reloadGridData
                    this.handleActionRelationGridId(objLayoutMap, objPageAction, objPage);
                    // 获取使用pageAction为列渲染函数(render属性)的grid、editableGrid，并存放到layoutVOMap中。
                    this.handleGridRenderAction(objLayoutMap, objPageAction, objPage);
                }
            }
            objResult.put("result", NumberConstant.ONE);
            objResult.put("message", "查询成功！");
            List<LayoutVO> lstLayout = new ArrayList<LayoutVO>();  
            Iterator objIterator = objLayoutMap.keySet().iterator();  
            while (objIterator.hasNext()) {  
                lstLayout.add(objLayoutMap.get(objIterator.next()));  
            }  
            objResult.put("dataList", lstLayout);
        } catch (OperateException e) {
            String strMsg = "根据行为类型，获取页面对应的自定义行为对象，再根据该行为查找绑定了该行为的控件对象时，报后台错误！";
            objResult.put("result", NumberConstant.MINUS_ONE);
            objResult.put("message", strMsg);
            logger.error(strMsg, e);
        }
       return objResult;
    }
}
