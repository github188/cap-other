/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.meeting.action.abs;

import com.comtop.cap.runtime.base.action.BaseAction;
import com.comtop.cip.jodd.madvoc.meta.Action;
import comtop.org.directwebremoting.annotations.DwrProxy;
import java.util.List;
import java.util.Arrays;

/**
 * 华侨城审批查看Action
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-5-16 CAP超级管理员
 */
@DwrProxy
public abstract class AbstractOtcProcessViewAction extends BaseAction {



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
	@Action("/meeting/otcProcessView.ac")
	public String pageInit() {
		initPageAttr();
		return "/meeting/OtcProcessView.jsp";
	}
}