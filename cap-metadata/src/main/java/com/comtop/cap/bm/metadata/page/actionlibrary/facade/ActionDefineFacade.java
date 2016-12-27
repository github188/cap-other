/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.actionlibrary.facade;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.base.facade.CapBmBaseFacade;
import com.comtop.cap.bm.metadata.common.dwr.CapMap;
import com.comtop.cap.bm.metadata.common.model.CuiTreeNodeVO;
import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.common.storage.exception.ValidateException;
import com.comtop.cap.bm.metadata.entity.facade.EntityFacade;
import com.comtop.cap.bm.metadata.entity.model.MethodVO;
import com.comtop.cap.bm.metadata.page.actionlibrary.model.ActionDefineVO;
import com.comtop.cap.bm.metadata.page.actionlibrary.model.ActionTypeVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageActionVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.cap.bm.metadata.page.uilibrary.model.PropertyEditorUIVO;
import com.comtop.cap.bm.metadata.page.uilibrary.model.PropertyVO;
import com.comtop.cip.common.validator.ValidateResult;
import com.comtop.cip.common.validator.ValidatorUtil;
import com.comtop.cip.jodd.io.FileUtil;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.json.JSON;
import com.comtop.corm.resource.util.CollectionUtils;
import com.comtop.top.component.common.systeminit.WebGlobalInfo;
import com.comtop.top.core.jodd.AppContext;
import com.comtop.top.core.util.StringConvertUtils;
import com.comtop.top.core.util.StringUtil;
import com.comtop.top.core.util.constant.NumberConstant;
import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;

/**
 * 行为定义facade类
 *
 * @author 诸焕辉
 * @version jdk1.6
 * @version 2015-6-03 诸焕辉
 */
@DwrProxy
@PetiteBean
public class ActionDefineFacade extends CapBmBaseFacade {
    
    /** 日志 */
    private final static Logger LOG = LoggerFactory.getLogger(ActionDefineFacade.class);
    
    /** 默认行为类型 */
    private final static String DEFAULT_ACTIONTYPE = "actionlibrary.actionType.customBase";
    
    /** 实体 Facade */
    private final EntityFacade entityFacade = AppContext.getBean(EntityFacade.class);
    
    /**
     * 获取所有行为定义
     *
     * @return 行为定义属性集合
     * @throws OperateException 异常
     */
    @SuppressWarnings("unchecked")
    @RemoteMethod
    public List<ActionDefineVO> queryList() throws OperateException {
        List<ActionDefineVO> lstActionDefineVO = CacheOperator.queryList("action");
        return lstActionDefineVO;
    }
    
    /**
     *
     * 获取所有行为名称(中英文名称),当作PullDown数据源
     *
     * @return 行为集合
     * @throws OperateException 异常
     */
    @SuppressWarnings("unchecked")
    @RemoteMethod
    public List<Map<String, String>> queryActionNameList() throws OperateException {
        List<Map<String, String>> lstActionName = null;
        List<ActionDefineVO> lstActionDefineVO = CacheOperator.queryList("action");
        if (lstActionDefineVO != null && lstActionDefineVO.size() > NumberConstant.ZERO) {
            lstActionName = new ArrayList<Map<String, String>>();
            for (ActionDefineVO actionDefineVO : lstActionDefineVO) {
                Map<String, String> objActionName = new HashMap<String, String>(lstActionName.size());
                objActionName.put("id", actionDefineVO.getModelName());
                objActionName.put("text", actionDefineVO.getCname());
                lstActionName.add(objActionName);
            }
        }
        return lstActionName;
    }
    
    /**
     * 根据控件英文名称加载模型文件
     *
     * @param modelId 行为模板ID
     * @return 操作结果
     * @throws OperateException xml操作异常
     */
    @SuppressWarnings("unchecked")
    @RemoteMethod
    public ActionDefineVO loadModelByModelId(String modelId) throws OperateException {
        ActionDefineVO objActionDefineVO = null;
        if (StringUtils.isNotBlank(modelId)) {
            List<ActionDefineVO> lstComponentVO = CacheOperator.queryList("action[modelId='" + modelId + "']",
                NumberConstant.ONE);
            if (lstComponentVO != null && lstComponentVO.size() > NumberConstant.ZERO) {
                objActionDefineVO = lstComponentVO.get(NumberConstant.ZERO);
            }
        }
        return objActionDefineVO;
    }
    
