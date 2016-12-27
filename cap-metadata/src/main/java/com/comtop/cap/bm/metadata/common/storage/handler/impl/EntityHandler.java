/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.common.storage.handler.impl;

import com.comtop.cap.bm.metadata.common.storage.handler.DataHandlerStrategy;
import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cip.jodd.util.StringUtil;

/**
 * 实体处理策略
 * 
 * @author 凌晨
 * @version jdk1.6
 * @version 2016-5-19 凌晨
 */
public class EntityHandler implements DataHandlerStrategy {
    
    /**
     * 数据的模型类型
     * 
     * @see com.comtop.cap.bm.metadata.common.storage.handler.DataHandlerStrategy#getModelType()
     */
    @Override
    public String getModelType() {
        return "entity";
    }
    
    /**
     * 对实体的别名进行处理
     * 实体有别名，则不处理，若实体没有别名，则把实体的英文名称首写字母转小写当做别名
     * 
     * @see com.comtop.cap.bm.metadata.common.storage.handler.DataHandlerStrategy#invoke(Object)
     */
    @Override
    public void invoke(Object obj) {
        EntityVO entity = (EntityVO) obj;
        // 若实体没有别名，则把实体的英文名称首写字母转小写当做别名
        if (StringUtil.isBlank(entity.getAliasName())) {
            String engName = entity.getEngName().trim();
            entity.setAliasName(engName.substring(0, 1).toLowerCase() + engName.substring(1));
        }
    }
    
}
