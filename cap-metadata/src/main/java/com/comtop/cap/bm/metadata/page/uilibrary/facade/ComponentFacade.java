/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.uilibrary.facade;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.base.facade.CapBmBaseFacade;
import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.common.storage.exception.ValidateException;
import com.comtop.cap.bm.metadata.page.desinger.model.LayoutVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.cap.bm.metadata.page.uilibrary.model.ComponentVO;
import com.comtop.cap.bm.metadata.page.uilibrary.model.EventVO;
import com.comtop.cap.bm.metadata.page.uilibrary.model.PropertyVO;
import com.comtop.cip.common.validator.ValidateResult;
import com.comtop.cip.common.validator.ValidatorUtil;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.json.JSONObject;
import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;

/**
 * 控件模型facade类
 *
 * @author 郑重
 * @version jdk1.5
 * @version 2015-5-12 郑重
 */
@DwrProxy
@PetiteBean
public class ComponentFacade extends CapBmBaseFacade {
    
    /** 把控件属性类型为json的属性按控件类型（uitype）和控件模型Id（modelId）分组封装到map对象中 */
    private static Map<String, Map<String, Map<String, Boolean>>> jsonKeys = new HashMap<String, Map<String, Map<String, Boolean>>>();
    
    /** 日志 */
    private final static Logger logger = LoggerFactory.getLogger(ComponentFacade.class);
    
    /** 所有控件校验规则 */
    private static Map<String, Map<String, Object>> componentValidRuleList = new HashMap<String, Map<String, Object>>();
    
    /** 运行时可用的控件属性按控件类型（uitype）和控件模型Id（modelId）分组封装到map对象中（非设计器添加的属性） */
    private static Map<String, Map<String, List<String>>> runtimeAvailableAttrs = new HashMap<String, Map<String, List<String>>>();
    
    /**
     * 加载模型文件
     *
     * @param id 控件模型ID
     * @return 操作结果
     */
    @RemoteMethod
    public ComponentVO loadModel(String id) {
        ComponentVO objComponentVO = null;
        if (StringUtils.isNotBlank(id)) {
            objComponentVO = (ComponentVO) CacheOperator.readById(id);
        }
        return objComponentVO;
    }
    
    /**
     * 验证VO对象
     *
     * @param model 被校验对象
     * @return 结果集
     */
    @SuppressWarnings("rawtypes")
    @RemoteMethod
    public ValidateResult validate(ComponentVO model) {
        
        return ValidatorUtil.validate(model);
    }
    
    /**
     * 保存
     *
     * @param model 被保存的对象
     * @return 是否成功
     * @throws ValidateException 异常
     */
    @RemoteMethod
    public boolean saveModel(ComponentVO model) throws ValidateException {
        if (StringUtils.isBlank(model.getModelId())) {
            model.setModelId(model.getModelPackage() + "." + model.getModelType() + "."
                + StringUtils.uncapitalize(model.getModelName()));
        }
        return model.saveModel();
    }
    
    /**
     * 删除模型
     *
     * @param model 被删除的对象
     * @return 是否成功
     * @throws OperateException 异常
     */
    @RemoteMethod
    public boolean deleteModel(ComponentVO model) throws OperateException {
        if (isComponentUsed(model.getModelId())) {
            return false;
        }
        return model.deleteModel();
    }
    
