/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.entity.facade;

import java.util.List;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import com.comtop.cap.bm.metadata.entity.model.EntityVO;

/**
 * 获取实体信息的接口。
 * 用于获取本实体及所有父实体的属性或方法
 *
 * @author 凌晨
 * @since jdk1.6
 * @version 2015年11月5日 凌晨
 */
public interface IEntitysInfo {
    
    /**
     * 
     * 获取实体的所有属性或方法（本实体的以及所有父实体的）
     *
     * @param lstEntityVOs 本实体及所有父实体的集合
     * @return 返回本实体及所有父实体的属性或方法集合
     */
    List<? extends BaseMetadata> getAllEntitysInfo(List<EntityVO> lstEntityVOs);
}
