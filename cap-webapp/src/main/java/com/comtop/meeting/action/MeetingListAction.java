/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.meeting.action;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.comtop.cap.runtime.base.model.SoaInvokeParam;
import com.comtop.cip.jodd.madvoc.meta.MadvocAction;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.meeting.action.abs.AbstractMeetingListAction;
import com.comtop.meeting.facade.XcMeetingFacade;
import com.comtop.meeting.model.XcMeetingVO;
import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;

/**
 * 会议管理列表界面Action
 * 
 * @author 作者
 * @version jdk1.6
 * @version 2016-1-20 作者
 */
@DwrProxy
@MadvocAction
public class MeetingListAction extends AbstractMeetingListAction {

	/**
	 * 会议管理facade
	 */
	@PetiteInject
	protected XcMeetingFacade xcMeetingFacade;

	/**
	 * 初始化页面参数
	 */
	@Override
	public void initBussinessAttr() {
		// 添加页面初始化时候输出参数值

		System.out.println("初始化会议管理页面...");
	}

	/**
	 * 初始化列表数据
	 * 
	 * @param meetingVO
	 *            会议管理vo
	 * 
	 * @return map
	 */
	@RemoteMethod
	public Map getListData(XcMeetingVO meetingVO) {
		Map<String, Object> map = new HashMap<String, Object>();
		int count = xcMeetingFacade.queryVOCount(meetingVO);
		List<XcMeetingVO> data = xcMeetingFacade.queryVOList(meetingVO);
		map.put("count", count);
		map.put("data", data);
		return map;
	}

	/**
	 * 描 述：覆盖父类方法
	 *
	 * @param invokeParam
	 *            param
	 * @return obj
	 *
	 * @see com.comtop.cap.runtime.base.action.BaseAction#dwrInvoke(com.comtop.cap.runtime.base.model.SoaInvokeParam)
	 */
	@Override
	@RemoteMethod
	public Object dwrInvoke(SoaInvokeParam invokeParam) {
		Map<String, Object> map = new HashMap<String, Object>();
		int count = xcMeetingFacade.queryVOCount(new XcMeetingVO());

		map.put("list", super.dwrInvoke(invokeParam));
		map.put("count", count);
		return map;
	}
}