    /**
     * 删除控件
     *
     * @param modelIds 控件Id集合
     * @return 未删除成功的控件Id
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public List<String> deleteList(String[] modelIds) throws OperateException {
        if (modelIds == null) {
            return null;
        }
        List<String> lstRet = new ArrayList<String>();
        List<PageVO> lstPageVO = CacheOperator.queryList("/page", PageVO.class);
        for (String strModelId : modelIds) {
            if (isComponentUsed(strModelId, lstPageVO)) {
                lstRet.add(strModelId);
                continue;
            }
            boolean bRet = CacheOperator.delete(strModelId);
            if (!bRet) {
                lstRet.add(strModelId);
            }
        }
        return lstRet;
    }
    
    /**
     * 控件是否被引用
     *
     * @param componentId 控件Id
     * @return 是否被引用
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public boolean isComponentUsed(String componentId) throws OperateException {
        List<PageVO> lstPageVO = CacheOperator.queryList("/page", PageVO.class);
        for (PageVO objPageVO : lstPageVO) {
            LayoutVO objLayout = objPageVO.getLayoutVO();
            if (contain(objLayout, componentId)) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * 控件是否被引用
     *
     * @param componentId 控件Id
     * @param lstPageVO lstPageVO
     * @return 是否被引用
     */
    private boolean isComponentUsed(String componentId, List<PageVO> lstPageVO) {
        for (PageVO objPageVO : lstPageVO) {
            LayoutVO objLayout = objPageVO.getLayoutVO();
            if (contain(objLayout, componentId)) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * 判断是否存在相同的控件
     *
     * <pre>
     * 
     * </pre>
     * 
     * @param modelName 行为名称
     * @return true
     * @throws OperateException OperateException
     */
    @RemoteMethod
    public boolean isExistSameComponent(String modelName) throws OperateException {
        boolean bResult = false;
        String strActionId = "uicomponent.custom.component." + modelName;
        String strExpression = "component[contains(modelPackage,'uicomponent.custom')]";
        List<ComponentVO> lstComponentVO = this.queryList(strExpression);
        for (ComponentVO objComponentVO : lstComponentVO) {
            String strModelId = objComponentVO.getModelId();
            if (strModelId.equals(strActionId)) {
                bResult = true;
                break;
            }
        }
        return bResult;
    }
    
    /**
     * 界面是否包含该控件
     *
     * @param layout layout
     * @param componentId 控件Id
     * @return 是否包含该控件
     */
    private boolean contain(LayoutVO layout, String componentId) {
        if (layout == null) {
            return false;
        }
        if (componentId.equals(layout.getComponentModelId())) {
            return true;
        }
        List<LayoutVO> lstLayouts = layout.getChildren();
        if (lstLayouts == null) {
            return false;
        }
        for (LayoutVO objLayout : lstLayouts) {
            if (contain(objLayout, componentId)) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * 根据表达式查找属性对象
     *
     * @param id 控件模型ID
     * @param expression 表达式
     * @return 查询结果集
     * @throws OperateException 对象操作异常
     */
    @RemoteMethod
    public PropertyVO query(String id, String expression) throws OperateException {
        ComponentVO objComponentVO = (ComponentVO) CacheOperator.readById(id);
        PropertyVO objPropertyVO = (PropertyVO) objComponentVO.query(expression);
        return objPropertyVO;
    }
    
    /**
     * 根据表达式，获取控件模型
     *
     * @param expression 表达式
     * @return 组件集合
     * @throws OperateException 异常
     */
    @SuppressWarnings("unchecked")
    @RemoteMethod
    public List<ComponentVO> queryList(String expression) throws OperateException {
        List<ComponentVO> lstComponentVO = CacheOperator.queryList(expression);
        return lstComponentVO;
    }
    
    /**
     * 根据modelId获取控件对象
     *
     * @param modelId id
     * @return 组件集合
     * @throws OperateException 异常
     */
    @RemoteMethod
    public ComponentVO readComponent(String modelId) throws OperateException {
        ComponentVO objComponentVO = (ComponentVO) CacheOperator.read(modelId);
        return objComponentVO;
    }
    
    /**
     * 获取控件模型
     * 
     * @return 组件集合
     * @throws OperateException xml解析异常
     */
    @SuppressWarnings("unchecked")
    public Map<String, ComponentVO> queryList() throws OperateException {
        Map<String, ComponentVO> objParam = new HashMap<String, ComponentVO>();
        List<ComponentVO> lstComponentVO = CacheOperator.queryList("component");
        for (ComponentVO objComponentVO : lstComponentVO) {
            objParam.put(objComponentVO.getModelId(), objComponentVO);
        }
        return objParam;
    }
    
    /**
     *
     * 获取控件属性是Json类型的，根据控件类型封装在map中
     *
     * @return Map
     */
    @SuppressWarnings("unchecked")
    public Map<String, Map<String, Map<String, Boolean>>> queryListByProJsonType() {
        Map<String, Map<String, Boolean>> objJsonKeys4cmp = new HashMap<String, Map<String, Boolean>>();
        Map<String, Map<String, Boolean>> objJsonKeys4UI = new HashMap<String, Map<String, Boolean>>();
        try {
            List<ComponentVO> lstComponentVO = CacheOperator.queryList("component");
            for (ComponentVO objComponentVO : lstComponentVO) {
                Map<String, Boolean> objKeyMap = new HashMap<String, Boolean>();
                // 属性
                List<PropertyVO> lstProperties = objComponentVO.getProperties();
                for (PropertyVO objPropertyVO : lstProperties) {
                    String strKey = objPropertyVO.getEname();
                    if ("Json".equalsIgnoreCase(objPropertyVO.getType())) {
                        objKeyMap.put(strKey, true);
                    }
                }
                // 事件
                List<EventVO> lstEvents = objComponentVO.getEvents();
                for (EventVO objEventVO : lstEvents) {
                    String strKey = objEventVO.getEname();
                    objKeyMap.put(strKey, true);
                }
                objJsonKeys4cmp.put(objComponentVO.getModelId(), objKeyMap);
                if (objComponentVO.getLayoutTypeList().size() > 0) {
                    PropertyVO objUItypeProVO = (PropertyVO) objComponentVO.query("properties[ename='uitype']");
                    objJsonKeys4UI.put(objUItypeProVO.getDefaultValue(), objKeyMap);
                }
            }
        } catch (Exception e) {
            logger.error("根据控件类型，把属性是json类型的封装在map中出错", e);
        }
        jsonKeys.put("modelId", objJsonKeys4cmp);
        jsonKeys.put("uitype", objJsonKeys4UI);
        return jsonKeys;
    }
    
    /**
     * 根据布局类型，获取所有控件名称
     * 
     * @param layoutType 布局类型
     * @param useRange 使用范围(CAP建模类型，开发建模：dev、需求建模：req)
     * @return 控件名称集合
     * @throws OperateException xml解析异常
     */
    @SuppressWarnings("unchecked")
    @RemoteMethod
    public Map<String, ComponentVO> queryComponentList(String layoutType, String[] useRange) throws OperateException {
        Map<String, ComponentVO> objParam = new HashMap<String, ComponentVO>();
        if (layoutType != null) {
            List<ComponentVO> lstComponentVO = CacheOperator.queryList("component"
                + this.buildModelPackageExpression(useRange));
            for (ComponentVO objComponentVO : lstComponentVO) {
                List<String> lstLayoutType = objComponentVO.getLayoutTypeList();
                for (String strLayoutTypeName : lstLayoutType) {
                    if (layoutType.equals(strLayoutTypeName)) {
                        objParam.put(objComponentVO.getModelId(), objComponentVO);
                    }
                }
            }
        }
        return objParam;
    }
    
    /**
     * 获取所有控件依赖文件信息
     * 
     * @return 所有控件所依赖的文件信息集合
     * @throws OperateException xml解析异常
     */
    @SuppressWarnings("unchecked")
    @RemoteMethod
    public List<String> queryAllComponentDependFiles() throws OperateException {
        List<String> lstDependFilePaths = new ArrayList<String>();
        List<ComponentVO> lstComponentVO = CacheOperator.queryList("component");
        for (ComponentVO objComponentVO : lstComponentVO) {
            lstDependFilePaths.addAll(objComponentVO.getJs());
            lstDependFilePaths.addAll(objComponentVO.getCss());
        }
        return this.removeDuplicate(lstDependFilePaths);
    }
    
    /**
     *
     * 删除重复对象
     *
     * @param list 集合
     * @return 去重后集合
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
    private List<String> removeDuplicate(List<String> list) {
        Set objSet = new HashSet();
        List lstResult = new ArrayList();
        for (Iterator objIter = list.iterator(); objIter.hasNext();) {
            Object objElement = objIter.next();
            if (objSet.add(objElement)) {
                lstResult.add(objElement);
            }
        }
        return lstResult;
    }
    
    /**
     * 所有控件校验规则
     * 
     * @return 控件属性校验集合
     * @throws OperateException 操作异常
     */
    @SuppressWarnings("unchecked")
    @RemoteMethod
    public Map<String, Map<String, Object>> queryAllComponentValidRule() throws OperateException {
        List<ComponentVO> lstComponentVO = CacheOperator.queryList("component");
        for (ComponentVO objComponentVO : lstComponentVO) {
            List<PropertyVO> lstProperties = objComponentVO.getProperties();
            Map<String, Object> objValid = new HashMap<String, Object>();
            for (PropertyVO objPropertyVO : lstProperties) {
                if (objPropertyVO.getHide() != null && objPropertyVO.getHide() == true) {
                    continue;
                }
                String strScript = objPropertyVO.getPropertyEditorUI().getScript();
                JSONObject objJSONObject = (JSONObject) JSONObject.parse(strScript);
                if (objJSONObject.containsKey("validate")) {
                    objValid.put(objPropertyVO.getEname(), objJSONObject.get("validate"));
                }
            }
            componentValidRuleList.put(objComponentVO.getModelId(), objValid);
        }
        return componentValidRuleList;
    }
    
    /**
     * 获取生成代码有用的UI控件属性（非设计器添加进去的属性）
     * 
     * @return 所有控件属性的属性类型集合
     */
    @SuppressWarnings("unchecked")
    public Map<String, Map<String, List<String>>> queryRuntimeAvailableAttrs() {
        Map<String, List<String>> runtimeAvailaAttrs4cmp = new HashMap<String, List<String>>();
        Map<String, List<String>> runtimeAvailaAttrs4UI = new HashMap<String, List<String>>();
        try {
            List<ComponentVO> lstComponentVO = CacheOperator.queryList("component");
            for (ComponentVO objComponentVO : lstComponentVO) {
                List<String> lstSelfAttr = new ArrayList<String>();
                // 属性
                List<PropertyVO> lstProperties = objComponentVO.getProperties();
                for (PropertyVO objPropertyVO : lstProperties) {
                    if (objPropertyVO.getGenerateCodeIgnore() == null || objPropertyVO.getGenerateCodeIgnore() == false) {
                        lstSelfAttr.add(objPropertyVO.getEname());
                    }
                }
                // 事件
                List<EventVO> lstEvents = objComponentVO.getEvents();
                for (EventVO objEventVO : lstEvents) {
                    if (objEventVO.getGenerateCodeIgnore() == null || objEventVO.getGenerateCodeIgnore() == false) {
                        lstSelfAttr.add(objEventVO.getEname());
                    }
                }
                runtimeAvailaAttrs4cmp.put(objComponentVO.getModelId(), lstSelfAttr);
                if (objComponentVO.getLayoutTypeList().size() > 0) {
                    PropertyVO objUItypeProVO = (PropertyVO) objComponentVO.query("properties[ename='uitype']");
                    runtimeAvailaAttrs4UI.put(objUItypeProVO.getDefaultValue(), lstSelfAttr);
                }
            }
        } catch (Exception e) {
            logger.error("通过缓存操作类读取所有控件元数据发生异常", e);
        }
        runtimeAvailableAttrs.put("modelId", runtimeAvailaAttrs4cmp);
        runtimeAvailableAttrs.put("uitype", runtimeAvailaAttrs4UI);
        return runtimeAvailableAttrs;
    }
    
    /**
     * 获取所有输入型控件类型
     * 
     * @param useRange 使用范围(CAP建模类型，开发建模：dev、需求建模：req)
     * @return 输入型控件集合
     */
    @SuppressWarnings("unchecked")
    public List<String> queryInputTypeUItypes(String[] useRange) {
        Set<String> lstInputTypeUItypes = new HashSet<String>();
        try {
            List<PropertyVO> lstPropertyVO = CacheOperator.queryList("component[hasInputType='true']"
                + this.buildModelPackageExpression(useRange) + "/properties[ename='uitype']");
            for (PropertyVO objPropertyVO : lstPropertyVO) {
                lstInputTypeUItypes.add(objPropertyVO.getDefaultValue());
            }
        } catch (OperateException e) {
            logger.error("获取所有输入型控件类型异常！", e);
        }
        return new ArrayList<String>(lstInputTypeUItypes);
    }
    
    /**
     * 根据CAP建模类型，构建模块包表达式
     * 
     * @param useRange 使用范围(CAP建模类型，开发建模：dev、需求建模：req)
     * @return 输入型控件集合
     */
    private String buildModelPackageExpression(String[] useRange) {
        StringBuffer strExp = new StringBuffer();
        if (useRange != null && useRange.length > 0) {
            strExp.append("[");
            for (int i = 0, len = useRange.length; i < len; i++) {
                if ("dev".equals(useRange[i])) {
                    strExp.append("starts-with(modelPackage,'uicomponent')");
                } else {
                    strExp.append("starts-with(modelPackage,'").append(useRange[i]).append(".uicomponent')");
                }
                if (i < len - 1) {
                    strExp.append("|");
                }
            }
            strExp.append("]");
        }
        return strExp.toString();
    }
}
