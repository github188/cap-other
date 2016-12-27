/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.common.storage;

import java.io.File;

/**
 * 文件操作接口
 *
 * @author 郑重
 * @version jdk1.5
 * @version 2015-4-24 郑重
 */
public interface IFileOperator {
    
    /**
     * 获取文件扩展名
     * 
     * @return 文件扩展名
     */
    public String getFileExtName();
    
    /**
     * 获取临时文件
     * 
     * @param file 临时文件
     * @return 临时文件
     */
    public File getTempFile(final File file);
    
    /**
     * 保存文件
     * 
     * @param vo 模型对象
     * @param file 文件
     * @param isTemp 是否临时临时文件
     * @return 是否成功
     */
    public boolean saveFile(final Object vo, final File file, boolean isTemp);
    
    /**
     * 读取文件
     * @param <T> Class
     * 
     * @param file 文件
     * @param type 模型类型
     * @param isTemp 是否临时临时文件
     * @return 模型对象
     */
    public <T> T readFile(File file, Class<T> type, boolean isTemp);
    
    /**
     * 删除文件
     * 
     * @param file 问
     * @return 是否删除成功
     */
    public boolean deleteFile(final File file);
}
