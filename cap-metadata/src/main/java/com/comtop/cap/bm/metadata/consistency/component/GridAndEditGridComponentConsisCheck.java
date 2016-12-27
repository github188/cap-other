
package com.comtop.cap.bm.metadata.consistency.component;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.base.consistency.ConsistencyCheckUtil;
import com.comtop.cap.bm.metadata.base.consistency.model.ConsistencyCheckResult;
import com.comtop.cap.bm.metadata.base.consistency.model.FieldConsistencyConfigVO;
import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.consistency.ConsistencyCheckResultType;
import com.comtop.cap.bm.metadata.consistency.ConsistencyResultAttrName;
import com.comtop.cap.bm.metadata.consistency.IComponentConsisCheck;
import com.comtop.cap.bm.metadata.consistency.component.attribute.ActionComponentAttrConsisCheck;
import com.comtop.cap.bm.metadata.consistency.component.attribute.DataStoreComponentAttrConsisCheck;
import com.comtop.cap.bm.metadata.entity.model.AttributeSourceType;
import com.comtop.cap.bm.metadata.entity.model.EntityAttributeVO;
import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cap.bm.metadata.page.desinger.model.DataStoreVO;
import com.comtop.cap.bm.metadata.page.desinger.model.LayoutVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.cap.bm.metadata.page.uilibrary.facade.ComponentFacade;
import com.comtop.cap.bm.metadata.page.uilibrary.model.ComponentVO;
import com.comtop.cap.bm.metadata.page.uilibrary.model.PropertyVO;
import com.comtop.cip.jodd.util.StringUtil;
import com.comtop.cip.json.JSONArray;
import com.comtop.cip.json.JSONObject;
import com.comtop.top.core.jodd.AppContext;

/**
 * 编辑网格控件属性一致性校验
 * 
 * @author 诸焕辉
 * @since jdk1.6
 * @version 2016年6月27日 诸焕辉
 */
public class GridAndEditGridComponentConsisCheck extends DefaultComponentConsisCheck {
    
    /** 日志 */
    private final static Logger LOG = LoggerFactory.getLogger(GridAndEditGridComponentConsisCheck.class);
    
    /**
     * 控件模型facade类
     */
    private final ComponentFacade componentFacade = AppContext.getBean(ComponentFacade.class);
    
    /**
     * 每行单元格属性配置
     */
    private static String COLUMNS = "columns";
    
    /**
     * 控件定义类型
     */
    private static String EDITTYPE = "edittype";
    
    /**
     * 主键
     */
    private static String PRIMARYKEY = "primarykey";
    
    @Override
    protected ConsistencyCheckResult checkPropertyConsistency(ComponentVO com, PropertyVO propertyVO, LayoutVO data,
        PageVO root) {
        ConsistencyCheckResult objRes = null;
        if (COLUMNS.equals(propertyVO.getEname())) {
            objRes = this.checkColumnsConsistency(com, propertyVO, data, root);
        } else if (EDITTYPE.equals(propertyVO.getEname())) {
            objRes = this.checkEditTypeConsistency(com, propertyVO, data, root);
        } else if (PRIMARYKEY.equals(propertyVO.getEname())) {
            objRes = this.checkPrimarykeyConsistency(com, propertyVO, data, root);
        } else {
            objRes = super.checkPropertyConsistency(com, propertyVO, data, root);
        }
        return objRes;
    }
    
