/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.req.prototype.design.facade;

import java.io.File;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.common.storage.exception.ValidateException;
import com.comtop.cap.bm.metadata.preferencesconfig.PreferenceConfigQueryUtil;
import com.comtop.cap.bm.req.prototype.design.model.PrototypeVersionVO;
import com.comtop.cap.bm.req.prototype.design.model.PrototypeVersionsVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.top.core.util.StringUtil;
import com.comtop.top.core.util.constant.NumberConstant;
import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;

/**
 * 版本管理
 *
 * @author zhuhuanhui
 * @since jdk1.6
 * @version 2016年11月21日 zhuhuanhui
 */
@DwrProxy
@PetiteBean
public class PrototypeVersionFacade {
    
    /** 版本类型 */
    private static final String VERSIONS_TYPE = "prototypeVersion";
    
    /** 版本名称 */
    private static final String VERSIONS_NAME = "versions";
    
    /**
     * 更新版本
     *
     * @param modelId 用例Id
     * @return 更新后的版本
     * @throws ValidateException 验证异常
     */
    @RemoteMethod
    public PrototypeVersionVO updateVersion(String modelId) throws ValidateException {
        String modelPackage = this.readModlePackageById(modelId);
        PrototypeVersionsVO versions = this.loadVersions(modelPackage);
        if (versions == null) {
            versions = new PrototypeVersionsVO();
            versions.setModelPackage(modelPackage);
        }
        PrototypeVersionVO version = versions.findVersions(modelId);
        if (version == null) {
            version = new PrototypeVersionVO();
            version.setModelId(modelId);
            versions.addVersion(version);
        }
        int old = version.getMetaDataVersion();
        version.setMetaDataVersion(old + 1);
        versions.addVersion(version);
        versions.saveModel();
        return version;
    }
    
    /**
     * 批量更新代码版本
     *
     * @param modelIds 界面原型Id
     * @return 更新后的版本
     * @throws ValidateException 验证异常
     */
    @RemoteMethod
    public Map<String, PrototypeVersionVO> batchUpdateCodeVersion(List<String> modelIds) throws ValidateException {
        Map<String, PrototypeVersionVO> objMap = new HashMap<String, PrototypeVersionVO>();
        for (String strModelId : modelIds) {
            objMap.put(strModelId, this.updateCodeVersion(strModelId, null));
        }
        return objMap;
    }
    
    /**
     * 更新代码版本
     *
     * @param modelId 界面原型Id
     * @param codeVersion 代码版本
     * @return 更新后的版本
     * @throws ValidateException 验证异常
     */
    @RemoteMethod
    public PrototypeVersionVO updateCodeVersion(String modelId, Integer codeVersion) throws ValidateException {
        String modelPackage = this.readModlePackageById(modelId);
        PrototypeVersionsVO versions = this.loadVersions(modelPackage);
        if (versions == null) {
            versions = new PrototypeVersionsVO();
            versions.setModelPackage(modelPackage);
        }
        PrototypeVersionVO version = versions.findVersions(modelId);
        if (version == null) {
            version = new PrototypeVersionVO();
            version.setModelId(modelId);
            versions.addVersion(version);
        }
        if (codeVersion == null) {
            codeVersion = version.getMetaDataVersion();
        }
        version.setCodeVersion(codeVersion);
        version.setGenCodeTime(System.currentTimeMillis());
        versions.addVersion(version);
        versions.saveModel();
        return version;
    }
    
    /**
     * 批量更新界面图片版本
     *
     * @param modelIds 界面原型Id
     * @return 更新后的版本
     * @throws ValidateException 验证异常
     */
    @RemoteMethod
    public Map<String, PrototypeVersionVO> batchUpdateImageVersion(List<String> modelIds) throws ValidateException {
        Map<String, PrototypeVersionVO> objMap = new HashMap<String, PrototypeVersionVO>();
        for (String strModelId : modelIds) {
            objMap.put(strModelId, this.updateImageVersion(strModelId, null));
        }
        return objMap;
    }
    
    /**
     * 更新界面图片版本
     *
     * @param modelId 界面原型Id
     * @param imageVersion 界面图片版本
     * @return 更新后的版本
     * @throws ValidateException 验证异常
     */
    @RemoteMethod
    public PrototypeVersionVO updateImageVersion(String modelId, Integer imageVersion) throws ValidateException {
        String modelPackage = this.readModlePackageById(modelId);
        PrototypeVersionsVO versions = this.loadVersions(modelPackage);
        if (versions == null) {
            versions = new PrototypeVersionsVO();
            versions.setModelPackage(modelPackage);
        }
        PrototypeVersionVO version = versions.findVersions(modelId);
        if (version == null) {
            version = new PrototypeVersionVO();
            version.setModelId(modelId);
            versions.addVersion(version);
        }
        if (imageVersion == null) {
            imageVersion = version.getMetaDataVersion();
        }
        version.setImageVersion(imageVersion);
        version.setGenImageTime(System.currentTimeMillis());
        versions.addVersion(version);
        versions.saveModel();
        return version;
    }
    
