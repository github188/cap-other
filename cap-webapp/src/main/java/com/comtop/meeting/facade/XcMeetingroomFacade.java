/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.meeting.facade;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;

import com.comtop.meeting.facade.abs.AbstractXcMeetingroomFacade;
import com.comtop.meeting.model.XcMeetingroomVO;
import comtop.org.directwebremoting.annotations.RemoteMethod;

/**
 * 会议室扩展实现
 * 
 * @author CAP
 * @since 1.0
 * @version 2016-1-20 CAP
 */
@Service
public class XcMeetingroomFacade extends
		AbstractXcMeetingroomFacade<XcMeetingroomVO> {

	/**
	 *
	 * @return xx
	 *
	 * @see com.comtop.meeting.facade.abs.AbstractXcMeetingroomFacade#test()
	 */
	@Override
	@SuppressWarnings("unchecked")
	@RemoteMethod
	public String test() {
		List<XcMeetingroomVO> voList = new ArrayList<XcMeetingroomVO>();
		XcMeetingroomVO room = new XcMeetingroomVO();
		
		room.setName("许畅测试批量更新");
		room.setFnumber("许畅测试批量更新");
		
		XcMeetingroomVO room2 = new XcMeetingroomVO();
		room2.setRoomid("D8229B76F50343CF932EB9B35B9AE2C1");
		room2.setName("许畅测试批量更新4/1");
		room2.setFnumber("许畅测试批量更新4/1");
		voList.add(room);
		voList.add(room2);
		batchUpdate(voList, new String[] { "name","fnumber" });
		return null;
	}

}
