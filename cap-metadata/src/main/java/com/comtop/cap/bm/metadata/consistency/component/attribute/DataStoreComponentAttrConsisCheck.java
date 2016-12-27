/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.consistency.component.attribute;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.bm.metadata.base.consistency.ConsistencyException;
import com.comtop.cap.bm.metadata.base.consistency.model.ConsistencyCheckResult;
import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import com.comtop.cap.bm.metadata.common.dwr.CapMap;
import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.consistency.ConsistencyCheckResultType;
import com.comtop.cap.bm.metadata.consistency.ConsistencyResultAttrName;
import com.comtop.cap.bm.metadata.entity.facade.EntityFacade;
import com.comtop.cap.bm.metadata.entity.model.AttributeSourceType;
import com.comtop.cap.bm.metadata.entity.model.AttributeType;
import com.comtop.cap.bm.metadata.entity.model.DataTypeVO;
import com.comtop.cap.bm.metadata.entity.model.EntityAttributeVO;
import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cap.bm.metadata.page.desinger.model.DataStoreVO;
import com.comtop.cap.bm.metadata.page.desinger.model.LayoutVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.cap.bm.metadata.page.uilibrary.model.ComponentVO;
import com.comtop.cap.bm.metadata.page.uilibrary.model.PropertyVO;
import com.comtop.cip.jodd.util.StringUtil;
import com.comtop.cip.json.JSONArray;
import com.comtop.cip.json.JSONObject;
import com.comtop.top.core.jodd.AppContext;

/**
 * 控件涉及到数据集数据的属性一致性校验
 * 
 * @author 诸焕辉
 * @since jdk1.6
 * @version 2016年6月28日 诸焕辉
 */
public class DataStoreComponentAttrConsisCheck extends DefaultComponentAttrConsisCheck {
    
    /** 数组匹配正则表达式 */
    private static final Pattern arrayPattern = Pattern.compile("\\[(0{1}|([1-9]{1}[0-9]+))\\]$");
    
    /**
     * 实体facade类
     */
    private final EntityFacade entityFacade = AppContext.getBean(EntityFacade.class);
    
    @Override
    public ConsistencyCheckResult checkAttrValueConsis(ComponentVO com, BaseMetadata baseMetadataVO, LayoutVO data,
        PageVO root) {
        PropertyVO objPropertyVO = (PropertyVO) baseMetadataVO;
        String strEname = objPropertyVO.getEname();
        String strValue = (String) data.getOptions().get(strEname);
        if (StringUtil.isBlank(strValue)) {
            return null;
        }
        return this.executeCheckHandler(com, data, root, strValue, strEname, objPropertyVO.getConsistencyConfig()
            .getRegular());
    }
    
