/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.design.facade;

import java.io.File;
import java.io.FileFilter;
import java.io.FileInputStream;
import java.util.Map;

import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.common.storage.exception.ValidateException;
import com.comtop.cap.bm.metadata.sysmodel.facade.SysmodelFacade;
import com.comtop.cap.test.design.model.Version;
import com.comtop.cap.test.design.model.Versions;
import com.comtop.cap.test.exception.FileUploadException;
import com.comtop.cap.test.preference.facade.TestServerConfigFacade;
import com.comtop.cap.test.robot.FileUploader;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.top.component.common.systeminit.WebGlobalInfo;

/**
 * 版本管理
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年7月7日 lizhongwen
 */
@PetiteBean
public class VersionFacade {
    
    /** 日志 */
    private final static Logger logger = LoggerFactory.getLogger(VersionFacade.class);
    
    /** 测试脚本根目录 */
    private static final String SCRIPTS_ROOT = "testcase-scripts";
    
    /** 版本类型 */
    private static final String VERSIONS_TYPE = "version";
    
    /** 版本名称 */
    private static final String VERSIONS_NAME = "versions";
    
    /** 变量脚本名称 */
    public static final String VARIABLES_NAME = "variables.py";
    
    /** 脚本后缀 */
    private static final String SCRIPT_SUFFIX = ".txt";
    
    /** Python后缀 */
    private static final String PYTHON_SUFFIX = ".py";
    
    /** 系统 */
    @PetiteInject
    protected SysmodelFacade sysmodelFacade;
    
    /** 测试服务器配置 */
    @PetiteInject
    protected TestServerConfigFacade configFacade;
    
    /**
     * 更新版本
     *
     * @param testcaseId 用例Id
     * @param caseName 用例名称
     * @return 更新后的版本
     * @throws ValidateException 验证异常
     */
    public Version updateVersion(String testcaseId, String caseName) throws ValidateException {
        String modelPackage = this.readModlePackageById(testcaseId);
        Versions versions = this.loadVersions(modelPackage);
        if (versions == null) {
            versions = new Versions();
            versions.setModelPackage(modelPackage);
        }
        Version version = versions.findVersions(testcaseId);
        if (version == null) {
            version = new Version();
            version.setTestcaseId(testcaseId);
            String folder = "/" + sysmodelFacade.queryParentModuleName(modelPackage);
            version.setScriptFolder(folder);
            versions.addVersion(version);
        }
        int old = version.getCaseVersion();
        version.setCaseVersion(old + 1);
        version.setScriptName(caseName);
        versions.addVersion(version);
        versions.saveModel();
        return version;
    }
    
    /**
     * 更新脚本版本
     *
     * @param testcaseId 用例Id
     * @param scriptVersion 脚本版本
     * @return 更新后的版本
     * @throws ValidateException 验证异常
     */
    public Version updateScriptVersion(String testcaseId, int scriptVersion) throws ValidateException {
        String modelPackage = this.readModlePackageById(testcaseId);
        Versions versions = this.loadVersions(modelPackage);
        Version version = versions.findVersions(testcaseId);
        version.setScriptVersion(scriptVersion);
        version.setGenTime(System.currentTimeMillis());
        versions.addVersion(version);
        versions.saveModel();
        return version;
    }
    
    /**
     * 从Id中读取包结构
     *
     * @param testcaseId Id
     * @return 包结构
     */
    private String readModlePackageById(String testcaseId) {
        String[] strPaths = testcaseId.split("\\.");
        int iLong = strPaths.length;
        String strPackage = "";
        for (int i = 0; i < iLong - 2; i++) {
            strPackage += "." + strPaths[i];
        }
        return strPackage.substring(1);
    }
    
    /**
     * 根据用例删除版本
     * 
     * @param testecaseIds 用例Id集合
     */
    public void removeVersionByTestCases(String[] testecaseIds) {
        for (String testcaseId : testecaseIds) {
            this.removeVersionByTestcaseId(testcaseId);
        }
    }
    
    /**
     * 根据用例Id删除版本
     *
     * @param testcaseId 用例Id
     */
    public void removeVersionByTestcaseId(String testcaseId) {
        String modelPackage = this.readModlePackageById(testcaseId);
        Versions versions = this.loadVersions(modelPackage);
        if (versions == null) {
            return;
        }
        Version version = versions.findVersions(testcaseId);
        if (version == null) {
            return;
        }
        File scriptFile = scriptFile(version);
        if (scriptFile.exists()) {
            scriptFile.delete();
        }
        versions.removeVersion(testcaseId);
        
    }
    
