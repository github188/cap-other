/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.serve.facade;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.base.facade.CapBmBaseFacade;
import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.common.storage.exception.ValidateException;
import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cap.bm.metadata.serve.model.ServiceObjectVO;
import com.comtop.cap.bm.metadata.sysmodel.facade.SysmodelFacade;
import com.comtop.cap.bm.metadata.sysmodel.model.CapPackageVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.corm.resource.util.CollectionUtils;
import com.comtop.top.core.jodd.AppContext;
import com.comtop.top.core.util.StringUtil;
import com.comtop.top.sys.module.facade.IModuleFacade;
import com.comtop.top.sys.module.facade.ModuleFacade;
import com.comtop.top.sys.module.model.ModuleDTO;
import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;

/**
 * 服务对象门面
 * 
 * @author 林玉千
 * @since 1.0
 * @version 2015-5-27 林玉千
 */
@DwrProxy
@PetiteBean
public class ServiceObjectFacade extends CapBmBaseFacade {
    
    /** 日志 */
    private final static Logger LOG = LoggerFactory.getLogger(ServiceObjectFacade.class);
    
    /** 包Facade */
    private final SysmodelFacade packageFacade = AppContext.getBean(SysmodelFacade.class);
    
    /** 系统模块 Facade */
    protected IModuleFacade moduleFacade = AppContext.getBean(ModuleFacade.class);
    
    /*** grid list常量 */
    public final static String PAGE_LIST = "list";
    
    /*** 总记录数 */
    public final static String TOTAL_COUNT = "count";
    
    /**
     * 查询服务列表
     * 
     * @param packageId 当前模块包ID
     * 
     * @return 服务列表
     * @throws OperateException 异常
     */
    @RemoteMethod
    public List<ServiceObjectVO> queryServiceObjectList(String packageId) throws OperateException {
        CapPackageVO objPackageVO = packageFacade.queryPackageById(packageId);
        String strPackageName = objPackageVO.getFullPath();
        List<ServiceObjectVO> lstServiceObjectVOs = CacheOperator.queryList(strPackageName + "/serve",
            ServiceObjectVO.class);
        if (lstServiceObjectVOs == null) {
            lstServiceObjectVOs = new ArrayList<ServiceObjectVO>();
        }
        return lstServiceObjectVOs;
    }
    
    /**
     * 查询服务列表
     * 
     * @param packageId 当前模块包ID
     * @param pageNo 当前页码
     * @param pageSize 每页显示数据大小
     * @return 服务列表
     * @throws OperateException 异常
     */
    @RemoteMethod
    public List<ServiceObjectVO> queryServiceObjectList(String packageId, int pageNo, int pageSize)
        throws OperateException {
        CapPackageVO objPackageVO = packageFacade.queryPackageById(packageId);
        String strPackageName = objPackageVO.getFullPath();
        List<ServiceObjectVO> lstServiceObjectVOs = CacheOperator.queryList(strPackageName + "/serve",
            ServiceObjectVO.class, pageNo, pageSize);
        if (lstServiceObjectVOs == null) {
            lstServiceObjectVOs = new ArrayList<ServiceObjectVO>();
        }
        return lstServiceObjectVOs;
    }
    
    /**
     * 
     * 测试建模中查询服务方法--for node
     * 
     * @param packageId 包ID
     * @return 查询结果
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public List<Map<String, Object>> queryServiceMethodForNode(String packageId) throws OperateException {
        List<Map<String, Object>> lstReturn = new ArrayList<Map<String, Object>>();
        List<ServiceObjectVO> lstServiceObject = this.queryServiceObjectList(packageId);
        for (ServiceObjectVO serviceObjectVO : lstServiceObject) {
            Map<String, Object> objMapServiceObject = new HashMap<String, Object>();
            objMapServiceObject.put("title", serviceObjectVO.getChineseName());
            objMapServiceObject.put("key", serviceObjectVO.getModelId());
            objMapServiceObject.put("data", serviceObjectVO);
            lstReturn.add(objMapServiceObject);
        }
        return lstReturn;
    }
    
    /**
     * 保存服务
     * 
     * @param serviceObjectVO 被保存的服务对象
     * @return 实体对象
     * @throws ValidateException 校验失败异常
     */
    @RemoteMethod
    public ServiceObjectVO saveServiceObject(ServiceObjectVO serviceObjectVO) throws ValidateException {
        boolean bResult = serviceObjectVO.saveModel();
        return bResult ? serviceObjectVO : null;
    }
    
