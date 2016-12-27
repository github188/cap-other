/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.preferencesconfig.model;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.ArrayList;
import java.util.List;

import javax.persistence.Id;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 首选项配置VO
 *
 * @author 罗珍明
 * @version jdk1.6
 * @version 2015-12-31
 * @version 2016-05-30 许畅 修改
 */
@DataTransferObject
public class PreferenceConfigVO extends BaseMetadata implements Cloneable {
    
    /** 日志 */
    private static Logger LOGGER = LoggerFactory.getLogger(PreferenceConfigVO.class);
    
    /** 配置code */
    @Id
    private String configKey;
    
    /** 配置值 */
    private String configValue;
    
    /** 子配置集合 */
    private List<PreferenceConfigVO> subConfig = new ArrayList<PreferenceConfigVO>();
    
    /**
     * @return the configKey
     */
    public String getConfigKey() {
        return configKey;
    }
    
    /**
     * @param configKey
     *            the configKey to set
     */
    public void setConfigKey(String configKey) {
        this.configKey = configKey;
    }
    
    /**
     * @return the configValue
     */
    public String getConfigValue() {
        return configValue;
    }
    
    /**
     * @param configValue
     *            the configValue to set
     */
    public void setConfigValue(String configValue) {
        this.configValue = configValue;
    }
    
    /**
     * @return the subConfig
     */
    public List<PreferenceConfigVO> getSubConfig() {
        return subConfig;
    }
    
    /**
     * @param subConfig
     *            the subConfig to set
     */
    public void setSubConfig(List<PreferenceConfigVO> subConfig) {
        this.subConfig = subConfig;
    }
    
    /**
     * 使用JDK clone方法将对象深度复制
     * 
     * @return PreferenceConfigVO
     */
    @SuppressWarnings("unchecked")
    @Override
    public PreferenceConfigVO clone() {
        PreferenceConfigVO preferenceConfigVO = null;
        try {
            preferenceConfigVO = (PreferenceConfigVO) super.clone();
            preferenceConfigVO.subConfig = (List<PreferenceConfigVO>) ((ArrayList<PreferenceConfigVO>) subConfig)
                .clone();
        } catch (CloneNotSupportedException e) {
            LOGGER.error(e.getMessage(), e);
        }
        return preferenceConfigVO;
    }
    
    /**
     * 利用的对象的序列化和反序列化深度复制
     * 
     * @return PreferenceConfigVO
     */
    public PreferenceConfigVO copy() {
        PreferenceConfigVO preferenceConfigVO = null;
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        ObjectOutputStream oos = null;
        ObjectInputStream ois = null;
        try {
            oos = new ObjectOutputStream(bos);
            oos.writeObject(this);
            ois = new ObjectInputStream(new ByteArrayInputStream(bos.toByteArray()));
            preferenceConfigVO = (PreferenceConfigVO) ois.readObject();
        } catch (IOException e) {
            LOGGER.error(e.getMessage(), e);
        } catch (ClassNotFoundException e) {
            LOGGER.error(e.getMessage(), e);
        } finally {
            try {
                if (ois != null)
                    ois.close();
                if (oos != null)
                    oos.close();
            } catch (IOException e) {
                LOGGER.error(e.getMessage(), e);
            }
        }
        return preferenceConfigVO;
    }
}
