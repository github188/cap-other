/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.template.facade;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.base.facade.CapBmBaseFacade;
import com.comtop.cap.bm.metadata.common.dwr.CapMap;
import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.common.storage.exception.ValidateException;
import com.comtop.cap.bm.metadata.entity.facade.EntityFacade;
import com.comtop.cap.bm.metadata.entity.model.MethodVO;
import com.comtop.cap.bm.metadata.page.desinger.facade.PageFacade;
import com.comtop.cap.bm.metadata.page.template.model.HiddenComponentVO;
import com.comtop.cap.bm.metadata.page.template.model.MenuAreaComponentVO;
import com.comtop.cap.bm.metadata.page.template.model.MetadataGenerateVO;
import com.comtop.cap.bm.metadata.page.template.model.MetadataPageConfigVO;
import com.comtop.cap.bm.metadata.page.template.model.MetadataValueVO;
import com.comtop.cap.bm.metadata.sysmodel.facade.SysmodelFacade;
import com.comtop.cap.bm.metadata.sysmodel.model.CapPackageVO;
import com.comtop.cip.common.validator.ValidateResult;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.json.JSONObject;
import com.comtop.corm.resource.util.CollectionUtils;
import com.comtop.top.core.jodd.AppContext;
import com.comtop.top.core.util.StringUtil;
import com.comtop.top.sys.accesscontrol.func.facade.FuncFacade;
import com.comtop.top.sys.accesscontrol.func.facade.IFuncFacade;
import com.comtop.top.sys.accesscontrol.func.model.FuncDTO;
import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;

/**
 * 元数据生成facade类
 *
 * @author 诸焕辉
 * @since jdk1.6
 * @version 2015-10-12 诸焕辉
 */
@DwrProxy
@PetiteBean
public class MetadataGenerateFacade extends CapBmBaseFacade {
    
    /** 日志 */
    private final static Logger LOG = LoggerFactory.getLogger(PageFacade.class);
    
    /** 包Facade */
    private final SysmodelFacade packageFacade = AppContext.getBean(SysmodelFacade.class);
    
    /**
     * 页面/菜单 facade
     */
    protected IFuncFacade funcFacade = AppContext.getBean(FuncFacade.class);
    
    /**
     * 页面 facade
     */
    protected PageFacade pageFacade = AppContext.getBean(PageFacade.class);
    
    /**
     * 加载模型文件
     *
     * @param modelId 控件模型ID
     * @param packageId 当前模块PackageVO 主键
     * @return 操作结果
     */
    @RemoteMethod
    public MetadataGenerateVO loadModel(String modelId, String packageId) {
        MetadataGenerateVO objMetadataGenerateVO = new MetadataGenerateVO();
        if (StringUtils.isNotBlank(modelId)) {
            objMetadataGenerateVO = (MetadataGenerateVO) CacheOperator.readById(modelId);
        } else {
            objMetadataGenerateVO.setModelPackage(this.getPackageVO(packageId).getFullPath());
            MetadataValueVO objMetadataValueVO = new MetadataValueVO();
            this.setPageDefaultParent(objMetadataValueVO, packageId);
            objMetadataGenerateVO.setMetadataValue(objMetadataValueVO);
        }
        return objMetadataGenerateVO;
    }
    
    /**
     * 根据包id获取上级目录名称
     * 
     * @param objMetadataValue 元数据数据源
     * @param packageId 模块Id
     */
    private void setPageDefaultParent(MetadataValueVO objMetadataValue, String packageId) {
        FuncDTO objQueryFuncDTO = new FuncDTO();
        objQueryFuncDTO.setParentFuncId(packageId);
        objQueryFuncDTO.setParentFuncType("MODULE");
        List<FuncDTO> lstFunc = funcFacade.queryFuncChild(objQueryFuncDTO);
        if (!CollectionUtils.isEmpty(lstFunc)) {
            MenuAreaComponentVO objMenuAreaComponentVO = new MenuAreaComponentVO();
            objMenuAreaComponentVO.setId("parentName");
            objMenuAreaComponentVO.setName(objMenuAreaComponentVO.getId());
            objMenuAreaComponentVO.setValue(lstFunc.get(0).getFuncName());
            objMetadataValue.getMenuComponentList().add(objMenuAreaComponentVO);
            
            HiddenComponentVO objHiddenComponentVO = new HiddenComponentVO();
            objHiddenComponentVO.setId("parentId");
            objHiddenComponentVO.setName(objHiddenComponentVO.getId());
            objHiddenComponentVO.setValue(lstFunc.get(0).getFuncId());
            objMetadataValue.getHiddenComponentList().add(objHiddenComponentVO);
        }
    }
    
