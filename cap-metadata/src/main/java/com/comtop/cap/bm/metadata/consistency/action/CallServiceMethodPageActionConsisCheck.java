/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.consistency.action;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.bm.metadata.base.consistency.ConsistencyException;
import com.comtop.cap.bm.metadata.base.consistency.model.ConsistencyCheckResult;
import com.comtop.cap.bm.metadata.common.dwr.CapMap;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.consistency.ConsistencyCheckResultType;
import com.comtop.cap.bm.metadata.consistency.ConsistencyResultAttrName;
import com.comtop.cap.bm.metadata.entity.facade.EntityFacade;
import com.comtop.cap.bm.metadata.entity.model.AttributeSourceType;
import com.comtop.cap.bm.metadata.entity.model.DataTypeVO;
import com.comtop.cap.bm.metadata.entity.model.EntityAttributeVO;
import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cap.bm.metadata.entity.model.MethodVO;
import com.comtop.cap.bm.metadata.page.actionlibrary.model.ActionDefineVO;
import com.comtop.cap.bm.metadata.page.desinger.model.DataStoreVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageActionVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageAttributeVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.cap.bm.metadata.page.uilibrary.model.PropertyVO;
import com.comtop.top.core.jodd.AppContext;

/**
 * 行为模版调用后台方法的数据一致性校验
 * 
 * @author 诸焕辉
 * @since jdk1.6
 * @version 2016年6月30日 诸焕辉
 */
public class CallServiceMethodPageActionConsisCheck extends DefaultPageActionConsisCheck {
    
    /**
     * 页面实体facade类
     */
    private final EntityFacade entityFacade = AppContext.getBean(EntityFacade.class);
    
    /**
     * 校验行为模版调用后台方法的校验类
     */
    private static String CALL_SERV_METHOD_PAGE_ACTION_PRO_CHECK = "com.comtop.cap.bm.metadata.consistency.action.property.CallServiceMethodPageActionProConsisCheck";
    
    /**
     * 入参变量
     */
    private static String METHOD_PARAMETER = "methodParameter";
    
    /**
     * 返回值变量
     */
    private static String RETURN_VALUE_BIND = "returnValueBind";
    
    @Override
    public List<ConsistencyCheckResult> checkPageActionConsis(ActionDefineVO comp, PageActionVO data, PageVO root) {
        List<ConsistencyCheckResult> lstRes = super.checkPageActionConsis(comp, data, root);
        // 校验动态属性
        PropertyVO objProperty = null;
        try {
            objProperty = (PropertyVO) comp
                .query("./properties[consistencyConfig[checkConsistency='true' and checkClass='"
                    + CALL_SERV_METHOD_PAGE_ACTION_PRO_CHECK + "']]");
            // 属性是否需要校验
            if (objProperty != null) {
                CapMap objOption = data.getMethodOption();
                String strEname = objProperty.getEname();
                String strValue = (String) objOption.get(strEname);
                if (StringUtils.isNotBlank(strValue)) {
                    String strEntity = (String) objOption.get("entityId");
                    EntityVO objEntity = entityFacade.loadEntity(strEntity, root.getModelPackage());
                    // 关联的实体是否存在
                    if (objEntity == null) {
                        lstRes
                            .add(this.packageCheckResult(root.getModelId(), data.getPageActionId(), strEname, String
                                .format("页面行为%s中的%s属性关联的实体%s不存在，绑定属性%s有误", data.getEname(), strEname, strEntity,
                                    strValue)));
                        return lstRes;
                    }
                    // 入参参数校验
                    String strMethodParameter = (String) objOption.get(METHOD_PARAMETER);
                    if (StringUtils.isBlank(strMethodParameter)) {
                        return lstRes;
                    }
                    String[] strParameters = strMethodParameter.split(",");
                    for (int i = 1, len = strParameters.length; i <= len; i++) {
                        String strParameter = METHOD_PARAMETER + i;
                        ConsistencyCheckResult objRes = this.checkDynamicPropertyConsis(comp, data, root, objEntity,
                            strParameter, (String) objOption.get(strParameter));
                        if (objRes != null) {
                            lstRes.add(objRes);
                        }
                    }
                    // 返回值校验
                    String strReturnValueBind = (String) objOption.get(RETURN_VALUE_BIND);
                    if (StringUtils.isBlank(strReturnValueBind)) {
                        return lstRes;
                    }
                    ConsistencyCheckResult objRes = this.checkDynamicPropertyConsis(comp, data, root, objEntity,
                        RETURN_VALUE_BIND, strReturnValueBind);
                    if (objRes != null) {
                        lstRes.add(objRes);
                    }
                }
            }
        } catch (OperateException e) {
            throw new ConsistencyException("校验行为属性依赖的数据一致性校验出错，校验的是动态属性出错", e);
        }
        return lstRes;
    }
    