    /**
     * 校验控件属性的值的一致性
     * 
     * @param com 控件信息
     * @param propertyVO 控件属性集合
     * @param data 控件对应的布局对象
     * @param root page对象
     * @return 校验结果
     */
    protected ConsistencyCheckResult checkColumnsConsistency(ComponentVO com, PropertyVO propertyVO, LayoutVO data,
        PageVO root) {
        StringBuffer strMsg = new StringBuffer();
        String strColumns = (String) data.getOptions().get(COLUMNS);
        if (StringUtils.isBlank(strColumns)) {
            return null;
        }
        JSONArray objColumns = JSONArray.parseArray(strColumns);
        if (objColumns.size() == 0) {
            return null;
        }
        if (objColumns.get(0) instanceof JSONArray) {// 多表头
            objColumns = (JSONArray) objColumns.get(1);
        }
        // 绑定的属性校验
        DataStoreComponentAttrConsisCheck objDataStoreConsisCheck = (DataStoreComponentAttrConsisCheck) ConsistencyCheckUtil
            .getConsistencyCheck(DATASTORE_COMPONENT_ATTR_CONSISCHECK_CLASS, IComponentAttrConsisCheck.class);
        if (objDataStoreConsisCheck != null) {
            ConsistencyCheckResult objRes4DataStore = objDataStoreConsisCheck.checkColumnsBindNameConsis(com,
                objColumns, data, root);
            if (objRes4DataStore != null) {
                strMsg.append(objRes4DataStore.getMessage());
            }
        }
        // 绑定的行为校验
        ActionComponentAttrConsisCheck objActionConsisCheck = (ActionComponentAttrConsisCheck) ConsistencyCheckUtil
            .getConsistencyCheck(ACTION_COMPONENT_ATTR_CONSISCHECK_CLASS, IComponentAttrConsisCheck.class);
        if (objActionConsisCheck != null) {
            ConsistencyCheckResult objRes4PageAction = objActionConsisCheck.checkColumnsRenderConsis(com, objColumns,
                data, root);
            if (objRes4PageAction != null) {
                strMsg.append(strMsg.length() > 0 ? "<br/>" : "").append(objRes4PageAction.getMessage());
            }
        }
        ConsistencyCheckResult objRes = null;
        if (strMsg.length() > 0) {
            objRes = new ConsistencyCheckResult();
            objRes.setMessage(strMsg.toString());
            Map<String, String> objAttrMap = new HashMap<String, String>();
            objAttrMap.put(ConsistencyResultAttrName.PAGE_ATTRNAME_PK.getValue(), root.getModelId());
            objAttrMap.put(ConsistencyResultAttrName.PAGE_LAYOUT_ATTRNAME_PK.getValue(), data.getId());
            objAttrMap.put(ConsistencyResultAttrName.PAGE_LAYOUT_ATTRNAME_COMPONENT_PRO.getValue(), COLUMNS);
            objRes.setAttrMap(objAttrMap);
            objRes.setType(ConsistencyCheckResultType.CONSISTENCY_TYPE_PAGE_LAYOUT.getValue());
        }
        return objRes;
    }
    
