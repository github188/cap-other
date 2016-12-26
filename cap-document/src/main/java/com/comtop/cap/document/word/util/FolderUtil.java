/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.util;

import java.io.File;
import java.net.URISyntaxException;
import java.net.URL;

import org.apache.commons.lang.StringUtils;

/**
 * 文件夹
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年10月13日 lizhongwen
 */
public class FolderUtil {
    
    /**
     * 构造函数
     */
    private FolderUtil() {
    }
    
    /**
     * 获取项目基础路径
     *
     * @return 项目根路径
     */
    public static String projectBasePath() {
        URL url = Thread.currentThread().getContextClassLoader().getResource("");
        String path = urlToPath(url);
        if (StringUtils.isNotBlank(path)) {
            File file = new File(path);
            return file.getParentFile().getAbsolutePath();
        }
        return null;
    }
    
    /**
     * 获取项目测试数据输出路径
     *
     * @return 项目测试数据输出路径
     */
    public static String projectOutputPath() {
        String path = projectBasePath();
        if (path != null) {
            File file = new File(path + "/output");
            if (!file.exists()) {
                file.mkdirs();
            }
            return file.getAbsolutePath();
        }
        return null;
    }
    
    /**
     * 将url转换成文件绝对路径
     *
     * @param url url
     * @return 文件路径
     */
    public static String urlToPath(URL url) {
        File file;
        try {
            file = new File(url.toURI());
            return file.getAbsolutePath().replace("\\", "/");
        } catch (URISyntaxException e) {
            e.printStackTrace();
        }
        return null;
    }
    
}
