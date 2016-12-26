/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.webapp.page.demo.action;

import com.comtop.cap.bm.webapp.page.demo.action.abs.AbstractFormCRUDAction;
import com.comtop.cip.jodd.madvoc.meta.MadvocAction;
import comtop.org.directwebremoting.annotations.DwrProxy;

/**
 * 最佳实践Action
 * 
 * @author 郑重
 * @version jdk1.6
 * @version 2015-5-27 郑重
 */
@DwrProxy
@MadvocAction
public class FormCRUDAction extends AbstractFormCRUDAction {

	/**
	 * 初始化页面参数
	 */
	@Override
	public void initBussinessAttr() {
		stringAttr = "zz";
		intAttr = 1;
		form = readFormById("sdf");
	}
}
