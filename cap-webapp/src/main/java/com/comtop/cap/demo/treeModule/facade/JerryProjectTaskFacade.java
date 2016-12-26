/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.demo.treeModule.facade;

import org.springframework.stereotype.Service;
import com.comtop.cap.demo.treeModule.facade.abs.AbstractJerryProjectTaskFacade;
import com.comtop.cap.demo.treeModule.model.JerryProjectTaskVO;


/**
 * JerryProjectTask扩展实现
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-6-14 CAP超级管理员
 */
@Service(value="jerryProjectTaskFacade")
public class JerryProjectTaskFacade extends AbstractJerryProjectTaskFacade<JerryProjectTaskVO> {
	//TODO 请在此编写自己的业务代码
	
}
