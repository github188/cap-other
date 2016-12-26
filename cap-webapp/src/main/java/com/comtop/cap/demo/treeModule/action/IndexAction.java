/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.demo.treeModule.action;

import com.comtop.cap.demo.treeModule.action.abs.AbstractIndexAction;
import com.comtop.cip.jodd.madvoc.meta.MadvocAction;
import comtop.org.directwebremoting.annotations.DwrProxy;

/**
 * 主页面（框架布局）Action
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-6-14 CAP超级管理员
 */
@DwrProxy
@MadvocAction
public class IndexAction extends AbstractIndexAction {

	/**
	 * 初始化页面参数
	 */
	@Override
	public void initBussinessAttr() {
		//添加页面初始化时候输出参数值
	}
}