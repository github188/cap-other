/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.common.storage;

/**
 * 枚举 ClassConfig配置
 *
 *
 * @author 凌晨
 * @since jdk1.6
 * @version 2016年6月22日 凌晨
 */
public enum ClassConfigEnum {
    
    /** 开发建模的配置 */
    DEVALOP_CONFIG("modelClassConfig.xml"),
    /** 测试建模的配置 */
    TEST_CONFIG("testClassConfig.xml");
    
    /** 配置文件的名称 */
    private String configName;
    
    /**
     * 构造函数
     * 
     * @param configName 配置文件的名称
     */
    private ClassConfigEnum(String configName) {
        this.configName = configName;
    }
    
    /**
     * @return 获取 configName属性值
     */
    public String getConfigName() {
        return configName;
    }
    
}