    /**
     * 通过服务属性ID查询服务对象
     * 
     * @param modelId 服务模型ID
     * @param packageId 包ID
     * @return 服务对象
     */
    @RemoteMethod
    public ServiceObjectVO loadServiceObject(String modelId, String packageId) {
        if (StringUtil.isBlank(modelId) && StringUtil.isBlank(packageId)) {
            return null;
        }
        ServiceObjectVO objServiceObjectVO = new ServiceObjectVO();
        // 如果modelId为空则构造空EntityVO到新增页面
        if (StringUtil.isNotBlank(modelId)) {
            objServiceObjectVO = (ServiceObjectVO) CacheOperator.readById(modelId);
            if (objServiceObjectVO == null) {
                return null;
            }
        } else {
            CapPackageVO objPackageVO = packageFacade.queryPackageById(packageId);
            objServiceObjectVO.setModelPackage(objPackageVO.getFullPath());
            objServiceObjectVO.setPackageVO(objPackageVO);
        }
        return objServiceObjectVO;
    }
    
    /**
     * 查询该包路径下是否存在相同服务类名称
     * 
     * @param modelPackage 包全路径
     * @param engName 服务类名称
     * @param modelId 服务类模块ID
     * @return 是否存在（false： 不存在、true：存在）
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public boolean isExistSameEnNameServiceObject(String modelPackage, String engName, String modelId)
        throws OperateException {
        boolean bResult = false;
        List<ServiceObjectVO> lstServiceObjectVO = CacheOperator.queryList(modelPackage + "/serve",
            ServiceObjectVO.class);
        for (ServiceObjectVO objServiceObjectVO : lstServiceObjectVO) {
            String strEngName = objServiceObjectVO.getEnglishName();
            String strModelId = objServiceObjectVO.getModelId();
            if (strEngName.equals(engName) && !strModelId.equals(modelId)) {
                bResult = true;
                break;
            }
        }
        return bResult;
    }
    
    /**
     * 查询该包路径下是否存在相同的服务中文名称
     * 
     * @param modelPackage 包全路径
     * @param chName 服务类中文名称
     * @param modelId 服务类模块ID
     * @return 是否存在（false： 不存在、true：存在）
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public boolean isExistSameChNameServiceObject(String modelPackage, String chName, String modelId)
        throws OperateException {
        boolean bResult = false;
        List<ServiceObjectVO> lstServiceObjectVO = CacheOperator.queryList(modelPackage + "/serve",
            ServiceObjectVO.class);
        for (ServiceObjectVO objServiceObjectVO : lstServiceObjectVO) {
            String strChName = objServiceObjectVO.getChineseName();
            String strModelId = objServiceObjectVO.getModelId();
            if (strChName.equals(chName) && !strModelId.equals(modelId)) {
                bResult = true;
                break;
            }
        }
        return bResult;
    }
    
    /**
     * 查询服务下是否存在相同的服务类别名 ，包括全服务下的服务实体别名 和 实体别名
     * 
     * @param aliasName 服务类名称
     * @param modelId 服务类模块ID
     * @return 是否存在（false： 不存在、true：存在）
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public boolean isExistSameAliasNameServiceObject(String aliasName, String modelId) throws OperateException {
        boolean bResult = false;
        // 查询全服务下的服务实体是否存在别名重复 ，排除当前记录
        List<ServiceObjectVO> lstServiceObjectVO = CacheOperator.queryList("/serve", ServiceObjectVO.class);
        for (ServiceObjectVO objServiceObjectVO : lstServiceObjectVO) {
            String strAliasName = objServiceObjectVO.getServiceAlias();
            String strModelId = objServiceObjectVO.getModelId();
            if (StringUtil.isNotBlank(strAliasName)) {
                if (strAliasName.equals(aliasName) && !strModelId.equals(modelId)) {
                    bResult = true;
                    break;
                }
            }
        }
        // 如果 服务实体别名不存在重复，需要查询全服务下的实体别名是否存在重复
        if (!bResult) {
            List<EntityVO> lstEntityVO = CacheOperator.queryList("/entity", EntityVO.class);
            for (EntityVO objEntityVO : lstEntityVO) {
                String strAliasName = objEntityVO.getAliasName();
                if (StringUtil.isNotBlank(strAliasName)) {
                    if (strAliasName.equals(aliasName)) {
                        bResult = true;
                        break;
                    }
                }
            }
        }
        return bResult;
    }
    
    /**
     * 删除模型
     * 
     * @param models ID集合
     * @return 是否成功
     */
    @RemoteMethod
    public boolean delServiceObjectList(String[] models) {
        boolean bResult = true;
        try {
            for (int i = 0; i < models.length; i++) {
                ServiceObjectVO.deleteModel(models[i]);
            }
        } catch (Exception e) {
            bResult = false;
            LOG.error("删除实体文件失败", e);
        }
        return bResult;
    }
    
