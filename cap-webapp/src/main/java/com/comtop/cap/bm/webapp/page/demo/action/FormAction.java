/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.webapp.page.demo.action;

import java.io.File;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.comtop.cap.bm.metadata.common.dwr.CapMap;
import com.comtop.cap.bm.metadata.common.storage.JsonOperator;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.cap.bm.webapp.page.demo.facade.FormFacade;
import com.comtop.cap.runtime.base.action.BaseAction;
import com.comtop.cip.jodd.madvoc.meta.Action;
import com.comtop.cip.jodd.madvoc.meta.InOut;
import com.comtop.cip.jodd.madvoc.meta.MadvocAction;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;

/**
 * 测试页面action
 *
 * @author 郑重
 * @version jdk1.5
 * @version 2015-5-14 郑重
 */
@DwrProxy
@MadvocAction
public class FormAction extends BaseAction {

	/**
	 * 页面参数,传入传出都可以，框架会自动放到request Attribute里
	 */
	@InOut
	String stringAttr;

	/**
	 * 页面参数
	 */
	@InOut
	int intAttr;

	/**
	 * 页面参数
	 */
	@InOut
	boolean verifyAttr;

	/**
	 * 页面参数
	 */
	@SuppressWarnings("rawtypes")
	@InOut
	Map form;

	/**
	 * ioc注入FormFacade
	 */
	@PetiteInject
	private FormFacade formFacade;

	/**
	 * 初始化页面参数
	 */
	@Override
	public void initBussinessAttr() {
		stringAttr = "zz";
		intAttr = 1;
		form = readFormById("sdf");
	}

	/**
	 * 初始化页面参数-权限
	 */
	@Override
	public void initVerifyAttr() {
		verifyAttr = verify("formdemo", "testOperator");
	}

	/**
	 * 页面初始化
	 *
	 * @return URL
	 */
	@Action("/cap/bm/dev/page/demo/form.ac")
	public String pageInit() {
		initPageAttr();
		return "/cap/bm/dev/page/demo/Form.jsp";
	}

	/**
	 * 通过实体属性ID查询实体属性
	 *
	 * @param entityId 实体属性ID
	 * @return 实体属性对象
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RemoteMethod
	public Map readFormById(String entityId) {
		Map objHashMap = new HashMap();
		/*
		 * var data={input:'绑定input', calender:
		 * '2015-05-07',checkboxGroup:[0,1],radioGroup:0,clickInput:'绑定clickInput',
		 * textarea:'绑定textarea',editor:'<span
		 * style="font-size: 20px;">绑定editor</span>' };
		 */
		objHashMap.put("input", "绑定input22222");
		objHashMap.put("calender", new Date());
		objHashMap.put("checkboxGroup", new Integer[] { 0, 1 });
		objHashMap.put("radioGroup", 0);
		objHashMap.put("clickInput", "绑定clickInput");
		objHashMap.put("textarea", "绑定textarea");
		objHashMap.put("editor", "<span style='font-size: 20px;'>绑定editor</span>");
		List lstC = new ArrayList<String>();
		PageVO objPageVO = new PageVO();
		objPageVO.setCname("sdfds");
		lstC.add(objPageVO);
		objHashMap.put("c", lstC);
		JsonOperator objJsonOperator = new JsonOperator();
		objJsonOperator.saveJson(objHashMap, new File("C:/z.json"), false);

		objHashMap = objJsonOperator.readJson(new File("C:/z.json"), HashMap.class, false);
		System.out.println(objHashMap.get("c").getClass());
		return objHashMap;
	}

	/**
	 * 通过实体属性ID查询实体属性
	 * @param capMap 表单
	 *
	 * @return 实体属性对象
	 */
	@RemoteMethod
	public boolean insertForm(CapMap capMap) {
		JsonOperator objJsonOperator = new JsonOperator();
		objJsonOperator.saveJson(form, new File("C:/z.json"), false);
		System.out.println(form.get("checkboxGroup").getClass());
		return true;
	}
}
