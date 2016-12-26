/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.meeting.action;

import com.comtop.meeting.action.abs.AbstractEeeTestModelListPageAction;
import com.comtop.cip.jodd.madvoc.meta.MadvocAction;
import comtop.org.directwebremoting.annotations.DwrProxy;

/**
 * werwe测试模板列表页面Action
 * 
 * @author 作者
 * @version jdk1.6
 * @version 2016-2-23 作者
 */
@DwrProxy
@MadvocAction
public class EeeTestModelListPageAction extends AbstractEeeTestModelListPageAction {

	/**
	 * 初始化页面参数
	 */
	@Override
	public void initBussinessAttr() {
		//添加页面初始化时候输出参数值
	}
}