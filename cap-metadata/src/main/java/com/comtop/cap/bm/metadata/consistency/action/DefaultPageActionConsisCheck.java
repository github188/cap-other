/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.consistency.action;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.comtop.cap.bm.metadata.base.consistency.ConsistencyCheckUtil;
import com.comtop.cap.bm.metadata.base.consistency.ConsistencyException;
import com.comtop.cap.bm.metadata.base.consistency.model.ConsistencyCheckResult;
import com.comtop.cap.bm.metadata.base.consistency.model.FieldConsistencyConfigVO;
import com.comtop.cap.bm.metadata.consistency.ConsistencyResultAttrName;
import com.comtop.cap.bm.metadata.entity.model.EntityAttributeVO;
import com.comtop.cap.bm.metadata.entity.model.MethodVO;
import com.comtop.cap.bm.metadata.page.actionlibrary.model.ActionDefineVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageActionVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.cap.bm.metadata.page.uilibrary.model.PropertyVO;
import com.comtop.cip.jodd.util.StringUtil;

/**
 * 控件属性一致性校验
 * 
 * @author 罗珍明
 *
 */
public class DefaultPageActionConsisCheck implements IPageActionConsisCheck {
    
    @Override
    public List<ConsistencyCheckResult> checkPageActionConsis(ActionDefineVO comp, PageActionVO data, PageVO root) {
        List<PropertyVO> lstProperties = comp.getProperties();
        List<ConsistencyCheckResult> objList = new ArrayList<ConsistencyCheckResult>();
        if (lstProperties == null || lstProperties.isEmpty()) {
            return objList;
        }
        Object objProValue;
        for (PropertyVO propertyVO : lstProperties) {
            objProValue = data.getMethodOption().get(propertyVO.getEname());
            if (objProValue == null) {
                continue;
            }
            List<ConsistencyCheckResult> objRes = checkPropertyConsistency(comp, propertyVO, data, root);
            if (objRes != null) {
                objList.addAll(objRes);
            }
        }
        return objList;
    }
    
    /**
     * 检查行为属性的一致性性
     * 
     * @param comp 行为模板定义
     * @param propertyVO 行为属性
     * @param data 页面行为
     * @param root 页面对象
     * @return 校验结果
     */
    protected List<ConsistencyCheckResult> checkPropertyConsistency(ActionDefineVO comp, PropertyVO propertyVO,
        PageActionVO data, PageVO root) {
        FieldConsistencyConfigVO objConfigVO;
        objConfigVO = propertyVO.getConsistencyConfig();
        if (objConfigVO == null || objConfigVO.getCheckConsistency() == null
            || !objConfigVO.getCheckConsistency().booleanValue()) {
            return new ArrayList<ConsistencyCheckResult>(0);
        }
        
        return checkPropertyConsistencyByConfig(comp, propertyVO, data, root);
    }
    
    /**
     * 
     * @param com 控件定义对象
     * @param propertyVO 控件属性
     * @param data 布局独享
     * @param root 页面对象
     * @return 校验结果
     */
    private List<ConsistencyCheckResult> checkPropertyConsistencyByConfig(ActionDefineVO com, PropertyVO propertyVO,
        PageActionVO data, PageVO root) {
        
        String strCheckClass = propertyVO.getConsistencyConfig().getCheckClass();
        String strExpr = propertyVO.getConsistencyConfig().getExpression();
        List<ConsistencyCheckResult> lstRes = new ArrayList<ConsistencyCheckResult>();
        if (StringUtil.isNotBlank(strCheckClass)) {
            ConsistencyCheckResult objRes = checkPropertyConsistencyWithClass(com, propertyVO, data, root);
            if (objRes != null) {
                lstRes.add(objRes);
            }
        } else if (StringUtil.isNotBlank(strExpr)) {
            ConsistencyCheckResult objRes = checkPropertyConsistencyWithExpr(com, propertyVO, data, root);
            if (objRes != null) {
                lstRes.add(objRes);
            }
        } else {
            throw new ConsistencyException(com.getModelId() + "的属性：" + propertyVO.getConsistencyConfig().getFieldName()
                + "配置的一致性校验信息错误，checkClass,expression都为空");
        }
        return lstRes;
    }
    
    /**
     * @param com 控件定义对象
     * @param propertyVO 属性信息
     * @param data 布局对象
     * @param root 页面对象
     * @return 校验结果
     */
    private ConsistencyCheckResult checkPropertyConsistencyWithExpr(ActionDefineVO com, PropertyVO propertyVO,
        PageActionVO data, PageVO root) {
        
        Object objProValue = data.getMethodOption().get(propertyVO.getEname());
        
        if (ConsistencyCheckUtil.executeExpression(root, propertyVO.getConsistencyConfig().getExpression(), propertyVO
            .getConsistencyConfig().getCheckScope(), objProValue)) {
            return null;
        }
        ConsistencyCheckResult obj = new ConsistencyCheckResult();
        
        obj.setMessage(createMessage(com, propertyVO.getConsistencyConfig().getFieldName(), objProValue, data));
        
        obj.setAttrMap(createLayoutPropertyAttrMap(root, data, propertyVO));
        
        return obj;
    }
    
