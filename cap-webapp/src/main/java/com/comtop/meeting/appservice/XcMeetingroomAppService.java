/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.meeting.appservice;

import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.meeting.model.XcMeetingroomVO;
import com.comtop.meeting.appservice.abs.AbstractXcMeetingroomAppService;


/**
 * 会议室服务扩展类
 * 
 * @author CAP
 * @since 1.0
 * @version 2016-1-20 CAP
 * @param <T> 类泛型
 */
@PetiteBean
public class XcMeetingroomAppService<T extends XcMeetingroomVO> extends AbstractXcMeetingroomAppService<XcMeetingroomVO> {
	//TODO 请在此编写自己的业务代码
}
