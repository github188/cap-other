/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.actionlibrary.facade;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.page.actionlibrary.model.ResourceVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.top.component.common.systeminit.WebGlobalInfo;
import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;
import comtop.org.directwebremoting.io.FileTransfer;

/**
 * 引入资源文件facade
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年10月31日 lizhongwen
 */
@DwrProxy
@PetiteBean
public class ResourceFacade {
    
    /** 日志 */
    private final static Logger LOG = LoggerFactory.getLogger(ResourceFacade.class);
    
    /**
     * 资源文件是否存在
     *
     * @param resource 资源
     * @return 是否已存在
     */
    @RemoteMethod
    public boolean existed(ResourceVO resource) {
        boolean bExisted = false;
        String filePath = path(resource);
        if (StringUtils.isNotBlank(filePath)) {
            File objFile = new File(filePath);
            bExisted = objFile.exists();
        }
        return bExisted;
    }
    
    /**
     * 保存资源
     *
     * @param resource 资源
     * @return 资源相对路径
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public String save(ResourceVO resource) throws OperateException {
        String strFilePath = null;
        String filePath = path(resource);
        if (StringUtils.isNotBlank(filePath)) {
            if (!isCapResource(resource.getPackagePath())) {
                File objFile = new File(filePath);
                FileOutputStream objFos = null;
                try {
                    if (!objFile.getParentFile().exists()) {
                        objFile.getParentFile().mkdirs();
                    }
                    objFos = new FileOutputStream(objFile);
                    IOUtils.write(resource.getContent(), objFos, "utf-8");
                } catch (Exception e) {
                    throw new OperateException("资源文件保存失败！", e);
                } finally {
                    IOUtils.closeQuietly(objFos);
                }
            }
            int iLen = WebGlobalInfo.getWebPath().length();
            strFilePath = filePath.substring(iLen).replace('\\', '/');
            
        }
        return strFilePath;
    }
    
    /**
     * 删除资源
     *
     * @param resource 资源
     * @return 是否删除成功
     */
    @RemoteMethod
    public boolean delete(ResourceVO resource) {
        boolean bRet = false;
        String filePath = path(resource);
        if (StringUtils.isNotBlank(filePath) && !isCapResource(resource.getPackagePath())) {
            File objFile = new File(filePath);
            bRet = objFile.delete();
        }
        return bRet;
    }
    
    /**
     * 是否为CAP资源
     *
     * @param pkg 包路径
     * @return 是否为CAP资源
     */
    public boolean isCapResource(String pkg) {
        return StringUtils.isNotBlank(pkg)
            && (pkg.startsWith("cap.rt.") || pkg.startsWith("cap.bm.") || pkg.startsWith("cap.ptc."));
    }
    
