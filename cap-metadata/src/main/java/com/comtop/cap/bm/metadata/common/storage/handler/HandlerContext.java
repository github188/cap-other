/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.common.storage.handler;

import java.util.ArrayList;
import java.util.List;

import com.comtop.cap.bm.metadata.common.storage.handler.impl.EntityHandler;
import com.comtop.cap.bm.metadata.common.storage.handler.impl.MethodHandler;

/**
 * 负责数据处理策略器的管理
 * 
 * @author 凌晨
 * @since jdk1.6
 * @version 2016-5-20 凌晨
 */
public class HandlerContext {
    
    /**
     * 数据处理策略器
     */
    private static List<DataHandlerStrategy> lstHandler = new ArrayList<DataHandlerStrategy>();
    
    static {
        // 初始化数据处理策略器
        lstHandler.add(new EntityHandler());
        lstHandler.add(new MethodHandler());
    }
    
    /**
     * @return 获取 lstHandler属性值
     */
    public static List<DataHandlerStrategy> getLstHandler() {
        return lstHandler;
    }
    
}