    /**
     * 根据packageId 查询对应上级菜单信息
     * @param packageId packageId
     * @return FuncDTO
     */
    @RemoteMethod
    public FuncDTO queryMenuByPackageId(String packageId) {
    	FuncDTO objQueryFuncDTO = new FuncDTO();
        objQueryFuncDTO.setParentFuncId(packageId);
        objQueryFuncDTO.setParentFuncType("MODULE");
        List<FuncDTO> lstFunc = funcFacade.queryFuncChild(objQueryFuncDTO);
        if (!CollectionUtils.isEmpty(lstFunc)) {
        	return lstFunc.get(0);
        }
        return null;
    }
    
    /**
     * 查询生成数据源列表
     *
     * @param modelPackage 查询当前模块下的页面
     * @return 页面对象集合
     * @throws OperateException 异常
     */
    @RemoteMethod
    public List<MetadataGenerateVO> queryMetadataGenerateList(String modelPackage) throws OperateException {
        CapPackageVO objPackageVO = getPackageVO(modelPackage);
        String strPackageName = objPackageVO.getFullPath();
        List<MetadataGenerateVO> lstMetadataGenerateVO = CacheOperator.queryList(strPackageName + "/metadataGenerate",
            MetadataGenerateVO.class);
        return lstMetadataGenerateVO;
    }
    
    /**
     * 删除模型
     *
     * @param models ID集合
     * @return 是否成功
     */
    @RemoteMethod
    public boolean deleteModels(String[] models) {
        boolean bResult = true;
        try {
            for (int i = 0; i < models.length; i++) {
                MetadataGenerateVO.deleteModel(models[i]);
            }
        } catch (Exception e) {
            bResult = false;
            LOG.error("删除模型文件失败", e);
        }
        return bResult;
    }
    
    /**
     * 保存
     *
     * @param metadataGenerateVO 被保存的对象
     * @return 操作结果
     * @throws ValidateException 校验失败异常
     */
    @RemoteMethod
    public MetadataGenerateVO saveModel(MetadataGenerateVO metadataGenerateVO) throws ValidateException {
        return saveModel(metadataGenerateVO, null, null);
    }
    
    /**
     * 保存
     *
     * @param metadataGenerateVO 被保存的对象
     * @param cascadeMethodList 需要新增级联方法列表
     * @param entityId 	新建级联方法的实体id
     * @return 操作结果
     * @throws ValidateException 校验失败异常
     */
    @RemoteMethod
    public MetadataGenerateVO saveModel(MetadataGenerateVO metadataGenerateVO, List<MethodVO> cascadeMethodList, String entityId) throws ValidateException {
    	EntityFacade entityFacade = AppContext.getBean(EntityFacade.class);
    	entityFacade.saveCascadeMethodList(cascadeMethodList, entityId);
        boolean bResult = metadataGenerateVO.saveModel();
        return bResult ? metadataGenerateVO : null;
    }
    
    /**
     * 验证VO对象
     *
     * @param metadataGenerateVO 被校验对象
     * @return 结果集
     */
    @RemoteMethod
    public ValidateResult<MetadataGenerateVO> validate(MetadataGenerateVO metadataGenerateVO) {
        ValidateResult<MetadataGenerateVO> objValidateResult = null;
        return objValidateResult;
    }
    