    /**
     * 校验控件属性的值的一致性
     * 
     * @param com 控件信息
     * @param propertyVO 控件属性集合
     * @param data 控件对应的布局对象
     * @param root page对象
     * @return 校验结果
     */
    protected ConsistencyCheckResult checkEditTypeConsistency(ComponentVO com, PropertyVO propertyVO, LayoutVO data,
        PageVO root) {
        String strEditType = (String) data.getOptions().get(EDITTYPE);
        String strDefaultCmpCheckClazz = "com.comtop.cap.bm.metadata.consistency.component.DefaultComponentConsisCheck";
        if (StringUtils.isBlank(strEditType)) {
            return null;
        }
        JSONObject objEditType = JSONObject.parseObject(strEditType);
        if (objEditType.isEmpty()) {
            return null;
        }
        String strExtras = (String) data.getOptions().get("extras");
        if (StringUtil.isBlank(strExtras)) {
            return null;
        }
        JSONObject objExtras = JSONObject.parseObject(strExtras);
        String strDatastore = objExtras.getString("dataStoreEname");
        if (StringUtil.isBlank(strDatastore)) {
            return null;
        }
        DataStoreVO objDataStoreVO = null;
        try {
            objDataStoreVO = root.query("./dataStoreVOList[ename='" + strDatastore + "']", DataStoreVO.class);
        } catch (OperateException e) {
            e.printStackTrace();
        }
        if (objDataStoreVO == null) {
            return null;
        }
        if (StringUtil.isBlank(objDataStoreVO.getEntityId())) {
            return null;
        }
        EntityVO objEntityVO = (EntityVO) CacheOperator.readById(objDataStoreVO.getEntityId());
        // 数据集绑定的实体是否存（绑定的实体已更新或删除）
        if (objEntityVO == null) {
            return null;
        }
        // 判断选中的数据是否为数据集合的子集
        if (objDataStoreVO.getEntityId() != null
            && !objDataStoreVO.getEntityId().equals(objExtras.getString("entityId"))) {
            // 检查父集合是否存在关联，存在则取子集实体，不存在
            EntityAttributeVO objEntityAttributeVO;
            try {
                objEntityAttributeVO = (EntityAttributeVO) objEntityVO
                    .query("./attributes[attributeType[type='entity' and value='" + objExtras.getString("entityId")
                        + "']]");
                if (objEntityAttributeVO != null) {
                    objEntityVO = (EntityVO) CacheOperator.readById(objExtras.getString("entityId"));
                    if (objEntityVO == null) {
                        return null;
                    }
                } else {
                    return null;
                }
            } catch (OperateException e) {
                e.printStackTrace();
            }
        }
        
        DataStoreComponentAttrConsisCheck objDataStoreConsisCheck = ConsistencyCheckUtil.getConsistencyCheck(
            DATASTORE_COMPONENT_ATTR_CONSISCHECK_CLASS, DataStoreComponentAttrConsisCheck.class);
        ActionComponentAttrConsisCheck objPageActionConsisCheck = ConsistencyCheckUtil.getConsistencyCheck(
            ACTION_COMPONENT_ATTR_CONSISCHECK_CLASS, ActionComponentAttrConsisCheck.class);
        StringBuffer strMsg = new StringBuffer();
        Set<String> objColKeySet = objEditType.keySet();
        Iterator<String> objColIterator = objColKeySet.iterator();
        while (objColIterator.hasNext()) {
            String strColKey = objColIterator.next();
            JSONObject objOptions = (JSONObject) objEditType.get(strColKey);
            String strCmpModelId = objOptions.getString("componentModelId");
            ComponentVO objComponentVO = componentFacade.loadModel(strCmpModelId);
            if (objComponentVO != null) {
                FieldConsistencyConfigVO objConsistencyConfig = objComponentVO.getConsistencyConfig();
                if (objConsistencyConfig != null) {
                    List<ConsistencyCheckResult> lstRes = new ArrayList<ConsistencyCheckResult>();
                    if (objConsistencyConfig.getCheckConsistency().booleanValue()) {
                        String strCheckClass = StringUtil.isBlank(objConsistencyConfig.getCheckClass())
                            ? objConsistencyConfig.getCheckClass() : strDefaultCmpCheckClazz;
                        IComponentConsisCheck objCheck = ConsistencyCheckUtil.getConsistencyCheck(strCheckClass,
                            IComponentConsisCheck.class);
                        if (objCheck != null) {
                            // 校验控件行为
                            ConsistencyCheckResult objRes4PageAction = objPageActionConsisCheck.checkEditTypeConsis(
                                objComponentVO, objOptions, data, root);
                            if (objRes4PageAction != null) {
                                lstRes.add(objRes4PageAction);
                            }
                            // 校验控件属性
                            ConsistencyCheckResult objRes4DataStore = objDataStoreConsisCheck.checkEditTypeConsis(
                                objComponentVO, objOptions, objEntityVO);
                            if (objRes4DataStore != null) {
                                lstRes.add(objRes4DataStore);
                            }
                        }
                    }
                    for (ConsistencyCheckResult objResult : lstRes) {
                        strMsg.append(strMsg.length() > 0 ? "<br/>" : "").append("bindName：").append(strColKey)
                            .append("对应的").append(objResult.getMessage());
                    }
                }
            }
        }
        ConsistencyCheckResult objRes = null;
        if (strMsg.length() > 0) {
            objRes = new ConsistencyCheckResult();
            objRes.setMessage(strMsg.toString());
            Map<String, String> objAttrMap = new HashMap<String, String>();
            objAttrMap.put(ConsistencyResultAttrName.PAGE_ATTRNAME_PK.getValue(), root.getModelId());
            objAttrMap.put(ConsistencyResultAttrName.PAGE_LAYOUT_ATTRNAME_PK.getValue(), data.getId());
            objAttrMap.put(ConsistencyResultAttrName.PAGE_LAYOUT_ATTRNAME_COMPONENT_PRO.getValue(), EDITTYPE);
            objRes.setAttrMap(objAttrMap);
            objRes.setType(ConsistencyCheckResultType.CONSISTENCY_TYPE_PAGE_LAYOUT.getValue());
        }
        return objRes;
    }
    
