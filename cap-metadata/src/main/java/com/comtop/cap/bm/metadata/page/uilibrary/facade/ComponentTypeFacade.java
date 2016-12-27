/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.uilibrary.facade;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.comtop.cap.bm.metadata.base.facade.CapBmBaseFacade;
import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.page.uilibrary.model.ComponentSubTypeVO;
import com.comtop.cap.bm.metadata.page.uilibrary.model.ComponentTypeVO;
import com.comtop.cap.bm.metadata.page.uilibrary.model.ComponentVO;
import com.comtop.cap.bm.metadata.page.uilibrary.model.EventVO;
import com.comtop.cap.bm.metadata.page.uilibrary.model.PropertyVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;

/**
 * 控件类型模型facade类
 *
 * @author 诸焕辉
 * @version jdk1.5
 * @version 2015-5-22 诸焕辉
 */
@DwrProxy
@PetiteBean
public class ComponentTypeFacade extends CapBmBaseFacade {
    
    /**
     * 组件facade
     */
    @PetiteInject
    private ComponentFacade componentFacade;
    
    /**
     * 加载模型文件
     *
     * @return 操作结果
     * @throws OperateException xml操作异常
     */
    @RemoteMethod
    public List<Map<String, Object>> queryList() throws OperateException {
        List<Map<String, Object>> lstComponentType = null;
        // 获取控件分类对象
        ComponentTypeVO objComponentTypeVO = (ComponentTypeVO) CacheOperator.readById(ComponentTypeVO.getDefaultModelId());
        if (objComponentTypeVO != null) {
            List<ComponentSubTypeVO> lstSubTypeVO = objComponentTypeVO.getType();
            lstComponentType = transformComponentType(lstSubTypeVO, null, false);
        }
        return lstComponentType;
    }
    
    /**
     * 加载模型文件
     * 
     * @param useRange 使用范围
     * @param isDelEmptyFolder 是否剔除掉空目录
     * @return 操作结果
     * @throws OperateException xml操作异常
     */
    @RemoteMethod
    public List<Map<String, Object>> queryListByUseRange(String[] useRange, Boolean isDelEmptyFolder) throws OperateException {
        List<Map<String, Object>> lstComponentType = null;
        // 获取控件分类对象
        ComponentTypeVO objComponentTypeVO = (ComponentTypeVO) CacheOperator.readById("uilibrary.componentType.type");
        if (objComponentTypeVO != null) {
            List<ComponentSubTypeVO> lstSubTypeVO = objComponentTypeVO.getType();
            lstComponentType = transformComponentType(lstSubTypeVO, useRange, isDelEmptyFolder);
        }
        return lstComponentType;
    }
    
    /**
     * 编译控件分类
     * 
     * @param lstSubTypeVO 子分类
     * @param useRange 使用范围
     * @param isDelEmptyFolder 是否剔除掉空目录
     * @return 集合
     * @throws OperateException 操作异常
     */
    @SuppressWarnings("unchecked")
    private List<Map<String, Object>> transformComponentType(List<ComponentSubTypeVO> lstSubTypeVO, String[] useRange, Boolean isDelEmptyFolder)
        throws OperateException {
        // 遍历控件分类
        List<Map<String, Object>> lstComponentType = new ArrayList<Map<String, Object>>();
        if (lstSubTypeVO != null && lstSubTypeVO.size() > 0) {
            for (ComponentSubTypeVO objSubTypeVO : lstSubTypeVO) {
                Map<String, Object> objMap = convertComponentTypeView(objSubTypeVO, useRange, isDelEmptyFolder);
                if(isDelEmptyFolder != null && isDelEmptyFolder == true 
                    && ((Boolean) objMap.get("isFolder")) == true 
                    && ((List<ComponentVO>)objMap.get("children")).size() == 0){
                    continue;
                }
                lstComponentType.add(objMap);
            }
        }
        return lstComponentType;
    }
    
