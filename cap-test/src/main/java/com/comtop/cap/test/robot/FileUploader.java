/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.robot;

import java.io.File;
import java.io.FileFilter;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Arrays;
import java.util.List;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPFile;
import org.apache.commons.net.ftp.FTPReply;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.component.loader.exception.LoadException;
import com.comtop.cip.jodd.util.ObjectUtil;

/**
 * 文件上传
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年7月6日 lizhongwen
 */
public class FileUploader {
    
    /** 日志 */
    private final static Logger logger = LoggerFactory.getLogger(FileUploader.class);
    
    /** 请求地址 */
    private String url;
    
    /** 服务器地址 */
    private String host;
    
    /** 服务器端口 */
    private int port;
    
    /** 用户名 */
    private String username;
    
    /** 密码 */
    private String password;
    
    /** ftp client */
    private FTPClient ftpClient;
    
    /** 文件上传实例 */
    private static FileUploader instance;
    
    /**
     * 构造函数
     * 
     * @param url 请求地址
     * @param username 用户名
     * @param password 密码
     */
    private FileUploader(String url, String username, String password) {
        super();
        this.url = url;
        this.username = username;
        this.password = password;
    }
    
    /**
     * 获取文件上传服务器
     *
     * @param url 请求地址
     * @param username 用户名
     * @param password 密码
     * @return 文件上传
     */
    public static FileUploader getInstance(String url, String username, String password) {
        if (instance == null) {
            createInstance(url, username, password);
            
        } else if (!ObjectUtil.equals(instance.url, url) || !ObjectUtil.equals(instance.password, password)
            || !ObjectUtil.equals(instance.username, username)) {
            instance = null;
            createInstance(url, username, password);
        }
        return instance;
    }
    
    /**
     * 构造实例
     *
     * @param url 请求地址
     * @param username 用户名
     * @param password 密码
     */
    private static void createInstance(String url, String username, String password) {
        if (StringUtils.isBlank(url) || StringUtils.isBlank(username)) {
            throw new LoadException("服务器参数不正确！");
        }
        synchronized (FileUploader.class) {
            if (instance == null) {
                instance = new FileUploader(url, username, password);
            }
        }
    }
    
    /**
     * 启动服务
     */
    public void openServer() {
        if (StringUtils.isBlank(url) || StringUtils.isBlank(username)) {
            throw new LoadException("服务器参数不正确！");
        }
        
        // 要是ftpClient是活动的就不在创建连接
        if (ftpClient != null) {
            int replyCode = ftpClient.getReplyCode();
            if (FTPReply.isPositiveCompletion(replyCode)) {
                return;
            }
        }
        try {
            URL ftpURL = new URL(url);
            host = ftpURL.getHost();
            port = ftpURL.getPort() < 0 ? 21 : ftpURL.getPort();
        } catch (MalformedURLException e) {
            throw new LoadException("服务器URL格式不正确！", e);
        }
        synchronized (FileUploader.class) {
            ftpClient = new FTPClient();
            // 设置对中文文件名上传下载的支持
            ftpClient.setControlEncoding("UTF-8");
            // ftpClient.addProtocolCommandListener(new PrintCommandListener(new PrintWriter(System.out), true));
        }
    }
    
    /**
     * 关闭服务器
     */
    public void closeServer() {
        if (ftpClient.isConnected()) {
            try {
                ftpClient.disconnect();
            } catch (IOException e) {
                logger.error("连接ftp服务器出错！", e);
            }
        }
    }
    
    /**
     * @return 是否能够获取到连接
     */
    public boolean testConenction() {
        return connect();
    }
    
    /**
     * @return 连接FTP服务器
     */
    private boolean connect() {
        if (ftpClient == null) {
            this.openServer();
        }
        if (ftpClient.isConnected()) {
            // 是否成功登录FTP服务器
            int replyCode = ftpClient.getReplyCode();
            if (FTPReply.isPositiveCompletion(replyCode)) {
                return true;
            }
        }
        try {
            ftpClient.connect(host, port);
            ftpClient.setFileType(FTP.BINARY_FILE_TYPE);
            return ftpClient.login(username, password);
        } catch (Exception e) {
            logger.error("连接ftp服务器出错！", e);
        }
        return false;
    }
    
    /**
     * 上传文件
     *
     * @param folderPath 指定服务器上文件保存目录
     * @param filePath 文件路径
     */
    public void upload(String folderPath, String filePath) {
        File file = new File(filePath);
        upload(folderPath, file);
    }
    
    /**
     * 上传文件
     *
     * @param folderPath 指定服务器上文件保存目录
     * @param file 文件
     */
    public void upload(String folderPath, File file) {
        // 连接服务器
        if (!connect()) {
            throw new LoadException("无法连接到服务器！");
        }
        String folder = folderPath.replace("\\", "/");
        boolean uploaded = false;
        try {
            // 如果目录不存在
            if (!dirExists(folder)) {
                // 创建
                mkd(folder);
            }
            uploaded = updateFile(folder, file);
        } catch (Exception e) {
            throw new LoadException("ftp上传出错!", e);
        } finally {
            // 关闭连接
            closeServer();
        }
        if (!uploaded) {
            throw new LoadException("ftp上传出错!");
        }
    }
    
