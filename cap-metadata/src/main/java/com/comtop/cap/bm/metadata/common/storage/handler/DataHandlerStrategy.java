/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.common.storage.handler;

/**
 * 数据处理策略接口
 * 
 * @author 凌晨
 * @version jdk1.6
 * @version 2016-5-19 凌晨
 */
public interface DataHandlerStrategy {
    
    /**
     * 对数据进行加工处理
     * 
     * @param obj 需要处理的数据对象
     */
    void invoke(Object obj);
    
    /**
     * @return 数据的模型类型
     */
    String getModelType();
}
