/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.webapp.page.demo.action.abs;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.comtop.cap.bm.webapp.page.demo.facade.FormFacade;
import com.comtop.cap.runtime.base.action.BaseAction;
import com.comtop.cip.jodd.madvoc.meta.Action;
import com.comtop.cip.jodd.madvoc.meta.InOut;
import com.comtop.cip.jodd.madvoc.meta.MadvocAction;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;

/**
 * 最佳实践Action
 *
 * @author 郑重
 * @version jdk1.6
 * @version 2015-5-27 郑重
 */
@DwrProxy
@MadvocAction
public abstract class AbstractFormCRUDAction extends BaseAction {

	/**
	 * 页面参数,传入传出都可以，框架会自动放到request Attribute里
	 */
	@InOut
	protected String stringAttr;

	/**
	 * 页面参数
	 */
	@InOut
	protected int intAttr;

	/**
	 * 页面参数
	 */
	@InOut
	protected boolean verifyAttr;

	/**
	 * 页面参数
	 */
	@SuppressWarnings("rawtypes")
	@InOut
	protected Map form;

	/**
	 * ioc注入FormFacade
	 */
	@PetiteInject
	protected FormFacade formFacade;

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
	@Action("/cap/bm/dev/page/demo/generate/formCRUD.ac")
	public String pageInit() {
		initPageAttr();
		return "/cap/bm/dev/page/demo/generate/FormCRUD.jsp";
	}

	/**
	 * 通过实体属性ID查询实体属性
	 *
	 * @param entityId 实体属性ID
	 * @return 实体属性对象
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RemoteMethod
	public Map readFormById(String entityId) {
		Map objFormVO = new HashMap();
		/*
		 * data={ code:'aaa', workPlanId:'111', applyDate:'2015-05-28',
		 * outageReasonType:1, overhaulType:1, isNeedInside:2,
		 * longTimeOutageReason:2, notTurnpowerReason:[1,2],
		 * notInMonplanReason:'fsdfsdfsdfs',
		 * planPeopleId:'00092CAA1982408DB62F01F4A6C98A27', planPeopleName:'薛武',
		 * planDepartmentId:"F50FF5BBD7E145D99C8FD9E06B33067B",
		 * planDepartmentName:"行政部", outageDeviceTableList:editGridData,
		 * requeryTableList:editGridData2 };
		 */
		objFormVO.put("code", "aaa111");
		objFormVO.put("workPlanId", "111");
		objFormVO.put("applyDate", new Date());
		objFormVO.put("outageReasonType", 1);
		objFormVO.put("overhaulType", 1);
		objFormVO.put("isNeedInside", 2);
		objFormVO.put("longTimeOutageReason", 2);
		objFormVO.put("notTurnpowerReason", new Integer[] { 1, 2 });
		objFormVO.put("notInMonplanReason", "fsdfsdfsdfs");
		objFormVO.put("planPeopleId", "00092CAA1982408DB62F01F4A6C98A27");
		objFormVO.put("planPeopleName", "薛武");
		objFormVO.put("planDepartmentId", "F50FF5BBD7E145D99C8FD9E06B33067B");
		objFormVO.put("planDepartmentName", "行政部");

		/*
		 * var editGridData =[{ "id": "0", "depertment" : "技术研究中心",
		 * "substation": "景田站", "line": "甲线", "device": "变电站" },{ "id": "1",
		 * "depertment" : "技术研究中心", "substation": "景田站", "line": "甲线", "device":
		 * "变电站" }];
		 */

		List lstEditGridVO1 = new ArrayList();

		Map obEditGridVO1 = new HashMap();
		obEditGridVO1.put("id", "0");
		obEditGridVO1.put("depertment", "技术研究中心");
		obEditGridVO1.put("substation", "景田站");
		obEditGridVO1.put("line", "甲线");
		obEditGridVO1.put("device", "变电站");
		lstEditGridVO1.add(obEditGridVO1);

		Map obEditGridVO2 = new HashMap();
		obEditGridVO2.put("id", "1");
		obEditGridVO2.put("depertment", "技术研究中心");
		obEditGridVO2.put("substation", "景田站");
		obEditGridVO2.put("line", "甲线");
		obEditGridVO2.put("device", "变电站");
		lstEditGridVO1.add(obEditGridVO2);

		/*
		 * var editGridData2 =[{ "id": "0", "requery" : "技术研究中心", },{ "id": "1",
		 * "requery" : "技术研究中心", }];
		 */
		List lstEditGridVO2 = new ArrayList();
		Map obEditGridVO3 = new HashMap();
		obEditGridVO3.put("id", "0");
		obEditGridVO3.put("requery", "技术研究中心");
		lstEditGridVO2.add(obEditGridVO3);

		Map obEditGridVO4 = new HashMap();
		obEditGridVO4.put("id", "1");
		obEditGridVO4.put("requery", "技术研究中心");
		lstEditGridVO2.add(obEditGridVO4);

		objFormVO.put("outageDeviceTableList", lstEditGridVO1);
		objFormVO.put("requeryTableList", lstEditGridVO2);
		return objFormVO;
	}

	/**
	 * 通过实体属性ID查询实体属性
	 * @param obj 表单
	 *
	 * @return 实体属性对象
	 */
	@SuppressWarnings("rawtypes")
	@RemoteMethod
	public boolean insertForm(Map obj) {
		System.out.println(obj);
		return true;
	}
}
