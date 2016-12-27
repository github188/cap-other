/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.common;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.tmatesoft.svn.core.SVNException;
import org.tmatesoft.svn.core.SVNURL;
import org.tmatesoft.svn.core.auth.ISVNAuthenticationManager;
import org.tmatesoft.svn.core.internal.io.dav.DAVRepositoryFactory;
import org.tmatesoft.svn.core.internal.io.fs.FSRepositoryFactory;
import org.tmatesoft.svn.core.internal.io.svn.SVNRepositoryFactoryImpl;
import org.tmatesoft.svn.core.internal.wc.DefaultSVNOptions;
import org.tmatesoft.svn.core.io.SVNRepository;
import org.tmatesoft.svn.core.wc.ISVNOptions;
import org.tmatesoft.svn.core.wc.SVNClientManager;
import org.tmatesoft.svn.core.wc.SVNWCUtil;

import com.comtop.cap.runtime.base.exception.CapMetaDataException;
import com.comtop.cip.common.util.MetadataPreferences;
import com.comtop.cip.common.util.MetadataSVNModel;

/**
 * 元数据SVN客户端管理类
 * 
 * 
 * @author 沈康
 * @since 1.0
 * @version 2014-6-10 沈康
 */
public final class MetadataSVNClientManager {
    
    /** 日志 */
    private static final Logger LOGGER = LoggerFactory.getLogger(MetadataSVNClientManager.class);
    
    /** SVM资料库 */
    private static SVNRepository repository;
    
    /** 声明SVN客户端管理类 */
    private static SVNClientManager svnClientManager;
    
    /** SVNURL声明 */
    private static SVNURL repositoryURL;
    
    /** SVN客户端管理VO */
    public static MetadataSVNModel metadataSVNModel;
    
    static {
        //初始化MetadataSVNModel
        initMetadataSVNModel();
        
        // 初始化SVN库
        setupLibrary();
    }
    
    /**
     * 构造函数
     */
    private MetadataSVNClientManager() {
        super();
    }
    
    /**
     * 初始化MetadataSVNModel
     */
    private static void initMetadataSVNModel() {
        metadataSVNModel = MetadataPreferences.getMetadataSVNModel();
        //处理JSON文件存储路径
        String strJsonFilePath = metadataSVNModel.getTempWorkSpace();
        strJsonFilePath = strJsonFilePath.endsWith("/") ? strJsonFilePath : strJsonFilePath + "/";
        metadataSVNModel.setTempWorkSpace(strJsonFilePath);
    }
    
    /**
     * 初始化操作
     * 
     * @return repository repository
     * 
     */
    public static SVNRepository initSVNRepository() {
        try {
            repository = SVNRepositoryFactoryImpl.create(SVNURL.parseURIEncoded(metadataSVNModel.getUrl()));
        } catch (SVNException e) {
            LOGGER.error("初始化SVN库失败！", e);
            throw new CapMetaDataException("初始化SVN库失败！", e);
        }
        ISVNAuthenticationManager objAuthManager = SVNWCUtil.createDefaultAuthenticationManager(
            metadataSVNModel.getUserName(), metadataSVNModel.getPassword());
        repository.setAuthenticationManager(objAuthManager);
        return repository;
    }
    
    /**
     * 获取SVNRepository
     * 
     * @param url SVNURL
     * @return repository repository
     * 
     */
    public static SVNRepository getSVNRepository(String url) {
        try {
            repository = SVNRepositoryFactoryImpl.create(SVNURL.parseURIEncoded(url));
        } catch (SVNException e) {
            LOGGER.error("初始化SVN库失败！", e);
            throw new CapMetaDataException("初始化SVN库失败！", e);
        }
        ISVNAuthenticationManager objAuthManager = SVNWCUtil.createDefaultAuthenticationManager(
            metadataSVNModel.getUserName(), metadataSVNModel.getPassword());
        repository.setAuthenticationManager(objAuthManager);
        return repository;
    }
    
    /**
     * 初始化SVN库
     * 
     */
    public static void setupLibrary() {
        // 用于file://协议
        FSRepositoryFactory.setup();
        // 用于https://协议
        DAVRepositoryFactory.setup();
        // 用于svn:// and svn+xxx://协议
        SVNRepositoryFactoryImpl.setup();
    }
    
    /**
     * 获取实例化SVN客户端管理类
     * 
     * @return SVN客户端管理类
     */
    public static SVNClientManager getSVNClientManager() {
        ISVNOptions objOptions = SVNWCUtil.createDefaultOptions(true);
        // 实例化客户端管理类
        svnClientManager = SVNClientManager.newInstance((DefaultSVNOptions) objOptions, metadataSVNModel.getUserName(),
            metadataSVNModel.getPassword());
        return svnClientManager;
    }
    
    /**
     * 获取RepositoryURL
     * 
     * @return RepositoryURL
     */
    public static SVNURL getRepositoryURL() {
        try {
            repositoryURL = SVNURL.parseURIEncoded(metadataSVNModel.getUrl());
        } catch (SVNException e) {
            LOGGER.error("获取获取RepositoryURL失败！", e);
            throw new CapMetaDataException("获取获取RepositoryURL失败！", e);
        }
        return repositoryURL;
    }
}