    /**
     * 根据服务模块Id查询该服务下面在方法列表
     * 
     * @param modelId 服务模块ID
     * @return 服务功能列表
     */
    @RemoteMethod
    public Map<String, Object> queryMethodByModelId(String modelId) {
        Map<String, Object> objQueryMap = new HashMap<String, Object>();
        if (StringUtil.isBlank(modelId)) {
            objQueryMap.put(PAGE_LIST, null);
            objQueryMap.put(TOTAL_COUNT, null);
            return objQueryMap;
        }
        ServiceObjectVO objServiceObjectVO = (ServiceObjectVO) CacheOperator.readById(modelId);
        if (objServiceObjectVO == null) {
            objQueryMap.put(PAGE_LIST, null);
            objQueryMap.put(TOTAL_COUNT, null);
            return objQueryMap;
        }
        objQueryMap.put(PAGE_LIST, objServiceObjectVO.getMethods());
        objQueryMap.put(TOTAL_COUNT, objServiceObjectVO.getMethods().size());
        return objQueryMap;
    }
    
    /**
     * 查询应用下所有的服务对象个数
     * 
     * @return 服务对象总数
     */
    public int queryServiceObjectNum() {
        try {
            return CacheOperator.queryCount("/serve");
        } catch (OperateException e) {
            LOG.error(e.getMessage());
        }
        return 0;
    }
    
    /**
     * 查询模块服务对象数量
     * 
     * @return Map<moduleCode,服务对象数量>
     */
    public Map<String, Integer> queryServiceObjectModuleNumForReport() {
        Map<String, Integer> objResultMap = new HashMap<String, Integer>();
        try {
            List<ServiceObjectVO> lstServiceObjectVO = CacheOperator.queryList("/serve", ServiceObjectVO.class);
            if (CollectionUtils.isEmpty(lstServiceObjectVO)) {
                return new HashMap<String, Integer>(0);
            }
            for (ServiceObjectVO objService : lstServiceObjectVO) {
                ModuleDTO objModuleDTO = moduleFacade.readModuleVO(objService.getPackageId());
                if (objResultMap.containsKey(objModuleDTO.getModuleCode())) {
                    objResultMap.put(objModuleDTO.getModuleCode(), objResultMap.get(objModuleDTO.getModuleCode()) + 1);
                } else {
                    objResultMap.put(objModuleDTO.getModuleCode(), 1);
                }
            }
        } catch (OperateException e) {
            LOG.error(e.getMessage());
        }
        return objResultMap;
    }
}
