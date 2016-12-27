/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.consistency;

import java.util.List;

import com.comtop.cap.bm.metadata.base.consistency.model.ConsistencyCheckResult;
import com.comtop.cap.bm.metadata.entity.model.EntityAttributeVO;
import com.comtop.cap.bm.metadata.page.desinger.model.DataStoreVO;
import com.comtop.cap.bm.metadata.page.desinger.model.LayoutVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.cap.bm.metadata.page.uilibrary.model.ComponentVO;
import com.comtop.cap.bm.metadata.page.uilibrary.model.EventVO;
import com.comtop.cap.bm.metadata.page.uilibrary.model.PropertyVO;

/**
 * 控件属性一致性校验
 * 
 * @author 罗珍明
 *
 */
public interface IComponentConsisCheck {
    
    /**
     * 校验控件属性的值的一致性
     * 
     * @param comp 控件信息
     * @param properties 控件属性集合
     * @param data 控件对应的布局对象
     * @param root page对象
     * @return 校验结果
     */
    List<ConsistencyCheckResult> checkPropertyValueConsis(ComponentVO comp, List<PropertyVO> properties, LayoutVO data,
        PageVO root);
    
    /**
     * 校验控件行为属性的值的一致性
     * 
     * @param comp 控件信息
     * @param eventList 控件属性集合
     * @param data 控件对应的布局对象
     * @param root page对象
     * @return 校验结果
     */
    List<ConsistencyCheckResult> checkEventValueConsis(ComponentVO comp, List<EventVO> eventList, LayoutVO data,
        PageVO root);
    
    /**
     * 校验控件属性是否依赖了当前传入的实体属性
     * 
     * @param comp 控件信息
     * @param entityAttrs 实体属性集合
     * @param relationDataStores 关联了当前校验实体的数据集
     * @param data 控件属性对象
     * @param page 页面对象
     * @return 校验结果
     */
    List<ConsistencyCheckResult> checkProValDependOnEntityAttr(ComponentVO comp,
        List<EntityAttributeVO> entityAttrs, List<DataStoreVO> relationDataStores, LayoutVO data, PageVO page);
}
