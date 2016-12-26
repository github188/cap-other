/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.definition;

import org.junit.Assert;
import org.junit.Test;

import com.comtop.cap.test.robot.FileUploader;

/**
 * 测试文件上传
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年7月6日 lizhongwen
 */
public class TestFileUploader {
    
    /**
     * 测试连接
     */
    @Test
    public void testConn() {
        FileUploader uploader = FileUploader.getInstance("http://10.10.5.151", "admin", "admin");
        boolean ret = uploader.testConenction();
        Assert.assertTrue(ret);
    }
    
    /**
     * 测试上传
     */
    @Test
    public void testUpload() {
        FileUploader uploader = FileUploader.getInstance("http://10.10.5.151", "admin", "admin");
        uploader.upload("/Cap自动化测试", "D:/Cap自动化测试/element.txt");
    }
}
