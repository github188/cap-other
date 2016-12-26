/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.dao;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.document.word.bizmodel.ModelObject;
import com.comtop.cip.json.JSON;

/**
 * 数据访问通用扩展
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年11月10日 lizhiyong
 */
public class CommonExtDataAccessor implements IWordDataAccessor<ModelObject> {
    
    /** 日志对象 */
    private final Logger LOGGER = LoggerFactory.getLogger(CommonExtDataAccessor.class);
    
    /** 输出文件夹 */
    private File outputDir;
    
    /**
     * 构造函数
     */
    public CommonExtDataAccessor() {
        String path = System.getProperty("user.dir");
        outputDir = new File(path + File.separator + "test" + File.separator
            + new SimpleDateFormat("yyyy-MM-dd HH-mm-ss-sss").format(new Date(System.currentTimeMillis())));
        if (!outputDir.exists()) {
            outputDir.mkdirs();
        }
    }
    
    @Override
    public void saveData(List<ModelObject> wordData) {
        String json = JSON.toJSONString(wordData, true);
        FileOutputStream fileOutputStream = null;
        try {
            File file = new File(outputDir.getAbsolutePath() + File.separator + wordData.get(0).getClassUri() + ".json");
            if (!file.exists()) {
                file.createNewFile();
            }
            fileOutputStream = new FileOutputStream(file);
            fileOutputStream.write(json.getBytes());
            fileOutputStream.flush();
        } catch (FileNotFoundException e) {
            LOGGER.error("持久化数据时发生异常", e);
        } catch (IOException e) {
            LOGGER.error("持久化数据时发生异常", e);
        } finally {
            if (fileOutputStream != null) {
                IOUtils.closeQuietly(fileOutputStream);
            }
        }
    }
    
    @Override
    public List<ModelObject> loadData(ModelObject condition) {
        return null;
    }
    
    @Override
    public void updatePropertyByID(String id, String propertyName, Object value) {
        //
    }
    
}