    /**
     * 检查处理器
     * 
     * @param com 控件信息
     * @param data 控件对应的布局对象
     * @param root page对象
     * @param value 值
     * @param ename 属性名称
     * @param regular 替换鬼谷子
     * @return 校验结果
     */
    public ConsistencyCheckResult executeCheckHandler(ComponentVO com, LayoutVO data, PageVO root, String value,
        String ename, Map<String, String> regular) {
        ConsistencyCheckResult objRes = null;
        if (StringUtil.isBlank(value)) {
            return objRes;
        }
        // 过滤属性值（如：$datastore.attrname，需过滤$符号）
        String strValue = filterAttrValue(regular, value);
        String[] strBind = strValue.split("\\.");
        String strDatastore = strBind[0];
        String strQueryExp = "./dataStoreVOList[ename='" + strDatastore + "']";
        try {
            DataStoreVO objDataStoreVO = root.query(strQueryExp, DataStoreVO.class);
            // 数据集是否存
            if (objDataStoreVO == null) {
                String strMessage = "不存在";
                return this.createCheckResult(com, data, root, strDatastore, strMessage, ename);
            }
            if (strBind.length <= 1) {
                return objRes;
            }
            // 数据集是否绑定了实体对象
            if (StringUtil.isBlank(objDataStoreVO.getEntityId())) {
                String strBindAttr = strValue.substring(strValue.indexOf('.'));
                String strMessage = "未关联实体，不存在属性：" + strBindAttr;
                return this.createCheckResult(com, data, root, strDatastore, strMessage, ename);
            }
            EntityVO objEntityVO = (EntityVO) CacheOperator.readById(objDataStoreVO.getEntityId());
            // 数据集绑定的实体是否存（绑定的实体已更新或删除）
            if (objEntityVO == null) {
                String strBindAttr = strValue.substring(strValue.indexOf('.'));
                String strMessage = "关联的实体" + objDataStoreVO.getEntityId() + "不存在,绑定属性有误：" + strBindAttr;
                return this.createCheckResult(com, data, root, strDatastore, strMessage, ename);
            }
            String strAttrName = null;
            for (int i = 1, len = strBind.length; i < len; i++) {
                strAttrName = strBind[i];
                if (isArray(strBind[i])) {
                    strAttrName = replaceArray(strBind[i]);
                }
                EntityAttributeVO objEntityAttr = objEntityVO.query("./attributes[engName='" + strAttrName + "']",
                    EntityAttributeVO.class);
                if (objEntityAttr == null) {
                    String strMessage = "不存在属性：" + strAttrName;
                    return this.createCheckResult(com, data, root, strDatastore, strMessage, ename);
                }
                if (isArray(strBind[i])
                    && !AttributeType.JAVA_UTIL_LIST.getValue().equals(objEntityAttr.getAttributeType().getType())) {
                    String strMessage = "的属性不是数组：" + strAttrName;
                    return this.createCheckResult(com, data, root, strDatastore, strMessage, ename);
                }
                if (i == strBind.length - 1) {
                    continue;
                }
                if (isPrimitive(objEntityAttr.getAttributeType())) {
                    String strMessage = "的属性：" + strAttrName + "不存在子属性";
                    return this.createCheckResult(com, data, root, strDatastore, strMessage, ename);
                }
                if (!isArray(strBind[i])
                    && AttributeType.JAVA_UTIL_LIST.getValue().equals(objEntityAttr.getAttributeType().getType())) {
                    String strMessage = "的属性：" + strAttrName + "是数组，不能直接访问数据中元素的属性";
                    return this.createCheckResult(com, data, root, strDatastore, strMessage, ename);
                }
                if (AttributeSourceType.THIRD_PARTY_TYPE.getValue()
                    .equals(objEntityAttr.getAttributeType().getSource())
                    || AttributeSourceType.JAVA_OBJECT.getValue().equals(objEntityAttr.getAttributeType().getSource())) {
                    break;
                }
                if (AttributeSourceType.ENTITY.getValue().equals(objEntityAttr.getAttributeType().getSource())) {
                    objEntityVO = (EntityVO) CacheOperator.readById(objEntityAttr.getAttributeType().getValue());
                    if (objEntityVO == null) {
                        String strMessage = "的属性：" + strAttrName + "对应的实体:"
                            + objEntityAttr.getAttributeType().getValue() + "不存在";
                        return this.createCheckResult(com, data, root, strDatastore, strMessage, ename);
                    }
                }
            }
        } catch (OperateException e) {
            throw new ConsistencyException("一致性校验出错，校验的" + ename + "属性出错", e);
        }
        return objRes;
    }
    
    /**
     * 根据规则，过滤属性值
     * 
     * @param regular 过滤规则
     * @param value 属性原始值
     * @return 返回过滤后的属性值
     */
    private String filterAttrValue(Map<String, String> regular, String value) {
        String strValue = value;
        if (StringUtils.isNotBlank(value) && regular != null && !regular.isEmpty()) {
            String regex = null;
            String replace = null;
            for (Entry<String, String> entry : regular.entrySet()) {
                regex = entry.getKey();
                replace = entry.getValue();
                Pattern objPattern = Pattern.compile(regex);
                Matcher objMatcher = objPattern.matcher(value);
                strValue = objMatcher.replaceAll(replace);
            }
        }
        return strValue;
    }
    