    /**
     * 
     * @param packageId 包对象Id
     * @return 包对象
     */
    @RemoteMethod
    private CapPackageVO getPackageVO(String packageId) {
        CapPackageVO objPackageVO = packageFacade.queryPackageById(packageId);
        return objPackageVO;
    }
    
    /**
     * 加载模型文件
     *
     * @param modelId 控件模型ID
     * @return 操作结果
     */
    @RemoteMethod
    public MetadataGenerateVO readModel(String modelId) {
        MetadataGenerateVO objMetadataGenerateVO = null;
        if (StringUtils.isNotBlank(modelId)) {
            objMetadataGenerateVO = (MetadataGenerateVO) CacheOperator.readById(modelId);
            if(objMetadataGenerateVO != null) {
            	MetadataPageConfigVO objMetadataPageConfigVO = (MetadataPageConfigVO) CacheOperator
            			.readById(objMetadataGenerateVO.getMetadataPageConfigModelId());
            	objMetadataGenerateVO.setMetadataPageConfigVO(objMetadataPageConfigVO);
            	
            }
        }
        return objMetadataGenerateVO;
    }
    
    /**
     * 
     * 根据元数据信息生成JSon文件
     *
     * @param metadataGenerateVO 元数据对象
     * @param cascadeMethodList 需要新增级联方法列表
     * @param entityId 	新建级联方法的实体id
     * @return boolean 返回生成操作是否成功
     * @throws ValidateException 校验失败异常
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public Map<String, String> generateMetadataById(MetadataGenerateVO metadataGenerateVO, List<MethodVO> cascadeMethodList, String entityId) throws ValidateException,
        OperateException {
        MetadataGenerateVO objMetadataGenerateVO = this.saveModel(metadataGenerateVO, cascadeMethodList, entityId);
        MetadataPageConfigVO objMetadataPageConfigVO = (MetadataPageConfigVO) CacheOperator
            .readById(objMetadataGenerateVO.getMetadataPageConfigModelId());
        objMetadataGenerateVO.setMetadataPageConfigVO(objMetadataPageConfigVO);
        return this.generateMetadataFile(objMetadataGenerateVO);
    }
    
    /**
     * 
     * 根据元数据信息生成JSon文件
     *
     * @param metadataGenerateVO 元数据对象
     * @return boolean 返回生成操作是否成功
     * @throws ValidateException 校验失败异常
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public Map<String, String> generateMetadataById(MetadataGenerateVO metadataGenerateVO) throws ValidateException,
        OperateException {
        return generateMetadataById(metadataGenerateVO, null, null);
    }
    
    /**
     * 
     * 根据元数据信息生成JSon文件
     *
     * @param lstIds 元数据对象Id集合
     * @return boolean 返回生成操作是否成功
     * @throws OperateException 操作异常
     * @throws ValidateException 校验异常
     */
    @SuppressWarnings("rawtypes")
    @RemoteMethod
    public Map<String, String> generateMetadataByIds(List lstIds) throws OperateException, ValidateException {
        Map<String, String> objResult = null;
        // 循环读取元数据ID
        for (Iterator iterator = lstIds.iterator(); iterator.hasNext();) {
            // String strId = "com.comtop.inventory.metadataGenerate.defectList";
            String strId = (String) iterator.next();
            MetadataGenerateVO objMetadataGenerateVO = this.readModel(strId);
            // 元数据不为空时进行生成Json文件操作
            if (objMetadataGenerateVO != null) {
                objResult = this.generateMetadataFile(objMetadataGenerateVO);
            }
        }
        return objResult;
    }
    