    /**
     * 校验主键值的一致性
     * 
     * @param com 控件信息
     * @param propertyVO 控件属性集合
     * @param data 控件对应的布局对象
     * @param root page对象
     * @return 校验结果
     */
    protected ConsistencyCheckResult checkPrimarykeyConsistency(ComponentVO com, PropertyVO propertyVO, LayoutVO data,
        PageVO root) {
        DataStoreComponentAttrConsisCheck objCheck = (DataStoreComponentAttrConsisCheck) ConsistencyCheckUtil
            .getConsistencyCheck(DATASTORE_COMPONENT_ATTR_CONSISCHECK_CLASS, IComponentAttrConsisCheck.class);
        String strEname = propertyVO.getEname();
        String strValue = (String) data.getOptions().get(strEname);
        if (StringUtil.isBlank(strValue)) {
            return null;
        }
        String strExtras = (String) data.getOptions().get("extras");
        if (StringUtil.isBlank(strExtras)) {
            return null;
        }
        JSONObject objExtras = JSONObject.parseObject(strExtras);
        String strDatastore = objExtras.getString("dataStoreEname");
        if (StringUtil.isBlank(strDatastore)) {
            return null;
        }
        // 页面一致性判断子集
        DataStoreVO objDataStoreVO = null;
        EntityVO objParentEntityVO = null;
        EntityVO objEntityVO = null;
        String strQueryExp = "./dataStoreVOList[ename='" + strDatastore + "']";
        try {
            objDataStoreVO = root.query(strQueryExp, DataStoreVO.class);
        } catch (OperateException e) {
            LOG.debug("error", e);
        }
        if (objDataStoreVO == null) {
            return null;
        }
        if (StringUtil.isBlank(objDataStoreVO.getEntityId())) {
            return null;
        }
        if (!objExtras.getString("entityId").equals(objDataStoreVO.getEntityId())) {
            objEntityVO = (EntityVO) CacheOperator.readById(objExtras.getString("entityId"));
            objParentEntityVO = (EntityVO) CacheOperator.readById(objDataStoreVO.getEntityId());
        }
        if (objParentEntityVO != null && objEntityVO != null) {
            EntityAttributeVO objEntityAttributeVO;
            try {
                
                objEntityAttributeVO = (EntityAttributeVO) objParentEntityVO
                    .query("./attributes[attributeType[type='entity' and value='" + objExtras.getString("entityId")
                        + "']]");
                if (objEntityAttributeVO != null) {
                    strValue = strDatastore + "." + objEntityAttributeVO.getEngName() + "." + strValue;
                } else {
                    return null;
                }
            } catch (OperateException e) {
                LOG.debug("error", e);
            }
        } else {
            strValue = strDatastore + "." + strValue;
        }
        
        ConsistencyCheckResult objRes = objCheck.executeCheckHandler(com, data, root, strValue, strEname,
            new HashMap<String, String>());
        return objRes;
    }
    