    /**
     * 根据版本获取脚本文件
     *
     * @param version 版本
     * @return 脚本文件
     */
    public File scriptFile(Version version) {
        String testCaseRoot = WebGlobalInfo.getWebPath() + File.separator + SCRIPTS_ROOT;
        String scriptFolder = version.getScriptFolder();
        String scriptName = version.getScriptName();
        String scriptFilePath = testCaseRoot + scriptFolder + File.separator + scriptName + SCRIPT_SUFFIX;
        File scriptFile = new File(scriptFilePath);
        return scriptFile;
    }
    
    /**
     * 根据版本获取脚本文件
     *
     * @return 脚本文件
     */
    public File variablesFile() {
        String veriablesPath = WebGlobalInfo.getWebPath() + File.separator + SCRIPTS_ROOT + File.separator
            + VARIABLES_NAME;
        File veriablesFile = new File(veriablesPath);
        return veriablesFile;
    }
    
    /**
     * 根据包结构获取版本
     *
     * @param modelPackage 模型包结构
     * @return 版本管理文件
     */
    public Versions loadVersions(String modelPackage) {
        String id = modelPackage + "." + VERSIONS_TYPE + "." + VERSIONS_NAME;
        Versions versions = (Versions) CacheOperator.readById(id);
        return versions;
    }
    
    /**
     * 根据版本信息上传脚本
     *
     * @param version 版本
     */
    public void uploadScript(Version version) {
        File scriptFile = this.scriptFile(version);
        if (!scriptFile.exists()) {
            return;
        }
        String scriptFolder = version.getScriptFolder();
        File variablesFile = this.variablesFile();
        try {
            FileUploader uploader = getUploader();
            uploader.upload(scriptFolder, scriptFile);
            if (variablesFile.exists()) {
                uploader.upload("/", variablesFile);
            }
        } catch (Exception e) {
            logger.error("文件上传失败！", e);
            throw new FileUploadException("上传测试脚本【" + scriptFolder + File.separator + scriptFile.getName() + "】失败！", e);
        }
    }
    
    /**
     * 根据包路径上传脚本文件
     *
     * @param modelPackage 包路径
     */
    public void uploadScript(String modelPackage) {
        String folder = "/" + sysmodelFacade.queryParentModuleName(modelPackage);
        String testCaseRoot = WebGlobalInfo.getWebPath() + File.separator + SCRIPTS_ROOT;
        String testCaseFolder = testCaseRoot + folder + File.separator;
        // File variablesFile = this.variablesFile();
        try {
            FileUploader uploader = getUploader();
            // if (variablesFile.exists()) {
            // uploader.upload("/", variablesFile);
            // }
            // 上传公共文件
            uploader.batchUpload("/", testCaseRoot, new FileFilter() {
                
                @Override
                public boolean accept(File pathname) {
                    return pathname.getName().endsWith(SCRIPT_SUFFIX) || pathname.getName().endsWith(PYTHON_SUFFIX);
                }
            });
            // 上传用例文件
            uploader.batchUpload(folder, testCaseFolder, new FileFilter() {
                
                @Override
                public boolean accept(File pathname) {
                    return pathname.getName().endsWith(SCRIPT_SUFFIX);
                }
            });
        } catch (Exception e) {
            logger.error("上传目录【" + folder + "】中的测试脚本失败！", e);
            throw new FileUploadException("上传目录【" + folder + "】中的测试脚本失败！", e);
        }
    }
    
    /**
     * 根据包路径上传脚本文件
     *
     * @param version 版本
     * @return 脚本内容
     */
    public String previewScript(Version version) {
        File scriptFile = this.scriptFile(version);
        if (!scriptFile.exists()) {
            logger.error("脚本【{}】生成失败!", version.getScriptFolder() + "/" + version.getScriptName());
            return null;
        }
        FileInputStream fis = null;
        try {
            fis = new FileInputStream(scriptFile);
            return IOUtils.toString(fis, "UTF-8");
        } catch (Exception e) {
            logger.error("读取脚本【{}】失败!", version.getScriptFolder() + "/" + version.getScriptName(), e);
        } finally {
            IOUtils.closeQuietly(fis);
        }
        return null;
    }
    
    /**
     * @return 获取文件上传工具
     */
    public FileUploader getUploader() {
        Map<String, String> config = configFacade.getServerConfig();
        String url = config.get(TestServerConfigFacade.SERVER_URL);
        String username = config.get(TestServerConfigFacade.SERVER_NAME);
        String password = config.get(TestServerConfigFacade.SERVER_PASSWORD);
        return FileUploader.getInstance(url, username, password);
    }
    
    /**
     * 根据用例Id查询版本信息
     *
     * @param testcaseId 用例id
     * @return 版本信息
     */
    public Version loadVersion(String testcaseId) {
        String modelPackage = this.readModlePackageById(testcaseId);
        Versions versions = this.loadVersions(modelPackage);
        if (versions == null) {
            return null;
        }
        return versions.findVersions(testcaseId);
    }
    
}
