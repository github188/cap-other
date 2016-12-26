/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.budget.action;

import com.comtop.budget.action.abs.AbstractUserEditPageForWorkFlowAction;
import com.comtop.cip.jodd.madvoc.meta.MadvocAction;
import comtop.org.directwebremoting.annotations.DwrProxy;

/**
 * 用户管理编辑页面Action
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-9-13 CAP超级管理员
 */
@DwrProxy
@MadvocAction
public class UserEditPageForWorkFlowAction extends AbstractUserEditPageForWorkFlowAction {

	/**
	 * 初始化页面参数
	 */
	@Override
	public void initBussinessAttr() {
		//添加页面初始化时候输出参数值
	}
}