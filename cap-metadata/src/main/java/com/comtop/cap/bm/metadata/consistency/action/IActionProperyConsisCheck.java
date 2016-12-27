/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.consistency.action;

import java.util.List;

import com.comtop.cap.bm.metadata.base.consistency.model.ConsistencyCheckResult;
import com.comtop.cap.bm.metadata.entity.model.EntityAttributeVO;
import com.comtop.cap.bm.metadata.entity.model.MethodVO;
import com.comtop.cap.bm.metadata.page.actionlibrary.model.ActionDefineVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageActionVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.cap.bm.metadata.page.uilibrary.model.PropertyVO;

/**
 * 控件属性一致性校验
 * 
 * @author 罗珍明
 *
 */
public interface IActionProperyConsisCheck {

	/**
	 * 校验控件属性的值的一致性
	 * @param comp 控件信息
	 * @param propertyVO 控件属性
	 * @param data 控件对应的布局对象
	 * @param root page对象
	 * @return 校验结果
	 */
    ConsistencyCheckResult checkPropertyValueConsis(ActionDefineVO comp, PropertyVO propertyVO,
			PageActionVO data, PageVO root);
    
    /**
     * 校验行为属性是否依赖了当前传入的实体属性
     *
     * @param comp 属性对象
     * @param entityAttrs 实体属性集合
     * @param propertyVO 属性对象
     * @param data 控件属性对象
     * @param root 页面对象
     * @return 校验结果
     */
    ConsistencyCheckResult checkPageActionDependOnEntityAttr(ActionDefineVO comp,
        List<EntityAttributeVO> entityAttrs, PropertyVO propertyVO, PageActionVO data, PageVO root);
    
    /**
     * 校验行为属性是否依赖了当前传入的实体方法
     *
     * @param entityMethodVOs 实体方法 集合
     * @param propertyVO 属性对象
     * @param data 控件属性对象
     * @param root 页面对象
     * @return 校验结果
     */
    ConsistencyCheckResult checkPageActionDependOnEntityMethod(List<MethodVO> entityMethodVOs, PropertyVO propertyVO, PageActionVO data, PageVO root);
}
