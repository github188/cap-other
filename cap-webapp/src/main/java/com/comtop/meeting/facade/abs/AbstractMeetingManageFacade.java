/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.meeting.facade.abs;
import com.comtop.cap.runtime.base.facade.BaseFacade;
import com.comtop.meeting.common.exception.MeetingException;


/**
 * 会议管理服务类 业务逻辑处理类 门面
 * 
 * @author CAP
 * @since 1.0
 * @version 2016-1-21 CAP
 */
public abstract class AbstractMeetingManageFacade extends BaseFacade {

    
    /**
     * 会议冲突问题解决
     * 
     * @param param param参数
     * @throws MeetingException MeetingException
     * 
     */
    public void meetingConflict(String param) throws MeetingException{
       
      //Do something....
    }
}