/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.pdm.util;

import java.io.File;

/**
 * PDM帮助类
 *
 *
 * @author 杜祺
 * @since 1.0
 * @version 2016-03-02
 */
public class PdmUtils
{
    /**
     * 获取webinf路径
     *
     * @return WebinfPath
     */
    private static String getWebinfPath() {
        String classesFilePath = Thread.currentThread().getContextClassLoader().getResource("").getFile();
        File file = new File(classesFilePath);
        return file.getParent();
    }

    /**
     * 获取webinf路径
     *
     * @return WebinfPath
     */
    public static String createTmpFileDir() {
        String webinfPath = getWebinfPath();
        String tmpFileDir = webinfPath + File.separator + "cap" + File.separator + "pdm";
        File file = new File(tmpFileDir);
        mkDir(file);
        return tmpFileDir;
    }

    /**
     * 递归创建目录
     *
     * @param file 文件
     */
    private static void mkDir(File file) {
        if (file.getParentFile().exists()) {
            file.mkdir();
        } else {
            mkDir(file.getParentFile());
            file.mkdir();
        }
    }
}
