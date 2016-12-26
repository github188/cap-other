/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.meeting.action.abs;

import com.comtop.cap.runtime.base.action.BaseAction;
import com.comtop.cip.jodd.madvoc.meta.Action;
import com.comtop.cip.jodd.madvoc.meta.MadvocAction;
import comtop.org.directwebremoting.annotations.DwrProxy;
import com.comtop.cip.jodd.madvoc.meta.InOut;
import com.comtop.meeting.model.UserVO;
import java.util.List;
import java.util.Arrays;

/**
 * 用户工作流已办页面Action
 * 
 * @author CAP超级管理员
 * @version jdk1.6
 * @version 2016-3-24 CAP超级管理员
 */
@DwrProxy
@MadvocAction
public abstract class AbstractUserWorkflowTestDoneListPageAction extends BaseAction {


	/**
	 * 用户表
	 */
	@InOut
	protected UserVO user;
	
	/**
	 * 用户表集合
	 */
	@InOut
	protected List<UserVO> userList;
	

	/**
	 * 初始化页面参数-权限
	 */
	@Override
	public void initVerifyAttr() {
	//初始化权限变量
	}
	
	/**
	 * 初始化页面使用的数据字典集合
	 */
	@Override
	@SuppressWarnings({ "unchecked" })
	public void initDicDatas() {
		List<String> lstCode = Arrays.asList();
		List<List<String>> lstAttrs = Arrays.asList();
		initDicDatas(lstCode, lstAttrs);
	}
	
	
	/**
	 * 初始化页面使用的枚举集合
	 */
	@Override
	@SuppressWarnings({ "unchecked" })
	public void initEnumDatas() {
		List<String> lstCode = Arrays.asList();
		List<List<String>> lstAttrs = Arrays.asList();
		initEnumDatas(lstCode, lstAttrs);
	}

	/**
	 * 页面跳转
	 * @return 页面URL
	 */
	@Action("/meeting/userWorkflowTestDoneListPage.ac")
	public String pageInit() {
		initPageAttr();
		return "/meeting/UserWorkflowTestDoneListPage.jsp";
	}
}