/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.carstorage.facade;

import java.util.List;

import org.springframework.stereotype.Service;

import com.comtop.carstorage.facade.abs.AbstractBizaccountFacade;
import com.comtop.carstorage.model.BizaccountVO;
import com.comtop.carstorage.model.OpinionVO;

/**
 * 费用报销单扩展实现
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-9-12 CAP超级管理员
 */
@Service(value="bizaccountFacade")
public class BizaccountFacade extends AbstractBizaccountFacade<BizaccountVO> {

	/** 
	 *
	 * @param opinion xx
	 * @return xx
	 *		
	 * @see com.comtop.carstorage.facade.abs.AbstractBizaccountFacade#relationAppinion(com.comtop.carstorage.model.OpinionVO)
	 */
	@Override
	public List<OpinionVO> relationAppinion(OpinionVO opinion) {
		// TODO 自动生成方法存根注释，方法实现时请删除此注释
		return null;
	}

	
	//TODO 请在此编写自己的业务代码
	
    
}