    /**
     * 转换单个组件节点VO对象成视图中的树节点VO
     * 
     * @param objSubTypeVO 子分类VO
     * @param useRange 使用范围
     * @param isDelEmptyFolder 是否剔除掉空目录
     * @return 控件集合
     * @throws OperateException 操作异常
     */
    @SuppressWarnings("unchecked")
    private Map<String, Object> convertComponentTypeView(ComponentSubTypeVO objSubTypeVO, String[] useRange, Boolean isDelEmptyFolder) throws OperateException {
        // {title:"基础控件", children:[{text:"文字",uiType:"Label",}, {text:"按钮",uiType:"Button"}]}
        Map<String, Object> objType = new HashMap<String, Object>();
        String strComponentType = objSubTypeVO.getTypeCode();
        List<ComponentSubTypeVO> lstSubTypeVO = objSubTypeVO.getSubType();
        // [{text:"文字",uiType:"Label"},{text:"按钮",uiType:"Button"}]
        List<Map<String, Object>> lstComponent = new ArrayList<Map<String, Object>>();
        if (lstSubTypeVO != null && lstSubTypeVO.size() > 0) {
            for (ComponentSubTypeVO objSubType : lstSubTypeVO) {
                // 查找子目录，将当前父目录code与配置中子目录code拼接，如node1节点下有子节点node2，则node2的code为node1.node2
                objSubType.setTypeCode(strComponentType + "." + objSubType.getTypeCode());
                Map<String, Object> objViewMap = convertComponentTypeView(objSubType, useRange, isDelEmptyFolder);
                if(isDelEmptyFolder != null && isDelEmptyFolder == true 
                    && ((Boolean) objViewMap.get("isFolder")) == true 
                    && ((List<ComponentVO>)objViewMap.get("children")).size() == 0){
                    continue;
                }
                lstComponent.add(objViewMap);
            }
        }
        StringBuffer strModelPackage = new StringBuffer();
        if(useRange != null && useRange.length > 0){
            for (int i = 0, len = useRange.length; i < len; i++) {
                if("dev".equals(useRange[i])){
                    strModelPackage.append("uicomponent.");
                } else {
                    strModelPackage.append(useRange[i]).append(".uicomponent.");
                }
                strModelPackage.append(strComponentType);
                if(i < len - 1){
                    strModelPackage.append("|");
                }
            }
        }
        // 获取控件集合
        List<ComponentVO> lstComponentVO = componentFacade.queryList(strModelPackage.toString() + "/component");
        Collections.sort(lstComponentVO, new Comparator<ComponentVO>() {
            
            @Override
            public int compare(ComponentVO arg0, ComponentVO arg1) {
                return arg0.getSort().compareTo(arg1.getSort());
            }
        });
        // {text:"文字",uiType:"Label"}
        for (ComponentVO objComponentVO : lstComponentVO) {
            if(objComponentVO.getDisable() == true){
                continue;
            }
            String strGroup = objComponentVO.getGroup();
            if (strGroup != null && strGroup.equals(strComponentType)) {
                String strUiType = null;
                List<PropertyVO> lstPropertyVO = objComponentVO.getProperties();
                // 获取控件类型
                for (PropertyVO objPropertyVO : lstPropertyVO) {
                    if ("uitype".equals(objPropertyVO.getEname())) {
                        strUiType = objPropertyVO.getDefaultValue();
                        break;
                    }
                }
                Map<String, Object> objComponent = new HashMap<String, Object>();
                objComponent.put("text", objComponentVO.getCname());
                objComponent.put("uiType", strUiType);
                objComponent.put("componentModelId", objComponentVO.getModelId());
                objComponent.put("options", this.initOptions(objComponentVO));
                objComponent.put("propertiesType", this.initPropertiesType(lstPropertyVO));
                objComponent.put("componentVo", objComponentVO);
                lstComponent.add(objComponent);
            }
        }
        
        objType.put("componentType", strComponentType);
        objType.put("title", objSubTypeVO.getTypeName());
        objType.put("isFolder", true);
        objType.put("children", lstComponent);
        return objType;
    }
    
    /**
     * 初始化LayoutVo对象中的options、objectOptions对象
     * 
     * @param model 控件对象
     * @return 操作结果
     */
    private Map<String, Object> initOptions(ComponentVO model) {
        Map<String, Object> objOptions = new HashMap<String, Object>();
        List<PropertyVO> lstProperties = model.getProperties();
        List<EventVO> lstEvents = model.getEvents();
        // 获取有默认值的控件属性值
        for (PropertyVO objPropertyVO : lstProperties) {
            String strDefaultValue = objPropertyVO.getDefaultValue();
            if (strDefaultValue != null && !"".equals(strDefaultValue)) {
                objOptions.put(objPropertyVO.getEname(), strDefaultValue.trim());
            }
        }
        // 获取有默认值的控件事件行为值
        for (EventVO objEventVO : lstEvents) {
            String strDefaultValue = objEventVO.getDefaultValue();
            // hasAutoCreate：false表示系统内置行为、true表示是需要创建行为对象，默认值不在此赋值
            if (objEventVO.getHasAutoCreate() == false && strDefaultValue != null && !"".equals(strDefaultValue)) {
                objOptions.put(objEventVO.getEname(), strDefaultValue.trim());
                objOptions.put(objEventVO.getEname() + "_id", strDefaultValue.trim());
            }
        }
        return objOptions;
    }
    
    /**
     *
     * 获取控件属性是Json类型的，根据控件类型封装在map中
     *
     * @param lstProperties 属性列表
     * @return 属性类型Map
     */
    private Map<String, String> initPropertiesType(List<PropertyVO> lstProperties) {
        Map<String, String> objKeyMap = new HashMap<String, String>();
        for (PropertyVO objPropertyVO : lstProperties) {
            objKeyMap.put(objPropertyVO.getEname(), objPropertyVO.getType());
        }
        return objKeyMap;
    }

}
