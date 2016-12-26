/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.tech.facade;

import org.springframework.stereotype.Service;
import com.comtop.tech.facade.abs.AbstractPaymentFacade;
import com.comtop.tech.model.PaymentVO;


/**
 * 付款单信息扩展实现
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-12-12 CAP超级管理员
 */
@Service(value="paymentFacade")
public class PaymentFacade extends AbstractPaymentFacade<PaymentVO> {
	//TODO 请在此编写自己的业务代码
	
}
