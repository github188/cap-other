/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.budget.facade;

import org.springframework.stereotype.Service;
import com.comtop.budget.facade.abs.AbstractUserFacade;
import com.comtop.budget.model.UserVO;


/**
 * 用户表扩展实现
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-9-13 CAP超级管理员
 */
@Service(value="user2Facade")
public class UserFacade extends AbstractUserFacade<UserVO> {
	//TODO 请在此编写自己的业务代码
	
}
