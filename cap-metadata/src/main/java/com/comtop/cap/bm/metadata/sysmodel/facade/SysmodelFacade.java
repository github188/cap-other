/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.sysmodel.facade;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.common.storage.exception.ValidateException;
import com.comtop.cap.bm.metadata.sysmodel.model.CapPackageVO;
import com.comtop.cap.bm.metadata.sysmodel.model.FunctionItemVO;
import com.comtop.cap.bm.metadata.sysmodel.utils.CapModuleConstants;
import com.comtop.cap.bm.req.func.facade.ReqTreeFacade;
import com.comtop.cap.bm.req.func.model.ReqTreeVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cip.jodd.util.StringUtil;
import com.comtop.cip.json.JSON;
import com.comtop.cip.json.JSONObject;
import com.comtop.cap.bm.metadata.pkg.facade.IPackageFacade;
import com.comtop.cap.bm.metadata.pkg.facade.PackageFacadeImpl;
import com.comtop.cap.bm.metadata.pkg.model.PackageVO;
import com.comtop.cap.runtime.core.AppBeanUtil;
import com.comtop.top.core.jodd.AppContext;
import com.comtop.top.sys.module.facade.IModuleFacade;
import com.comtop.top.sys.module.model.ModuleDTO;

import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;

/**
 * 系统模块facade类
 *
 * @author 罗珍明
 * @since jdk1.6
 * @version 2015年12月30日
 */
@DwrProxy
@PetiteBean
public class SysmodelFacade {
    
    /** 包Facade */
    private final IPackageFacade packageFacade = AppContext.getBean(PackageFacadeImpl.class);
    
    /** 系统模块 Facade */
    @PetiteInject
    protected IModuleFacade moduleFacade;
    
    /** 模块类型为2 */
    private static final int MODEL_TYPE_PACKAGE = 2;
    
    /** 需求管理默认包路径 */
    private static final String REQUEST_MANAGE_PACKAGE = "requestmanage";
    
    /** 模块需求默认类型 */
    private static final String MODULE_REQUEST_PACKAGE = "modulerequest";
    
    /** 模块需求默认类型 */
    private static final String SEPARATOR = ".";
    
    /** capPackageVO 默认类型 */
    private static final String CAPPACKAGE_PACKAGE = "package";
    
    /** Facade */
    protected final ReqTreeFacade reqTreeFacade = AppBeanUtil.getBean(ReqTreeFacade.class);
    
    /**
     * @param packageId 应用的数据库Id
     * @return 应用VO
     */
    public CapPackageVO queryPackageById(String packageId) {
        PackageVO objPackageVO = packageFacade.queryPackageById(packageId);
        if (objPackageVO != null) {
            JSONObject object = (JSONObject) JSON.toJSON(objPackageVO);
            return JSON.parseObject(object.toJSONString(), CapPackageVO.class);
        }
        return new CapPackageVO();
    }
    
    /**
     * 通过包路径查询包对象
     * 
     * @param packagePath
     *            包路径
     * @return 包对象
     */
    public PackageVO queryPackageVOByPath(String packagePath) {
        return packageFacade.queryPackageByFullPath(packagePath);
    }
    
    /**
     * 返回模块下及其所有子模块的包路径（忽略没有包路径的模块）
     * 
     * @param modelId 模块Id
     * @return 包路径集合
     */
    public List<String> queryPkgPathAndAllSubPkgPathBy(String modelId) {
        
        ModuleDTO objModuleDTO = moduleFacade.readModuleVO(modelId);
        
        if (objModuleDTO == null) {
            return new ArrayList<String>(0);
        }
        List<String> lstString = new ArrayList<String>();
        if (objModuleDTO.getModuleType() == MODEL_TYPE_PACKAGE && StringUtil.isNotBlank(objModuleDTO.getFullPath())) {
            lstString.add(objModuleDTO.getFullPath());
        }
        
        List<ModuleDTO> lstModel = moduleFacade.getSubChildModuleByModuleId(modelId);
        if (lstModel == null) {
            return lstString;
        }
        
        for (ModuleDTO moduleDTO : lstModel) {
            if (moduleDTO.getModuleType() == MODEL_TYPE_PACKAGE && StringUtil.isNotBlank(moduleDTO.getFullPath())) {
                lstString.add(moduleDTO.getFullPath());
            }
        }
        return lstString;
    }
    
    /**
     * 根据模块包路径，查询模块的全路径名称
     * 
     * @param packagePath 包路径
     * @return 模块集合
     */
    public String queryParentModuleName(String packagePath) {
    	PackageVO objPackageVO = packageFacade.queryPackageByFullPath(packagePath);
    	if(objPackageVO == null){
    		return "";
    	}
        ModuleDTO objCurrentModuleDTO = moduleFacade.readModuleVO(objPackageVO.getId());
        if (objCurrentModuleDTO == null) {
            return "";
        }
        List<ModuleDTO> lstParentModules = moduleFacade.getParentModuleTree(objCurrentModuleDTO.getModuleCode());
        if(lstParentModules == null){
        	return objCurrentModuleDTO.getModuleName();
        }
        
        Collections.sort(lstParentModules, new Comparator<ModuleDTO> (){
        	@Override
        	public int compare(ModuleDTO o1, ModuleDTO o2) {
        		return o1.getSortId() - o2.getSortId();
        	}
        });
        
        StringBuffer sbBuffer = new StringBuffer();
        for (ModuleDTO objModuleDTO : lstParentModules) {
        	sbBuffer.append(objModuleDTO.getModuleName());
        	sbBuffer.append("/");
        }
        return sbBuffer.toString().substring(0, sbBuffer.length()-1);
    }
    