    @Override
    public List<ConsistencyCheckResult> checkProValDependOnEntityAttr(ComponentVO comp,
        List<EntityAttributeVO> entityAttrs, List<DataStoreVO> relationDataStores, LayoutVO data, PageVO page) {
        List<ConsistencyCheckResult> lstRes = new ArrayList<ConsistencyCheckResult>();
        String strCheckClazz = "com.comtop.cap.bm.metadata.consistency.component.attribute.DataStoreComponentAttrConsisCheck";
        IComponentAttrConsisCheck objCheck = ConsistencyCheckUtil.getConsistencyCheck(strCheckClazz,
            IComponentAttrConsisCheck.class);
        if (objCheck == null) {
            return lstRes;
        }
        for (PropertyVO objPropertyVO : comp.getProperties()) {
            
            FieldConsistencyConfigVO objFieldConsisConfigVO = objPropertyVO.getConsistencyConfig();
            if (objFieldConsisConfigVO != null && objFieldConsisConfigVO.getCheckConsistency().booleanValue()
                && strCheckClazz.equals(objFieldConsisConfigVO.getCheckClass())) {
                ConsistencyCheckResult objRes = null;
                if (COLUMNS.equals(objPropertyVO.getEname())) {
                    objRes = this.checkColumnsDependOnEntityAttr(objPropertyVO, entityAttrs, relationDataStores, data,
                        page);
                } else if (EDITTYPE.equals(objPropertyVO.getEname())) {
                    objRes = this.checkEditTypeDependOnEntityAttr(objPropertyVO, entityAttrs, relationDataStores, data,
                        page);
                } else if (PRIMARYKEY.equals(objPropertyVO.getEname())) {
                    objRes = this.checkPrimarykeyDependOnEntityAttr(objPropertyVO, entityAttrs, relationDataStores,
                        data, page);
                } else {
                    objRes = objCheck.checkAttrValueDependOnEntityAttr(objPropertyVO, entityAttrs, relationDataStores,
                        data, page);
                }
                if (objRes != null) {
                    lstRes.add(objRes);
                }
            }
        }
        return lstRes;
    }
    
    /**
     * 校验Columns属性是否依赖了当前传入的实体属性
     * 
     * @param baseMetadataVO 属性对象
     * @param entityAttrs 实体属性集合
     * @param relationDataStores 关联了当前校验实体的数据集
     * @param data 控件属性对象
     * @param page 页面对象
     * @return 校验结果
     */
    protected ConsistencyCheckResult checkColumnsDependOnEntityAttr(BaseMetadata baseMetadataVO,
        List<EntityAttributeVO> entityAttrs, List<DataStoreVO> relationDataStores, LayoutVO data, PageVO page) {
        String strColumns = (String) data.getOptions().get(COLUMNS);
        if (StringUtils.isBlank(strColumns)) {
            return null;
        }
        JSONArray objColumns = JSONArray.parseArray(strColumns);
        if (objColumns.size() == 0) {
            return null;
        }
        if (objColumns.get(0) instanceof JSONArray) {// 多表头
            objColumns = (JSONArray) objColumns.get(1);
        }
        StringBuffer strMsg = new StringBuffer();
        // 从扩展属性中获取绑定的数据集名称
        String strExtras = (String) data.getOptions().get("extras");
        if (StringUtil.isNotBlank(strExtras)) {
            JSONObject objExtras = JSONObject.parseObject(strExtras);
            String strDatastore = objExtras.getString("dataStoreEname");
            if (StringUtil.isNotBlank(strDatastore)) {
                boolean bExist = false;
                for (DataStoreVO objDataStoreVO : relationDataStores) {
                    if (strDatastore.equals(objDataStoreVO.getEname())) {
                        bExist = true;
                    }
                }
                if (!bExist) {
                    return null;
                }
                for (int i = 0, len = objColumns.size(); i < len; i++) {
                    JSONObject objCol = (JSONObject) objColumns.get(i);
                    String strBindName = (String) objCol.get("bindName");
                    if (StringUtil.isNotBlank(strBindName)) {
                        String strDependEntityAttr = null;
                        for (EntityAttributeVO objEntityAttrVO : entityAttrs) {
                            if (AttributeSourceType.ENTITY.equals(objEntityAttrVO.getAttributeType().getSource())
                                && len > 1 && strBindName.equals(objEntityAttrVO.getEngName())) {
                                strDependEntityAttr = strBindName;
                                break;
                            } else if (strBindName.equals(objEntityAttrVO.getEngName())) {
                                strDependEntityAttr = strBindName;
                                break;
                            }
                        }
                        if (strDependEntityAttr != null) {
                            strMsg.append(strMsg.length() > 0 ? "、" : "").append("第【").append(i + 1)
                                .append("】列中的bindName的值").append("依赖了实体属性：").append(strDependEntityAttr);
                        }
                    }
                }
            }
        }
        ConsistencyCheckResult objRes = null;
        if (strMsg.length() > 0) {
            objRes = new ConsistencyCheckResult();
            objRes.setMessage("页面控件【" + data.getUiType() + "->" + data.getId() + "】" + strMsg.toString());
            objRes.setType(ConsistencyCheckResultType.CONSISTENCY_TYPE_PAGE_LAYOUT.getValue());
            Map<String, String> objAtrrMap = new HashMap<String, String>();
            objAtrrMap.put(ConsistencyResultAttrName.PAGE_ATTRNAME_PK.getValue(), page.getModelId());
            objAtrrMap.put(ConsistencyResultAttrName.PAGE_LAYOUT_ATTRNAME_PK.getValue(), data.getId());
            objAtrrMap.put(ConsistencyResultAttrName.PAGE_LAYOUT_ATTRNAME_COMPONENT_PRO.getValue(), COLUMNS);
            objRes.setAttrMap(objAtrrMap);
        }
        return objRes;
    }
    
