/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.meeting.appservice;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.meeting.appservice.abs.AbstractXcMeetingAppService;
import com.comtop.meeting.common.util.MeetingConstants;
import com.comtop.meeting.common.util.MeetingUtil;
import com.comtop.meeting.model.MeetingManageViewVO;
import com.comtop.meeting.model.MeetingViewDTO;
import com.comtop.meeting.model.XcMeetingVO;
import com.comtop.meeting.model.XcMeetingroomVO;

/**
 * 会议管理服务扩展类
 * 
 * @author CAP
 * @since 1.0
 * @version 2016-1-20 CAP
 * @param <T>
 *            类泛型
 */
@PetiteBean
public class XcMeetingAppService<T extends XcMeetingVO> extends
		AbstractXcMeetingAppService<XcMeetingVO> {

	/**
	 * 查询出分录出席者集合
	 * 
	 * @param xcMeetingVO
	 *            xcMeetingVO
	 * @return list
	 */
	@SuppressWarnings("unchecked")
	public List<T> queryPresentEntrys(T xcMeetingVO) {

		String statementId = MeetingConstants.QUERY_PRESENTS_STATEMENTID_CONSTANT;
		return capBaseCommonDAO.queryList(statementId, xcMeetingVO);
	}

	/**
	 * 查询出会议看板的数据
	 * 
	 * @param date
	 *            开始日期
	 * @return list
	 */
	public List<MeetingViewDTO> meetingView(Date date) {
		// 查询出当前的所有会议室
		XcMeetingroomVO roomVO = new XcMeetingroomVO();
		String roomStatementId = MeetingConstants.QUERY_MEETINGROOMS_STATEMENTID_CONSTANT;
		@SuppressWarnings("unchecked")
		List<XcMeetingroomVO> rooms = capBaseCommonDAO.queryList(
				roomStatementId, roomVO);

		// 会议看板数据源
		List<MeetingViewDTO> list = new ArrayList<MeetingViewDTO>();
		for (XcMeetingroomVO room : rooms) {

			Map<String, String> map = new HashMap<String, String>();
			map.put("roomId", room.getRoomid());
			map.put("roomName", room.getName());
			int timeCount = 23;// 至22点则无会议室
			for (int i = 9; i < timeCount; i++) {
				MeetingManageViewVO vo = new MeetingManageViewVO();
				vo.setStartDate(MeetingUtil.toTimestampByHour(date, i));
				vo.setEndDate(MeetingUtil.toTimestampByHour(date, i + 1));
				vo.setRoomId(room.getRoomid());
				@SuppressWarnings("unchecked")
				List<MeetingManageViewVO> ls = capBaseCommonDAO.queryList(
						MeetingConstants.MEETINGVIEW_STATEMENTID_CONSTANT, vo);
				if (ls.size() > 0) {
					// 有人使用会议室
					String key = "time" + i;
					map.put(key, ls.get(0).getApplierName());
				} else {
					// 空闲会议室
					String key = "time" + i;
					map.put(key, "闲置");
				}
			}

			MeetingViewDTO view = new MeetingViewDTO();
			try {
				view = (MeetingViewDTO) MeetingUtil.mapConvertToBean(
						MeetingViewDTO.class, map);
			} catch (Exception e) {
				e.printStackTrace();
			}

			list.add(view);
		}

		return list;
	}
}