    /**
     * 上传资源文件
     *
     * @param fileTransfer 文件传输对象
     * @param pkg 包路径
     * @return 文件相对路径
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public String upload(FileTransfer fileTransfer, String pkg) throws OperateException {
        if (StringUtils.isBlank(pkg)) {
            throw new OperateException("资源文件包路径不能为空！");
        }
        String fileName = fileTransfer.getFilename();
        if (StringUtils.isBlank(fileName)) {
            throw new OperateException("资源文件名称不能为空！");
        }
        if (!(fileName.endsWith(".css") || fileName.endsWith(".js"))) {
            throw new OperateException("不能上传非css或者js文件。！");
        }
        String strPath = WebGlobalInfo.getWebPath() + File.separator + pkg.replace('.', '/') + File.separator
            + fileName;
        InputStream objInput = null;
        FileOutputStream objOut = null;
        try {
            File objFile = new File(strPath);
            if (!objFile.getParentFile().exists()) {
                objFile.getParentFile().mkdirs();
            }
            objInput = fileTransfer.getInputStream();
            objOut = new FileOutputStream(objFile);
            IOUtils.copy(objInput, objOut);
        } catch (IOException e) {
            throw new OperateException("资源文件上传失败！", e);
        } finally {
            IOUtils.closeQuietly(objInput);
            IOUtils.closeQuietly(objOut);
        }
        int iLen = WebGlobalInfo.getWebPath().length();
        String strFilePath = strPath.substring(iLen).replace('\\', '/');
        return strFilePath;
    }
    
    /**
     * 读取资源文件
     *
     * @param path 路径
     * @return 资源文件对象
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public ResourceVO readResouce(String path) throws OperateException {
        if (StringUtils.isBlank(path)) {
            return null;
        }
        ResourceVO objRes = new ResourceVO();
        if (path.endsWith(".css")) {
            objRes.setFileType("css");
        } else if (path.endsWith(".js")) {
            objRes.setFileType("js");
        }
        int iLastPath = path.lastIndexOf("/");
        int iLastSubfix = path.lastIndexOf(".");
        String fileName = path.substring(iLastPath + 1, iLastSubfix);
        objRes.setFileName(fileName);
        int iStart = path.startsWith("/") ? 1 : 0;
        String strPackagePath = path.substring(iStart, iLastPath).replace('/', '.');
        objRes.setPackagePath(strPackagePath);
        String strFilePath = WebGlobalInfo.getWebPath() + File.separator + path;
        File file = new File(strFilePath);
        if (file.exists()) {
            InputStream objInput = null;
            try {
                // objReader = new FileReader(file);
                // String strContent = IOUtils.toString(objReader);
                objInput = new java.io.FileInputStream(file);
                String strContent = IOUtils.toString(objInput, "utf-8");
                objRes.setContent(strContent);
            } catch (Exception e) {
                throw new OperateException("资源文件读取失败！", e);
            } finally {
                IOUtils.closeQuietly(objInput);
            }
        }
        return objRes;
    }
    
    /**
     * 读取资源文件
     *
     * @param pathes 路径集合
     * @return 资源文件对象
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public List<ResourceVO> readResouces(List<String> pathes) throws OperateException {
        StringBuffer objBuffer = new StringBuffer();
        List<ResourceVO> lstRes = new ArrayList<ResourceVO>();
        for (String path : pathes) {
            try {
                ResourceVO res = this.readResouce(path);
                lstRes.add(res);
            } catch (Exception e) {
                objBuffer.append(path);
                objBuffer.append("，");
            }
        }
        if (objBuffer.length() > 0) {
            LOG.error("下列文件读取失败：{0}", objBuffer.deleteCharAt(objBuffer.length() - 1).toString());
        }
        return lstRes;
    }
    
    /**
     * 批量删除资源文件
     *
     * @param resources 资源文件集合
     * @return 未能被删除资源文件对象
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public List<ResourceVO> deleteResouces(List<ResourceVO> resources) throws OperateException {
        if (resources == null) {
            return null;
        }
        List<ResourceVO> lstRes = new ArrayList<ResourceVO>();
        for (ResourceVO objRes : resources) {
            if (!this.delete(objRes)) {
                lstRes.add(objRes);
            }
        }
        return lstRes;
    }
    
    /**
     * 批量删除资源文件
     *
     * @param pathes 资源文件路径集合
     * @return 未能被删除的文件
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public List<String> deleteResoucesByPath(String[] pathes) throws OperateException {
        if (pathes == null) {
            return null;
        }
        List<String> lstRes = new ArrayList<String>();
        String strPrefix = WebGlobalInfo.getWebPath() + File.separator;
        File objRes;
        for (String strPath : pathes) {
            objRes = new File(strPrefix + (strPath.startsWith("/") ? strPath.substring(1) : strPath));
            if (!objRes.exists() || !objRes.delete()) {
                lstRes.add(strPath);
            }
        }
        return lstRes;
    }
    
    /**
     * 获取资源文件路径
     *
     * @param resource 资源文件
     * @return 路径
     */
    private String path(ResourceVO resource) {
        String strPath = "";
        if (StringUtils.isNotBlank(resource.getPackagePath())) {
            strPath += resource.getPackagePath().replace('.', '/');
        }
        if (StringUtils.isNotBlank(resource.getFileName())) {
            strPath += File.separator + resource.getFileName();
        }
        if (StringUtils.isNotBlank(resource.getFileType()) && StringUtils.isNotBlank(strPath)) {
            strPath += "." + resource.getFileType();
        }
        if (StringUtils.isNotBlank(strPath)) {
            strPath = WebGlobalInfo.getWebPath() + File.separator + strPath;
        }
        return strPath;
    }
}