    /**
     * 行为模版动态属性数据一致性校验
     * 
     * @param comp 行为模板信息
     * @param data 页面行为
     * @param root page对象
     * @param entityVO 当前关联的实体对象
     * @param attrName 属性名称
     * @param bindValue 值
     * @return 校验结果
     * @throws OperateException 操作异常
     */
    private ConsistencyCheckResult checkDynamicPropertyConsis(ActionDefineVO comp, PageActionVO data, PageVO root,
        EntityVO entityVO, String attrName, String bindValue) throws OperateException {
        ConsistencyCheckResult objRes = null;
        String[] strBind = bindValue.split("\\.");
        String strDatastore = strBind[0];
        String strQueryExp = "./dataStoreVOList[ename='" + strDatastore + "' and (modelType='object' or modelType='list')]";
        DataStoreVO objDataStoreVO = root.query(strQueryExp, DataStoreVO.class);
        // 数据集是否存 pageAttributeVOList
        if (objDataStoreVO == null) {
            String strMsg = null;
            //校验属性是否为页面自定义变量
//            strMsg = "页面行为%s中的%s属性关联的数据集%s不存在";
            if (strBind.length == 1) {
                strQueryExp = "./pageAttributeVOList[attributeName='" + strBind[0] + "']";
                PageAttributeVO objPageAttributeVO = root.query(strQueryExp, PageAttributeVO.class);
                if (objPageAttributeVO == null) {
                    strMsg = "页面行为%s中的%s属性关联的页面参数%s不存在";
                }
            }
            return strMsg  != null ? this.packageCheckResult(root.getModelId(), data.getPageActionId(), attrName,
                String.format(strMsg, data.getEname(), attrName, data.getMethodOption().get("entityId"), bindValue)) : null;
        }
        
        String strAttrName = null;
        for (int i = 1, len = strBind.length; i < len; i++) {
            strAttrName = strBind[i];
            EntityAttributeVO objAttributeVO = entityVO.query("./attributes[engName='" + strAttrName + "']",
                EntityAttributeVO.class);
            if (objAttributeVO == null) {
                return this.packageCheckResult(
                    root.getModelId(),
                    data.getPageActionId(),
                    attrName,
                    String.format("页面行为%s中的%s属性关联的实体%s不存在属性%s", data.getEname(), attrName,
                        data.getMethodOption().get("entityId"), strAttrName));
            }
            if (i == strBind.length - 1) {
                continue;
            }
            if (isPrimitive(objAttributeVO.getAttributeType())) {
                return this.packageCheckResult(root.getModelId(), data.getPageActionId(), attrName, String.format(
                    "页面行为%s中的%s属性关联的实体%s属性%s不存在子属性", data.getEname(), attrName, data.getMethodOption().get("entityId"),
                    strAttrName));
            }
            if (AttributeSourceType.THIRD_PARTY_TYPE.equals(objAttributeVO.getAttributeType().getSource())
                || AttributeSourceType.JAVA_OBJECT.equals(objAttributeVO.getAttributeType().getSource())) {
                break;
            }
            // 关联的第三方实体
            if (AttributeSourceType.ENTITY.equals(objAttributeVO.getAttributeType().getSource())) {
                EntityVO objRelationEntityVO = entityFacade.loadEntity(objAttributeVO.getAttributeType().getValue(),
                    root.getModelPackage());
                if (objRelationEntityVO == null) {
                    return this.packageCheckResult(root.getModelId(), data.getPageActionId(), attrName, String.format(
                        "页面行为%s中的%s属性关联的实体%s属性%s对应的实体%s不存在", data.getEname(), attrName,
                        data.getMethodOption().get("entityId"), strAttrName, objAttributeVO.getAttributeType()
                            .getValue()));
                }
            }
        }
        return objRes;
    }
    
    /**
     * 是否是非关联实体类型
     * 
     * @param dataType 实体属性类型
     * @return true 时基本类型 false 非基本类型
     */
    private boolean isPrimitive(DataTypeVO dataType) {
        return AttributeSourceType.DATA_DICTIONARY.equals(dataType.getSource())
            || AttributeSourceType.PRIMITIVE.equals(dataType.getSource())
            || AttributeSourceType.OTHER_ENTITY_ATTRIBUTE.equals(dataType.getSource())
            || AttributeSourceType.ENUM_TYPE.equals(dataType.getSource());
    }
    
    /**
     * 封装校验信息
     * 
     * @param modelId 元数据模型Id
     * @param pageActionId 行为Id
     * @param attrName 属性名称
     * @param errorMsgTemp 错误信息
     * @return 校验结果
     */
    private ConsistencyCheckResult packageCheckResult(String modelId, String pageActionId, String attrName,
        String errorMsgTemp) {
        ConsistencyCheckResult objRes = new ConsistencyCheckResult();
        objRes.setType(ConsistencyCheckResultType.CONSISTENCY_TYPE_PAGE_ACTION.getValue());
        objRes.setMessage(errorMsgTemp);
        Map<String, String> objAtrrMap = new HashMap<String, String>();
        objAtrrMap.put(ConsistencyResultAttrName.PAGE_ATTRNAME_PK.getValue(), modelId);
        objAtrrMap.put(ConsistencyResultAttrName.PAGE_ACTION_ATTRNAME_PK.getValue(), pageActionId);
        objAtrrMap.put(ConsistencyResultAttrName.PAGE_ACTION_ATTRNAME_ACTION_PRO.getValue(), attrName);
        objRes.setAttrMap(objAtrrMap);
        return objRes;
    }
    
