/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.meeting.action;

import com.comtop.cap.runtime.base.model.SoaInvokeParam;
import com.comtop.cip.jodd.madvoc.meta.MadvocAction;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.meeting.action.abs.AbstractMeetingRoomListAction;
import com.comtop.meeting.facade.XcMeetingroomFacade;
import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;

/**
 * 会议室列表界面Action
 * 
 * @author 作者
 * @version jdk1.6
 * @version 2016-1-25 作者
 */
@DwrProxy
@MadvocAction
public class MeetingRoomListAction extends AbstractMeetingRoomListAction {

	/**
	 * 初始化页面参数
	 */
	@Override
	public void initBussinessAttr() {
		// 添加页面初始化时候输出参数值
	}

	/**
	 * 会议室管理facade
	 */
	@PetiteInject
	protected XcMeetingroomFacade xcMeetingroomFacade;

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

		return super.dwrInvoke(invokeParam);
	}
}