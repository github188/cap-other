/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.consistency.component;

import java.util.ArrayList;
import java.util.List;

import com.comtop.cap.bm.metadata.base.consistency.ConsistencyCheckUtil;
import com.comtop.cap.bm.metadata.base.consistency.ConsistencyException;
import com.comtop.cap.bm.metadata.base.consistency.model.ConsistencyCheckResult;
import com.comtop.cap.bm.metadata.base.consistency.model.FieldConsistencyConfigVO;
import com.comtop.cap.bm.metadata.consistency.IComponentConsisCheck;
import com.comtop.cap.bm.metadata.entity.model.EntityAttributeVO;
import com.comtop.cap.bm.metadata.page.desinger.model.DataStoreVO;
import com.comtop.cap.bm.metadata.page.desinger.model.LayoutVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.cap.bm.metadata.page.uilibrary.model.ComponentVO;
import com.comtop.cap.bm.metadata.page.uilibrary.model.EventVO;
import com.comtop.cap.bm.metadata.page.uilibrary.model.PropertyVO;
import com.comtop.cip.jodd.util.StringUtil;

/**
 * 控件属性一致性校验
 * 
 * @author 罗珍明
 *
 */
public class DefaultComponentConsisCheck implements IComponentConsisCheck {
    
    /** 默认的控件校验类处理类名称 */
    public static String DEFAULT_COMPONENT_ATTR_CONSISCHECK_CLASS = "com.comtop.cap.bm.metadata.consistency.component.attribute.DefaultComponentAttrConsisCheck";
    
    /** 控件行为校验类处理类名称 */
    public static String ACTION_COMPONENT_ATTR_CONSISCHECK_CLASS = "com.comtop.cap.bm.metadata.consistency.component.attribute.ActionComponentAttrConsisCheck";
    
    /** 控件属性校验类处理类名称 */
    public static String DATASTORE_COMPONENT_ATTR_CONSISCHECK_CLASS = "com.comtop.cap.bm.metadata.consistency.component.attribute.DataStoreComponentAttrConsisCheck";
    
    /**
     * 校验控件属性的值的一致性
     * 
     * @param properties 控件属性集合
     * @param data 控件对应的布局对象
     * @param root page对象
     * @return 校验结果
     */
    @Override
    public List<ConsistencyCheckResult> checkPropertyValueConsis(ComponentVO com, List<PropertyVO> properties,
        LayoutVO data, PageVO root) {
        List<ConsistencyCheckResult> objList = new ArrayList<ConsistencyCheckResult>();
        if (properties == null || properties.isEmpty()) {
            return objList;
        }
        Object objProValue = null;
        for (PropertyVO propertyVO : properties) {
            objProValue = data.getOptions().get(propertyVO.getEname());
            if (objProValue == null) {
                continue;
            }
            ConsistencyCheckResult objRes = this.checkPropertyConsistency(com, propertyVO, data, root);
            if (objRes != null) {
                objList.add(objRes);
            }
        }
        return objList;
    }
    
    /***
     * 校验单个属性一致性
     * 
     * @param com 控件定义信息
     * @param propertyVO 控件属性信息
     * @param data 布局信息
     * @param root 页面信息
     * @return 校验结果
     */
    protected ConsistencyCheckResult checkPropertyConsistency(ComponentVO com, PropertyVO propertyVO, LayoutVO data,
        PageVO root) {
        FieldConsistencyConfigVO objConfigVO = propertyVO.getConsistencyConfig();
        if (objConfigVO == null || objConfigVO.getCheckConsistency() == null
            || !objConfigVO.getCheckConsistency().booleanValue()) {
            return null;
        }
        return this.checkPropertyConsistencyByConfig(com, propertyVO, data, root);
    }
    