    /**
     * 根据控件英文名称加载模型文件
     *
     * @param modelIds 行为模板IDs
     * @return 操作结果
     * @throws OperateException xml操作异常
     */
    @RemoteMethod
    public List<ActionDefineVO> loadModelByModelIds(String[] modelIds) throws OperateException {
        List<ActionDefineVO> lstComponentVO = new ArrayList<ActionDefineVO>();
        for (int i = 0; i < modelIds.length; i++) {
            ActionDefineVO objActionDefineVO = (ActionDefineVO) CacheOperator.readById(modelIds[i]);
            lstComponentVO.add(objActionDefineVO);
        }
        return lstComponentVO;
    }
    
    /**
     * 加载模型文件
     *
     * @param id 控件模型ID
     * @return 操作结果
     */
    @RemoteMethod
    public ActionDefineVO loadModel(String id) {
        return (ActionDefineVO) CacheOperator.readById(id);
    }
    
    /**
     * 验证VO对象
     *
     * @param model 被校验对象
     * @return 结果集
     */
    @SuppressWarnings("rawtypes")
    @RemoteMethod
    public ValidateResult validate(ActionDefineVO model) {
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
    public boolean saveModel(ActionDefineVO model) throws ValidateException {
        String strCnPackageName = model.getModelPackageCnName();
        String strPart = "";
        if (StringUtils.isNotBlank(strCnPackageName)) {
            strPart = StringConvertUtils.getFullSpell(strCnPackageName);
        }
        model
            .setModelPackage("actionlibrary.customAction" + (StringUtils.isBlank(strPart) ? strPart : ("." + strPart)));
        if (StringUtils.isBlank(model.getModelId())) {
            model.setModelId(model.getModelPackage() + "." + model.getModelType() + "." + model.getModelName());
        }
        addToActionType(strCnPackageName, strPart, model.getModelId(), model.getCname());
        return model.saveModel();
    }
    
    /**
     * 添加到ActionTyep中
     *
     * @param packageCnName 包中文名称
     * @param packageEnName 包英文名称
     * @param actionId 行为Id
     * @param actionName 行为名称
     * @throws ValidateException 验证异常
     */
    private void addToActionType(String packageCnName, String packageEnName, String actionId, String actionName)
        throws ValidateException {
        ActionTypeVO objActionTypeVO = (ActionTypeVO) CacheOperator.readById(DEFAULT_ACTIONTYPE);
        if (objActionTypeVO == null) {
            objActionTypeVO = ActionTypeVO.createMetaDataFile(DEFAULT_ACTIONTYPE);
        }
        List<CuiTreeNodeVO> lstNodes = objActionTypeVO.getDatasource();
        CuiTreeNodeVO objCustomNode = null;
        if (lstNodes != null) {
            for (CuiTreeNodeVO node : lstNodes) {
                if ("code_9".equals(node.getId())) {
                    objCustomNode = node;
                }
            }
        } else {
            lstNodes = new ArrayList<CuiTreeNodeVO>();
            objActionTypeVO.setDatasource(lstNodes);
        }
        if (objCustomNode == null) {
            objCustomNode = createCustomNode();
            lstNodes.add(objCustomNode);
        }
        List<CuiTreeNodeVO> lstChildrenPackages = objCustomNode.getChildren();
        if (lstChildrenPackages == null) {
            lstChildrenPackages = new ArrayList<CuiTreeNodeVO>();
            objCustomNode.setChildren(lstChildrenPackages);
        }
        CuiTreeNodeVO objPackage = null;
        CuiTreeNodeVO objActionNode = null;
        for (CuiTreeNodeVO objChildrenPackage : lstChildrenPackages) {
            if (StringUtils.isNotBlank(packageEnName)) {
                if (packageEnName.equals(objChildrenPackage.getId())) {
                    objPackage = objChildrenPackage;
                }
            } else {
                if (actionId.equals(objChildrenPackage.getId())) {
                    objActionNode = objChildrenPackage;
                }
            }
        }
        if (StringUtils.isNotBlank(packageEnName)) {
            if (objPackage == null) {
                objPackage = new CuiTreeNodeVO();
                objPackage.setId(packageEnName);
                objPackage.setTitle(packageCnName);
                objPackage.setKey(packageEnName);
                objPackage.setIsFolder(true);
                objPackage.setParentId("code_9");
                lstChildrenPackages.add(objPackage);
            }
            List<CuiTreeNodeVO> lstActionNodes = objPackage.getChildren();
            if (lstActionNodes == null) {
                lstActionNodes = new ArrayList<CuiTreeNodeVO>();
                objPackage.setChildren(lstActionNodes);
            }
            for (CuiTreeNodeVO actionNode : lstActionNodes) {
                if (actionId.equals(actionNode.getId())) {
                    objActionNode = actionNode;
                }
            }
        }
        if (objActionNode == null) {
            objActionNode = new CuiTreeNodeVO();
            objActionNode.setId(actionId);
            objActionNode.setTitle(actionName);
            objActionNode.setKey(actionId);
            objActionNode.setIsFolder(false);
            if (StringUtils.isNotBlank(packageEnName) && objPackage != null) {
                objActionNode.setParentId(packageEnName);
                objPackage.getChildren().add(objActionNode);
            } else {
                objActionNode.setParentId("code_9");
                lstChildrenPackages.add(objActionNode);
            }
            objActionTypeVO.saveModel();
        }
    }
    
    /**
     * 创建自定义行为节点
     *
     * @return 自定义行为节点
     */
    private CuiTreeNodeVO createCustomNode() {
        CuiTreeNodeVO objNode = new CuiTreeNodeVO();
        objNode.setId("code_9");
        objNode.setTitle("自定义扩展行为");
        objNode.setKey("customAction");
        objNode.setIsFolder(true);
        objNode.setParentId("0");
        return objNode;
    }
    
    /**
     * 删除模型
     *
     * @param model 被删除的对象
     * @return 是否成功
     * @throws OperateException 异常
     * @throws ValidateException 验证异常
     */
    @RemoteMethod
    public boolean deleteModel(ActionDefineVO model) throws OperateException, ValidateException {
        if (isActionUsed(model.getModelId())) {
            return false;
        }
        boolean ret = model.deleteModel();
        if (ret) {
            removeActionType(model);
        }
        return ret;
    }
    
    /**
     * 获取控件模型下所有实体
     * 
     * @param <T> 类型
     * @param expression 表达式
     * @return 行为定义集合
     * @throws OperateException 异常
     */
    @SuppressWarnings("unchecked")
    @RemoteMethod
    public <T> List<T> queryList(String expression) throws OperateException {
        List<T> lstTVO = CacheOperator.queryList(expression);
        return lstTVO;
    }
    
    /**
     * 分析行为是否被引用
     *
     * @param actionId 行为的ModelId
     * @param lstPageVO lstPageVO
     * @return 是否被页面引用
     */
    private boolean isActionUsed(String actionId, List<PageVO> lstPageVO) {
        boolean bResult = false;
        for (PageVO objPageVO : lstPageVO) {
            List<PageActionVO> lstAction = objPageVO.getPageActionVOList();
            if (lstAction == null || lstAction.isEmpty()) {
                continue;
            }
            for (PageActionVO objAction : lstAction) {
                String strTemplate = objAction.getMethodTemplate();
                if (actionId.equals(strTemplate)) {
                    return true;
                }
            }
        }
        return bResult;
    }
    
    /**
     * 分析行为是否被引用
     *
     * @param actionId 行为的ModelId
     * @return 是否被页面引用
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public boolean isActionUsed(String actionId) throws OperateException {
        boolean bResult = false;
        // 获取所有页面
        List<PageVO> lstPageVO = CacheOperator.queryList("/page", PageVO.class);
        for (PageVO objPageVO : lstPageVO) {
            List<PageActionVO> lstAction = objPageVO.getPageActionVOList();
            if (lstAction == null || lstAction.isEmpty()) {
                continue;
            }
            for (PageActionVO objAction : lstAction) {
                String strTemplate = objAction.getMethodTemplate();
                if (actionId.equals(strTemplate)) {
                    return true;
                }
            }
        }
        return bResult;
    }
    
    /**
     * 判断是否存在相同的行为
     *
     * <pre>
     * 
     * </pre>
     * 
     * @param modelName 行为名称
     * @param packageCnName 行为包中文名
     * @return true
     * @throws OperateException OperateException
     */
    @RemoteMethod
    public boolean isExistSameAction(String modelName, String packageCnName) throws OperateException {
        boolean bResult = false;
        String strPart = "";
        if (StringUtils.isNotBlank(packageCnName)) {
            strPart = StringConvertUtils.getFullSpell(packageCnName) + ".";
        }
        String strActionId = "actionlibrary.customAction." + strPart + "action." + modelName;
        String strExpression = "action[contains(modelPackage,'actionlibrary.customAction')]";
        List<ActionDefineVO> lstActionDefineVO = this.queryList(strExpression);
        for (ActionDefineVO objActionDefineVO : lstActionDefineVO) {
            String strModelId = objActionDefineVO.getModelId();
            if (strModelId.equals(strActionId)) {
                bResult = true;
                break;
            }
        }
        return bResult;
    }
    
    /**
     * 删除自定义行为集合
     *
     * @param modelIds ModelId
     * @return 不能删除的行为ID集合
     * @throws OperateException 操作异常
     * @throws ValidateException 验证异常
     */
    @RemoteMethod
    public List<String> deleteList(String[] modelIds) throws OperateException, ValidateException {
        if (modelIds == null || modelIds.length == 0) {
            return null;
        }
        List<String> lstRemain = new ArrayList<String>();
        // 获取所有页面
        List<PageVO> lstPageVO = CacheOperator.queryList("/page", PageVO.class);
        String modelId;
        for (int i = 0; i < modelIds.length; i++) {
            modelId = modelIds[i];
            if (isActionUsed(modelId, lstPageVO)) {
                lstRemain.add(modelId);
            } else {
                ActionDefineVO objActionDefineVO = (ActionDefineVO) CacheOperator.readById(modelIds[i]);
                boolean ret = objActionDefineVO.deleteModel();
                if (ret) {
                    removeActionType(objActionDefineVO);
                } else {
                    lstRemain.add(modelId);
                }
            }
        }
        return lstRemain;
    }
    
    /**
     * 删除行为类型
     *
     * @param action 行为类型
     * @throws ValidateException 验证异常
     */
    private void removeActionType(ActionDefineVO action) throws ValidateException {
        String strCnPackageName = action.getModelPackageCnName();
        String strPart = "";
        if (StringUtils.isNotBlank(strCnPackageName)) {
            strPart = StringConvertUtils.getFullSpell(strCnPackageName);
        }
        String strActionId = action.getModelId();
        ActionTypeVO objActionTypeVO = (ActionTypeVO) CacheOperator.readById(DEFAULT_ACTIONTYPE);
        if (objActionTypeVO == null) {
            return;
        }
        List<CuiTreeNodeVO> lstNodes = objActionTypeVO.getDatasource();
        CuiTreeNodeVO objCustomNode = null;
        if (lstNodes == null) {
            return;
        }
        for (CuiTreeNodeVO node : lstNodes) {
            if ("code_9".equals(node.getId())) {
                objCustomNode = node;
            }
        }
        if (objCustomNode == null) {
            return;
        }
        List<CuiTreeNodeVO> lstChildrenPackages = objCustomNode.getChildren();
        if (lstChildrenPackages == null) {
            return;
        }
        CuiTreeNodeVO objPackage = null;
        CuiTreeNodeVO objActionNode = null;
        for (CuiTreeNodeVO objChildrenPackage : lstChildrenPackages) {
            if (StringUtils.isNotBlank(strPart)) {
                if (strPart.equals(objChildrenPackage.getId())) {
                    objPackage = objChildrenPackage;
                }
            } else {
                if (strActionId.equals(objChildrenPackage.getId())) {
                    objActionNode = objChildrenPackage;
                }
            }
        }
        if (StringUtils.isNotBlank(strPart)) {
            if (objPackage == null) {
                return;
            }
            List<CuiTreeNodeVO> lstActionNodes = objPackage.getChildren();
            if (lstActionNodes == null) {
                return;
            }
            for (CuiTreeNodeVO actionNode : lstActionNodes) {
                if (strActionId.equals(actionNode.getId())) {
                    objActionNode = actionNode;
                }
            }
        }
        String strFolderPath = null;
        if (objActionNode != null) {
            if (StringUtils.isNotBlank(strPart) && objPackage != null) {
                objPackage.getChildren().remove(objActionNode);
                if (objPackage.getChildren().isEmpty()) {
                    lstChildrenPackages.remove(objPackage);
                    strFolderPath = WebGlobalInfo.getWebInfoPath() + File.separator
                        + "metadata/actionlibrary/customAction/" + objPackage.getId().replace('.', '/');
                }
            } else {
                lstChildrenPackages.remove(objActionNode);
            }
            objActionTypeVO.saveModel();
        }
        if (StringUtils.isNotBlank(strFolderPath)) {
            try {
                FileUtil.deleteDir(strFolderPath);
            } catch (IOException e) {
                LOG.error("删除元数据目录{0}失败!{1}", strFolderPath, e);
            }
        }
    }
    
    /**
     * 完善页面行为属性，如：设置行为信息
     * 
     * @param lstPageActionVO 页面行为对象
     * @throws OperateException 异常
     */
    public void perfectPageAction(List<PageActionVO> lstPageActionVO) throws OperateException {
        try {
            if (lstPageActionVO == null || lstPageActionVO.isEmpty()) {
                return;
            }
            for (int i = 0; i < lstPageActionVO.size(); i++) {
                PageActionVO objPageActionVO = lstPageActionVO.get(i);
                ActionDefineVO objActionDefineVO = this.loadModel(objPageActionVO.getMethodTemplate());
                if (objActionDefineVO != null) {
                    try {
                        clearDeprecatedScript(objPageActionVO, objActionDefineVO);
                        ActionDefineVO objNewActionDefineVO = (ActionDefineVO) objActionDefineVO.clone();
                        objPageActionVO.setInitPropertiesCount(objNewActionDefineVO.getProperties().size());
                        objPageActionVO.setActionDefineVO(objNewActionDefineVO);
                        // 如果是action行为
                        if (objPageActionVO.getMethodOption().get("methodId") != null
                            && StringUtil.isNotBlank((String) objPageActionVO.getMethodOption().get("methodId"))) {
                            setActioncallAction(objPageActionVO);
                        } else if ("pageJump".equals(objActionDefineVO.getModelName())) {
                            // 如果是页面跳转行为
                            setPageJumpAction(objPageActionVO);
                        }
                    } catch (Exception e) {
                        LOG.error("设置行为ActionDefineVO失败", e);
                    }
                }
            }
        } catch (Exception e) {
            LOG.error("设置行为信息错误", e);
            throw new OperateException("设置行为信息错误", e);
        }
    }
    
    /**
     * 对PageActionVO中的methodBodyExtend（即行为中的<code><script/></code>集合）进行检查，去掉无用的script扩展。
     * 造成PageActionVO中存在无用的script扩展，可能是删除了行为模板中的<code><script/></code>，但元数据中依然存在。
     * 只有下次在设计器中重新打开这个界面（将会调用此检查函数），并执行保存操作，保存之后的元数据就不再有无用的script扩展。
     * 
     * @param actionVO 检查的PageActionVO对象
     * @param objActionDefineVO PageActionVO对象的行为模板对象
     */
    private void clearDeprecatedScript(PageActionVO actionVO, ActionDefineVO objActionDefineVO) {
        // 获取行为模板的script模板
        String script = objActionDefineVO.getScript();
        Pattern pattern = Pattern.compile("<[\\s]*script[\\s]+name[\\s]*=[\\s]*\"(\\w+)\"[\\s]*/>",
            Pattern.CASE_INSENSITIVE);
        Matcher matcher = pattern.matcher(script);
        // 获取script模板中的script占位符的名称集合。如<script name="setDataAfter"/>，名称为setDataAfter
        Set<String> scriptSet = new HashSet<String>();
        while (matcher.find()) {
            scriptSet.add(matcher.group(1));
        }
        // 获取行为VO中的script键值对
        CapMap map = actionVO.getMethodBodyExtend();
        if (!CollectionUtils.isEmpty(scriptSet) && !CollectionUtils.isEmpty(map)) {
            // 遍历行为VO中的script键值对
            Iterator<Map.Entry<String, String>> it = map.entrySet().iterator();
            while (it.hasNext()) {
                Map.Entry<String, String> entry = it.next();
                // 如果遍历的键在行为模板的script占位符名称集合中没有，则从行为VO中去掉。
                if (!scriptSet.contains(entry.getKey())) {
                    it.remove();
                }
            }
        }
    }
    
    /**
     * 设置action行为
     * 
     * @param pageActionVO 行为对象
     */
    private void setActioncallAction(PageActionVO pageActionVO) {
        // com.comntop.user.entity.Human/queryVOListByPage
        String id = (String) pageActionVO.getMethodOption().get("methodId");
        Pattern p = Pattern.compile("^([^/]+)/([^/]+)$");
        Matcher matcher = p.matcher(id);
        String entityId = null;
        String methodName = null;
        if (matcher.find()) {
            entityId = matcher.group(1);
            methodName = matcher.group(2);
        } else {
            throw new RuntimeException("行为[" + pageActionVO.getCname() + "(" + pageActionVO.getEname()
                + ")]对象中存储的方法id非法,合法的id为：实体id/方法名称");
        }
        List<MethodVO> lstMethods = entityFacade.getSelfAndParentMethods(entityId);
        MethodVO objMethodVO = null;
        if (!CollectionUtils.isEmpty(lstMethods)) {
            for (MethodVO methodVO : lstMethods) {
                if (methodName.equals(methodVO.getEngName())) {
                    objMethodVO = methodVO;
                    break;
                }
            }
        }
        if (objMethodVO == null) {
            pageActionVO.getMethodOption().clear();
        } else {
            boolean bReturnType = "void".equals(objMethodVO.getReturnType().getType()) ? false : true;
            int iCount = objMethodVO.getParameters().size();
            String methodAliasName = StringUtil.isNotBlank(objMethodVO.getAliasName()) ? objMethodVO.getAliasName()
                : objMethodVO.getEngName();
            pageActionVO.getMethodOption().put("actionMethodName", methodAliasName);
            if (!"false".equals(pageActionVO.getMethodOption().get("isGenerateParameterForm"))) {
                ActionDefineVO objActionDefineVO = pageActionVO.getActionDefineVO();
                List<PropertyVO> lstPropertyVO = objActionDefineVO.getProperties();
                if (bReturnType) {
                    PropertyVO objPropertyVO = createMethodDefineProperty("返回值", "returnValueBind");
                    lstPropertyVO.add(objPropertyVO);
                }
                
                for (int i = 1; i <= iCount; i++) {
                    PropertyVO objPropertyVO = createMethodDefineProperty("参数" + i, "methodParameter" + i);
                    lstPropertyVO.add(objPropertyVO);
                }
            }
        }
    }
    
    /**
     * 创建方法定义属性
     * 
     * @param cname 属性中文名
     * @param ename 属性英文名
     * @return 属性VO
     */
    private PropertyVO createMethodDefineProperty(String cname, String ename) {
        PropertyVO objPropertyVO = new PropertyVO();
        objPropertyVO.setCname(cname);
        objPropertyVO.setEname(ename);
        objPropertyVO.setType("String");
        objPropertyVO.setRequried(true);
        objPropertyVO.setDescription("");
        PropertyEditorUIVO objPropertyEditorUIVO = new PropertyEditorUIVO();
        objPropertyEditorUIVO.setComponentName("cui_clickinput");
        objPropertyEditorUIVO.setScript("{\"ng-model\":\"" + ename + "\",\"onclick\":\"openDataStoreSelect(\'" + ename
            + "\')\"}");
        objPropertyVO.setPropertyEditorUI(objPropertyEditorUIVO);
        return objPropertyVO;
    }
    
    /**
     * 设置页面跳转行为
     * 
     * @param pageActionVO 页面行为对象
     */
    private void setPageJumpAction(PageActionVO pageActionVO) {
        String strPageAttributeVOString = (String) pageActionVO.getMethodOption().get("pageAttributeVOString");
        if (StringUtil.isNotBlank(strPageAttributeVOString)) {
            pageActionVO.getMethodOption().put("pageAttributeVOList", JSON.parse(strPageAttributeVOString));
        }
    }
}