    /**
     * 封装校验结果
     * 
     * @param com 控件定义
     * @param data 布局对象
     * @param root 页面对象
     * @param strDatastore 数据集名称
     * @param strMessage 校验信息
     * @param field 控件属性名称
     * @return 校验对象
     */
    private ConsistencyCheckResult createCheckResult(ComponentVO com, LayoutVO data, PageVO root, String strDatastore,
        String strMessage, String field) {
        ConsistencyCheckResult objRes = new ConsistencyCheckResult();
        String strMes = this.createMessage(com, field, strDatastore, data) + strMessage;
        objRes.setMessage(strMes);
        objRes.setAttrMap(this.createLayoutAttrMap(root, data, field));
        objRes.setType(ConsistencyCheckResultType.CONSISTENCY_TYPE_PAGE_LAYOUT.getValue());
        return objRes;
    }
    
    /**
     * 替换数组属性中的[]，获取真实属性
     * 
     * @param string bandind属性
     * @return 实体属性
     */
    private String replaceArray(String string) {
        return arrayPattern.matcher(string).replaceAll("");
    }
    
    /**
     * 是否为数组属性
     * 
     * @param string bandind属性
     * @return true是数组属性 false 非数组属性
     */
    private boolean isArray(String string) {
        return arrayPattern.matcher(string).find();
    }
    
    /**
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
    
    @Override
    public ConsistencyCheckResult checkAttrValueDependOnEntityAttr(BaseMetadata baseMetadataVO,
        List<EntityAttributeVO> entityAttrs, List<DataStoreVO> relationDataStores, LayoutVO data, PageVO page) {
        CapMap objOption = data.getOptions();
        PropertyVO objPropertyVO = (PropertyVO) baseMetadataVO;
        String strEname = objPropertyVO.getEname();
        String strValue = (String) objOption.get(strEname);
        if (StringUtil.isNotBlank(strValue)) {
            return null;
        }
        String strbindValue = filterAttrValue(objPropertyVO.getConsistencyConfig().getRegular(), strValue);
        return this.execCheckDependOnEntityAttrHandler(data, entityAttrs, relationDataStores, page, strbindValue,
            strEname);
    }
    
    /**
     * 检验grid或editableGrid的列绑定的数据一致性
     * 
     * @param entityAttrs 控件属性名称
     * @param bindName 控件对应的布局对象
     * @param page page对象
     * @return 校验结果
     */
    public ConsistencyCheckResult checkColBindNameBeingDependOnEntAttr(List<EntityAttributeVO> entityAttrs,
        String bindName, PageVO page) {
        
        return null;
    }
    
    /**
     * 校验控件属性是否依赖了当前传入的实体属性
     * 
     * @param data 布局对象
     * @param entityAttrs 实体属性集合
     * @param relationDataStores 关联了当前校验实体的数据集
     * @param root 页面对象
     * @param bindValue 实体属性
     * @param ename 控件属性名称
     * @return 校验结果
     */
    public ConsistencyCheckResult execCheckDependOnEntityAttrHandler(LayoutVO data,
        List<EntityAttributeVO> entityAttrs, List<DataStoreVO> relationDataStores, PageVO root, String bindValue,
        String ename) {
        ConsistencyCheckResult objRes = null;
        if (StringUtil.isBlank(bindValue)) {
            return objRes;
        }
        String[] strBind = bindValue.split("\\.");
        String strDatastore = strBind[0];
        boolean bExist = false;
        for (DataStoreVO objDataStoreVO : relationDataStores) {
            if (strDatastore.equals(objDataStoreVO.getEname())) {
                bExist = true;
            }
        }
        if (!bExist) {
            return objRes;
        }
        for (int i = 1, len = strBind.length; i < len; i++) {
            String strDependEntityAttr = null;
            for (EntityAttributeVO objEntityAttrVO : entityAttrs) {
                if (AttributeSourceType.ENTITY.equals(objEntityAttrVO.getAttributeType().getSource()) && len > 1
                    && strBind[i].equals(objEntityAttrVO.getEngName())) {
                    strDependEntityAttr = strBind[i];
                    break;
                } else if (strBind[i].equals(objEntityAttrVO.getEngName())) {
                    strDependEntityAttr = strBind[i];
                    break;
                }
            }
            if (strDependEntityAttr != null) {
                objRes = new ConsistencyCheckResult();
                objRes.setType(ConsistencyCheckResultType.CONSISTENCY_TYPE_PAGE_LAYOUT.getValue());
                objRes.setMessage(String.format("页面【%s】中的控件【%s】属性%s值依赖了实体属性：%s", root.getCname(), data.getId(), ename,
                    strDependEntityAttr));
                Map<String, String> objAtrrMap = new HashMap<String, String>();
                objAtrrMap.put(ConsistencyResultAttrName.PAGE_ATTRNAME_PK.getValue(), root.getModelId());
                objAtrrMap.put(ConsistencyResultAttrName.PAGE_LAYOUT_ATTRNAME_PK.getValue(), data.getId());
                objAtrrMap.put(ConsistencyResultAttrName.PAGE_LAYOUT_ATTRNAME_COMPONENT_PRO.getValue(), ename);
                objRes.setAttrMap(objAtrrMap);
                break;
            }
        }
        return objRes;
    }
    
