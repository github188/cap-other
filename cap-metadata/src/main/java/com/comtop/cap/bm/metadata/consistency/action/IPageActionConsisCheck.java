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

/**
 * 控件属性一致性校验
 * 
 * @author 罗珍明
 *
 */
public interface IPageActionConsisCheck {

	/**
	 * 校验控件属性的值的一致性
	 * @param comp 行为模板信息
	 * @param data 页面行为
	 * @param root page对象
	 * @return 校验结果
	 */
	List<ConsistencyCheckResult> checkPageActionConsis(ActionDefineVO comp, PageActionVO data, PageVO root);
	
	/**
     * 校验行为属性是否依赖了当前传入的实体属性
     *
     * @param comp 属性对象
     * @param entityAttrs 实体属性集合
     * @param data 控件属性对象
     * @param root 页面对象
     * @return 校验结果
     */
	List<ConsistencyCheckResult> checkPageActionDependOnEntityAttr(ActionDefineVO comp,
        List<EntityAttributeVO> entityAttrs, PageActionVO data, PageVO root);
	
	/**
     * 校验行为属性是否依赖了当前传入的实体方法
     *
     * @param comp 属性对象
     * @param entityMethods 实体方法集合
     * @param data 控件属性对象
     * @param root 页面对象
     * @return 校验结果
     */
    List<ConsistencyCheckResult> checkPageActionDependOnEntityMethod(ActionDefineVO comp,
        List<MethodVO> entityMethods, PageActionVO data, PageVO root);
}