    /**
     * 
     * 生成元数据文件
     *
     * @param metadataGenerateVO 元数据对象
     * @return 返回生成操作结果信息
     * @throws OperateException 操作异常
     * @throws ValidateException 验证异常
     */
    @SuppressWarnings("unchecked")
    private Map<String, String> generateMetadataFile(MetadataGenerateVO metadataGenerateVO) throws OperateException,
        ValidateException {
        Map<String, Object> objGenResult = new HashMap<String, Object>();
        // 使用FTL模板生成Json
        try {
            if (metadataGenerateVO.getMetadataPageConfigVO().isDefaultTemplate()) {
                objGenResult = new PageGenerate4DefaultFtlTemp().generatePageJson(metadataGenerateVO);
            } else {
                objGenResult = new PageGenerate4CustomTmp().generatePageJson(metadataGenerateVO);
            }
        } catch (Exception e) {
            LOG.error("生成页面元数据失败！", e);
        }
        Map<String, String> objLogInfo = new HashMap<String, String>();
        MetadataPageConfigVO objMetadataPageConfig = metadataGenerateVO.getMetadataPageConfigVO();
        List<String> lstSuccessModelId =  objGenResult.containsKey("success") ? (List<String>) objGenResult.get("success") : new ArrayList<String>();
        List<String> lstErrorTemplateName = objGenResult.containsKey("error") ? (List<String>) objGenResult.get("error") : new ArrayList<String>();
        int iSuccessCount = lstSuccessModelId.size(), iErrorCount = lstErrorTemplateName.size(), iTemplateNum = objMetadataPageConfig != null ? objMetadataPageConfig.getPageTempList().size() : (iSuccessCount + iErrorCount);
        if (iTemplateNum == iSuccessCount) {
            objLogInfo.put("result", "1");
            objLogInfo.put("message", "生成元数据成功");
            objLogInfo.put("pageModelIds", JSONObject.toJSONString(lstSuccessModelId));
            objLogInfo.put("templateNum", String.valueOf(iTemplateNum));
        } else if (iSuccessCount == 0) {
            objLogInfo.put("result", "-1");
            objLogInfo.put("message", "后台报错");
            objLogInfo.put("pageModelIds", JSONObject.toJSONString(lstSuccessModelId));
            objLogInfo.put("failTempateName", JSONObject.toJSONString(lstErrorTemplateName));
            objLogInfo.put("templateNum", String.valueOf(iTemplateNum));
        } else {
            objLogInfo.put("result", "0");
            objLogInfo.put("message",
                "成功生成元数据" + iSuccessCount + "条，生成元数据失败" + iErrorCount + "条");
            objLogInfo.put("pageModelIds", JSONObject.toJSONString(lstSuccessModelId));
            objLogInfo.put("failTempateName", JSONObject.toJSONString(lstErrorTemplateName));
            objLogInfo.put("templateNum", String.valueOf(iTemplateNum));
        }
        return objLogInfo;
    }
    
    /**
     * 检查生成元数据模块名称是否已存在。
     * 检查所有子系统所有应用下的元数据模块名称
     *
     * @param modelName 文件名称
     * @return 是否存在（false： 不存在、true：存在）
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public boolean isExistNewModelName(String modelName) throws OperateException {
        boolean bResult = false;
        List<MetadataGenerateVO> lstMetadataGenerateVO = CacheOperator.queryList("/metadataGenerate",
            MetadataGenerateVO.class);
        for (MetadataGenerateVO objMetadataGenerateVO : lstMetadataGenerateVO) {
            String strModelName = objMetadataGenerateVO.getModelName();
            if (strModelName.equals(modelName)) {
                bResult = true;
                break;
            }
        }
        return bResult;
    }
    
    /**
     * 根据元数据信息生成JSON页面
     *
     * @param objMetaData 页面元数据
     * @param cascadeMethodList 需要新增级联方法列表
     * @param entityId 	新建级联方法的实体id
     * @return 操作结果信息
     * @throws OperateException 操作异常
     * @throws ValidateException 验证异常
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
    @RemoteMethod
    public Map<String, String> generatePageJson(MetadataGenerateVO objMetaData, List<MethodVO> cascadeMethodList, String entityId) throws ValidateException,
        OperateException {
        return this.generateMetadataById(objMetaData, cascadeMethodList, entityId);
    }
    
    /**
     * 根据ID集合生成相关页面JSON文件
     *
     * @param lstIds 元数据对象Id集合
     * @return 操作结果
     * @throws OperateException 操作异常
     * @throws ValidateException 验证异常
     */
    @RemoteMethod
    public Map<String, String> generatePageJsonByIds(List<String> lstIds) throws ValidateException, OperateException {
        // 循环读取元数据ID
        String iRs = String.valueOf("0");
        Map<String, String> objLogInfo = new HashMap<String, String>();
        for (Iterator<String> iterator = lstIds.iterator(); iterator.hasNext();) {
            String strId = iterator.next();
            MetadataGenerateVO objMetadataGenerateVO = this.readModel(strId);
            // 元数据不为空时进行生成Json文件操作
            if (objMetadataGenerateVO != null) {
                Map<String, String> mapResult = this.generatePageJson(objMetadataGenerateVO, null, null);
                iRs = mapResult.get("result");
                objLogInfo.put(objMetadataGenerateVO.getModelName() + "pageModelIds", mapResult.get("pageModelIds"));
                objLogInfo.put(objMetadataGenerateVO.getModelName() + "templateNum", mapResult.get("templateNum"));
            }
        }
        
        if (StringUtil.equals(iRs, "1")) {
            objLogInfo.put("result", "1");
            objLogInfo.put("message", "生成元数据成功");
        } else {
            objLogInfo.put("result", "-1");
            objLogInfo.put("message", "后台报错");
        }
        return objLogInfo;
    }
    