    /**
     * 检验grid或editableGrid的列绑定的数据一致性
     * 
     * @param com 控件信息
     * @param columns 控件属性名称
     * @param data 控件对应的布局对象
     * @param root page对象
     * @return 校验结果
     */
    public ConsistencyCheckResult checkColumnsBindNameConsis(ComponentVO com, JSONArray columns, LayoutVO data,
        PageVO root) {
        StringBuffer strMsg = new StringBuffer();
        // 从扩展属性中获取绑定的数据集名称
        String strExtras = (String) data.getOptions().get("extras");
        if (StringUtil.isBlank(strExtras)) {
            strMsg.append("扩展属性extras不存在，获取不了绑定的数据集，无法进一步验证绑定的实体属性是否一致");
        } else {
            JSONObject objExtras = JSONObject.parseObject(strExtras);
            String strDatastore = objExtras.getString("dataStoreEname");
            if (StringUtil.isBlank(strDatastore)) {
                strMsg.append("扩展属性extras中未存储绑定的数据集名称，无法进一步验证绑定的实体属性是否一致");
            } else {
                try {
                    DataStoreVO objDataStoreVO = root.query("./dataStoreVOList[ename='" + strDatastore + "']",
                        DataStoreVO.class);
                    // 数据集是否存
                    if (objDataStoreVO == null) {
                        strMsg.append("绑定的数据集：").append(strDatastore).append("不存在");
                    } else if (StringUtil.isBlank(objDataStoreVO.getEntityId())) {// 数据集是否绑定了实体对象
                        strMsg.append("绑定的数据集：").append(strDatastore).append("未关联实体");
                    } else {
                        EntityVO objEntityVO = (EntityVO) CacheOperator.readById(objDataStoreVO.getEntityId());
                        // 数据集绑定的实体是否存（绑定的实体已更新或删除）
                        if (objEntityVO == null) {
                            strMsg.append("绑定的数据集：").append(strDatastore).append("关联的实体：")
                                .append(objDataStoreVO.getEntityId()).append("不存在");
                        } else {
                            // 数据集绑定的实体于entityId不同相同，则取entityId(子集)
                            if (!objDataStoreVO.getEntityId().equals(objExtras.getString("entityId"))) {
                                // 检查父集合是否存在关联，存在则取子集实体，不存在
                            	//TODO 此处的关联属性校验，只校验了关联的第一级属性，即仅校验了a.b时，a、b是否存在；对于a.b.c.d多级属性，此处逻辑不能实现该需求
                            	EntityAttributeVO objEntityAttributeVO = (EntityAttributeVO) objEntityVO
                                    .query("./attributes[attributeType[(type='entity' and value='"
                                        + objExtras.getString("entityId") + "') or (type='java.util.List' and generic[value='"+objExtras.getString("entityId")+"'])]]");
                                if (objEntityAttributeVO != null) {
                                    objEntityVO = (EntityVO) CacheOperator.readById(objExtras.getString("entityId"));
                                    if (objEntityVO == null) {
                                        strMsg.append("绑定的数据集：").append(strDatastore).append("关联的实体：")
                                            .append(objDataStoreVO.getEntityId()).append("不存在");
                                    } else {
                                        for (int i = 0, len = columns.size(); i < len; i++) {
                                            JSONObject objCol = (JSONObject) columns.get(i);
                                            String strBindName = (String) objCol.get("bindName");
                                            if (StringUtil.isNotBlank(strBindName)) {
                                                EntityAttributeVO objEntityAttr = null;
                                                objEntityAttr = objEntityVO.query("./attributes[engName='"
                                                    + strBindName + "']", EntityAttributeVO.class);
                                                if (objEntityAttr == null) {
                                                    strMsg.append("第【").append(i + 1).append("】列bindName绑定的属性")
                                                        .append(strBindName).append("不存在");
                                                }
                                            }
                                        }
                                    }
                                } else {
                                    strMsg.append("绑定的数据集：").append(strDatastore).append("关联的实体：")
                                        .append(objExtras.getString("entityId")).append("关联关系不存在");
                                }
                            } else {
                                for (int i = 0, len = columns.size(); i < len; i++) {
                                    JSONObject objCol = (JSONObject) columns.get(i);
                                    String strBindName = (String) objCol.get("bindName");
                                    if(StringUtil.isBlank(strBindName)) {
                                    	continue;
                                    }else if(!entityFacade.hasAttribute(objEntityVO, strBindName)) {
                                    	strMsg.append("第【").append(i + 1).append("】列bindName绑定的属性")
                                        .append(strBindName).append("不存在");
                                    }
                                }
                            }
                            
                        }
                    }
                } catch (OperateException e) {
                    throw new ConsistencyException("一致性校验出错，校验的页面控件【" + data.getId() + "】属性colunms出错", e);
                }
            }
        }
        ConsistencyCheckResult objRes = null;
        if (strMsg.length() > 0) {
            objRes = new ConsistencyCheckResult();
            objRes.setMessage(strMsg.toString());
        }
        return objRes;
    }
    