    /**
     * 校验EditType属性是否依赖了当前传入的实体属性
     * 
     * @param baseMetadataVO 属性对象
     * @param entityAttrs 实体属性集合
     * @param relationDataStores 关联了当前校验实体的数据集
     * @param data 控件属性对象
     * @param page 页面对象
     * @return 校验结果
     */
    protected ConsistencyCheckResult checkEditTypeDependOnEntityAttr(BaseMetadata baseMetadataVO,
        List<EntityAttributeVO> entityAttrs, List<DataStoreVO> relationDataStores, LayoutVO data, PageVO page) {
        StringBuffer strMsg = new StringBuffer();
        String strEditType = (String) data.getOptions().get(EDITTYPE);
        if (StringUtils.isBlank(strEditType)) {
            return null;
        }
        JSONObject objEditType = JSONObject.parseObject(strEditType);
        if (objEditType.isEmpty()) {
            return null;
        }
        // 从扩展属性中获取绑定的数据集名称
        String strExtras = (String) data.getOptions().get("extras");
        if (StringUtil.isNotBlank(strExtras)) {
            JSONObject objExtras = JSONObject.parseObject(strExtras);
            String strDatastore = objExtras.getString("dataStoreEname");
            if (StringUtil.isNotBlank(strDatastore)) {
                boolean bExist = false;
                for (DataStoreVO objDataStoreVO : relationDataStores) {
                    if (strDatastore.equals(objDataStoreVO.getEname())) {
                        bExist = true;
                    }
                }
                if (!bExist) {
                    return null;
                }
                Set<String> objColKeySet = objEditType.keySet();
                Iterator<String> objColIterator = objColKeySet.iterator();
                while (objColIterator.hasNext()) {
                    String strColKey = objColIterator.next();
                    JSONObject objOptions = (JSONObject) objEditType.get(strColKey);
                    Set<String> objCmpKeySet = objOptions.keySet();
                    Iterator<String> objCmpIterator = objCmpKeySet.iterator();
                    while (objCmpIterator.hasNext()) {
                        String strUItype = objOptions.getString("uitype");
                        if ("ChooseUser".equals(strUItype) || "ChooseOrg".equals(strUItype)) {
                            String strM = this.checkEdittypeChooseUserOrgEntiAttr(entityAttrs,
                                objOptions.getString("idName"), "idName", strUItype, strColKey);
                            if (strM != null) {
                                strMsg.append(strM);
                            }
                            strM = this.checkEdittypeChooseUserOrgEntiAttr(entityAttrs,
                                objOptions.getString("valueName"), "valueName", strUItype, strColKey);
                            if (strM != null) {
                                strMsg.append(strM);
                            }
                            Pattern objPattern = Pattern.compile("\\{'codeName':[\\s]*'([\\w-\\.]*)'\\}");
                            Matcher objMatcher = objPattern.matcher(objOptions.getString("opts"));
                            String strOpts = objMatcher.replaceAll("$1");
                            strM = this.checkEdittypeChooseUserOrgEntiAttr(entityAttrs, strOpts, "opts", strUItype,
                                strColKey);
                            if (strM != null) {
                                strMsg.append(strM);
                            }
                        }
                    }
                }
            }
        }
        ConsistencyCheckResult objRes = null;
        if (strMsg.length() > 0) {
            objRes = new ConsistencyCheckResult();
            objRes.setMessage("页面控件【" + data.getUiType() + "->" + data.getId() + "】" + strMsg.toString());
            objRes.setType(ConsistencyCheckResultType.CONSISTENCY_TYPE_PAGE_LAYOUT.getValue());
            Map<String, String> objAtrrMap = new HashMap<String, String>();
            objAtrrMap.put(ConsistencyResultAttrName.PAGE_ATTRNAME_PK.getValue(), page.getModelId());
            objAtrrMap.put(ConsistencyResultAttrName.PAGE_LAYOUT_ATTRNAME_PK.getValue(), data.getId());
            objAtrrMap.put(ConsistencyResultAttrName.PAGE_LAYOUT_ATTRNAME_COMPONENT_PRO.getValue(), EDITTYPE);
            objRes.setAttrMap(objAtrrMap);
        }
        return objRes;
    }
    