    /**
     * 通过模糊查询，获取对应的MetadataGenerateVO集合
     *
     * @param expression 表达式
     * @return MetadataGenerateVO集合
     * @throws OperateException 对象操作异常
     */
    @SuppressWarnings("unchecked")
    public List<MetadataGenerateVO> queryListByExpression(String expression) throws OperateException {
        return CacheOperator.queryList(expression);
    }
    
    /**
     * 再次生成界面元数据时，检查是否有存在相应界面元数据
     * 
     * @param metadataGenerateVO 生成元数据对象
     * @return 是否已存在
     */
    @RemoteMethod
    public boolean isGeneratedCode(MetadataGenerateVO metadataGenerateVO) {
        boolean bResult = false;
        MetadataPageConfigVO objMetadataPageConfigVO = null;
        if (StringUtils.isNotBlank(metadataGenerateVO.getMetadataPageConfigModelId())) {
            objMetadataPageConfigVO = (MetadataPageConfigVO) CacheOperator.readById(metadataGenerateVO
                .getMetadataPageConfigModelId());
        } else if (StringUtils.isNotBlank(metadataGenerateVO.getModelId())) {
            metadataGenerateVO = (MetadataGenerateVO) CacheOperator.readById(metadataGenerateVO.getModelId());
            objMetadataPageConfigVO = metadataGenerateVO.getMetadataPageConfigVO();
        }
        if (objMetadataPageConfigVO != null) {
            List<String> lstPageModelId = new ArrayList<String>();
            List<CapMap> lstPageTemp = objMetadataPageConfigVO.getPageTempList();
            String strModelName = metadataGenerateVO.getModelName();
            strModelName = strModelName.substring(0, 1).toUpperCase() + strModelName.substring(1);
            if (objMetadataPageConfigVO.isDefaultTemplate()) {
                for (CapMap objPageTemp : lstPageTemp) {
                    lstPageModelId.add(metadataGenerateVO.getModelPackage() + ".page." + strModelName
                        + objPageTemp.get("id"));
                }
            } else {
                for (CapMap objPageTemp : lstPageTemp) {
                    String strPageTmpModelId = (String) objPageTemp.get("modelId");
                    String strPageTmpModelName = strPageTmpModelId.substring(strPageTmpModelId.lastIndexOf(".") + 1,
                        strPageTmpModelId.length());
                    lstPageModelId.add(metadataGenerateVO.getModelPackage() + ".page." + strModelName
                        + strPageTmpModelName);
                }
            }
            for (String strPageModelId : lstPageModelId) {
                bResult = pageFacade.isExistPageMetaFile(strPageModelId);
                if (bResult) {
                    break;
                }
            }
        }
        return bResult;
    }
}