    /**
     * @param com 控件定义
     * @param field 属性
     * @param value 属性值
     * @param data layout对象
     * @return 返回消息
     */
    private String createMessage(ActionDefineVO com, String field, Object value, PageActionVO data) {
        StringBuffer sb = new StringBuffer();
        sb.append("页面行为");
        sb.append(data.getEname());
        sb.append("的属性");
        sb.append(field);
        sb.append("关联的对象");
        sb.append(value);
        sb.append("不存在");
        return sb.toString();
    }
    
    /**
     * 
     * @param root 页面对象
     * @param data 布局
     * @param propertyVO 属性校验信息
     * @return 校验结果所需参数
     */
    private Map<String, String> createLayoutPropertyAttrMap(PageVO root, PageActionVO data, PropertyVO propertyVO) {
        Map<String, String> objAttrMap = new HashMap<String, String>();
        objAttrMap.put(ConsistencyResultAttrName.PAGE_ATTRNAME_PK.getValue(), root.getModelId());
        objAttrMap.put(ConsistencyResultAttrName.PAGE_ACTION_ATTRNAME_PK.getValue(), data.getPageActionId());
        objAttrMap.put(ConsistencyResultAttrName.PAGE_ACTION_ATTRNAME_ACTION_PRO.getValue(), propertyVO
            .getConsistencyConfig().getFieldName());
        return objAttrMap;
    }
    
    /**
     * @param com 控件定义对象
     * @param propertyVO 属性信息
     * @param data 布局独享
     * @param root 页面对象
     * @return 校验结果
     */
    private ConsistencyCheckResult checkPropertyConsistencyWithClass(ActionDefineVO com, PropertyVO propertyVO,
        PageActionVO data, PageVO root) {
        String strPropertyCheckClass = propertyVO.getConsistencyConfig().getCheckClass();
        IActionProperyConsisCheck obj = ConsistencyCheckUtil.getConsistencyCheck(strPropertyCheckClass,
            IActionProperyConsisCheck.class);
        if (obj == null) {
            return null;
        }
        return obj.checkPropertyValueConsis(com, propertyVO, data, root);
    }
    
    @Override
    public List<ConsistencyCheckResult> checkPageActionDependOnEntityAttr(ActionDefineVO comp,
        List<EntityAttributeVO> entityAttrs, PageActionVO data, PageVO root) {
        List<ConsistencyCheckResult> lstRes = new ArrayList<ConsistencyCheckResult>();
        List<PropertyVO> lstProperty = comp.getProperties();
        for (PropertyVO objPropertyVO : lstProperty) {
            if (objPropertyVO.getConsistencyConfig() == null) {
                continue;
            }
            String strPropertyCheckClass = objPropertyVO.getConsistencyConfig().getCheckClass();
            IActionProperyConsisCheck objCheck = ConsistencyCheckUtil.getConsistencyCheck(strPropertyCheckClass,
                IActionProperyConsisCheck.class);
            if (objCheck == null) {
                continue;
            }
            ConsistencyCheckResult objRes = objCheck.checkPageActionDependOnEntityAttr(comp, entityAttrs,
                objPropertyVO, data, root);
            if (objRes != null) {
                lstRes.add(objRes);
            }
        }
        return lstRes;
    }
    
    @Override
    public List<ConsistencyCheckResult> checkPageActionDependOnEntityMethod(ActionDefineVO actionDefine,
        List<MethodVO> entityMethods, PageActionVO data, PageVO root) {
        List<ConsistencyCheckResult> lstRes = new ArrayList<ConsistencyCheckResult>();
        if (data.getMethodOption() == null || data.getMethodOption().isEmpty()
            || StringUtil.isBlank(data.getMethodTemplate()) || actionDefine == null) {
            return lstRes;
        }
        FieldConsistencyConfigVO objFieldConsisConfigVO = actionDefine.getConsistencyConfig();
        if (objFieldConsisConfigVO != null && objFieldConsisConfigVO.getCheckConsistency() != null
            && objFieldConsisConfigVO.getCheckConsistency().booleanValue()) {
            List<PropertyVO> lstProperty = actionDefine.getProperties();
            for (PropertyVO objPropertyVO : lstProperty) {
                if (objPropertyVO.getConsistencyConfig() != null) {
                    String strPropertyCheckClass = objPropertyVO.getConsistencyConfig().getCheckClass();
                    IActionProperyConsisCheck objCheck = ConsistencyCheckUtil.getConsistencyCheck(
                        strPropertyCheckClass, IActionProperyConsisCheck.class);
                    if (objCheck == null) {
                        continue;
                    }
                    ConsistencyCheckResult objRes = objCheck.checkPageActionDependOnEntityMethod(entityMethods,
                        objPropertyVO, data, root);
                    if (objRes != null) {
                        lstRes.add(objRes);
                    }
                }
            }
        }
        return lstRes;
    }
}