    @Override
    public List<ConsistencyCheckResult> checkPageActionDependOnEntityMethod(ActionDefineVO comp,
        List<MethodVO> entityMethods, PageActionVO data, PageVO root) {
        return super.checkPageActionDependOnEntityMethod(comp, entityMethods, data, root);
    }
    
    @Override
    public List<ConsistencyCheckResult> checkPageActionDependOnEntityAttr(ActionDefineVO comp,
        List<EntityAttributeVO> entityAttrs, PageActionVO data, PageVO root) {
        List<ConsistencyCheckResult> lstRes = super.checkPageActionDependOnEntityAttr(comp, entityAttrs, data, root);
        // 校验动态属性
        PropertyVO objProperty = null;
        try {
            objProperty = (PropertyVO) comp
                .query("./properties[consistencyConfig[checkConsistency='true' and checkClass='"
                    + CALL_SERV_METHOD_PAGE_ACTION_PRO_CHECK + "']]");
            // 属性是否需要校验
            if (objProperty != null) {
                CapMap objOption = data.getMethodOption();
                String strEname = objProperty.getEname();
                String strValue = (String) objOption.get(strEname);
                if (StringUtils.isNotBlank(strValue)) {
                    // 入参参数校验
                    String strMethodParameter = (String) objOption.get(METHOD_PARAMETER);
                    if (StringUtils.isBlank(strMethodParameter)) {
                        return lstRes;
                    }
                    String[] strParameters = strMethodParameter.split(",");
                    for (int i = 1, len = strParameters.length; i <= len; i++) {
                        String strParameter = METHOD_PARAMETER + i;
                        ConsistencyCheckResult objRes = this.checkDynamicProDependOnEntityAttr(comp, data, entityAttrs,
                            strParameter, (String) objOption.get(strParameter), root);
                        if (objRes != null) {
                            lstRes.add(objRes);
                        }
                    }
                    // 返回值校验
                    String strReturnValueBind = (String) objOption.get(RETURN_VALUE_BIND);
                    if (StringUtils.isBlank(strReturnValueBind)) {
                        return lstRes;
                    }
                    ConsistencyCheckResult objRes = this.checkDynamicProDependOnEntityAttr(comp, data, entityAttrs,
                        RETURN_VALUE_BIND, strReturnValueBind, root);
                    if (objRes != null) {
                        lstRes.add(objRes);
                    }
                }
            }
        } catch (OperateException e) {
            throw new ConsistencyException("校验行为属性依赖的数据一致性校验出错，校验的是动态属性出错", e);
        }
        return lstRes;
    }
    
    /**
     * 行为模版动态属性数据一致性校验
     * 
     * @param comp 行为模板信息
     * @param data 页面行为
     * @param entityAttrs 当前关联的实体对象
     * @param attrName 属性名称
     * @param page 页面对象
     * @param bindValue 值
     * @return 校验结果
     * @throws OperateException 操作异常
     */
    private ConsistencyCheckResult checkDynamicProDependOnEntityAttr(ActionDefineVO comp, PageActionVO data,
        List<EntityAttributeVO> entityAttrs, String attrName, String bindValue, PageVO page) throws OperateException {
        ConsistencyCheckResult objRes = null;
        String[] strBindEntityAttr = bindValue.split("\\.");
        for (int i = 1, len = strBindEntityAttr.length; i < len; i++) {
            String strAttrName = null;
            for (EntityAttributeVO objEntityAttr : entityAttrs) {
                if (strBindEntityAttr.equals(objEntityAttr.getEngName())) {
                    strAttrName = objEntityAttr.getEngName();
                    break;
                }
            }
            if (strAttrName != null) {
                objRes = new ConsistencyCheckResult();
                objRes.setType(ConsistencyCheckResultType.CONSISTENCY_TYPE_PAGE_ACTION.getValue());
                objRes.setMessage(String.format("页面【%s】中的行为【%s】属性%s值依赖了实体属性：%s", page.getCname(),
                    data.getPageActionId(), attrName, strAttrName));
                Map<String, String> objAtrrMap = new HashMap<String, String>();
                objAtrrMap.put(ConsistencyResultAttrName.PAGE_ATTRNAME_PK.getValue(), page.getModelId());
                objAtrrMap.put(ConsistencyResultAttrName.PAGE_ACTION_ATTRNAME_PK.getValue(), data.getPageActionId());
                objAtrrMap.put(ConsistencyResultAttrName.PAGE_ACTION_ATTRNAME_ACTION_PRO.getValue(), attrName);
                objRes.setAttrMap(objAtrrMap);
                break;
            }
        }
        return objRes;
    }
}