    /**
     * 从Id中读取包结构
     *
     * @param modelId Id
     * @return 包结构
     */
    private String readModlePackageById(String modelId) {
        if (StringUtil.isBlank(modelId)) {
            return null;
        }
        Matcher m = Pattern.compile("^(com[.]comtop[.]prototype[.].+)[.]prototype[.].+$").matcher(modelId);
        return m.find() ? m.group(1) : null;
    }
    
    /**
     * 根据界面原型Id删除版本
     * 
     * @param modelIds 界面原型Id集合
     */
    @RemoteMethod
    public void removeVersionByModelIds(String[] modelIds) {
        for (String modelId : modelIds) {
            this.removeVersionByModelId(modelId);
        }
    }
    
    /**
     * 根据界面原型Id删除版本
     *
     * @param modelId 用例Id
     */
    @RemoteMethod
    public void removeVersionByModelId(String modelId) {
        String modelPackage = this.readModlePackageById(modelId);
        PrototypeVersionsVO versions = this.loadVersions(modelPackage);
        if (versions == null) {
            return;
        }
        PrototypeVersionVO version = versions.findVersions(modelId);
        if (version == null) {
            return;
        }
        versions.removeVersion(modelId);
        
    }
    
    /**
     * 根据包结构获取版本
     *
     * @param modelPackage 模型包结构
     * @return 版本管理文件
     */
    @RemoteMethod
    public PrototypeVersionsVO loadVersions(String modelPackage) {
        String id = modelPackage + "." + VERSIONS_TYPE + "." + VERSIONS_NAME;
        PrototypeVersionsVO versions = (PrototypeVersionsVO) CacheOperator.readById(id);
        return versions;
    }
    
    /**
     * 根据界面原型Id查询版本信息
     *
     * @param modelId 用例id
     * @return 版本信息
     */
    @RemoteMethod
    public PrototypeVersionVO loadVersion(String modelId) {
        String modelPackage = this.readModlePackageById(modelId);
        PrototypeVersionsVO versions = this.loadVersions(modelPackage);
        return versions.findVersions(modelId);
    }
    
    /**
     * 根据界面原型Id查询版本信息
     *
     * @param modelId 用例id
     * @param filePath 文件包路径
     * @return 版本信息
     */
    @RemoteMethod
    public PrototypeVersionVO loadVersion(String modelId, String filePath) {
        String modelPackage = this.readModlePackageById(modelId);
        PrototypeVersionsVO versions = this.loadVersions(modelPackage);
        if (versions == null) {
            versions = new PrototypeVersionsVO();
            versions.setModelPackage(modelPackage);
        }
        PrototypeVersionVO version = versions.findVersions(modelId);
        if (version == null) {
            version = new PrototypeVersionVO();
            version.setModelId(modelId);
            version.setMetaDataVersion(NumberConstant.ONE);
            versions.addVersion(version);
        } else {
            boolean bExist = true;
            if (filePath.lastIndexOf(".html") > 0) {
                bExist = this.existLocalFile(filePath);
            } else if (filePath.lastIndexOf(".png") > 0){
                bExist = this.existHttpPath(filePath);
            } 
            if (!bExist) {
                version.setCodeVersion(NumberConstant.ZERO);
                version.setGenCodeTime(NumberConstant.ZERO);
            }
        }
        return version;
    }
    
    /**
     * 文件是否存在
     *
     * @param filePath 文件路径
     * @return 版本信息
     */
    private boolean existLocalFile(String filePath) {
        String projectFilePath = PreferenceConfigQueryUtil.getCodePath();
        if (!projectFilePath.endsWith("/")) {
            projectFilePath += File.separator;
        }
        File objSourceFile = new File(projectFilePath + PreferenceConfigQueryUtil.getPageFilePath() + filePath);
        return objSourceFile.exists();
    }
    
    /**
     * 文件是否存在
     *
     * @param httpPath 文件存放路径
     * @return 版本信息
     */
    public boolean existHttpPath(String httpPath) {
        try {
            HttpURLConnection.setFollowRedirects(false);
            HttpURLConnection con = (HttpURLConnection) new URL(httpPath).openConnection();
            return (con.getResponseCode() == HttpURLConnection.HTTP_OK);
        } catch (Exception e) {
            return false;
        }
    }
}
