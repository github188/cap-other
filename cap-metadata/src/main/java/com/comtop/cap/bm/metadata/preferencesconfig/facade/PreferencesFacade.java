/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.preferencesconfig.facade;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.base.facade.CapBmBaseFacade;
import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.common.storage.exception.ValidateException;
import com.comtop.cap.bm.metadata.preferencesconfig.PreferenceConfigQueryUtil;
import com.comtop.cap.bm.metadata.preferencesconfig.model.PreferenceConfigVO;
import com.comtop.cap.bm.metadata.preferencesconfig.model.PreferencesFileVO;
import com.comtop.cap.runtime.base.cache.CapGlobalEnvironment;
import com.comtop.cap.runtime.base.cache.EHCacheServiceFactory;
import com.comtop.cap.runtime.base.cache.IEHCacheService;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;

/**
 * 环境变量首选项facade类
 * 
 * @author 肖威
 * @version jdk1.6
 * @version 2015-12-21
 */
@DwrProxy
@PetiteBean
public class PreferencesFacade extends CapBmBaseFacade {
    
    /** 日志 */
    private final static Logger LOG = LoggerFactory.getLogger(PreferencesFacade.class);
    
    /**
     * 获取引用文件首选项
     * 
     * @param preferenceConfigCode
     *            首选项配置code
     * 
     * @return 操作结果
     */
    @RemoteMethod
    public PreferenceConfigVO getConfig(String preferenceConfigCode) {
        try {
            PreferencesFileVO objFileVO = getCustomPreferencesFileVO();
            String strPath = getConfigXPath(preferenceConfigCode);
            List<PreferenceConfigVO> lstConfig = objFileVO.queryList(strPath, PreferenceConfigVO.class);
            if (lstConfig == null || lstConfig.isEmpty()) {
                return new PreferenceConfigVO();
            }
            return lstConfig.get(0);
        } catch (OperateException e) {
            LOG.error("查询首选项配置出错，配置code：" + preferenceConfigCode, e);
        }
        return new PreferenceConfigVO();
    }
    
    /**
     * 获取引用文件配置项集合
     * 
     * <pre>
     * 
     * </pre>
     * 
     * @return 配置项集合
     */
    @RemoteMethod
    public List<PreferenceConfigVO> getConfigList() {
        
        try {
            PreferencesFileVO objFileVO = getCustomPreferencesFileVO();
            List<PreferenceConfigVO> lstConfig = objFileVO.queryList("//subConfig", PreferenceConfigVO.class);
            return lstConfig;
        } catch (OperateException e) {
            LOG.error("查询配置项集合出错", e);
        }
        return null;
    }
    
    /**
     * 
     * @param configKey
     *            配置项Code
     * @return xpath
     * 
     */
    public String getConfigXPath(String configKey) {
        return "//subConfig[configKey='" + configKey + "']";
    }
    
    /**
     * @param preferenceConfig
     *            配置项
     * @return 配置项
     */
    @RemoteMethod
    public PreferenceConfigVO saveConfig(PreferenceConfigVO preferenceConfig) {
        PreferencesFileVO objFileVO = getCustomPreferencesFileVO();
        try {
            String strPath = "./subConfig[configKey='" + preferenceConfig.getConfigKey() + "']";
            if (objFileVO.query(strPath) == null) {
                objFileVO.add("./subConfig", preferenceConfig);
            } else {
                objFileVO.update(strPath, preferenceConfig);
            }
            return preferenceConfig;
        } catch (OperateException e) {
            LOG.error("更新首选项配置出错，配置：" + preferenceConfig, e);
        } catch (ValidateException e) {
            LOG.error("更新首选项配置出错，配置：" + preferenceConfig, e);
        }
        return null;
    }
    
    /**
     * 
     * @return 用户配置文件
     */
    public PreferencesFileVO getCustomPreferencesFileVO() {
        String strModelId = PreferencesFileVO.getCustomPreferModelId();
        PreferencesFileVO objFileVO = (PreferencesFileVO) CacheOperator.readById(strModelId);
        if (objFileVO == null) {
            objFileVO = PreferencesFileVO.createCustomPrefer();
            try {
                if (objFileVO.saveModel()) {
                    objFileVO = (PreferencesFileVO) PreferencesFileVO.loadModel(strModelId);
                }
            } catch (ValidateException e) {
                LOG.error("生成用户首选项配置文件出错", e);
            }
        }
        return objFileVO;
    }
    
    /**
     * 根据配置文件获取是否需要执行远端soa服务
     * 
     * @return 根据配置文件获取是否需要执行远端soa服务
     */
    @RemoteMethod
    public boolean isCallSoaRemoteService() {
        return PreferenceConfigQueryUtil.isCallSoaRemoteService();
    }
    
    /**
     * 将配置信息缓存到内存中
     * 
     * @param isCallSoaRemoteService
     *            是否需要远端执行
     * @return isSucess
     */
    @RemoteMethod
    public String saveIsCallSoaRemoteService(String isCallSoaRemoteService) {
        String result = null;
        try {
            isCallSoaRemoteService = isCallSoaRemoteService == null ? "false" : isCallSoaRemoteService;
            
            IEHCacheService iEHCacheService = EHCacheServiceFactory.getInstance();
            
            Object capGlobalEnvironment = iEHCacheService.getCacheElement("CapGlobalEnvironment");
            if (capGlobalEnvironment == null) {
                CapGlobalEnvironment.putVar("isCallSoaRemoteService", isCallSoaRemoteService);
                iEHCacheService.saveCache("CapGlobalEnvironment", CapGlobalEnvironment.getGlobalVarMap());
            } else {
                CapGlobalEnvironment.putVar("isCallSoaRemoteService", isCallSoaRemoteService);
                iEHCacheService.saveCache("CapGlobalEnvironment", CapGlobalEnvironment.getGlobalVarMap());
            }
            return "success";
        } catch (Exception e) {
            LOG.error(e.getMessage(), e);
        }
        return result;
    }
    
}