    /**
     * 根据控件属性配置的校验方式进行校验
     * 
     * @param com 控件定义对象
     * @param propertyVO 属性信息
     * @param data 布局独享
     * @param root 页面对象
     * @return 校验结果
     */
    private ConsistencyCheckResult checkPropertyConsistencyByConfig(ComponentVO com, PropertyVO propertyVO,
        LayoutVO data, PageVO root) {
        String strCheckClass = propertyVO.getConsistencyConfig().getCheckClass();
        String strExpr = propertyVO.getConsistencyConfig().getExpression();
        ConsistencyCheckResult objRes = null;
        if (StringUtil.isNotBlank(strCheckClass)) {
            objRes = this.checkPropertyConsistencyWithClass(com, propertyVO, data, root);
        } else if (StringUtil.isNotBlank(strExpr)) {
            IComponentAttrConsisCheck obj = ConsistencyCheckUtil.getConsistencyCheck(
                DEFAULT_COMPONENT_ATTR_CONSISCHECK_CLASS, IComponentAttrConsisCheck.class);
            if (obj != null) {
                objRes = obj.checkAttrValueConsis(com, propertyVO, data, root);
            }
        } else {
            throw new ConsistencyException(com.getModelId() + "的属性：" + propertyVO.getConsistencyConfig().getFieldName()
                + "配置的一致性校验信息错误，checkClass、expression都为空");
        }
        return objRes;
    }
    
    /**
     * 根据控件属性校验类型进行校验
     * 
     * @param com 控件定义对象
     * @param propertyVO 属性校验信息
     * @param data 布局独享
     * @param root 页面对象
     * @return 校验结果
     */
    private ConsistencyCheckResult checkPropertyConsistencyWithClass(ComponentVO com, PropertyVO propertyVO,
        LayoutVO data, PageVO root) {
        String strPropertyCheckClass = propertyVO.getConsistencyConfig().getCheckClass();
        IComponentAttrConsisCheck obj = ConsistencyCheckUtil.getConsistencyCheck(strPropertyCheckClass,
            IComponentAttrConsisCheck.class);
        if (obj == null) {
            return null;
        }
        return obj.checkAttrValueConsis(com, propertyVO, data, root);
    }
    
    @Override
    public List<ConsistencyCheckResult> checkEventValueConsis(ComponentVO com, List<EventVO> eventList, LayoutVO data,
        PageVO root) {
        List<ConsistencyCheckResult> lstRes = new ArrayList<ConsistencyCheckResult>();
        IComponentAttrConsisCheck obj = ConsistencyCheckUtil.getConsistencyCheck(
            ACTION_COMPONENT_ATTR_CONSISCHECK_CLASS, IComponentAttrConsisCheck.class);
        if (eventList == null || eventList.isEmpty() || obj == null) {
            return lstRes;
        }
        ConsistencyCheckResult objRes = null;
        String strFuncName = null;
        for (EventVO eventVO : eventList) {
            strFuncName = (String) data.getOptions().get(eventVO.getEname());
            if (strFuncName == null) {
                continue;
            }
            objRes = obj.checkAttrValueConsis(com, eventVO, data, root);
            if (objRes != null) {
                lstRes.add(objRes);
            }
        }
        return lstRes;
    }
    
    @Override
    public List<ConsistencyCheckResult> checkProValDependOnEntityAttr(ComponentVO comp,
        List<EntityAttributeVO> entityAttrs, List<DataStoreVO> relationDataStores, LayoutVO data, PageVO page) {
        List<ConsistencyCheckResult> lstRes = new ArrayList<ConsistencyCheckResult>();
        IComponentAttrConsisCheck objCheck = ConsistencyCheckUtil.getConsistencyCheck(
            DATASTORE_COMPONENT_ATTR_CONSISCHECK_CLASS, IComponentAttrConsisCheck.class);
        if (objCheck == null) {
            return lstRes;
        }
        for (PropertyVO objPropertyVO : comp.getProperties()) {
            FieldConsistencyConfigVO objFieldConsisConfigVO = objPropertyVO.getConsistencyConfig();
            if (objFieldConsisConfigVO != null && objFieldConsisConfigVO.getCheckConsistency().booleanValue()
                && DATASTORE_COMPONENT_ATTR_CONSISCHECK_CLASS.equals(objFieldConsisConfigVO.getCheckClass())) {
                ConsistencyCheckResult objRes = objCheck.checkAttrValueDependOnEntityAttr(objPropertyVO, entityAttrs,
                    relationDataStores, data, page);
                if (objRes != null) {
                    lstRes.add(objRes);
                }
            }
        }
        return lstRes;
    }
}
