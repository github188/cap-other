/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.meeting.facade;

import java.util.Date;
import java.util.List;

import org.springframework.stereotype.Service;

import com.comtop.cap.runtime.base.model.CapBaseVO;
import com.comtop.meeting.facade.abs.AbstractXcMeetingFacade;
import com.comtop.meeting.model.MeetingViewDTO;
import com.comtop.meeting.model.XcMeetingVO;
import com.comtop.meeting.model.XcPresententryVO;

/**
 * 会议管理扩展实现
 * 
 * @author CAP
 * @since 1.0
 * @version 2016-1-20 CAP
 */
@Service
public class XcMeetingFacade extends AbstractXcMeetingFacade<XcMeetingVO> {

	/**
	 * 会议保存
	 *
	 * @param vo
	 *            vo
	 * @return pk
	 *
	 * @see com.comtop.cap.runtime.base.facade.CapBaseFacade#save(com.comtop.cap.runtime.base.model.CapBaseVO)
	 */
	@Override
	public String save(CapBaseVO vo) {
		XcMeetingVO meetingVO = (XcMeetingVO) vo;
		List<XcPresententryVO> list = meetingVO
				.getRelationPerson_presents_relation();

		String pk = super.save(vo);

		if (list != null) {
			for (XcPresententryVO entry : list) {
				entry.setMeetingid(pk);
				super.save(entry);
			}
		}

		return pk;
	}

	/**
	 * @param date
	 *            开始日期
	 * @return list
	 */
	public List<MeetingViewDTO> meetingView(Date date) {

		return getAppService().meetingView(date);
	}

	/**
	 * 界面加载数据
	 *
	 * @param id
	 *            pk
	 * @return meetingVO
	 *
	 * @see com.comtop.cap.runtime.base.facade.CapBaseFacade#loadById(java.lang.String)
	 */
	@Override
	public CapBaseVO loadById(String id) {
		XcMeetingVO meetingVO = (XcMeetingVO) super.loadById(id);

		List<XcPresententryVO> list = getAppService().queryPresentEntrys(
				meetingVO);

		meetingVO.setRelationPerson_presents_relation(list);

		return meetingVO;
	}

}
