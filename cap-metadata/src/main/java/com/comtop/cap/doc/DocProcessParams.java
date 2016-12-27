/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import com.comtop.cap.doc.info.model.DocumentVO;
import com.comtop.cap.doc.tmpl.model.CapDocTemplateVO;

/**
 * 文档处理参数
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2016年2月18日 lizhiyong
 */
public class DocProcessParams {
    
    /** 文档信息对象 */
    private DocumentVO document;
    
    /** cookie的Json串 */
    private String cookiesJsonStr;
    
    /** 请求的根路径 */
    private String httpRootUrl;
    
    /** 当前用户 */
    private String curUserId;
    
    /** 当前用户 */
    private String curUserAccount;
    
    /** 当前用户 */
    private String curUserName;
    
    /** 待处理的文档 */
    private File docFile;
    
    /** 文件的http访问路径 */
    private String fileHttpUrl;
    
    /** 参数集 */
    private final Map<String, Object> paramMap = new HashMap<String, Object>();
    
    /** 上传文件的mimeType */
    private String mimeType;
    
    /** 文件的大小 */
    private long size;
    
    /** web根路径 绝对路径 */
    private String webPath;
    
    /** 日志文件地址 */
    private String logPath;
    
    /** 文档模板VO */
    private CapDocTemplateVO docTemplateVO;
    
    /**
     * @return 获取 logPath属性值
     */
    public String getLogPath() {
        return logPath;
    }
    
    /**
     * @param logPath 设置 logPath 属性值为参数值 logPath
     */
    public void setLogPath(String logPath) {
        this.logPath = logPath;
    }
    
    /**
     * @return 获取 docTemplateVO属性值
     */
    public CapDocTemplateVO getDocTemplateVO() {
        return docTemplateVO;
    }
    
    /**
     * @param docTemplateVO 设置 docTemplateVO 属性值为参数值 docTemplateVO
     */
    public void setDocTemplateVO(CapDocTemplateVO docTemplateVO) {
        this.docTemplateVO = docTemplateVO;
    }
    
    /**
     * @return 获取 webPath属性值
     */
    public String getWebPath() {
        return webPath;
    }
    
    /**
     * @param webPath 设置 webPath 属性值为参数值 webPath
     */
    public void setWebPath(String webPath) {
        this.webPath = webPath;
    }
    
    /**
     * @return 获取 fileHttpUrl属性值
     */
    public String getFileHttpUrl() {
        return fileHttpUrl;
    }
    
    /**
     * @param fileHttpUrl 设置 fileHttpUrl 属性值为参数值 fileHttpUrl
     */
    public void setFileHttpUrl(String fileHttpUrl) {
        this.fileHttpUrl = fileHttpUrl;
    }
    
    /**
     * @return 获取 docFile属性值
     */
    public File getDocFile() {
        return docFile;
    }
    
    /**
     * @param docFile 设置 docFile 属性值为参数值 docFile
     */
    public void setDocFile(File docFile) {
        this.docFile = docFile;
    }
    
    /**
     * @return 获取 curUserAccount属性值
     */
    public String getCurUserAccount() {
        return curUserAccount;
    }
    
    /**
     * @param curUserAccount 设置 curUserAccount 属性值为参数值 curUserAccount
     */
    public void setCurUserAccount(String curUserAccount) {
        this.curUserAccount = curUserAccount;
    }
    
    /**
     * @return 获取 mimeType属性值
     */
    public String getMimeType() {
        return mimeType;
    }
    
    /**
     * @param mimeType 设置 mimeType 属性值为参数值 mimeType
     */
    public void setMimeType(String mimeType) {
        this.mimeType = mimeType;
    }
    
    /**
     * @return 获取 size属性值
     */
    public long getSize() {
        return size;
    }
    
    /**
     * @param size 设置 size 属性值为参数值 size
     */
    public void setSize(long size) {
        this.size = size;
    }
    
    /**
     * @return 获取 cookiesJsonStr属性值
     */
    public String getCookiesJsonStr() {
        return cookiesJsonStr;
    }
    
    /**
     * @param cookiesJsonStr 设置 cookiesJsonStr 属性值为参数值 cookiesJsonStr
     */
    public void setCookiesJsonStr(String cookiesJsonStr) {
        this.cookiesJsonStr = cookiesJsonStr;
    }
    
    /**
     * @return 获取 httpRootUrl属性值
     */
    public String getHttpRootUrl() {
        return httpRootUrl;
    }
    
    /**
     * @param httpRootUrl 设置 httpRootUrl 属性值为参数值 httpRootUrl
     */
    public void setHttpRootUrl(String httpRootUrl) {
        this.httpRootUrl = httpRootUrl;
    }
    
    /**
     * @return 获取 curUserId属性值
     */
    public String getCurUserId() {
        return curUserId;
    }
    
    /**
     * @param curUserId 设置 curUserId 属性值为参数值 curUserId
     */
    public void setCurUserId(String curUserId) {
        this.curUserId = curUserId;
    }
    
    /**
     * @return 获取 curUserName属性值
     */
    public String getCurUserName() {
        return curUserName;
    }
    
    /**
     * @param curUserName 设置 curUserName 属性值为参数值 curUserName
     */
    public void setCurUserName(String curUserName) {
        this.curUserName = curUserName;
    }
    
    /**
     * @return 获取 document属性值
     */
    public DocumentVO getDocument() {
        return document;
    }
    
    /**
     * @param document 设置 document 属性值为参数值 document
     */
    public void setDocument(DocumentVO document) {
        this.document = document;
    }
    
    /**
     * 获得指定的参数值
     *
     * @param name 参数key
     * @return 值
     */
    public Object getParam(String name) {
        return paramMap.get(name);
    }
    
    /**
     * 添加一个参数
     *
     * @param name 参数名称
     * @param value 参数值
     */
    public void addParam(String name, Object value) {
        paramMap.put(name, value);
    }
    
    /**
     * 添加参数集
     *
     * @param params 参数集
     */
    @SuppressWarnings("unchecked")
    public void addParams(@SuppressWarnings("rawtypes") Map params) {
        paramMap.putAll(params);
    }
}
