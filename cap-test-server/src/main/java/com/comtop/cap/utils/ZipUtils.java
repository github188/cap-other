/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 压缩文件工具类
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年8月19日 lizhongwen
 */
public class ZipUtils {
    
    /** 日志 */
    private static final Logger logger = LoggerFactory.getLogger(ZipUtils.class);
    
    /**
     * 压缩文件
     *
     * @param filePath 文件路径
     * @return 压缩文件路径
     */
    public static String zipFile(String filePath) {
        File file = new File(filePath);
        String zipPath = filePath + ".zip";
        if (file.exists() && file.isDirectory()) {
            try (FileOutputStream fout = new FileOutputStream(zipPath);
                ZipOutputStream zout = new ZipOutputStream(fout);) {
                addDirectory(zout, file);
                // close the ZipOutputStream
                zout.close();
                logger.info("Zip file has been created!");
                return zipPath;
            } catch (IOException e) {
                logger.error("打压缩包出错！", e);
            }
        }
        return null;
    }
    
    /**
     * 添加目录
     *
     * @param zout ZIP输出
     * @param dir 文件目录
     */
    private static void addDirectory(ZipOutputStream zout, File dir) {
        File[] files = dir.listFiles();
        logger.debug("Adding directory " + dir.getName());
        FileInputStream fin = null;
        for (int i = 0; i < files.length; i++) {
            try {
                String name = files[i].getAbsolutePath();
                name = name.substring(dir.getAbsolutePath().length() + 1);
                // if the file is directory, call the function recursively
                if (files[i].isDirectory()) {
                    addDirectory(zout, files[i]);
                    continue;
                }
                logger.debug("Adding file " + files[i].getName());
                // create object of FileInputStream
                fin = new FileInputStream(files[i]);
                zout.putNextEntry(new ZipEntry(name));
                IOUtils.copy(fin, zout);
                zout.closeEntry();
            } catch (IOException ioe) {
                logger.error(ioe.getMessage(), ioe);
            } finally {
                // close the InputStream
                IOUtils.closeQuietly(fin);
            }
        }
    }
}
