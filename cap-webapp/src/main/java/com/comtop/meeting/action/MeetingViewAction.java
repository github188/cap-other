/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.meeting.action;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;

import com.comtop.cip.jodd.madvoc.meta.MadvocAction;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.meeting.action.abs.AbstractMeetingViewAction;
import com.comtop.meeting.facade.XcMeetingFacade;
import com.comtop.meeting.model.MeetingViewDTO;
import com.comtop.meeting.model.XcMeetingVO;
import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;

/**
 * 会议看板Action
 * 
 * @author 作者
 * @version jdk1.6
 * @version 2016-1-27 作者
 */
@DwrProxy
@MadvocAction
public class MeetingViewAction extends AbstractMeetingViewAction {

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
	}

	/**
	 * @param date
	 *            开始日期
	 * @param request
	 *            HttpServletRequest
	 * @param response
	 *            HttpServletResponse
	 * @return map
	 */
	@RemoteMethod
	public List<MeetingViewDTO> query(String date, HttpServletRequest request,
			HttpServletResponse response) {

		if (StringUtils.isEmpty(date))
			return new ArrayList<MeetingViewDTO>();

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		try {
			return this.xcMeetingFacade.meetingView(sdf.parse(date));
		} catch (ParseException e) {

			e.printStackTrace();
		}

		return new ArrayList<MeetingViewDTO>();
	}

	/**
	 * 预定会议
	 * 
	 * @param meetingVO
	 *            会议管理vo
	 * @return pk
	 */
	@RemoteMethod
	public String save(XcMeetingVO meetingVO) {

		return xcMeetingFacade.save(meetingVO);
	}

	/**
	 * @param request
	 *            rqt
	 * @param response
	 *            rsp
	 * @return str
	 */
	@RequestMapping(params = "method=initAction")
	public String initAction(HttpServletRequest request,
			HttpServletResponse response) {

		System.out.println("spring ioc");

		return null;
	}
}