    /**
     * 检验grid或editableGrid的列定义的控件数据一致性（目前只需检验人员和组织控件）
     * 
     * @param com 控件信息
     * @param options 控件定义类型
     * @param entity 实体对象
     * @return 校验结果
     */
    public ConsistencyCheckResult checkEditTypeConsis(ComponentVO com, JSONObject options, EntityVO entity) {
        StringBuffer strMsg = new StringBuffer();
        String strUItype = options.getString("uitype");
        if ("ChooseUser".equals(strUItype) || "ChooseOrg".equals(strUItype)) {
            String strIdName = options.getString("idName");
            String strValueName = options.getString("valueName");
            String strOpts = options.getString("opts");
            EntityAttributeVO objEntityAttr = null;
            try {
                objEntityAttr = entity.query("./attributes[engName='" + strIdName + "']", EntityAttributeVO.class);
                if (objEntityAttr == null) {
                    strMsg.append("属性idName绑定的实体属性").append(strIdName).append("不存在");
                }
                objEntityAttr = entity.query("./attributes[engName='" + strValueName + "']", EntityAttributeVO.class);
                if (objEntityAttr == null) {
                    strMsg.append(strMsg.length() > 0 ? "<br/>" : "").append("属性valueName绑定的实体属性").append(strIdName)
                        .append("不存在");
                }
                objEntityAttr = entity.query("./attributes[engName='" + strOpts + "']", EntityAttributeVO.class);
                if (objEntityAttr == null) {
                    strMsg.append(strMsg.length() > 0 ? "<br/>" : "").append("属性opts绑定的实体属性").append(strIdName)
                        .append("不存在");
                }
            } catch (OperateException e) {
                throw new ConsistencyException("一致性校验出错，校验的页面控件属性colunms出错", e);
            }
        }
        ConsistencyCheckResult objRes = null;
        if (strMsg.length() > 0) {
            objRes = new ConsistencyCheckResult();
            objRes.setMessage(strMsg.toString());
        }
        return objRes;
    }
}