    /**
     * 校验EditType控件（人员或组织）属性是否依赖了当前传入的实体属性
     * 
     * @param entityAttrs 实体属性集合
     * @param strValueName 控件属性值
     * @param strProName 控件属性名称
     * @param uitype 控件类型
     * @param colBindName 列绑定的属性变量
     * @return 校验结果
     */
    private String checkEdittypeChooseUserOrgEntiAttr(List<EntityAttributeVO> entityAttrs, String strValueName,
        String strProName, String uitype, String colBindName) {
        StringBuffer strMsg = new StringBuffer();
        for (EntityAttributeVO objEntityAttrVO : entityAttrs) {
            if (AttributeSourceType.ENTITY.equals(objEntityAttrVO.getAttributeType().getSource())
                && strValueName.equals(objEntityAttrVO.getEngName())) {
                strMsg.append(strMsg.length() > 0 ? "、" : "").append("bindName：").append(colBindName).append("对应的控件")
                    .append(uitype).append("中的").append(strProName).append("属性").append("依赖了实体属性：")
                    .append(strValueName);
            } else if (strValueName.equals(objEntityAttrVO.getEngName())) {
                strMsg.append(strMsg.length() > 0 ? "、" : "").append("bindName：").append(colBindName).append("对应的控件")
                    .append(uitype).append("中的").append(strProName).append("属性").append("依赖了实体属性：")
                    .append(strValueName);
            }
        }
        return strMsg.length() > 0 ? strMsg.toString() : null;
    }
    
    /**
     * 校验Primarykey属性是否依赖了当前传入的实体属性
     * 
     * @param property 属性对象
     * @param entityAttrs 实体属性集合
     * @param relationDataStores 关联了当前校验实体的数据集
     * @param data 控件属性对象
     * @param page 页面对象
     * @return 校验结果
     */
    protected ConsistencyCheckResult checkPrimarykeyDependOnEntityAttr(PropertyVO property,
        List<EntityAttributeVO> entityAttrs, List<DataStoreVO> relationDataStores, LayoutVO data, PageVO page) {
        DataStoreComponentAttrConsisCheck objCheck = (DataStoreComponentAttrConsisCheck) ConsistencyCheckUtil
            .getConsistencyCheck(DATASTORE_COMPONENT_ATTR_CONSISCHECK_CLASS, IComponentAttrConsisCheck.class);
        String strEname = property.getEname();
        String strValue = (String) data.getOptions().get(strEname);
        if (StringUtil.isBlank(strValue)) {
            return null;
        }
        String strExtras = (String) data.getOptions().get("extras");
        if (StringUtil.isBlank(strExtras)) {
            return null;
        }
        JSONObject objExtras = JSONObject.parseObject(strExtras);
        String strDatastore = objExtras.getString("dataStoreEname");
        if (StringUtil.isBlank(strDatastore)) {
            return null;
        }
        return objCheck.execCheckDependOnEntityAttrHandler(data, entityAttrs, relationDataStores, page, strDatastore
            + "." + strValue, strEname);
    }
}