    /**
     * 根据模块id查询子模块(包括下级的所有子节点)
     * 
     * @param moduleId 模块Id
     * @return 模块集合
     */
    public List<CapPackageVO> querySubChildModuleByModuleId(String moduleId) {
        ModuleDTO objRootModuleDTO = moduleFacade.readModuleVO(moduleId);
        if (objRootModuleDTO == null) {
            return new ArrayList<CapPackageVO>(0);
        }
        List<ModuleDTO> lstModule = new ArrayList<ModuleDTO>();
        lstModule.add(objRootModuleDTO);
        List<ModuleDTO> lstSubModules = moduleFacade.getSubChildModuleByModuleId(moduleId);
        if (lstSubModules != null) {
            lstModule.addAll(lstSubModules);
        }
        List<CapPackageVO> lstCapPackageVO = new ArrayList<CapPackageVO>();
        for (ModuleDTO objModuleDTO : lstModule) {
            if (objModuleDTO != null && StringUtil.isNotEmpty(objModuleDTO.getModuleId())) {
                lstCapPackageVO.add(convertModuleDTO2CapPackageVO(objModuleDTO));
            }
        }
        return lstCapPackageVO;
    }
    
    /**
     * 转换ModuleDTO为CapPackageVO
     * 
     * @param objModuleDTO 待转ModuleDTO
     * @return 转换后的CapPackageVO
     */
    private CapPackageVO convertModuleDTO2CapPackageVO(ModuleDTO objModuleDTO) {
        // 转换ModuleDTO
        CapPackageVO objCapPackageVO = readModuleVOByCode(objModuleDTO.getModuleCode());
        if (objCapPackageVO == null) { // 如果未持久化为CAP模块包信息，则返回模块信息
            objCapPackageVO = new CapPackageVO();
            objCapPackageVO.setLstFunctionItem(new ArrayList<FunctionItemVO>(0));
        }
        objCapPackageVO.setModuleId(objModuleDTO.getModuleId());
        objCapPackageVO.setModuleName(objModuleDTO.getModuleName());
        objCapPackageVO.setModuleCode(objModuleDTO.getModuleCode());
        objCapPackageVO.setModuleType(objModuleDTO.getModuleType());
        objCapPackageVO.setModuleDescription(objModuleDTO.getDescription());
        objCapPackageVO.setParentModuleId(objModuleDTO.getParentModuleId());
        objCapPackageVO.setSortId(objModuleDTO.getSortId());
        return objCapPackageVO;
    }
    
    /**
     * 保存CAP模块包对象
     * 
     * @param vo 对象
     * @return CapPackageVO 保存后的
     * @throws ValidateException 异常
     */
    @RemoteMethod
    public CapPackageVO savePackageVO(CapPackageVO vo) throws ValidateException {
        // 设置用于持久化的model信息
        vo.setModelPackage(REQUEST_MANAGE_PACKAGE);
        vo.setModelType(MODULE_REQUEST_PACKAGE);
        vo.setModelName(vo.getModuleCode());
        vo.setModelId(vo.getModelPackage() + SEPARATOR + vo.getModelType() + SEPARATOR + vo.getModelName());
        boolean bResult = vo.saveModel();
        return bResult ? vo : null;
    }
    
    /**
     * 删除CAP模块包对象
     * 
     * @param vo 对象
     * @return CapPackageVO 保存后的
     * @throws OperateException 异常
     */
    @RemoteMethod
    public boolean deletePackageVO(CapPackageVO vo) throws OperateException {
        vo.setModelPackage(REQUEST_MANAGE_PACKAGE);
        vo.setModelType(MODULE_REQUEST_PACKAGE);
        vo.setModelName(vo.getModuleCode());
        vo.setModelId(vo.getModelPackage() + SEPARATOR + vo.getModelType() + SEPARATOR + vo.getModelName());
        return vo.deleteModel();
    }
    
    /**
     * 根据模块id查询CAP模块包信息（包含功能（子）项信息）
     * 
     * @param moduleId 模块id
     * @return ModuleDTO 系统模块DTO
     */
    @RemoteMethod
    public CapPackageVO readModuleVOById(String moduleId) {
        if (StringUtil.isEmpty(moduleId))
            return null;
        ModuleDTO objModuleDTO = moduleFacade.readModuleVO(moduleId);
        if (objModuleDTO == null) {
            return null;
        }
        return convertModuleDTO2CapPackageVO(objModuleDTO);
    }
    
