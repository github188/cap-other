/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.meeting.action;

import com.comtop.meeting.action.abs.AbstractUserWorkflowListPageForWorkFlowAction;
import com.comtop.cip.jodd.madvoc.meta.MadvocAction;
import comtop.org.directwebremoting.annotations.DwrProxy;

/**
 * 用户工作流测试列表页面Action
 * 
 * @author CAP超级管理员
 * @version jdk1.6
 * @version 2016-3-24 CAP超级管理员
 */
@DwrProxy
@MadvocAction
public class UserWorkflowListPageForWorkFlowAction extends AbstractUserWorkflowListPageForWorkFlowAction {

	/**
	 * 初始化页面参数
	 */
	@Override
	public void initBussinessAttr() {
		//添加页面初始化时候输出参数值
	}
}