    /**
     * 上传文件
     *
     * @param folder 文件目录
     * @param file 文件
     * @return 是否上传成功
     */
    private boolean updateFile(String folder, File file) {
        boolean uploaded = false;
        // 连接服务器
        if (!connect()) {
            throw new LoadException("无法连接到服务器！");
        }
        FileInputStream fis = null;
        try {
            fis = new FileInputStream(file);
            String remote = folder.endsWith("/") ? folder + file.getName() : folder + "/" + file.getName();
            if (fileExistes(remote)) {
                this.delete(remote, false);
            }
            uploaded = ftpClient.storeFile(remote, fis);
        } catch (Exception e) {
            logger.error("文件上传出错", e);
        } finally {
            IOUtils.closeQuietly(fis);
        }
        return uploaded;
    }
    
    /**
     * 上传指定目录中的文件
     *
     * @param folderPath 远程文件保存目录
     * @param dir 本地文件目录
     * @param filter 文件过滤器
     */
    public void batchUpload(String folderPath, String dir, FileFilter filter) {
        File directory = new File(dir);
        if (!directory.exists()) {
            return;
        }
        File[] files = directory.listFiles(filter);
        if (files == null || files.length == 0) {
            return;
        }
        this.batchUpload(folderPath, Arrays.asList(files));
    }
    
    /**
     * 上传多个文件
     *
     * @param folderPath 远程文件保存目录
     * @param files 本地文件
     */
    public void batchUpload(String folderPath, List<File> files) {
        // 连接服务器
        if (!connect()) {
            throw new LoadException("无法连接到服务器！");
        }
        String folder = folderPath.replace("\\", "/");
        boolean uploaded = true;
        try {
            // 如果目录不存在
            if (!dirExists(folder)) {
                // 创建
                mkd(folder);
            }
            boolean ret;
            for (File file : files) {
                ret = this.updateFile(folder, file);
                uploaded = ret && uploaded;
            }
        } catch (Exception e) {
            throw new LoadException("ftp上传出错!", e);
        } finally {
            // 关闭连接
            closeServer();
        }
        if (!uploaded) {
            throw new LoadException("ftp上传出错!");
        }
    }
    
    /**
     * 检出文件是否存在
     *
     * @param filePath 远程文件路径
     * @return 文件是否已在服务器中存在
     */
    private boolean fileExistes(String filePath) {
        // 连接服务器
        if (!connect()) {
            throw new LoadException("无法连接到服务器！");
        }
        // 获取到文件夹路径中每个文件夹的名称
        String path = filePath.replace("\\", "/");
        try {
            FTPFile[] files = ftpClient.listFiles(path);
            return files != null && files.length > 0;
        } catch (IOException e) {
            logger.debug("查询文件列表失败！", e);
            return false;
        }
    }
    
    /**
     * 删除文件
     *
     * @param filePath 远程文件路径
     * @return 是否删除成功
     */
    public boolean delete(String filePath) {
        return this.delete(filePath, true);
    }
    
    /**
     * 删除文件
     *
     * @param filePath 远程文件路径
     * @param closeServer 是否关闭远程连接
     * @return 是否删除成功
     */
    public boolean delete(String filePath, boolean closeServer) {
        // 连接服务器
        if (!connect()) {
            throw new LoadException("无法连接到服务器！");
        }
        try {
            return ftpClient.deleteFile(filePath);
        } catch (IOException e) {
            throw new LoadException(String.format("ftp删除文件  %s 出错.%n", filePath), e);
        } finally {
            if (closeServer) {
                closeServer();
            }
        }
    }
    
    /**
     * 通过给定的文件夹路径创建文件夹(文件定位的开始是用当前的工作目录)<br>
     * 要是父文件夹不存在也会创建父文件夹
     * 
     * @param folderPath 目录
     * @throws IOException IO异常
     */
    public void mkd(String folderPath) throws IOException {
        // 连接服务器
        if (!connect()) {
            throw new LoadException("无法连接到服务器！");
        }
        // 获取到文件夹路径中每个文件夹的名称
        String[] folders = folderPath.replace("\\", "/").split("/");
        // 获取ftp当前的工作目录
        String ftpWorkingDirectory = ftpClient.printWorkingDirectory();
        
        for (String folder : folders) {
            // 如果不存在就创建
            if (!dirExists(folder)) {
                ftpClient.makeDirectory(folder);
            }
            // 并切换为当前的工作目录
            ftpClient.changeWorkingDirectory(folder);
        }
        // 创建完成后切换回原来的工作目录
        ftpClient.changeWorkingDirectory(ftpWorkingDirectory);
    }
    
    /**
     * 判断对应的文件夹目录在服务器端是否存在
     * 
     * @param folderPath
     *            目录
     * @return true 存在 false 不存在
     */
    public boolean dirExists(String folderPath) {
        // 连接服务器
        if (!connect()) {
            throw new LoadException("无法连接到服务器！");
        }
        String folder = folderPath.replace("\\", "/");
        if ("/".equals(folder)) {
            return true;
        }
        
        FTPFile[] ftpFileArr = null;
        try {
            ftpFileArr = ftpClient.listFiles(folder);
        } catch (IOException e) {
            logger.debug("查询文件目录列表失败！", e);
            return false;
        }
        return ftpFileArr != null && ftpFileArr.length > 0;
    }
    
}