    /**
     * 根据模块id查询CAP模块包信息（包含功能（子）项信息）
     * 
     * @param moduleCode 模块id
     * @return CapPackageVO CAP模块包信息
     */
    @RemoteMethod
    public CapPackageVO readModuleVOByCode(String moduleCode) {
        if (StringUtil.isEmpty(moduleCode))
            return null;
        String strTempModuleCode = REQUEST_MANAGE_PACKAGE + SEPARATOR + MODULE_REQUEST_PACKAGE + SEPARATOR + moduleCode;
        CapPackageVO objCapPackageVO = (CapPackageVO) CacheOperator.readById(strTempModuleCode);
        return objCapPackageVO;
    }
    
    /**
     * 查询模块根节点（只支持父节点为-1的单个根节点）
     * 
     * @return CapPackageVO 系统模块根节点
     */
    @RemoteMethod
    public CapPackageVO readModuleRoot() {
        List<ModuleDTO> lstModuleDTO = moduleFacade.getChildModuleList("");
        return convertModuleDTO2CapPackageVO(lstModuleDTO.get(0));
    }
    
    /**
     * 判断包全路径是否已存在
     *
     * @param packageVO 包全路径
     * @return 是否存在
     */
    public boolean isExistPackageFullPath(PackageVO packageVO) {
        return packageFacade.isExistPackageFullPath(packageVO);
    }
    
    /**
     * 根据模块id获取所对应的功能项及功能子项集合
     * 
     * @param moduleId 模块id
     * @return 功能项及功能子项集合
     */
    public List<ReqTreeVO> queryReqTreeVOByModuleId(String moduleId) {
        CapPackageVO objCapPackageVO = readModuleVOByCode(moduleId);
        List<ReqTreeVO> lstReqTreeVO = new ArrayList<ReqTreeVO>();
        if (objCapPackageVO == null) {
            return lstReqTreeVO;
        }
        List<FunctionItemVO> lstFunctionItem = objCapPackageVO.getLstFunctionItem();
        if (lstFunctionItem != null) {
            Map<String, List<String>> funcItemMap = new HashMap<String, List<String>>() {
                
                /** 序列化id */
                private static final long serialVersionUID = 1L;
                
                {
                    put(CapModuleConstants.FUNCTION_ITEM_TYPE, new ArrayList<String>());
                    put(CapModuleConstants.SUB_FUNCTION_ITEM_TYPE, new ArrayList<String>());
                }
            };
            for (FunctionItemVO objFunctionItemVO : lstFunctionItem) {
                List<String> lstIds = funcItemMap.get(objFunctionItemVO.getItemType());
                if (lstIds != null) {
                    lstIds.add(objFunctionItemVO.getItemId());
                }
            }
            List<ReqTreeVO> lstTempReqTreeVO = reqTreeFacade.queryViewReqTreeListByTypeAndIds(
                CapModuleConstants.FUNCTION_ITEM_TYPE, funcItemMap.get(CapModuleConstants.FUNCTION_ITEM_TYPE));
            if (lstTempReqTreeVO != null)
                lstReqTreeVO.addAll(lstTempReqTreeVO);
            lstTempReqTreeVO = reqTreeFacade.queryViewReqTreeListByTypeAndIds(
                CapModuleConstants.SUB_FUNCTION_ITEM_TYPE, funcItemMap.get(CapModuleConstants.SUB_FUNCTION_ITEM_TYPE));
            if (lstTempReqTreeVO != null)
                lstReqTreeVO.addAll(lstTempReqTreeVO);
        }
        return lstReqTreeVO;
    }
    
    /**
     * 保存包含java源代码路径和page路径的CAP模块包对象
     * 
     * @param vo 对象
     * @return CapPackageVO 保存后的
     * @throws ValidateException 异常
     */
    @RemoteMethod
    public CapPackageVO saveCapPackage4CodePath(CapPackageVO vo) throws ValidateException {
        // 设置用于持久化的model信息
        vo.setModelType(CAPPACKAGE_PACKAGE);
        vo.setModelName(vo.getModuleCode());
        vo.setModelId(vo.getModelPackage() + SEPARATOR + vo.getModelType() + SEPARATOR + vo.getModelName());
        boolean bResult = vo.saveModel();
        return bResult ? vo : null;
    }
    
    /**
     * 删除包含java源代码路径和page路径的CAP模块包对象
     * 
     * @param vo 对象
     * @return CapPackageVO 保存后的
     * @throws OperateException 异常
     */
    @RemoteMethod
    public boolean deleteCapPackage4CodePath(CapPackageVO vo) throws OperateException {
        return vo.deleteModel();
    }
    
    /**
     * 根据模块id查询CAP模块包信息
     * 
     * @param modelId 模块id
     * @return CapPackageVO CAP模块包信息
     */
    @RemoteMethod
    public CapPackageVO readCapPackage4CodePathById(String modelId) {
        if (StringUtil.isEmpty(modelId))
            return null;
        CapPackageVO objCapPackageVO = (CapPackageVO) CacheOperator.readById(modelId);
        if (objCapPackageVO == null) { // 如果未持久化为CAP模块包信息，则返回模块信息
            objCapPackageVO = new CapPackageVO();
        }
        return objCapPackageVO;
    }
    
}
