/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.meeting.facade;

import org.springframework.stereotype.Service;
import com.comtop.meeting.facade.abs.AbstractUserFacade;
import com.comtop.meeting.model.UserVO;

import com.comtop.soa.annotation.SoaMethod;

/**
 * 用户表扩展实现
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-5-31 CAP超级管理员
 */
@Service(value="userFacade")
public class UserFacade extends AbstractUserFacade<UserVO> {
	//TODO 请在此编写自己的业务代码
	
    /**
     * 测试多参数
     * 
     * @param param1 param1
     * @param param2 param2
     * @return  Object
     * 
     */
    @Override
    @SoaMethod(alias="testTwoParams")     
    public Object testTwoParams(String param1,String param2){
      return null;
    }
    /**
     * 测试
     * 
     * @return  String
     * 
     */
    @Override
    @SoaMethod(alias="testThrid")     
    public String testThrid(){
      return null;
    }
}
